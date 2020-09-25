# load_forecast

## Overview
This R script analyzes electric class load and generates a load forecast.  The data for this script was obtained from [here](http://www.bgs-auction.com/bgs.dataroom.asp).

The goal of the script is to generate a medium-term load forecast (6 months to 3 years). First, the script examines the time series property of the load.  Second, the script generates a load forecast using a combination of weather and independent variables.

## Dependencies

This script was developed in the RStudio environment and will require the following libraries to be installed:

* stats
* data.table
* lubridate
* readxl
* stringr
* car
* sandwich
* timeSeries
* tseries
* urca
* tidyr

## Status
This script is in the early stages of development.  

The first part of the script examines the original load for its time series structure.  We start with decomposing the observed load into a seasonal, trend, and random component. We also inspect the random component for evidence of a remaining structure in the residuals.

The following improvements/additionals to the code have not been implemented:
* Ensure that the data is complete for the period of investigation. This assurance includes:
  * No missing hours within the date-time period.
  * When data for an hour is missing, fill-in the missing data.
* Incorporate script to add weather data and generate dataset for regression.
* Develop regression model to forecast load.  Concepts to explore:
  * Additive or multiplicative?
  * Include a time series component?
  * How to include trends?
  * Daily or hourly model?

## License

The script is shared under the GNU GPLv3 license.
