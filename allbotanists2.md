SELECT ?item ?itemLabel ?yob ?yod ?ipni ?harvard ?zoo ?bhl WHERE {
  {?item wdt:P586 ?id.} UNION #ipni
  {?item wdt:P6264 ?id.} UNION #harvard
  {?item wdt:P2006 ?id.} UNION #zoobank
  {?item wdt:P4081 ?id.} UNION #bhl
  {?article schema:about ?item ; #wikispecies
            schema:isPartOf <https://species.wikimedia.org/> .
   } UNION
  {?item wdt:P4081 ?bhl_id.}
  	OPTIONAL { ?item wdt:P569 ?dob . BIND(YEAR(?dob) as ?yob) }
	OPTIONAL { ?item wdt:P570 ?dod . BIND(YEAR(?dod) as ?yod) }  
    OPTIONAL { ?item wdt:P586 ?ipni .}
    OPTIONAL { ?item wdt:P6264 ?harvard .}
    OPTIONAL { ?item wdt:P2006 ?zoo .}
    OPTIONAL { ?item wdt:P4081 ?bhl .}
}
