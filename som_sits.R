# Satellite Image Time Series Analysis on Earth Observation Data Cubes ---------------------------------------------------------------------
# Autora do script: Jeanne Franco ----------------------------------------------------------------------------------------------------------
# Data do script: 24/06/2025 ---------------------------------------------------------------------------------------------------------------
# Referência: https://e-sensing.github.io/sitsbook/ ----------------------------------------------------------------------------------------

#  Self-organized maps for sample quality control - Capítulo 14 ----------------------------------------------------------------------------

# Configurations to run this chapter -------------------------------------------------------------------------------------------------------

library(tibble)
library(sits)
library(sitsdata)

# set tempdir if it does not exist 
tempdir_r <- "ts_som"
dir.create(tempdir_r, showWarnings = FALSE)

# Introdução -------------------------------------------------------------------------------------------------------------------------------

# O pacote sits promove uma técnica de clusterização baseada em self-organizing maps (SOM)
# como uma alternativa a clusterização hierárquica para controle de qualidade do treinamento
# das amostras. O SOM é uma técnica de redução da dimensionalidade, onde dados de alta dimensão
# são mapeados em um mapa de duas dimensões, mantendo as relações topológicas entre os padrões
# de dados. O mapa SOM em 2D é composto de unidades chamadas neurônios. Cada neurônio tem um
# vetor de peso com a mesma dimensão das amostras de treinamento. No início, os neurônios 
# recebem um pequeno valor aleatório e depois são treinados por aprendizado competitivo. O
# algoritmo calcula as distâncias de cada membro do conjunto de treinamento para todos os
# neurônios e encontra o neurônio mais próximo da entrada, chamado de melhor unidade correspondente.












