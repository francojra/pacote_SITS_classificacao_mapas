# Pacote SITS - Classificação de uso e cobertura do solo
### Data: 23/05/25

### Explicação do Script:

1. Configuração Inicial: Define parâmetros de reprodutibilidade e configurações do SITS
2. Carregamento de Dados:
- Dados de treinamento (amostras coletadas)
- Cubo de dados de imagens de satélite
3. Pré-processamento:
- Suavização temporal
- Cálculo de índices de vegetação
4. Treinamento do Modelo: Usa Random Forest (pode substituir por outros como SVM, XGBoost, etc.)
5. Classificação: Aplica o modelo em todo o cubo de dados
6. Pós-processamento: Suavização para reduzir ruídos
7. Visualização: Gera e plota o mapa final
8. Validação: Avaliação da precisão usando validação cruzada
