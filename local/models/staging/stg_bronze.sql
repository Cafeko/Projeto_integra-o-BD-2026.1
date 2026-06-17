{{ config(materialized='table') }}

-- Limpeza linha a linha (trim, tipos, regex, unaccent) + colunas derivadas.
-- Tudo aqui é operação por linha, sem sort/agregação — roda em um único scan da bronze.

SELECT
    "DatGeracaoConjuntoDados",
    to_date("DatCompetencia"::text, 'YYYY-MM-DD')                                                AS "DatCompetencia",
    nullif(regexp_replace(trim("NumCNPJAgenteDistribuidora"::text), '\D', '', 'g'), '')          AS "NumCNPJAgenteDistribuidora",
    unaccent(upper(regexp_replace(trim("SigAgenteDistribuidora"::text),    '\s+', ' ', 'g')))    AS "SigAgenteDistribuidora",
    unaccent(upper(regexp_replace(trim("NomAgenteDistribuidora"::text),    '\s+', ' ', 'g')))    AS "NomAgenteDistribuidora",
    unaccent(upper(regexp_replace(trim("NomTipoMercado"::text),            '\s+', ' ', 'g')))    AS "NomTipoMercado",
    unaccent(upper(regexp_replace(trim("DscModalidadeTarifaria"::text),    '\s+', ' ', 'g')))    AS "DscModalidadeTarifaria",
    unaccent(upper(regexp_replace(trim("DscSubGrupoTarifario"::text),      '\s+', ' ', 'g')))    AS "DscSubGrupoTarifario",
    unaccent(upper(regexp_replace(trim("DscClasseConsumoMercado"::text),   '\s+', ' ', 'g')))    AS "DscClasseConsumoMercado",
    unaccent(upper(regexp_replace(trim("DscSubClasseConsumidor"::text),    '\s+', ' ', 'g')))    AS "DscSubClasseConsumidor",
    unaccent(upper(regexp_replace(trim("DscDetalheConsumidor"::text),      '\s+', ' ', 'g')))    AS "DscDetalheConsumidor",
    COALESCE(nullif(regexp_replace(trim("NumCNPJAgenteAcessante"::text), '\D', '', 'g'), ''), '0') AS "NumCNPJAgenteAcessante",
    CASE
        WHEN unaccent(upper(regexp_replace(trim("NomAgenteAcessante"::text), '\s+', ' ', 'g'))) = 'SAO VALENTIM'
            THEN 'SÃO VALENTIM'
        WHEN "NomAgenteAcessante" IS NULL
            THEN 'NAO INFORMADO'
        ELSE unaccent(upper(regexp_replace(trim("NomAgenteAcessante"::text), '\s+', ' ', 'g')))
    END                                                                                          AS "NomAgenteAcessante",
    unaccent(upper(regexp_replace(trim("DscPostoTarifario"::text),         '\s+', ' ', 'g')))    AS "DscPostoTarifario",
    unaccent(upper(regexp_replace(trim("DscOpcaoEnergia"::text),           '\s+', ' ', 'g')))    AS "DscOpcaoEnergia",
    unaccent(upper(regexp_replace(trim("DscDetalheMercado"::text),         '\s+', ' ', 'g')))    AS "DscDetalheMercado",
    unaccent(upper(regexp_replace(trim("arquivo_origem"::text),            '\s+', ' ', 'g')))    AS "arquivo_origem",
    replace(replace(trim("VlrMercado"::text), '.', ''), ',', '.')::NUMERIC                       AS "VlrMercado",
    EXTRACT(YEAR FROM to_date("DatCompetencia"::text, 'YYYY-MM-DD'))::INT                        AS "competencia_ano",
    TO_CHAR(to_date("DatCompetencia"::text, 'YYYY-MM-DD'), 'YYYY-MM')                            AS "competencia_mes",
    TO_CHAR(to_date("DatCompetencia"::text, 'YYYY-MM-DD'), 'YYYY')
        || 'Q'
        || EXTRACT(QUARTER FROM to_date("DatCompetencia"::text, 'YYYY-MM-DD'))::INT::TEXT        AS "competencia_trimestre"
FROM "Dados_Bronze"
WHERE "DatCompetencia" IS NOT NULL
  AND "VlrMercado"     IS NOT NULL
