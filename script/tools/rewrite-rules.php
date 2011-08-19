<?php
/*
 * You can use ./script/rebuild-cache.sh to easily get a list of URLs in the site.
 */
$rewrites = array(
	'/' => '/',
	'/business/' => '/m-a-d-business/',
	'/business/motivational-speaking' => '/',
	'/business/services' => '/m-a-d-business/',
	'/business/team-building-events' => '/m-a-d-business/',
	'/business/testimonials' => '/',
	'/business/whos-mad' => '/whos-m-a-d/',
	'/contact/' => '/contact/',
	'/contact/thanks' => '/',
	'/events/' => '/events/',
	'/events/attendees' => '/',
	'/events/details' => '/',
	'/events/past-events' => '/',
	'/events/payment' => '/',
	'/events/thank-you' => '/',
	'/events/upcoming' => '/events/',
	'/geoffer' => '/',
	'/goodbye' => '/',
	'/mad-magnets' => 'http://www.shopmadwoman.mybigcommerce.com/m-a-d-magnet/',
	'/mad-store' => 'http://shopmadwoman.mybigcommerce.com/',
	'/mail/' => '/contact/',
	'/mail/contact' => '/contact/',
	'/mentions/' => '/in-the-news/',
	'/mentions/awards' => '/whos-m-a-d/',
	'/mentions/single-volunteers-goes-national' => '/',
	'/mentions/testimonials' => '/',
	'/missions/' => '/',
	'/missions/how-you-can-be-mad' => '/',
	'/missions/mobile' => '/',
	'/missions/projects-in-need' => '/',
	'/missions/random-acts' => '2010/08/random-acts-of-m-a-d/',
	'/page-not-found' => '/page-not-found',
	'/proud/' => '/',
	'/proud/celebrities' => '/',
	'/proud/helpers' => '/',
	'/proud/partners' => '/',
	'/proud/profiles' => '/',
	'/proud/sports' => '/',
	'/proud/supporters' => '/',
	'/reiv-offer' => '/',
	'/same-sex-single-volunteer-events' => '/',
	'/shop/' => 'http://shopmadwoman.mybigcommerce.com/',
	'/sign-up' => '/subscribe/',
	'/thanks' => '/',
	'/thanks-for-your-help' => '/',
	'/things/' => '/',
	'/things/books/' => 'http://www.shopmadwoman.mybigcommerce.com/m-a-d-books/',
	'/things/critters/' => 'http://www.shopmadwoman.mybigcommerce.com/paper-m-a-d/',
	'/things/critters/bug-your-room' => 'http://www.shopmadwoman.mybigcommerce.com/bug-your-room/',
	'/things/critters/buzzzzz-over-here' => 'http://www.shopmadwoman.mybigcommerce.com/paper-m-a-d/',
	'/things/critters/complete-critter-collection-pack' => 'http://www.shopmadwoman.mybigcommerce.com/paper-m-a-d/',
	'/things/critters/da-frog' => 'http://www.shopmadwoman.mybigcommerce.com/play-leap-da-frog/',
	'/things/critters/enjoy-a-flutter' => 'http://www.shopmadwoman.mybigcommerce.com/paper-m-a-d/',
	'/things/critters/jumping-da-frog' => 'http://www.shopmadwoman.mybigcommerce.com/can-you-catch-da-jumping-frog/',
	'/things/critters/lil-critter-clan-pack' => 'http://www.shopmadwoman.mybigcommerce.com/lil-critter-clan-pack/',
	'/things/critters/schnail-trail' => 'http://www.shopmadwoman.mybigcommerce.com/paper-m-a-d/',
	'/things/memorabilia' => '/',
	'/things/merchandise' => '/',
	'/unsubscribe' => '/',
);
foreach( $rewrites as $source => $destination ) {
	echo <<<EOB
	RewriteCond %{REQUEST_URI} $source
	RewriteRule . $destination [R=301,L]

EOB;
}
?>