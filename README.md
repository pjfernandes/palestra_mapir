# palestra_mapir

Materiais da palestra **"IA e ciência de dados em geotecnologias e no serviço público"**, apresentada no **Curso MAPIR** (Instituto de Geociências / UFF, julho de 2026).

O repositório reúne os slides e os exemplos de código demonstrados ao vivo: quatro pipelines geoespaciais aplicados a áreas de estudo no Rio de Janeiro (Niterói, Icaraí e Itaboraí), cobrindo classificação supervisionada, detecção de copas por deep learning, segmentação por prompt de texto e métricas de desmatamento.

## Estrutura

| Arquivo | Tecnologia | Descrição |
|---|---|---|
| `palestra_MAPIR.pdf` | — | Slides da apresentação (68 páginas) |
| `codigo_google_earth_engine_niteroi.js` | Google Earth Engine (JS) | Classificação supervisionada Sentinel-2 por Random Forest |
| `deepforest_icarai_praia.ipynb` | Python / Colab | Detecção de árvores individuais com DeepForest |
| `samgeo_areas_verdes_niteroi.ipynb` | Python / Colab | Segmentação de áreas verdes por prompt de texto (LangSAM) |
| `frontiermetrics_itaborai.R` | R | Métricas de perda florestal com dados Global Forest Watch |

## Detalhamento

### `codigo_google_earth_engine_niteroi.js`
Roda no **GEE Code Editor**. Monta um mosaico Sentinel-2 (`COPERNICUS/S2`, 2022) usando mediana temporal, filtro de nuvens (`CLOUDY_PIXEL_PERCENTAGE < 20`) e máscara QA60 (bits 10/11). Treina um classificador **Random Forest** (100 árvores) sobre as bandas B2, B3, B4 e B8, a partir de amostras de três classes — floresta, urbano e água — desenhadas sobre Niterói/RJ, e exibe a classificação resultante.

### `deepforest_icarai_praia.ipynb`
Notebook **Colab**. Baixa RGB de alta resolução do Esri World Imagery para a Praia de Icaraí (bbox WGS84 configurável), aplica o **DeepForest** (`predict_tile`) para detectar copas individuais, georreferencia as caixas e exporta **GeoJSON**. Inclui um proxy de cobertura verde via **Excess Green (ExG = 2G − R − B) + limiar de Otsu**, com máscara exportada em GeoTIFF. Trata compatibilidade entre DeepForest `<2.0` e `>=2.0`.

### `samgeo_areas_verdes_niteroi.ipynb`
Notebook **Colab (requer GPU)**. Segmentação por **prompt de texto** com `segment-geospatial` / **LangSAM** (GroundingDINO + Segment Anything). AOI definível interativamente no mapa (`leafmap`) ou por bbox padrão (Campo de São Bento / Icaraí). Baixa a imagem de satélite, segmenta a partir de um prompt (ex.: `"green vegetation"`), exporta **GeoTIFF** e **GeoPackage** (pronto para QGIS). Fixa `transformers==4.57.6` por incompatibilidade do GroundingDINO com `transformers 5.x`.

### `frontiermetrics_itaborai.R`
Usa os pacotes **frontiermetrics** e **terra**. Baixa camadas do **Global Forest Watch** (cobertura arbórea e ano de perda) para Itaboraí/RJ (região do COMPERJ), agrega em grade e calcula as métricas `loss` e `speed` no período **2000–2024**, gerando os mapas correspondentes.

## Requisitos

- **GEE:** conta no [Google Earth Engine](https://code.earthengine.google.com/) (executar direto no Code Editor).
- **Notebooks:** Google Colab. Dependências instaladas nas primeiras células (`deepforest`, `contextily`, `rasterio`, `geopandas`, `segment-geospatial`, `groundingdino-py`, `leafmap`). O notebook `samgeo` exige runtime com **GPU**.
- **R:** `install.packages(c("terra"))` e o pacote `frontiermetrics`.
