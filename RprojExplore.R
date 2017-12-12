#--------------------------
# R PYTHON FINAL PROJECT
# ALYSSA FORBER
# CREATED DEC 4 2017
#-------------------------

rm(list=ls())
library(maptools)

library(RColorBrewer)
library(sp)


library(lattice)
library(latticeExtra) # For layer()

dat <- read.csv('/Users/alyssaforber/Documents/Denver/Fall2017/RPython/RProject/FinalData3.csv', header=T)
poly <- readShapePoly('/Users/alyssaforber/Documents/Denver/Fall2017/RPython/Moz_admin2.shp', IDvar="DISTCODE")
dat2 <- read.csv('/Users/alyssaforber/Documents/Denver/Fall2017/RPython/RProject/FinalData4.csv', header=T)


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
dat$decayIRS0 <- scale(dat$decayIRS)
dat$decayITN0 <- scale(dat$decayITN)

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

# just cases
plot(smooth.spline(dat2$Epiweek, dat2$cases), type="l", col="deepskyblue", xlab="Epidemiology week", 
     ylab="Standard deviations", main = "Normalized Cases and Lagged Weather", lwd=2)


# for one year and district look at intervention

dat$decayIRS0 <- ifelse(is.na(dat$decayIRS), 0, dat$decayIRS)
dat$decayITN0 <- ifelse(is.na(dat$decayITN), 0, dat$decayITN)
dat2 <- dat[complete.cases(dat[ , 13]),]

plot(smooth.spline(dat2$Epiweek[dat2$Epiyear==2016&dat2$DISTCODE==302], dat2$cases0[dat2$Epiyear==2016&dat2$DISTCODE==302]), 
     type="l", col="blue", ylim=c(-0.5,1.5), xlab="Epidemiology week", 
     ylab="Standard deviations", main = "Normalized Cases, IRS Intervention,
     & Rainfall for 2016 Angoche District", lwd=2)
lines(smooth.spline(dat2$Epiweek[dat2$Epiyear==2016&dat2$DISTCODE==302], dat2$decayIRS0[dat2$Epiyear==2016&dat2$DISTCODE==302]), 
      type="l", col="darkolivegreen3", lwd=2)
lines(smooth.spline(dat$Epiweek, dat$raint22,df=10), type="l", col="red", lwd=2)
legend(7, 0, c("Cases", "IRS Protection", "Rain lag 2"), 
       text.col = c("blue","green4", "red"), 
       cex = .9, bty = "n")


#-------------------
# MERGE SPATIAL DATA
#-------------------

week <- subset(dat, Epiyear==2013 & Epiweek==20)
rownames(week) <- week$DISTCODE
# sp package # allows you to create your own spatial poly data frame
polydat <- SpatialPolygonsDataFrame(poly, week)

#--------------------------------------------
# FROM NOTES10.17.17&SPATIALGRAPHICS


# Different color scheme and cuts
tempPal <- brewer.pal(n = 7, name = "YlOrRd")
spplot(polydat, "incid", col.regions = tempPal, cuts = 6, col = "transparent", main = "Malaria Incidene", sub = "2016 week 8")



# MULTIPLE #
#tempPal <- brewer.pal(n = 6, name = "YlOrRd")
rainPal <- brewer.pal(n = 6, name = "YlGnBu")
#rhPal <- brewer.pal(n = 6, name = "BuPu")
#sdPal <- brewer.pal(n = 6, name = "Greens")

#trellis.par.set(sp.theme(regions=list(col = rainPal)))
spplot(polydat, c("cases", "raint4","tavg2"), names.attr = c("Cases", "Total rain", "Ave temp"), 
       colorkey=list(space="right"), scales = list(draw = TRUE), main = "Mozambique weather, Week 20, 2013", 
       as.table = TRUE, cuts=5, col.regions = rainPal)


# plot from https://stackoverflow.com/questions/29974535/dates-with-month-and-day-in-time-series-plot-in-ggplot2-with-facet-for-years
p <- ggplot(data=dat, mapping=aes(x=Epiweek, y=cases,  color=as.factor(Epiyear))) + 
  geom_point() +geom_line(aes(group = 1))
p <- p + facet_grid(facets = as.factor(Epiyear) ~ ., margins = FALSE) + theme_bw()
p + labs(title = "Malaria Incidence by Year") + labs(y = "Malaria Incidence")

# JUST ONE DISTRICT TO MAKE IT EASIER
dat1 <- subset(dat, dat$District=="PEMBA")

p <- ggplot(data=dat1, mapping=aes(x=Epiweek, y=cases,  color=as.factor(Epiyear))) + 
  geom_point() +geom_line(aes(group = 1))
p <- p + facet_grid(facets = as.factor(Epiyear) ~ ., margins = FALSE) + theme_bw()
p + labs(title = "Malaria Incidence by Year in Pemba") + labs(y = "Malaria Incidence")

