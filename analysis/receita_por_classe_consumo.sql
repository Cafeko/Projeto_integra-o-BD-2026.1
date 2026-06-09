SELECT 
    m."DscClasseConsumoMercado" AS classe_de_consumo,
    SUM(f."VlrMercado") AS receita_total_reais
FROM fato_energia f
JOIN dim_mercado m ON f.mercado_id = m.mercado_id
WHERE m."DscDetalheMercado" = 'RECEITA ENERGIA (R$)'
GROUP BY m."DscClasseConsumoMercado"
ORDER BY receita_total_reais DESC;