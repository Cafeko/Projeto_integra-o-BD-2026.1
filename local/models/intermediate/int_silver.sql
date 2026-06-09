{{ config(materialized='table') }}

WITH source AS (
    SELECT * FROM {{ ref('stg_bronze') }}
),

deduped AS (
    SELECT DISTINCT * FROM source
),

typed AS (
    SELECT
        "DatGeracaoConjuntoDados",
        to_date("DatCompetencia"::text, 'YYYY-MM-DD')                                              AS "DatCompetencia",
        nullif(regexp_replace(trim("NumCNPJAgenteDistribuidora"::text), '\D', '', 'g'), '')         AS "NumCNPJAgenteDistribuidora",
        unaccent(upper(regexp_replace(trim("SigAgenteDistribuidora"::text),    '\s+', ' ', 'g')))   AS "SigAgenteDistribuidora",
        unaccent(upper(regexp_replace(trim("NomAgenteDistribuidora"::text),    '\s+', ' ', 'g')))   AS "NomAgenteDistribuidora",
        unaccent(upper(regexp_replace(trim("NomTipoMercado"::text),            '\s+', ' ', 'g')))   AS "NomTipoMercado",
        unaccent(upper(regexp_replace(trim("DscModalidadeTarifaria"::text),    '\s+', ' ', 'g')))   AS "DscModalidadeTarifaria",
        unaccent(upper(regexp_replace(trim("DscSubGrupoTarifario"::text),      '\s+', ' ', 'g')))   AS "DscSubGrupoTarifario",
        unaccent(upper(regexp_replace(trim("DscClasseConsumoMercado"::text),   '\s+', ' ', 'g')))   AS "DscClasseConsumoMercado",
        unaccent(upper(regexp_replace(trim("DscSubClasseConsumidor"::text),    '\s+', ' ', 'g')))   AS "DscSubClasseConsumidor",
        unaccent(upper(regexp_replace(trim("DscDetalheConsumidor"::text),      '\s+', ' ', 'g')))   AS "DscDetalheConsumidor",
        nullif(regexp_replace(trim("NumCNPJAgenteAcessante"::text), '\D', '', 'g'), '')             AS "NumCNPJAgenteAcessante_raw",
        unaccent(upper(regexp_replace(trim("NomAgenteAcessante"::text),        '\s+', ' ', 'g')))   AS "NomAgenteAcessante_raw",
        unaccent(upper(regexp_replace(trim("DscPostoTarifario"::text),         '\s+', ' ', 'g')))   AS "DscPostoTarifario",
        unaccent(upper(regexp_replace(trim("DscOpcaoEnergia"::text),           '\s+', ' ', 'g')))   AS "DscOpcaoEnergia",
        unaccent(upper(regexp_replace(trim("DscDetalheMercado"::text),         '\s+', ' ', 'g')))   AS "DscDetalheMercado",
        unaccent(upper(regexp_replace(trim("arquivo_origem"::text),            '\s+', ' ', 'g')))   AS "arquivo_origem",
        replace(replace(trim("VlrMercado"::text), '.', ''), ',', '.')::NUMERIC                     AS "VlrMercado"
    FROM deduped
    WHERE "DatCompetencia" IS NOT NULL
      AND "VlrMercado"    IS NOT NULL
),

nulls_filled AS (
    SELECT
        "DatGeracaoConjuntoDados",
        "DatCompetencia",
        "NumCNPJAgenteDistribuidora",
        "SigAgenteDistribuidora",
        "NomAgenteDistribuidora",
        "NomTipoMercado",
        "DscModalidadeTarifaria",
        "DscSubGrupoTarifario",
        "DscClasseConsumoMercado",
        "DscSubClasseConsumidor",
        "DscDetalheConsumidor",
        COALESCE("NumCNPJAgenteAcessante_raw", '0') AS "NumCNPJAgenteAcessante",
        CASE
            WHEN "NomAgenteAcessante_raw" = 'SAO VALENTIM' THEN 'SÃO VALENTIM'
            WHEN "NomAgenteAcessante_raw" IS NULL           THEN 'NAO INFORMADO'
            ELSE "NomAgenteAcessante_raw"
        END AS "NomAgenteAcessante",
        "DscPostoTarifario",
        "DscOpcaoEnergia",
        "DscDetalheMercado",
        "arquivo_origem",
        "VlrMercado",
        EXTRACT(YEAR FROM "DatCompetencia")::INT                                                    AS "competencia_ano",
        TO_CHAR("DatCompetencia", 'YYYY-MM')                                                        AS "competencia_mes",
        TO_CHAR("DatCompetencia", 'YYYY') || 'Q' || EXTRACT(QUARTER FROM "DatCompetencia")::INT::TEXT AS "competencia_trimestre"
    FROM typed
),

agent_ids AS (
    SELECT DISTINCT
        "NomAgenteAcessante",
        "NumCNPJAgenteAcessante",
        ROW_NUMBER() OVER (ORDER BY "NomAgenteAcessante", "NumCNPJAgenteAcessante") AS "IdeAgenteAcessante"
    FROM nulls_filled
)

SELECT
    n."DatGeracaoConjuntoDados",
    n."DatCompetencia",
    n."NumCNPJAgenteDistribuidora",
    n."SigAgenteDistribuidora",
    n."NomAgenteDistribuidora",
    n."NomTipoMercado",
    n."DscModalidadeTarifaria",
    n."DscSubGrupoTarifario",
    n."DscClasseConsumoMercado",
    n."DscSubClasseConsumidor",
    n."DscDetalheConsumidor",
    a."IdeAgenteAcessante",
    n."NumCNPJAgenteAcessante",
    n."NomAgenteAcessante",
    n."DscPostoTarifario",
    n."DscOpcaoEnergia",
    n."DscDetalheMercado",
    n."arquivo_origem",
    n."VlrMercado",
    n."competencia_ano",
    n."competencia_mes",
    n."competencia_trimestre"
FROM nulls_filled n
LEFT JOIN agent_ids a
    ON  n."NomAgenteAcessante"     = a."NomAgenteAcessante"
    AND n."NumCNPJAgenteAcessante" = a."NumCNPJAgenteAcessante"
