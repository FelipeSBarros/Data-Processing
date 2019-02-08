# Revisão taxonômica Cristina_BanksLeite
##Grupo taxonômico MAMÍFERO
## Informations to use RGBIF packages - https://cloud.r-project.org/web/packages/rgbif/vignettes/rgbif_vignette.html

setwd("/media/user/Daniel/Banco dados")

# loading packages
library(rgbif)
install.packages("tidyverse", dependencies = T)
library(tidyverse)


# Reading datasets and data exploration  ----------------------------------

past.species <- read_csv("Dados Manipulados.csv/Cristina_BanksLeite/Bird_dataset (interior).csv")
post.species <- read_csv("Dados Manipulados.csv/Cristina_BanksLeite/Cristina_BanksLeite.especie.csv")
cris.correction <- read_csv("Dados Manipulados.csv/Cristina_BanksLeite/match_BirdLife_names.csv")



past.cris <- cris.correction$allspecies
post.cris <- cris.correction$`birdlife match`
past.list <- list()
for(i in 1:length(past.cris)){
  past.list[[i]] <- name_lookup(query = past.cris[i], rank = "species", return = "data") %>% 
    select(scientificName, class, family, species, canonicalName, nameType, taxonomicStatus, synonym)
} 
past.list <- bind_rows(past.list)

past.list %>% 
  filter(taxonomicStatus == "SYNONYM", species == "Myiothlypis leucoblephara")  
  

#Notes
Basileuterus leucoblepharus
Myiothlypis leucoblephara
Myiothlypis leucoblephara


rm(list=ls(all=TRUE))