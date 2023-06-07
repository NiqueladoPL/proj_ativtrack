#Criando o Banco de Dados
CREATE DATABASE ativtracker CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
#----------------------------------------------------------------------------------------


#Selecionando o Banco
USE ativtracker;
#----------------------------------------------------------------------------------------


#Criando usuário com todas as permissões para poder manipular somente o banco Ativtracker
CREATE USER 'masteruser'@'localhost' IDENTIFIED BY '123senha';
GRANT ALL PRIVILEGES ON ativtracker.* TO 'masteruser'@'localhost';
FLUSH PRIVILEGES;
#----------------------------------------------------------------------------------------


#Criando a tabela de usuários 
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50),
    email VARCHAR(100),
    senha VARCHAR(255),
    nivel_acesso INT DEFAULT 0,
    ativo INT DEFAULT 1
);
#----------------------------------------------------------------------------------------


#Criando as tabelas de ATIVOS e CLIENTES
CREATE TABLE ativos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50),
    serial VARCHAR(50),
    marca VARCHAR(50),
    modelo VARCHAR(50),
    tipo VARCHAR(10),
    id_cliente INT,
    status ENUM('Em uso', 'Em manutenção', 'Em estoque', 'Desativado'),
    observacao VARCHAR(255),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id)
);



CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50),
    email VARCHAR(100),
    documento VARCHAR(14),
    id_celular INT,
    id_notebook INT,
    status ENUM('Ativo', 'Inativo'),
    observacao VARCHAR(255),
    FOREIGN KEY (id_celular) REFERENCES ativos(id),
    FOREIGN KEY (id_notebook) REFERENCES ativos(id)
);
#-----------------------------------------------------------------------------------------


#Inserindo dados
INSERT INTO ativos (nome, serial, marca, modelo, tipo, id_cliente, status, observacao)
VALUES
    ('Ativo 1', '123456789', 'Marca 1', 'Modelo 1', 'Notebook', NULL, 'Em estoque', ''),
    ('Ativo 2', '987654321', 'Marca 2', 'Modelo 2', 'Celular', NULL, 'Em estoque', ''),
    ('Ativo 3', '456789123', 'Marca 3', 'Modelo 3', 'Notebook', 1, 'Em uso', 'Observação 1'),
    ('Ativo 4', '321654987', 'Marca 4', 'Modelo 4', 'Celular', 2, 'Em uso', 'Observação 2'),
    ('Ativo 5', '789123456', 'Marca 5', 'Modelo 5', 'Notebook', 3, 'Em uso', 'Observação 3'),
    ('Ativo 6', '654987321', 'Marca 6', 'Modelo 6', 'Celular', 4, 'Em uso', 'Observação 4'),
    ('Ativo 7', '987123654', 'Marca 7', 'Modelo 7', 'Notebook', NULL, 'Em estoque', ''),
    ('Ativo 8', '321789654', 'Marca 8', 'Modelo 8', 'Celular', NULL, 'Em estoque', ''),
    ('Ativo 9', '456123789', 'Marca 9', 'Modelo 9', 'Notebook', 5, 'Em uso', 'Observação 5'),
    ('Ativo 10', '654321987', 'Marca 10', 'Modelo 10', 'Celular', 6, 'Em uso', 'Observação 6');

    
INSERT INTO clientes (nome, email, documento, id_celular, id_notebook, status, observacao)
VALUES
    ('Cliente 1', 'cliente1@example.com', '12345678901', NULL, NULL, 'Ativo', 'Observação 1'),
    ('Cliente 2', 'cliente2@example.com', '23456789012', 2, NULL, 'Ativo', 'Observação 2'),
    ('Cliente 3', 'cliente3@example.com', '34567890123', NULL, 3, 'Inativo', 'Observação 3'),
    ('Cliente 4', 'cliente4@example.com', '45678901234', 4, NULL, 'Ativo', 'Observação 4'),
    ('Cliente 5', 'cliente5@example.com', '56789012345', NULL, 5, 'Ativo', 'Observação 5'),
    ('Cliente 6', 'cliente6@example.com', '67890123456', 6, NULL, 'Inativo', 'Observação 6'),
    ('Cliente 7', 'cliente7@example.com', '78901234567', NULL, 7, 'Ativo', 'Observação 7'),
    ('Cliente 8', 'cliente8@example.com', '89012345678', 8, NULL, 'Ativo', 'Observação 8'),
    ('Cliente 9', 'cliente9@example.com', '90123456789', NULL, 9, 'Inativo', 'Observação 9'),
    ('Cliente 10', 'cliente10@example.com', '01234567890', 10, NULL, 'Ativo', 'Observação 10');


INSERT INTO usuarios (nome, email, senha, nivel_acesso, ativo)
VALUES
    ('Usuário 1', 'usuario1@example.com', 'senha1', 1, 1),
    ('Usuário 2', 'usuario2@example.com', 'senha2', 2, 1),
    ('Usuário 3', 'usuario3@example.com', 'senha3', 1, 0),
    ('Usuário 4', 'usuario4@example.com', 'senha4', 2, 1),
    ('Usuário 5', 'usuario5@example.com', 'senha5', 1, 1);
#-----------------------------------------------------------------------------------------


#Criando view para ver ativo vinculado aos clientes
CREATE VIEW clientes_e_ativos AS
SELECT clientes.id AS id_cliente, clientes.nome AS nome_cliente, clientes.email AS email_cliente,
       IFNULL(ativos_notebook.id, '-') AS id_notebook, IFNULL(ativos_notebook.nome, '-') AS nome_notebook,
       IFNULL(ativos_celular.id, '-') AS id_celular, IFNULL(ativos_celular.nome, '-') AS nome_celular
FROM clientes
LEFT JOIN ativos AS ativos_notebook ON clientes.id_notebook = ativos_notebook.id
LEFT JOIN ativos AS ativos_celular ON clientes.id_celular = ativos_celular.id;

SELECT * FROM clientes_e_ativos;
#-----------------------------------------------------------------------------------------


#Criando view para ver ativos em uso
CREATE VIEW ativos_em_uso AS
SELECT ativos.id AS id_ativo, ativos.nome AS nome_ativo, ativos.tipo AS tipo_ativo,
       clientes.id AS id_cliente, clientes.nome AS nome_cliente, clientes.email AS email_cliente
FROM ativos
INNER JOIN clientes ON ativos.id_cliente = clientes.id
WHERE ativos.status = 'Em uso' AND ativos.id_cliente IS NOT NULL;

SELECT * FROM ativos_em_uso;
#-----------------------------------------------------------------------------------------


#Criando view para ver celulares em uso
CREATE VIEW celulares_em_uso AS
SELECT ativo.id AS id_celular, ativo.nome AS nome_celular, ativo.status AS status_celular, cliente.email AS email_cliente
FROM ativos AS ativo
INNER JOIN clientes AS cliente ON ativo.id_cliente = cliente.id
WHERE ativo.tipo = 'Celular' AND ativo.status = 'Em uso';

SELECT * FROM celulares_em_uso;
#-----------------------------------------------------------------------------------------


#Criando view para ver notebooks em uso
CREATE VIEW notebooks_em_uso AS
SELECT ativo.id AS id_notebook, ativo.nome AS nome_notebook, ativo.status AS status_notebook, cliente.email AS email_cliente
FROM ativos AS ativo
INNER JOIN clientes AS cliente ON ativo.id_cliente = cliente.id
WHERE ativo.tipo = 'Notebook' AND ativo.status = 'Em uso';

SELECT * FROM notebooks_em_uso;
#-----------------------------------------------------------------------------------------


#Criando view para ver celulares que não estão em uso
CREATE VIEW celulares_nao_em_uso AS 
SELECT id, nome, status FROM ativos WHERE tipo = 'Celular' AND status != 'Em uso';

SELECT * FROM celulares_nao_em_uso;

#-----------------------------------------------------------------------------------------


#Criando view para ver notebooks que não estão em uso
CREATE VIEW notebooks_nao_em_uso AS
SELECT id, nome, status FROM ativos WHERE tipo = 'Notebook' AND status != 'Em uso';

SELECT * FROM notebooks_nao_em_uso;
#-----------------------------------------------------------------------------------------


#Criando tabela de LOG
CREATE TABLE log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tabela VARCHAR(50),
    acao VARCHAR(10),
    usuario VARCHAR(50),
    data_hora DATETIME
);
#-----------------------------------------------------------------------------------------


#Criando trigger para a tabela clientes
#Trigger para INSERT
DELIMITER $$
CREATE TRIGGER clientes_insert_trigger AFTER INSERT ON clientes
FOR EACH ROW
BEGIN
    INSERT INTO log (tabela, acao, usuario, data_hora)
    VALUES ('clientes', 'Inserção', USER(), NOW());
END $$
DELIMITER ;

#Trigger para UPDATE
DELIMITER $$
CREATE TRIGGER clientes_update_trigger AFTER UPDATE ON clientes
FOR EACH ROW
BEGIN
    #atualizar ativo (adionar ou remover) - (notebook ou celular)
    INSERT INTO log (tabela, acao, usuario, data_hora)
    VALUES ('clientes', 'Alteração', USER(), NOW());
END $$
DELIMITER ;

#Trigger para DELETE
DELIMITER $$
CREATE TRIGGER clientes_delete_trigger AFTER DELETE ON clientes
FOR EACH ROW
BEGIN
    INSERT INTO log (tabela, acao, usuario, data_hora)
    VALUES ('clientes', 'Exclusão', USER(), NOW());
END $$
DELIMITER ;
#-----------------------------------------------------------------------

#Criando trigger para a tabela ativos
#Trigger para INSERT
DELIMITER $$
CREATE TRIGGER ativos_insert_trigger AFTER INSERT ON ativos
FOR EACH ROW
BEGIN
    INSERT INTO log (tabela, acao, usuario, data_hora)
    VALUES ('ativos', 'Inserção', USER(), NOW());
END $$
DELIMITER ;

#Trigger para UPDATE
DELIMITER $$
CREATE TRIGGER ativos_update_trigger AFTER UPDATE ON ativos
FOR EACH ROW
BEGIN
    INSERT INTO log (tabela, acao, usuario, data_hora)
    VALUES ('ativos', 'Alteração', USER(), NOW());
END $$
DELIMITER ;

#Trigger para DELETE
DELIMITER $$
CREATE TRIGGER ativos_delete_trigger AFTER DELETE ON ativos
FOR EACH ROW
BEGIN
    INSERT INTO log (tabela, acao, usuario, data_hora)
    VALUES ('ativos', 'Exclusão', USER(), NOW());
END $$
DELIMITER ;
#----------------------------------------------------------------------------


#TESTE
INSERT INTO clientes (nome, email, documento) VALUES ('João', 'joao@example.com', '12345678901');

UPDATE clientes SET nome = 'Maria' WHERE id = 1;

DELETE FROM clientes WHERE id = 1;

INSERT INTO ativos (nome, serial, marca, modelo, tipo, id_cliente, status, observacao)
VALUES ('Notebook', 'ABC123', 'Dell', 'Latitude', 'Notebook', 1, 'Em uso', 'Observação do notebook');

UPDATE ativos SET nome = 'Celular', marca = 'Samsung' WHERE id = 1;

DELETE FROM ativos WHERE id = 1;

SELECT * FROM log;



#-------------------------------------------------------------------------------
#Adicionando a função de manutenção

ALTER TABLE ativos
ADD COLUMN data_manutencao DATE AFTER status;

select * from ativos;

TRUNCATE TABLE ativos;
TRUNCATE TABLE clientes;

INSERT INTO ativos (nome, serial, marca, modelo, tipo, id_cliente, status, observacao, data_manutencao)
VALUES
  ('Ativo 1', 'Serial 1', 'Marca 1', 'Modelo 1', 'Celular', 1, 'Em uso', 'Observação 1', '2022-05-25'),
  ('Ativo 2', 'Serial 2', 'Marca 2', 'Modelo 2', 'Notebook', 2, 'Em uso', 'Observação 2', '2022-10-12'),
  ('Ativo 3', 'Serial 3', 'Marca 3', 'Modelo 3', 'Celular', 3, 'Em uso', 'Observação 3', '2022-08-21')
  ;
  


INSERT INTO clientes (nome, email, documento, id_celular, id_notebook, status, observacao)
VALUES
  ('Cliente 1', 'cliente1@example.com', 'CPF 1', 1, NULL, 'Ativo', 'Observação 1'),
  ('Cliente 2', 'cliente2@example.com', 'CPF 2', NULL, 2, 'Ativo', 'Observação 2'),
  ('Cliente 3', 'cliente3@example.com', 'CPF 3', 3, NULL, 'Ativo', 'Observação 3')
  ;


#Criando a procedure
DELIMITER //

DELIMITER //

CREATE PROCEDURE atualiza_view_manutencao()
BEGIN
    DROP VIEW IF EXISTS view_manutencao;

    CREATE VIEW view_manutencao AS
    SELECT * FROM ativos WHERE data_manutencao < DATE_SUB(CURDATE(), INTERVAL 6 MONTH);
END //

DELIMITER ;


#Executando a procedure uma vez por semana
CREATE EVENT IF NOT EXISTS event_atualizar_view
ON SCHEDULE EVERY 1 WEEK
DO CALL atualiza_view_manutencao();

CALL atualiza_view_manutencao();
    
select * from view_manutencao;


#------------------------------------------------------------------
#Função para contar notebooks e celulares

DELIMITER //

CREATE FUNCTION ContarNotebooks()
RETURNS TEXT
BEGIN
    SET @total := 0;
    SET @emUso := 0;
    SET @emEstoque := 0;
    SET @resultado := '';

    SELECT COUNT(*) INTO @total FROM ativos WHERE tipo = 'Notebook';
    SELECT COUNT(*) INTO @emUso FROM ativos WHERE tipo = 'Notebook' AND status = 'Em uso';
    SELECT COUNT(*) INTO @emEstoque FROM ativos WHERE tipo = 'Notebook' AND status = 'Em estoque';

    SET @resultado := CONCAT('Total: ', @total, ', Em uso: ', @emUso, ', Em estoque: ', @emEstoque);

    RETURN @resultado;
END //

DELIMITER ;


INSERT INTO ativos (nome, serial, marca, modelo, tipo, id_cliente, status, observacao, data_manutencao)
VALUES
  ('Notebook 4', 'Serial 4', 'Marca 4', 'Modelo 4', 'Notebook', NULL, 'Em estoque', 'Observação 4', '2022-05-23'),
  ('Notebook 5', 'Serial 5', 'Marca 5', 'Modelo 5', 'Notebook', NULL, 'Em uso', 'Observação 5', '2022-12-01'),
  ('Notebook 6', 'Serial 6', 'Marca 6', 'Modelo 6', 'Notebook', NULL, 'Em uso', 'Observação 6', '2023-04-24');

SELECT ContarNotebooks();




DELIMITER //
CREATE FUNCTION ContarCelulares()
RETURNS VARCHAR(100)
BEGIN
    DECLARE total INT;
    DECLARE emUso INT;
    DECLARE emEstoque INT;
    DECLARE resultado VARCHAR(100);
    
    SELECT COUNT(*) INTO total FROM ativos WHERE tipo = 'Celular';
    SELECT COUNT(*) INTO emUso FROM ativos WHERE tipo = 'Celular' AND status = 'Em uso';
    SELECT COUNT(*) INTO emEstoque FROM ativos WHERE tipo = 'Celular' AND status = 'Em estoque';
    
    SET resultado = CONCAT('Total de celulares: ', total, ', Em uso: ', emUso, ', Em estoque: ', emEstoque);
    
    RETURN resultado;
END //
DELIMITER ;

INSERT INTO ativos (nome, serial, marca, modelo, tipo, id_cliente, status, observacao)
VALUES
  ('Celular 1', 'Serial 4', 'Marca 4', 'Modelo 4', 'Celular', NULL, 'Em estoque', 'Observação 4'),
  ('Celular 2', 'Serial 5', 'Marca 5', 'Modelo 5', 'Celular', NULL, 'Em estoque', 'Observação 5'),
  ('Celular 3', 'Serial 6', 'Marca 6', 'Modelo 6', 'Celular', NULL, 'Em estoque', 'Observação 6'),
  ('Celular 4', 'Serial 7', 'Marca 7', 'Modelo 7', 'Celular', NULL, 'Em estoque', 'Observação 7'),
  ('Celular 5', 'Serial 8', 'Marca 8', 'Modelo 8', 'Celular', NULL, 'Em estoque', 'Observação 8');


SELECT ContarCelulares();
