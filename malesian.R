library(tidyverse)
setwd("D:/apm/STSM mobilise/data")

setwd("cyclopaedia-malesian-collectors-master")

#extract person names out of the HTML of the individual pages, stored in alphabetic folders (except folder XY)
naam = NA
names = NA
names = tibble(names)
az = LETTERS
az = az[-25]
az[24]="XY"

for (j in 1:length(az)) {
  setwd(az[j])
  di = list.files()
  for (i in  1:length(di)) {
    pars = readLines(di[i])
    part = tibble(pars)
    #the name is as a header2, extract all between both tags and then regex the html tags away
    line.ids = c(grep("<h2",part$pars,fixed=T),
                 grep("</h2",part$pars,fixed=T))
    naam = paste(part$pars[line.ids[1]:line.ids[2]],collapse="")
    naam = gsub("<[^<>]*>","",naam)
    names = rbind(names,naam)
  }
  setwd("..")
  print(az[j])
}
#remove the initial row and the summary pages
names = names[-1,]
names = filter(names,grepl("Cyclopaedia of",names)==F)
