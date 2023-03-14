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

#### CargaremoS la informacion del dataset del trabajo del SINADEF ####

fallecidos <- read.csv(paste0(wd$datasets,"fallecidos_sinadef.csv"), sep = "|")

#### Impresion de las columnas de la data set.

colnames(fallecidos)


#### Lista de columnas con la que se va a trabajar con la dataset ####


datos_seleccionados <- fallecidos[,c(3,4,6,11,15,16)]


#### Lista de Sexo ####
unique(fallecidos$SEXO)

#### Lista de edades ####

unique(fallecidos$EDAD)

### Lista de  Estado Civil ####
unique(fallecidos$ESTADO.CIVIL)


#### Lista de Departamento ####
unique(fallecidos$DEPARTAMENTO.DOMICILIO)

#### Lista de Año ####

unique(fallecidos$AÑO)
#### Lista de Mes ###

unique(fallecidos$MES)


#### sE UTILIZA LA FUNCON TABLE PARA EL CONTADOR DE LOS FALLECIDOS POR CATEGORIAS #####

table(fallecidos$SEXO, useNA = "ifany")

### Vamoa agrupar por categorias las muertes por cada año por ende usamos la funcion agregate###

conteo_sexo_año <- aggregate(cbind(Masculino = fallecidos$SEXO == "MASCULINO",
                                   Femenino = fallecidos$SEXO == "FEMENINO",
                                   Indeterminado = fallecidos$SEXO == "INDETERMINADO",
                                   SinRegistro = fallecidos$SEXO == "SIN REGISTRO"),
                             by = list(año = fallecidos$AÑO),
                             FUN = sum)

# Creamos el gráfico de pastel
fallecidos <- subset(fallecidos, select=c("SEXO", "AÑO"))


ggplot(fallecidos, aes(x="", fill=SEXO)) + 
  geom_bar(width = 8, stat = "count") +
  coord_polar("y", start=0) +
  labs(title="Relación de Muertes por Año y Categoria", fill="SEXO") +
  theme_void() +
  theme(legend.position = "bottom") # Etiquetas parte inferior


# Guardamos en el dsico duro.
 ggsave(filename = file.path(wd$outputs, "Paastel Relacion Muertes por Año y categoria.png"),
        width = 8.5,
        height = 11)

## Se realizara un grafio de barras de la relacion entre estado civil y edades.
 
 library(dplyr)
 library(ggplot2)
 df_tabla <- fallecidos %>% count(ESTADO.CIVIL, EDAD)
 ggplot(df_tabla, aes(x = EDAD, y = n, fill = ESTADO.CIVIL)) +
   geom_bar(stat = "identity", position = "dodge") +
   labs(x = "EDAD", y = "Frecuencia", fill = "Estado Civil")

 # guadar en el disco
 
 ggsave(filename = paste0(wd$outputs, "Grafico de Barras de Estados civil y Edades grafico.png"),
        width = 8.5,
        height = 11)
 
 ### Aqui se realiza un group by para