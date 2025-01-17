# set working directory to dataverse file
setwd("~/Documents/dataverse_files")

#import raw data set
ICTRP_download_all_registries_but_CT_15DEC20 <- read.csv("ICTRP download all registries but CT 15DEC20.csv")
ICTRP_download_CT_registry_15DEC20 <- read.csv("ICTRP download CT registry 15DEC20.csv")

# import curated data set
ICTRP_Analysis_seperate_Dataset <- read.csv("ICTRP Analysis seperate Dataset.csv")

#merge the data sets
combined <- rbind(ICTRP_download_all_registries_but_CT_15DEC20,ICTRP_download_CT_registry_15DEC20)

#removes all "child" in bridgred_type column as those with child are linked to
#the parent clinical trial and are counted as 1 trial.
combined <- combined[!(combined$Bridged_type == "\"child     \""),]

library(dplyr)

#creates abbreviation of all trial registries. first two letters 
combined$REG <- substr(combined$TrialID,1,2)
#change all text in REG to uppercase so there is no longer 2 versions of anything
combined$REG <- toupper(combined$REG)

#moves coloumn to after TrialID coloumn
combined <- combined %>% relocate(REG, .after = TrialID)

combined$Date_Reg <-  lubridate::parse_date_time(combined$Date_registration, orders = c('dmy','ymd'))
#replace empty values in dateregistration with date in x.coumn.names
combined$Date_Reg[is.na(combined$Date_Reg)] <-  lubridate::dmy(combined$X.No.column.name., na.rm = TRUE)


#creates column of just the year of registration
combined$year <- strftime(combined$Date_Reg, "%Y")
combined$year <- as.numeric(combined$year)  

#moves column to after date_registration coloumn
combined <- combined %>% relocate(Date_Reg, .after = Date_registration )
combined <- combined %>% relocate(year, .after = Date_Reg )


# used IDP PLAN column from  curated data
combined$IPD_PLAN <-ICTRP_Analysis_seperate_Dataset$IPD.PLAN
combined <- combined %>% relocate(IPD_PLAN , .after = results_IPD_plan)

#change all text in IDP_PLAN COLUMN to uppercase so there is no longer 2 versions of yes
combined$IPD_PLAN <- toupper(combined$IPD_PLAN)

#netherlands has two registrations letters, NT & NL. to make them one, convert all NL to NT
combined$REG[combined$REG == "NL"] = "NT"

# used HIC and LMIC column from  curated data
combined$HIC.East.Asia...Pacific <- ICTRP_Analysis_seperate_Dataset$HIC.East.Asia...Pacific

combined$LMIC.East.Asia...Pacific <- ICTRP_Analysis_seperate_Dataset$LMIC.East.Asia...Pacific

combined$HIC.Europe...Central.Asia <- ICTRP_Analysis_seperate_Dataset$HIC.Europe...Central.Asia

combined$LMIC.Europe...Central.Asia <-  ICTRP_Analysis_seperate_Dataset$LMIC.Europe...Central.Asia

combined$HIC..LatinAmerica...Carribean <- ICTRP_Analysis_seperate_Dataset$HIC..LatinAmerica...Carribean

combined$LMIC.LatinAmerica...Carribean <- ICTRP_Analysis_seperate_Dataset$LMIC.LatinAmerica...Carribean

combined$HIC.Middle.East..North.Africa <- ICTRP_Analysis_seperate_Dataset$HIC.Middle.East..North.Africa

combined$LMIC.Middle.East..North.Africa <- ICTRP_Analysis_seperate_Dataset$LMIC.Middle.East..North.Africa

combined$HIC.North.America <- ICTRP_Analysis_seperate_Dataset$HIC.North.America

combined$LMIC.North.America <- ICTRP_Analysis_seperate_Dataset$LMIC.North.America

combined$HIC.Sub.Saharan <- ICTRP_Analysis_seperate_Dataset$HIC.Sub.Saharan

combined$LMIC.Sub.Saharan.Africa <- ICTRP_Analysis_seperate_Dataset$LMIC.Sub.Saharan.Africa

combined$LMIC.South.Asia <- ICTRP_Analysis_seperate_Dataset$LMIC.South.Asia






