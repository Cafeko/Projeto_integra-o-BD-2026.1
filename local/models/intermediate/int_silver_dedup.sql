{{ config(materialized='table') }}

-- Só a deduplicação, isolada em um passo próprio: um único sort/hash
-- sobre dados já limpos e tipados (mesma ordem do tratamento.sql, que
-- deduplica depois do trim).

SELECT DISTINCT *
FROM {{ ref('stg_bronze') }}
