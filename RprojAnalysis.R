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

dat <- read.csv('/Users/alyssaforber/Documents/Denver/Fall2017/RPython/RProject/MergedData.csv', header=T)
poly <- readShapePoly('/Users/alyssaforber/Documents/Denver/Fall2017/RPython/Moz_admin2.shp', IDvar="DISTCODE")

names(dat)
# SQKM are square kilometers
# u5total I think is population
# we want incidence so that is cases/1000 people

# The incidence data today are likelyrelated to exposure up to 14 days prior 
# and the effects of weather and temperature, etc, arelikely related to exposure 
# at an uncertain time before that.  This time is typically thought tobe 2, 4 or 8 
# weeks from the day the person showed up in the health center.  You are expected
# to create the lagged variables and explore their relationships with malaria incidence.


# we can assume that the IRS (indoor residual spraying) variable has 
# 75% protection 6  months  after  the  start  date.   The  ITNs  
# (insecticide  treated  bednets)  are  thought  to  be
# 60% protective 24 months after the start date.  
### No clue how to get the protection

#----------------
### QUESTIONS 11.27
# 1. I merged off of ITN week and year because IRS had so much missing,
# was that right? because then to do the lag of effect I feel like I'm 
# missing something. So I need to make two columns for the effectiveness
# for ITN and then IRS?
# and then I need to make columns that lag the weather/incidence
# but have to make an incidence column
# to make incidence column, I divide cases/population
# that is now cases/100, so then I multiply by 1000? 

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

# there are some duplicates it seems
plot(dat$cases[dat$Epiyear==2012 & dat$District=="PEMBA"] ~ dat$Epiweek[dat$Epiyear==2012  & dat$District=="PEMBA"])

# there seem to be too many for a week of the year
# wondering if my data is correct
(dat$cases[dat$Epiyear==2016])
count(dat$cases[dat$Epiyear==2016])

count(dat$Epiweek, dat$Epiyear, dat$District)



#------------
# GRAPHICS
#------------

# (histograms, splines, etc), mapsof incidence (by district, across years, etc) 
# and explore, at the very least, basic relationships between the independent 
# variables and the outcome (malaria incidence)




library(ggplot2)

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

