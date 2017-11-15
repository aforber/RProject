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

# GET WEEKS
library(data.table)

for (i in seq_along(d)){
  d[[i]]$Epiweek <- week(d[[i]]$longDate)
}

# AVERAGE BY WEEK FOR ALL VARS, EXCEPT SUM RAINT
byweek <- NULL
for (i in seq_along(d)){
  byweek[[i]] <- data.table(d[[i]])[, list(raint = sum(raint), tavg=mean(tavg), rh= mean(rh), 
                                           sd=mean(sd), psfc= mean(psfc), District=District), 
                                    by=list(year, Epiweek)]
}
# this is not doing what it should


library(plyr)
byweek2 <- NULL
for (i in seq_along(d)){
  byweek2[[i]] <- ddply(d[[i]], .(Epiweek, year), summarize,  raint = sum(raint), tavg=mean(tavg), rh= mean(rh), 
        sd=mean(sd), psfc= mean(psfc), District=District)
}

# this did what I want
byweek2 <- NULL
for (i in seq_along(d)){
  byweek2[[i]] <- ddply(d[[i]], .(Epiweek, year), summarize,  raint = sum(raint), tavg=mean(tavg), rh= mean(rh), 
                        sd=mean(sd), psfc= mean(psfc), District)
}

# ADD COLUMN FOR DISTRICT NAMES
byweek2 <- Map(cbind, byweek2, District = districts)




ddply(mtcars, .(am, cyl), summarize, mpg_mean = mean(mpg))
sur_case <- as.data.frame(round(ddply(post_sur, .(month), summarize, Total_mean = mean(Total.Positive), Total_sd = sd(Total.Positive),
                                      Under5_mean = mean(malaria_blood_smear_tests_positive_under_5yrs), 
                                      Under5_sd = sd(malaria_blood_smear_tests_positive_under_5yrs),
                                      Over5_mean = mean(malaria_blood_smear_tests_positive_5yrs_plus),
                                      Over5_sd = sd(malaria_blood_smear_tests_positive_5yrs_plus)), digits = 2))




# MAKE IT A DATATABLE (not sure if I need to?)
byweekdf <- NULL
for (i in seq_along(byweek)){
  byweekdf[[i]] <- as.data.frame(byweek[[i]])
}



# delete any non-matching data
# don't deal with missing data
# do na.omit 

