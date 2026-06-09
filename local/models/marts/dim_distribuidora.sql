{{ config(materialized='table') }}

SELECT
    ROW_NUMBER() OVER (ORDER BY "SigAgenteDistribuidora", "NomAgenteDistribuidora") AS "distribuidora_id",
    "NumCNPJAgenteDistribuidora",
    "SigAgenteDistribuidora",
    "NomAgenteDistribuidora"
FROM (
    SELECT DISTINCT
        "NumCNPJAgenteDistribuidora",
        "SigAgenteDistribuidora",
        "NomAgenteDistribuidora"
    FROM {{ ref('int_silver') }}
) sub
