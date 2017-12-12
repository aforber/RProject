#--------------------------
# R PYTHON FINAL PROJECT
# ALYSSA FORBER
# CREATED DEC 5 2017
#-------------------------

rm(list=ls())

dat <- read.csv('/Users/alyssaforber/Documents/Denver/Fall2017/RPython/RProject/FinalData3.csv', header=T)

library(lme4)
library(nlme)

# WHICH LAG TO USE

# RAIN = 2
cor.test(dat$cases, dat$raint2)
cor.test(dat$cases, dat$raint4)
cor.test(dat$cases, dat$raint8)

# TAVG = 4 (BARELY)
cor.test(dat$cases, dat$tavg2)
cor.test(dat$cases, dat$tavg4)
cor.test(dat$cases, dat$tavg8)

# RH = 8
cor.test(dat$cases, dat$rh2)
cor.test(dat$cases, dat$rh4)
cor.test(dat$cases, dat$rh8)

# SD = 8
cor.test(dat$cases, dat$sd2)
cor.test(dat$cases, dat$sd4)
cor.test(dat$cases, dat$sd8)

# PSFC = 2
cor.test(dat$cases, dat$psfc2)
cor.test(dat$cases, dat$psfc4)
cor.test(dat$cases, dat$psfc8)

# these two might give colinearity issues
plot(dat$sd8, dat$rh8)
cor.test(dat$sd8, dat$rh8)



mod1 <- glmer(cases ~ (1 | District),
              family="poisson", offset = log(u5total), data = dat)
summary(mod1)

mod2 <- glmer(cases ~ decayITN + decayIRS + (1 | District),
              family="poisson", offset = log(u5total), data = dat)
summary(mod2)

mod3 <- glmer(cases ~ decayITN + decayIRS + Region + (1 | District),
              family="poisson", offset = log(u5total), data = dat)
summary(mod3)


# JUST SCALING THE ONES I WANT TO USE
dat$psfc22 <- scale(dat$psfc2)
dat$sd88 <- scale(dat$sd8)
dat$tavg44 <- scale(dat$tavg4)
dat$raint22 <- scale(dat$raint2)
dat$rh88 <- scale(dat$rh8)


mod4 <- glmer(cases ~ decayITN + decayIRS + tavg44 + (1 | District),
              family="poisson", offset = log(u5total), data = dat)
summary(mod4)


# lowest AIC with all four weather vars
datLim <- subset(dat, DISTCODE!=1101)
datLim$District <- as.factor(datLim$District)
datLim$DISTCODE <- as.factor(datLim$DISTCODE)
# try as.factor(District)
mod5 <- glmer(cases ~ decayITN + decayIRS + tavg44 + raint22 + sd88 + psfc22 + (1 | DISTCODE),
              family="poisson", offset = log(u5total), data = datLim)
summary(mod5)
# they're could be influencial points, but that's beyond the scope of the class etc


## TRY TO RESCALE DECAY VARS
dat$decayIRS2 <- scale(dat$decayIRS)
dat$decayITN2 <- scale(dat$decayITN)

mod6 <- glmer(cases ~ decayITN2 + decayIRS2 + tavg44 + raint22 + sd88 + psfc22 + (1 | District),
              family="poisson", offset = log(u5total), data = dat, nAGQ=4)
summary(mod6)

#-----------------
## FINAL MODEL
#-----------------
# there is no fixing the issue, will use the scale weather vars
# and not change anything else
# and not scaling params because it doesn't add anything
# and just make interpreting more difficult


mod <- glmer(cases ~ decayITN + decayIRS + tavg4 + raint2 + rh8 + psfc2 + (1 | DISTCODE),
             family="poisson", offset = log(u5total), data = dat)
summary(mod) # AIC= 85666.7 

# MAKE ESTIMATE TABLE

est <- as.data.frame(summary(mod)$coef)
est$Lower <- est$Estimate -1.96*est$`Std. Error`
est$Upper <- est$Estimate +1.96*est$`Std. Error`
est <- round(est[,c(1,5:6,4)], digits=4)
rownames(est) <- c("Intercept", "ITN Decay", "IRS Decay", "Temperature", "Rainfall",
                   "Relative Humididy", "Barometric Pressure")

write.csv(est, '/Users/alyssaforber/Documents/Denver/Fall2017/RPython/RProject/Estimates.csv')
