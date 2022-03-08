library(rfactor)
library(ggbiplot)
library("readxl")
library("FactoMineR")
library(tidyverse)

df <- read_excel("C:/Users/elmen/OneDrive/Documents/marathon/Presidentielle_2017_Departement_Tour_2.xls")
df %>% select(5, 7, 8,9,11,12,14,15,18,19,22,23)
res.pca = PCA(df[,5:6], scale.unit=TRUE, ncp=5, graph=T)
res.pca <- PCA(df[,3:15], graph = FALSE)

plot(res.pca, choix = "ind", autoLab = "yes")
