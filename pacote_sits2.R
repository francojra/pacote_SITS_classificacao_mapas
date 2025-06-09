
# Baixar e carregar pacote sitsdata

library(devtools) # Necessário para baixar o pacote
options(download.file.method = "wininet")
devtools::install_github("e-sensing/sitsdata")

# Baixar pacotes para análises

library(sitsdata)
library(sits)
