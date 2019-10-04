library(tidyverse)
library(WikidataQueryServiceR)
library(jsonlite)

#modified function based on query_wikidata in WikidataQueryServiceR package
#this one avoids the encoding error in text extraction
#also modified to avoid faulty column parsing with readr for sparse ids, e.g. orcids
querki <- function(query,h="text/csv") {
  require(httr)
  response <- httr::GET(url = "https://query.wikidata.org/sparql", 
                        query = list(query = query),
                        httr::add_headers(Accept = h))
  return(httr::content(response,type=h,col_types = cols(.default = "c")))
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

#wikispecies
query <- 'SELECT ?item ?itemLabel ?article ?orcid ?viaf ?isni
WHERE
{
	?item wdt:P31 wd:Q5 .
  ?article 	schema:about ?item ;
			schema:isPartOf <https://species.wikimedia.org/> .
	SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" }
	OPTIONAL { ?item wdt:P496 ?orcid .}
  OPTIONAL { ?item wdt:P214 ?viaf .}
  OPTIONAL { ?item wdt:P213 ?isni .}
}'
raw[[iter]] = querki(query)
iter = iter + 1

#all biologists
# query <-  'SELECT ?item ?itemLabel ?occupation ?orcid ?viaf ?isni WHERE {
#     ?item wdt:P106/wdt:P279* wd:Q864503 . #all biologists incl subclasses
#     SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" }
#     OPTIONAL { ?item wdt:P496 ?orcid .}
#     OPTIONAL { ?item wdt:P214 ?viaf .}
#     OPTIONAL { ?item wdt:P213 ?isni .}
#     OPTIONAL { ?item wdt:P106 ?occupation .} #not the label, as that timed out
#   }'
# raw[[iter]] = querki(query)
# iter = iter + 1

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

#deduplication, start with occupation
#find all occupations
#doesn't work: doesn't recurse in subclasses of zoologist, for instance
# query <- 'SELECT ?item ?itemLabel WHERE {
#   ?item wdt:P279 wd:Q864503 .
#   SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" }
#   }'
# occup = querki(query)
# allb$occupation2 = gsub("http://www.wikidata.org/entity/","",allb$occupation)
# for (i in 1:dim(occup)[1]) {
#   allb$occupation2[allb$occupation==occup$item[i]] = occup$itemLabel[i]
# }
# allb$occupation2[allb$occupation=="http://www.wikidata.org/entity/Q864503"] = "biologist"

#deduplication try 2

allb.names = filter(allb,duplicated(item)==F)
for (i in 3:length(allb.names)) {
  z = dim(allb.names)[1] -
    dim(allb.names[is.na(allb.names[,i]),i])[1]
  print(paste0(colnames(allb.names)[i],": ",z))
}

twoways = as.tibble(t(combn(seq(1:9),2)))
twoways = twoways+2

for (i in 1:dim(twoways)[1]) {
  z = dim(allb.names[is.na(allb.names[,twoways[i,1]])==F&
                     is.na(allb.names[,twoways[i,2]])==F,3])[1]
  print(paste0(colnames(allb.names)[twoways[i,1]],
               ", ",
               colnames(allb.names)[twoways[i,2]],
               ": ",
               z))
}

#test for no english label
#is the setting in the query optional? does it omit items with no english label?
allb.names$id = gsub("http://www.wikidata.org/entity/","",allb.names$item)
View(filter(allb.names,id==item))

allb.names$sname = gsub("^(.*[\\s])","",allb.names$itemLabel,perl=T)

ipni_info = list()
for (i in 1:dim(raw[[5]])[1]) {
  ipni_info[[i]] = fromJSON(paste0("https://beta.ipni.org/api/1/a/urn:lsid:ipni.org:authors:",raw[[5]]$ipni_id[i]))
  if (i%%5000==0) {
    print(i)
  }
}
#timed out after 317 requests
