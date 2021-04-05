library(tidyverse)
library(zoo)
library(patchwork)
theme_set(theme_bw())

eatingout_data <- read_csv("result/eatingout_output.csv")
transportaion_data <- read_csv("result/transportation_output.csv")



plot_fig_1 <- function(
  ms_data,
  title_input = "",
  ylab_input = "",
  date_labels_input = "%y/%m/%d",
  labels_input = scales::percent
){
  labdate <- ms_data %>% 
    filter(est_state != lag(est_state)) %>% 
    filter(is.na(lag(date))|difftime(date, lag(date))>5) %>% 
    .$date %>% 
    c(range(ms_data$date))
  
  
  ms_data %>% 
    ggplot(aes(x = date))+
    geom_line(aes(y = y), color = "black", size = 0.1, linetype = 1)+
    geom_line(aes(y = rollmean(y,7, na.pad=TRUE)), color = "red", size = 1)+
    geom_tile(
      aes(y = 0,
          height = 2,
          fill = est_state), 
      alpha = 0.3,
      linetype = 0
    )+
    coord_cartesian(xlim = range(ms_data$date), ylim = c(-1, 1),  expand = FALSE)+
    guides(fill = FALSE)+
    theme(
      panel.border = element_blank(),
      plot.title = element_text(hjust = 0.5),
      axis.text.x = element_text(angle = 45, hjust = 1)
    )+
    scale_y_continuous(labels = labels_input)+
    scale_x_date(
      date_labels = date_labels_input,
      breaks = labdate
    )+
    ylab(ylab_input)+
    xlab("")+ 
    scale_fill_manual(values=c("#FFFFFF", "#56B4E9"))+
    ggtitle(title_input)
}

p1_test <- plot_fig_1(
  ms_data = eatingout_data,
  title_input = "外食",
  ylab_input = "同月同日からの変化率"
)

p2_test <- plot_fig_1(
  ms_data = transportaion_data,
  title_input = "交通",
  ylab_input = ""
)

graph_1 <- p1_test+p2_test

graph_1

ggsave(filename = "result/g1.png", plot = graph_1, width = 8, height = 5)


##-----------------

apple_data <- read_csv("result/apple_transit_output.csv")

google_data <- read_csv("result/google_station_output.csv")

apple_labels <- apple_data%>% 
  filter(est_state != lag(est_state)) %>% 
  filter(is.na(lag(date))|difftime(date, lag(date))>5) %>% 
  .$date %>% 
  c(range(apple_data$date))

google_labels <- google_data%>% 
  filter(est_state != lag(est_state)) %>% 
  filter(is.na(lag(date))|difftime(date, lag(date))>5) %>% 
  .$date %>% 
  c(range(google_data$date))

m1 <- apple_data %>% 
  ggplot(aes(x = date))+
  geom_line(aes(y = y), color = "black", size = 0.1)+
  geom_line(aes(y = rollmean(y,7, na.pad=TRUE)), color = "red", size = 1)+
  geom_tile(
    aes(y = (max(y)+min(y))/2,
        height = (max(y)-min(y)),
        fill = est_state), 
    alpha = 0.3,
    linetype = 0
  )+
  coord_cartesian(xlim = range(apple_data$date), ylim = range(apple_data$y),  expand = FALSE)+
  guides(fill = FALSE)+
  theme(
    panel.border = element_blank(),
    plot.title = element_text(hjust = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )+
  scale_x_date(date_labels = "%y/%m/%d", 
               breaks = apple_labels
  )+
  scale_fill_manual(values=c("#FFFFFF", "#56B4E9"))+
  ylab("")+
  xlab("")+
  ggtitle("Apple モビリティデータ, 交通機関")


m2 <- google_data %>% 
  ggplot(aes(x = date))+
  geom_line(aes(y = y), color = "black", size = 0.1)+
  geom_line(aes(y = rollmean(y,7, na.pad=TRUE)), color = "red", size = 1)+
  geom_tile(
    aes(y = (max(y)+min(y))/2,
        height = (max(y)-min(y)),
        fill = est_state), 
    alpha = 0.3,
    linetype = 0
  )+
  coord_cartesian(xlim = range(google_data$date), ylim = range(google_data$y),  expand = FALSE)+
  guides(fill = FALSE)+
  theme(
    panel.border = element_blank(),
    plot.title = element_text(hjust = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )+
  scale_fill_manual(values=c("#FFFFFF", "#56B4E9"))+
  scale_x_date(date_labels = "%y/%m/%d", 
               breaks = google_labels
  )+
  ylab("")+
  xlab("")+
  ggtitle("Google モビリティデータ, 乗換駅")
 
graph_2 <- m1+m2
graph_2

ggsave(filename = "result/g2.png", plot = graph_2, width = 8, height = 5)
