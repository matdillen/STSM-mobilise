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