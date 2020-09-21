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
par(mfrow=c(4,3))

for (i in 1:12){
  
  data <- load.data.dt.dcast[Month == i, ]
  
  y <- data[,Load]
  plot(y, ylim = c(0,10000))
  print(adf.test((y)))
}

par(mfrow=c(1,1))
x <- ts(load.data.dt.dcast[ , Load], frequency = 24*365)
plot.ts(x)
x_decomp <- decompose(x)
plot(x_decomp)

x_trend <- x_decomp$trend %>% as.data.table
x_trend.test <- x_trend[!is.na(x),]
  acf(x_trend.test)
  pacf(x_trend.test)
  adf.test(ts(x_trend.test, frequency = 24))
  
x_seasonal <- x_decomp$seasonal %>% as.data.table
x_seasonal.test <- x_seasonal[!is.na(x),]
  acf(x_seasonal.test)
  pacf(x_seasonal.test)  
  adf.test(x_decomp$seasonal)

  
x_random <- x_decomp$random %>% as.data.table
x_random.test <- x_random[!is.na(x),]
  acf(x_random.test)
  pacf(x_random.test)

auto.arima(x_random.test)    
