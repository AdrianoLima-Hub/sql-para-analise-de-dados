-- ============================================================
-- ESTUDO COMPLETO DE SQL PARA ANALISE DE DADOS
-- Baseado no curso da Data Science Academy (DSA)
-- Banco de Dados: PostgreSQL
-- Autor: AdrainoLima-Hub
-- ============================================================


-- ============================================================
-- CAP 3 - PRIMEIROS PASSOS COM LINGUAGEM SQL
-- DDL: Criacao de banco e tabelas | DML: Insercao de dados
-- ============================================================

CREATE SCHEMA IF NOT EXISTS estudo;

CREATE TABLE estudo.clientes (
    id_cliente    SERIAL PRIMARY KEY,
    nome          VARCHAR(100) NOT NULL,
    email         VARCHAR(100),
    cidade        VARCHAR(50),
    estado        CHAR(2),
    data_cadastro DATE DEFAULT CURRENT_DATE
);

CREATE TABLE estudo.produtos (
    id_produto SERIAL PRIMARY KEY,
    nome       VARCHAR(100) NOT NULL,
    categoria  VARCHAR(50),
    preco      NUMERIC(10, 2),
    quantidade INTEGER DEFAULT 0
);

CREATE TABLE estudo.vendas (
    id_venda    SERIAL PRIMARY KEY,
    id_cliente  INTEGER REFERENCES estudo.clientes(id_cliente),
    id_produto  INTEGER REFERENCES estudo.produtos(id_produto),
    quantidade  INTEGER,
    data_venda  DATE DEFAULT CURRENT_DATE,
    valor_total NUMERIC(10, 2)
);

INSERT INTO estudo.clientes (nome, email, cidade, estado) VALUES
('Ana Silva',    'ana@email.com',    'Sao Paulo',      'SP'),
('Bruno Costa',  'bruno@email.com',  'Rio de Janeiro', 'RJ'),
('Carla Mendes', 'carla@email.com',  'Belo Horizonte', 'MG'),
('Diego Souza',  'diego@email.com',  'Curitiba',       'PR'),
('Eva Lima',     'eva@email.com',    'Fortaleza',      'CE'),
('Felipe Rocha', NULL,               'Salvador',       'BA'),
('Gisele Alves', 'gisele@email.com', 'Sao Paulo',      'SP'),
('Hugo Nunes',   'hugo@email.com',   'Recife',         'PE');

INSERT INTO estudo.produtos (nome, categoria, preco, quantidade) VALUES
('Notebook',     'Eletronicos', 3500.00, 50),
('Mouse',        'Eletronicos',   80.00, 200),
('Teclado',      'Eletronicos',  150.00, 150),
('Mesa',         'Moveis',       800.00, 30),
('Cadeira',      'Moveis',       450.00, 60),
('Livro SQL',    'Educacao',      90.00, 100),
('Curso Online', 'Educacao',     299.00, 500),
('Headset',      'Eletronicos',  250.00, 80);

INSERT INTO estudo.vendas (id_cliente, id_produto, quantidade, data_venda, valor_total) VALUES
(1, 1, 1, '2024-01-10', 3500.00),
(2, 2, 2, '2024-01-15',  160.00),
(3, 6, 1, '2024-02-01',   90.00),
(4, 5, 2, '2024-02-10',  900.00),
(1, 3, 1, '2024-02-20',  150.00),
(5, 7, 1, '2024-03-05',  299.00),
(6, 4, 1, '2024-03-10',  800.00),
(7, 8, 1, '2024-03-15',  250.00),
(2, 1, 1, '2024-04-01', 3500.00),
(8, 2, 3, '2024-04-05',  240.00);


-- ============================================================
-- CAP 4 - FUNDAMENTOS DA LINGUAGEM SQL - PARTE 1
-- SELECT, WHERE, operadores, filtros
-- ============================================================

SELECT * FROM estudo.clientes;

SELECT nome, cidade, estado FROM estudo.clientes;

SELECT * FROM estudo.clientes WHERE estado = 'SP';

SELECT * FROM estudo.produtos
WHERE categoria = 'Eletronicos' AND preco < 200;

SELECT * FROM estudo.clientes
WHERE estado IN ('SP', 'RJ', 'MG');

SELECT * FROM estudo.clientes
WHERE estado NOT IN ('CE', 'BA', 'PE');

SELECT * FROM estudo.produtos
WHERE preco BETWEEN 100 AND 500;

-- LIKE: busca por padrao
SELECT * FROM estudo.clientes WHERE nome LIKE 'A%';
SELECT * FROM estudo.clientes WHERE nome LIKE '%Silva';
SELECT * FROM estudo.clientes WHERE nome LIKE '%os%';

-- Filtrar valores nulos
SELECT * FROM estudo.clientes WHERE email IS NULL;
SELECT * FROM estudo.clientes WHERE email IS NOT NULL;

-- Alias de coluna
SELECT nome AS cliente, cidade AS localidade FROM estudo.clientes;

-- Ordenacao
SELECT * FROM estudo.produtos ORDER BY preco DESC;
SELECT * FROM estudo.produtos ORDER BY categoria ASC, preco DESC;

-- Limitar resultados
SELECT * FROM estudo.produtos ORDER BY preco DESC LIMIT 3;


-- ============================================================
-- CAP 5 - FUNDAMENTOS DA LINGUAGEM SQL - PARTE 2
-- Funcoes de agregacao, GROUP BY, HAVING
-- ============================================================

SELECT COUNT(*) AS total_clientes FROM estudo.clientes;

SELECT COUNT(email) AS clientes_com_email FROM estudo.clientes;

SELECT COUNT(DISTINCT estado) AS total_estados FROM estudo.clientes;

SELECT
    SUM(valor_total)           AS receita_total,
    ROUND(AVG(valor_total), 2) AS ticket_medio,
    MAX(valor_total)           AS maior_venda,
    MIN(valor_total)           AS menor_venda
FROM estudo.vendas;

-- Agrupamento por categoria
SELECT categoria, COUNT(*) AS qtd_produtos, ROUND(AVG(preco), 2) AS preco_medio
FROM estudo.produtos
GROUP BY categoria
ORDER BY preco_medio DESC;

-- HAVING: filtro apos agrupamento
SELECT categoria, SUM(quantidade) AS estoque_total
FROM estudo.produtos
GROUP BY categoria
HAVING SUM(quantidade) > 100;

-- Total de clientes por estado
SELECT estado, COUNT(*) AS total_clientes
FROM estudo.clientes
GROUP BY estado
ORDER BY total_clientes DESC;


-- ============================================================
-- CAP 6 - CATEGORIZACAO, CODIFICACAO E BINARIZACAO
-- CASE WHEN
-- ============================================================

-- Faixa de preco
SELECT nome, preco,
    CASE
        WHEN preco < 100  THEN 'Barato'
        WHEN preco < 500  THEN 'Medio'
        WHEN preco < 1000 THEN 'Caro'
        ELSE 'Premium'
    END AS faixa_preco
FROM estudo.produtos;

-- Codificacao de regiao
SELECT nome, estado,
    CASE estado
        WHEN 'SP' THEN 'Sudeste'
        WHEN 'RJ' THEN 'Sudeste'
        WHEN 'MG' THEN 'Sudeste'
        WHEN 'PR' THEN 'Sul'
        WHEN 'CE' THEN 'Nordeste'
        WHEN 'BA' THEN 'Nordeste'
        WHEN 'PE' THEN 'Nordeste'
        ELSE 'Outro'
    END AS regiao
FROM estudo.clientes;

-- Binarizacao: tem email?
SELECT nome,
    CASE WHEN email IS NOT NULL THEN 1 ELSE 0 END AS tem_email
FROM estudo.clientes;

-- Agregacao condicional
SELECT
    COUNT(CASE WHEN estado = 'SP' THEN 1 END) AS clientes_sp,
    COUNT(CASE WHEN estado = 'RJ' THEN 1 END) AS clientes_rj,
    COUNT(CASE WHEN estado NOT IN ('SP','RJ') THEN 1 END) AS outros
FROM estudo.clientes;


-- ============================================================
-- CAP 7 e 8 - JUNCAO DE TABELAS (JOINs)
-- INNER, LEFT, RIGHT, FULL, CROSS JOIN
-- ============================================================

-- INNER JOIN
SELECT
    v.id_venda,
    c.nome      AS cliente,
    p.nome      AS produto,
    v.quantidade,
    v.valor_total,
    v.data_venda
FROM estudo.vendas v
INNER JOIN estudo.clientes c ON v.id_cliente = c.id_cliente
INNER JOIN estudo.produtos p ON v.id_produto = p.id_produto;

-- LEFT JOIN: todos os clientes, mesmo sem venda
SELECT c.nome AS cliente, v.id_venda, v.valor_total
FROM estudo.clientes c
LEFT JOIN estudo.vendas v ON c.id_cliente = v.id_cliente
ORDER BY c.nome;

-- Clientes que NUNCA compraram
SELECT c.nome AS cliente_sem_compra
FROM estudo.clientes c
LEFT JOIN estudo.vendas v ON c.id_cliente = v.id_cliente
WHERE v.id_venda IS NULL;

-- RIGHT JOIN: todos os produtos, mesmo sem venda
SELECT p.nome AS produto, v.id_venda
FROM estudo.vendas v
RIGHT JOIN estudo.produtos p ON v.id_produto = p.id_produto
ORDER BY p.nome;

-- Produtos que NUNCA foram vendidos
SELECT p.nome AS produto_sem_venda
FROM estudo.vendas v
RIGHT JOIN estudo.produtos p ON v.id_produto = p.id_produto
WHERE v.id_venda IS NULL;

-- FULL JOIN
SELECT c.nome, v.id_venda
FROM estudo.clientes c
FULL JOIN estudo.vendas v ON c.id_cliente = v.id_cliente;

-- CROSS JOIN: produto cartesiano
SELECT c.nome AS cliente, p.nome AS produto
FROM estudo.clientes c
CROSS JOIN estudo.produtos p
LIMIT 20;

-- Receita por cliente com JOIN + agregacao
SELECT
    c.nome AS cliente,
    COUNT(v.id_venda)          AS total_pedidos,
    SUM(v.valor_total)         AS receita_total,
    ROUND(AVG(v.valor_total), 2) AS ticket_medio
FROM estudo.clientes c
LEFT JOIN estudo.vendas v ON c.id_cliente = v.id_cliente
GROUP BY c.nome
ORDER BY receita_total DESC NULLS LAST;

-- Receita por categoria
SELECT
    p.categoria,
    COUNT(v.id_venda)  AS total_vendas,
    SUM(v.valor_total) AS receita_total
FROM estudo.vendas v
INNER JOIN estudo.produtos p ON v.id_produto = p.id_produto
GROUP BY p.categoria
ORDER BY receita_total DESC;


-- ============================================================
-- CAP 9 e 10 - AGREGACAO PARA ANALISE DE DADOS
-- ============================================================

-- Receita mensal
SELECT
    EXTRACT(YEAR  FROM data_venda) AS ano,
    EXTRACT(MONTH FROM data_venda) AS mes,
    SUM(valor_total)               AS receita_mensal,
    COUNT(*)                       AS total_pedidos
FROM estudo.vendas
GROUP BY ano, mes
ORDER BY ano, mes;

-- Receita acumulada com Window Function
SELECT
    data_venda,
    valor_total,
    SUM(valor_total) OVER (ORDER BY data_venda) AS receita_acumulada
FROM estudo.vendas
ORDER BY data_venda;

-- Percentual de participacao por produto
SELECT
    p.nome AS produto,
    SUM(v.valor_total) AS receita,
    ROUND(100.0 * SUM(v.valor_total) / SUM(SUM(v.valor_total)) OVER (), 2) AS pct_receita
FROM estudo.vendas v
INNER JOIN estudo.produtos p ON v.id_produto = p.id_produto
GROUP BY p.nome
ORDER BY receita DESC;


-- ============================================================
-- CAP 11 e 12 - WINDOW FUNCTIONS E SUBCONSULTAS
-- ROW_NUMBER, RANK, DENSE_RANK, LAG, LEAD, NTILE, CTE
-- ============================================================

-- ROW_NUMBER por particao
SELECT
    p.nome AS produto,
    p.categoria,
    p.preco,
    ROW_NUMBER() OVER (PARTITION BY p.categoria ORDER BY p.preco DESC) AS rank_categoria
FROM estudo.produtos p;

-- RANK e DENSE_RANK
SELECT
    nome, preco,
    RANK()       OVER (ORDER BY preco DESC) AS rank,
    DENSE_RANK() OVER (ORDER BY preco DESC) AS dense_rank
FROM estudo.produtos;

-- LAG: variacao em relacao a venda anterior
SELECT
    data_venda,
    valor_total,
    LAG(valor_total) OVER (ORDER BY data_venda) AS venda_anterior,
    valor_total - LAG(valor_total) OVER (ORDER BY data_venda) AS variacao
FROM estudo.vendas
ORDER BY data_venda;

-- LEAD: proxima venda
SELECT
    data_venda,
    valor_total,
    LEAD(valor_total) OVER (ORDER BY data_venda) AS proxima_venda
FROM estudo.vendas
ORDER BY data_venda;

-- NTILE: dividir em quartis
SELECT
    nome, preco,
    NTILE(4) OVER (ORDER BY preco) AS quartil
FROM estudo.produtos;

-- CTE (Common Table Expression)
WITH vendas_por_cliente AS (
    SELECT
        c.nome AS cliente,
        SUM(v.valor_total) AS receita_total
    FROM estudo.vendas v
    INNER JOIN estudo.clientes c ON v.id_cliente = c.id_cliente
    GROUP BY c.nome
)
SELECT * FROM vendas_por_cliente
WHERE receita_total > 500
ORDER BY receita_total DESC;

-- CTE recursiva: sequencia numerica
WITH RECURSIVE sequencia AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM sequencia WHERE n < 10
)
SELECT * FROM sequencia;

-- Subconsulta no WHERE
SELECT nome, preco FROM estudo.produtos
WHERE preco > (SELECT AVG(preco) FROM estudo.produtos);

-- Subconsulta correlacionada
SELECT nome, cidade,
    (SELECT COUNT(*) FROM estudo.vendas v WHERE v.id_cliente = c.id_cliente) AS total_compras
FROM estudo.clientes c;

-- Subconsulta no FROM
SELECT categoria, preco_medio
FROM (
    SELECT categoria, ROUND(AVG(preco), 2) AS preco_medio
    FROM estudo.produtos
    GROUP BY categoria
) AS media_por_categoria
WHERE preco_medio > 200;


-- ============================================================
-- CAP 13 - ANALISE EXPLORATORIA DE DADOS (EDA) COM SQL
-- ============================================================

SELECT COUNT(*) AS total_clientes FROM estudo.clientes;
SELECT COUNT(*) AS total_produtos  FROM estudo.produtos;
SELECT COUNT(*) AS total_vendas    FROM estudo.vendas;

-- Distribuicao de clientes por estado
SELECT estado, COUNT(*) AS qtd,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct
FROM estudo.clientes
GROUP BY estado ORDER BY qtd DESC;

-- Estatisticas descritivas de precos
SELECT
    ROUND(AVG(preco),   2) AS media,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY preco) AS mediana,
    ROUND(STDDEV(preco), 2) AS desvio_padrao,
    MIN(preco) AS minimo,
    MAX(preco) AS maximo
FROM estudo.produtos;

-- Vendas por periodo
SELECT
    TO_CHAR(data_venda, 'YYYY-MM') AS mes,
    COUNT(*)          AS qtd_vendas,
    SUM(valor_total)  AS receita
FROM estudo.vendas
GROUP BY mes ORDER BY mes;

-- Top 3 produtos mais vendidos
SELECT p.nome, SUM(v.quantidade) AS unidades_vendidas
FROM estudo.vendas v
INNER JOIN estudo.produtos p ON v.id_produto = p.id_produto
GROUP BY p.nome
ORDER BY unidades_vendidas DESC
LIMIT 3;


-- ============================================================
-- CAP 14, 15 e 16 - LIMPEZA E TRANSFORMACAO DE DADOS
-- ============================================================

-- Registros com campos nulos
SELECT * FROM estudo.clientes WHERE email IS NULL;

-- COALESCE: substituir nulos
SELECT nome, COALESCE(email, 'nao_informado@email.com') AS email
FROM estudo.clientes;

-- NULLIF
SELECT nome, NULLIF(estado, '') AS estado
FROM estudo.clientes;

-- TRIM: remover espacos
SELECT TRIM('  dado com espaco  ') AS dado_limpo;

-- Padronizar texto
SELECT
    UPPER(nome)   AS maiusculo,
    LOWER(nome)   AS minusculo,
    INITCAP(nome) AS capitalizado
FROM estudo.clientes;

-- Extrair partes de string
SELECT
    email,
    SUBSTRING(email FROM 1 FOR POSITION('@' IN email) - 1) AS usuario,
    SPLIT_PART(email, '@', 2) AS dominio
FROM estudo.clientes
WHERE email IS NOT NULL;

-- Concatenar colunas
SELECT nome || ' - ' || cidade || '/' || estado AS identificacao
FROM estudo.clientes;

-- Funcoes de data
SELECT
    CURRENT_DATE                         AS hoje,
    CURRENT_DATE - INTERVAL '30 days'   AS ha_30_dias,
    EXTRACT(YEAR  FROM CURRENT_DATE)     AS ano_atual,
    EXTRACT(MONTH FROM CURRENT_DATE)     AS mes_atual,
    TO_CHAR(CURRENT_DATE, 'DD/MM/YYYY') AS data_formatada;

-- Dias desde a venda
SELECT
    data_venda,
    CURRENT_DATE - data_venda AS dias_desde_venda
FROM estudo.vendas
ORDER BY data_venda;

-- UPDATE: corrigir dados
UPDATE estudo.clientes
SET email = 'felipe@email.com'
WHERE nome = 'Felipe Rocha' AND email IS NULL;

-- Tabela temporaria para analise
CREATE TEMP TABLE vendas_analisadas AS
SELECT
    c.nome     AS cliente,
    p.nome     AS produto,
    p.categoria,
    v.quantidade,
    v.valor_total,
    v.data_venda,
    CASE
        WHEN v.valor_total >= 1000 THEN 'Alto Valor'
        WHEN v.valor_total >= 200  THEN 'Medio Valor'
        ELSE 'Baixo Valor'
    END AS faixa_valor
FROM estudo.vendas v
INNER JOIN estudo.clientes c ON v.id_cliente = c.id_cliente
INNER JOIN estudo.produtos p ON v.id_produto = p.id_produto;

SELECT * FROM vendas_analisadas ORDER BY valor_total DESC;


-- ============================================================
-- CAP 17 - ANALISE DE DADOS E PROCESSO DE SELECAO
-- Perguntas de negocio respondidas com SQL
-- ============================================================

-- Q1: Qual cliente gerou mais receita?
SELECT c.nome, SUM(v.valor_total) AS receita_total
FROM estudo.vendas v
INNER JOIN estudo.clientes c ON v.id_cliente = c.id_cliente
GROUP BY c.nome
ORDER BY receita_total DESC LIMIT 1;

-- Q2: Qual categoria vende mais em valor?
SELECT p.categoria, SUM(v.valor_total) AS receita
FROM estudo.vendas v
INNER JOIN estudo.produtos p ON v.id_produto = p.id_produto
GROUP BY p.categoria
ORDER BY receita DESC;

-- Q3: Qual o mes com maior receita?
SELECT TO_CHAR(data_venda, 'YYYY-MM') AS mes, SUM(valor_total) AS receita
FROM estudo.vendas
GROUP BY mes ORDER BY receita DESC LIMIT 1;

-- Q4: Clientes que compraram mais de uma vez
SELECT c.nome, COUNT(v.id_venda) AS total_compras
FROM estudo.clientes c
INNER JOIN estudo.vendas v ON c.id_cliente = v.id_cliente
GROUP BY c.nome
HAVING COUNT(v.id_venda) > 1
ORDER BY total_compras DESC;

-- Q5: Sazonalidade das vendas por mes
SELECT
    EXTRACT(MONTH FROM data_venda) AS mes,
    COUNT(*)         AS qtd_pedidos,
    SUM(valor_total) AS receita
FROM estudo.vendas
GROUP BY mes ORDER BY mes;


-- ============================================================
-- CAP 18 e 19 - PROGRAMACAO NO BANCO DE DADOS
-- Views, Functions, Stored Procedures
-- ============================================================

-- VIEW: visao reutilizavel
CREATE OR REPLACE VIEW estudo.vw_vendas_detalhadas AS
SELECT
    v.id_venda,
    c.nome     AS cliente,
    c.estado,
    p.nome     AS produto,
    p.categoria,
    v.quantidade,
    v.valor_total,
    v.data_venda
FROM estudo.vendas v
INNER JOIN estudo.clientes c ON v.id_cliente = c.id_cliente
INNER JOIN estudo.produtos p ON v.id_produto = p.id_produto;

SELECT * FROM estudo.vw_vendas_detalhadas WHERE estado = 'SP';

-- FUNCTION: calcular desconto por categoria
CREATE OR REPLACE FUNCTION estudo.calcular_desconto(preco NUMERIC, categoria VARCHAR)
RETURNS NUMERIC AS $$
BEGIN
    RETURN CASE
        WHEN categoria = 'Eletronicos' THEN preco * 0.10
        WHEN categoria = 'Educacao'    THEN preco * 0.15
        ELSE preco * 0.05
    END;
END;
$$ LANGUAGE plpgsql;

SELECT nome, preco, categoria,
    estudo.calcular_desconto(preco, categoria) AS desconto,
    preco - estudo.calcular_desconto(preco, categoria) AS preco_com_desconto
FROM estudo.produtos;

-- STORED PROCEDURE: inserir cliente
CREATE OR REPLACE PROCEDURE estudo.inserir_cliente(
    p_nome   VARCHAR,
    p_email  VARCHAR,
    p_cidade VARCHAR,
    p_estado CHAR(2)
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO estudo.clientes (nome, email, cidade, estado)
    VALUES (p_nome, p_email, p_cidade, p_estado);
    RAISE NOTICE 'Cliente % inserido com sucesso!', p_nome;
END;
$$;

CALL estudo.inserir_cliente('Iago Martins', 'iago@email.com', 'Natal', 'RN');


-- ============================================================
-- CAP 20 e 21 - OTIMIZACAO DE CONSULTAS SQL
-- EXPLAIN, ANALYZE, Indices
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_clientes_estado ON estudo.clientes(estado);
CREATE INDEX IF NOT EXISTS idx_vendas_data     ON estudo.vendas(data_venda);
CREATE INDEX IF NOT EXISTS idx_vendas_cliente  ON estudo.vendas(id_cliente);

-- Analisar plano de execucao
EXPLAIN ANALYZE
SELECT c.nome, SUM(v.valor_total)
FROM estudo.vendas v
INNER JOIN estudo.clientes c ON v.id_cliente = c.id_cliente
WHERE v.data_venda >= '2024-01-01'
GROUP BY c.nome;

-- Boas praticas: selecionar apenas colunas necessarias
SELECT id_cliente, nome, email FROM estudo.clientes WHERE estado = 'SP';

-- Usar EXISTS em vez de IN para grandes volumes
SELECT nome FROM estudo.clientes c
WHERE EXISTS (
    SELECT 1 FROM estudo.vendas v WHERE v.id_cliente = c.id_cliente
);


-- ============================================================
-- CAP 22 - PROJETO ESPECIAL: ANALISE COMPLETA DE NEGOCIO
-- Case real de Analista de Dados
-- ============================================================

-- KPIs principais
SELECT
    COUNT(DISTINCT id_cliente) AS total_clientes_ativos,
    COUNT(*)                   AS total_pedidos,
    SUM(valor_total)           AS receita_total,
    ROUND(AVG(valor_total), 2) AS ticket_medio,
    MAX(valor_total)           AS maior_pedido
FROM estudo.vendas;

-- Analise RFM simplificada (Recencia, Frequencia, Monetario)
WITH rfm AS (
    SELECT
        c.id_cliente,
        c.nome,
        MAX(v.data_venda)                AS ultima_compra,
        COUNT(v.id_venda)                AS frequencia,
        SUM(v.valor_total)               AS valor_total,
        CURRENT_DATE - MAX(v.data_venda) AS recencia_dias
    FROM estudo.clientes c
    INNER JOIN estudo.vendas v ON c.id_cliente = v.id_cliente
    GROUP BY c.id_cliente, c.nome
)
SELECT *,
    CASE
        WHEN recencia_dias <= 30  AND frequencia >= 2 THEN 'Campeao'
        WHEN recencia_dias <= 60  AND frequencia >= 1 THEN 'Leal'
        WHEN recencia_dias > 60   AND frequencia >= 2 THEN 'Em Risco'
        ELSE 'Perdido'
    END AS segmento_rfm
FROM rfm
ORDER BY valor_total DESC;

-- ============================================================
-- FIM DO ESTUDO - SQL para Analise de Dados - DSA
-- ============================================================
