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


# Modification dans la table eau.csv -----

# Correction du mot fontaine dans la variable Nom_df
eau$Lieu <- gsub("Fontaines", "Fontaine", eau$Lieu)

# Capitalisation d'uniquement la premiere lettre
eau$Nom.voie <- paste(toupper(substring(eau$Nom.voie, 1, 1)), tolower(substring(eau$Nom.voie, 2)), sep="")

# Correction du mot ilots/espaces_verts dans la variable Nom_df
eau$Nom_df <- gsub("ilots_espaces_verts", "Ilots/espaces verts", eau$Nom_df)

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

# Ecriture du fichier
write.csv(eau,"Data/eau.csv")
