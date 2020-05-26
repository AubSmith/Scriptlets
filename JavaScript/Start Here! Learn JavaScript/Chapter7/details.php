<?php

if (!isset($_POST['flightID'])) {
	die();
}
$data = array();
switch ($_POST['flightID']) {
	case "flight0":
		$data = array("duration" => "1 Minute");
		break;
	case "flight1":
		$data = array("duration" => "5 Days");
		break;
	case "flight2":	
		$data = array("duration" => "7 Days");
		break;
	default:
		$data = array("duration" => "9 Days");
}

print json_encode($data);

?>
