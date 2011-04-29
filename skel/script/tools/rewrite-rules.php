<?php
/*
 * You can use ./script/rebuild-cache.sh to easily get a list of URLs in the site.
 */
$rewrites = array(
	'/abdominoplasty.html' => '/our-services/surgical/abdominoplasty-tummy-tuck/',
	'/anti_wrinkle_treatment.html' => 'our-services/non-surgical/anti-wrinkle-treatment/',
	'/appoint.html' => '/',
	'/beauty_therapy.html' => '/',
	'/breast_augmentation.html' => '/our-services/surgical/breast-augmentation/',
	'/breast_augmentation_gallery.html' => '/our-services/surgical/breast-augmentation/',
	'/breast_augmentation_gallery1.html' => '/our-services/surgical/breast-augmentation/',
	'/breast_augmentation_gallery2.html' => '/our-services/surgical/breast-augmentation/',
	'/breast_reduction.html' => '/our-services/surgical/breast-reduction/',
	'/browlift.html' => '/our-services/surgical/foreheadplasty-brow-lift/',
	'/confirm_appoint.php' => '/',
	'/confirm_appoint_no.php' => '/',
	'/confirm_general_thanks.php' => '/',
	'/contact_us.html' => '/contact-us/contact-us/',
	'/country_interstate_patients.html' => '/patient-information/interstate-patients/',
	'/crystal_peel_microdermabrasion.html' => '/our-services/medi-spa/crystal-microdermabration/',
	'/dermal_fillers.html' => '/our-services/non-surgical/dermal-fillers/',
	'/disclaimer.html' => '/disclaimer',
	'/elos_hair_removal.html' => '/our-services/medi-spa/laser-hair-removal/',
	'/elos_skin_rejuvenation.html' => '/our-services/medi-spa/elos-skin-rejuvenation/',
	'/endermologie.html' => '/',
	'/eyelid_lift.html' => '/our-services/surgical/blepharoplasty-eyelid-surgery/',
	'/facelift.html' => '/our-services/surgical/meloplasty-face-lift/',
	'/faq.html' => '/patient-information/faq/',
	'/index.html' => '/',
	'/index2.html' => '/',
	'/links.html' => '/patient-information/useful-links/',
	'/liposuction.html' => '/our-services/surgical/liposuction/',
	'/liposuction_gallery.html' => '/our-services/surgical/liposuction/',
	'/liposuction_gallery1.html' => '/our-services/surgical/liposuction/',
	'/liposuction_gallery2.html' => '/our-services/surgical/liposuction/',
	'/location.html' => '/contact-us/contact-us/',
	'/mailerappoint.php' => '/',
	'/mailercontact.php' => '/',
	'/mailerquestion.php' => '/',
	'/medical_microcurrent.html' => '/our-services/medi-spa/medical-micro-current/',
	'/medical_spa_services.html' => '/our-services/medi-spa/',
	'/micro_fat_transfer.html' => '/our-services/non-surgical/micro-fat-transfer/',
	'/multilase.html' => '/our-services/medi-spa/low-intensity-laser-therapy/',
	'/necklift.html' => '/our-services/surgical/necklift/',
	'/non_surgical_procedures.html' => '/our-services/non-surgical/',
	'/online_appoint.html' => '/contact-us/contact-us/',
	'/our_facility.html' => '/contact-us/contact-us/',
	'/our_surgeon.html' => '/about-us/our-surgeon/',
	'/our_team.html' => '/about-us/our-team/',
	'/payment_plan.html' => '/patient-information/payment-plan-options/',
	'/pci_micro_needling.html' => '/our-services/non-surgical/pci-micro-needling/',
	'/photo_gallery.html' => '/',
	'/privacy.html' => '/privacy/',
	'/products.html' => '/',
	'/question.html' => '/patient-information/faq/',
	'/recent_articles.html' => '/',
	'/rhinoplasty.html' => '/our-services/surgical/rhinoplasty-nose-reshaping/',
	'/services.html' => '/our-services/surgical/',
	'/sitemap.html' => '/site-map',
	'/superficial_skin_peels.html' => '/our-services/medi-spa/superficial-skin-peels/',
	'/surgical_procedures.html' => '/our-services/surgical/',
	'/thanks.php' => '/'
);
foreach( $rewrites as $source => $destination ) {
	echo <<<EOB
	RewriteCond %{REQUEST_URI} $source
	RewriteRule . $destination [R=301,L]

EOB;
}
?>