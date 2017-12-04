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

# EXPORT NEW DATA
write.csv(dat, '/Users/alyssaforber/Documents/Denver/Fall2017/RPython/RProject/MergedData.csv')



#-----------------
# CREATE NEW VARS
#-----------------

# INCIDENCE
dat$incid <- dat$cases/dat$u5total*1000


# SORT
dat2 <- dat[with(dat, order("District", "Epiyear", "Epiweek")),]
dat3 <- arrange(dat, Epiyear, Epiweek)
dat4 <- with(dat, dat[order(DISTCODE, Epiyear, Epiweek),])
# these I think are all working, I just only have one observation
# for each district, which does not seems right and is inter's fault


# IRS PROTECTION (spray)
# 75% protection 6 months after the start
# 1 at 0 weeks, .75 at 24 weeks 
# (0.01041667 decrease each week)

# ITN PROTECTION (nets)
# 60% protective 96 months after the start
# (0.004166667 decrease each week)


#----------------
### QUESTIONS 11.27
# 1. I merged off of ITN week and year because IRS had so much missing,
# was that right??? 

# 2. Do we need to do a regression?
# From description it seems like just 
# "exploratory analysis figures, mapsof incidence, and explore, 
# at the very least, basic rela-tionships between the independent 
# variables and the outcome"
# but no mention of an actual model...


#----------------
# EXPLORE DATA
#----------------

plot(dat$District)
plot(dat$raint ~ dat$Epiyear)

hist(dat$Epiweek)
hist(dat$Epiyear)

hist(dat$DISTCODE.x)

# don't know what this var is
plot(dat$SQKM)
hist(dat$SQKM)

plot(dat$Province)

plot(dat$Region)

hist(dat$u5total)

plot(dat$XCOORD)
hist(dat$XCOORD)
hist(dat$YCOORD)


hist(dat$IRSyear)
hist(dat$IRSepiWeek)

# would think this to be more continuous 
plot(dat$raint)
hist(dat$raint)

plot(dat$tavg)
hist(dat$tavg)

plot(dat$rh)
hist(dat$rh)

plot(dat$sd)
hist(dat$sd)

plot(dat$psfc)
hist(dat$psfc)

plot(dat$cases)


#----------------
# RELATIONSHIPS
#----------------

# WEATHER DATA

# see relationship here
plot(dat$rh ~ dat$tavg)
plot(dat$rh ~ dat$raint)
plot(dat$rh ~ dat$psfc)
# see relationship here
plot(dat$rh ~ dat$sd)

plot(dat$raint ~ dat$tavg)
plot(dat$raint ~ dat$psfc)
plot(dat$raint ~ dat$sd)

# see realtionship here
plot(dat$tavg ~ dat$sd)
# see relationship here
plot(dat$tavg ~ dat$psfc)
# some relationship here
plot(dat$psfc ~ dat$sd)

# no weather differences by Region
boxplot(dat$raint ~ dat$Province)
boxplot(dat$raint ~ dat$Region)
boxplot(dat$tavg ~ dat$Region)
boxplot(dat$tavg ~ dat$Province)
boxplot(dat$sd ~ dat$Region)
boxplot(dat$sd ~ dat$Province)
boxplot(dat$rh ~ dat$Region)
boxplot(dat$rh ~ dat$Province)
boxplot(dat$psfc ~ dat$Region)
boxplot(dat$psfc ~ dat$Province)

# see case difference by providence
boxplot(dat$cases ~ dat$Province)
boxplot(dat$cases ~ dat$Region)




# cases with weather 
plot(dat$cases ~ dat$raint)
plot(dat$cases ~ dat$tavg)
plot(dat$cases ~ dat$sd)
plot(dat$cases ~ dat$rh)
plot(dat$cases ~ dat$psfc)

plot(dat$cases ~ dat$Epiweek)

plot(dat$cases[dat$Epiyear==2011] ~ dat$Epiweek[dat$Epiyear==2011])
plot(dat$cases[dat$Epiyear==2012] ~ dat$Epiweek[dat$Epiyear==2012])
plot(dat$cases[dat$Epiyear==2013] ~ dat$Epiweek[dat$Epiyear==2013])
plot(dat$cases[dat$Epiyear==2014] ~ dat$Epiweek[dat$Epiyear==2014])
plot(dat$cases[dat$Epiyear==2015] ~ dat$Epiweek[dat$Epiyear==2015])
plot(dat$cases[dat$Epiyear==2016] ~ dat$Epiweek[dat$Epiyear==2016])


#------------
# GRAPHICS
#------------

# (histograms, splines, etc), mapsof incidence (by district, across years, etc) 
# and explore, at the very least, basic relationships between the independent 
# variables and the outcome (malaria incidence)

#-------------------
# MERGE SPATIAL DATA
#-------------------

# get rownames to match
# can't have duplicates though...
# which means I have to only look at once instance (week)
# but that's not very informative..?
rownames(dat) <- dat$DISTCODE
# sp package # allows you to create your own spatial poly data frame
polydat <- SpatialPolygonsDataFrame(poly, dat)

#--------------------------------------------
# FROM NOTES10.17.17&SPATIALGRAPHICS
# Basic Mozambique Map for total rainfall, 2016 week 8
spplot(polydat, "rainTot", main = "Rainfall total", sub = "2016 week 8")

#display.brewer.all()

my.palette <- brewer.pal(n = 7, name = "YlGnBu") # want yellow, green, blue color palette
# Different color scheme and cuts
spplot(polydat, "rainTot", col.regions = my.palette, cuts = 6, col = "transparent", main = "Rainfall total", sub = "2016 week 8")

# Temperature
colours <- rainbow(6, start=0, end=1/6) # 6 colors, stopping at 1/6 makes a heat map
# since it doesn't get to go all the way through the rainbow
cols <- rev(colours)
spplot(polydat, "tavg", col.regions = cols, cuts = 5, main = "Ave temperature 2016 week 8")


# MULTIPLE #
#tempPal <- brewer.pal(n = 6, name = "YlOrRd")
rainPal <- brewer.pal(n = 6, name = "YlGnBu")
#rhPal <- brewer.pal(n = 6, name = "BuPu")
#sdPal <- brewer.pal(n = 6, name = "Greens")

#trellis.par.set(sp.theme(regions=list(col = rainPal)))
spplot(polydat, c("tavg", "rainTot", "rh", "sd"), names.attr = c("Ave temp", "Total rain", "Rel Humidity", 
                                                                 "Saturation Pressure Deficit"), 
       colorkey=list(space="right"), scales = list(draw = TRUE), main = "Mozambique weather, Week 8, 2016", 
       as.table = TRUE, cuts=5, col.regions = rainPal)
#------------------------------------------------



# plot from https://stackoverflow.com/questions/29974535/dates-with-month-and-day-in-time-series-plot-in-ggplot2-with-facet-for-years
p <- ggplot(data=dat, mapping=aes(x=Epiweek, y=raint, shape=as.factor(Epiyear), color=as.factor(Epiyear))) + 
  geom_point() +geom_line(aes(group = 1))
p <- p + facet_grid(facets = as.factor(Epiyear) ~ ., margins = FALSE) + theme_bw()
p

# be cool to add cases to this

# also how to account for districts?


#----------------
# REGRESSION?
#----------------

# describe the temporal and spatial variation in these data  
# and to draw conclusions about the relationships between the variables.

