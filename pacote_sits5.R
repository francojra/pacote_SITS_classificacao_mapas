# Earth observation data cubes -------------------------------------------------------------------------------------------------------------
# Autora do script: Jeanne Franco ----------------------------------------------------------------------------------------------------------
# Data do script: 23/06/2025 ---------------------------------------------------------------------------------------------------------------
# Referência: https://e-sensing.github.io/sitsbook/ ----------------------------------------------------------------------------------------

# Temporal reduction operations ------------------------------------------------------------------------------------------------------------

# load package "tibble"
library(tibble)
# load packages "sits" and "sitsdata"
library(sits)
library(sitsdata)

#  Introduction ----------------------------------------------------------------------------------------------------------------------------

## Existem casos quando usuários quer produzir resultados os
## valores de uma série temporal associados a cada pixel de 
## um cubo de dados usando operações de redução. No contexto de
## análises de séries temporais, um operador de redução é uma
## função que reduz uma sequência de pontos de dados em um simples
## valor ou em um menor conjunto de valores. Esse processo envolve
## resumir ou agregar as informações de uma série temporal de forma
## significativa. Operadores de redução são frequentemente usados
## para extrair estatísticas chaves ou características de um dado,
## tornando ele mais fácil para analisar e interpretar.
