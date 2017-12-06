#--------------------------
# R PYTHON FINAL PROJECT
# ALYSSA FORBER
# CREATED DEC 5 2017
#-------------------------

rm(list=ls())

dat <- read.csv('/Users/alyssaforber/Documents/Denver/Fall2017/RPython/RProject/FinalData.csv', header=T)

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




mod1 <- glmer(cases ~ (1 | District),
              family="poisson", offset = log(u5total), data = dat)
summary(mod1)

mod2 <- glmer(cases ~ decayITN + decayIRS + (1 | District),
              family="poisson", offset = log(u5total), data = dat)
summary(mod2)

mod3 <- glmer(cases ~ decayITN + decayIRS + Region + (1 | District),
              family="poisson", offset = log(u5total), data = dat)
summary(mod3)

# not able to converge when putting weather data in
# try to center and scale the vars?

# PSFC = 2 # SD = 8 # TAVG = 4 (BARELY) # RAIN = 2

dat$psfc22 <- scale(dat$psfc2)
dat$sd88 <- scale(dat$sd8)
dat$tavg44 <- scale(dat$tavg4)
dat$raint22 <- scale(dat$raint2)

mod4 <- glmer(cases ~ decayITN + decayIRS + tavg44 + (1 | District),
              family="poisson", offset = log(u5total), data = dat)

summary(mod4)

