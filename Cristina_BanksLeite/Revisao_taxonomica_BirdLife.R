# Revisão taxonômica Cristina_BanksLeite
##Grupo taxonômico MAMÍFERO
## Informations to use RGBIF packages - https://cloud.r-project.org/web/packages/rgbif/vignettes/rgbif_vignette.html

setwd("/media/user/Daniel/Banco dados")

# loading packages
install.packages("tidyverse", dependencies = T)
library(tidyverse)

# Preparing BirdLife colsulting --------------------------------------------------
birdlife <- read_csv("Dados Manipulados.csv/Cristina_BanksLeite/HBW-BirdLife_Checklist_Version_3_manipulado.csv")
birdlife.sinonimo <- birdlife %>%
  filter(Synonyms != as.character("NA")) %>% # selecting all synonyms existing in BirdLife
  filter(BirdLife_taxonomic_treatment!= "NR") %>% # selecting all Not Regular taxonomy in BirdLife
  print()

# Reading the datasets ----------------------------------------------------
## This dataset is using the primary species data. That is, not including the correction file from Cris sources.
cris <- read_csv("Dados Manipulados.csv/Cristina_BanksLeite/Bird_dataset (interior).csv") %>% 
  rename(id_site = local) %>% 
  filter(id_site != "Antenor 2")  # Excluding Antenor 2 Estudo. See conversation in e-mail

# Correcting the synonyms species -----------------------------------------

cris$corrigido <- cris$especie # Creating a new column "corrigido" equal to "especie" column
for(i in 1:length(birdlife.sinonimo$Scientific_name)){
  cris$corrigido <- gsub(pattern = birdlife.sinonimo$Synonyms [i], replacement = birdlife.sinonimo$Scientific_name[i], x = cris$corrigido) # Replacing all Synonyms by Scientific_Name in column "corrigido".
}

cris
View(cris)


# Confering with Cris file ------------------------------------------------
## dataset for conference
BanksLeite <- read_csv("Dados Manipulados.csv/Cristina_BanksLeite/match_BirdLife_names.csv")
BanksLeite.sinonimo <- BanksLeite %>% 
  filter(allspecies!=`birdlife match`) %>% 
  print()

birdlife.sinonimo
BanksLeite.sinonimo

##Sinonimos BirdLife contidos em Cris
birdlife.test <- birdlife.sinonimo %>% 
  filter(birdlife.sinonimo$Synonyms %in% cris$especie) %>% 
  print()

  
##Sinonimos BanksLeite contidos em Cris
BanksLeite.test <- BanksLeite.sinonimo %>% 
  filter(BanksLeite.sinonimo$allspecies %in% cris$especie) %>% 
  print()

# Comparando os testes ----------------------------------------------------
birdlife.test <- birdlife.test %>% 
  select(Synonyms, Scientific_name) %>% 
  arrange(Synonyms)

BanksLeite.test <- BanksLeite.test %>% 
  arrange(allspecies)

comparativo <- list(birdlife.test, BanksLeite.test)


# Outras verificações -----------------------------------------------------

birdlife %>% 
  select(Synonyms, Scientific_name) %>% 
  filter(Synonyms == "Myiodynastes maculatus ")

birdlife %>% 
  select(Synonyms, Scientific_name) %>% 
  filter(Scientific_name == "Myiodynastes solitarius")



rm(list=ls(all=TRUE))
