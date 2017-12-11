#RProject


## In this folder:

#### Code:

RprojData is the code for taking and cleaning the weather data off the url and exporting it.

RprojMerge is the code for merging all the datasets.

RprojDecay is the code for creating the decay variables.

RprojModel is the code for running the Poisson regression.

RprojExplore is the code for creating plots and graphics.

#### Files:

CleanWeather is the output from RprojData of just the cleaned weather data.

MergedData is the merged data before decay variables.

FinalData is the data after adding the decay variables (there have been a few versions of this as I tweaked the decay code, 3 is the last one used for analysis).

Estimates is the output of the final regression model.

#### Report:

RprojReport is the write up for the project. 



## About the Project

In  this  project,  you  will  be  analyzing  weather  and  (simulated)  malaria  incidence  and(simulated) intervention data from Mozambique.  The objective of this project is to describe the  temporal  and  spatial  variation  in  these  data  and  to  draw  conclusions about the  relationships between the variables.  Information about malaria can be found on the Centers forDisease Control and Prevention’s website (https://www.cdc.gov/malaria/).The data for this project can be found in two places.  The weather data are here (http://rap.ucar.edu/staff/monaghan/colborn/mozambique/daily/v2/) and all other data arein the folder “FinalProject” on Canvas.  The “incidence.csv” data contain incidence data andother details of the districts. The “intervention.csv” data contain the intervention start timesfor various districts across the years of observation.  All data need to be merged together.Finally, the shapefile ending in .shp can be used to map attribute data.


year is the year 

mo is the month

day is the day 

raint(mm/d) is the daily rainfall in mm

tavg(C) is the daily average temperature in Celcius

rh(%) is the relative humidity in %

sd(mmHg) is  the  saturation  vapor  pressure  deficit  in  mm  of  mercury  (another  measure  of humidity)

psfc(hPa) is the surface barometric pressure (a general indicator of large-scale weather activity and exhibits a strong seasonal cycle

The district names are in the url’s for each climate file.  Those need to be saved so that you can create a district name variable that will allow you to merge these data to the other data sets. The intervention data can be assumed to be protective for specific periods of time.  For example, we can assume that the IRS (indoor residual spraying) variable has 75% protection 6 months  after  the  start  date.   
The  ITNs  (insecticide  treated  bednets)  are  thought  to  be 60% protective 24 months after the start date.  When merging these data, these coverages need to be applied to the subsequent weeks after the start week.  For simplicity,  you can assume a constant decrease per week to achieve the protection described above, where we can  assume  that  IRS  and  ITNs  start  with  100%  effectiveness  at  the  start  week.   If  you want to be more specific than this, here is a paper to help guide your assumptionshttps://www.ncbi.nlm.nih.gov/pmc/articles/PMC4644290/.Malaria tends to be related to weather (increased rainfall and warmer temperatures) in alagged fashion.  This is because there is a 7-14 day incubation period between exposure to aninfective bite by a mosquito and the onset of symptoms.  The incidence data today are likely related to exposure up to 14 days prior and the effects of weather and temperature, etc, are likely related to exposure at an uncertain time before that.  This time is typically thought to be 2, 4 or 8 weeks from the day the person showed up in the health center.  You are expectedto create the lagged variables and explore their relationships with malaria incidence.

