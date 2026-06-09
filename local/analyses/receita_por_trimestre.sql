SELECT 
    t.ano, 
    t.trimestre, 
    SUM(f."VlrMercado") AS receita_total_reais
FROM fato_energia f
JOIN dim_tempo t ON f.tempo_id = t.tempo_id
JOIN dim_mercado m ON f.mercado_id = m.mercado_id
WHERE m."DscDetalheMercado" = 'RECEITA ENERGIA (R$)' 
GROUP BY t.ano, t.trimestre
ORDER BY t.ano, t.trimestre;