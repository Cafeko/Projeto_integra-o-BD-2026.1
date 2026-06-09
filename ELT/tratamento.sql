/* Fazendo tratamento e correções iniciais dos dados */

-- Remover espaços extras no inicio e no final do valores:
UPDATE "Dados_Bronze"
SET "DatGeracaoConjuntoDados" = trim("DatGeracaoConjuntoDados"),
"NumCNPJAgenteDistribuidora" = trim("NumCNPJAgenteDistribuidora"),
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
"DatCompetencia" = trim("DatCompetencia"),
"VlrMercado" = trim("VlrMercado"),
"arquivo_origem" =  trim("arquivo_origem");


-- Trocar tipos de dados:

--- "DatGeracaoConjuntoDados" de text para date.
ALTER TABLE "Dados_Bronze" ALTER COLUMN "DatGeracaoConjuntoDados"
TYPE DATE USING to_date("DatGeracaoConjuntoDados", 'YYYY-MM--DD');

--- "DatCompetencia" de text para date.
ALTER TABLE "Dados_Bronze" ALTER COLUMN "DatCompetencia"
TYPE DATE USING to_date("DatCompetencia", 'YYYY-MM--DD');

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


-- Tratamento de acentuação:
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
ADD COLUMN "competencia_mes" INTEGER,
ADD COLUMN "competencia_trimestre" INTEGER;

UPDATE "Dados_Silver"
SET "competencia_ano" = EXTRACT(YEAR FROM "DatCompetencia"),
"competencia_mes" = EXTRACT(MONTH FROM "DatCompetencia"),
"competencia_trimestre" = EXTRACT(QUARTER FROM "DatCompetencia");


-- Preenche nulos de "IdeAgenteAcessante", "NomAgenteAcessante" e "NumCNPJAgenteAcessante":
UPDATE "Dados_Silver"
SET "IdeAgenteAcessante" = 'NAO INFORMADO'
WHERE "IdeAgenteAcessante" IS NULL;

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


-- Criar tabela fato


