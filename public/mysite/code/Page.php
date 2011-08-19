<?php

class Page extends SiteTree {

	public static $db = array(
	);

	public static $has_one = array(
	);
	
	/**
	 * @see SiteTree::getCMSFields()
	 * @return FieldSet The fields to be displayed in the CMS.
	 */
	function getCMSFields() {
		return parent::getCMSFields();
	}

}

class Page_Controller extends ContentController {

	function init() {
		parent::init();
		$scripts = $this->getCombinedJsFiles();
		foreach( $scripts as $script ) {
			Requirements::javascript($script);
		}
		Requirements::combine_files('combined.js', $scripts);
		$stylesheets = $this->getCombinedCSSFiles();
		foreach( $stylesheets as $stylesheet ) {
			Requirements::css($stylesheet);
		}
		Requirements::combine_files('combined.css', $stylesheets);
		Requirements::set_combined_files_folder('themes/'.SSViewer::current_theme().'/_combined');
		Requirements::process_combined_files();
		
		// Enable Firebug Lite for debugging
		//* debug */ Requirements::javascript('https://getfirebug.com/firebug-lite-beta.js');
		//* debug */ $this->HTMLAttributes = ' debug="true"';
	}

	function getCombinedJsFiles() {
		return array(
				THIRDPARTY_DIR.'/jquery/jquery-packed.js', // using jquery-packed.js to avoid duplicate jquery from modules
				// 'themes/site/js/browser.js',
				// 'themes/site/js/cufon.js',
				// 'themes/site/js/amasis.font.js',
				'themes/site/js/site.js'
		);
	}

	function getCombinedCSSFiles() {
		return array(
				'themes/site/css/standard.css',
				'themes/site/css/theme.css',
				'themes/site/css/theme-style.css'
		);
	}

	public function Banner( $dataObject = null ) {
		$rv = false;
		if( !$dataObject ) {
			$dataObject = $this->data();
		}
		if( ($image = $dataObject->Banner()) && is_file($image->getFullPath()) ) {
			$rv = $image;
		}
		if( !$rv && $dataObject->Parent ) {
			$rv = $this->Banner($dataObject->Parent);
		}
		return $rv;
	}

	public function IsLiveEnvironment() {
		return Director::isLive();
	}

	public function PageTitle( $suffix = '', $separator = ' | ' ) {
		if( !$suffix ) {
			$suffix = SiteConfig::current_site_config()->Title;
		}
		if( $page = $this->data() ) {
			$rv = trim($page->getField('Title'));
		}
		else {
			$rv = '';
		}
		if( $suffix ) {
			if( $rv == 'Home' ) {
				$rv = '';
			}
			if( $rv ) {
				$rv .= $separator.$suffix;
			}
			else {
				$rv = $suffix;
			}
		}
		return $rv;
	}

	/**
	 * Returns true if the current browser has had an Admin user login in the last 90 days.
	 */
	function PastAdmin() {
		if( Permission::check('ADMIN') ) {
			Cookie::set('PastAdmin', true);
			return true;
		}
		else if( isset($_COOKIE['PastAdmin']) ) {
			return $_COOKIE['PastAdmin'];
		}
	}

}

?>