-- CRIAR BANCO DE DADOS
CREATE DATABASE ecommerce;

-- UTILIZAR O BANCO DE DADOS
USE ecommerce;

-- CRIANDO A TABELA CLIENTE
CREATE TABLE Cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    PrimeiroNomeCliente VARCHAR(45),
    NomeDoMeio CHAR(3),
    Sobrenome VARCHAR(45),
    Endereço VARCHAR(45),
    CPF CHAR(11) NOT NULL UNIQUE
);

-- CRIANDO A TABELA PAGAMENTO
CREATE TABLE Pagamento (
    idPagamento INT AUTO_INCREMENT PRIMARY KEY,
    idCliente INT,
    Tipo_pagamento ENUM('Boleto', '1 Cartão', '2 Cartões') NOT NULL,
    LimiteAvaliado FLOAT,
    CONSTRAINT fk_pagamento_cliente FOREIGN KEY (idCliente) REFERENCES Cliente (idCliente)
);

-- CRIANDO A TABELA FORNECEDOR
CREATE TABLE Fornecedor (
    idFornecedor INT AUTO_INCREMENT PRIMARY KEY,
    NomeSocial VARCHAR(225) NOT NULL,
    CNPJ CHAR(10) NOT NULL UNIQUE,
    Contato CHAR(10) NOT NULL
);

-- CRIANDO A TABELA VENDEDOR
CREATE TABLE Vendedor (
    idVendedor INT AUTO_INCREMENT PRIMARY KEY,
    NomeSocial VARCHAR(225) NOT NULL,
    AbsNome VARCHAR(225),
    CNPJ CHAR(20) UNIQUE,
    CPF CHAR(11) UNIQUE,
    localização VARCHAR(225),
    contato CHAR(11) NOT NULL
);

-- CRIANDO A TABELA PRODUTO-VENDEDOR
CREATE TABLE ProdutoVendedor (
    idProdutoVendedor INT,
    idProduto INT,
    QuantidadeProduto INT DEFAULT 1,
    PRIMARY KEY (idProdutoVendedor, idProduto),
    FOREIGN KEY (idProdutoVendedor) REFERENCES Vendedor (idVendedor),
    FOREIGN KEY (idProduto) REFERENCES Produto (idProduto)
);

-- CRIANDO A TABELA PRODUTO-PEDIDO
CREATE TABLE ProdutoPedido (
    idPOPedido INT,
    idPOProduto INT,
    statusPedido ENUM('Disponível', 'Sem estoque') DEFAULT 'Disponível',
    QuantidadeProduto INT DEFAULT 1,
    PRIMARY KEY (idPOPedido, idPOProduto),
    FOREIGN KEY (idPOPedido) REFERENCES Pedido (idPedido),
    FOREIGN KEY (idPOProduto) REFERENCES Produto (idProduto)
);

-- CRIANDO A TABELA STORAGE-LOCATION
CREATE TABLE StorageLocation (
    idLProduto INT,
    idLStorage INT,
    localização VARCHAR(225) NOT NULL,
    PRIMARY KEY (idLProduto, idLStorage),
    FOREIGN KEY (idLProduto) REFERENCES Produto (idProduto),
    FOREIGN KEY (idLStorage) REFERENCES Estoque (idEstoque)
);

-- MOSTRANDO AS TABELAS EXISTENTES
SHOW TABLES;

-- QUANTOS PEDIDOS FORAM FEITOS POR CADA CLIENTE?
SELECT c.nome, COUNT(p.pedido_id) AS total_pedidos 
FROM Cliente c
JOIN Pedido p ON c.cliente_id = p.cliente_id
GROUP BY c.nome;

-- ALGUM VENDEDOR TAMBÉM É FORNECEDOR?
SELECT c.nome AS vendedor, f.nome AS fornecedor
FROM Cliente c
JOIN Fornecedor f ON c.nome = f.nome;

-- RELAÇÃO DE PRODUTOS E FORNECEDORES E ESTOQUES
SELECT p.nome AS produto, f.nome AS fornecedor, e.quantidade AS estoque
FROM Produto p
JOIN Estoque e ON p.produto_id = e.produto_id
JOIN Fornecedor f ON p.produto_id = f.produto_id;

-- RELAÇÃO DE NOMES DOS FORNECEDORES E NOMES DOS PRODUTOS
SELECT f.nome AS fornecedor, p.nome AS produto
FROM Fornecedor f
JOIN Produto p ON f.produto_id = p.produto_id;

-- RECUPERAÇÃO DE DADOS DE ENTREGA COM STATUS ENTREGUE E CODIGO DE RASTREIO
SELECT e.codigo_rastreio, p.data AS data_entrega
FROM Entrega e
JOIN Pedido p ON e.pedido_id = p.pedido_id
WHERE e.status = 'Entregue';