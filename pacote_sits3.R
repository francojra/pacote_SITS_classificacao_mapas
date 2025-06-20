
# Earth observation data cubes -------------------------------------------------------------------------------------------------------------
# Autora do script: Jeanne Franco ----------------------------------------------------------------------------------------------------------
# Data do script: 18/06/2025 ---------------------------------------------------------------------------------------------------------------
# Referência: https://e-sensing.github.io/sitsbook/earth-observation-data-cubes.html -------------------------------------------------------

# Carregar pacotes -------------------------------------------------------------------------------------------------------------------------

library(sits)
library(raster)
library(ggplot2)
library(ggspatial)

# Amazon Web Services ----------------------------------------------------------------------------------------------------------------------

# Criar um cubo de dados cobrindo uma área do Brasil

s2_23MMU_cube <- sits_cube(
  source = "AWS",
  collection = "SENTINEL-2-L2A",
  tiles = "23MMU",
  bands = c("B02", "B8A", "B11", "CLOUD"),
  start_date = "2018-07-12",
  end_date = "2019-07-28"
)

plot(s2_23MMU_cube,
  red = "B11",
  blue = "B02",
  green = "B8A",
  date = "2018-10-05"
)

# Microsoft Planetary Computer - SENTINEL-2/2A images in MPC -------------------------------------------------------------------------------

# Criar um cubo de dados cobrindo uma área da Amazônia

s2_20LKP_cube_MPC <- sits_cube(
  source = "MPC",
  collection = "SENTINEL-2-L2A",
  tiles = "20LKP",
  bands = c("B02", "B8A", "B11", "CLOUD"),
  start_date = "2019-07-01",
  end_date = "2019-07-28"
)

# Plotar uma composição de cor de uma data do cubo 

plot(s2_20LKP_cube_MPC,
  red = "B11", blue = "B02", green = "B8A",
  date = "2019-07-18"
)

# LANDSAT-C2-L2 images in MPC --------------------------------------------------------------------------------------------------------------

## Para essa coleção, pesquisa por tile não é suportado, o parâmetro 
## roi (região de interesse) deve ser usado para esse cubo. O
## exemplo abaixo mostra como recuperar dados de uma região de
## interesse cobrindo a cidade de Brasília.

# Ler um ROI que cobre parte da costa nordeste do Brasil

roi <- c(
  lon_min = -43.5526, lat_min = -2.9644,
  lon_max = -42.5124, lat_max = -2.1671
)

# Selecionar um cubo

s2_L8_cube_MPC <- sits_cube(
  source = "MPC",
  collection = "LANDSAT-C2-L2",
  bands = c("BLUE", "RED", "GREEN", "NIR08", "SWIR16", "CLOUD"),
  roi = roi,
  start_date = "2019-06-01",
  end_date = "2019-09-01"
)

# Plotar o tile que cobre os lençois maranhenses 

plot(s2_L8_cube_MPC,
  red = "RED", green = "GREEN", blue = "BLUE",
  date = "2019-06-30"
)

## Teste

roi <- c(
  lon_min = -47.6000, lat_min = -14.2000,
  lon_max = -47.5000, lat_max = -14.1000
)

s2_L8_cube_MPC <- sits_cube(
  source = "MPC",
  collection = "LANDSAT-C2-L2",
  bands = c("BLUE", "RED", "GREEN", "NIR08", "SWIR16", "CLOUD"),
  roi = roi,
  start_date = "2019-06-01",
  end_date = "2019-09-01"
)

View(s2_L8_cube_MPC)
sits_timeline(s2_L8_cube_MPC) # Importante sempre verificar as
# datas disponíveis para esse cubo com um diferente roi

plot(s2_L8_cube_MPC,
  red = "RED", green = "GREEN", blue = "BLUE",
  date = "2019-06-20"
)

sits::sits_bbox(s2_L8_cube_MPC)
summary(s2_L8_cube_MPC)

# SENTINEL-1-GRD images in MPC -------------------------------------------------------------------------------------------------------------

cube_s1_grd <- sits_cube(
  source = "MPC",
  collection = "SENTINEL-1-GRD",
  bands = c("VV"),
  orbit = "descending",
  tiles = c("21LUJ", "21LVJ"),
  start_date = "2021-08-01",
  end_date = "2021-09-30"
)

plot(cube_s1_grd, band = "VV", palette = "Greys")

# SENTINEL-1-RTC images in MPC -------------------------------------------------------------------------------------------------------------

cube_s1_rtc <- sits_cube(
  source = "MPC",
  collection = "SENTINEL-1-RTC",
  bands = c("VV", "VH"),
  orbit = "descending",
  tiles = "18NZM",
  start_date = "2021-08-01",
  end_date = "2021-09-30"
)

plot(cube_s1_rtc, band = "VV", palette = "Greys")

# Copernicus DEM 30 meter images in MPC ----------------------------------------------------------------------------------------------------

cube_dem_30 <- sits_cube(
  source = "MPC",
  collection = "COP-DEM-GLO-30",
  tiles = "20LMR",
  band = "ELEVATION"
)

plot(cube_dem_30, band = "ELEVATION", palette = "RdYlGn", rev = TRUE)

sits:sits_bbox(cube_dem_30)

# Brazil Data Cube -------------------------------------------------------------------------------------------------------------------------

# Define a tile from the CBERS-4/4A AWFI collection
cbers_tile <- sits_cube(
  source = "BDC",
  collection = "CBERS-WFI-16D",
  #tiles = "005004",
  roi = roi,
  bands = c("B13", "B14", "B15", "B16", "CLOUD"),
  start_date = "2021-05-01",
  end_date = "2021-09-01"
)

# Plot one time instance
plot(cbers_tile,
  red = "B15",
  green = "B16",
  blue = "B13",
  date = "2021-05-09"
)
