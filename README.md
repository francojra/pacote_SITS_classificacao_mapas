se# Pacote SITS - Séries Temporais e Classificação de uso e Cobertura do Solo 

#### Autoria do script: Jeanne Franco
#### Data: 23/05/25
#### Referência: https://e-sensing.github.io/sitsbook/index.html

## Conceitos

### Por que trabalhar com séries temporais de imagens de satélite?

Imageamento de satélite promove o mais extensivo dado sobre nosso ambiente. Ao abranger várias áreas da superfície da terra, as imagens permitem aos pesquisadores analisar transformações locais e globais. Ao observar o mesmo local em diferentes tempos, os satélites fornecem dados sobre mudanças ambientais e permitem pesquisar áreas que são difíceis de observar do solo. Dado características únicas delas, as imagens oferecem essenciais informações para muitas aplicações, incluindo desmatamento, produção agrícola, segurança alimentar, áreas urbanas, escassez de água e degradação da terra. Usando séries temporais, especialistas melhoram o entendimento deles sobre processos e padrões ecológicos. Em vez de selecionar imagens individuais de datas específicas e compará-las, os pesquisadores rastreiam as mudanças continuamente.

### Tempo primeiro, espaço depois

“*Time-first, space-later*” é um conceito de classificação de imagem de satélite que toma análises de séries temporais como primeiro passo para analisar dados de sensoriamento remoto, com informação espacial sendo considerada após todas as séries de tempo serem classificadas. O tempo primeiro traz um melhor entendimento das mudanças nas paisagens. Detectar e rastrear tendências sazonais e de longo prazo torna-se viável, bem como identificar eventos anômalos ou padrões nos dados, como incêndios florestais, inundações, ou secas. Cada pixel em um cubo de dado é tratado como uma série temporal, usando informação disponível nas instâncias temporais do caso. Classificação de séries temporais é baseada em pixel, produzindo um conjunto de pixels rotulados. Esse resultado é então usado como input para o *space-later* do método. Nessa fase, um algoritmo de suavização (smoothing) melhor os resultados da classificação *Time-first* ao considerar a vizinhança espacial de cada pixel. O mapa resultante assim combina ambos informações espaciais e temporais.

### Cobertura e uso da terra

A Food and Agriculture Organization define cobertura da terra como "a cobertura biofísica observada sobre a superfície da terra". A cobertura da terra pode ser observada e mapeada diretamente através de imagens de sensoriamento remoto. Nas diretrizes e relatórios da FAO, uso da terra é descrita como "as atividades ou propósitos humanos para os quais a terra é gerida ou explorada". Apesar do "*uso da terra*" e "*cobertura da terra*" denotar diferentes abordagens para descrever a paisagem da terra, na prática existe considerável sobreposição entre esses conceitos. Ao classificar imagens de sensoriamento remoto, áreas naturais são classificadas usando tipos de cobertura da terra (ex.: floresta), enquanto áreas modificadas por humanos são descritas com uso de classes da terra (ex.: pasto).

Uma das vantagens de usar imagens de séries temporais para classificação da terra é a capacidade delas de medir mudanças na paisagem relacionadas a práticas de agricultura. Por exemplo, séries temporais de um índice de vegetação em uma área de produção agrícola mostrará um padrão de mínimos (estágios de plantio e semeadura) e máximos (estágio de floração). Assim, esquemas de classificação sobre imagens de dados de séries temporais pode ser mais rico e mais detalhado que aqueles associados apenas com cobertura da terra. A seguir, nós usamos o termo *classificação da terra* (*land classification*) para se referir a classificação da imagem representando ambos cobertura da terra e classes de uso da terra.

### Como o *sits* trabalha

O pacote *sits* usa imagens de séries temporais para classificação da terra usando a abordagem *time-first, space-later*. A parte de preparação de dados, coleções de imagens *Big Earth Observation* são organizadas como cubos de dados. Cada localização espacial do cubo de dados é associada a uma série temporal. Localizações com conhecidos rótulos treina um algoritmo de machine learning, que classifica todas as séries temporais de um cubo de dados, como mostrado na figura abaixo:

![Usando séries temporais para classificação da terra (fonte: autores).](https://e-sensing.github.io/sitsbook/images/sits_general_view.png)

O pacote fornece ferramentas para análises, visualização e classificação de imagens de satélite de séries temporais. Usuários seguem um típico fluxo de trabalho para uma classificação baseada em pixel:

1. Selecionar um dado de coletação de imagem pronta para análise (ARD image collections) de provedores de nuvem como AWS, Microsoft Planetary Computer, Digital Earth Africa, Brazil Data Cube, etc. --> sits_cube()
2. Construir um cubo de dados regular usando a coleção de imagem escolhida. --> sits_regularize()
3. Obter novas bandas e índices com operações sobre o cubo de dados. --> sits_apply()
4. Extrair amostras de séries temporais do cubo de dados para ser usado como dados de treinamento. --> sits_get_data()
5. Executar o controle de qualidade e a filtragem nas amostras de séries temporais. 
6. Treinar o modelo de machine learning usando as amostras de séries temporais. --> sits_train()
7. Classificar os cubos de dados usando o modelo para obter as classes de probabilidades para cada pixel. --> sits_classify()
8. Pós-processar o cubo de probabilidade para remover outliers. --> sits_smooth()
9. Produzir um mapa rotulado do cubo de probabilidade pós-processado. --> sits_label_classification()
10. Avaliar a acurácia da classificação usando as melhores práticas. --> sits_accuracy()

Cada etapa do fluxo de trabalho corresponde a uma função do sits API, como mostrado na figura abaixo. Essas funções tem parâmetros e comportamentos padrões convenientes. Uma simples função constroi modelos de machine learning. A função de classificação processa cubos de big data com processamento paralelo eficiente. Como a API SITs é simples de aprender, alcançar bons resultados não exige conhecimento profundo sobre aprendizado de máquina e processamento paralelo.

![Principais funções do sits API (fonte: autores).](https://e-sensing.github.io/sitsbook/images/sits_api.png)

### Criando cubos de dados

Para obter informações sobre a coleção de imagens ARD de provedores de nuvem, o SIT utiliza o protocolo Spatio Temporal Asset Catalogue (STAC), uma especificação de informações geoespaciais adotada por muitos grandes provedores de coleção de imagens. Um "ativo espaço-temporal" é qualquer arquivo que represente informações sobre a Terra capturadas em um espaço e tempo específicos. Para acessar os endpoints do STAC, o SIT utiliza o pacote do R rstac.

A função sits_cube() suporta acesso para coleções de imagens em serviços de nuvem; ele tem os seguintes parâmetros:

- **source**: nome do provedor.
- **collection**: uma coleção de imagens disponíveis no provedor e suportado pelo sits. Para descobrir quais coleções são suportadas pelo sits, ver a função sits_list_collection().
- **plataform**: parâmetro opcional que especifica a plataforma em coleções com múltiplos satélites.
- **tiles**: conjunto de tiles do sistema de referência de coleção de imagens. É necessário especificar tiles ou roi.
- **roi**: uma região de interesse. Pode ser um vetor nomeado (lon_min, lon_max, lat_min, lat_max) em coordenadas WGS 84; ou um objeto sf. Todas as imagens interseccionando o envoltório convexo do roi são selecionadas.
- **bands**: parâmetro opcional com as bandas a serem usadas. Se omitido no código, todas as bandas da coleção são usadas.
- **orbit**: parâmetro opcional requerido apenas para imagens Sentinel-1 (default = “descending”).
- **start_date**: a data inicial para o intervalo temporal contendo as séries de tempo de imagens.
- **end_date**: a data final para o intervalo temporal contendo as séries de tempo das imagens.

O resultado de sits_cube() é um tibble com uma descrição das imagens selecionadas necessárias para processamento posterior. Ele não contém os dados reais, mas apenas ponteiros para as imagens. Os atributos de arquivos de imagem individuais podem ser acessados ​​listando a coluna file_info do tibble.
