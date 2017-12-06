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


# JUST SCALING THE ONES I WANT TO USE
dat$psfc22 <- scale(dat$psfc2)
dat$sd88 <- scale(dat$sd8)
dat$tavg44 <- scale(dat$tavg4)
dat$raint22 <- scale(dat$raint2)

mod4 <- glmer(cases ~ decayITN + decayIRS + tavg44 + (1 | District),
              family="poisson", offset = log(u5total), data = dat)
summary(mod4)

# lowest AIC with all four weather vars
mod5 <- glmer(cases ~ decayITN + decayIRS + tavg44 + raint22 + sd88 + psfc22 + (1 | District),
              family="poisson", offset = log(u5total), data = dat)
summary(mod5)

# TRY TO ASSES CONVERGENCE 
# check singularity- fine
diag.vals <- getME(mod5,"theta")[getME(mod5,"lower") == 0]
any(diag.vals < 1e-6)

#recompute gradient and Hessian with Richardson extrapolation
devfun <- update(mod5, devFunOnly=TRUE)
if (isLMM(mod5)) {
  pars <- getME(mod5,"theta")
} else {
  ## GLMM: requires both random and fixed parameters
  pars <- getME(mod5, c("theta","fixef"))
}
if (require("numDeriv")) {
  cat("hess:\n"); print(hess <- hessian(devfun, unlist(pars)))
  cat("grad:\n"); print(grad <- grad(devfun, unlist(pars)))
  cat("scaled gradient:\n")
  print(scgrad <- solve(chol(hess), grad))
}
## compare with internal calculations:
mod5@optinfo$derivs

#restart the fit from the original value (or
## a slightly perturbed value):
mod5.restart <- update(mod5, start=pars)


