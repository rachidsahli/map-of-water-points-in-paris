# Import library ----------
library(dplyr)
library(tidyr)
library(leaflet)
library(leaflet.extras)

# Import data ----------
commerce_eau <- read.csv("commerces-eau-de-paris.csv", header = TRUE, sep = ";")
fontaines_a_boire <- read.csv("fontaines-a-boire.csv", header = TRUE, sep = ";")
ilots_equipements <- read.csv("ilots-de-fraicheur-equipements-activites.csv", header = TRUE, sep = ";")
ilots_espaces_verts <- read.csv("ilots-de-fraicheur-espaces-verts-frais.csv", header = TRUE, sep = ";")

# Cleaning ----------
# Commerce_eau file
sapply(commerce_eau, function(x) sum(is.na(x)))

commerce_eau <- subset(commerce_eau, select = -c(Code.postal, Nom.commune, geo_shape, geo_point_2d))

commerce_eau$num_voie <- as.character(commerce_eau$Numéro.voie)

# Fontaines_a_boire file
sapply(fontaines_a_boire, function(x) sum(is.na(x)))

fontaines_a_boire <- subset(fontaines_a_boire, select = -c(N..Voie.Pair,N..Voie.Impair,Début.Indisponibilité,
                                                           Fin.Indisponibilité,Motif.Indisponibilité,geo_shape))

fontaines_a_boire <- fontaines_a_boire %>% 
  separate(geo_point_2d, into = c("lat","lon"), sep = ",") %>% 
  mutate(across(c(lat, lon), as.numeric))

# Ilots_equipements file
sapply(ilots_equipements, function(x) sum(is.na(x)))

ilots_equipements <- subset(ilots_equipements, select = -c(id_dicom, statut_ouverture, geo_shape, proposition_usager))

ilots_equipements <- ilots_equipements %>% 
  separate(geo_point_2d, into = c("lat","lon"), sep = ",") %>% 
  mutate(across(c(lat, lon), as.numeric))

# Ilots_espaces_verts file
sapply(ilots_espaces_verts, function(x) sum(is.na(x)))

ilots_espaces_verts <- subset(ilots_espaces_verts, select = -c(proportion_vegetation_haute,
                                                               geo_shape, mail_2,internet_2, date_fermeture))

ilots_espaces_verts <- ilots_espaces_verts %>% 
  separate(geo_point_2d, into = c("lat","lon"), sep = ",") %>% 
  mutate(across(c(lat, lon), as.numeric))

# Join
commerce_eau <- commerce_eau %>% 
  mutate(Nom_df = "Commerce")

fontaines_a_boire <- fontaines_a_boire %>% 
  mutate(Nom_df = "Fontaines")

ilots_equipements <- ilots_equipements %>% 
  mutate(Nom_df = "Equipements")

ilots_espaces_verts <- ilots_espaces_verts %>% 
  mutate(Nom_df = "ilots_espaces_verts")

commerce_eau <- commerce_eau %>% 
  rename(Lieu = "Nom.du.commerce")

fontaines_a_boire <- fontaines_a_boire %>% 
  mutate(Lieu = "Fontaines")

ilots_equipements <- ilots_equipements %>% 
  rename(Lieu = "nom")

ilots_espaces_verts <- ilots_espaces_verts %>% 
  rename(Lieu = "nom_ev")

commerce_eau <- commerce_eau %>% 
  rename(lon = "Longitude",
         lat = "Latitude")

eau <- commerce_eau %>%
  full_join(fontaines_a_boire, by = c("Lieu" = "Lieu", "lat" = "lat", "lon" = "lon", "Nom_df" = "Nom_df")) %>%
  full_join(ilots_equipements, by = c("Lieu" = "Lieu", "lat" = "lat", "lon" = "lon", "Nom_df" = "Nom_df" )) %>%
  full_join(ilots_espaces_verts, by = c("Lieu" = "Lieu", "lat" = "lat", "lon" = "lon", "Nom_df" = "Nom_df" ))

# Colors and icons
eau <- eau %>%
  mutate(
    Icons = case_when(
      Nom_df == "Commerce" ~ "shopping-cart",   
      Nom_df == "Fontaines" ~ "tint",         
      Nom_df == "Equipements" ~ "building",  
      Nom_df == "ilots_espaces_verts" ~ "tree"  
    ),
    
    Couleur = case_when(
      Nom_df == "Commerce" ~ "purple",          
      Nom_df == "Fontaines" ~ "lightblue",      
      Nom_df == "Equipements" ~ "orange",   
      Nom_df == "ilots_espaces_verts" ~ "lightgreen"
    )
  )

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

