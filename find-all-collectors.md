## Entomologists of the world

```
SELECT ?item ?itemLabel ?orcid ?viaf ?isni WHERE {
  ?item wdt:P5370 ?id. #entomologists of the world
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" } 
  OPTIONAL { ?item wdt:P496 ?orcid .}
  OPTIONAL { ?item wdt:P214 ?viaf .}
  OPTIONAL { ?item wdt:P213 ?isni .}
}
```

## BHL creator ID

```
SELECT ?item ?itemLabel ?orcid ?viaf ?isni WHERE {
  ?item wdt:P4081 ?id. #BHL creator
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" } 
  OPTIONAL { ?item wdt:P496 ?orcid .}
  OPTIONAL { ?item wdt:P214 ?viaf .}
  OPTIONAL { ?item wdt:P213 ?isni .}
}
```

## Harvard

```
SELECT ?item ?itemLabel ?orcid ?viaf ?isni WHERE {
  ?item wdt:P6264 ?id. #Harvard index of botanists
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" } 
  OPTIONAL { ?item wdt:P496 ?orcid .}
  OPTIONAL { ?item wdt:P214 ?viaf .}
  OPTIONAL { ?item wdt:P213 ?isni .}
}
```

## Zoobank

```
SELECT ?item ?itemLabel ?orcid ?viaf ?isni WHERE {
  ?item wdt:P2006 ?id. #zoobank
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" } 
  OPTIONAL { ?item wdt:P496 ?orcid .}
  OPTIONAL { ?item wdt:P214 ?viaf .}
  OPTIONAL { ?item wdt:P213 ?isni .}
}
```

## IPNI

```
SELECT ?item ?itemLabel ?orcid ?viaf ?isni WHERE {
  ?item wdt:P586 ?id. #ipni
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" } 
  OPTIONAL { ?item wdt:P496 ?orcid .}
  OPTIONAL { ?item wdt:P214 ?viaf .}
  OPTIONAL { ?item wdt:P213 ?isni .}
}
```
