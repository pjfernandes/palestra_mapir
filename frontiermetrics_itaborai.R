library(frontiermetrics)
library(terra)

dir.create("itaborai_project")
setwd("itaborai_project")

# Retângulo cobrindo Itaboraí/RJ + COMPERJ (WGS84 / EPSG:4326)
# ordem do ext(): xmin, xmax, ymin, ymax  ->  lon_oeste, lon_leste, lat_sul, lat_norte
itaborai <- vect(ext(-42.95, -42.65, -22.85, -22.60), crs = "EPSG:4326")

# Baixar as camadas GFW para a área de estudo
get_gfw(study_area = itaborai,
        filenames = c("tree_cover_itaborai", "loss_year_itaborai"))

gfw_cover <- rast("tree_cover_itaborai.tif")
gfw_loss  <- rast("loss_year_itaborai.tif")

# Inicializar com grão FINO:
#   aggregation[1]=10 -> ~300 m ; aggregation[2]=3 -> ~900 m (célula final da métrica)
itaborai_dataset <- init_fmetrics(
  raster      = list(gfw_cover, gfw_loss),
  tag         = "Itaboraí/RJ (COMPERJ)",
  time_frame  = c(2000, 2024),
  aggregation = c(4, 4)
)

# Calcular só as duas métricas de interesse
itaborai_metrics <- fmetrics(itaborai_dataset, metrics = c("loss", "speed"))


# Plotar só loss e speed, valores contínuos, visual limpo
fmetrics_plot(itaborai_metrics,
              metrics   = c("loss", "speed"),
              what      = "values",
              ncol      = 1,
              palette   = "rocket",
              direction = -1)
