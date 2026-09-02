-- Criando o banco de dados e selecionando-o
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;


-- ------------------------------------------------------------
-- TABELA CLIENTE: Armazena informações de clientes PF (Pessoa Física) e PJ (Pessoa Jurídica)
-- ------------------------------------------------------------
CREATE TABLE clientes (
cliente_id INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
tipo ENUM('PF', 'PJ') NOT NULL,
cpf VARCHAR(14) UNIQUE,
cnpj VARCHAR(18) UNIQUE,
email VARCHAR(100),
telefone VARCHAR(20),
CONSTRAINT chk_cliente_tipo CHECK (
(tipo = 'PF' AND cpf IS NOT NULL AND cnpj IS NULL) OR
(tipo = 'PJ' AND cnpj IS NOT NULL AND cpf IS NULL)
)
);


-- ------------------------------------------------------------
-- TABELA FORNECEDOR: Dados das empresas fornecedoras de produtos
-- ------------------------------------------------------------
CREATE TABLE fornecedores (
fornecedor_id INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
cnpj VARCHAR(18) UNIQUE NOT NULL,
telefone VARCHAR(20)
);


-- ------------------------------------------------------------
-- TABELA PRODUTOS: Armazena os produtos disponíveis no e-commerce
-- ------------------------------------------------------------
CREATE TABLE produtos (
produto_id INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
descricao TEXT,
preco DECIMAL(10,2) NOT NULL,
fornecedor_id INT,
FOREIGN KEY (fornecedor_id) REFERENCES fornecedores(fornecedor_id)
);


-- ------------------------------------------------------------
-- TABELA ESTOQUE: Controla o estoque de produtos
-- ------------------------------------------------------------
CREATE TABLE estoque (
estoque_id INT AUTO_INCREMENT PRIMARY KEY,
produto_id INT NOT NULL,
quantidade INT DEFAULT 0,
localizacao VARCHAR(100),
FOREIGN KEY (produto_id) REFERENCES produtos(produto_id)
);


-- ------------------------------------------------------------
-- TABELA VENDEDORES: Representa os vendedores cadastrados na plataforma
-- ------------------------------------------------------------
CREATE TABLE vendedores (
vendedor_id INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
cpf VARCHAR(14) UNIQUE NOT NULL,
email VARCHAR(100)
);


-- ------------------------------------------------------------
-- TABELA PEDIDOS: Armazena os pedidos realizados pelos clientes
-- ------------------------------------------------------------
CREATE TABLE pedidos (
pedido_id INT AUTO_INCREMENT PRIMARY KEY,
cliente_id INT NOT NULL,
vendedor_id INT,
data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
status ENUM('Em processamento', 'Enviado', 'Entregue', 'Cancelado') DEFAULT 'Em processamento',
valor_total DECIMAL(10,2),
FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id),
FOREIGN KEY (vendedor_id) REFERENCES vendedores(vendedor_id)
);


-- ------------------------------------------------------------
-- TABELA PAGAMENTOS: Armazena as formas de pagamento e seus detalhes
-- ------------------------------------------------------------
CREATE TABLE pagamentos (
pagamento_id INT AUTO_INCREMENT PRIMARY KEY,
pedido_id INT NOT NULL,
tipo_pagamento ENUM('Cartão de Crédito', 'Boleto', 'Pix', 'Transferência') NOT NULL,
status_pagamento ENUM('Pendente', 'Concluído', 'Cancelado') DEFAULT 'Pendente',
FOREIGN KEY (pedido_id) REFERENCES pedidos(pedido_id)
);


-- ------------------------------------------------------------
-- TABELA ENTREGAS: Controla o status de entrega dos pedidos
-- ------------------------------------------------------------
CREATE TABLE entregas (
entrega_id INT AUTO_INCREMENT PRIMARY KEY,
pedido_id INT NOT NULL,
codigo_rastreio VARCHAR(50),
status_entrega ENUM('Aguardando Envio', 'Em Trânsito', 'Entregue', 'Devolvido') DEFAULT 'Aguardando Envio',
FOREIGN KEY (pedido_id) REFERENCES pedidos(pedido_id)
);


-- ------------------------------------------------------------
-- TABELA ITENS_PEDIDO: Relaciona produtos com pedidos (N:N)
-- ------------------------------------------------------------
CREATE TABLE itens_pedido (
item_id INT AUTO_INCREMENT PRIMARY KEY,
pedido_id INT NOT NULL,
produto_id INT NOT NULL,
quantidade INT DEFAULT 1,
preco_unitario DECIMAL(10,2) NOT NULL,
FOREIGN KEY (pedido_id) REFERENCES pedidos(pedido_id),
FOREIGN KEY (produto_id) REFERENCES produtos(produto_id)
);

-- ------------------------------------------------------------
-- INSERINDO DADOS DE EXEMPLO
-- ------------------------------------------------------------


INSERT INTO clientes (nome, tipo, cpf, cnpj, email, telefone) VALUES
 ('João Silva', 'PF', '123.456.789-00', NULL, 'joao@email.com', '11999999999'),
 ('Maria Souza', 'PF', '987.654.321-00', NULL, 'maria@email.com', '11988888888'),
 ('Tech Solutions LTDA', 'PJ', NULL, '12.345.678/0001-00', 'contato@techsol.com', '1133333333');



INSERT INTO fornecedores (nome, cnpj, telefone) VALUES
('Fornecedor A', '11.111.111/0001-11', '1144444444'),
('Fornecedor B', '22.222.222/0001-22', '1155555555');


INSERT INTO produtos (nome, descricao, preco, fornecedor_id) VALUES
('Notebook', 'Notebook 15 polegadas', 3500.00, 1),
('Mouse Gamer', 'Mouse RGB 16000 DPI', 150.00, 2),
('Cadeira Escritório', 'Cadeira ergonômica ajustável', 800.00, 1);


INSERT INTO estoque (produto_id, quantidade, localizacao) VALUES
(1, 15, 'Depósito A'),
(2, 50, 'Depósito B'),
(3, 25, 'Depósito A');


INSERT INTO vendedores (nome, cpf, email) VALUES
('Carlos Vendas', '111.222.333-44', 'carlos@empresa.com'),
('Ana Paula', '555.666.777-88', 'ana@empresa.com');


INSERT INTO pedidos (cliente_id, vendedor_id, status, valor_total) VALUES
(7, 1, 'Em processamento', 3650.00),
(8, 2, 'Enviado', 150.00),
(9, 1, 'Entregue', 800.00);


INSERT INTO pagamentos (pedido_id, tipo_pagamento, status_pagamento) VALUES
(10, 'Cartão de Crédito', 'Concluído'),
(11, 'Pix', 'Concluído'),
(12, 'Boleto', 'Pendente');


INSERT INTO entregas (pedido_id, codigo_rastreio, status_entrega) VALUES
(10, 'BR123456789', 'Em Trânsito'),
(11, 'BR987654321', 'Entregue'),
(12, 'BR111222333', 'Aguardando Envio');


INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unitario) VALUES
(10, 1, 1, 3500.00),
(10, 2, 1, 150.00),
(11, 2, 1, 150.00),
(12, 3, 1, 800.00);

-- ------------------------------------------------------------
-- CONSULTAS SQL (QUERIES)
-- ------------------------------------------------------------


-- Recuperar todos os pedidos e seus respectivos clientes
SELECT p.pedido_id, c.nome AS cliente, p.status, p.valor_total
FROM pedidos p
JOIN clientes c ON p.cliente_id = c.cliente_id;


-- Quantos pedidos foram feitos por cada cliente
SELECT c.nome AS cliente, COUNT(p.pedido_id) AS total_pedidos
FROM clientes c
JOIN pedidos p ON c.cliente_id = p.cliente_id
GROUP BY c.nome
ORDER BY total_pedidos DESC;


-- Relação de produtos, fornecedores e estoques
SELECT pr.nome AS produto, f.nome AS fornecedor, e.quantidade
FROM produtos pr
JOIN fornecedores f ON pr.fornecedor_id = f.fornecedor_id
JOIN estoque e ON pr.produto_id = e.produto_id;


-- Relação de nomes dos fornecedores e nomes dos produtos
SELECT f.nome AS fornecedor, pr.nome AS produto
FROM fornecedores f
JOIN produtos pr ON f.fornecedor_id = pr.fornecedor_id
ORDER BY f.nome;


-- Valor total médio de pedidos concluídos
SELECT ROUND(AVG(valor_total), 2) AS media_valor_pedidos
FROM pedidos
WHERE status = 'Entregue';


-- Atributo derivado: total gasto por cliente
SELECT c.nome, SUM(p.valor_total) AS total_gasto
FROM clientes c
JOIN pedidos p ON c.cliente_id = p.cliente_id
GROUP BY c.nome
ORDER BY total_gasto DESC;