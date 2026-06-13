{{ config(materialized='table') }}

-- Tabela auxiliar de ids (equivalente à "Aux_Agente_Acessante" do tratamento.sql).
-- Como é um modelo separado, o pipeline pesado não é recomputado para gerá-la.

SELECT
    "NomAgenteAcessante",
    "NumCNPJAgenteAcessante",
    ROW_NUMBER() OVER (ORDER BY "NomAgenteAcessante", "NumCNPJAgenteAcessante") AS "IdeAgenteAcessante"
FROM (
    SELECT DISTINCT
        "NomAgenteAcessante",
        "NumCNPJAgenteAcessante"
    FROM {{ ref('int_silver_dedup') }}
) agentes
