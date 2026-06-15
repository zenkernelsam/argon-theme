					<footer id="footer" class="site-footer card shadow-sm border-0">
						<?php
							echo argon_get_option('argon_footer_html');
						?>
						<div><?php $footer_mode = argon_get_option('argon_hide_footer_author'); if ($footer_mode == 'next') { ?>Theme <a href="https://github.com/solstice23/argon-theme" target="_blank"><strong>Argon</strong></a> <a href="https://github.com/zenkernelsam/argon-theme" target="_blank"><strong>Next</strong></a><?php } else { ?>Theme <a href="https://github.com/solstice23/argon-theme" target="_blank"><strong>Argon</strong></a><?php if ($footer_mode != 'true') {echo " By solstice23"; } ?><?php } ?></div>
					</footer>
				</main>
			</div>
		</div>
		<?php // [Argon Next] argontheme.js 已改为通过 wp_enqueue_script 在 functions.php 中管理加载 ?>
		<?php if (argon_get_option('argon_math_render') == 'mathjax3') { /*Mathjax V3*/?>
			<script>
				window.MathJax = {
					tex: {
						inlineMath: [["$", "$"], ["\\\\(", "\\\\)"]],
						displayMath: [['$$','$$']],
						processEscapes: true,
						packages: {'[+]': ['noerrors']}
					},
					options: {
						skipHtmlTags: ['script', 'noscript', 'style', 'textarea', 'pre', 'code'],
						ignoreHtmlClass: 'tex2jax_ignore',
						processHtmlClass: 'tex2jax_process'
					},
					loader: {
						load: ['[tex]/noerrors']
					}
				};
			</script>
			<script src="<?php echo argon_get_option('argon_mathjax_cdn_url') == '' ? '//cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml-full.js' : argon_get_option('argon_mathjax_cdn_url'); ?>" id="MathJax-script" async></script>
		<?php }?>
		<?php if (argon_get_option('argon_math_render') == 'mathjax2') { /*Mathjax V2*/?>
			<script type="text/x-mathjax-config" id="mathjax_v2_script">
				MathJax.Hub.Config({
					messageStyle: "none",
					tex2jax: {
						inlineMath: [["$", "$"], ["\\\\(", "\\\\)"]],
						displayMath: [['$$','$$']],
						processEscapes: true,
						skipTags: ['script', 'noscript', 'style', 'textarea', 'pre', 'code']
					},
					menuSettings: {
						zoom: "Hover",
						zscale: "200%"
					},
					"HTML-CSS": {
						showMathMenu: "false"
					}
				});
			</script>
			<script src="<?php echo argon_get_option('argon_mathjax_v2_cdn_url') == '' ? '//cdn.jsdelivr.net/npm/mathjax@2.7.5/MathJax.js?config=TeX-AMS_HTML' : argon_get_option('argon_mathjax_v2_cdn_url'); ?>"></script>
		<?php }?>
		<?php if (argon_get_option('argon_math_render') == 'katex') { /*Katex*/?>
			<link rel="stylesheet" href="<?php echo argon_get_option('argon_katex_cdn_url') == '' ? '//cdn.jsdelivr.net/npm/katex@0.11.1/dist/' : argon_get_option('argon_katex_cdn_url'); ?>katex.min.css">
			<script src="<?php echo argon_get_option('argon_katex_cdn_url') == '' ? '//cdn.jsdelivr.net/npm/katex@0.11.1/dist/' : argon_get_option('argon_katex_cdn_url'); ?>katex.min.js"></script>
			<script src="<?php echo argon_get_option('argon_katex_cdn_url') == '' ? '//cdn.jsdelivr.net/npm/katex@0.11.1/dist/' : argon_get_option('argon_katex_cdn_url'); ?>contrib/auto-render.min.js"></script>
			<script>
				document.addEventListener("DOMContentLoaded", function() {
					renderMathInElement(document.body,{
						delimiters: [
							{left: "$$", right: "$$", display: true},
							{left: "$", right: "$", display: false},
							{left: "\\(", right: "\\)", display: false}
						]
					});
				});
			</script>
		<?php }?>

		<?php if (argon_get_option('argon_enable_code_highlight') == 'true') { /*Highlight.js*/?>
			<link rel="stylesheet" href="<?php echo $GLOBALS['assets_path']; ?>/assets/vendor/highlight/styles/<?php echo argon_get_option('argon_code_theme') == '' ? 'vs2015' : argon_get_option('argon_code_theme'); ?>.css">
		<?php }?>

	</div>
</div>
<?php 
// [Argon Next] 移除重复加载，argon.min.js 已在 header 中通过 footer 加载注册
?>
<?php wp_footer(); ?>
</body>

<?php echo argon_get_option('argon_custom_html_foot'); ?>

</html>
