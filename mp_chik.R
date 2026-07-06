load("~/Library/CloudStorage/Dropbox/dataset/automatic_read_sinave/8.RData/den/dengue_loc/2026/dengue_loc_2026.RData")

library(leaflet)
library(leaflet.extras)

data <- chik
data <- data |> 
    #dplyr::select(dplyr::all_of(var)) |>
    dplyr::mutate(n = confirmado) |>
    dplyr::filter(n >= 1)


# Paleta de color continua
pal <- leaflet::colorNumeric(palette = viridis::viridis(10,
                                                        option = "D"),
                             domain = data$n)

# Escala de radio proporcional
radio <- function(x, r_min = 4, r_max = 20) {
    r_min + (x - min(x)) / (max(x) - min(x)) * (r_max - r_min)
}

leaflet(data) |>
    # Capas base
    addProviderTiles("CartoDB.Positron",      group = "Positron") |>
    addProviderTiles("Esri.WorldImagery",     group = "Satelite") |>
    addProviderTiles("OpenStreetMap",         group = "OpenStreetMap") |>
    addProviderTiles("CartoDB.DarkMatter",    group = "Dark") |>
    addProviderTiles("Esri.WorldTopoMap",     group = "Topografico") |>
    # Círculos proporcionales
    addCircleMarkers(
        radius       = ~radio(n),
        color        = "white",
        weight       = 0.5,
        fillColor    = ~pal(n),
        fillOpacity  = 0.8,
        popup = ~paste0(
            "<b>Localidad:</b> ", cvegeo, "<br>",
            "<b>Confirmados:</b> ", "confirmado" , "<br>",
            "<b>Probables:</b> ", probable, "<br>"),
        label = ~paste0(cvegeo, ": ", n, "Confirmado"),
        labelOptions = labelOptions(
            style = list("font-size" = "12px"),
            textsize = "12px",
            direction = "auto"
        ),
        group = "Confirmados"
    ) |>
    # Leyenda de color
    addLegend(position = "bottomright",
              pal      = pal,
              values   = ~n,
              title    = "Casos<br>Confirmados",
              opacity  = 0.8
    ) |>
    # Control de capas
    addLayersControl(baseGroups    = c("Positron", "Satelite", 
                                       "OpenStreetMap", "Dark", 
                                       "Topografico"),
                     overlayGroups = c("Confirmados"),
                     options = layersControlOptions(collapsed = TRUE)) |>
    addScaleBar(position = "bottomleft") |>
    hideGroup("") 

