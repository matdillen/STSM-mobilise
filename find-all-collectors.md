## Entomologists of the world

```
SELECT ?item ?itemLabel ?entom_id ?orcid ?viaf ?isni WHERE {
  ?item wdt:P5370 ?entom_id. #entomologists of the world
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" } 
  OPTIONAL { ?item wdt:P496 ?orcid .}
  OPTIONAL { ?item wdt:P214 ?viaf .}
  OPTIONAL { ?item wdt:P213 ?isni .}
}
```

## BHL creator ID

```
SELECT ?item ?itemLabel ?bhl_id ?orcid ?viaf ?isni WHERE {
  ?item wdt:P4081 ?bhl_id. #BHL creator
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" } 
  OPTIONAL { ?item wdt:P496 ?orcid .}
  OPTIONAL { ?item wdt:P214 ?viaf .}
  OPTIONAL { ?item wdt:P213 ?isni .}
}
```

## Harvard

```
SELECT ?item ?itemLabel ?harv_id ?orcid ?viaf ?isni WHERE {
  ?item wdt:P6264 ?harv_id. #Harvard index of botanists
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" } 
  OPTIONAL { ?item wdt:P496 ?orcid .}
  OPTIONAL { ?item wdt:P214 ?viaf .}
  OPTIONAL { ?item wdt:P213 ?isni .}
}
```

## Zoobank

```
SELECT ?item ?itemLabel ?zoo_id ?orcid ?viaf ?isni WHERE {
  ?item wdt:P2006 ?zoo_id. #zoobank
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" } 
  OPTIONAL { ?item wdt:P496 ?orcid .}
  OPTIONAL { ?item wdt:P214 ?viaf .}
  OPTIONAL { ?item wdt:P213 ?isni .}
}
```

## IPNI

```
SELECT ?item ?itemLabel ?ipni_id ?orcid ?viaf ?isni WHERE {
  ?item wdt:P586 ?ipni_id. #ipni
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" } 
  OPTIONAL { ?item wdt:P496 ?orcid .}
  OPTIONAL { ?item wdt:P214 ?viaf .}
  OPTIONAL { ?item wdt:P213 ?isni .}
}
```
