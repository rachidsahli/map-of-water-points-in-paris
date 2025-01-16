# Import library ---------------

library(shiny) # Application
library(bslib) # Application
library(htmltools) # Manipulation de contenu html
library(dplyr) # Manipulation de données
library(leaflet) # Carte
library(leaflet.extras) # Carte
library(rsconnect) # Déploiement de l'application
library(tidyr) # Manipulation de données

# Import data ---------------

eau <- read.csv("eau.csv")

# UI --------------- 

ui <- page_sidebar(
  
  theme = bs_theme(bootswatch = "yeti"),
  title = "Fontaines de Paris",  
  id = "page",
  lang = "fr",
  
  sidebar = sidebar(
    title = "Menu",
    
    input_dark_mode(),
    
    selectInput("Lieu_filtre", "Choisissez un lieu", 
                choices = c("Tous", unique(eau$Nom_df)), selected = "Tous"),
    
    selectInput("fond_carte", "Fond de carte", 
                choices = c("Classique", "Satellite", "Nocturne"), 
                selected = "Classique"),
    
    actionButton("recentrer", "Recentrer sur Paris"),
    
    actionButton("quit_button", "Quitter", icon = icon("sign-out-alt"), class = "btn-danger"),
    
    
  ),
  
  div(
    style = "padding: 10px; text-align: center;",
    h2("Où boire de l'eau à Paris ?"),
    h5("Paris regorge de fontaines publiques où vous pouvez vous désaltérer gratuitement. Cette carte interactive vous permet de localiser les fontaines et de découvrir où elles se trouvent dans la ville. Explorez les différents types de fontaines et leur accessibilité pour vous rafraîchir pendant vos promenades.")
  ),
  
  # Carte
  card(
    full_screen = TRUE,
    div(
      style = "position: relative; height: 100%;",  
      leafletOutput("carte", width = "100%", height = "100%")
    ),
    card_footer(
      popover(
        a("En savoir plus"),
        markdown("Cette carte a été réalisée à partir des données disponibles sur le site [data.gouv.fr](https://www.data.gouv.fr/fr/). 
        Les points d'eau indiqués peuvent avoir évolué, notamment en ce qui concerne les îlots et équipements verts, dont certains ont été installés spécifiquement pour les Jeux Olympiques de 2024.
")
      )
    )
  )
)


# SERVER --------------- 

server <- function(input, output) {
  
  # Activation boutons quitter
  observeEvent(input$quit_button, {
    stopApp()  
  })
  
  # Changement fond carte
  observe({
    fond <- switch(input$fond_carte,
                   "Classique" = providers$OpenStreetMap,
                   "Satellite" = providers$Esri.WorldImagery,
                   "Nocturne" = providers$CartoDB.DarkMatter)
    
    leafletProxy("carte") %>%
      clearTiles() %>%
      addProviderTiles(fond)
  })
  
  # Recentrer sur Paris
  observeEvent(input$recentrer, {
    leafletProxy("carte") %>%
      setView(lng = 2.3522, lat = 48.8566, zoom = 12)
  })
  
  # Filtre lieu
  eau_filtre <- reactive({
    if (input$Lieu_filtre == "Tous") {
      return(eau)
    } else {
      return(subset(eau, Nom_df == input$Lieu_filtre))
    }
  })
  
  # Carte points d'eau
  output$carte <- renderLeaflet({
    leaflet(eau_filtre()) %>%
      addTiles() %>%
      addAwesomeMarkers(
        ~lon, ~lat,
        popup = ~paste0(
          Lieu,
          ifelse(!is.na(payant), paste0("<br> Payant : ", payant), ""),
          ifelse(!is.na(Numéro.voie), paste0("<br> Adresse : ",Numéro.voie," ",Nom.voie), ""),
          ifelse(!is.na(Voie), paste0("<br>",Voie),""),
          ifelse(!is.na(adresse.x), paste0("<br> Adresse : ",adresse.x),""),
          ifelse(!is.na(horaires_lundi), paste0("<br> Lundi : ",horaires_lundi),""),
          ifelse(!is.na(horaires_mardi), paste0("<br> Mardi : ",horaires_mardi),""),
          ifelse(!is.na(horaires_mercredi), paste0("<br> Mercredi : ",horaires_mercredi),""),
          ifelse(!is.na(horaires_jeudi), paste0("<br> Jeudi : ",horaires_jeudi),""),
          ifelse(!is.na(horaires_vendredi), paste0("<br> Vendredi : ",horaires_vendredi),""),
          ifelse(!is.na(horaires_samedi), paste0("<br> Samedi : ",horaires_samedi),""),
          ifelse(!is.na(horaires_dimanche), paste0("<br> Dimanche : ",horaires_dimanche),""),
          ifelse(!is.na(internet_1), paste0("<br> ",internet_1),"")
        ),
        icon = ~awesomeIcons(
          icon = ~Icons,  
          iconColor = "black",
          library = "fa",
          markerColor = ~Couleur  
        ),
        clusterOptions = markerClusterOptions()
      ) %>%
      addLegend(
        position = "topright",
        colors = c("purple", "lightblue", "orange", "lightgreen"),
        labels = c("Commerce", "Fontaine", "Bâtiments public", "Espace vert"),
        title = "Lieu",
        opacity = 0.9
      ) %>%
      addSearchOSM(
        options = searchOptions(
          zoom = 15,
          textPlaceholder = "Rechercher un lieu en France..."
        )
      ) %>%
      addFullscreenControl() %>% 
      setView(lng = 2.333333, lat = 48.866667, zoom = 11)
  })
}

# RUN APP --------------- 

shinyApp(ui = ui, server = server)

# Simulation de déploiement
# rsconnect::deployApp()

# Vérification journaux de déploiement
# rsconnect::showLogs()
