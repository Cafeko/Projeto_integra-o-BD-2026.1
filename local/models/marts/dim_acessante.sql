{{ config(materialized='table') }}

SELECT DISTINCT
    "IdeAgenteAcessante",
    "NumCNPJAgenteAcessante",
    "NomAgenteAcessante"
FROM {{ ref('int_silver') }}
