SELECT 
    d."SigAgenteDistribuidora" AS distribuidora_sigla,
    d."NomAgenteDistribuidora" AS distribuidora_nome,
    SUM(f."VlrMercado") AS total_energia_distribuida_kwh
FROM fato_energia f
JOIN dim_distribuidora d ON f.distribuidora_id = d.distribuidora_id
JOIN dim_mercado m ON f.mercado_id = m.mercado_id
WHERE m."DscDetalheMercado" = 'ENERGIA TE (KWH)'
GROUP BY d."SigAgenteDistribuidora", d."NomAgenteDistribuidora"
ORDER BY total_energia_distribuida_kwh DESC
LIMIT 10;