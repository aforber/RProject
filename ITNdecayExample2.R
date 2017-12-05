
rm(list = ls())

data <- read.csv('/Users/alyssaforber/Documents/Denver/Fall2017/RPython/intervention.csv', header=T)
data2 <- read.csv('/Users/alyssaforber/Documents/Denver/Fall2017/RPython/RProject/MergedData.csv', header=T)

# we have from 2010 week 9 to 2017 week 30

# IRS PROTECTION (spray)
# 75% protection 6 months after the start
# 1 at 0 weeks, .75 at 24 weeks 
# (0.01041667 decrease each week)

# ITN PROTECTION (nets)
# 60% protective 96 months after the start
# (0.004166667 decrease each week)
x.val <- (0:8)

y.val <- c(100,	93,	74,	50,	28,	12,	4,	1,	0)/100

f.eff <- splinefun(x.val,y.val,method="natural")


efficacy.net <- function(x) {
  if(x<0) stop("x cannot be negative")
  if(x>8) {
    return(0)
  } else {
    f.eff(x)
  }
}
efficacy.net <- Vectorize(efficacy.net,"x")

curve(efficacy.net(x),xlim=c(0,10))

#data$time <- (data$yr-2010)*12+data$mon
data$time1 <- (data$IRSyear-2012)*12 + data$IRSepiWeek
data$time2 <- (data$ITNyear-2009)*12 + data$ITNepiWeek

#data2$time <- (data2$Epiyear-2011)*12 + data2$Epiweek
#data2$time1 <- (data$IRSyear-2012)*12 + data$IRSepiWeek
#data2$time2 <- (data$ITNyear-2009)*12 + data$ITNepiWeek

n.distr <- length(unique(data2$DISTCODE))

# how to make postITN
data$postITN <- ifelse(is.na(data$time2), 0, 1)
#data2$postITN <- ifelse()
# how to make post IRS
data$postIRS <- ifelse(is.na(data$time1), 0, 1)

# don't know how this can incorporate when there are two interventions....
unique.distcode <- unique(data$DISTCODE)
for(i in 1:n.distr) {
  ind.i <- which(data$DISTCODE==unique.distcode[i])
  ind.ITN <- which(data[ind.i,]$postITN==1) 
  if(length(ind.ITN)>0) {
    ind.sort <- sort.list(data[ind.i,][ind.ITN,]$time2) # giving error (arg 1 is not a vector)
    min.t <- min(data[ind.i,][ind.ITN,][ind.sort,]$time2)
    data[ind.i,][ind.ITN,][ind.sort,]$postITN <- efficacy.net(data[ind.i,][ind.ITN,][ind.sort,]$time2-min.t)
  }
}



