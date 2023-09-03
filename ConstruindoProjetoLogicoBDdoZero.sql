-- CRIAÇÂO DE TABELAS
CREATE TABLE Cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    telefone VARCHAR(15)
);

CREATE TABLE Carro (
    idCarro INT AUTO_INCREMENT PRIMARY KEY,
    idCliente INT,
    modelo VARCHAR(50),
    ano INT,
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);

CREATE TABLE Servico (
    idServico INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(200),
    preco DECIMAL(10, 2)
);

-- OUTRAS TABELAS (Funcionário, Agenda, etc.) TAMBÉM DEVEM SER CRIADAS
-- Criar tabelas para relacionamentos, se necessário
CREATE TABLE CarroServico (
    idCarro INT,
    idServico INT,
    PRIMARY KEY (idCarro, idServico),
    FOREIGN KEY (idCarro) REFERENCES Carro(idCarro),
    FOREIGN KEY (idServico) REFERENCES Servico(idServico)
);

-- INSERIR DADOS DOS CLIENTES
INSERT INTO Cliente (nome, telefone) VALUES ('Pedro', '1234567890');
INSERT INTO Cliente (nome, telefone) VALUES ('Mateus', '9876543210');

-- INSERIR DADOS DOS CARROS
INSERT INTO Carro (idCliente, modelo, ano) VALUES (1, 'HB20', 1980);
INSERT INTO Carro (idCliente, modelo, ano) VALUES (2, 'Fit', 2020);

-- INSERIR DADOS DOS SERVIÇOS
INSERT INTO Servico (descricao, preco) VALUES ('Troca de óleo', 50.00);
INSERT INTO Servico (descricao, preco) VALUES ('Cambagem', 80.00);

-- RECUPERAÇÃO DE TODOS OS CARROS DE UM CLIENTE ESPECIFICO
SELECT Carro.modelo, Carro.ano
FROM Carro
WHERE Carro.idCliente = 1; -- Substitua 1 pelo ID do cliente desejado

-- RECUPERACAO DOS SERVICOS REALIZADOS EM UM CARRO COM VALOR TOTAL
SELECT Servico.descricao, Servico.preco
FROM CarroServico
JOIN Servico ON CarroServico.idServico = Servico.idServico
WHERE CarroServico.idCarro = 1; -- Substitua 1 pelo ID do carro desejado

-- CALCULAR O VALOR TOTAL, ADD GROUP BY
SELECT CarroServico.idCarro, SUM(Servico.preco) AS ValorTotal
FROM CarroServico
JOIN Servico ON CarroServico.idServico = Servico.idServico
GROUP BY CarroServico.idCarro;

-- RECUPERACAO DOS CARROS QUE REALIZARAM UM SERVICO ESPECIFICO
SELECT Carro.modelo, Carro.ano
FROM Carro
JOIN CarroServico ON Carro.idCarro = CarroServico.idCarro
WHERE CarroServico.idServico = 1; -- Substitua 1 pelo ID do serviço desejado

-- RECUPERACAO DOS CLIENTES QUE GASTARAM MAIS DE X EM SERVCICOS
SELECT Cliente.nome, SUM(Servico.preco) AS TotalGasto
FROM Cliente
JOIN Carro ON Cliente.idCliente = Carro.idCliente
JOIN CarroServico ON Carro.idCarro = CarroServico.idCarro
JOIN Servico ON CarroServico.idServico = Servico.idServico
GROUP BY Cliente.idCliente
HAVING TotalGasto > 100; -- Substitua 100 pelo valor desejado