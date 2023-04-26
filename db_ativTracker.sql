CREATE DATABASE ativtracker ;

use ativtracker;

CREATE TABLE usuarios(
id_usu int PRIMARY KEY AUTO_INCREMENT NOT NULL,
nome_usu varchar(30) NOT NULL,
email_usu varchar(50) NOT NULL,
pass_usu varchar(255) NOT NULL,
ativo_usu boolean NOT NULL
);


CREATE TABLE ativos(
id_ativ int PRIMARY KEY AUTO_INCREMENT NOT NULL,
nome_ativ varchar(30) NOT NULL,
serial_ativ varchar(50) NOT NULL,
marca_ativ varchar(30) NOT NULL,
modelo_ativ varchar(30) NOT NULL,
categoria_ativ varchar(10) NOT NULL,
id_cliente_ativ int,
status_ativ varchar(15) NOT NULL,
observacao_ativ text,
FOREIGN KEY (id_cliente_ativ) REFERENCES clientes(id_cliente)
);


CREATE TABLE clientes (
id_cliente int PRIMARY KEY AUTO_INCREMENT NOT NULL,
nome_cliente varchar(30) NOT NULL,
email_cliente varchar(50) NOT NULL,
documento_cliente varchar(15),
id_cel_cliente int DEFAULT '-1',
id_notebook_cliente int DEFAULT '-1',
status_cliente int DEFAULT 1,
observacao_cliente text,
FOREIGN KEY (id_cel_cliente) REFERENCES ativos(id_ativ),
FOREIGN KEY (id_notebook_cliente) REFERENCES ativos(id_ativ)
);

INSERT INTO usuarios values(NULL, "Victor", "victor@gmail.com", "123senha", "1");
select * from usuarios;

INSERT INTO clientes (nome_cliente, email_cliente) VALUES ("Cliente 1", "cliente1@gmail.com"), 
															("Cliente 2", "cliente2@gmail.com"),
															("Cliente 3", "cliente3@gmail.com"), 
                                                            ("Cliente 4", "cliente4@gmail.com"),
                                                            ("Cliente 5", "cliente5@gmail.com");
SELECT * FROM clientes;

INSERT INTO ativos (nome_ativ, serial_ativ, marca_ativ, modelo_ativ, categoria_ativ, status_ativ) VALUES ("Notebook 1", "000000111111", "Lenovo", "Thinkpad", "Notebook", "Em uso"),
																											("Notebook 2", "111111222222", "HP", "Ultrabook", "Notebook", "Em uso"),
                                                                                                            ("Notebook 3", "222222333333", "Lenovo", "Thinkpad", "Notebook", "Em estoque"),
                                                                                                            ("Celular 1", "333333444444", "Samsung", "A10", "Celular", "Em uso"),
                                                                                                            ("Celular 2", "444444555555", "Xiaomi", "Redminote 11", "Celular", "Em estoque");
                                                                                                            
SELECT * FROM ativos;			

CREATE USER 'gerente'@'localhost'IDENTIFIED BY '123senha';
GRANT ALL PRIVILEGES ON ativtracker . * TO 'gerente'@'localhost';		



CREATE VIEW celulares_em_estoque AS 
SELECT * FROM ativos WHERE categoria_ativ = 'Celular' AND status_ativ = 'Em estoque';
#
SELECT * FROM celulares_em_estoque;


																			
CREATE VIEW celulares_em_uso AS
SELECT ativos.id_ativ, ativos.nome_ativ, ativos.serial_ativ, ativos.marca_ativ, ativos.modelo_ativ, clientes.nome_cliente FROM ativos
INNER JOIN clientes ON ativos.id_cliente_ativ = clientes.id_cliente
WHERE ativos.categoria_ativ = 'Celular' AND ativos.status_ativ = 'Em uso';
#
SELECT * FROM celulares_em_uso;
												
                                                
                                                
CREATE VIEW notebooks_em_estoque AS
SELECT * FROM ativos WHERE categoria_ativ = 'Notebook' AND status_ativ = 'Em estoque';
#
SELECT * FROM notebooks_em_estoque;

CREATE VIEW notebooks_em_uso AS
SELECT ativos.id_ativ, ativos.nome_ativ, ativos.serial_ativ, ativos.marca_ativ, ativos.modelo_ativ, clientes.nome_cliente FROM ativos
INNER JOIN clientes ON ativos.id_cliente_ativ = clientes.id_cliente
WHERE ativos.categoria_ativ = 'Notebook' AND ativos.status_ativ = 'Em uso';
#
SELECT * FROM notebooks_em_uso;



                                                