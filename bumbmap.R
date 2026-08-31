
# 
# Step 1. load the dengue dataset ####
path_sinave <- "/Users/fdzul/Documents/geocoding_mx_2026_dengue/1.data/semana_actual/DENGUE2_.txt"

x <- data.table::fread(path_sinave,
                       #select = vect_cols2,
                       encoding = "Latin-1",
                       quote="",
                       fill=TRUE)

# Step 2. load the function ####
source("~/Dropbox/r_developments/r_new_functions/3.Functions/static_bump_map.R")


static_bump_map(dataset = x,
                year = "2026",
                state = TRUE,
                size_text_value = 2,
                size_text_country = 2,
                country_text_x = 0.5,
                country_text_y = 0.8,
                line_size = 1.5,
                pal_vir = "viridis")


ggplot2::ggsave(filename = "bumbum_map.jpg",
                dpi = 400)

