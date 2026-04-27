

# Step 1. make the tible link ####
link <- tibble::tibble(CVE_ENT = c("01","02", "03", "04", "05",
                                   
                                   "06", "07","08", "09", "10",
                                   
                                   "11", "12", "13", "14", "15",
                                   
                                   "16", "17", "18", "19", "20",
                                   
                                   "21", "22","23","24", "25",
                                   
                                   "26", "27", "28",
                                   #"29",
                                   "30",
                                   
                                   "31", "32"),
                       link = c("https://unrivaled-brigadeiros-1382f3.netlify.app",  # 01
                                "https://admirable-manatee-d63392.netlify.app",      # 02
                                "https://resonant-lamington-213eaa.netlify.app",     # 03
                                "https://spectacular-clafoutis-0da912.netlify.app",  # 04
                                "https://stately-blancmange-201518.netlify.app",     # 05
                                "https://thunderous-lokum-bd4f9a.netlify.app",       # 06
                                "https://keen-empanada-1560f6.netlify.app",          # 07
                                "https://candid-mermaid-0b4c86.netlify.app",         # 08
                                "https://lustrous-chaja-e64e35.netlify.app",         # 09
                                "https://courageous-buttercream-d9f7b9.netlify.app", # 10,
                                "https://golden-marigold-dcf3ae.netlify.app",        # 11
                                "https://chic-torte-96f7af.netlify.app",             # 12
                                "https://cozy-alpaca-6a09ee.netlify.app",            # 13
                                "https://rococo-liger-b1cb6e.netlify.app",           # 14
                                "https://effulgent-duckanoo-42fd18.netlify.app",     # 15
                                "https://gleeful-mousse-0d5b05.netlify.app",         # 16
                                "https://keen-starlight-16885b.netlify.app",         # 17
                                "https://marvelous-babka-70d1cb.netlify.app",        # 18
                                "https://iridescent-chimera-e0ad09.netlify.app",     # 19
                                "https://inspiring-cranachan-e486d6.netlify.app",    # 20
                                "https://calm-phoenix-18c04a.netlify.app",           # 21
                                "https://meek-arithmetic-311c9c.netlify.app",        # 22
                                "https://cheerful-mousse-4505bf.netlify.app",        # 23
                                "https://zingy-moonbeam-95d47f.netlify.app",         # 24
                                "https://profound-buttercream-3bfee3.netlify.app",   # 25
                                "https://polite-sunburst-1d5e9c.netlify.app",        # 26
                                "https://peppy-granita-0a7d31.netlify.app",          # 27
                                "https://lovely-pika-abd38d.netlify.app",            # 28
                                # 29
                                "https://glowing-gelato-676090.netlify.app",         # 30
                                "https://boisterous-douhua-506ac6.netlify.app",      # 31
                                "https://chipper-liger-bff066.netlify.app"          # 32
                           
                       ))

# Step 3. left joint ####
mex_link <- dplyr::left_join(x = link,
                             y = rgeomex::AGEE_inegi19_mx,
                             by = "CVE_ENT") |>
    dplyr::mutate(Estado = paste0(": <a href=", 
                                  link,">", 
                                  NOMGEO, "</a>")) |>
    as.data.frame() |>
    sf::st_set_geometry(value = "geometry") 


# map #### 
mex_link |>
    mapview::mapview(popup = "Estado",
                     legend = FALSE,
                     color = "#e6d194", 
                     alpha.regions = 1,
                     col.regions = "#691C32")


save(mex_link,
     file = "persistent_dengue_transmission.RData")
