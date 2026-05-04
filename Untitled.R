
library(sf)
library(magrittr)
library(mapgl)
load("/Users/fdzul/Documents/geocoding_mx_2026_dengue/4.RData/dengue_mx_2026.RData")
source("~/Library/CloudStorage/Dropbox/r_developments/r_dashboards/netlify/1.2.persisten_dengue_transmission_2026/persistent_dengue_transmission_10_durango/mp_heatmap.R")
source("~/Library/CloudStorage/Dropbox/r_developments/r_dashboards/netlify/1.2.persisten_dengue_transmission_2026/persistent_dengue_transmission_10_durango/mp_transmission_chains.R")
library(fishualize)

source("~/Library/CloudStorage/Dropbox/r_developments/r_dashboards/netlify/1.2.persisten_dengue_transmission_2026/persistent_dengue_transmission_10_durango/mp_dengue_cases.R")

# data
cdmx <- z |>
    dplyr::filter(DES_EDO_REP == "")


#######
# Step 1. create the week
data <- z |>
    dplyr::filter(IDE_EDA_ANO <= 12 | IDE_EDA_ANO >= 65) |>
    dplyr::mutate(onset = FEC_INI_SIGNOS_SINT) |>
    dplyr::select(ANO, long, lat, onset) |>
    dplyr::mutate(x = long,
                  y = lat) |>
    sf::st_as_sf(coords = c("x", "y"),
                 crs = 4326) |>
    dplyr::filter(ANO %in% c(2026)) |>
    dplyr::mutate(week = lubridate::epiweek(onset)) |>
    dplyr::mutate(week_factor = dplyr::case_when(week <= 10 ~ "1-10",
                                                 week > 10 & week <= 20 ~ "11-20",
                                                 week > 20 & week <= 25 ~ "21-25",
                                                 week > 25 & week <= 30 ~ "26-30",
                                                 week > 30 & week <= 35 ~ "31-35",
                                                 week > 35 & week <= 40 ~ "36-40",
                                                 week > 40 & week <= 45 ~ "41-45",
                                                 week > 45 & week <= 53 ~ "46-53")) |>
    dplyr::mutate(week_factor = factor(week_factor,
                                       levels = c("1-10",
                                                  "11-20",
                                                  "21-25",
                                                  "26-30",
                                                  "31-35",
                                                  "36-40",
                                                  "41-45",
                                                  "46-53"),
                                       ordered = TRUE)) 
# Step 2. extract the locality
loc <- rgeomex::AGEE_inegi19_mx |>
    dplyr::select(-NOMGEO)

# Step 3. extract the dengue cases in the locality
data <- data[loc, ] 


# map
# Step 3. 1. crea the palette
pal_colores <- fishualize::fish(n = 8,
                                option = "Scarus_hoefleri",
                                direction = -1)

# week_num como character
data$week_num <- as.character(as.integer(data$week_factor))

# map
maplibre(style  = carto_style("positron"),
         bounds = st_bbox(loc)) |>
    add_source("area", data = loc) |>
    add_line_layer(id         = "ciudad-borde",
                   source     = "area",
                   line_color = "#444444",
                   line_width = 1) |>
    add_circle_layer(id     = "casos-puntos",
                     source = data,
                     circle_color = match_expr(column  = "week_num",
                                               values  = as.character(1:8),
                                               stops   = pal_colores),
                     circle_stroke_color = "white",
                     circle_stroke_width = 1,
                     circle_radius       = 6,
                     tooltip             = "week_factor") |>
    add_categorical_legend(legend_title = "Semana",
                           values       = c("1-10","11-20","21-25","26-30",
                                            "31-35","36-40","41-45","46-53"),
                           colors       = pal_colores,
                           patch_shape  = "circle") |>
    add_fullscreen_control(position = "top-left") |> 
    add_navigation_control() |>
    add_globe_control() |>
    add_scale_control()


#####
z <- z |>
    dplyr::filter(IDE_EDA_ANO <= 12 | IDE_EDA_ANO >= 65) |>
    dplyr::mutate(onset = FEC_INI_SIGNOS_SINT) |>
    dplyr::select(ANO, long, lat, onset) |>
    dplyr::mutate(x = long,
                  y = lat) |>
    sf::st_as_sf(coords = c("x", "y"),
                 crs = 4326) 

# Step 2. extract the locality ####
loc <- rgeomex::AGEE_inegi19_mx |>
    dplyr::select(-NOMGEO)


# Step 3. extract the geocoded cases of merida ####
z <- z[loc, ]  |>
    dplyr::mutate(x = long,
                  y = lat) |>
    #sf::st_drop_geometry() |>
    dplyr::filter(ANO %in% c(2026))

#########

mapgl::maplibre(bounds = loc,
                color = NA,
                #width = "100%",
                #height = "400px",
                #style = carto_style(style_name = "voyager")
                style = mapgl::carto_style(style_name = "positron")) |>
    mapgl::add_source("area",  data = loc) |>
    mapgl::add_source("casos", data = z) |>
    # Límites de la ciudad
    mapgl::add_fill_layer(id           = "ciudad-fill",
                          source       = "area",
                          fill_color   = "transparent",
                          fill_opacity = 0) |>
    mapgl::add_line_layer(id             = "ciudad-borde",
                          source         = "area",
                          line_color     = "#444444",
                          #line_dasharray = c(1, 1)
                          line_width     = 1) |>
    mapgl::add_heatmap_layer(id = "dengue_cases",
                             source = "casos",
                             heatmap_weight = mapgl::interpolate(column = "mag",
                                                                 values = c(0, 6),
                                                                 stops = c(0, 1)),
                             heatmap_intensity = mapgl::interpolate(property = "zoom",
                                                                    values = c(0, 9),
                                                                    stops = c(1, 3)),
                             heatmap_color = mapgl::interpolate(property = "heatmap-density",
                                                                values = seq(from = 0, to = 1, by = 0.2),
                                                                stops = c('rgba(33,102,172,0)', 
                                                                          'rgb(103,169,207)',
                                                                          'rgb(209,229,240)', 
                                                                          'rgb(253,219,199)',
                                                                          'rgb(239,138,98)', 
                                                                          'rgb(178,24,43)')),
                             heatmap_opacity = 0.7) |>
    mapgl::add_fullscreen_control(position = "top-left") |> 
    mapgl::add_navigation_control() |>
    mapgl::add_globe_control() |>
    mapgl::add_scale_control()
