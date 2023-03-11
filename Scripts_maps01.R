#### Configurciones Iniales ###


# Limpiamos memoria

rm(list = ls())
library(tidyverse)
library(sf)


#### Datos ####


#Definamos una estuctura directorio tanto para imputs como para outputs

wd <- list()
#
wd$root <- "D:/Guillermo Odar/Big data y Analistc-CTICUNI/Clase4_Bigdata/Clase4_pdeBigdata_Repo01/"
wd$inputs <- paste0(wd$root, "01_inputs/01_inputs/")
wd$shapef <- paste0(wd$inputs,"shapefiles/")
wd$datasets <- paste0(wd$inputs, "datasets/")
wd$outputs <- paste0(wd$root,"02_outputs/")

# Carguemos en memoria la informacion espacial.

peru_sf <- st_read(paste0(wd$shapef, "INEI_LIMITE_DEPARTAMENTAL.shp"))




