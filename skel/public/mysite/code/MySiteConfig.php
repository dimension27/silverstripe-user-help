<?php
 
class MySiteConfig extends DataObjectDecorator {
 
	function extraStatics() {
		return array(
			'db' => array(
				'SideBarContent' => 'HTMLText',
				'BackgroundImagePosition' => 'Varchar(100)',
				'BackgroundColor' => 'Varchar(100)'
			),
			'has_one' => array(
				'BackgroundImage' => 'Image'
			)
		);
	}
 
	public function updateCMSFields(FieldSet $fields) {
		$fields->addFieldToTab("Root.Main", new HTMLEditorField("SideBarContent", "Side-Bar Content"));
		$fields->addFieldToTab("Root.Main", new ImageField("BackgroundImage", "Background Image"));
		$positionOptions = array(
				'top left no-repeat' => 'Left',
				'top center no-repeat' => 'Center',
				'top right no-repeat' => 'Right',
				'repeat-x' => 'Repeat X',
				'repeat-y' => 'Repeat Y',
				'repeat' => 'Repeat Both'
		);
		$fields->addFieldToTab("Root.Main", new DropdownField('BackgroundImagePosition', 'Position', $positionOptions));
		$fields->addFieldToTab("Root.Main", new TextField('BackgroundColor', 'Background Color'));
	}

}
