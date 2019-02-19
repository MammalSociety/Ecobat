
# # Total Bat Passes by Night 
# ## All Detectors  

Table <- All_data %>%
  group_by(Spp, Night) %>% 
  count() %>% 
  spread(Night, n)

# Make all NA's = 0
Table[is.na(Table)] <- 0


# code for having species as the rownames on the left
Table2 <- Table %>%
  remove_rownames %>%
  column_to_rownames(var="Spp") 

# list <- c(unique(Table$Species))
# Table3 <- as.data.frame(t(Table[,-1]))
# colnames(Table3) <- list

results='asis' #important to run this as it ensures the raw table output isn't processed further by knitr

panderOptions('table.split.table', 120)

pander(Table2, style = "multiline", justify = "left")




# Total Bat Passes by Night
# Per Detector

if(length(Dets) >1) {
  
  Table <- All_data %>%
    group_by(SppDets, Night) %>% 
    count() %>% 
    spread(Night, n)
  
  # Make all NA's = 0
  Table[is.na(Table)] <- 0
  
  
  # code for having species as the rownames on the left
  Table2 <- Table %>%
    remove_rownames %>%
    column_to_rownames(var="SppDets")
  
  # if wanting species along the top:
  # list <- c(unique(Table$Species))
  # Table3 <- as.data.frame(t(Table[,-1]))
  # colnames(Table3) <- list
  
  results='asis' #important to run this as it ensures the raw table output isn't processed further by knitr
  
  panderOptions('table.split.table', 100)
  panderOptions('table.split.cells', 2)
  
  pander(Table2, style = "multiline")
}




## Mean Bat Passes per Hour

#Computed as (total bat passes per night)/(night length in hours).**
  
Table <- All_data %>%
  group_by(Spp, Night, night_length_hr) %>% 
  # count number of passes per night by species - makes coloumn "n""
  count() %>% 
  # calculate average bat passes per hour for each Night and species
  summarise(Act_per_hr = n / night_length_hr) %>%
  # Remove Night Length column from the Table
  select(-night_length_hr) %>% 
  spread(Night, Act_per_hr)

# Make all NA's = 0
Table[is.na(Table)] <- 0

Table2 <- Table %>% 
  remove_rownames %>% 
  column_to_rownames(var="Spp")


results='asis' #important to run this as it ensures the raw table output isn't processed further by knitr

panderOptions('table.split.table', 100)
panderOptions('round', 1)

pander(Table2, style = "multiline")
