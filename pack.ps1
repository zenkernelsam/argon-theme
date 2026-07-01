# ============================================================
# Argon Next 主题打包脚本
# 用法: powershell -ExecutionPolicy Bypass -File "c:\...\argon-theme\pack.ps1"
# 输出: c:\Users\Cisco He\Desktop\argon-next.zip
# ============================================================

$source = 'c:\Users\Cisco He\Desktop\Git\argon-theme'
$dest = 'c:\Users\Cisco He\Desktop\argon-next.zip'

Write-Output "Source: $source"
Write-Output "Dest:   $dest"

Remove-Item $dest -Force -ErrorAction SilentlyContinue
Add-Type -AssemblyName System.IO.Compression.FileSystem
$archive = [System.IO.Compression.ZipFile]::Open($dest, 'Create')

$excludeNames = @(
    '.git', '.github', '.gitattributes', '.gitignore',
    '.eslintrc.json', '.eslintignore', '.editorconfig',
    'package.json', 'package-lock.json', 'node_modules',
    'pack.ps1', 'pack.zip'
)

$sourceLen = $source.Length + 1
$count = 0
$scriptPath = $MyInvocation.MyCommand.Path

Get-ChildItem -Path $source -Recurse -File | ForEach-Object {
    $full = $_.FullName
    if ($full -eq $scriptPath) { return }
    $name = $_.Name
    foreach ($e in $excludeNames) {
        if ($name -eq $e) { return }
        if ($full -like "*\$e\*" -or $full -like "*\$e") { return }
    }
    $entry = 'argon-next/' + $full.Substring($sourceLen).Replace('\', '/')
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $full, $entry)
    $count++
}

$archive.Dispose()
$size = [math]::Round((Get-Item $dest).Length / 1KB, 0)
Write-Output "Done: $count files, $size KB"
Write-Output "Output: $dest"
