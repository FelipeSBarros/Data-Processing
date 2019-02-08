setwd("/media/user/Daniel/Banco dados/")
library(tidyverse)
library(raster)
library(sp)

# download the dataset
especie <- read_csv("Dados Manipulados.csv/Thomas_Puttker/especie.csv")
site <- read_csv("Dados Manipulados.csv/Thomas_Puttker/site.csv")
estudo <- read_csv("Dados Manipulados.csv/Thomas_Puttker/estudo.csv")
