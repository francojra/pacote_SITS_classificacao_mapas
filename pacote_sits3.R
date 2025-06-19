
# Earth observation data cubes -------------------------------------------------------------------------------------------------------------
# Autora do script: Jeanne Franco ----------------------------------------------------------------------------------------------------------
# Data do script: 18/06/2025 ---------------------------------------------------------------------------------------------------------------
# Referência: https://e-sensing.github.io/sitsbook/earth-observation-data-cubes.html -------------------------------------------------------

# Carregar pacotes -------------------------------------------------------------------------------------------------------------------------

library(sits)

# Create a data cube covering an area in Brazil
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
