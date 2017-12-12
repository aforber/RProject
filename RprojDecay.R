#--------------------------
# R PYTHON FINAL PROJECT
# ALYSSA FORBER
# CREATED DEC 4 2017
#-------------------------

rm(list=ls())

dat <- read.csv('/Users/alyssaforber/Documents/Denver/Fall2017/RPython/RProject/MergedData2.csv', header=T)
# 4392 OBS
sum(dat$IRS)
#[1] 35
sum(dat$ITN)
#[1] 114

# MAKE DATE COLUMN

dat$time <- (dat$Epiyear-2009)*52 + dat$Epiweek

# MAKE DIFFERNCE FROM INTERVENTION TO CURRENT DATA

#-------------------- 
# MAKE DIFF FOR ITN
#-------------------- 

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

sum(enddf$IRS)
#[1] 35
sum(enddf$ITN)
#[1] 114

#------------------  
# DO AGAIN FOR IRS
#------------------ 

dat <- enddf
enddf2 <- NULL


for (j in levels(dat$District)){
  df <- subset(dat, dat$District %in% j)
  timeIRS <- df$time[df$IRS==1]
  df[,"decayIRS"] <- NA
  
  # for only one interevention 
  if (length(timeIRS)==1){
    
    # if it's before
    for (i in 1:dim(df)[1]){
      
      if (df[i,]$time >= timeIRS){
        df[i,]$decayIRS <- df[i,]$time - timeIRS

      }
    }
    
    # for when there are two intervention
  } else if (length(timeIRS)==2){
    for (i in 1:dim(df)[1]){
      
      if (df[i,]$time >= timeIRS[1] & df[i,]$time < timeIRS[2]){
        # if it's after the first
        df$decayIRS <- df[i,]$time - timeIRS[1]

      } else if (df[i,]$time >= timeIRS[2]){
        # if it's after the second
        df$decayIRS <- df[i,]$time - timeIRS[2]

      } else{
        
      } 
    }
  } else{
    
  }
  enddf2 <- rbind(enddf2, df)
} 

data <- enddf2


#-------------------
# MULTIPLY DIFFERENCE BY RATE OF DECAY 
#FOR EACH INTERVENTION AND SUBTRACT 1
#-------------------

# IRS PROTECTION (spray)
# 75% protection 6 months after the start
# 1 at 0 weeks, .75 at 24 weeks 
# (0.01041667 decrease each week)

# ITN PROTECTION (nets)
# 60% protective 96 months after the start
# (0.004166667 decrease each week)

# IRS 0.01041667 PER WEEK
data$decayIRS <- 1 - data$decayIRS*0.01041667

# ITN 0.004166667 PER WEEK
data$decayITN <- 1 - data$decayITN*0.004166667

# CHANGE ANY NEGATIVE VALUES TO 0
data$decayIRS <- ifelse(data$decayIRS<0, 0, data$decayIRS)
data$decayITN <- ifelse(data$decayITN<0, 0, data$decayITN)

# CHANGE ANY NA TO 0
data$decayIRS <- ifelse(is.na(data$decayIRS), 0, data$decayIRS)
data$decayITN <- ifelse(is.na(data$decayITN), 0, data$decayITN)


write.csv(data, '/Users/alyssaforber/Documents/Denver/Fall2017/RPython/RProject/FinalData4.csv')
