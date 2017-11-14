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

# this is what they look like individually
zam <- read.table("http://rap.ucar.edu/staff/monaghan/colborn/mozambique/daily/v2/ALTO_MOLOCUE_ZAM_fldas_daily_20100101-20170724.txt",
                  skip=3, header = FALSE, sep ='', stringsAsFactors = FALSE, dec=".")
colnames(zam) <- c("year", "mo", "day", "raint", "tavg", "rh", "sd", "psfc")

#http://rap.ucar.edu/staff/monaghan/colborn/mozambique/daily/v2/

# reading this in is not straight forwards
#zam2 <- read.table("http://rap.ucar.edu/staff/monaghan/colborn/mozambique/daily/v2/")


# This creates the file paths! 
# we just need to extract a list of the district names

# PUT TOGETHER THE FILE PATHS FROM A LIST OF DISTRICT NAMES
g <-file.path("https:/", c("district1", "district2", "district3"))
h <- file.path(g, "fldas_daily_20100101-20170724.txt", fsep= "_")



# code from https://stackoverflow.com/questions/15954463/read-list-of-file-names-from-web-into-r
# EXTRACT ALL THE LINKS FOR EACH FILE
library(XML)
url <- "http://rap.ucar.edu/staff/monaghan/colborn/mozambique/daily/v2/"
doc <- htmlParse(url)
links <- xpathSApply(doc, "//a/@href")
free(doc)
links


wanted <- links[grepl("*_fldas_daily_20100101-20170724.txt", links)]
wanted <- links[grepl("Amelia_1\\.2.*", links)]
GetMe <- paste(url, wanted, sep = "")

# FUNCTION THAT READS TABLE CORRECTLY
myread <- function(f){
  read.table("f", skip=3, header = FALSE, sep ='', stringsAsFactors = FALSE, dec=".")
}

# get a list of data frames
d <- lapply(seq_along(GetMe), 
            function(x) read.table(GetMe[1], skip=3, header = FALSE, sep ='', stringsAsFactors = FALSE, dec="."))

for (i in seq_along(d)){
  colnames(d[[i]]) <- c("year", "mo", "day", "raint", "tavg", "rh", "sd", "psfc")
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

