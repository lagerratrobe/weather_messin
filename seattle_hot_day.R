# seattle_hot_day.R
library(arrow)
library(dplyr)
library(lubridate)

# Read in the weather data, filter it down to just Seattle and Sequim, select time, temp and precip columns,
# and create proper date and time objects.
df <- read_parquet("weather_data.parquet")

df %>% filter(stationID %in% c("KWASEATT2743", "KWASEQUI431")) %>% 
  transmute(stationID, 
         datetime = lubridate::ymd_hms(obsTimeLocal), 
         temp = imperial.temp, 
         precip = imperial.precipTotal) -> df

# Look for a day that has temps above 80 deg
df %>% filter(temp >= 80) %>% head()
# 2022-08-06

# Pick one of the hot days and check when in the day the peak temp is.

df %>% filter(datetime == ymd("2022-08-06"))
glimpse(df)
              