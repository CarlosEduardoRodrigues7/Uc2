CREATE DATABASE naramarket;
USE naramarket;
CREATE TABLE lojas (
 id_loja INT PRIMARY KEY,
 nome VARCHAR(100) NOT NULL,
 bairro VARCHAR(50)
);



CREATE TABLE produtos (
	id_produto INT PRIMARY KEY,
    nome VARCHAR (150) NOT NULL,
    categoria VARCHAR (100) NOT NULL,
    preco DECIMAL(10,2)
    );
    
    CREATE TABLE vendas (
 id_venda INT PRIMARY KEY,
 id_produto INT NOT NULL,
 id_loja INT NOT NULL,
 quantidade INT,
 valor DECIMAL(8,2),
 data_venda DATE,
 FOREIGN KEY (id_produto)
	REFERENCES produtos(id_produto),
 FOREIGN KEY (id_loja)
	REFERENCES lojas(id_loja)
);
    
    DROP TABLE LOJAS;
    
SET GLOBAL local_infile = 1;

LOAD DATA INFILE "C:/Users/carlos.orodrigues/Downloads/naramarket_lojas.csv"
INTO TABLE lojas
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_loja, nome, bairro);

LOAD DATA INFILE "C:/Users/carlos.orodrigues/Downloads/naramarket_produtos.csv"
INTO TABLE produtos
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_produto, nome, categoria, preco);

LOAD DATA INFILE "C:/Users/carlos.orodrigues/Downloads/naramarket_vendas.csv"
INTO TABLE vendas
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_venda, id_produto, id_loja, quantidade, valor, data_venda);


-- Todos os dados da tabela
SELECT * FROM vendas;

-- Colunas específicas
SELECT id_produto, valor FROM vendas;

-- Com filtro simples
SELECT id_produto, valor FROM vendas
WHERE valor > 100;

-- Ordenando e limitando resultados
SELECT id_produto, valor FROM vendas
ORDER BY valor DESC
LIMIT 5;

-- Vendas de uma loja específica
SELECT id_produto, valor FROM vendas
WHERE id_loja = 3;

-- Vendas dentro de um período
SELECT id_produto, valor, data_venda FROM vendas
WHERE data_venda >= '2024-03-01'
AND data_venda <= '2024-03-31';

-- Vendas de produtos específicos
SELECT id_produto, valor FROM vendas
WHERE id_produto IN (5, 12, 47);

-- Total vendido por produto
SELECT id_produto, SUM(valor) AS total_vendas
FROM vendas
GROUP BY id_produto
ORDER BY total_vendas DESC;

-- Quantidade de vendas por loja
SELECT id_loja, COUNT(id_venda) AS quantidade
FROM vendas
GROUP BY id_loja;

-- Valor produto por data
SELECT id_produto, SUM(valor) AS total_vendas
FROM vendas
WHERE data_vendas >= "2024-06-01"
GROUP BY id_produto
HAVING total_vendas >= 10000
ORDER BY total_vendas DESC;

SELECT v.id_venda, p.nome, p.categoria, v.valor
FROM vendas v
INNER JOIN produtos p ON v.id_produto = p.id_produto;

CREATE TABLE  cliente_farmacia (
id INT PRIMARY KEY,
nome VARCHAR(100));

CREATE TABLE vendas_farmacia (
id INT PRIMARY KEY,
id_cliente INT,
FOREIGN KEY (id_cliente)
REFERENCES cliente_farmacia(id));

INSERT INTO cliente_farmacia (id, nome)
VALUES (1, 'Naruto'),
	   (2, 'Goku'),
	   (3, 'Sakura'),
       (4, 'Zoro');
       
INSERT INTO vendas_farmacia (id, id_cliente)
VALUES (1, 4),
	   (2, 2),
	   (3, 2),
       (4, 4);
       
INSERT INTO vendas_farmacia (id)
VALUES (5);
       
SELECT * FROM cliente_farmacia;
SELECT * FROM vendas_farmacia;

SELECT v.id, c.nome
FROM vendas_farmacia v
INNER JOIN cliente_farmacia c ON v.id_cliente = c.id;

SELECT v.id, c.nome
FROM vendas_farmacia v
LEFT JOIN cliente_farmacia c ON v.id_cliente = c.id;

SELECT v.id, c.nome
FROM vendas_farmacia v
RIGHT JOIN cliente_farmacia c ON v.id_cliente = c.id;

SELECT l.bairro, SUM(v.valor) AS faturamento
FROM vendas v
JOIN lojas l ON v.id_loja = l.id_loja
GROUP BY l.bairro
HAVING SUM(v.valor) > 60000
ORDER BY faturamento DESC;

SELECT p.categoria, SUM(v.valor) AS faturamento
FROM vendas v
JOIN produtos p ON v.id_produto = p.id_produto
GROUP BY p.categoria
HAVING SUM(v.valor) > 60000
ORDER BY faturamento DESC;