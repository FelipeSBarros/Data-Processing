# Revisão taxonômica Carolina_Esteves
##Grupo taxonômico MAMÍFERO
## Informations to use RGBIF packages - https://cloud.r-project.org/web/packages/rgbif/vignettes/rgbif_vignette.html

setwd("/media/user/Daniel/Banco dados")

# loading packages
library(rgbif)
install.packages("tidyverse", dependencies = T)
library(tidyverse)


# Reading datasets and data exploration  ----------------------------------

especie <- read_csv("Dados Manipulados.csv/Carolina_Esteves/especies.csv")

#Exploring dataset
list.especies.sites <- especie %>% 
  group_by(id_site) %>% 
  distinct(especie)
  
Abundance.sites <- especie %>% 
  group_by(id_site) %>% 
  summarise(n())

list.species <- especie %>% 
  group_by(especie) %>% 
  distinct(especie)


#final tibble for review in RGIBF

review <- especies %>% 
  group_by(id_site, familia) %>% 
  distinct(especie, .keep_all = T)
unique(review$especie)


# Dataset sources for GBIF ------------------------------------------------

familia <- unique(review$familia)
listagem <- list()

for(i in 1:length(familia)){
  listagem[[i]] <- name_lookup(query = familia[i], rank = "species", limit = 10000, return = "data") %>% 
    select(scientificName, class, family, species, canonicalName, nameType, taxonomicStatus, synonym, accepted)
  } # The LOOP doesn't ran because family [[3]] dont't have "accepted" collumn.

#option
listagem[[1]] <- name_lookup(query = familia[1], rank = "species", limit = 10000, return = "data") %>% 
  select(scientificName, class, family, species, canonicalName, nameType, taxonomicStatus, synonym, accepted)
listagem[[2]] <- name_lookup(query = familia[2], rank = "species", limit = 10000, return = "data") %>% 
  select(scientificName, class, family, species, canonicalName, nameType, taxonomicStatus, synonym, accepted)
listagem[[3]] <- name_lookup(query = familia[3], rank = "species", limit = 10000, return = "data") %>% 
  select(scientificName, class, family, species, canonicalName, nameType, taxonomicStatus, synonym)
listagem[[4]] <- name_lookup(query = familia[4], rank = "species", limit = 10000, return = "data") %>% 
  select(scientificName, class, family, species, canonicalName, nameType, taxonomicStatus, synonym, accepted)
listagem[[5]] <- name_lookup(query = familia[5], rank = "species", limit = 10000, return = "data") %>% 
  select(scientificName, class, family, species, canonicalName, nameType, taxonomicStatus, synonym, accepted)
listagem[[6]] <- name_lookup(query = familia[6], rank = "species", limit = 10000, return = "data") %>% 
  select(scientificName, class, family, species, canonicalName, nameType, taxonomicStatus, synonym, accepted)
listagem[[7]] <- name_lookup(query = familia[7], rank = "species", limit = 10000, return = "data") %>% 
  select(scientificName, class, family, species, canonicalName, nameType, taxonomicStatus, synonym, accepted)
listagem[[8]] <- name_lookup(query = familia[8], rank = "species", limit = 10000, return = "data") %>% 
  select(scientificName, class, family, species, canonicalName, nameType, taxonomicStatus, synonym, accepted)
listagem[[9]] <- name_lookup(query = familia[9], rank = "species", limit = 10000, return = "data") %>% 
  select(scientificName, class, family, species, canonicalName, nameType, taxonomicStatus, synonym, accepted)
listagem


GBIF.results <- bind_rows(listagem)
colnames(GBIF.results)


# identifing erros in dataset ---------------------------------------------
## Sinonyms
unique(GBIF.results$taxonomicStatus)
sinonym <- GBIF.results %>% 
  filter(taxonomicStatus == c("SYNONYM", "HOMOTYPIC_SYNONYM", "DOUBTFUL")) %>% 
  distinct(species)

length(sinonym)
list.species <- unique(review$especie)
list.species %in% sinonym

## Canonical Names
canonical.names <- unique(GBIF.results$canonicalName)
list.species %in% canonical.names
list.species[3] # specie level not indetified

## Name types

names.types <- unique(GBIF.results$nameType)
no.scientific <- GBIF.results[GBIF.results$nameType != "SCIENTIFIC", ]
list.species %in% no.scientific$species
x <- list.species[list.species %in% no.scientific$species] # consulting GBIF website, it was identifyied as Scientific Names too.
list.species[3]
list.species[4]








review %>% 
  mutate(presence = if_else(especie %in% GBIF.results$taxonomicStatus == "ACCEPTED", true = T, false = F))
  




rm(list=ls(all=TRUE))
