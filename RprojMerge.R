#--------------------------
# R PYTHON FINAL PROJECT
# ALYSSA FORBER
# CREATED NOV 15 2017
#-------------------------

rm(list=ls())

library(maptools) 
library(rgdal)
library(ggplot2)
library(VIM)

library(RColorBrewer)
library(sp)
library(lattice)
library(latticeExtra) # For layer()

#------------
# LOAD DATA
#------------

inter <- read.csv('/Users/alyssaforber/Documents/Denver/Fall2017/RPython/intervention.csv', header=T)
incid <- read.csv('/Users/alyssaforber/Documents/Denver/Fall2017/RPython/incidence.csv')
weath <- read.csv('/Users/alyssaforber/Documents/Denver/Fall2017/RPython/RProject/CleanWeather.csv', header=T)
poly <- readShapePoly('/Users/alyssaforber/Documents/Denver/Fall2017/RPython/Moz_admin2.shp', IDvar="DISTCODE")


#--------------
# LAG WEATHER
#--------------
weath$X <- NULL
# 2 weeks
weath2 <- weath
weath2$Epiweek <- weath2$Epiweek + 2
names(weath2) <- paste0(names(weath2), "2")
# 4 weeks
weath4 <- weath
weath4$Epiweek <- weath4$Epiweek + 4
names(weath4) <- paste0(names(weath4), "4")
# 8 weeks
weath8 <- weath
weath8$Epiweek <- weath8$Epiweek + 8
names(weath8) <- paste0(names(weath8), "8")

#----------------
# MERGE
#----------------

# Why don't the dates for the two interventions match up 
# for inter? I'm merging off the ITN dates because they
# are all there... 
# merging with inter makes us loose a bunch of data
# then we only have like one week for each district?

# MERGE INTER AND INCID
datf <- merge(incid, inter, by.x = c("Epiyear", "Epiweek", "DISTCODE"), 
              by.y = c("ITNyear", "ITNepiWeek", "DISTCODE"), all=T)

# MERGE WITH WEATHER2
dat <- merge(datf, weath2, by.x = c("District", "Epiweek", "Epiyear"), 
             by.y = c("District2", "Epiweek2", "year2"))
# MERGE WITH WEATHER4
dat <- merge(dat, weath4, by.x = c("District", "Epiweek", "Epiyear"), 
             by.y = c("District4", "Epiweek4", "year4"))
# MERGE WITH WEATHER8
dat <- merge(dat, weath8, by.x = c("District", "Epiweek", "Epiyear"), 
             by.y = c("District8", "Epiweek8", "year8"))

# I'm surprised there are no missing values since we lagged.
# That is suspicious

#---------------
# REMOVE NAS? 
#---------------

# missing data for SQKM, Province, Region, u5total, cases
# (keep NA for IRS week and year)
# maybe keep na for sqkm, province and region as well

summary(aggr(dat[,11:18]))

# only remove missing cases and populations
dat <- dat[!with(dat,is.na(cases) & is.na(u5total)),]


#-----------------
# CREATE INCIDENCE
#-----------------

# INCIDENCE
dat$incid <- dat$cases/dat$u5total*1000



# EXPORT NEW DATA
write.csv(dat, '/Users/alyssaforber/Documents/Denver/Fall2017/RPython/RProject/MergedData.csv')



#----------------
### QUESTIONS 11.27
# 1. I merged off of ITN week and year because IRS had so much missing,
# was that right??? 

# 2. Do we need to do a regression?
# From description it seems like just 
# "exploratory analysis figures, mapsof incidence, and explore, 
# at the very least, basic rela-tionships between the independent 
# variables and the outcome"

