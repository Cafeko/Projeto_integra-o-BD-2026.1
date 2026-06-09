{{ config(materialized='table') }}

SELECT
    ROW_NUMBER() OVER (
        ORDER BY "NomTipoMercado", "DscModalidadeTarifaria", "DscPostoTarifario", "DscDetalheMercado"
    ) AS "mercado_id",
    "NomTipoMercado",
    "DscModalidadeTarifaria",
    "DscSubGrupoTarifario",
    "DscClasseConsumoMercado",
    "DscSubClasseConsumidor",
    "DscDetalheConsumidor",
    "DscPostoTarifario",
    "DscOpcaoEnergia",
    "DscDetalheMercado"
FROM (
    SELECT DISTINCT
        "NomTipoMercado",
        "DscModalidadeTarifaria",
        "DscSubGrupoTarifario",
        "DscClasseConsumoMercado",
        "DscSubClasseConsumidor",
        "DscDetalheConsumidor",
        "DscPostoTarifario",
        "DscOpcaoEnergia",
        "DscDetalheMercado"
    FROM {{ ref('int_silver') }}
) sub
