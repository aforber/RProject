#--------------------------
# R PYTHON FINAL PROJECT
# ALYSSA FORBER
# CREATED DEC 4 2017
#-------------------------

rm(list=ls())

dat <- read.csv('/Users/alyssaforber/Documents/Denver/Fall2017/RPython/RProject/MergedData.csv', header=T)


# MAKE DATE COLUMN

dat$time <- (dat$Epiyear-2009)*12 + dat$Epiweek

# MAKE DIFFERNCE FROM INTERVENTION TO CURRENT DATA

n.distcode <- length(unique(dat$DISTCODE))
unique.distcode <- unique(dat$DISTCODE)

for (i in 1:n.distcode)


# MAKE DECAY FOR ITN

enddf <- NULL

for (j in levels(dat$District)){
  df <- subset(dat, dat$District %in% j)
  timeITN <- df$time[df$ITN==1]
  df[,"decayITN"] <- NA
  
  # for only one interevention 
  if (length(timeITN)==1){
    
    # if it's before
    for (i in 1:dim(df)[1]){
      if (df[i,]$time >= timeITN){
        df[i,]$decayITN <- df[i,]$time - timeITN
      }
    }
    
  # for when there are two intervention
  } else if (length(timeITN)==2){
    for (i in 1:dim(df)[1]){
      if (df[i,]$time >= timeITN[1] & df[i,]$time < timeITN[2]){
        # if it's after the first
        df$decayITN <- df[i,]$time - timeITN[1] 
      } else if (df[i,]$time >= timeITN[2]){
        # if it's after the second
        df$decayITN <- df[i,]$time - timeITN[2]
      } else{
        
      } 
    }
  } else{
    
  }
  enddf <- rbind(enddf, df)
} 
  
  



# MULTIPLY DIFFERENCE BY RATE OF DECAY FOR EACH INTERVENTION





# SORT
#dat2 <- dat[with(dat, order("District", "Epiyear", "Epiweek")),]
#dat3 <- arrange(dat, Epiyear, Epiweek)
#dat4 <- with(dat, dat[order(DISTCODE, Epiyear, Epiweek),])


# IRS PROTECTION (spray)
# 75% protection 6 months after the start
# 1 at 0 weeks, .75 at 24 weeks 
# (0.01041667 decrease each week)

# ITN PROTECTION (nets)
# 60% protective 96 months after the start
# (0.004166667 decrease each week)


