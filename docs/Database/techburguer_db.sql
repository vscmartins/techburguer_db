-- =========================================================================================
-- TechBurger - Banco de dados normalizado (MySQL 8.0.16 ou superior, por causa do CHECK)
-- =========================================================================================

DROP DATABASE IF EXISTS techburger_db;

CREATE DATABASE techburger_db
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE techburger_db;

-- ------------------------------------------------
-- Bairros (evita repetição do bairro no cliente - 3FN)
CREATE TABLE tb_bairro (
                           id_bairro   INT AUTO_INCREMENT PRIMARY KEY,
                           nome_bairro VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Categorias de produto (categoria depende do produto, não do pedido - 3FN)
CREATE TABLE tb_categoria_produto (
                                      id_categoria   INT AUTO_INCREMENT PRIMARY KEY,
                                      nome_categoria VARCHAR(60) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Formas de pagamento
CREATE TABLE tb_forma_pagamento (
                                    id_forma_pagamento INT AUTO_INCREMENT PRIMARY KEY,
                                    descricao          VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE tb_cliente (
                            id_cliente       INT AUTO_INCREMENT PRIMARY KEY,
                            nome_cliente     VARCHAR(150) NOT NULL,
                            cpf_cliente      CHAR(11) NOT NULL,
                            telefone_cliente VARCHAR(20) NOT NULL,
                            logradouro       VARCHAR(150) NOT NULL,
                            numero           VARCHAR(10)  NOT NULL,
                            complemento      VARCHAR(60),
                            cep              CHAR(8) NOT NULL,
                            id_bairro        INT NOT NULL,
                            CONSTRAINT uq_cliente_cpf UNIQUE (cpf_cliente),
                            CONSTRAINT fk_cliente_bairro
                                FOREIGN KEY (id_bairro) REFERENCES tb_bairro(id_bairro)
) ENGINE=InnoDB;


CREATE TABLE tb_produto (
                            id_produto   INT AUTO_INCREMENT PRIMARY KEY,
                            nome_produto VARCHAR(120) NOT NULL,
                            id_categoria INT NOT NULL,
                            preco_atual  DECIMAL(8,2) NOT NULL,
                            CONSTRAINT chk_produto_preco CHECK (preco_atual >= 0),
                            CONSTRAINT fk_produto_categoria
                                FOREIGN KEY (id_categoria) REFERENCES tb_categoria_produto(id_categoria)
) ENGINE=InnoDB;


CREATE TABLE tb_entregador (
                               id_entregador       INT AUTO_INCREMENT PRIMARY KEY,
                               nome_entregador     VARCHAR(120) NOT NULL,
                               telefone_entregador VARCHAR(20)
) ENGINE=InnoDB;

CREATE TABLE tb_pedido (
                           id_pedido             INT AUTO_INCREMENT PRIMARY KEY,
                           data_hora_pedido      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                           id_cliente            INT NOT NULL,
                           id_entregador         INT,
                           id_forma_pagamento    INT NOT NULL,
                           observacoes_pedido    VARCHAR(255),
                           valor_total_calculado DECIMAL(8,2) NOT NULL DEFAULT 0.00,
                           valor_pago            DECIMAL(8,2) NULL,  -- quanto o cliente entregou (base do troco)
                           status_pedido         ENUM('RECEBIDO','EM_PREPARO','SAIU_ENTREGA','ENTREGUE','CANCELADO')
                          NOT NULL DEFAULT 'RECEBIDO',
                           CONSTRAINT chk_pedido_valor CHECK (valor_total_calculado >= 0),
                           CONSTRAINT chk_pedido_valor_pago CHECK (valor_pago IS NULL OR valor_pago >= 0),
                           CONSTRAINT fk_pedido_cliente
                               FOREIGN KEY (id_cliente) REFERENCES tb_cliente(id_cliente),
                           CONSTRAINT fk_pedido_entregador
                               FOREIGN KEY (id_entregador) REFERENCES tb_entregador(id_entregador),
                           CONSTRAINT fk_pedido_forma_pagamento
                               FOREIGN KEY (id_forma_pagamento) REFERENCES tb_forma_pagamento(id_forma_pagamento)
) ENGINE=InnoDB;

CREATE TABLE tb_item_pedido (
                                id_item_pedido  INT AUTO_INCREMENT PRIMARY KEY,
                                id_pedido       INT NOT NULL,
                                id_produto      INT NOT NULL,
                                quantidade      INT NOT NULL,
                                preco_historico DECIMAL(8,2) NOT NULL,
                                CONSTRAINT chk_item_qtd CHECK (quantidade > 0),
                                CONSTRAINT chk_item_preco CHECK (preco_historico >= 0),
                                CONSTRAINT fk_item_pedido
                                    FOREIGN KEY (id_pedido) REFERENCES tb_pedido(id_pedido),
                                CONSTRAINT fk_item_produto
                                    FOREIGN KEY (id_produto) REFERENCES tb_produto(id_produto)
) ENGINE=InnoDB;


CREATE TABLE tb_historico_status (
                                     id_historico      INT AUTO_INCREMENT PRIMARY KEY,
                                     id_pedido         INT NOT NULL,
                                     status            ENUM('RECEBIDO','EM_PREPARO','SAIU_ENTREGA','ENTREGUE','CANCELADO') NOT NULL,
                                     data_hora_mudanca DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                     CONSTRAINT fk_historico_pedido
                                         FOREIGN KEY (id_pedido) REFERENCES tb_pedido(id_pedido)
) ENGINE=InnoDB;

CREATE INDEX idx_cliente_bairro ON tb_cliente(id_bairro);
CREATE INDEX idx_produto_categoria ON tb_produto(id_categoria);
CREATE INDEX idx_pedido_cliente ON tb_pedido(id_cliente);
CREATE INDEX idx_pedido_entregador ON tb_pedido(id_entregador);
CREATE INDEX idx_pedido_forma_pagamento ON tb_pedido(id_forma_pagamento);
CREATE INDEX idx_item_pedido ON tb_item_pedido(id_pedido);
CREATE INDEX idx_item_produto ON tb_item_pedido(id_produto);
CREATE INDEX idx_historico_pedido ON tb_historico_status(id_pedido);

-- -----------------------------------------------------------------------------------------
-- insert

USE techburger_db;

INSERT IGNORE INTO tb_bairro (nome_bairro) VALUES
    ('Centro'),
    ('Jardim das Rosas'),
    ('Bela Vista'),
    ('Cerqueira César');

INSERT IGNORE INTO tb_categoria_produto (nome_categoria) VALUES
    ('Hambúrguer'),
    ('Bebida'),
    ('Sobremesa'),
    ('Acompanhamento');


INSERT IGNORE INTO tb_forma_pagamento (descricao) VALUES
    ('PIX'),
    ('Cartão de Crédito'),
    ('Dinheiro'),
    ('Cartão de Débito');

INSERT INTO tb_cliente
(nome_cliente, cpf_cliente, telefone_cliente, logradouro, numero, complemento, cep, id_bairro)
VALUES
    ('João da Silva', '11122233344', '(11) 98888-1111', 'Rua das Flores', '123', NULL, '00000000',
     (SELECT id_bairro FROM tb_bairro WHERE nome_bairro = 'Centro')),
    ('Maria Oliveira', '22233344455', '(11) 97777-2222', 'Avenida Paulista', '1000', 'Apto 42', '00000000',
     (SELECT id_bairro FROM tb_bairro WHERE nome_bairro = 'Centro')),
    ('Ana Souza', '33344455566', '(11) 96666-3333', 'Rua Bela Vista', '45', NULL, '00000000',
     (SELECT id_bairro FROM tb_bairro WHERE nome_bairro = 'Jardim das Rosas')),
    ('Lucas Mendes', '00000000000', '(11) 95555-4444', 'Rua Central', '88', NULL, '00000000',
     (SELECT id_bairro FROM tb_bairro WHERE nome_bairro = 'Centro')),
    ('Fernanda Lima', '44455566677', '(11) 94444-5555', 'Rua Pedroso', '90', NULL, '00000000',
     (SELECT id_bairro FROM tb_bairro WHERE nome_bairro = 'Bela Vista')),
    ('Paulo Santos', '55566677788', '(11) 93333-2222', 'Alameda Santos', '500', NULL, '00000000',
     (SELECT id_bairro FROM tb_bairro WHERE nome_bairro = 'Cerqueira César'));

INSERT INTO tb_entregador (nome_entregador, telefone_entregador) VALUES
                                                                     ('Roberto Silva', NULL),
                                                                     ('Carlos Moto', NULL);

INSERT INTO tb_produto (nome_produto, id_categoria, preco_atual) VALUES
                                                                     ('Tech Smash',          (SELECT id_categoria FROM tb_categoria_produto WHERE nome_categoria='Hambúrguer'), 25.00),
                                                                     ('Tech Bacon',          (SELECT id_categoria FROM tb_categoria_produto WHERE nome_categoria='Hambúrguer'), 32.00),
                                                                     ('Double Tech Cheese',  (SELECT id_categoria FROM tb_categoria_produto WHERE nome_categoria='Hambúrguer'), 38.00),
                                                                     ('Tech Veggie',         (SELECT id_categoria FROM tb_categoria_produto WHERE nome_categoria='Hambúrguer'), 28.00),
                                                                     ('Tech Monster',        (SELECT id_categoria FROM tb_categoria_produto WHERE nome_categoria='Hambúrguer'), 45.00),
                                                                     ('Tech Chicken',        (SELECT id_categoria FROM tb_categoria_produto WHERE nome_categoria='Hambúrguer'), 27.00),
                                                                     ('Coca-Cola Zero',      (SELECT id_categoria FROM tb_categoria_produto WHERE nome_categoria='Bebida'), 6.00),
                                                                     ('Coca-Cola',           (SELECT id_categoria FROM tb_categoria_produto WHERE nome_categoria='Bebida'), 6.00),
                                                                     ('Guaraná',             (SELECT id_categoria FROM tb_categoria_produto WHERE nome_categoria='Bebida'), 6.00),
                                                                     ('Suco de Laranja',     (SELECT id_categoria FROM tb_categoria_produto WHERE nome_categoria='Bebida'), 8.00),
                                                                     ('Água Mineral',        (SELECT id_categoria FROM tb_categoria_produto WHERE nome_categoria='Bebida'), 4.00),
                                                                     ('Cerveja IPA',         (SELECT id_categoria FROM tb_categoria_produto WHERE nome_categoria='Bebida'), 12.00),
                                                                     ('Batata Frita',        (SELECT id_categoria FROM tb_categoria_produto WHERE nome_categoria='Acompanhamento'), 14.00),
                                                                     ('Milkshake Chocolate', (SELECT id_categoria FROM tb_categoria_produto WHERE nome_categoria='Sobremesa'), 18.00);

-- Pedido 1 - João da Silva
INSERT INTO tb_pedido (data_hora_pedido, id_cliente, id_entregador, id_forma_pagamento, observacoes_pedido, valor_total_calculado, status_pedido)
VALUES ('2026-08-01 19:10:00',
        (SELECT id_cliente FROM tb_cliente WHERE cpf_cliente='11122233344'),
        (SELECT id_entregador FROM tb_entregador WHERE nome_entregador='Roberto Silva'),
        (SELECT id_forma_pagamento FROM tb_forma_pagamento WHERE descricao='Cartão de Crédito'),
        'Sem cebola', 62.00, 'ENTREGUE');
SET @p1 = LAST_INSERT_ID();
INSERT INTO tb_item_pedido (id_pedido, id_produto, quantidade, preco_historico) VALUES
                                                                                    (@p1, (SELECT id_produto FROM tb_produto WHERE nome_produto='Tech Smash'), 2, 25.00),
                                                                                    (@p1, (SELECT id_produto FROM tb_produto WHERE nome_produto='Coca-Cola Zero'), 2, 6.00);
INSERT INTO tb_historico_status (id_pedido, status, data_hora_mudanca) VALUES (@p1, 'ENTREGUE', '2026-08-01 19:10:00');

-- Pedido 2 - Maria Oliveira
INSERT INTO tb_pedido (data_hora_pedido, id_cliente, id_entregador, id_forma_pagamento, observacoes_pedido, valor_total_calculado, status_pedido)
VALUES ('2026-08-01 19:25:00',
        (SELECT id_cliente FROM tb_cliente WHERE cpf_cliente='22233344455'),
        (SELECT id_entregador FROM tb_entregador WHERE nome_entregador='Roberto Silva'),
        (SELECT id_forma_pagamento FROM tb_forma_pagamento WHERE descricao='PIX'),
        'Bem passado', 38.00, 'ENTREGUE');
SET @p2 = LAST_INSERT_ID();
INSERT INTO tb_item_pedido (id_pedido, id_produto, quantidade, preco_historico) VALUES
                                                                                    (@p2, (SELECT id_produto FROM tb_produto WHERE nome_produto='Tech Bacon'), 1, 32.00),
                                                                                    (@p2, (SELECT id_produto FROM tb_produto WHERE nome_produto='Guaraná'), 1, 6.00);
INSERT INTO tb_historico_status (id_pedido, status, data_hora_mudanca) VALUES (@p2, 'ENTREGUE', '2026-08-01 19:25:00');

-- Pedido 3 - João da Silva (mesmo CPF do pedido 1)
INSERT INTO tb_pedido (data_hora_pedido, id_cliente, id_entregador, id_forma_pagamento, observacoes_pedido, valor_total_calculado, status_pedido)
VALUES ('2026-08-01 19:40:00',
        (SELECT id_cliente FROM tb_cliente WHERE cpf_cliente='11122233344'),
        (SELECT id_entregador FROM tb_entregador WHERE nome_entregador='Carlos Moto'),
        (SELECT id_forma_pagamento FROM tb_forma_pagamento WHERE descricao='Dinheiro'),
        'Maio extra', 14.00, 'ENTREGUE');
SET @p3 = LAST_INSERT_ID();
INSERT INTO tb_item_pedido (id_pedido, id_produto, quantidade, preco_historico) VALUES
    (@p3, (SELECT id_produto FROM tb_produto WHERE nome_produto='Batata Frita'), 1, 14.00);
INSERT INTO tb_historico_status (id_pedido, status, data_hora_mudanca) VALUES (@p3, 'ENTREGUE', '2026-08-01 19:40:00');

-- Pedido 4 - Ana Souza
INSERT INTO tb_pedido (data_hora_pedido, id_cliente, id_entregador, id_forma_pagamento, observacoes_pedido, valor_total_calculado, status_pedido)
VALUES ('2026-08-01 20:00:00',
        (SELECT id_cliente FROM tb_cliente WHERE cpf_cliente='33344455566'),
        (SELECT id_entregador FROM tb_entregador WHERE nome_entregador='Roberto Silva'),
        (SELECT id_forma_pagamento FROM tb_forma_pagamento WHERE descricao='PIX'),
        'Capricha no molho', 46.00, 'ENTREGUE');
SET @p4 = LAST_INSERT_ID();
INSERT INTO tb_item_pedido (id_pedido, id_produto, quantidade, preco_historico) VALUES
                                                                                    (@p4, (SELECT id_produto FROM tb_produto WHERE nome_produto='Double Tech Cheese'), 1, 38.00),
                                                                                    (@p4, (SELECT id_produto FROM tb_produto WHERE nome_produto='Suco de Laranja'), 1, 8.00);
INSERT INTO tb_historico_status (id_pedido, status, data_hora_mudanca) VALUES (@p4, 'ENTREGUE', '2026-08-01 20:00:00');

-- Pedido 5 - Lucas Mendes (CPF sentinela, pendente de correção) - CANCELADO
INSERT INTO tb_pedido (data_hora_pedido, id_cliente, id_entregador, id_forma_pagamento, observacoes_pedido, valor_total_calculado, status_pedido)
VALUES ('2026-08-01 20:15:00',
        (SELECT id_cliente FROM tb_cliente WHERE cpf_cliente='00000000000'),
        NULL,
        (SELECT id_forma_pagamento FROM tb_forma_pagamento WHERE descricao='Cartão de Crédito'),
        NULL, 64.00, 'CANCELADO');
SET @p5 = LAST_INSERT_ID();
INSERT INTO tb_item_pedido (id_pedido, id_produto, quantidade, preco_historico) VALUES
                                                                                    (@p5, (SELECT id_produto FROM tb_produto WHERE nome_produto='Tech Veggie'), 2, 28.00),
                                                                                    (@p5, (SELECT id_produto FROM tb_produto WHERE nome_produto='Água Mineral'), 2, 4.00);
INSERT INTO tb_historico_status (id_pedido, status, data_hora_mudanca) VALUES (@p5, 'CANCELADO', '2026-08-01 20:15:00');

-- Pedido 6 - Maria Oliveira (mesmo CPF do pedido 2)
INSERT INTO tb_pedido (data_hora_pedido, id_cliente, id_entregador, id_forma_pagamento, observacoes_pedido, valor_total_calculado, status_pedido)
VALUES ('2026-08-01 20:30:00',
        (SELECT id_cliente FROM tb_cliente WHERE cpf_cliente='22233344455'),
        (SELECT id_entregador FROM tb_entregador WHERE nome_entregador='Carlos Moto'),
        (SELECT id_forma_pagamento FROM tb_forma_pagamento WHERE descricao='Cartão de Débito'),
        'Molho à parte', 93.00, 'ENTREGUE');
SET @p6 = LAST_INSERT_ID();
INSERT INTO tb_item_pedido (id_pedido, id_produto, quantidade, preco_historico) VALUES
                                                                                    (@p6, (SELECT id_produto FROM tb_produto WHERE nome_produto='Tech Smash'), 3, 25.00),
                                                                                    (@p6, (SELECT id_produto FROM tb_produto WHERE nome_produto='Coca-Cola'), 3, 6.00);
INSERT INTO tb_historico_status (id_pedido, status, data_hora_mudanca) VALUES (@p6, 'ENTREGUE', '2026-08-01 20:30:00');

-- Pedido 7 - Fernanda Lima - Em Rota
INSERT INTO tb_pedido (data_hora_pedido, id_cliente, id_entregador, id_forma_pagamento, observacoes_pedido, valor_total_calculado, status_pedido)
VALUES ('2026-08-01 20:45:00',
        (SELECT id_cliente FROM tb_cliente WHERE cpf_cliente='44455566677'),
        (SELECT id_entregador FROM tb_entregador WHERE nome_entregador='Roberto Silva'),
        (SELECT id_forma_pagamento FROM tb_forma_pagamento WHERE descricao='PIX'),
        'Extra queijo', 59.00, 'SAIU_ENTREGA');
SET @p7 = LAST_INSERT_ID();
INSERT INTO tb_item_pedido (id_pedido, id_produto, quantidade, preco_historico) VALUES
                                                                                    (@p7, (SELECT id_produto FROM tb_produto WHERE nome_produto='Tech Monster'), 1, 45.00),
                                                                                    (@p7, (SELECT id_produto FROM tb_produto WHERE nome_produto='Batata Frita'), 1, 14.00);
INSERT INTO tb_historico_status (id_pedido, status, data_hora_mudanca) VALUES (@p7, 'SAIU_ENTREGA', '2026-08-01 20:45:00');

-- Pedido 8 - João da Silva (mesmo CPF dos pedidos 1 e 3)
INSERT INTO tb_pedido (data_hora_pedido, id_cliente, id_entregador, id_forma_pagamento, observacoes_pedido, valor_total_calculado, status_pedido)
VALUES ('2026-08-01 21:00:00',
        (SELECT id_cliente FROM tb_cliente WHERE cpf_cliente='11122233344'),
        (SELECT id_entregador FROM tb_entregador WHERE nome_entregador='Carlos Moto'),
        (SELECT id_forma_pagamento FROM tb_forma_pagamento WHERE descricao='Dinheiro'),
        NULL, 27.00, 'ENTREGUE');
SET @p8 = LAST_INSERT_ID();
INSERT INTO tb_item_pedido (id_pedido, id_produto, quantidade, preco_historico) VALUES
    (@p8, (SELECT id_produto FROM tb_produto WHERE nome_produto='Tech Chicken'), 1, 27.00);
INSERT INTO tb_historico_status (id_pedido, status, data_hora_mudanca) VALUES (@p8, 'ENTREGUE', '2026-08-01 21:00:00');

-- Pedido 9 - Paulo Santos
INSERT INTO tb_pedido (data_hora_pedido, id_cliente, id_entregador, id_forma_pagamento, observacoes_pedido, valor_total_calculado, status_pedido)
VALUES ('2026-08-01 21:20:00',
        (SELECT id_cliente FROM tb_cliente WHERE cpf_cliente='55566677788'),
        (SELECT id_entregador FROM tb_entregador WHERE nome_entregador='Roberto Silva'),
        (SELECT id_forma_pagamento FROM tb_forma_pagamento WHERE descricao='Cartão de Crédito'),
        'Gelada', 49.00, 'ENTREGUE');
SET @p9 = LAST_INSERT_ID();
INSERT INTO tb_item_pedido (id_pedido, id_produto, quantidade, preco_historico) VALUES
                                                                                    (@p9, (SELECT id_produto FROM tb_produto WHERE nome_produto='Tech Smash'), 1, 25.00),
                                                                                    (@p9, (SELECT id_produto FROM tb_produto WHERE nome_produto='Cerveja IPA'), 2, 12.00);
INSERT INTO tb_historico_status (id_pedido, status, data_hora_mudanca) VALUES (@p9, 'ENTREGUE', '2026-08-01 21:20:00');

-- Pedido 10 - Ana Souza (mesmo CPF do pedido 4)
INSERT INTO tb_pedido (data_hora_pedido, id_cliente, id_entregador, id_forma_pagamento, observacoes_pedido, valor_total_calculado, status_pedido)
VALUES ('2026-08-01 21:35:00',
        (SELECT id_cliente FROM tb_cliente WHERE cpf_cliente='33344455566'),
        (SELECT id_entregador FROM tb_entregador WHERE nome_entregador='Carlos Moto'),
        (SELECT id_forma_pagamento FROM tb_forma_pagamento WHERE descricao='PIX'),
        'Copo bolha', 36.00, 'ENTREGUE');
SET @p10 = LAST_INSERT_ID();
INSERT INTO tb_item_pedido (id_pedido, id_produto, quantidade, preco_historico) VALUES
    (@p10, (SELECT id_produto FROM tb_produto WHERE nome_produto='Milkshake Chocolate'), 2, 18.00);
INSERT INTO tb_historico_status (id_pedido, status, data_hora_mudanca) VALUES (@p10, 'ENTREGUE', '2026-08-01 21:35:00');

-- -----------------------------------------------------------------------------------------
-- Visão geral de todos os pedidos (conferência após a carga)
USE techburger_db;

SELECT
    ped.id_pedido,
    ped.data_hora_pedido,
    ped.status_pedido,
    cli.nome_cliente,
    cli.cpf_cliente,
    cli.telefone_cliente,
    cli.logradouro,
    cli.numero,
    cli.complemento,
    cli.cep,
    b.nome_bairro,
    cat.nome_categoria,
    prod.nome_produto,
    ip.quantidade,
    ip.preco_historico,
    prod.preco_atual,
    (ip.quantidade * ip.preco_historico) AS subtotal_item,
    ent.nome_entregador,
    fp.descricao AS forma_pagamento,
    ped.observacoes_pedido,
    ped.valor_total_calculado,
    ped.valor_pago,
    hs.status AS status_historico,
    hs.data_hora_mudanca
FROM tb_pedido ped
         JOIN tb_cliente cli              ON cli.id_cliente = ped.id_cliente
         JOIN tb_bairro b                 ON b.id_bairro = cli.id_bairro
         JOIN tb_item_pedido ip           ON ip.id_pedido = ped.id_pedido
         JOIN tb_produto prod             ON prod.id_produto = ip.id_produto
         JOIN tb_categoria_produto cat    ON cat.id_categoria = prod.id_categoria
         JOIN tb_forma_pagamento fp       ON fp.id_forma_pagamento = ped.id_forma_pagamento
         LEFT JOIN tb_entregador ent      ON ent.id_entregador = ped.id_entregador
         LEFT JOIN tb_historico_status hs ON hs.id_pedido = ped.id_pedido
ORDER BY ped.id_pedido, ip.id_item_pedido;

-- -----------------------------------------------------------------------------------------
-- Conferência do conteúdo de cada tabela
SELECT * FROM tb_bairro;
SELECT * FROM tb_categoria_produto;
SELECT * FROM tb_forma_pagamento;
SELECT * FROM tb_cliente;
SELECT * FROM tb_produto;
SELECT * FROM tb_entregador;
SELECT * FROM tb_pedido;
SELECT * FROM tb_item_pedido;
SELECT * FROM tb_historico_status;

-- -----------------------------------------------------------------------------------------
-- Consultas

-- Consulta 1: Clientes do bairro "Centro"
SELECT c.nome_cliente, c.telefone_cliente, c.logradouro, c.numero
FROM tb_cliente c
         JOIN tb_bairro b ON b.id_bairro = c.id_bairro
WHERE b.nome_bairro = 'Centro';

-- Consulta 2: Faturamento por categoria de produto
SELECT cat.nome_categoria,
       SUM(ip.quantidade * ip.preco_historico) AS faturamento_total
FROM tb_item_pedido ip
         JOIN tb_produto p ON p.id_produto = ip.id_produto
         JOIN tb_categoria_produto cat ON cat.id_categoria = p.id_categoria
GROUP BY cat.nome_categoria
ORDER BY faturamento_total DESC;

-- Consulta 3: Extrato 360° do pedido (itens, entregador, pagamento e troco)
SELECT
    ped.id_pedido,
    ped.data_hora_pedido,
    cli.nome_cliente,
    prod.nome_produto,
    ip.quantidade,
    ip.preco_historico,
    (ip.quantidade * ip.preco_historico) AS subtotal_item,
    ent.nome_entregador,
    fp.descricao AS forma_pagamento,
    ped.valor_total_calculado,
    ped.valor_pago,
    CASE
        WHEN ped.valor_pago IS NULL THEN NULL
        ELSE GREATEST(ped.valor_pago - ped.valor_total_calculado, 0)
        END AS troco
FROM tb_pedido ped
         JOIN tb_cliente cli ON cli.id_cliente = ped.id_cliente
         JOIN tb_item_pedido ip ON ip.id_pedido = ped.id_pedido
         JOIN tb_produto prod ON prod.id_produto = ip.id_produto
         LEFT JOIN tb_entregador ent ON ent.id_entregador = ped.id_entregador
         JOIN tb_forma_pagamento fp ON fp.id_forma_pagamento = ped.id_forma_pagamento
WHERE ped.id_pedido = 1;

-- -----------------------------------------------------------------------------------------
-- Limpeza do banco no período de testes (NÃO EXECUTAR junto com o restante do script)
-- Para usar, remova os comentários (--) das linhas abaixo e execute apenas este bloco.
-- Atenção: apaga todos os dados das tabelas.

-- USE techburger_db;
-- SET FOREIGN_KEY_CHECKS = 0;
-- TRUNCATE TABLE tb_historico_status;
-- TRUNCATE TABLE tb_item_pedido;
-- TRUNCATE TABLE tb_pedido;
-- TRUNCATE TABLE tb_produto;
-- TRUNCATE TABLE tb_entregador;
-- TRUNCATE TABLE tb_cliente;
-- TRUNCATE TABLE tb_forma_pagamento;
-- TRUNCATE TABLE tb_categoria_produto;
-- TRUNCATE TABLE tb_bairro;
-- SET FOREIGN_KEY_CHECKS = 1;