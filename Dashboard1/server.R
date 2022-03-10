#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
#Librairies
library(maps)
library(shiny)
library(data.table)
library(tidyverse)
library(stringr)
library(stringi)
library(ggplot2)
library(plotly)
library(rsconnect)



theme_set(
  theme_void() 
)

#Couleurs des partis
couleurs_T1=c("#0E4D7C", "#051237", "#2ABAFF","#DE313D")
couleurs_T2=c( "#051237", "#2ABAFF")
couleurs_T2v2=c( "#2ABAFF", "#051237")

carte_dep=read.csv(text = readLines("carte_dep.csv", warn = FALSE),header=T, encoding = "UTF-8")
carte_cant=read.csv(text = readLines("carte_cant.csv", warn = FALSE),header=T,encoding = "UTF-8")
setDT(carte_dep)
setDT(carte_cant)


#////////////////
g1=ggplot(carte_dep[!is.na(long) & place==1,], aes(long, lat, group = group))+
  geom_polygon(aes(fill = nom ), color = "white", size = 0.1)+ 
  scale_fill_manual(values = couleurs_T1)+ labs(fill = "Candidat") +
  theme(
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    # Modifier le trait des axes
    axis.line = element_blank()
  ) +
  facet_grid(.~tour)
g5=ggplot(carte_cant)+
  geom_bar(aes(x = canton, y=votes_votant,fill=nom),color=couleurs_T2[1],stat="identity",position=position_dodge(), size = 0.1)+ 
  scale_fill_manual(values=couleurs_T2)+ 
  labs(fill = "Candidat") +xlab("")+
  ylab("% de voix par candidat")+
  ggtitle("Vote au 2e tour pour\nles 5 plus grandes villes")+theme(axis.text.x= element_text(size=9,colour = "#000000"))+
  theme_grey()+ scale_x_discrete(limits=c("Toulouse", "Montpellier", "Nîmes","Perpignan","Béziers")) + coord_flip()





# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  
  ################G1########################
  ######Défaut cartes france
  #####G1 ga1
  v <- reactiveValues(data = NULL)
  v2 <- reactiveValues(data = NULL)
  v3 <- reactiveValues(data = NULL)
  v4 <- reactiveValues(data = NULL)
  
  observeEvent(input$G1_occitanie, {
    v$data <- carte_dep[!is.na(long) & place==1 & nom_region=="Occitanie",]
    v2$data=1
  })
  observeEvent(input$G2_T2, {
    v3$data=NULL
  })
  observeEvent(input$G1_FR, {
    v$data <- carte_dep[!is.na(long) & place==1,]
    v2$data=NULL
  })
  observeEvent(input$G2_T1, {
    v3$data=1
  })
  
  
  
  
  output$ga3 <- renderPlotly({
    if (is.null(v2$data)) return()
    ggplotly(g5)
  })
  output$ga1 <- renderPlotly({
    if (is.null(v$data)) return(ggplotly(g1))
    g1=ggplot((v$data), aes(long, lat, group = group))+
      geom_polygon(aes(fill = nom ), color = "white", size = 0.1)+ 
      scale_fill_manual(values = couleurs_T1)+ labs(fill = "Candidat") +
      theme(
        panel.border = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        # Modifier le trait des axes
        axis.line = element_blank()
      ) +
      facet_grid(.~tour)
    ggplotly(g1)
  })
  
  
  
})
