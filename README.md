# Pipeline de Dados: Mercado de Energia Elétrica (SAMP/ANEEL)

> **Projeto de Integração de Banco de Dados (2026.1) - CIn/UFPE**

Este projeto implementa e compara arquiteturas fundamentais de Engenharia de Dados — **ETL Clássico** (Python/Pandas) e **ELT Moderno** (SQL) — para processar, higienizar e modelar dados públicos do mercado e consumo de energia elétrica no Brasil.

O diferencial deste projeto é a implementação final de uma **Modelagem Dimensional (Esquema Estrela)**, transformando uma grande volumetria de registros brutos em um Data Warehouse otimizado para análises de Inteligência de Negócios (BI).

---

## Objetivo e Desafio

O objetivo central foi integrar dados dispersos temporalmente para permitir análises históricas de faturamento e consumo energético nacional.

* **Fonte:** Portal de Dados Abertos da ANEEL (SAMP - Sistema de Acompanhamento de Informações de Mercado para Regulação Econômica).
* **Dados Brutos:** Arquivos `.csv` separados por ano (2024, 2025, 2026).
* **Desafio Principal:** Os dados originais possuíam inconsistências textuais severas (acentuação divergente, formatações variadas), tipagem complexa (CNPJs perdendo zeros à esquerda) e a necessidade de criar chaves artificiais (Surrogate Keys) para relacionar corretamente as entidades.

## Arquitetura da Solução

O projeto constrói o mesmo modelo final através de caminhos distintos para fins de comparação acadêmica:

### 1. Abordagem ETL (Python Driven)
* **Extração:** Leitura automatizada dos CSVs via `pandas`.
* **Transformação (Em Memória):** Higienização pesada utilizando as bibliotecas nativas do Python (ex: `unicodedata` para remoção de acentos), padronização em caixa alta (`.str.upper()`) e modelagem do Esquema Estrela separando o dataframe principal em Fatos e Dimensões.
* **Carga:** Injeção das tabelas modeladas e limpas diretamente no PostgreSQL via `sqlalchemy`.

### 2. Abordagem ELT (SQL Driven)
* **Extração e Carga:** Leitura bruta dos dados e injeção direta no PostgreSQL sem tratamento (`raw data`).
* **Transformação (In-Database):** Execução de scripts SQL para limpar, normalizar e modelar os dados utilizando o poder de processamento do próprio motor de banco de dados.

## Modelagem Dimensional (Star Schema)

O Data Warehouse final está estruturado com a seguinte granularidade:

* **`fato_energia`**: Tabela central contendo as métricas de `VlrMercado` (financeiro) e chaves estrangeiras.
* **`dim_tempo`**: Competências (Mês/Ano/Trimestre).
* **`dim_distribuidora`**: Dados descritivos das concessionárias (Nome, Sigla, CNPJ).
* **`dim_mercado`**: Categorias tarifárias, classes de consumo e detalhes de mercado.
* **`dim_acessante`**: Informações sobre as entidades vinculadas.
* **`dim_origem`**: Metadados para rastreabilidade do arquivo gerador.

---

## Como Executar o Projeto Localmente

**Pré-requisitos:** Python 3.x e PostgreSQL instalados localmente.

### Passo 1: Preparação do Ambiente
1. Clone este repositório.
2. Crie um ambiente virtual e instale as dependências:
   ```bash
   pip install pandas sqlalchemy psycopg2-binary

### Passo 2: Execução da Carga (ETL)
1. Abra o arquivo ETL.ipynb no VS Code.
2. No primeiro bloco de código, atualize as credenciais do PostgreSQL (usuario_db, senha_db, etc.) com os dados da sua máquina local.
3. Execute todas as células. O script cuidará da limpeza e criará as 6 tabelas finais no seu banco de dados.

## Resultados e Insights

As consultas SQL localizadas na pasta /analysis demonstram o poder do modelo construído para gerar valor ao negócio:
1. **Evolução Temporal** (`receita_por_trimestre.sql`): Análise do volume de receita faturada por ano e trimestre, evidenciando a sazonalidade e picos de consumo no mercado elétrico usando a dim_tempo.
2. **Concentração de Mercado** (`ranking_distribuidoras.sql`): Mapeamento do "Market Share" logístico, ranqueando as 10 maiores distribuidoras do país com base no volume físico de energia distribuída em KWH, utilizando a dim_distribuidora.
3. **Cobertura de Grupos (`receita_por_classe_consumo.sql`):** Análise macroeconômica que divide a receita total do setor por classes (Residencial, Industrial, Comercial, etc.), cruzando a tabela Fato com a dim_mercado.

## Equipe
    
    Dyego Ferreira da Silva            - dfs10
    Caio Ferreira Gomes da Silva       - cfgs
    Júlio Cesar da Silva               - jcs8
    Anysabele de Paula Barbosa Santos  - apbs2
    Jairo Cândido Gonzaga Neto         - jcgn
    Vinicius guedes de macedo          - Vgm