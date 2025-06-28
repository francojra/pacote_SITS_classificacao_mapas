# load the sitsdata library

options(timeout = 300)
devtools::install_github("e-sensing/sitsdata")

# usethis::create_github_token()
# gitcreds::gitcreds_set()

# Carregar pacotes

library(tibble)
library(sits)
library(sitsdata)

# Principais funções dos pacotes -----------------------------------------------------------------------------------------------------------

# 1 - sits_cube()
# 2 - sits_regularize()
# 3 - sits_apply()
# 4 - sits_get_data()
# 5 - sits_train()
# 6 - sits_classify()
# 7 - sits_smooth()
# 8 - sits_uncertainty()
# 9 - sits_label_classification()
# 10 - sits_accuracy()

# Criando um cubo de dados -----------------------------------------------------------------------------------------------------------------

# Create a data cube using local files
sinop_cube <- sits_cube(
  source = "BDC",
  collection = "MOD13Q1-6.1",
  bands = c("NDVI", "EVI"),
  data_dir = system.file("extdata/sinop", package = "sitsdata"),
  parse_info = c("satellite", "sensor", "tile", "band", "date")
)

# Plot the NDVI for the first date (2013-09-14)
plot(sinop_cube,
  band = "NDVI",
  dates = "2013-09-14",
  palette = "RdYlGn"
)
