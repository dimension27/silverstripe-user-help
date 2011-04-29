#!/usr/bin/env php
<?php
/**
 * This is an unfinished script that was designed to handle bounce emails, but demonstrates
 * how to get a Sapphire up without using sake. 
 */

/*
 * Load up Silverstripe, and call the controller
 * Change to Sapphire, so all includes work
 */
$_SERVER['SCRIPT_FILENAME'] = __FILE__;
chdir(dirname(dirname($_SERVER['SCRIPT_FILENAME'])).'/public/sapphire');

/*
 * Include Sapphire's core code
 */
require_once("core/Core.php");
global $databaseConfig;

// We don't have a session in cli-script, but this prevents errors
$_SESSION = null;

// Connect to database
require_once("core/model/DB.php");
DB::connect($databaseConfig);

/*
 * Configure the request for the Director
 */
$_SERVER['REQUEST_URI'] = BASE_URL . '/' . $url;
$_GET['Key'] = EMAIL_BOUNCEHANDLER_KEY;
$_REQUEST = $_GET;
Director::direct($url);