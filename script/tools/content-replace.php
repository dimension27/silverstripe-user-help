<?php
include(dirname($argv[0]).'/../env.php');

/*
 * Non-command line usage example:
$tables = array(
	'SiteTree' => array('Content'),
	'NewsItem' => array('Teaser'),
	'File' => array('FileName'),
	'CompanySearch' => array('NoResultsContent'),
	'RequestQuoteForm' => array('PCCEmailBody')
);
$searchReplace = array(
	'assets/Uploads/' => 'assets/Termidor/',
	'assets/Crop-Protection-2/' => 'assets/Crop-Protection/',
	'assets/media/termidor-news/' => 'assets/Termidor/News/'
);
contentReplace($tables, $searchReplace);
exit;
 */

if( sizeof($argv) != 4 ) {
	echo "Usage: $argv[0] {table.column,table.column,...} {search} {replace}\n";
	exit;
}
list($script, $tableList, $search, $replace) = $argv;
$tables = array();
$searchReplace = array($search => $replace);
foreach( preg_split('/\s*,\s*/', $tableList) as $table ) {
	list($table, $column) = explode('.', $table);
	$tables[$table][] = $column;
}

$renameFiles = array();
function contentReplace( $tables, $searchReplace ) {
	foreach( $tables as $table => $columns ) {
		foreach( $columns as $column ) {
			foreach( $searchReplace as $search => $replace ) {
				// echo "SELECT ID, $column FROM $table WHERE $column LIKE '%".addslashes($search)."%';\n";
				echo "UPDATE $table SET $column = REPLACE($column, '".addslashes($search)."', '".addslashes($replace)."') "
						."WHERE $column LIKE '%".addslashes($search)."%';\n";
				$file = BASE_PATH.'/public/'.$search;
				if( file_exists($file) ) {
					$dest = BASE_PATH."/public/$replace";
					if( !is_dir(dirname($dest)) ) {
						mkdir(dirname($dest));
					}
					$renameFiles[$file] = "mv '$file' '$dest'";
				}
			}
		}
	}
	if( $renameFiles ) {
		echo implode("\n", $renameFiles);
	}
}
?>