# Argon Next theme packaging script.
# Usage:
#   powershell -ExecutionPolicy Bypass -File .\pack.ps1
#   powershell -ExecutionPolicy Bypass -File .\pack.ps1 -Output C:\path\argon-next.zip

[CmdletBinding()]
param(
    [string]$Source = $PSScriptRoot,
    [string]$Output = "",
    [string]$PackageName = "argon-next"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($Source)) {
    $Source = (Get-Location).Path
}

if ($PackageName -match '[\\/:*?"<>|]') {
    throw "PackageName contains invalid path characters: $PackageName"
}

$sourcePath = [System.IO.Path]::GetFullPath($Source)
if (-not (Test-Path -LiteralPath $sourcePath -PathType Container)) {
    throw "Source directory does not exist: $sourcePath"
}

if ([string]::IsNullOrWhiteSpace($Output)) {
    $desktop = [Environment]::GetFolderPath("Desktop")
    if ([string]::IsNullOrWhiteSpace($desktop)) {
        $desktop = Split-Path -Parent $sourcePath
    }
    $Output = Join-Path $desktop "$PackageName.zip"
}

$destPath = [System.IO.Path]::GetFullPath($Output)
$destDir = Split-Path -Parent $destPath
if (-not (Test-Path -LiteralPath $destDir -PathType Container)) {
    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
}

$scriptPath = if ($PSCommandPath) { [System.IO.Path]::GetFullPath($PSCommandPath) } else { "" }
$sourceRoot = $sourcePath.TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar

$excludeNames = @(
    ".git",
    ".github",
    ".gitattributes",
    ".gitignore",
    ".editorconfig",
    ".eslintignore",
    ".eslintrc.json",
    ".idea",
    ".vscode",
    "node_modules",
    "package.json",
    "package-lock.json",
    "pnpm-lock.yaml",
    "yarn.lock",
    "composer.lock",
    "pack.ps1"
)

$excludeFileNames = @(
    ".DS_Store",
    "Thumbs.db"
)

$excludeExtensions = @(
    ".log",
    ".zip"
)

function Test-ArgonPackExcluded {
    param(
        [System.IO.FileInfo]$File
    )

    $fullPath = [System.IO.Path]::GetFullPath($File.FullName)
    if ($fullPath -eq $destPath -or ($scriptPath -ne "" -and $fullPath -eq $scriptPath)) {
        return $true
    }

    if ($excludeFileNames -contains $File.Name) {
        return $true
    }

    if ($excludeExtensions -contains $File.Extension.ToLowerInvariant()) {
        return $true
    }

    $relativePath = $fullPath.Substring($sourceRoot.Length)
    $segments = $relativePath -split '[\\/]'
    foreach ($segment in $segments) {
        if ($excludeNames -contains $segment) {
            return $true
        }
    }

    return $false
}

Write-Output "Source:  $sourcePath"
Write-Output "Output:  $destPath"
Write-Output "Package: $PackageName"

if (Test-Path -LiteralPath $destPath -PathType Leaf) {
    Remove-Item -LiteralPath $destPath -Force
}

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$archive = [System.IO.Compression.ZipFile]::Open($destPath, [System.IO.Compression.ZipArchiveMode]::Create)
$count = 0

try {
    Get-ChildItem -LiteralPath $sourcePath -Recurse -File | Sort-Object FullName | ForEach-Object {
        if (Test-ArgonPackExcluded -File $_) {
            return
        }

        $fullPath = [System.IO.Path]::GetFullPath($_.FullName)
        $relativePath = $fullPath.Substring($sourceRoot.Length).Replace('\', '/')
        $entryName = "$PackageName/$relativePath"
        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
            $archive,
            $fullPath,
            $entryName,
            [System.IO.Compression.CompressionLevel]::Optimal
        ) | Out-Null
        $count++
    }
}
finally {
    $archive.Dispose()
}

$destItem = Get-Item -LiteralPath $destPath
$sizeKb = [math]::Round($destItem.Length / 1KB, 0)
$hash = (Get-FileHash -LiteralPath $destPath -Algorithm SHA256).Hash

Write-Output "Done:    $count files, $sizeKb KB"
Write-Output "SHA256:  $hash"
