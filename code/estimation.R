library(tidyverse)
library(MSwM)
library(mltools)
library(data.table)


estimation <- function(
  data_date,
  data_target,
  dir_name = "output/test"
){
  
  target_data <- 
    tibble(
      date = data_date,
      y = data_target
    ) %>% 
    arrange(date) %>% 
    mutate(
      day_of_week = as.factor(lubridate::wday(date))
    ) %>% 
    na.omit() %>% 
    as.data.table() %>% 
    one_hot() %>% 
    as_tibble()
  
  # note: day_of_week == 1 is Sunday, day_of_week == 2 is Munday, and so on
  
  estimate_ms_model <- function(target_data_){
    mod_lm <- lm(
      y ~ 1+day_of_week_2+day_of_week_3+day_of_week_4+day_of_week_5+day_of_week_6+day_of_week_7,
      data = target_data_
    )
    
    mod_ms <- MSwM::msmFit(
      mod_lm,
      k = 2,
      sw = c(TRUE, rep(FALSE, 6), FALSE),
      p = 0,
      control=list(parallel=FALSE, maxiter = 1000, maxiterOuter = 20, maxiterInner = 10)
    )
    
    return(mod_ms)
  }
  
  mod_ms <- estimate_ms_model(target_data)
  # check solution, MSwM::msmFit sometimes produce suboptimal solutions
  check_flag_pass = TRUE
  check_count = 1
  while(check_flag_pass){
    # cat("check:: ", check_count, "\n")
    check_count <- check_count+1
    
    test_mod <- estimate_ms_model(target_data)
    
    old_loglikelihood <- mod_ms@Fit@logLikel
    new_loglikelihood <- test_mod@Fit@logLikel
    dif_lll <- old_loglikelihood - new_loglikelihood
    
    if(abs(dif_lll)< abs(old_loglikelihood/10000)){
      check_flag_pass = FALSE
    }else{
      if(old_loglikelihood < new_loglikelihood){
        mod_ms <- test_mod
      }
    }
    
    first_30_prob <- test_mod@Fit@smoProb[2:31,1]
    
    approx_change_count <- sum(abs(first_30_prob[1:29] + first_30_prob[2:30] -1)/2 < 0.2)
    # cat("transition is ", approx_change_count, " times.\n")
    
    if(approx_change_count>5){
      check_flag_pass = TRUE
    }
    
    # cat("check opt:: loglikelihood = ", old_loglikelihood, ", dif old - new = ", dif_lll, "\n")
  }
  
  
  
  coef_matrix <- mod_ms@Coef
  
  regime_mean <- cbind(
    # sunday, monday-saturday
    coef_matrix[,1], coef_matrix[, -1] + coef_matrix[,1]
  )%>% 
    apply(1, mean)
  
  smoothed_prob <- mod_ms@Fit@smoProb[-1,]
  index_high_regime <- ifelse(regime_mean[1]>regime_mean[2], 1, 2)
  index_low_regime <- 3-index_high_regime
  
  output_data <- tibble(
    date = target_data$date,
    y = target_data$y,
    high_prob = smoothed_prob[,index_high_regime],
    low_prob = smoothed_prob[,index_low_regime]
  ) %>% 
    mutate(
      est_state = ifelse(high_prob >= 0.5, "high", "low"),
      est_value = ifelse(est_state == "high", regime_mean[index_high_regime], regime_mean[index_low_regime])
    ) 
  
  output_list <- list(
    data = output_data,
    fit = mod_ms
  )
  
  
  if(!dir.exists(dir_name))dir.create(dir_name)
  
  write_csv(output_data, str_c(dir_name, "/output.csv"))
  save(output_list, file = str_c(dir_name, "/result.RData"))
  
  return(output_list)
  
  
}

# FIES


list_fies_names <- list(
  name_jp = c("外食", "映画・演劇等入場料", "交通"),
  name_en = c("eatingout", "theater", "transportation")
)

fies <- read_csv("preprocessed_data/fies.csv")

for(i in 1:length(list_fies_names$name_jp)){
  
  cat("------------------estimation on ",list_fies_names$name_en[i],"------------------\n")
  sub_fies <- fies %>% 
    filter(label == list_fies_names$name_jp[i])
  
  data_date <- sub_fies$date
  data_target <- sub_fies$value_change
  
  est_res <- estimation(
    data_date, data_target, str_c("output/", list_fies_names$name_en[i])
  )
  
  # first_30_prob <- est_res$fit@Fit@smoProb[2:31,1]
  # 
  # approx_change_count <- sum(abs(first_30_prob[1:29] + first_30_prob[2:30] -1)/2 < 0.2)
  # cat("transition is ", approx_change_count, " times.\n")
}

# apple mobility
apple_mobility <- read_csv("preprocessed_data/apple_mobility.csv")


apple_transit_res <- estimation(
  data_date =   apple_mobility$date,  
  data_target = apple_mobility$transit, 
  dir_name = "output/apple_transit"
)


# google mobility
google_mobility <- read_csv("preprocessed_data/google_mobility.csv")


google_station_res <- estimation(
  data_date =   google_mobility$date,  
  data_target = google_mobility$google_station, 
  dir_name = "output/google_station"
)
