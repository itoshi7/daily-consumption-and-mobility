library(tidyverse)

# FIES
fies_data <- read_csv("data/fies.csv")

fies_base <- fies_data %>% 
  filter(
    !is.na(date),
    year <= "2018-12-31"
  ) %>% 
  group_by(
    label, month, day
  ) %>% 
  summarise(
    base_value = mean(value)
  )


use_category <- c("外食", "交通")

fies_preprocessed <- fies_data %>% 
  filter(date >= "2019-11-01") %>% 
  left_join(fies_base, by = c("label", "day", "month")) %>% 
  mutate(
    value_change = value/base_value - 1
  ) %>% 
  filter(label %in% use_category) %>% 
  arrange(label, date)


write_csv(fies_preprocessed, "data/preprocessed_fies.csv")



# apple mobility


apple_data <- read_csv("data/apple.csv")

apple_data_japan <- apple_data %>% 
  filter(region == "Japan") %>% 
  select(-geo_type, -region, -(alternative_name:country)) %>% 
  gather(date, value, -transportation_type) %>% 
  mutate(date = as.Date(date)) %>% 
  spread(transportation_type, value)


write_csv(apple_data_japan, "data/preprocessed_apple.csv")


# google mobility


google_data <- read_csv("https://www.gstatic.com/covid19/mobility/Global_Mobility_Report.csv")

google_data_preprocessed <- google_data %>% 
  filter(country_region_code == "JP") %>% 
  filter(is.na(sub_region_1)) %>% 
  transmute(date, 
            google_retail_and_recreation = retail_and_recreation_percent_change_from_baseline,
            google_grocery= grocery_and_pharmacy_percent_change_from_baseline,
            google_park =parks_percent_change_from_baseline,
            google_station =transit_stations_percent_change_from_baseline,
            google_workplace=workplaces_percent_change_from_baseline,
            google_residential=residential_percent_change_from_baseline
  )


write_csv(google_data_preprocessed, "data/preprocessed_google.csv")
