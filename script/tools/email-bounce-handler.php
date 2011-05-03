#!/usr/bin/env php
<?php
/*
 * Designed to Receive Bounces from Postfix.
 * Add the following lines to postfix's main.cf
 * virtual_alias_domains = [DOMAIN_THAT_EMAILS_ARE_COMING_FROM]
 * virtual_alias_maps = hash:/etc/postfix/[MAP_FILE_NAME]
 *
 * The add to the above map file
 * [EMAIL_ADDRESS] [LOCAL-ALIAS]
 *
 * Then create the hash file (for postfix)
 * postmap /etc/postfix/[MAP_FILE_NAME]
 *
 * Then add a local alias (usually /etc/aliases)
 * [LOCAL-ALIAS]:  |[PATH_TO_THIS_SCRIPT]
 *
 * Then enable the alias
 * newaliases
 *
 * Make sure the 'Key' below matches the EMAIL_BOUNCEHANDLER_KEY in silverstripe
 * and that the silverstripe domain name is resolvable locally.
 */

$get['Key'] = '453616c60bfc87e41c146d3b90b85b9a';

/*
 * Parse the Bounced Email from stdin
 */
$email = file('php://stdin');
/**
 * Technically we should be parsing the email. the mime-decoding the
 * attachment that is the bounced email, and grabbing the headers from
 * that. But we are relying on the Silverstripe headers NOT being
 * present in the NDR.
/*
 * Parse the headers
 */
$headers = array();
foreach($email as $line) {
	if ($colon = strpos($line, ':')) {
		$header_name = trim(substr($line, 0, $colon));
		$header_value = trim(substr($line, $colon+1));
		$headers[$header_name] = $header_value;
	}
}

if (!isset($headers['X-SilverStripeBounceURL'])) {
	print('Missing Silverstripe Headers');
	exit(1);
}

$url = 'http://'.$headers['X-SilverStripeBounceURL'];


$get['Email'] = $headers['To'];

$now = new DateTime('now');
$get['Date'] = $now->format('d-m-Y');
$get['Time'] = $now->format('H:i:s');
/*
 * This specifically should be parsed from the message
 */
$get['Message'] = 'Received Bounce in Email system.';

$url = $url.'?'.http_build_query($get);
$response = file_get_contents($url);
if ($response === false) {
	print("Could not access URL: ".$url);
	exit(2);
}
/*
 * the Controller still returns 200 even if something is wrong
 * So we cannot check the heade response
 * var_dump($http_response_header);
 */
if (strpos($response, 'Error') !== false) {
	print($response);
	exit(3);
}
