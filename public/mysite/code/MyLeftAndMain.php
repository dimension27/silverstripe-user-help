<?php
class MyLeftAndMain extends Extension {

	function init() {
		Requirements::css(project().'/css/admin.css');
		Requirements::javascript(project().'/js/admin.js');
		if( class_exists('Subsite') ) {
			HtmlEditorConfig::get('cms')->setOption(
				'content_css',
				'themes/'.Subsite::currentSubsite()->Theme.'/css/editor.css'
			);
		}
	}

}
?>