library(tidyverse)
setwd("D:/apm/STSM mobilise/data")

#import collector table export, apparently not UTF-8 encoded
bgb = read_csv("COLLECTORS_24APR19.csv",locale = locale(encoding = "latin1"))
#remove duplicate columns
bgb = bgb[,-c(13,14)]

##function to query wikidata API
#default lang is english
querki <- function(name,lang = "en") {
  require(jsonlite)
  #remove question marks in name strings. may need to remove other undesirable HTML reserved characters
  name = gsub("?","",name,fixed=T)
  url = paste0("https://www.wikidata.org/w/api.php?action=wbsearchentities&search=",
               name,
               "&type=item&format=json&language=",
               lang)
  #encode spaces
  url = URLencode(url)
  #query, parse from JSON to list
  resp = fromJSON(url,flatten=T)
  return(resp)
}

##Try a few tests
#initialize list for API responses
resu = list()

#define nr to try and GET
e = 1000

##query the API for string of "first name" + "last name"
#see how it goes without sleep for now
for (i in 1:e) {
  name = paste(bgb$FNAME[i],bgb$LNAME[i])
  resu[[i]] = querki(name)
  if (i%%100==0) {
    print(i)
  }
  #Sys.sleep(1)
}

##process the results

#retrieve the name that was tried and the number of matches found
#(this approach fails if the first record gets 0 matches)
name = resu[[1]]$searchinfo$search
aantal = tibble(name)
aantal$c = dim(resu[[1]]$search)[1]

#
for (i in 2:e) {
  name = resu[[i]]$searchinfo$search
  aantal.p = tibble(name)
  c = dim(resu[[i]]$search)[1]
  if (is.null(c)) {
    aantal.p$c = 0
  }
  else {
    aantal.p$c = c
  }
  aantal = rbind(aantal,aantal.p)
}             

#save the results and make frequency table
test2.res = count(aantal,c)
test2.data = resu
aantal$id = NA

#add the wikidata ids for single matches
#few samples indicate not a few false matches (e.g. partial string matches)
for (i in 1:e) {
  if (aantal$c[i]==1) {
    aantal$id[i] = resu[[i]]$search$id
  }
}
