{{ config(materialized='table') }}

-- Camada silver final: só o join entre os dados deduplicados e a tabela
-- auxiliar de ids. Mesmas colunas de saída de antes — os marts não mudam.

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
FROM {{ ref('int_silver_dedup') }} n
LEFT JOIN {{ ref('int_agente_acessante') }} a
    ON  n."NomAgenteAcessante"     = a."NomAgenteAcessante"
    AND n."NumCNPJAgenteAcessante" = a."NumCNPJAgenteAcessante"
