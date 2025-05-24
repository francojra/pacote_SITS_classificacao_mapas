# Pacote SITS - Classificação de uso e cobertura do solo

## Explicação do Script:

1. Configuração Inicial: Define parâmetros de reprodutibilidade e configurações do SITS

2. Carregamento de Dados:

- Dados de treinamento (amostras coletadas)
- Cubo de dados de imagens de satélite

3. Pré-processamento:

Suavização temporal

Cálculo de índices de vegetação

Treinamento do Modelo: Usa Random Forest (pode substituir por outros como SVM, XGBoost, etc.)

Classificação: Aplica o modelo em todo o cubo de dados

Pós-processamento: Suavização para reduzir ruídos

Visualização: Gera e plota o mapa final

Validação: Avaliação da precisão usando validação cruzada
