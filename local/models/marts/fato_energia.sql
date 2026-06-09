{{ config(materialized='table') }}

SELECT
    ROW_NUMBER() OVER (
        ORDER BY s."DatCompetencia", s."NumCNPJAgenteDistribuidora", s."IdeAgenteAcessante"
    ) AS "fato_id",
    dt."tempo_id",
    dd."distribuidora_id",
    da."IdeAgenteAcessante",
    dm."mercado_id",
    dor."origem_id",
    s."VlrMercado"
FROM {{ ref('int_silver') }} s
LEFT JOIN {{ ref('dim_tempo') }} dt
    ON s."DatCompetencia" = dt."data_competencia"
LEFT JOIN {{ ref('dim_distribuidora') }} dd
    ON  s."NumCNPJAgenteDistribuidora" = dd."NumCNPJAgenteDistribuidora"
    AND s."SigAgenteDistribuidora"     = dd."SigAgenteDistribuidora"
    AND s."NomAgenteDistribuidora"     = dd."NomAgenteDistribuidora"
LEFT JOIN {{ ref('dim_acessante') }} da
    ON  s."IdeAgenteAcessante"     = da."IdeAgenteAcessante"
    AND s."NumCNPJAgenteAcessante" = da."NumCNPJAgenteAcessante"
    AND s."NomAgenteAcessante"     = da."NomAgenteAcessante"
LEFT JOIN {{ ref('dim_mercado') }} dm
    ON  s."NomTipoMercado"          = dm."NomTipoMercado"
    AND s."DscModalidadeTarifaria"  = dm."DscModalidadeTarifaria"
    AND s."DscSubGrupoTarifario"    = dm."DscSubGrupoTarifario"
    AND s."DscClasseConsumoMercado" = dm."DscClasseConsumoMercado"
    AND s."DscSubClasseConsumidor"  = dm."DscSubClasseConsumidor"
    AND s."DscDetalheConsumidor"    = dm."DscDetalheConsumidor"
    AND s."DscPostoTarifario"       = dm."DscPostoTarifario"
    AND s."DscOpcaoEnergia"         = dm."DscOpcaoEnergia"
    AND s."DscDetalheMercado"       = dm."DscDetalheMercado"
LEFT JOIN {{ ref('dim_origem') }} dor
    ON  s."DatGeracaoConjuntoDados" = dor."DatGeracaoConjuntoDados"
    AND s."arquivo_origem"          = dor."arquivo_origem"
