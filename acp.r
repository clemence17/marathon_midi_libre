library(rfactor)
library(ggbiplot)
library("readxl")
library("FactoMineR")

df <- read_excel("C:/Users/elmen/OneDrive/Documents/marathon/Presidentielle_2017_Departement_Tour_2.xls")
df
res.pca <- PCA(df, graph = FALSE)
