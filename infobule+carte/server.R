setwd("~/a_M1 MIASHS/MARATHON-WEB/Rshiny/Carte_C")
#Librairies
library(shiny)
library(data.table)
library(tidyverse)
library(stringr)
library(stringi)
library(ggplot2)
library(plotly)
library(ggiraph)

theme_set(
    theme_void() 
)

#Couleurs des partis
couleurs_T1=c("#0E4D7C", "#051237", "#2ABAFF","#DE313D")
couleurs_T2=c( "#051237", "#2ABAFF")
couleurs_T2v2=c( "#2ABAFF", "#051237")


carte <- map_data("france")
setDT(carte)
carte[,region:=str_to_lower(region)][,region:=gsub(" ","",region)][,region:=gsub("-","",region)]

d=read.csv2("C:/Users/Hp/OneDrive/Documents/a_M1 MIASHS/MARATHON-WEB/Rshiny/Carte_C/pres_dep.csv", header=T)

names(d)=c("code","dep","inscrits","abstention","votants","blanc","nul","exprimes","tour","place","nom","voix")
setDT(d)

d[,region:=iconv(dep,to="ASCII//TRANSLIT")][,region:=gsub("'","",region)][,region:=str_to_lower(region)][,region:=gsub(" ","",region)][,region:=gsub("-","",region)]
d2=read.csv2("C:/Users/Hp/OneDrive/Documents/a_M1 MIASHS/MARATHON-WEB/Rshiny/Carte_C/pres_cantons_T2.csv", header=T)
d2=d2[,c(2,4:13)]
names(d2)=c("dep","canton","inscrits","abstention","votants","blanc","nul","exprimes","place","nom","voix")

setDT(d2)
d2[,region:=iconv(dep,to="ASCII//TRANSLIT")][,region:=gsub("'","",region)][,region:=str_to_lower(region)][,region:=gsub(" ","",region)][,region:=gsub("-","",region)]


deps=read.csv("C:/Users/Hp/OneDrive/Documents/a_M1 MIASHS/MARATHON-WEB/Rshiny/Carte_C/departement2021.csv", encoding = "UTF-8")

regions=read.csv("C:/Users/Hp/OneDrive/Documents/a_M1 MIASHS/MARATHON-WEB/Rshiny/Carte_C/region2021.csv", encoding = "UTF-8")
regions=left_join(regions,deps, by = "REG")
regions=regions[,c(6,10)]
names(regions)=c("nom_region","region")
setDT(regions)
regions[,region:=gsub(" ","",region)][,region:=str_to_lower(region)]



carte<- left_join(regions, carte, by = "region")
carte_dep <- left_join(d, carte, by = "region")
carte_cant<- left_join(d2, carte, by = "region")

setDT(carte_dep)
setDT(carte_cant)

carte_dep[,tour:=ifelse(tour==1,"Premier tour","Second tour")]
carte_cant[,canton:=gsub("-","",canton)][,canton:=gsub("[1234567890]","",canton)]
carte_cant[,canton:=gsub("-","",canton)][,canton:=gsub("[1234567890]","",canton)]
carte_cant=carte_cant[canton %in% c("Toulouse", "Montpellier","Béziers", "Nîmes","Perpignan"),]
carte_cant=carte_cant[,.(voix=sum(voix),
                         votants=sum(votants),
                         inscrits=sum(inscrits),
                         abstention=sum(abstention),
                         blancs=sum(blanc),
                         nuls=sum(nul),
                         exprimes=sum(exprimes)),by=.(canton,nom)]
carte_cant[,blancs_inscrits:=round((blancs/inscrits)*100,1)][,abstention_inscrits:=round((abstention/inscrits)*100,1)][,votes_votant:=round((voix/votants)*100,1)]

carte_dep[,blancs_inscrits:=round((blanc/inscrits)*100,1)][,abstention_inscrits:=round((abstention/inscrits)*100,1)][,votes_votant:=round((voix/votants)*100,1)]




carte_deptol1=carte_dep %>%
    filter(!is.na(long) & place==1)

carte_deptol1$tooltip <- c(paste0("Nom: ", carte_deptol1$nom, ", Voix: ", carte_deptol1$voix, ", Département: ", carte_deptol1$dep))


g1=ggplot(carte_dep[!is.na(long) & place==1,], aes(long, lat, group = group,tooltip=carte_deptol1$tooltip))+
    geom_polygon_interactive(aes(fill = nom ), color = "white", size = 0.1)+ 
    scale_fill_manual(values = couleurs_T1)+ labs(fill = "Candidat") +
    theme(
        panel.border = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        # Modifier le trait des axes
        axis.line = element_blank()
    ) +
    facet_grid(.~tour)
ggiraph(code = print(g1), tooltip_extra_css = "background-color:gray;color:white;background-color:gray;color:white;font-style:italic;padding:10px;border-radius:10px 20px 10px 20px;",
        tooltip_opacity = 1)


carte_cant

carte_cant$tooltip <- c(paste0("Nom = ", carte_cant$nom, ", Ville = ", carte_cant$canton,", Voix = ", carte_cant$voix))

g5=ggplot(carte_cant)+
    geom_bar_interactive(aes(x = canton, y=votes_votant,fill=nom,tooltip=carte_cant$tooltip),color=couleurs_T2[1],stat="identity",position=position_dodge(), size = 0.1)+ 
    scale_fill_manual(values=couleurs_T2)+ 
    labs(fill = "Candidat") + xlab("")+ylab("% de voix par candidat")+
    ggtitle("gggggggggggggg")+theme(axis.text.x= element_text(size=12,colour = "#000000"))+
    theme_grey()+ scale_x_discrete(limits=c("Toulouse", "Montpellier", "Nîmes","Perpignan","Béziers")) + coord_flip()

ggiraph(code = print(g5), tooltip_extra_css = "background-color:gray;color:white;background-color:gray;color:white;font-style:italic;padding:10px;border-radius:10px 20px 10px 20px;",
        tooltip_opacity = 1)



carte_deptol6=carte_dep %>%
    filter(nom=="MACRON" & nom_region=="Occitanie" & tour=="Premier tour")

carte_deptol6$tooltip <- c(paste0("Nom: ", carte_deptol6$nom, ", Voix: ", carte_deptol6$voix, ", Département: ", carte_deptol6$dep))

g6=ggplot(carte_dep[nom=="MACRON" & nom_region=="Occitanie" & tour=="Premier tour",], aes(long, lat, group = group,tooltip=carte_deptol6$tooltip))+
    geom_polygon_interactive(aes(fill = votes_votant), color = "white", size = 0.1)+ 
    scale_fill_gradient(low="#ECEEF0", high=couleurs_T1[3])+
    theme(
        panel.border = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        # Modifier le trait des axes
        axis.line = element_blank()
    ) + labs(fill = "Votes en fonction \ndu nombre de votes \npar département en %") 

ggiraph(code = print(g6), tooltip_extra_css = "background-color:gray;color:white;background-color:gray;color:white;font-style:italic;padding:10px;border-radius:10px 20px 10px 20px;",
        tooltip_opacity = 1)





carte_deptol7=carte_dep %>%
    filter(nom=="MACRON" & nom_region=="Occitanie" & tour=="Second tour")


carte_deptol7$tooltip <- c(paste0("Nom: ", carte_deptol7$nom, ", Voix: ", carte_deptol7$voix, ", Département: ", carte_deptol7$dep))


g7=ggplot(carte_dep[nom=="MACRON" & nom_region=="Occitanie" & tour=="Second tour",], aes(long, lat, group = group,tooltip=carte_deptol7$tooltip))+
    geom_polygon_interactive(aes(fill = votes_votant), color = "white", size = 0.1)+ 
    scale_fill_gradient(low="#ECEEF0", high=couleurs_T1[3])+
    theme(
        panel.border = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        # Modifier le trait des axes
        axis.line = element_blank()
    ) + labs(fill = "Votes en fonction \ndu nombre de votes \npar département en %") 

ggiraph(code = print(g7), tooltip_extra_css = "background-color:gray;color:white;background-color:gray;color:white;font-style:italic;padding:10px;border-radius:10px 20px 10px 20px;",
        tooltip_opacity = 1)






carte_deptol8=carte_dep %>%
    filter(nom=="LE PEN" & nom_region=="Occitanie" & tour=="Premier tour")


carte_deptol8$tooltip <- c(paste0("Nom: ", carte_deptol8$nom, ", Voix: ", carte_deptol8$voix, ", Département: ", carte_deptol8$dep))

g8=ggplot(carte_dep[nom=="LE PEN" & nom_region=="Occitanie" & tour=="Premier tour",], aes(long, lat, group = group,tooltip=carte_deptol8$tooltip))+
    geom_polygon_interactive(aes(fill = votes_votant), color = "white", size = 0.1)+ 
    scale_fill_gradient(low="#ECEEF0", high=couleurs_T1[2])+
    theme(
        panel.border = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        # Modifier le trait des axes
        axis.line = element_blank()
    ) + labs(fill = "Votes en fonction \ndu nombre de votes \npar département en %") 

ggiraph(code = print(g8), tooltip_extra_css = "background-color:gray;color:white;background-color:gray;color:white;font-style:italic;padding:10px;border-radius:10px 20px 10px 20px;",
        tooltip_opacity = 1)



carte_deptol9=carte_dep %>%
    filter(nom=="LE PEN" & nom_region=="Occitanie" & tour=="Second tour")

carte_deptol9$tooltip <- c(paste0("Nom: ", carte_deptol9$nom, ", Voix: ", carte_deptol9$voix, ", Département: ", carte_deptol9$dep))


g9=ggplot(carte_dep[nom=="LE PEN" & nom_region=="Occitanie" & tour=="Second tour",], aes(long, lat, group = group,tooltip=carte_deptol9$tooltip))+
    geom_polygon_interactive(aes(fill = votes_votant), color = "white", size = 0.1)+ 
    scale_fill_gradient(low="#ECEEF0", high=couleurs_T1[2])+
    theme(
        panel.border = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        # Modifier le trait des axes
        axis.line = element_blank()
    ) + labs(fill = "Votes en fonction \ndu nombre de votes \npar département en %") 
ggiraph(code = print(g9), tooltip_extra_css = "background-color:gray;color:white;background-color:gray;color:white;font-style:italic;padding:10px;border-radius:10px 20px 10px 20px;",
        tooltip_opacity = 1)



carte_deptol10=carte_dep %>%
    filter(nom=="MÉLENCHON" & nom_region=="Occitanie" & tour=="Premier tour")


carte_deptol10$tooltip <- c(paste0("Nom: ", carte_deptol10$nom, ", Voix: ", carte_deptol10$voix, ", Département: ", carte_deptol10$dep))

g10=ggplot(carte_dep[nom=="MÉLENCHON" & nom_region=="Occitanie" & tour=="Premier tour",], aes(long, lat, group = group,tooltip=carte_deptol10$tooltip))+
    geom_polygon_interactive(aes(fill = votes_votant), color = "white", size = 0.1)+ 
    scale_fill_gradient(low="#ECEEF0", high=couleurs_T1[4])+
    theme(
        panel.border = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        # Modifier le trait des axes
        axis.line = element_blank()
    ) + labs(fill = "Votes en fonction \ndu nombre de votes \npar département en %") 

ggiraph(code = print(g10), tooltip_extra_css = "background-color:gray;color:white;background-color:gray;color:white;font-style:italic;padding:10px;border-radius:10px 20px 10px 20px;",
        tooltip_opacity = 1)


carte_deptol11=carte_dep %>%
    filter(nom=="FILLON" & nom_region=="Occitanie" & tour=="Premier tour")


carte_deptol11$tooltip <- c(paste0("Nom: ", carte_deptol11$nom, ", Voix: ", carte_deptol11$voix, ", Département: ", carte_deptol11$dep))

g11=ggplot(carte_dep[nom=="FILLON" & nom_region=="Occitanie" & tour=="Premier tour",], aes(long, lat, group = group,tooltip=carte_deptol10$tooltip))+
    geom_polygon_interactive(aes(fill = votes_votant), color = "white", size = 0.1)+ 
    scale_fill_gradient(low="#ECEEF0", high=couleurs_T1[1])+
    theme(
        panel.border = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        # Modifier le trait des axes
        axis.line = element_blank()
    ) + labs(fill = "Votes en fonction \ndu nombre de votes \npar département en %") 
ggiraph(code = print(g11), tooltip_extra_css = "background-color:gray;color:white;background-color:gray;color:white;font-style:italic;padding:10px;border-radius:10px 20px 10px 20px;",
        tooltip_opacity = 1)


carte_cant$tooltip <- c(paste0("Nom = ", carte_cant$nom, ", Voix = ", carte_cant$voix))


g12=ggplot(carte_cant)+
    geom_bar_interactive(aes(x = canton, y=abstention_inscrits,tooltip=carte_cant$tooltip),fill="#E61D23",stat="identity",position=position_dodge(),width =0.6)+ 
    labs(fill = "Candidat") + xlab("")+
    ylab("% de voix par candidat")+
    ggtitle("Pourcentage d'd'abstention du second\npour les 5 villes les plus importantes d'Occitanie")+theme(axis.text.x= element_text(size=12,colour = "#000000"))+
    theme_grey()+ scale_x_discrete(limits=c("Toulouse", "Montpellier", "Nîmes","Perpignan","Béziers"))+ coord_flip()
ggiraph(code = print(g12), tooltip_extra_css = "background-color:gray;color:white;background-color:gray;color:white;font-style:italic;padding:10px;border-radius:10px 20px 10px 20px;",
        tooltip_opacity = 1)





carte_cant$tooltip <- c(paste0("Nom: ", carte_cant$nom, ", Voix = ", carte_cant$voix, ", Département: ", carte_cant$canton))
g15=ggplot(carte_cant)+
    geom_bar_interactive(aes(x = canton, y=blancs_inscrits,tooltip=carte_cant$tooltip),fill="#E6B52E",stat="identity",position=position_dodge(),width =0.6)+ 
    labs(fill = "Candidat") + xlab("")+
    ylab("% de voix par candidat")+
    ggtitle("Pourcentage de votes blancs du second\npour les 5 villes les plus importantes d'Occitanie")+theme(axis.text.x= element_text(size=12,colour = "#000000"))+
    theme_grey()+ scale_x_discrete(limits=c("Toulouse", "Montpellier", "Nîmes","Perpignan","Béziers")) + coord_flip()

ggiraph(code = print(g15), tooltip_extra_css = "background-color:gray;color:white;background-color:gray;color:white;font-style:italic;padding:10px;border-radius:10px 20px 10px 20px;",
        tooltip_opacity = 1)


carte_deptol13=carte_dep %>%
    filter(place==1 & nom_region=="Occitanie")

carte_deptol13$tooltip <- c(paste0("Nom: ", carte_deptol13$nom, ", Voix: ", carte_deptol13$voix, ", Département: ", carte_deptol13$dep))

g13=ggplot(carte_dep[place==1 & nom_region=="Occitanie",], aes(long, lat, group = group,tooltip=carte_deptol13$tooltip ))+
    geom_polygon_interactive(aes(fill = abstention_inscrits), color = "white", size = 0.1)+ 
    scale_fill_gradient(low="#ECEEF0", high="#E61D23", limits=c(15,25))+
    theme(
        panel.border = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        # Modifier le trait des axes
        axis.line = element_blank()
    ) +
    ggtitle(paste("Abstention premier tour"))+ labs(fill = "Asbtention par rapport au nombre d'inscrits en %") + facet_grid(.~tour)
ggiraph(code = print(g13), tooltip_extra_css = "background-color:gray;color:white;background-color:gray;color:white;font-style:italic;padding:10px;border-radius:10px 20px 10px 20px;",
        tooltip_opacity = 1)



carte_deptol14=carte_dep %>%
    filter(place==1 & nom_region=="Occitanie")
carte_deptol14

carte_deptol14$tooltip <- c(paste0("Nom: ", carte_deptol14$nom, ", Voix: ", carte_deptol14$voix, ", Département: ", carte_deptol14$dep))

g14=ggplot(carte_dep[place==1 & nom_region=="Occitanie",], aes(long, lat, group = group,tooltip=carte_deptol14$tooltip))+
    geom_polygon_interactive(aes(fill = blancs_inscrits), color = "white", size = 0.1)+ 
    scale_fill_gradient(low="#ECEEF0", high="#E6B52E")+
    theme(
        panel.border = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        # Modifier le trait des axes
        axis.line = element_blank()
    ) +
    ggtitle(paste("Votes blancs"))+ labs(fill = "Votes blancs par rapport au nombre d'inscrits en %") + facet_grid(.~tour) +
    theme(text=element_text(size=16, family="Arial"))
ggiraph(code = print(g14), tooltip_extra_css = "background-color:gray;color:white;background-color:gray;color:white;font-style:italic;padding:10px;border-radius:10px 20px 10px 20px;",
        tooltip_opacity = 1)



# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    
    ################G1########################
    ######DÃ©faut cartes france
    #####G1 ga1
    v <- reactiveValues(data = NULL)
    v2 <- reactiveValues(data = NULL)
    v3 <- reactiveValues(data = NULL)
    v4 <- reactiveValues(data = NULL)
    
    observeEvent(input$G1_occitanie, {
        v$data <- carte_dep[!is.na(long) & place==1 & nom_region=="Occitanie",]
        v2$data=1
    })
    observeEvent(input$G1_FR, {
        v$data <- carte_dep[!is.na(long) & place==1,]
        v2$data=NULL
    })
    observeEvent(input$G2_T1, {
        v3$data=1
    })
    observeEvent(input$G2_T2, {
        v3$data=NULL
    })
    observeEvent(input$G3_abstention, {
        v4$data=1
    })
    observeEvent(input$G3_blancs, {
        v4$data=NULL
    })
    
    
    output$ga1 <- renderggiraph({
        if (is.null(v$data)) return(ggiraph(code = print(g1), tooltip_extra_css = "background-color:gray;color:white;background-color:gray;color:white;font-style:italic;padding:10px;border-radius:10px 20px 10px 20px;",
                                            tooltip_opacity = 1))
        g1=ggplot((v$data),aes(long, lat, group = group,tooltip=carte_deptol1$tooltip))+
            geom_polygon_interactive(aes(fill = nom ), color = "white", size = 0.1)+ 
            scale_fill_manual(values = couleurs_T1)+ labs(fill = "Candidat") +
            theme(
                panel.border = element_blank(),
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank(),
                # Modifier le trait des axes
                axis.line = element_blank()
            ) +
            facet_grid(.~tour)
        ggiraph(code = print(g1), tooltip_extra_css = "background-color:gray;color:white;font-style:italic;padding:10px;border-radius:10px 20px 10px 20px;",
                tooltip_opacity = 1)
        
                  
                  
                  
    })
    
    output$ga3 <- renderggiraph({
        if (is.null(v2$data)) return()
        g5=ggplot((v2$data),aes(x = canton, y=votes_votant,fill=nom,tooltip=carte_cant$tooltip),color=couleurs_T2[1],stat="identity",position=position_dodge(), size = 0.1)+ 
            scale_fill_manual(values=couleurs_T2)+ 
            labs(fill = "Candidat") + xlab("")+
            ylab("% de voix par candidat")+
            ggtitle("gjhfughfvk,fc")+theme(axis.text.x= element_text(size=12,colour = "#000000"))+
            theme_grey()+ scale_x_discrete(limits=c("Toulouse", "Montpellier", "Nîmes","Perpignan","Béziers")) + coord_flip()
        
        ggiraph(code = print(g5), tooltip_extra_css = "background-color:gray;color:white;font-style:italic;padding:10px;border-radius:10px 20px 10px 20px;",
                tooltip_opacity = 1)
       
    })
    
    output$ga4 <- renderggiraph({
        if (is.null(v3$data)) return(ggiraph(code = print(g7), tooltip_extra_css = "background-color:gray;color:white;font-style:italic;padding:10px;border-radius:10px 20px 10px 20px;",
                                             tooltip_opacity = 1))
        g6=ggplot((v3$data),aes(long, lat, group = group,tooltip=carte_deptol6$tooltip))+
            geom_polygon_interactive(aes(fill = votes_votant), color = "white", size = 0.1)+ 
            scale_fill_gradient(low="#ECEEF0", high=couleurs_T1[3])+
            theme(
                panel.border = element_blank(),
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank(),
                # Modifier le trait des axes
                axis.line = element_blank()
            ) + labs(fill = "Votes en fonction \ndu nombre de votes \npar département en %") 
        
        ggiraph(code = print(g6), tooltip_extra_css = "background-color:gray;color:white;font-style:italic;padding:10px;border-radius:10px 20px 10px 20px;",
                tooltip_opacity = 1)
        
        
        
        
        
    })
    output$ga5 <- renderggiraph({
        if (is.null(v3$data)) return(ggiraph(code = print(g9), tooltip_extra_css = "background-color:gray;color:white;font-style:italic;padding:10px;border-radius:10px 20px 10px 20px;",
                                             tooltip_opacity = 1))
        ggiraph(code = print(g8), tooltip_extra_css = "background-color:gray;color:white;font-style:italic;padding:10px;border-radius:10px 20px 10px 20px;",
                tooltip_opacity = 1)
    })
    
    
    output$ga6 <- renderggiraph({
        if (is.null(v3$data)) return()
        ggiraph(code = print(g10), tooltip_extra_css = "background-color:gray;color:white;font-style:italic;padding:10px;border-radius:10px 20px 10px 20px;",
                tooltip_opacity = 1)
    })
    output$ga7 <- renderggiraph({
        if (is.null(v3$data)) return()
        ggiraph(code = print(g11), tooltip_extra_css = "background-color:gray;color:white;font-style:italic;padding:10px;border-radius:10px 20px 10px 20px;",
                tooltip_opacity = 1)
    })
    output$ga8 <- renderggiraph({
        if (is.null(v4$data)) return(ggiraph(code = print(g14), tooltip_extra_css = "background-color:gray;color:white;font-style:italic;padding:10px;border-radius:10px 20px 10px 20px;",
                                             tooltip_opacity = 1))
        ggiraph(code = print(g13), tooltip_extra_css = "background-color:gray;color:white;background-color:gray;color:white;font-style:italic;padding:10px;border-radius:10px 20px 10px 20px;",
                tooltip_opacity = 1)
    })
    
    
    
    
    output$ga9 <- renderggiraph({
        if (is.null(v4$data)) return(ggiraph(code = print(g15), tooltip_extra_css = "background-color:gray;color:white;background-color:gray;color:white;font-style:italic;padding:10px;border-radius:10px 20px 10px 20px;",
                                             tooltip_opacity = 1))
        
        
        
        ggiraph(code = print(g12), tooltip_extra_css = "background-color:gray;color:white;background-color:gray;color:white;font-style:italic;padding:10px;border-radius:10px 20px 10px 20px;",
                tooltip_opacity = 1)
    })
    
    
    
})
