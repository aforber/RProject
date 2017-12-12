#--------------------------
# R PYTHON FINAL PROJECT
# ALYSSA FORBER
# CREATED DEC 4 2017
#-------------------------

rm(list=ls())
library(maptools)

library(ggplot2)
library(VIM)

library(RColorBrewer)
library(sp)
library(lattice)
library(latticeExtra) # For layer()

dat <- read.csv('/Users/alyssaforber/Documents/Denver/Fall2017/RPython/RProject/FinalData3.csv', header=T)
poly <- readShapePoly('/Users/alyssaforber/Documents/Denver/Fall2017/RPython/Moz_admin2.shp', IDvar="DISTCODE")


#----------------
# EXPLORE DATA
#----------------

plot(dat$District)
plot(dat$raint ~ dat$Epiyear)

hist(dat$Epiweek)
hist(dat$Epiyear)

plot(dat$Province)

plot(dat$Region)

hist(dat$u5total)

plot(dat$XCOORD)
hist(dat$XCOORD)
hist(dat$YCOORD)

hist(dat$IRSyear)
hist(dat$IRSepiWeek)

plot(dat$raint2)
hist(dat$raint2)

plot(dat$tavg4)
hist(dat$tavg4)

plot(dat$rh8)
hist(dat$rh8)

plot(dat$sd8)
hist(dat$sd8)

plot(dat$psfc2)
hist(dat$psfc2)

hist(dat$cases)

#----------------
# RELATIONSHIPS
#----------------

# WEATHER DATA

plot(dat$rh8 ~ dat$tavg4)
plot(dat$rh8 ~ dat$raint2)
plot(dat$rh8 ~ dat$psfc2)

plot(dat$rh8 ~ dat$sd8, xlab="Saturation Vapor Pressure (mmHg)", ylab="Relative Humidity (%)",
     main="Humidity and Vapor Pressure", pch=20)

plot(dat$raint2 ~ dat$tavg)
plot(dat$raint2 ~ dat$psfc2)
plot(dat$raint2 ~ dat$sd8)

# see realtionship here
plot(dat$tavg4 ~ dat$sd8)
# see relationship here
plot(dat$tavg4 ~ dat$psfc2)
# some relationship here
plot(dat$psfc2 ~ dat$sd8)

# no weather differences by Region
boxplot(dat$raint2 ~ dat$Province)
boxplot(dat$raint2 ~ dat$Region)
boxplot(dat$tavg4 ~ dat$Region)
boxplot(dat$tavg4 ~ dat$Province)
boxplot(dat$sd8 ~ dat$Region)
boxplot(dat$sd8 ~ dat$Province)
boxplot(dat$rh8 ~ dat$Region)
boxplot(dat$rh8 ~ dat$Province)
boxplot(dat$psfc2 ~ dat$Region)
boxplot(dat$psfc2 ~ dat$Province)

# see case difference by providence
boxplot(dat$cases ~ dat$Province, cex.axis = .65,
        xlab="Province", ylab="Cases of Malaria",
        main="Malaria Cases by Province", col="lavenderblush2")

boxplot(dat$cases ~ dat$Region)


# cases with weather 
plot(dat$cases ~ dat$raint2)
plot(dat$cases ~ dat$tavg4)
plot(dat$cases ~ dat$sd8)
plot(dat$cases ~ dat$rh8)
plot(dat$cases ~ dat$psfc2)

plot(dat$cases ~ dat$Epiweek)

plot(dat$cases[dat$Epiyear==2011] ~ dat$Epiweek[dat$Epiyear==2011])
plot(dat$cases[dat$Epiyear==2012] ~ dat$Epiweek[dat$Epiyear==2012])

plot(dat$cases[dat$Epiyear==2013] ~ dat$Epiweek[dat$Epiyear==2013], 
     pch=20, xlab="Weeks of 2013", ylab="Malaria Cases", 
     main="Malaria Cases over 2013", xaxt="n")
axis(1, at = seq(0, 52, by = 4), las=2)

plot(dat$cases[dat$Epiyear==2014] ~ dat$Epiweek[dat$Epiyear==2014])
plot(dat$cases[dat$Epiyear==2015] ~ dat$Epiweek[dat$Epiyear==2015])
plot(dat$cases[dat$Epiyear==2016] ~ dat$Epiweek[dat$Epiyear==2016])


#------------
# GRAPHICS
#------------

# (histograms, splines, etc), mapsof incidence (by district, across years, etc) 
# and explore, at the very least, basic relationships between the independent 
# variables and the outcome (malaria incidence)

dat$psfc22 <- scale(dat$psfc2)
dat$sd88 <- scale(dat$sd8)
dat$tavg44 <- scale(dat$tavg4)
dat$raint22 <- scale(dat$raint2)
dat$rh88 <- scale(dat$rh8)
dat$cases0 <- scale(dat$cases)

dat2 <- dat[complete.cases(dat[ , 13]),]

plot(smooth.spline(dat$Epiweek, dat$raint22), type="l", col="blue", ylim=c(-3,2.1), xlab="Epidemiology week", 
     ylab="Standard deviations", main = "Normalized Cases and Lagged Weather", lwd=2)
lines(smooth.spline(dat$Epiweek, dat$tavg44), type="l", col="red", lwd=2)
lines(smooth.spline(dat$Epiweek, dat$sd88), type="l", col="purple", lwd=2)
lines(smooth.spline(dat2$Epiweek, dat2$cases0), type="l", col="green4", lwd=3,lty=2)
lines(smooth.spline(dat$Epiweek, dat$psfc22), type="l", col="deepskyblue", lwd=2)
legend(10, -1.5, c("Rain lag 2", "Ave temp lag 4", "Rel Hum lag 8","Pressure lag 2" ,"Cases"), 
       text.col = c("blue", "red", "purple", "deepskyblue", "green4"), 
       cex = .9, bty = "n")


plot(smooth.spline(dat2$Epiweek, dat2$cases), type="l", col="deepskyblue", xlab="Epidemiology week", 
     ylab="Standard deviations", main = "Normalized Cases and Lagged Weather", lwd=2)


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

