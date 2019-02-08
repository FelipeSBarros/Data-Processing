setwd("/media/user/Daniel/Banco dados/Dados Manipulados.csv/")
install.packages("tidyverse", dependencies = T)
library(tidyverse)
library(raster)
library(sp)


# Cristina BanksLeite -----------------------------------------------------
# download the dataset
especie <- read_csv("Cristina_BanksLeite/Bird_dataset (interior).csv")
classificacao <- read_csv("Cristina_BanksLeite/Classification.csv")
sinonimo <- read_csv("Cristina_BanksLeite/match_BirdLife_names.csv")
site <- read_csv("Cristina_BanksLeite/Copy of Dados Cris Banks-Leite.csv")

unique(site$`Nome/ID do site`)

# base de dados - BD -----------------------------------------------------------
"%nin%" <- Negate(f = "%in%")
especie <- especie %>% 
  rename(id_site = local) %>% 
  filter(id_site %nin% "Antenor 2") # Excluding Antenor 2 Estudo. See conversation in e-mail
unique(especie$id_site)

sinonimo <- rename(.data = sinonimo, especie = allspecies, especie.cor = `birdlife match`)
classificacao <- rename(.data = classificacao, especie = Especie, especialista_floresta = 'Forest use', endemismo = Endemic)
site <- rename(.data = site, id_site = `Nome/ID do site`)
ano_inicio <- rep(2005,6145)
ano_fim <- rep(2007, 6145)
ano <- rep(2006, 6145)

banco <- especie %>% 
  inner_join(site, by = "id_site") %>% 
  left_join(sinonimo, by = "especie") %>% 
  left_join(classificacao, by = "especie") %>% 
  mutate(corrigido = if_else(especie == especie.cor, especie, especie.cor, missing = especie), ano_inicio, ano_fim, ano)


#select(BD, id_estudo, id_site, especie = corrigido, long = `Coordenadas O`, lat = `Coordenadas S`, utm_zona = `Zona UTM`, municipio = Municipios, metodo = `Metodo de coleta`, esforco = Esforco, especialista_floresta, endemismo)

# Especies ----------------------------------------------------------------
CBL.especie <- banco %>% 
  group_by(id_site, corrigido) %>% 
  mutate(abundance = n()) %>% 
  distinct(corrigido, id_site, .keep_all = T) %>% 
  select(id_site, especie = corrigido, abundance, especialista_floresta, endemismo)
  

abundance <- CBL.especie[, c("id_site", "especie", "abundance")]
length(unique(CBL.especie$id_site))
 
# Sites -------------------------------------------------------------------

CBL.site <- banco %>% 
  group_by(id_site) %>% 
  distinct(id_site, .keep_all = T) %>% 
  select(id_estudo, id_site, long = `Coordenadas O`, lat = `Coordenadas S`, municipio = Municipios, metodo = `Método de coleta`, esforço = Esforço, ano_inicio, ano_fim, ano)

colnames(CBL.site)


# Saving the files ---------------------------------------------------

write_csv(CBL.especie, "Cristina_BanksLeite/Cristina_BanksLeite.especie.csv")
write_csv(CBL.site, "Cristina_BanksLeite/Cristina_BanksLeite.site.csv")


rm(list=ls())
