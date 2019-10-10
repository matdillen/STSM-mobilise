<?php

$basedir = '/Volumes/Samsung_T5/rdf-archive/ipni/authors';

$files1 =  scandir($basedir);

$keys = array('id', 'name', 'alias', 'fl');

echo join("\t", $keys) . "\n";

foreach ($files1 as $directory)
{
	if (preg_match('/^\d+$/', $directory))
	{	
		$files2 = scandir($basedir . '/' . $directory);

		foreach ($files2 as $filename)
		{
			//echo $filename . "\n";
			if (preg_match('/\.xml$/', $filename))
			{	
				$xml = file_get_contents($basedir . '/' . $directory . '/' . $filename);
				
				$obj = new stdclass;
				$obj->name = '';
				$obj->alias = array();
				$obj->fl = '';
				
				// parse
				$dom= new DOMDocument;
				$dom->loadXML($xml);
				$xpath = new DOMXPath($dom);
				
				$xpath->registerNamespace("dc", "http://purl.org/dc/elements/1.1/");
				$xpath->registerNamespace("p", "http://rs.tdwg.org/ontology/voc/Person");
				$xpath->registerNamespace("rdf", "http://www.w3.org/1999/02/22-rdf-syntax-ns#");


				$xpath_query = '//p:Person/@rdf:about';
				$nodeCollection = $xpath->query ($xpath_query);
				foreach($nodeCollection as $node)
				{
					$obj->id = $node->firstChild->nodeValue;
					
					$obj->id= str_replace('urn:lsid:ipni.org:authors:', '', $obj->id);
				}

				$xpath_query = '//dc:title';
				$nodeCollection = $xpath->query ($xpath_query);
				foreach($nodeCollection as $node)
				{
					$obj->name = $node->firstChild->nodeValue;
				}

				$xpath_query = '//p:lifeSpan';
				$nodeCollection = $xpath->query ($xpath_query);
				foreach($nodeCollection as $node)
				{
					$obj->fl = $node->firstChild->nodeValue;
				}

				$xpath_query = '//p:alias/p:PersonNameAlias';
				$nodeCollection = $xpath->query ($xpath_query);
				foreach($nodeCollection as $node)
				{
					$alias = array();
					foreach ($xpath->query('p:forenames', $node) as $n)
					{
						$alias[] = $n->firstChild->nodeValue;
					}
					foreach ($xpath->query('p:surname', $node) as $n)
					{
						$alias[] = $n->firstChild->nodeValue;
					}
				
					$obj->alias[] = join(' ', $alias);
				}
				
				//print_r($obj);
				
				$row = array();
				foreach($keys as $k)
				{
					if (is_array($obj->{$k}))
					{
						$row[] = join('|', $obj->{$k});
					}
					else
					{
						$row[] = $obj->{$k};
					}
				}
				echo join("\t", $row) . "\n";
				
			}
		}
	}
}

/*
<?xml version="1.0" encoding="UTF-8"?>
<rdf:RDF xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:dc="http://purl.org/dc/elements/1.1/" 
xmlns:dcterms="http://purl.org/dc/terms/"
xmlns:p="http://rs.tdwg.org/ontology/voc/Person"
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
xmlns:owl="http://www.w3.org/2002/07/owl#">
<p:Person rdf:about="urn:lsid:ipni.org:authors:1-1">
<dc:title>Franz Engel</dc:title>
<owl:versionInfo>1.2</owl:versionInfo>
<dcterms:created>2003-07-02 00:00:00.0</dcterms:created>
<dcterms:modified>2013-11-08 10:11:18.0</dcterms:modified>
<p:alias>
<p:PersonNameAlias>
<p:isPreferred>true</p:isPreferred>
<p:standardForm>Engel</p:standardForm>
<p:forenames>Franz</p:forenames>	
<p:surname>Engel</p:surname>
</p:PersonNameAlias>
</p:alias>    
<p:alias>	
<p:PersonNameAlias>
<p:isPreferred>false</p:isPreferred>
<p:forenames>Theodor Franz Johann August</p:forenames>	
<p:surname>Engel</p:surname>
</p:PersonNameAlias>
</p:alias>
<p:lifeSpan>1834-1920</p:lifeSpan>
<p:subjectScope>Botany</p:subjectScope>
<p:subjectScope>Spermatophytes</p:subjectScope>
</p:Person>
</rdf:RDF>
*/

?>



