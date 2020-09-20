library(stats)
library(data.table)
library(lubridate)
library(readxl)
library(magrittr)
library(stringr)
library(car)
library(sandwich)
library(lmtest)
library(timeSeries)
library(tseries)
library(urca)
library(tidyr)
library(zoo)
library(forecast)

####
#SET working directory
setwd("C:/R/Git Repo/projects_github/load_forecast/")

####
#DEFINE location of data
load.data.file.folder <- "Data/"
load.data.file.name  <- "Hist_PSEG_Total_Retail_Hourly_Load_1.99-6.20.csv"

####
#UPLOAD data
load.data.dt <- fread(paste(load.data.file.folder,load.data.file.name,sep = ""),
                      skip = 4,
                      header = TRUE,
                      colClasses = c("character",rep("numeric",24)))

#RESHAPE DATA
load.data.dt.dcast <- melt(load.data.dt,
                           id.vars = "Date",
                           variable.name = "HE",
                           value.name = "Load")
str(load.data.dt.dcast)
#REFORMAT data and add additional variables
load.data.dt.dcast[ , ":=" (Date = mdy(Date),
                            HE = as.numeric(gsub("Hour ","",HE)),
                            Load = as.numeric(Load))] %>% setorderv(.,cols = c("Date","HE"), order = 1)
load.data.dt.dcast[ , ":=" (Month = month(Date),
                            Year = year(Date),
                            Day = day(Date),
                            Weekday = weekdays(Date),
                            DATE.DMO = paste(year(Date),month(Date),1,sep="-"))]
load.data.dt.dcast[,Date.TS := parse_date_time(paste(Date,HE,sep = " "), order = "ymd H")]


#Graph Load
Load <- load.data.dt.dcast[,Load]

plot.ts(Load)
