
# Step 1. make the tible link ####
link <- tibble::tibble(CVE_ENT = c("25", "26", "27", "30"),
                       link = c("https://dapper-bubblegum-16b79a.netlify.app",
                                "https://magnificent-boba-378005.netlify.app",
                                "https://polite-lily-6140a2.netlify.app",
                                "https://marvelous-pie-045c03.netlify.app"))

# Step 2. left joint ####
mex_link <- dplyr::left_join(x = link,
                             y = rgeomex::AGEE_inegi19_mx,
                             by = "CVE_ENT") |>
    dplyr::mutate(Estado = paste0(": <a href=", 
                                  link,">", 
                                  NOMGEO, "</a>")) |>
    as.data.frame() |>
    sf::st_set_geometry(value = "geometry") 




# Step 1. load the AGEE ####
mex <- rgeomex::AGEE_inegi19_mx |>
    dplyr::select(-NOMGEO)

# map #### 
mex_link |>
    mapview::mapview(popup = "Estado",
                     legend = FALSE,
                     color = "#e6d194", 
                     alpha.regions = 1,
                     col.regions = "#691C32")


save(mex_link,
     file = "active_dengue_transmission_2026.RData")

########
# Mapa completo con hover, leyenda y mejor UX
library(mapgl)
library(sf)

mapgl::maplibre(style  = mapgl::carto_style("positron"),
                bounds = sf::st_bbox(mex_link)) |>
    mapgl::add_source(id = "estados_fill",
                      data = mex_link) |>
    mapgl::add_source(id = "estados",
               data = mex) |>
    mapgl::add_line_layer(id  = "estados-borde",
                          source = "estados",
                          line_color = "#691C32",
                          #fill_color = "#E01A59",
                          #opacity = 0.6,
                          #fill_outline_color = "#FFFFFF",
                          line_width = 0.1) |>
    mapgl::add_fill_layer(id = "estados_fill",
                   source = "estados_fill",
                   fill_color = "#691C32",
                   fill_opacity = 1,
                   fill_outline_color = "#e6d194") |>
    mapgl::set_popup(layer_id = "estados_fill")


####

