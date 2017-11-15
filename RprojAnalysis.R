#--------------------------
# R PYTHON FINAL PROJECT
# ALYSSA FORBER
# CREATED NOV 15 2017
#-------------------------

rm(list=ls())

library(maptools) 
library(rgdal)

#------------
# LOAD DATA
#------------

weath <- read.csv('/Users/alyssaforber/Documents/Denver/Fall2017/RPython/RProject/CleanWeather.csv', header=T)
inter <- read.csv('/Users/alyssaforber/Documents/Denver/Fall2017/RPython/intervention.csv', header=T)
incid <- read.csv('/Users/alyssaforber/Documents/Denver/Fall2017/RPython/incidence.csv')
poly <- readShapePoly('/Users/alyssaforber/Documents/Denver/Fall2017/RPython/Moz_admin2.shp', IDvar="DISTCODE")


#------------
# MERGE
#------------

# MERGE INTER AND INCID
df <- merge(incid, inter, by.x = c("Epiyear", "Epiweek"), by.y = c("ITNyear", "ITNepiWeek"))

# added a Distcode.y but we want Distcode.x
df$DISTCODE.y <- NULL


# MERGE WITH WEATHER
dat <- merge(df, weath, by.x = c("District", "Epiweek", "Epiyear"), 
             by.y = c("District", "Epiweek", "year"))


# REMOVE NAS (keep NA for IRS week and year)
# missing data for SQKM, Province, Region, u5total, cases
library(VIM)
summary(aggr(dat))

dat <- dat[complete.cases(dat[, c(1:11, 14:19)]),]


# EXPORT NEW DATA
write.csv(dat, '/Users/alyssaforber/Documents/Denver/Fall2017/RPython/RProject/MergedData.csv')


# delete any non-matching data
# don't deal with missing data
# do na.omit 


#------------
# GRAPHICS
#------------

# (histograms, splines, etc), mapsof incidence (by district, across years, etc) 
# and explore, at the very least, basic relationships between the independent 
# variables and the outcome (malaria incidence)


#----------------
# RELATIONSHIPS
#----------------



#----------------
# REGRESSION?
#----------------

# describe the temporal and spatial variation in these data  
# and to draw conclusions about the relationships between the variables.

