library(rfactor)
library(ggbiplot)
library("readxl")
library("FactoMineR")
library(tidyverse)
library(ggplot2)

df <- read_excel("C:/Users/elmen/OneDrive/Documents/marathon/Presidentielle_2017_Departement_Tour_2.xls")
df=df %>% select(5, 7, 8,9,11,12,14,15,18,19,22,23)
res.pca = PCA(df, scale.unit=TRUE, ncp=5, graph=T)
res.pca <- PCA(df[,3:15], graph = FALSE)

plot(res.pca, choix = "ind", autoLab = "yes")
plotellipses(res.pca)

df <- read_excel("C:/Users/elmen/OneDrive/Documents/marathon/macron.xls")
#df <- read_excel("C:/Users/elmen/OneDrive/Documents/marathon/occitanie.xls")

df=as.data.frame(df)
df$columns <- unlist(df$columns)
ggplot(data = df, aes(x=df[,1],y=df[,2], fill=df[,3])) + geom_col(position="dodge") + ggtitle('histo') 


ggplot(df, aes(x = vote, fill = candidat)) + 
  geom_histogram()


library(ggiraph)
library(plotly)
df <- read_excel("C:/Users/elmen/OneDrive/Documents/marathon/villes_2.xls")
df=as.data.frame(df)
#my_gg=ggplot(data = df, aes(x=df[,1],y=df[,2], fill=df[,3])) + geom_col(position="dodge") + ggtitle('histo')+ geom_bar_interactive()        
#+geom_bar_interactive(aes(x=df[,1],tooltip = paste(df[,1],"décès pour 100 000 naissances")))
#ggiraph(code = print(my_gg))

p <- ggplot(data=df, aes(x=ville, y=vote, fill=candidat)) +
  geom_bar(stat="identity", position=position_dodge(), colour="black") +
  scale_fill_manual(values=c("#00AFBB", "#FC4E07"))

fig <- ggplotly(p)

fig

ggplotly(ggplot(data=df, aes(x=ville, y=vote, fill=candidat)) +
  geom_bar(stat="identity", position=position_dodge(), colour="black") +
  scale_fill_manual(values=c("#00AFBB", "#FC4E07")))

g <- ggplot(df, aes(ville))  
p <-ggplot(df, aes(x=ville,y = ville)) +
  geom_bar(stat="identity",aes(fill = candidat), position = position_stack(reverse = TRUE)) +
  theme(legend.position = "top")

ggplotly(p)

























