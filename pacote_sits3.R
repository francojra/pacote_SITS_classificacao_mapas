
# Earth observation data cubes -------------------------------------------------------------------------------------------------------------
# Autora do script: Jeanne Franco ----------------------------------------------------------------------------------------------------------
# Data do script: 18/06/2025 ---------------------------------------------------------------------------------------------------------------
# Referência: https://e-sensing.github.io/sitsbook/earth-observation-data-cubes.html -------------------------------------------------------

# Carregar pacotes -------------------------------------------------------------------------------------------------------------------------

library(sits)

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