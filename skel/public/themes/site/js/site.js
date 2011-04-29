/*
 * Cufon example:
/**
 * Provides a workaround for the flash of unstyled text before Cufon loads
 * Requires the following in the <head>:
 * 
 * <script type="text/javascript">document.getElementsByTagName('HTML')[0].className = 'js-enabled';</script>
 * 
 * The following is an example of the accompanying CSS:
 * 
 * .js-enabled h1,
 * .js-enabled [other Cufon selectors...] {
 *   visibility: hidden;
 * }
 * .js-enabled .ready h1,
 * .js-enabled .ready [other Cufon selectors...] {
 *   visibility: visible;
 * }
 * /
var handleCufonLoad = function() {
	var $body = $(document.body);
	$(function() {
		$body.addClass('ready');
	});
	$(window).load(function() {
		$body.addClass('loaded');
	});
}();
Cufon.replace('.introText', { fontFamily: 'Swis721 Th BT' });
Cufon.replace('h1', { fontFamily: 'Swis721 LtCn BT' });
 */