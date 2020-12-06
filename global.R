# Final_Project global
library(shiny)
library(plotly)
library(tidyverse)
library(maps)

# Sys.setenv(R_REMOTES_STANDALONE="true")
# withr::with_envvar(c(R_REMOTES_NO_ERRORS_FROM_WARNINGS="true"), 
#                    remotes::install_github("wmurphyrd/fiftystater"))
library(fiftystater)


college_raw <- read_csv("Most-Recent-Cohorts-All-Data-Elements.csv")
college_raw <- college_raw[,c(1,4,6,17, 20, 37,60,387,1639, 1826)]
college <- filter(college_raw, STABBR!="AS", STABBR!="FM",STABBR!="GU",STABBR!="MP",STABBR!="PW",
                  STABBR!="PR", STABBR!="VI", STABBR!="MH",
                  ADM_RATE!="NULL", SAT_AVG!="NULL")


majors_raw <- read_csv("Most-Recent-Field-Data-Elements.csv")
majors_raw <- majors_raw[,c(1,7,9,11,13,16)]
majors <- filter(majors_raw, CREDDESC =="Bachelors Degree",
                 MD_EARN_WNE !="PrivacySuppressed",
                 DEBTMEDIAN !="PrivacySuppressed", DEBTMEAN !="PrivacySuppressed")

full_data <- full_join(college, majors, by="UNITID")
full_data$ADM_RATE <- as.numeric(full_data$ADM_RATE)
full_data$SAT_AVG <- as.numeric(full_data$SAT_AVG)
full_data$MD_EARN_WNE <- as.numeric(full_data$MD_EARN_WNE)
full_data$DEBTMEDIAN <- as.numeric(full_data$DEBTMEDIAN)
full_data$DEBTMEAN <- as.numeric(full_data$DEBTMEAN)
full_data$CONTROL <- as.numeric(full_data$CONTROL)
full_data$C150_4 <- as.numeric(full_data$C150_4)
full_data$C100_4_POOLED <- as.numeric(full_data$C100_4_POOLED)
full_data$MN_EARN_WNE_P10 <- as.numeric(full_data$MN_EARN_WNE_P10)


#data("fifty_states")
fifty_states$id <- str_to_title(fifty_states$id)
fifty_states$id <- state.abb[match(fifty_states$id, state.name)]
#add DC abbreviation
fifty_states$id[is.na(fifty_states$id)] = "DC"
names(full_data)[3] <- "id"

names(full_data)[6] <- "Admission_Rate"
names(full_data)[7] <- "Mean_SAT_Score"
names(full_data)[15] <- "Median_Annual_Earnings"
names(full_data)[13] <- "Median_Debt"
names(full_data)[14] <- "Mean_Debt"
names(full_data)[2] <- "College"



state_data <- full_data %>% group_by(id) %>% summarize(Public_Colleges = sum(CONTROL==1, na.rm=T)/n(), 
                                                       Private_NFP_Colleges = sum(CONTROL==2, na.rm=T)/n(), 
                                                       Graduate_Earnings = sum(MN_EARN_WNE_P10>=50944, na.rm=T)/n(),
                                                       SAT_Scores = sum(Mean_SAT_Score>=1140, na.rm=T)/n(),
                                                       Six_Yr_Graduation_Rate = sum(C150_4>=.6, na.rm=T)/n(), 
                                                       Four_Yr_Graduation_Rate = sum(C100_4_POOLED>=.41, na.rm=T)/n())

state_data <- filter(state_data, !is.na(id))

usData <- left_join(fifty_states,state_data,by="id")
usData$id <- as.factor(usData$id)
