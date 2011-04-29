<?php
include('include.php');

$forceRotate = false;
if( @$argv[1] == '--force' ) {
	$forceRotate = true;
}
// controls the maximum size of the log files
$maxSize = 1048576;
// controls the maxiumum age (in seconds) of the entries in the request log database table (if any)
$requestLogMaxAge = 14 * 86400;

$path = base_getProjectPath();
$logFileRotator = base_new('iris.util.logging.LogFileRotator');
$logFileRotator->addLogFile($path.'/logs/apache-access.log', $maxSize, 10);
$logFileRotator->addLogFile($path.'/logs/apache-error.log', $maxSize, 10);
$logFileRotator->addLogFile($path.'/logs/php-error.log', $maxSize, 10);
$logFileRotator->addLogFile($path.'/logs/request.log', $maxSize, 10);
$logFileRotator->rotateLogFiles($forceRotate);

$db = base_getDatabase();
if( $db->tableExists('requestLog') ) {
	$dateLimit = date('Y-m-d H:i:s', time() - $requestLogMaxAge);
	$db->execute("DELETE FROM requestLog WHERE timestamp < '$dateLimit'");
}
?>