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

# MERGE INTER AND INCID

# SEPARATE INTERVENTION DATA TO MERGE EACH SEPARATELY
# ADD INDICATOR COLUMNS WHERE THERE WAS INTERVENTION
inter$IRS <- ifelse(is.na(inter$IRSyear), 0, 1)
inter$ITN <- ifelse(is.na(inter$ITNyear), 0, 1)
interITN <- inter[,c(1, 4:5,7)]
interIRS <- inter[,c(1:3,6)]

# MERGE EACH
datf <- merge(incid, interITN, by.x = c("Epiyear", "Epiweek", "DISTCODE"), 
              by.y = c("ITNyear", "ITNepiWeek", "DISTCODE"), all=T)
datf <- merge(datf, interIRS, by.x = c("Epiyear", "Epiweek", "DISTCODE"), 
              by.y = c("IRSyear", "IRSepiWeek", "DISTCODE"), all=T)

# CHANGE INTERVENTION COL NAS TO 0
datf$IRS <- ifelse(is.na(datf$IRS), 0, 1)
datf$ITN <- ifelse(is.na(datf$ITN), 0, 1)


# MERGE WITH WEATHER2
dat <- merge(datf, weath2, by.x = c("District", "Epiweek", "Epiyear"), 
             by.y = c("District2", "Epiweek2", "year2"))
# MERGE WITH WEATHER4
dat <- merge(dat, weath4, by.x = c("District", "Epiweek", "Epiyear"), 
             by.y = c("District4", "Epiweek4", "year4"))
# MERGE WITH WEATHER8
dat <- merge(dat, weath8, by.x = c("District", "Epiweek", "Epiyear"), 
             by.y = c("District8", "Epiweek8", "year8"))


#-----------------
# CREATE INCIDENCE
#-----------------

# INCIDENCE
dat$incid <- dat$cases/dat$u5total*1000

# REMOVE USELESS X COL
dat$X <- NULL


#-----------------
# EXPORT NEW DATA
#-----------------
write.csv(dat, '/Users/alyssaforber/Documents/Denver/Fall2017/RPython/RProject/MergedData.csv')


