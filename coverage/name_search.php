<?php


//----------------------------------------------------------------------------------------
// get
function get($url, $format = "application/json")
{
	
	$ch = curl_init();
	curl_setopt($ch, CURLOPT_URL, $url);
	curl_setopt($ch, CURLOPT_POST, 1);
	curl_setopt($ch, CURLOPT_HEADER, 0);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);   
	curl_setopt($ch, CURLOPT_HTTPHEADER, array("Accept: " . $format, "User-agent: Mozilla/5.0 (iPad; U; CPU OS 3_2_1 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Mobile/7B405"));

	$response = curl_exec($ch);
	if($response == FALSE) 
	{
		$errorText = curl_error($ch);
		curl_close($ch);
		die($errorText);
	}
	
	$info = curl_getinfo($ch);
	$http_code = $info['http_code'];
	
	curl_close($ch);
	
	return $response;
}


$query = 'Reijo Jussila';

// emtity query

$parameters = array(
	'action' => 'wbsearchentities',
	'search' => $query,
	'type' => 'item',
	'format' => 'json',
	'language' => 'en'
);

$url = 'https://www.wikidata.org/w/api.php?' . http_build_query($parameters);

$json = get($url);

echo $json;



// text query
$parameters = array(
	'action' => 'query',
	'list'	=> 'search',
	'srsearch' => $query,
	'srprop'	=> 'titlesnippet|7Csnippet',
	'format' => 'json',
);

$url = 'https://www.wikidata.org/w/api.php?' . http_build_query($parameters);

$json = get($url);

echo $json;




// merge results



?>


