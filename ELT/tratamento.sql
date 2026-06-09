/* Fazendo tratamento e correções iniciais dos dados */

CREATE EXTENSION IF NOT EXISTS unaccent;


-- Remover espaços extras no inicio e no final do valores:
UPDATE "Dados_Bronze"
SET "NumCNPJAgenteDistribuidora" = trim("NumCNPJAgenteDistribuidora"),
"SigAgenteDistribuidora" = trim("SigAgenteDistribuidora"),
"NomAgenteDistribuidora" = trim("NomAgenteDistribuidora"),
"NomTipoMercado" = trim("NomTipoMercado"),
"DscModalidadeTarifaria" = trim("DscModalidadeTarifaria"),
"DscSubGrupoTarifario" = trim("DscSubGrupoTarifario"),
"DscClasseConsumoMercado" = trim("DscClasseConsumoMercado"),
"DscSubClasseConsumidor" = trim("DscSubClasseConsumidor"),
"DscDetalheConsumidor" = trim("DscDetalheConsumidor"),
"IdeAgenteAcessante" = trim("IdeAgenteAcessante"),
"NumCNPJAgenteAcessante" = trim("NumCNPJAgenteAcessante"),
"NomAgenteAcessante" = trim("NomAgenteAcessante"),
"DscPostoTarifario" = trim("DscPostoTarifario"),
"DscOpcaoEnergia" = trim("DscOpcaoEnergia"),
"DscDetalheMercado" = trim("DscDetalheMercado"),
"arquivo_origem" =  trim("arquivo_origem");


-- Trocar tipos de dados:

--- "DatGeracaoConjuntoDados" já é DATE (convertido pelo ELT), sem ALTER necessário.

--- "DatCompetencia" de text para date.
ALTER TABLE "Dados_Bronze" ALTER COLUMN "DatCompetencia"
TYPE DATE USING to_date("DatCompetencia", 'YYYY-MM-DD');

--- "VlrMercado" de text para date.
ALTER TABLE "Dados_Bronze" ALTER COLUMN "VlrMercado"
TYPE NUMERIC USING replace(replace("VlrMercado", '.', ''), ',', '.')::NUMERIC;


-- Padronizando formato dos dados:

--- Remover qualquer valor que não seja digito de "NumCNPJAgenteDistribuidora" e "NumCNPJAgenteAcessante".
UPDATE "Dados_Bronze"
SET "NumCNPJAgenteDistribuidora" = nullif(regexp_replace("NumCNPJAgenteDistribuidora", '\D', '', 'g'), ''),
"NumCNPJAgenteAcessante" = nullif(regexp_replace("NumCNPJAgenteAcessante", '\D', '', 'g'), '');


/* Camada silver */

-- Removendo linhas duplicadas:
-- DROP TABLE "Dados_Silver";
CREATE TABLE "Dados_Silver" AS
SELECT DISTINCT *
FROM "Dados_Bronze";


-- Removendo espaços extras no meio dos textos:
UPDATE "Dados_Silver"
SET "NumCNPJAgenteDistribuidora" = regexp_replace("NumCNPJAgenteDistribuidora", '\s+', ' ', 'g'),
"SigAgenteDistribuidora" = regexp_replace("SigAgenteDistribuidora", '\s+', ' ', 'g'),
"NomAgenteDistribuidora" = regexp_replace("NomAgenteDistribuidora", '\s+', ' ', 'g'),
"NomTipoMercado" = regexp_replace("NomTipoMercado", '\s+', ' ', 'g'),
"DscModalidadeTarifaria" = regexp_replace("DscModalidadeTarifaria", '\s+', ' ', 'g'),
"DscSubGrupoTarifario" = regexp_replace("DscSubGrupoTarifario", '\s+', ' ', 'g'),
"DscClasseConsumoMercado" = regexp_replace("DscClasseConsumoMercado", '\s+', ' ', 'g'),
"DscSubClasseConsumidor" = regexp_replace("DscSubClasseConsumidor", '\s+', ' ', 'g'),
"DscDetalheConsumidor" = regexp_replace("DscDetalheConsumidor", '\s+', ' ', 'g'),
"IdeAgenteAcessante" = regexp_replace("IdeAgenteAcessante", '\s+', ' ', 'g'),
"NumCNPJAgenteAcessante" = regexp_replace("NumCNPJAgenteAcessante", '\s+', ' ', 'g'),
"NomAgenteAcessante" = regexp_replace("NomAgenteAcessante", '\s+', ' ', 'g'),
"DscPostoTarifario" = regexp_replace("DscPostoTarifario", '\s+', ' ', 'g'),
"DscOpcaoEnergia" = regexp_replace("DscOpcaoEnergia", '\s+', ' ', 'g'),
"DscDetalheMercado" = regexp_replace("DscDetalheMercado", '\s+', ' ', 'g'),
"arquivo_origem" =  regexp_replace("arquivo_origem", '\s+', ' ', 'g');


-- Deixando todos os textos maiusculos:
UPDATE "Dados_Silver"
SET "NumCNPJAgenteDistribuidora" = upper("NumCNPJAgenteDistribuidora"),
"SigAgenteDistribuidora" = upper("SigAgenteDistribuidora"),
"NomAgenteDistribuidora" = upper("NomAgenteDistribuidora"),
"NomTipoMercado" = upper("NomTipoMercado"),
"DscModalidadeTarifaria" = upper("DscModalidadeTarifaria"),
"DscSubGrupoTarifario" = upper("DscSubGrupoTarifario"),
"DscClasseConsumoMercado" = upper("DscClasseConsumoMercado"),
"DscSubClasseConsumidor" = upper("DscSubClasseConsumidor"),
"DscDetalheConsumidor" = upper("DscDetalheConsumidor"),
"IdeAgenteAcessante" = upper("IdeAgenteAcessante"),
"NumCNPJAgenteAcessante" = upper("NumCNPJAgenteAcessante"),
"NomAgenteAcessante" = upper("NomAgenteAcessante"),
"DscPostoTarifario" = upper("DscPostoTarifario"),
"DscOpcaoEnergia" = upper("DscOpcaoEnergia"),
"DscDetalheMercado" = upper("DscDetalheMercado"),
"arquivo_origem" =  upper("arquivo_origem");


-- Remover acentos de todas as colunas de texto:
UPDATE "Dados_Silver"
SET "NumCNPJAgenteDistribuidora" = unaccent("NumCNPJAgenteDistribuidora"),
"SigAgenteDistribuidora" = unaccent("SigAgenteDistribuidora"),
"NomAgenteDistribuidora" = unaccent("NomAgenteDistribuidora"),
"NomTipoMercado" = unaccent("NomTipoMercado"),
"DscModalidadeTarifaria" = unaccent("DscModalidadeTarifaria"),
"DscSubGrupoTarifario" = unaccent("DscSubGrupoTarifario"),
"DscClasseConsumoMercado" = unaccent("DscClasseConsumoMercado"),
"DscSubClasseConsumidor" = unaccent("DscSubClasseConsumidor"),
"DscDetalheConsumidor" = unaccent("DscDetalheConsumidor"),
"IdeAgenteAcessante" = unaccent("IdeAgenteAcessante"),
"NumCNPJAgenteAcessante" = unaccent("NumCNPJAgenteAcessante"),
"NomAgenteAcessante" = unaccent("NomAgenteAcessante"),
"DscPostoTarifario" = unaccent("DscPostoTarifario"),
"DscOpcaoEnergia" = unaccent("DscOpcaoEnergia"),
"DscDetalheMercado" = unaccent("DscDetalheMercado"),
"arquivo_origem" = unaccent("arquivo_origem");


-- Tratamento de acentuação (caso especial restaurado):
UPDATE "Dados_Silver"
SET "NomAgenteAcessante" = 'SÃO VALENTIM'
WHERE "NomAgenteAcessante" = 'SAO VALENTIM';


-- Remover registros que tiverem nulo em "DatCompetencia" e "VlrMercado":
DELETE FROM "Dados_Silver"
WHERE "DatCompetencia" IS NULL
    OR "VlrMercado" IS NULL;


-- Criar colunas para "competencia_ano", "competencia_mes" e "competencia_trimestre":
ALTER TABLE "Dados_Silver"
ADD COLUMN "competencia_ano" INTEGER,
ADD COLUMN "competencia_mes" TEXT,
ADD COLUMN "competencia_trimestre" TEXT;

UPDATE "Dados_Silver"
SET "competencia_ano" = EXTRACT(YEAR FROM "DatCompetencia"),
"competencia_mes" = TO_CHAR("DatCompetencia", 'YYYY-MM'),
"competencia_trimestre" = TO_CHAR("DatCompetencia", 'YYYY') || 'Q' || EXTRACT(QUARTER FROM "DatCompetencia")::INT::TEXT;


-- Preenche nulos de "IdeAgenteAcessante", "NomAgenteAcessante" e "NumCNPJAgenteAcessante":
UPDATE "Dados_Silver"
SET "IdeAgenteAcessante" = 'NAO INFORMADO'
WHERE "IdeAgenteAcessante" IS NULL OR "IdeAgenteAcessante" = '0';

UPDATE "Dados_Silver"
SET "NomAgenteAcessante" = 'NAO INFORMADO'
WHERE "NomAgenteAcessante" IS NULL;

UPDATE "Dados_Silver"
SET "NumCNPJAgenteAcessante" = '0'
WHERE "NumCNPJAgenteAcessante" IS NULL;


-- Cria os ids em "IdeAgenteAcessante"
-- DROP TABLE "Aux_Agente_Acessante";
CREATE TABLE "Aux_Agente_Acessante" AS
SELECT ROW_NUMBER() OVER (ORDER BY "NomAgenteAcessante", "NumCNPJAgenteAcessante") AS id_agente,
"NomAgenteAcessante", "NumCNPJAgenteAcessante"
FROM (SELECT DISTINCT "NumCNPJAgenteAcessante", "NomAgenteAcessante"
        FROM "Dados_Silver");

UPDATE "Dados_Silver" ds
SET "IdeAgenteAcessante" = a."id_agente"
FROM  "Aux_Agente_Acessante" a
WHERE ds."NumCNPJAgenteAcessante" = a."NumCNPJAgenteAcessante"
    AND ds."NomAgenteAcessante" = a."NomAgenteAcessante";

/* Camada gold */

-- Cria copia para não perder a tabela "Dados_Silver".
-- DROP TABLE "Dados_Gold";
CREATE TABLE "Dados_Gold" AS
SELECT DISTINCT *
FROM "Dados_Silver";

-- Criar tabelas para as dimensões

-- DROP TABLE "dim_tempo";
CREATE TABLE "dim_tempo" AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY "DatCompetencia") AS "tempo_id",
    "DatCompetencia" AS "data_competencia",
    EXTRACT(YEAR FROM "DatCompetencia") AS "ano",
    EXTRACT(MONTH FROM "DatCompetencia") AS "mes",
    TO_CHAR("DatCompetencia", 'Month') AS "nome_mes",
    EXTRACT(QUARTER FROM "DatCompetencia") AS "trimestre",
    CASE 
        WHEN EXTRACT(MONTH FROM "DatCompetencia") <= 6 THEN 1 
        ELSE 2 
    END AS "semestre"
FROM (
    SELECT DISTINCT "DatCompetencia"
    FROM "Dados_Gold"
    WHERE "DatCompetencia" IS NOT NULL
    ORDER BY "DatCompetencia"
);

-- DROP TABLE "dim_distribuidora";
CREATE TABLE "dim_distribuidora" AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY "SigAgenteDistribuidora", "NomAgenteDistribuidora") AS "distribuidora_id",
    "NumCNPJAgenteDistribuidora",
    "SigAgenteDistribuidora",
    "NomAgenteDistribuidora"
FROM (
    SELECT DISTINCT 
        "NumCNPJAgenteDistribuidora",
        "SigAgenteDistribuidora",
        "NomAgenteDistribuidora"
    FROM "Dados_Gold"
    ORDER BY "SigAgenteDistribuidora", "NomAgenteDistribuidora"
);

-- DROP TABLE "dim_acessante";
CREATE TABLE "dim_acessante" AS
SELECT 
    "IdeAgenteAcessante",
    "NumCNPJAgenteAcessante",
    "NomAgenteAcessante"
FROM (
    SELECT DISTINCT 
        "IdeAgenteAcessante",
        "NumCNPJAgenteAcessante",
        "NomAgenteAcessante"
    FROM "Dados_Gold"
    ORDER BY "IdeAgenteAcessante", "NomAgenteAcessante", "NumCNPJAgenteAcessante"
);

-- DROP TABLE "dim_mercado";
CREATE TABLE "dim_mercado" AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY "NomTipoMercado", "DscModalidadeTarifaria", "DscPostoTarifario", "DscDetalheMercado") AS "mercado_id",
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
    FROM "Dados_Gold"
    ORDER BY "NomTipoMercado", "DscModalidadeTarifaria", "DscPostoTarifario", "DscDetalheMercado"
);

-- DROP TABLE "dim_origem";
CREATE TABLE "dim_origem" AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY "DatGeracaoConjuntoDados", "arquivo_origem") AS "origem_id",
    "DatGeracaoConjuntoDados",
    "arquivo_origem"
FROM (
    SELECT DISTINCT 
        "DatGeracaoConjuntoDados",
        "arquivo_origem"
    FROM "Dados_Gold"
    ORDER BY "DatGeracaoConjuntoDados", "arquivo_origem"
);

-- Criar tabela fato

-- DROP TABLE "fato_energia";
CREATE TABLE "fato_energia" AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY dg.ctid) AS "fato_id",
    dt."tempo_id",
    dd."distribuidora_id",
    da."IdeAgenteAcessante",
    dm."mercado_id",
    dor."origem_id",
    dg."VlrMercado"
FROM "Dados_Gold" dg
LEFT JOIN "dim_tempo" dt ON dg."DatCompetencia" = dt."data_competencia"
LEFT JOIN "dim_distribuidora" dd 
    ON dg."NumCNPJAgenteDistribuidora" = dd."NumCNPJAgenteDistribuidora"
    AND dg."SigAgenteDistribuidora" = dd."SigAgenteDistribuidora"
    AND dg."NomAgenteDistribuidora" = dd."NomAgenteDistribuidora"
LEFT JOIN "dim_acessante" da 
    ON dg."NumCNPJAgenteAcessante" = da."NumCNPJAgenteAcessante"
    AND dg."IdeAgenteAcessante" = da."IdeAgenteAcessante"
    AND dg."NomAgenteAcessante" = da."NomAgenteAcessante"
LEFT JOIN "dim_mercado" dm 
    ON dg."NomTipoMercado" = dm."NomTipoMercado"
    AND dg."DscModalidadeTarifaria" = dm."DscModalidadeTarifaria"
    AND dg."DscSubGrupoTarifario" = dm."DscSubGrupoTarifario"
    AND dg."DscClasseConsumoMercado" = dm."DscClasseConsumoMercado"
    AND dg."DscSubClasseConsumidor" = dm."DscSubClasseConsumidor"
    AND dg."DscDetalheConsumidor" = dm."DscDetalheConsumidor"
    AND dg."DscPostoTarifario" = dm."DscPostoTarifario"
    AND dg."DscOpcaoEnergia" = dm."DscOpcaoEnergia"
    AND dg."DscDetalheMercado" = dm."DscDetalheMercado"
LEFT JOIN "dim_origem" dor 
    ON dg."DatGeracaoConjuntoDados" = dor."DatGeracaoConjuntoDados"
    AND dg."arquivo_origem" = dor."arquivo_origem";

/* Auditoria de integridade das chaves primárias */

-- Verificar integridade da Dimensão Tempo
SELECT 'Dim Tempo' AS "Dimensao",
    COUNT(*) AS "Total_Linhas",
    COUNT(DISTINCT "tempo_id") AS "Valores_Unicos",
    COUNT(CASE WHEN "tempo_id" IS NULL THEN 1 END) AS "Nulos",
    CASE 
        WHEN COUNT(*) = COUNT(DISTINCT "tempo_id") AND COUNT(CASE WHEN "tempo_id" IS NULL THEN 1 END) = 0 
        THEN '[OK] Chave integra (Unica e sem nulos)'
        ELSE '[ALERTA] Falha de integridade!'
    END AS "Status"
FROM "dim_tempo";

-- Verificar integridade da Dimensão Distribuidora
SELECT 'Dim Distribuidora' AS "Dimensao",
    COUNT(*) AS "Total_Linhas",
    COUNT(DISTINCT "distribuidora_id") AS "Valores_Unicos",
    COUNT(CASE WHEN "distribuidora_id" IS NULL THEN 1 END) AS "Nulos",
    CASE 
        WHEN COUNT(*) = COUNT(DISTINCT "distribuidora_id") AND COUNT(CASE WHEN "distribuidora_id" IS NULL THEN 1 END) = 0 
        THEN '[OK] Chave integra (Unica e sem nulos)'
        ELSE '[ALERTA] Falha de integridade!'
    END AS "Status"
FROM "dim_distribuidora";

-- Verificar integridade da Dimensão Acessante
SELECT 'Dim Acessante' AS "Dimensao",
    COUNT(*) AS "Total_Linhas",
    COUNT(DISTINCT "IdeAgenteAcessante") AS "Valores_Unicos",
    COUNT(CASE WHEN "IdeAgenteAcessante" IS NULL THEN 1 END) AS "Nulos",
    CASE 
        WHEN COUNT(*) = COUNT(DISTINCT "IdeAgenteAcessante") AND COUNT(CASE WHEN "IdeAgenteAcessante" IS NULL THEN 1 END) = 0 
        THEN '[OK] Chave integra (Unica e sem nulos)'
        ELSE '[ALERTA] Falha de integridade!'
    END AS "Status"
FROM "dim_acessante";

-- Verificar integridade da Dimensão Mercado
SELECT 'Dim Mercado' AS "Dimensao",
    COUNT(*) AS "Total_Linhas",
    COUNT(DISTINCT "mercado_id") AS "Valores_Unicos",
    COUNT(CASE WHEN "mercado_id" IS NULL THEN 1 END) AS "Nulos",
    CASE 
        WHEN COUNT(*) = COUNT(DISTINCT "mercado_id") AND COUNT(CASE WHEN "mercado_id" IS NULL THEN 1 END) = 0 
        THEN '[OK] Chave integra (Unica e sem nulos)'
        ELSE '[ALERTA] Falha de integridade!'
    END AS "Status"
FROM "dim_mercado";

-- Verificar integridade da Dimensão Origem
SELECT 'Dim Origem' AS "Dimensao",
    COUNT(*) AS "Total_Linhas",
    COUNT(DISTINCT "origem_id") AS "Valores_Unicos",
    COUNT(CASE WHEN "origem_id" IS NULL THEN 1 END) AS "Nulos",
    CASE 
        WHEN COUNT(*) = COUNT(DISTINCT "origem_id") AND COUNT(CASE WHEN "origem_id" IS NULL THEN 1 END) = 0 
        THEN '[OK] Chave integra (Unica e sem nulos)'
        ELSE '[ALERTA] Falha de integridade!'
    END AS "Status"
FROM "dim_origem";

/* Validação de relacionamento fato x dimensão */

-- Verificar chave "tempo_id"
SELECT 'tempo_id' AS "Chave",
    COUNT(CASE WHEN "tempo_id" IS NULL THEN 1 END) AS "Registros_Sem_Correspondencia",
    CASE 
        WHEN COUNT(CASE WHEN "tempo_id" IS NULL THEN 1 END) = 0 
        THEN '[OK] Integração realizada com sucesso'
        ELSE '[ALERTA] Existem registros sem correspondencia nas dimensoes'
    END AS "Status"
FROM "fato_energia";

-- Verificar chave "distribuidora_id"
SELECT 'distribuidora_id' AS "Chave",
    COUNT(CASE WHEN "distribuidora_id" IS NULL THEN 1 END) AS "Registros_Sem_Correspondencia",
    CASE 
        WHEN COUNT(CASE WHEN "distribuidora_id" IS NULL THEN 1 END) = 0 
        THEN '[OK] Integração realizada com sucesso'
        ELSE '[ALERTA] Existem registros sem correspondencia nas dimensoes'
    END AS "Status"
FROM "fato_energia";

-- Verificar chave "IdeAgenteAcessante"
SELECT 'IdeAgenteAcessante' AS "Chave",
    COUNT(CASE WHEN "IdeAgenteAcessante" IS NULL THEN 1 END) AS "Registros_Sem_Correspondencia",
    CASE 
        WHEN COUNT(CASE WHEN "IdeAgenteAcessante" IS NULL THEN 1 END) = 0 
        THEN '[OK] Integração realizada com sucesso'
        ELSE '[ALERTA] Existem registros sem correspondencia nas dimensoes'
    END AS "Status"
FROM "fato_energia";

-- Verificar chave "mercado_id"
SELECT 'mercado_id' AS "Chave",
    COUNT(CASE WHEN "mercado_id" IS NULL THEN 1 END) AS "Registros_Sem_Correspondencia",
    CASE 
        WHEN COUNT(CASE WHEN "mercado_id" IS NULL THEN 1 END) = 0 
        THEN '[OK] Integração realizada com sucesso'
        ELSE '[ALERTA] Existem registros sem correspondencia nas dimensoes'
    END AS "Status"
FROM "fato_energia";

-- Verificar chave "origem_id"
SELECT 'origem_id' AS "Chave",
    COUNT(CASE WHEN "origem_id" IS NULL THEN 1 END) AS "Registros_Sem_Correspondencia",
    CASE 
        WHEN COUNT(CASE WHEN "origem_id" IS NULL THEN 1 END) = 0 
        THEN '[OK] Integração realizada com sucesso'
        ELSE '[ALERTA] Existem registros sem correspondencia nas dimensoes'
    END AS "Status"
FROM "fato_energia";

