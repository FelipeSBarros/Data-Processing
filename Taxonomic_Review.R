####### SCRIPT PARA REVISÃO TAXONOMICA#######

# loading packages
install.packages("tidyverse", dependencies = T)
library(tidyverse)
library(rgbif)

## GBIF database
## Informations to use RGBIF packages - https://cloud.r-project.org/web/packages/rgbif/vignettes/rgbif_vignette.html
## loading packages


# #########  BIRD ######### -----------------------------------------------


birdlife <- read_csv("Reference_taxonomic_review/BirdLife/HBW-BirdLife_Checklist_Version_3_manipulado.csv")
birdlife.sinonimo <- birdlife %>%
  filter(Synonyms != as.character("NA")) %>% # selecting all synonyms existing in BirdLife
  filter(BirdLife_taxonomic_treatment!= "NR") %>% # selecting all Not Regular taxonomy in BirdLife
  print()



# INITAL REVIEW ----------------------------------------------------------

# Cristina Banks-Leite ----------------------------------------------------
#Reading the datasets
## This dataset is using the primary data sent by email in 16/01/2019. This not including Cristina taxonomic review ("BanksLeite") 


cris <- read_csv("Cristina_BanksLeite/Bird_dataset (interior).csv") %>% 
  rename(id_site = local) %>% 
  filter(id_site != "Antenor 2")  # Excluding Antenor 2 Estudo. See conversation in e-mail

## Final dataset
# Correcting the synonyms species

cris$corrigido <- cris$especie # Creating a new column "corrigido" equal to "especie" column
for(i in 1:length(birdlife.sinonimo$Scientific_name)){
  cris$corrigido <- gsub(pattern = birdlife.sinonimo$Synonyms [i], replacement = birdlife.sinonimo$Scientific_name[i], x = cris$corrigido) # Replacing all Synonyms by Scientific_Name in column "corrigido".
}

cris
View(cris)
rm(list=ls(all=TRUE))

especie[,7]

# Eduardo Alexandrino -----------------------------------------------------
especie <- read_csv("Eduardo_Alexandrino/especies.csv", na = "NA") 

x <- gsub(pattern = "" ,replacement = "D", especie$endemismo, fixed = T)


# #########  MAMMALS ######### -----------------------------------------------
# Review by RGBIF

# Carolina Esteves --------------------------------------------------------

especie <- read_csv("Carolina_Esteves/especies.csv")

#Exploring dataset
list.especies.sites <- especie %>% 
  group_by(id_site) %>% 
  distinct(especie) %>% 
  print()

Abundance.sites <- especie %>% 
  group_by(id_site) %>% 
  summarise(n()) %>% 
  print()

list.species <- especie %>% 
  group_by(especie) %>% 
  distinct(especie) %>% 
  print()


#final tibble for review 
review <- especie %>% 
  group_by(id_site) %>% 
  distinct(especie, .keep_all = T) %>% 
  print()

unique(review$id_site)

# review in GBIF. Sourching for Synonyms in RGBIF

list.species <- unique(review$especie)
listagem <- list()

for(i in 1:length(list.species)){
  listagem[[i]] <- name_lookup(query = list.species[i], rank = "species", limit = 10000, return = "data")
} 
list.gbif <- bind_rows(listagem) # Source for species name in gbif Packeges, indexing the list of species in this study. 

gbif.synonyms <- list.gbif %>% 
  select(scientificName, family, species, canonicalName,  taxonomicStatus, synonym, accepted, basionym) %>% 
  filter(scientificName != accepted ) %>% # scientificName is the actual name. accepted is the old name, which accepted is = T if species is a synonyms.
  print()

gbif.synonyms$accepted %in% review$especie


#####conclusion <-There is no species name in Carolina Esteves dataset identified by old name. There is no necessary to correct taxonomy name

# Review in "Annotated Checklist of Brazilian Mammals 2nd Edition"
unique(review$especie)
review[review$especie == "Didelphis aurita"| review$especie == "Sapajus nigritus",] # this species is identified as endemic from MA in Checklist Paglia.  It isn't happened in this dataset.



rm(list=ls(all=TRUE))
# Thomas Puttker ----------------------------------------------------------
#final tibble for review 
especie <- read_csv("Thomas_Puttker/especie.csv")

review <- especie %>% 
  group_by(id_site) %>% 
  distinct(especie, .keep_all = T) %>% 
  print()

# review in GBIF. Surching for Synonyms in RGBIF

list.species <- unique(review$especie) # list of species in dataset
listagem <- list() # Empty list to data archivement.

for(i in 1:length(list.species)){
  listagem[[i]] <- name_lookup(query = review$especie[i], rank = "species", limit = 10000, return = "data")
} 
list.gbif <- bind_rows(listagem) # Source for species name in gbif Packeges, indexing the list of species in this study. 

gbif.synonyms <- list.gbif %>% 
  select(scientificName, family, species, canonicalName,  taxonomicStatus, synonym, accepted, basionym) %>% 
  filter(scientificName != accepted ) %>% # "scientificName" is the actual name. "accepted" is the old name, where accepted is = T to be synonyms.
  print()

gbif.synonyms$accepted %in% review$especie

####

my_fun(list.species = review$especie)


my_fun <- function(list.species){
  listagem <- list()
  for(i in 1:length(list.species)){
    listagem[[i]] <- name_lookup(query = list.species[i], rank = "species", limit = 10000, return = "data")
  }
  list.gbif <- bind_rows(listagem)
  gbif.synonyms <- list.gbif %>% 
    select(scientificName, family, species, canonicalName,  taxonomicStatus, synonym, accepted, basionym) %>% 
    filter(scientificName != accepted )
  return(gbif.synonyms)
}
# Try to use "invisable" tool
my_fun(list.species)
  





rm(list=ls(all=TRUE))
