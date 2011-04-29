<?php
class MySiteTree extends SiteTree {

	/**
	 * Return a list of all the pages to be cached.
	 * @return array
	 */
	function allPagesToCache() {
		// Get each page type to define its sub-urls
		$urls = array();
		if( class_exists('Subsite') ) {
			$pages = Subsite::get_from_all_subsites('SiteTree', $filter);
		}
		else {
			$pages = DataObject::get('SiteTree', $filter);
		}
		foreach( $pages as $page ) {
			$urls = array_merge($urls, $page->pagesAffectedByChanges());
		}
		// add any custom URLs which are not SiteTree instances
		$urls[] = Director::absoluteBaseURL().'sitemap.xml';
		return $urls;
	}

	/**
	 * Get a list of pages that need to be updated in the cache when this page is published.
	 * @return array
	 */
	function pagesAffectedByChanges() {
		// Defines any pages which should not be cached
		$excluded = array();
		$urls = array();
		if( $this->canView() ) {
			$urls[] = $this->Link();
		}
		$urls = array_merge($urls, $this->subPagesToCache());
		$rv = array();
		foreach( $urls as $url ) {
			if( !in_array($url, $excluded) ) {
				$rv[] = $url;
			}
		}
		if( $p = $this->Parent ) {
			$urls = array_merge((array) $urls, (array) $p->subPagesToCache());
		}
		return $urls;
	}

	/**
	 * Get a list of sub-pages to be cached with this page.
	 * @return array
	 */
	function subPagesToCache() {
		$urls = array();
		// only cache the RSS feed if anyone can view this page
		if( $this->ProvideComments && $this->canView() ) {
			$urls[] = Director::absoluteBaseURL().'pagecomment/rss/'.$this->ID;
		}
		return $urls;
	}

}

class Page extends MySiteTree {

	public static $db = array(
	);

	public static $has_one = array(
		 'Banner' => 'Image'
	);
	
	/**
	 * @see SiteTree::getCMSFields()
	 * @return FieldSet The fields to be displayed in the CMS.
	 */
	function getCMSFields() {
		$fields = parent::getCMSFields();
		$fields->addFieldToTab("Root.Content.Images", new ImageField('Banner'));
		return $fields;
	}

}

class MyContentController extends ContentController {}

class Page_Controller extends MyContentController {

	/**
	 * An array of actions that can be accessed via a request. Each array element should be an action name, and the
	 * permissions or conditions required to allow the user to access it.
	 *
	 * <code>
	 * array (
	 *		 'action', // anyone can access this action
	 *		 'action' => true, // same as above
	 *		 'action' => 'ADMIN', // you must have ADMIN permissions to access this action
	 *		 'action' => '->checkAction' // you can only access this action if $this->checkAction() returns true
	 * );
	 * </code>
	 *
	 * @var array
	 */
	public static $allowed_actions = array (
	);

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
				"sapphire/thirdparty/jquery/jquery.js",
				// "themes/site/js/browser.js",
				// "themes/site/js/cufon.js",
				// "themes/site/js/amasis.font.js",
				"themes/site/js/site.js"
		);
	}

	function getCombinedCSSFiles() {
		return array(
				'themes/site/css/standard.css',
				'themes/site/css/form.css',
				'themes/site/css/site.css',
				'themes/site/css/site-style.css'
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

}

?>