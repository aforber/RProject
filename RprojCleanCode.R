#--------------------------
# R PYTHON FINAL PROJECT
# ALYSSA FORBER
# CREATED NOV 14 2017
#-------------------------

rm(list=ls())

library(maptools) 
library(data.table)
library(XML)


#-----------
# READ DATA
#-----------

inter <- read.csv('/Users/alyssaforber/Documents/Denver/Fall2017/RPython/intervention.csv', header=T)
incid <- read.csv('/Users/alyssaforber/Documents/Denver/Fall2017/RPython/incidence.csv')
poly <- readShapePoly('/Users/alyssaforber/Documents/Denver/Fall2017/RPython/Moz_admin2.shp', IDvar="DISTCODE")


#----------------------
# READ FILES FROM URL
#----------------------


# code from https://stackoverflow.com/questions/15954463/read-list-of-file-names-from-web-into-r

# EXTRACT ALL THE LINKS FOR EACH FILE
url <- "http://rap.ucar.edu/staff/monaghan/colborn/mozambique/daily/v2/"
doc <- htmlParse(url)
links <- xpathSApply(doc, "//a/@href")
#free(doc)
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
for (i in seq_along(d)){
  d[[i]]$Epiweek <- week(d[[i]]$longDate)
}


# AVERAGE BY WEEK FOR ALL VARS, EXCEPT SUM RAINT
byweek <- NULL
for (i in seq_along(d)){
  byweek[[i]] <- ddply(d[[i]], .(Epiweek, year), summarize,  raint = sum(raint), tavg=mean(tavg), rh= mean(rh), 
                        sd=mean(sd), psfc= mean(psfc))
}


# ADD COLUMN FOR DISTRICT NAMES
byweek <- Map(cbind, byweek, District = districts)


# MAKE IT A DATAFRAME (not sure if I need to?)
byweekdf <- NULL
for (i in seq_along(byweek)){
  byweekdf[[i]] <- as.data.frame(byweek[[i]])
}


# MAKE LIST OF DATAFRAMES ONE DATAFRAME
weath <- do.call("rbind", byweekdf)


# EXPORT TO CSV TO EASILY READ IN
write.csv(weath, '/Users/alyssaforber/Documents/Denver/Fall2017/RPython/RProject/CleanWeather.csv')


#----------------
# MERGE
#----------------

# MERGE INTER AND INCID
datf <- merge(incid, inter, by.x = c("Epiyear", "Epiweek"), by.y = c("ITNyear", "ITNepiWeek"))

# added a Distcode.y but we want Distcode.x
datf$DISTCODE.y <- NULL


# MERGE WITH WEATHER
dat <- merge(datf, weath, by.x = c("District", "Epiweek", "Epiyear"), 
             by.y = c("District", "Epiweek", "year"))


# REMOVE NAS (keep NA for IRS week and year)
# missing data for SQKM, Province, Region, u5total, cases
library(VIM)
summary(aggr(dat))

dat <- dat[complete.cases(dat[, c(1:11, 14:18)]), ]


# EXPORT NEW DATA
write.csv(dat, '/Users/alyssaforber/Documents/Denver/Fall2017/RPython/RProject/MergedData.csv')


# CLEAN WORKSPACE
rm(byweek, byweekdf, d, districts, doc, GetMe, i, links, url, wanted)
