
#load dataset
here::i_am("code/data_cleaning.R")
data<-read.csv(here::here("autism_prevalence_studies_20250220.csv"))

library(tidyverse)

#cleaning up dataset

#creating more clear age values
data$age<-gsub(" to ", " ", data$Age.Range)
data$age_lower<-gsub( " .*$", "", data$age)

data$age_upper<-sub(".*? ", "", data$age)

data <- data %>% 
  mutate(age_lower_cat = 
           ifelse(age_lower <= 1, "infant", 
                  ifelse(age_lower %in% 2:3, "toddler", 
                         ifelse(age_lower %in% 4:5, "preschool", 
                                ifelse(age_lower %in% 6:12, "gradeschool", 
                                       ifelse(age_lower %in% 13:18, "teen", 
                                              ifelse(age_lower %in% 18:100, "adult", NA)))))))

data <- data %>% 
  mutate(age_upper_cat = 
           ifelse(age_upper <= 1, "infant", 
                  ifelse(age_upper %in% 2:3, "toddler", 
                         ifelse(age_upper %in% 4:5, "preschool", 
                                ifelse(age_upper %in% 6:12, "gradeschool", 
                                       ifelse(age_upper %in% 13:18, "teen", 
                                              ifelse(age_upper %in% 18:100, "adult", NA)))))))


#cleaning up case id method
data$id_records<-grepl('records', data$Case.Identification.Method)
data$id_mail<-grepl('mail', data$Case.Identification.Method)
data$id_survery<-grepl('survey', data$Case.Identification.Method)
data$id_phone<-grepl('phone', data$Case.Identification.Method)
data$id_in_person<-grepl('in-person', data$Case.Identification.Method)
data$id_registry<-grepl('registry', data$Case.Identification.Method)
data$id_interview<-grepl('interview', data$Case.Identification.Method)
data$id_parent<-grepl('parent', data$Case.Identification.Method)

data <- data %>% 
  mutate(id_type = 
           ifelse(id_phone==TRUE | id_interview==TRUE | id_in_person==TRUE, "interactive", 
                  ifelse(id_registry==TRUE|id_mail==TRUE|id_records==TRUE, "remote", "other")))

saveRDS(data, here::here("output/ASD_clean.RDS"))
