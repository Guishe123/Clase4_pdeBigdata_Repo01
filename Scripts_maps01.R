#### Configurciones Iniales ###


# Limpiamos memoria

rm(list = ls())
library(tidyverse)
library(sf)
library(ggrepel)

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


### Primer Mapa ####

ggplot(data = peru_sf)+
  geom_sf()

#gUARDAR EN EL DIRECTOIO OUTPUTS

ggsave(filename = paste0(wd$outputs, "MapaBaseperu.png"),
                         width= 8.5,
                         height=11)

# Lista de Depamentos

unique(peru_sf$NOMBDEP)

#### Mpaa de Junin ####

ggplot(data = peru_sf %>%
         filter(NOMBDEP == "JUNIN"))+
         geom_sf()

# Guardamos en el disco duro

ggsave(filename = paste0(wd$outputs, "mapajunin.png"),
       width =8, height=8)

# calculamos  de centroides

peru_sf <- peru_sf %>% mutate(centroid = map(geometry, st_centroid),
                   coords = map(centroid,st_coordinates),
                   coords_x = map_dbl(coords,1),
                   coords_y = map_dbl(coords,2))

#### Coloquemos las etiquetas  de cada dpto ####
ggplot(data = peru_sf)+
  geom_sf(fill = "skyblue", color = "black", alpha = 0.7)+
  geom_text_repel(mapping = aes(coords_x, coords_y, label = NOMBDEP),
                  size = 2)

#
# Guardamos  en disco duro

ggsave(filename = paste0(wd$outputs, "mapaPeru_centroide.png"),
       width =8.5,
       height = 11)

