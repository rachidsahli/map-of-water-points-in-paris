# Map
leaflet(eau) %>%
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
      icon = Icons,
      iconColor = "black",
      library = "fa",
      markerColor = Couleur),
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
      #openPopup = TRUE,
      textPlaceholder = "Rechercher un lieu en France..."
    )
  ) %>%
  addFullscreenControl() %>% 
  setView(lng = 2.333333, lat = 48.866667, zoom = 11)

