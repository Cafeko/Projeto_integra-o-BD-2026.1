{{ config(materialized='table') }}

SELECT
    ROW_NUMBER() OVER (ORDER BY "DatGeracaoConjuntoDados", "arquivo_origem") AS "origem_id",
    "DatGeracaoConjuntoDados",
    "arquivo_origem"
FROM (
    SELECT DISTINCT
        "DatGeracaoConjuntoDados",
        "arquivo_origem"
    FROM {{ ref('int_silver') }}
) sub
