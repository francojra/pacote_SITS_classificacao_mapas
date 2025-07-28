# Criação de cubo de dados, Self-Organizing Maps (SOM) e Classificação  --------------------------------------------------------------------
# Teste de Amostras  -----------------------------------------------------------------------------------------------------------------------
# Tile 034017 ------------------------------------------------------------------------------------------------------------------------------
# Autoria do script: Jeanne Franco ---------------------------------------------------------------------------------------------------------
# Data: 04/07/25 ---------------------------------------------------------------------------------------------------------------------------

# Etapas do script -------------------------------------------------------------------------------------------------------------------------

## 1 - Carregar pacotes necessários
## 2 - Definir diretório de trabalho (pasta com arquivos)
## 3 - Criar cubo de dados
## 4 - Criar cubo de dados das amostras - Grupo 2
## 5 - Gerar análise SOM
## 6 - Treinamento do modelo e classificação

# Carregar pacotes -------------------------------------------------------------------------------------------------------------------------

library(tibble) # Pacote para visualizar tabelas
library(sits) # Pacote para análises de séries temporais de imagens de satélite
library(sitsdata) # Pacote para obter conjunto de dados de amostras
library(kohonen) # Pacote para plotar o mapa SOM

# Estabelecer diretório de trabalho  -------------------------------------------------------------------------------------------------------

## Estabelecer um diretório de trabalho (pasta do computador com seus arquivos)
### 1ª Opção:
setwd("C:/caminho/da/sua/pasta")  

### 2ª opção (manual):
# Session > Set Working Directory > Choose Directory

## Conferir o caminho do diretório de trabalho definido:
getwd() 

# Criar cubo de dados - Sentinel 2 ---------------------------------------------------------------------------------------------------------

cubo_tile_034017 <- sits_cube(
  source     = "BDC", # Fonte dos cubos de dados
  collection = "SENTINEL-2-16D", # Coleção de imagens
  tiles      = "034017", # Região definida pelo Tile
  start_date = "2020-01-01", # Data inicial 
  end_date   = "2020-12-31") # Data final (período de 1 ano)

# Salvar arquivo do cubo em formato rds ----------------------------------------------------------------------------------------------------

## Salvando os dados, não precisa gerar o cubo das amostras novamente

saveRDS(cubo_tile_034017, file = "cubo_tile_034017.rds") 
cubo_tile_034017 <- readRDS("cubo_tile_034017.rds")

# Verificar informações sobre o cubo -------------------------------------------------------------------------------------------------------

view(cubo_tile_034017) # Tabela com principais informações do cubo
view(cubo_tile_034017$file_info[[1]]) # Tabela das informações contidas na coluna file_info

sits_bands(cubo_tile_034017)
sits_timeline(cubo_tile_034017)

# Ler conjunto de dados com todas as bandas e índices --------------------------------------------------------------------------------------

cubo_caatinga_bandas_indices <- readRDS("cubo_caatinga_indices.rds")