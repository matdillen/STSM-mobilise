library(tidyverse)
library(WikidataQueryServiceR)

#modified function based on query_wikidata in WikidataQueryServiceR package
#this one avoids the encoding error in text extraction
querki <- function(query,h="text/csv") {
  require(httr)
  response <- httr::GET(url = "https://query.wikidata.org/sparql", 
                        query = list(query = query),
                        httr::add_headers(Accept = h))
  return(httr::content(response))
}

#convert logical columns to char for compatibility
#columns will default to logical if all values are empty
tochar <- function(df) {
  df2 = as_tibble(sapply(df,
                      function(x) if(is.logical(x)) {
                        return(as.character(x)) } 
                      else {
                        return(x)
                        }
                      ))
  return(df2)
}

#process the different source SPARQL queries

raw = list()
iter = 1

#entomologists of the world
query <- 'SELECT ?item ?itemLabel ?entom_id ?orcid ?viaf ?isni WHERE {
  ?item wdt:P5370 ?entom_id. #entomologists of the world
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" } 
  OPTIONAL { ?item wdt:P496 ?orcid .}
  OPTIONAL { ?item wdt:P214 ?viaf .}
  OPTIONAL { ?item wdt:P213 ?isni .}
}'
raw[[iter]] = querki(query)
iter = iter + 1

#BHL creator
query <- 'SELECT ?item ?itemLabel ?bhl_id ?orcid ?viaf ?isni WHERE {
  ?item wdt:P4081 ?bhl_id. #BHL creator
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" } 
  OPTIONAL { ?item wdt:P496 ?orcid .}
  OPTIONAL { ?item wdt:P214 ?viaf .}
  OPTIONAL { ?item wdt:P213 ?isni .}
}'
#raw[[iter]] = query_wikidata(query)
raw[[iter]] = querki(query)
iter = iter + 1

#Harvard
query <- 'SELECT ?item ?itemLabel ?harv_id ?orcid ?viaf ?isni WHERE {
  ?item wdt:P6264 ?harv_id. #Harvard index of botanists
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" } 
  OPTIONAL { ?item wdt:P496 ?orcid .}
  OPTIONAL { ?item wdt:P214 ?viaf .}
  OPTIONAL { ?item wdt:P213 ?isni .}
}'
raw[[iter]] = querki(query)
iter = iter + 1

#Zoobank
query <- 'SELECT ?item ?itemLabel ?zoo_id ?orcid ?viaf ?isni WHERE {
  ?item wdt:P2006 ?zoo_id. #zoobank
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" } 
  OPTIONAL { ?item wdt:P496 ?orcid .}
  OPTIONAL { ?item wdt:P214 ?viaf .}
  OPTIONAL { ?item wdt:P213 ?isni .}
}'
raw[[iter]] = querki(query)
iter = iter + 1

#IPNI
query <- 'SELECT ?item ?itemLabel ?ipni_id ?orcid ?viaf ?isni WHERE {
  ?item wdt:P586 ?ipni_id. #ipni
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" } 
  OPTIONAL { ?item wdt:P496 ?orcid .}
  OPTIONAL { ?item wdt:P214 ?viaf .}
  OPTIONAL { ?item wdt:P213 ?isni .}
}'
raw[[iter]] = querki(query)
iter = iter + 1

#for comparison: query results using GUI
# setwd("D:/apm/STSM mobilise/data/select")
# di = list.files(pattern="*.tsv")
# raw2=list()
# for (i in 1:length(di)) {
#   raw2[[i]] = read_tsv(di[i],col_types = cols(.default = "c"))
# }


#fix column types
for (i in 1:length(raw)) {
  raw[[i]] = tochar(raw[[i]])
}

#full join
allb = full_join(raw[[1]],raw[[2]])
if (length(raw)>2) {
  for (i in 3:length(raw)) {
    allb = full_join(allb,raw[[i]])
  }
}
