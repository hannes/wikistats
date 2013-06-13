<?php
require 'phplib/php_monetdb.php';
$db = monetdb_connect("sql","bristol.ins.cwi.nl",50000,"monetdb","monetdb","wikistats") or trigger_error(monetdb_last_error());

$hasJsonp = false;
$jsonp = "";
$lang = "en";

if (isset($_REQUEST["callback"]) && !empty($_REQUEST["callback"])) {
	$hasJsonp = true;
	$jsonp = $_REQUEST["callback"];
}

$json = array();

if (isset($_REQUEST['page'])) {

	$pages = $_REQUEST["page"];
	if (sizeof($pages) < 1) {
		http_response_code(400);
		die("Empty 'page[]' request parameter(s)");
	}
	if (!is_array($pages)) {
		$pages = array($pages);
	}

	$query = "SELECT \"page\",\"year\",\"week\",\"count\" FROM \"weekcountenf\" WHERE \"lang\"='".$lang."' AND \"page\" in ('".implode($pages,"','")."') ORDER BY \"page\", \"week\";";
	$res = monetdb_query($db, monetdb_escape_string($query)) or trigger_error(monetdb_last_error());
	while ( $row = monetdb_fetch_object($res) ){
		$json[$row->page]["data"][] = array("x"=>strtotime($row->year."W".sprintf('%02d', $row->week)),"y" =>  intval($row->count));
		$json[$row->page]["name"] = $row->page;
	}
	$json = array_values($json);

	monetdb_free_result($res);
}

if (isset($_REQUEST['suggest'])) {
	$suggest = strtolower(trim($_REQUEST['suggest']));
	if (strlen($suggest) == 0) {
		http_response_code(400);
		die("Empty 'suggest' request parameter");
	}
	$query = "SELECT \"page\",100000000 as \"countsum\" FROM \"pages\" WHERE lcase(\"page\")  = '".$suggest."' UNION ALL SELECT \"page\",\"countsum\" FROM \"pages\" WHERE lcase(\"page\")  like '%".$suggest."%' and not(lcase(\"page\") = '".$suggest."') ORDER BY countsum DESC LIMIT 10;";
	$res = monetdb_query($db, monetdb_escape_string($query)) or trigger_error(monetdb_last_error());
	while ( $row = monetdb_fetch_object($res) ){
		$json[] = $row->page;
	}
	monetdb_free_result($res);
}

if (monetdb_connected($db)) {
		monetdb_disconnect($db);
}

if ($hasJsonp) {
	header("Content-Type: application/javascript");
	print $jsonp ."(".json_encode($json).");";
} else {
	header("Content-Type: application/json");
	print json_encode($json);
}

?>