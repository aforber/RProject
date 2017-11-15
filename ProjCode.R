#--------------------------
# R PYTHON FINAL PROJECT
# ALYSSA FORBER
# CREATED NOV 14 2017
#-------------------------

rm(list=ls())

library(RColorBrewer)
library(sp)
library(maptools) 
library(lattice)
library(latticeExtra)
library(rgdal)

#-----------
# READ DATA
#-----------

inter <- read.csv('/Users/alyssaforber/Documents/Denver/Fall2017/RPython/intervention.csv', header=T)
incid <- read.csv('/Users/alyssaforber/Documents/Denver/Fall2017/RPython/incidence.csv')
poly <- readShapePoly('/Users/alyssaforber/Documents/Denver/Fall2017/RPython/Moz_admin2.shp', IDvar="DISTCODE")



# code from https://stackoverflow.com/questions/15954463/read-list-of-file-names-from-web-into-r

# EXTRACT ALL THE LINKS FOR EACH FILE
library(XML)
url <- "http://rap.ucar.edu/staff/monaghan/colborn/mozambique/daily/v2/"
doc <- htmlParse(url)
links <- xpathSApply(doc, "//a/@href")
free(doc)
wanted <- links[grepl("*_fldas_daily_20100101-20170724.txt", links)]
GetMe <- paste(url, wanted, sep = "")


# LIST OF DATA FRAMES
d <- lapply(seq_along(GetMe), 
            function(x) read.table(GetMe[1], skip=3, header = FALSE, sep ='', stringsAsFactors = FALSE, dec="."))

# ADD COLUMN NAMES
for (i in seq_along(d)){
  colnames(d[[i]]) <- c("year", "mo", "day", "raint", "tavg", "rh", "sd", "psfc")
}

# GET LIST OF DISTRICT NAMES
districts <- as.list(gsub( "_.{3}_fldas_daily_20100101-20170724.txt", "", links ))
districts <- gsub("_", " ", districts)
districts <- districts[6:length(districts)]


# ADD COLUMN FOR DISTRICT NAMES
d <- Map(cbind, d, District = districts)

# COMBINE DATE
for (i in seq_along(d)){
  d[[i]]$longDate <- as.Date(paste(d[[i]]$year, d[[i]]$mo, d[[i]]$day, sep = "/"), format = "%Y/%m/%d")
}



# package called epiweek
# use paste function to combine the date to do as.date
# then use epiweek to create weeks
# so you do sum or average over for the weeks, 
# so that it binds to other data
# sum rain, average of other vars

# delete any non-matching data
# don't deal with missing data
# do na.omit 

