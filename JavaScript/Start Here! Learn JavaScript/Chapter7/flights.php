<?php

$travels = array();

$travels[] = array("trip" => 'Around the block',"price" => 10000);
$travels[] = array("trip" => 'Earth to Moon',"price" => 50000);
$travels[] = array("trip" => 'Earth to Venus',"price" => 200000);
$travels[] = array("trip" => 'Earth to Mars',"price" => 100000);
$travels[] = array("trip" => 'Venus to Mars',"price" => 250000);
$travels[] = array("trip" => 'Earth to Sun - One Way',"price" => 450000);
$travels[] = array("trip" => 'Earth to Jupiter',"price" => 300000);
$travels[] = array("trip" => 'Earth to Neptune',"price" => 475000);
$travels[] = array("trip" => 'Earth to Uranus',"price" => 500000);

print json_encode($travels);

?>
