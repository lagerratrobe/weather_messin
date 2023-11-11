library(dplyr)
library(lubridate)
library(arrow)
library(ggplot2)

df <- read_parquet("weather_data.parquet")
glimpse(df)

df <- df |> mutate(stationID, 
                   datetime = lubridate::ymd_hms(obsTimeLocal),
                   temp_F = imperial.temp,
                   precip = imperial.precipTotal,
                   .keep = "none") %>%
  filter(stationID %in% c("KWASEATT2743", "KWASEQUI431"))

# Find some days that get above 80
df |> filter(temp_F >= 80) |> head()

# Get one day that's got temps over 80
df |> filter(date(datetime) == '2022-08-06') -> hot_day
head(hot_day)

# Create a lineplot of temps on that day for just Seattle
hot_day <- hot_day %>% filter(stationID == "KWASEATT2743")

hot_day |> ggplot(aes(x=datetime, y=temp_F)) +
  geom_line() +
  scale_x_datetime(date_labels = "%H:%M") +
  geom_vline(xintercept=hot_day$datetime[15],color="red") +
  annotate("text", 
           x=hot_day$datetime[16], 
           y=60, 
           label=format(hot_day$datetime[15], "%H:%M"),
           color="red")
