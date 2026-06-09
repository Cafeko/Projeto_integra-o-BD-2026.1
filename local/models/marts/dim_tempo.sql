{{ config(materialized='table') }}

SELECT
    ROW_NUMBER() OVER (ORDER BY "DatCompetencia")       AS "tempo_id",
    "DatCompetencia"                                     AS "data_competencia",
    EXTRACT(YEAR    FROM "DatCompetencia")::INT          AS "ano",
    EXTRACT(MONTH   FROM "DatCompetencia")::INT          AS "mes",
    TO_CHAR("DatCompetencia", 'Month')                   AS "nome_mes",
    EXTRACT(QUARTER FROM "DatCompetencia")::INT          AS "trimestre",
    CASE
        WHEN EXTRACT(MONTH FROM "DatCompetencia") <= 6 THEN 1
        ELSE 2
    END AS "semestre"
FROM (
    SELECT DISTINCT "DatCompetencia"
    FROM {{ ref('int_silver') }}
    WHERE "DatCompetencia" IS NOT NULL
) sub
