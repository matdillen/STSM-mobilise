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
                        httr::add_headers(Accept = h),httr::user_agent("Matdillen"))
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
query <- 'SELECT ?item ?itemLabel ?entom_id ?orcid ?viaf ?isni ?yob ?yod WHERE {
  ?item wdt:P5370 ?entom_id. #entomologists of the world
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" } 
  OPTIONAL { ?item wdt:P496 ?orcid .}
  OPTIONAL { ?item wdt:P214 ?viaf .}
  OPTIONAL { ?item wdt:P213 ?isni .}
  OPTIONAL { ?item wdt:P569 ?dob . BIND(YEAR(?dob) as ?yob) }
	OPTIONAL { ?item wdt:P570 ?dod . BIND(YEAR(?dod) as ?yod) }
}'
raw[[iter]] = querki(query)
iter = iter + 1

#BHL creator
query <- 'SELECT ?item ?itemLabel ?bhl_id ?orcid ?viaf ?isni ?yob ?yod WHERE {
  ?item wdt:P4081 ?bhl_id. #BHL creator
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" } 
  OPTIONAL { ?item wdt:P496 ?orcid .}
  OPTIONAL { ?item wdt:P214 ?viaf .}
  OPTIONAL { ?item wdt:P213 ?isni .}
  OPTIONAL { ?item wdt:P569 ?dob . BIND(YEAR(?dob) as ?yob) }
	OPTIONAL { ?item wdt:P570 ?dod . BIND(YEAR(?dod) as ?yod) }
}'
#raw[[iter]] = query_wikidata(query)
raw[[iter]] = querki(query)
iter = iter + 1

#Harvard
query <- 'SELECT ?item ?itemLabel ?harv_id ?orcid ?viaf ?isni ?yob ?yod WHERE {
  ?item wdt:P6264 ?harv_id. #Harvard index of botanists
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" } 
  OPTIONAL { ?item wdt:P496 ?orcid .}
  OPTIONAL { ?item wdt:P214 ?viaf .}
  OPTIONAL { ?item wdt:P213 ?isni .}
  OPTIONAL { ?item wdt:P569 ?dob . BIND(YEAR(?dob) as ?yob) }
	OPTIONAL { ?item wdt:P570 ?dod . BIND(YEAR(?dod) as ?yod) }
}'
raw[[iter]] = querki(query)
iter = iter + 1

#Zoobank
query <- 'SELECT ?item ?itemLabel ?zoo_id ?orcid ?viaf ?isni ?yob ?yod WHERE {
  ?item wdt:P2006 ?zoo_id. #zoobank
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" } 
  OPTIONAL { ?item wdt:P496 ?orcid .}
  OPTIONAL { ?item wdt:P214 ?viaf .}
  OPTIONAL { ?item wdt:P213 ?isni .}
  OPTIONAL { ?item wdt:P569 ?dob . BIND(YEAR(?dob) as ?yob) }
	OPTIONAL { ?item wdt:P570 ?dod . BIND(YEAR(?dod) as ?yod) }
}'
raw[[iter]] = querki(query)
iter = iter + 1

#IPNI
query <- 'SELECT ?item ?itemLabel ?ipni_id ?orcid ?viaf ?isni ?yob ?yod WHERE {
  ?item wdt:P586 ?ipni_id. #ipni
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" } 
  OPTIONAL { ?item wdt:P496 ?orcid .}
  OPTIONAL { ?item wdt:P214 ?viaf .}
  OPTIONAL { ?item wdt:P213 ?isni .}
  OPTIONAL { ?item wdt:P569 ?dob . BIND(YEAR(?dob) as ?yob) }
	OPTIONAL { ?item wdt:P570 ?dod . BIND(YEAR(?dod) as ?yod) }
}'
raw[[iter]] = querki(query)
iter = iter + 1

#wikispecies
query <- 'SELECT ?item ?itemLabel ?article ?orcid ?viaf ?isni ?yob ?yod
WHERE
{
	?item wdt:P31 wd:Q5 .
  ?article 	schema:about ?item ;
			schema:isPartOf <https://species.wikimedia.org/> .
	SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" }
	OPTIONAL { ?item wdt:P496 ?orcid .}
  OPTIONAL { ?item wdt:P214 ?viaf .}
  OPTIONAL { ?item wdt:P213 ?isni .}
  OPTIONAL { ?item wdt:P569 ?dob . BIND(YEAR(?dob) as ?yob) }
	OPTIONAL { ?item wdt:P570 ?dod . BIND(YEAR(?dod) as ?yod) }
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

#try the IPNI beta API
ipni_info = list()
for (i in 1:dim(raw[[5]])[1]) {
  ipni_info[[i]] = fromJSON(paste0("https://beta.ipni.org/api/1/a/urn:lsid:ipni.org:authors:",raw[[5]]$ipni_id[i]))
  if (i%%5000==0) {
    print(i)
  }
}
#timed out after 317 requests
#evening: after 2933 requests
#maybe with trycatch, but will take hours!


####Match BG-Base collectors to wikidata items
setwd("D:/apm/STSM mobilise/data")
bgb = read_csv("COLLECTORS_24APR19.csv",locale = locale(encoding = "latin1"))
#View(filter(allb.names,sname%in%bgb$LNAME))

#make date ranges
allb.names$date = paste(allb.names$yob,allb.names$yod,sep="-")
allb.names$date = gsub("NA","",allb.names$date)

#extract year
for (i in 1:dim(bgb)[1]) {
  bgb$date1[i] = substr(bgb$BIRTH_DT[i],nchar(bgb$BIRTH_DT[i])-3,nchar(bgb$BIRTH_DT[i]))
  bgb$date2[i] = substr(bgb$DEATH_DT[i],nchar(bgb$DEATH_DT[i])-3,nchar(bgb$DEATH_DT[i]))
}
bgb$date = paste(bgb$date1,bgb$date2,sep="-")
bgb$date = gsub("NA","",bgb$date)
bgb$date[bgb$date=="-"]="NA"


#try wikidata api
# allb.names$id = gsub("http://www.wikidata.org/entity/","",allb.names$item)
# tst50 = paste(allb.names$id[1:50],collapse="|")
# test = fromJSON(paste0("https://www.wikidata.org/w/api.php?action=wbgetentities&ids=",tst50,"&format=json"))
# 
# library(httr)
# tst100 = paste(allb.names$id[51:100],collapse="|")
# test3 = httr::GET(url = paste0("https://www.wikidata.org/w/api.php?action=wbgetentities&ids=",tst100,"&format=json"),
#                                httr::user_agent("Matdillen"))
# test3.c = httr::content(test3,type="application/json")
# 
# for (i in seq(from=1,to=dim(allb.names)[1],by=50)) {
#   #too big for memory, will be difficult to effectively parse
# }

bgb$fullname = paste(bgb$FNAME,bgb$MNAME,bgb$LNAME)
bgb$fullname = gsub("NA ","",bgb$fullname)

#View(filter(bgb,fullname%in%allb.names$itemLabel))

#Find how many specimens a COLL_ID collected
#based on latest BG-Base specimen export (imported as 'exp': data from May 2019)
bgb$n = NA
bgb$mndate = NA
bgb$mxdate = NA
for (i in 1:dim(bgb)[1]) {
  k = speccoll[speccoll$COLL_ID==bgb$COLL_ID[i],]
  if (is.na(bgb$date1[i])) {
  dates = filter(exp,bgb$COLL_ID[i]==COLL_ID,is.na(COLL_DT)==F)$COLL_DT
    if (length(dates)>0) {
      bgb$mndate[i] = min(as.numeric(substr(dates,8,11)))
      bgb$mxdate[i] = max(as.numeric(substr(dates,8,11)))
    }
  }
  bgb$n[i]=k$n[1]
  if (i%%100==0) {
    print(i)
  }
}

#kill ranges over a 100: probably an error in one of the dates or associations
for (i in 1:dim(bgb)[1]) {
  if (is.na(bgb$mndate[i])==F&is.na(bgb$mxdate[i])==F) {
    dur = bgb$mxdate[i] - bgb$mndate[i]
    if (dur > 100) {
      bgb$mndate[i] = NA
      bgb$mxdate[i] = NA
      }
  }
}

#only people who have collected specimens
bgb2 = filter(bgb,n>0)

#only those who have some sort of date
bgb3 = filter(bgb2,is.na(date1)==F|is.na(mndate)==F)
bgb3 = filter(bgb3,is.na(LNAME)==F) #remove no collector specified

#add 15y margin for childhood
bgb3$mndate2 = bgb3$mndate - 15

bgb3$options = NA
bgb3$lopt = NA

#create initials for the wikidata item labels
allb.names$init = gsub("\'","",allb.names$itemLabel,fixed=T)
allb.names$init = gsub("\"","",allb.names$init,fixed=T)
allb.names$init = gsub("(?<!\\s).","",allb.names$init,perl=T)
allb.names$init = paste0(substr(allb.names$itemLabel,1,1),allb.names$init)

#match (see documentation for more explanation)
for (i in 1:dim(bgb3)[1]) {
  truem = filter(allb.names,itemLabel==bgb3$fullname[i])
  if (dim(truem)[1]>0) {
    bgb3$lopt[i] = dim(truem)[1]
    bgb3$options[i] = paste(truem$itemLabel,collapse="|")
    next
  }
  yob = filter(allb.names,yob==bgb3$date1[i])
  if (dim(yob)[1]>0) {
    yob = filter(yob,agrepl(bgb3$LNAME[i],itemLabel))
    len = dim(yob)[1]
    if (is.na(bgb3$FNAME[i])==F) {
      if (grepl(".",bgb3$FNAME[i],fixed=T)==F) {
        yob = filter(yob,agrepl(bgb3$FNAME[i],itemLabel))
        len = dim(yob)[1]
      }
      if (grepl(".",bgb3$FNAME[i],fixed=T)) {
        yob = filter(yob,grepl(gsub("\\.","",bgb3$FNAME[i]),init))
        len=dim(yob)[1]
      }
    }
     if (len > 1&is.na(bgb3$MNAME[i])==F) {
       yob = filter(yob,agrepl(bgb3$MNAME[i],itemLabel))
       len = dim(yob)[1]
     }
    bgb3$lopt[i] = len
    bgb3$options[i] = paste(yob$itemLabel,collapse="|")
    print(i)
    next
  }
  if (is.na(bgb3$mndate2[i])==F) {
    #next
    yob = filter(allb.names,yob<bgb3$mndate2[i])
    yob = filter(yob,is.na(yod)|yod>bgb3$mxdate[i])
    if (dim(yob)[1]>0) {
      yob = filter(yob,agrepl(bgb3$LNAME[i],itemLabel))
      len = dim(yob)[1]
      if (is.na(bgb3$FNAME[i])==F) {
        if (grepl(".",bgb3$FNAME[i],fixed=T)==F) {
          yob = filter(yob,agrepl(bgb3$FNAME[i],itemLabel))
          len = dim(yob)[1]
        }
        if (grepl(".",bgb3$FNAME[i],fixed=T)) {
          yob = filter(yob,grepl(gsub("\\.","",bgb3$FNAME[i]),init))
          len=dim(yob)[1]
        }
      }
      if (len > 1&is.na(bgb3$MNAME[i])==F) {
        yob = filter(yob,agrepl(bgb3$MNAME[i],itemLabel))
        len = dim(yob)[1]
      }
      bgb3$lopt[i] = len
      bgb3$options[i] = paste(yob$itemLabel,collapse="|")
      print(i)
      next
    }
  }
}

#unmatched
allb.nd = filter(allb.names,is.na(yob))
bgb4 = filter(bgb3,lopt!=1)


#get pub info from wikidata
# query <- paste0('SELECT ?item ?itemLabel ?pub WHERE 
# {
#   ?item wdt:P50 wd:',item,'.
#   SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" }
#   OPTIONAL { ?item wdt:P577 ?pub.}
#   }')
# pubs = querki(query)

#initialize
pubst = tibble(item = 0,itemLabel = 0, pub = 0,id=0)

#bombardment of sparql queries
for (i in 10001:20000) {
  query <- paste0('SELECT ?item ?itemLabel ?pub WHERE 
{
  ?item wdt:P50 wd:',allb.nd$id[i],'.
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" }
  OPTIONAL { ?item wdt:P577 ?pub.}
  }')
  pubs = querki(query)
  if (dim(pubs)[1]>0) {
    pubs$id = allb.nd$id[i]
    pubst = rbind(pubst,pubs)
  }
  print(i)
}

#post processing
pubst.uni = filter(pubst,duplicated(id)==F)
pubst.uni = pubst.uni[-1,]
pubst2 = pubst
pubst2$year = substr(pubst2$pub,1,4)
pubst2 = pubst2[-1,]

for (i in 1:dim(pubst.uni)[1]) {
  giv = filter(pubst2,id==pubst.uni$id[i])
  pubst.uni$mndate[i] = min(giv$year)
  pubst.uni$mxdate[i] = max(giv$year)
}
