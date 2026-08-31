CREATE DATABASE naranerd;
USE naranerd; 
CREATE TABLE clientes (
id_cliente INT PRIMARY KEY,
nome VARCHAR (100),
email VARCHAR (100),
cidade VARCHAR (100)
);

CREATE TABLE vendedores (
id_vendedor INT PRIMARY KEY, 
nome VARCHAR (100), 
loja VARCHAR (100)
);

CREATE TABLE produtos (
id_produto INT PRIMARY KEY, 
nome VARCHAR (100) NOT NULL, 
categoria VARCHAR (100), 
preco DECIMAL (10,2)
);

CREATE TABLE vendas (
id_venda INT PRIMARY KEY, 
id_cliente INT NOT NULL, 
id_vendedor INT NOT NULL, 
id_produto INT NOT NULL, 
quantidade INT NOT NULL, 
valor DECIMAL (10,2), 
data_venda DATE,
FOREIGN KEY (id_cliente)
	REFERENCES clientes(id_cliente),
FOREIGN KEY (id_vendedor)
	REFERENCES vendedores(id_vendedor),
FOREIGN KEY (id_produto)
	REFERENCES produtos(id_produto)
);

DROP TABLE vendas;



SET GLOBAL local_infile = 1;

LOAD DATA INFILE "C:/Users/carlos.orodrigues/Downloads/naranerd_clientes.csv"
INTO TABLE clientes
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_cliente, nome, email, cidade);

SELECT * FROM clientes

LOAD DATA INFILE "C:/Users/carlos.orodrigues/Downloads/naranerd_vendedores.csv"
INTO TABLE vendedores
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_vendedor, nome, loja);
SELECT * FROM vendedores

LOAD DATA INFILE "C:/Users/carlos.orodrigues/Downloads/naranerd_produtos.csv"
INTO TABLE produtos
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_produto, nome, categoria, preco);
SELECT * FROM produtos

LOAD DATA INFILE "C:/Users/carlos.orodrigues/Downloads/naranerd_vendas.csv"
INTO TABLE vendas
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_venda, id_cliente, id_vendedor, id_produto, quantidade, valor, data_venda);

SELECT * FROM vendas;

-- 1  Quem é esse cliente e quanto ele gastou?
SELECT c.id_cliente, c.nome, SUM(v.valor) AS total_gasto
FROM  vendas v
INNER JOIN clientes c  ON v.id_cliente = c.id_cliente
GROUP BY c.nome, c.id_cliente
ORDER BY total_gasto DESC


-- 2 ranking de vendedores.
SELECT r.nome, r.id_vendedor, COUNT(v.id_venda) AS quantidade_vendas
FROM vendas v
INNER JOIN vendedores r  ON v.id_vendedor = r.id_vendedor 
GROUP BY r.id_vendedor, r.nome
ORDER BY quantidade_vendas DESC


-- 3  categoria de produto trouxe mais receit
SELECT p.categoria, SUM(v.valor) AS categoria_receita
FROM vendas v
INNER JOIN produtos p 	ON  v.id_produto = p.id_produto 
GROUP BY p.categoria
ORDER BY categoria_receita DESC



SELECT c.cidade, COUNT(v.id_venda) AS cidades_vendas
FROM vendas v
INNER JOIN clientes c 	ON c.id_cliente = v.id_cliente
GROUP BY c.cidade
ORDER BY cidades_vendas DESC
LIMIT 10;


-- 4 vendedor cidade
SELECT r.nome, c.cidade, COUNT(v.id_venda) AS cidades_vendas
FROM vendas v
JOIN clientes c   ON  v.id_cliente = c.id_cliente 
JOIN vendedores r ON  v.id_vendedor = r.id_vendedor
GROUP BY c.cidade, r.nome
ORDER BY cidades_vendas DESC

-- 5 média venda
SELECT r.nome, p.categoria, ROUND(AVG(v.valor),2) AS ticket_médio
FROM vendas v
JOIN produtos p   ON  v.id_produto = p.id_produto 
JOIN vendedores r ON  v.id_vendedor = r.id_vendedor
GROUP BY r.nome, p.categoria
ORDER BY ticket_médio DESC


 