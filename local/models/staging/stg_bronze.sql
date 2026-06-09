{{ config(materialized='view') }}

SELECT * FROM "Dados_Bronze"
