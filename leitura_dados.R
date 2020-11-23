library(tidyverse)
library(readxl)

# Esse programa recebe os dados do questinário presentes no arquivo 
# "dados.xlsx" e carrega-os no ambiente para o shiny.

df <- read_excel("dados.xlsx")
 
# converte para o tipo apropriado
df$Latitude <- df$Latitude %>% as.numeric()
df$Longitude <- df$Longitude %>% as.numeric()

df$tipo <- df$tipo %>% as.factor()





        