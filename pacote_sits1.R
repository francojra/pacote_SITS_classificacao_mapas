# load the sits library

options(timeout = 300)
devtools::install_github("e-sensing/sitsdata")

# usethis::create_github_token()
# gitcreds::gitcreds_set()

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
