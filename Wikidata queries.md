# Wikidata Queries 

Examples of queries to assess scope of Wikidata coverage.

## IPNI

### IPNI author id

Find people in Wikidata that have IPNI author ids (set of botanical taxonomists that have published plant names)

```
SELECT * WHERE {
  ?item wdt:P586 ?IPNI_author_ID.
  OPTIONAL { 
    ?item wdt:P496 ?orcid.
  }
  OPTIONAL { 
    ?article 	schema:about ?item ;
    schema:isPartOf <https://species.wikimedia.org/> .
  }
}
```

[Try it](https://w.wiki/8yL) 46725 rows 2019-09-27

### IPNI and ORCID

Find IPNI authors who also have an ORCID id

```
SELECT * WHERE {
  ?item wdt:P586 ?IPNI_author_ID .
  ?item wdt:P496 ?orcid .
}
```

[Try it](https://w.wiki/8yN) 400 rows 2019-09-27

### IPNI and Wikispecies

IPNI authors that also have Wikispecies articles

```
SELECT * WHERE {
  ?item wdt:P586 ?IPNI_author_ID.
  ?article 	schema:about ?item ;
  schema:isPartOf <https://species.wikimedia.org/> .
}
```

[Try it](https://w.wiki/8yQ) 12223 rows 2019-09-27


## ZooBank

### ZooBank authors

Find people with ZooBank author ids (set of zoological authors who have published names)

```
SELECT * WHERE {
  ?item wdt:P2006 ?zoobank.
}
```
15658 rows 2019-09-27 (same as Wikispecies)

### ZooBank and Wikispecies

Zoobank authors that also have Wikispecies articles

```
SELECT * WHERE {
  ?item wdt:P2006 ?zoobank.
  ?article schema:about ?item;
  schema:isPartOf <https://species.wikimedia.org/>.
}
```

[Try it](https://w.wiki/8yT) 15658 rows 2019-09-27


### Zoobank and ORCID

ZooBank authors with ORCID ids in Wikidata

```
SELECT * WHERE {
  ?item wdt:P2006 ?zoobank.
  ?item wdt:P496 ?orcid .
}
```

[Try it](https://w.wiki/8yW) 1138 rows 2019-09-27

## Visualisations

### Citizenship of people with ZooBank author ids

```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
SELECT DISTINCT 
?citizenship ?citizenship_label (COUNT(?citizenship_label) AS ?count) 
WHERE
{ 
    # get people
	  ?item wdt:P2006 ?zoobank.
 
    # get citizenship
    ?item rdfs:label ?name .
    FILTER (lang(?name) = 'en')
    ?item wdt:P27 ?citizenship .
    ?citizenship rdfs:label ?citizenship_label .
    FILTER (lang(?citizenship_label) = 'en')    
   
}
GROUP BY ?citizenship ?citizenship_label

```
	
[Try it](https://w.wiki/9Co)

### Gender ratio of people with ZooBank author ids

```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
SELECT DISTINCT 
?gender ?gender_label (COUNT(?gender_label) AS ?count) 
WHERE
{ 
    # get people
	  ?item wdt:P2006 ?zoobank.

    ?item rdfs:label ?name .
    FILTER (lang(?name) = 'en')
    ?item wdt:P21 ?gender .
    ?gender rdfs:label ?gender_label .
    FILTER (lang(?gender_label) = 'en')    
 }
GROUP BY ?gender ?gender_label
```

[Try it](https://w.wiki/9Cp)


### Birth dates of people with ZooBank author ids

Note that major problem is birth dates are often not precise, and a date of “20th C” gets translated as 1 January 2000, which is of no use.

```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
SELECT DISTINCT 
?item ?name 
(YEAR(?birth) AS ?year)
WHERE
{ 
    # get people
	 ?item wdt:P2006 ?zoobank.
 
    ?item rdfs:label ?name .
    FILTER (lang(?name) = 'en')
    ?item wdt:P569 ?birth .
}
ORDER BY ?year
```

[Try it](https://w.wiki/9Ct)

##Harvard botanist id

###Find all items with a Harvard botanist ID

```
SELECT * WHERE {
  ?item wdt:P6264 ?harvard_id.
  OPTIONAL { 
    ?article 	schema:about ?item ;
    schema:isPartOf <https://species.wikimedia.org/> .
  }
}
```

