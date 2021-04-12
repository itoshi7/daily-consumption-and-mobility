library(tidyverse)
library(lubridate)

apple_data <- read_csv("data/apple.csv")

apple_data_jp <- apple_data %>% 
  filter(
    country == "Japan",
    region %in% c("Tokyo (Prefecture)", "Osaka Prefecture")
  ) %>% 
  rbind(
    apple_data %>% filter(region == "Japan")
  ) %>% 
  filter(transportation_type == "transit") %>% 
  select(
    -geo_type, -alternative_name, -`sub-region`, -country, -transportation_type
  ) %>% 
  gather(date, value, -region) %>% 
  mutate(date = lubridate::date(date))

apple_data_jp_lag_1year <- apple_data_jp %>% 
  mutate(date = date + days(364)) %>% 
  rename(value_past = value)

apple_data_jp_add_past <- apple_data_jp %>% 
  left_join(apple_data_jp_lag_1year) %>% 
  mutate(value_change = value/value_past * 100)

label_converter_df <- tibble(
  region = c("Japan", "Tokyo (Prefecture)", "Osaka Prefecture"),
  region_ja = c("日本全体", "東京都", "大阪府")
)

graph_3 <- apple_data_jp_add_past %>% 
  filter(
    date >=date("2021-01-13")
  ) %>% 
  left_join(label_converter_df) %>% 
  ggplot(aes(x = date, y = value_change, color = region_ja))+
  geom_line()+
  ylab("52週間前が100")+
  xlab("2021年")+
  scale_x_date(
    date_labels = "%m/%d",
    date_breaks = "2 week"
  )+
  theme(
    legend.position = "bottom",
    legend.title = element_blank(),
    legend.background = element_rect(
      size=0.5, 
      linetype="solid", 
      colour ="black"
    )
  )


ggsave(filename = "result/g3.png", plot = graph_3, width = 6, height = 5)
