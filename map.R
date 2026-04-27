

# Step 1. load the dataset ####
load("active_dengue_transmission_2026.RData")



load("persistent_dengue_transmission.RData")

mex_link |>
    mapview::mapview(popup = "Estado",
                     legend = FALSE,
                     color = "#e6d194", 
                     alpha.regions = 1,
                     col.regions = "#691C32")