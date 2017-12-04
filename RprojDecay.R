#--------------------------
# R PYTHON FINAL PROJECT
# ALYSSA FORBER
# CREATED NOV 15 2017
#-------------------------

data <- read.csv('/Users/alyssaforber/Documents/Denver/Fall2017/RPython/RProject/MergedData.csv', header=T)



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
