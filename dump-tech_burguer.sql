CREATE DATABASE  IF NOT EXISTS `techburger_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `techburger_db`;
-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: techburger_db
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `tb_bairro`
--

DROP TABLE IF EXISTS `tb_bairro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_bairro` (
  `id_bairro` int NOT NULL AUTO_INCREMENT,
  `nome_bairro` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_bairro`),
  UNIQUE KEY `nome_bairro` (`nome_bairro`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_bairro`
--

LOCK TABLES `tb_bairro` WRITE;
/*!40000 ALTER TABLE `tb_bairro` DISABLE KEYS */;
INSERT INTO `tb_bairro` VALUES (3,'Bela Vista'),(1,'Centro'),(4,'Cerqueira César'),(2,'Jardim das Rosas');
/*!40000 ALTER TABLE `tb_bairro` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_categoria_produto`
--

DROP TABLE IF EXISTS `tb_categoria_produto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_categoria_produto` (
  `id_categoria` int NOT NULL AUTO_INCREMENT,
  `nome_categoria` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_categoria`),
  UNIQUE KEY `nome_categoria` (`nome_categoria`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_categoria_produto`
--

LOCK TABLES `tb_categoria_produto` WRITE;
/*!40000 ALTER TABLE `tb_categoria_produto` DISABLE KEYS */;
INSERT INTO `tb_categoria_produto` VALUES (4,'Acompanhamento'),(2,'Bebida'),(1,'Hambúrguer'),(3,'Sobremesa');
/*!40000 ALTER TABLE `tb_categoria_produto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_cliente`
--

DROP TABLE IF EXISTS `tb_cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_cliente` (
  `id_cliente` int NOT NULL AUTO_INCREMENT,
  `nome_cliente` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cpf_cliente` char(11) COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefone_cliente` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `logradouro` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `numero` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `complemento` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cep` char(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_bairro` int NOT NULL,
  PRIMARY KEY (`id_cliente`),
  UNIQUE KEY `uq_cliente_cpf` (`cpf_cliente`),
  KEY `idx_cliente_bairro` (`id_bairro`),
  CONSTRAINT `fk_cliente_bairro` FOREIGN KEY (`id_bairro`) REFERENCES `tb_bairro` (`id_bairro`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_cliente`
--

LOCK TABLES `tb_cliente` WRITE;
/*!40000 ALTER TABLE `tb_cliente` DISABLE KEYS */;
INSERT INTO `tb_cliente` VALUES (1,'João da Silva','11122233344','(11) 98888-1111','Rua das Flores','123',NULL,'00000000',1),(2,'Maria Oliveira','22233344455','(11) 97777-2222','Avenida Paulista','1000','Apto 42','00000000',1),(3,'Ana Souza','33344455566','(11) 96666-3333','Rua Bela Vista','45',NULL,'00000000',2),(4,'Lucas Mendes','00000000000','(11) 95555-4444','Rua Central','88',NULL,'00000000',1),(5,'Fernanda Lima','44455566677','(11) 94444-5555','Rua Pedroso','90',NULL,'00000000',3),(6,'Paulo Santos','55566677788','(11) 93333-2222','Alameda Santos','500',NULL,'00000000',4);
/*!40000 ALTER TABLE `tb_cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_entregador`
--

DROP TABLE IF EXISTS `tb_entregador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_entregador` (
  `id_entregador` int NOT NULL AUTO_INCREMENT,
  `nome_entregador` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefone_entregador` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_entregador`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_entregador`
--

LOCK TABLES `tb_entregador` WRITE;
/*!40000 ALTER TABLE `tb_entregador` DISABLE KEYS */;
INSERT INTO `tb_entregador` VALUES (1,'Roberto Silva',NULL),(2,'Carlos Moto',NULL);
/*!40000 ALTER TABLE `tb_entregador` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_forma_pagamento`
--

DROP TABLE IF EXISTS `tb_forma_pagamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_forma_pagamento` (
  `id_forma_pagamento` int NOT NULL AUTO_INCREMENT,
  `descricao` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_forma_pagamento`),
  UNIQUE KEY `descricao` (`descricao`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_forma_pagamento`
--

LOCK TABLES `tb_forma_pagamento` WRITE;
/*!40000 ALTER TABLE `tb_forma_pagamento` DISABLE KEYS */;
INSERT INTO `tb_forma_pagamento` VALUES (2,'Cartão de Crédito'),(4,'Cartão de Débito'),(3,'Dinheiro'),(1,'PIX');
/*!40000 ALTER TABLE `tb_forma_pagamento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_historico_status`
--

DROP TABLE IF EXISTS `tb_historico_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_historico_status` (
  `id_historico` int NOT NULL AUTO_INCREMENT,
  `id_pedido` int NOT NULL,
  `status` enum('RECEBIDO','EM_PREPARO','SAIU_ENTREGA','ENTREGUE','CANCELADO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `data_hora_mudanca` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_historico`),
  KEY `idx_historico_pedido` (`id_pedido`),
  CONSTRAINT `fk_historico_pedido` FOREIGN KEY (`id_pedido`) REFERENCES `tb_pedido` (`id_pedido`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_historico_status`
--

LOCK TABLES `tb_historico_status` WRITE;
/*!40000 ALTER TABLE `tb_historico_status` DISABLE KEYS */;
INSERT INTO `tb_historico_status` VALUES (1,1,'ENTREGUE','2026-08-01 19:10:00'),(2,2,'ENTREGUE','2026-08-01 19:25:00'),(3,3,'ENTREGUE','2026-08-01 19:40:00'),(4,4,'ENTREGUE','2026-08-01 20:00:00'),(5,5,'CANCELADO','2026-08-01 20:15:00'),(6,6,'ENTREGUE','2026-08-01 20:30:00'),(7,7,'SAIU_ENTREGA','2026-08-01 20:45:00'),(8,8,'ENTREGUE','2026-08-01 21:00:00'),(9,9,'ENTREGUE','2026-08-01 21:20:00'),(10,10,'ENTREGUE','2026-08-01 21:35:00');
/*!40000 ALTER TABLE `tb_historico_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_item_pedido`
--

DROP TABLE IF EXISTS `tb_item_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_item_pedido` (
  `id_item_pedido` int NOT NULL AUTO_INCREMENT,
  `id_pedido` int NOT NULL,
  `id_produto` int NOT NULL,
  `quantidade` int NOT NULL,
  `preco_historico` decimal(8,2) NOT NULL,
  PRIMARY KEY (`id_item_pedido`),
  KEY `idx_item_pedido` (`id_pedido`),
  KEY `idx_item_produto` (`id_produto`),
  CONSTRAINT `fk_item_pedido` FOREIGN KEY (`id_pedido`) REFERENCES `tb_pedido` (`id_pedido`),
  CONSTRAINT `fk_item_produto` FOREIGN KEY (`id_produto`) REFERENCES `tb_produto` (`id_produto`),
  CONSTRAINT `chk_item_preco` CHECK ((`preco_historico` >= 0)),
  CONSTRAINT `chk_item_qtd` CHECK ((`quantidade` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_item_pedido`
--

LOCK TABLES `tb_item_pedido` WRITE;
/*!40000 ALTER TABLE `tb_item_pedido` DISABLE KEYS */;
INSERT INTO `tb_item_pedido` VALUES (1,1,1,2,25.00),(2,1,7,2,6.00),(3,2,2,1,32.00),(4,2,9,1,6.00),(5,3,13,1,14.00),(6,4,3,1,38.00),(7,4,10,1,8.00),(8,5,4,2,28.00),(9,5,11,2,4.00),(10,6,1,3,25.00),(11,6,8,3,6.00),(12,7,5,1,45.00),(13,7,13,1,14.00),(14,8,6,1,27.00),(15,9,1,1,25.00),(16,9,12,2,12.00),(17,10,14,2,18.00);
/*!40000 ALTER TABLE `tb_item_pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_pedido`
--

DROP TABLE IF EXISTS `tb_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_pedido` (
  `id_pedido` int NOT NULL AUTO_INCREMENT,
  `data_hora_pedido` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_cliente` int NOT NULL,
  `id_entregador` int DEFAULT NULL,
  `id_forma_pagamento` int NOT NULL,
  `observacoes_pedido` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `valor_total_calculado` decimal(8,2) NOT NULL DEFAULT '0.00',
  `valor_pago` decimal(8,2) DEFAULT NULL,
  `status_pedido` enum('RECEBIDO','EM_PREPARO','SAIU_ENTREGA','ENTREGUE','CANCELADO') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'RECEBIDO',
  PRIMARY KEY (`id_pedido`),
  KEY `idx_pedido_cliente` (`id_cliente`),
  KEY `idx_pedido_entregador` (`id_entregador`),
  KEY `idx_pedido_forma_pagamento` (`id_forma_pagamento`),
  CONSTRAINT `fk_pedido_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `tb_cliente` (`id_cliente`),
  CONSTRAINT `fk_pedido_entregador` FOREIGN KEY (`id_entregador`) REFERENCES `tb_entregador` (`id_entregador`),
  CONSTRAINT `fk_pedido_forma_pagamento` FOREIGN KEY (`id_forma_pagamento`) REFERENCES `tb_forma_pagamento` (`id_forma_pagamento`),
  CONSTRAINT `chk_pedido_valor` CHECK ((`valor_total_calculado` >= 0)),
  CONSTRAINT `chk_pedido_valor_pago` CHECK (((`valor_pago` is null) or (`valor_pago` >= 0)))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_pedido`
--

LOCK TABLES `tb_pedido` WRITE;
/*!40000 ALTER TABLE `tb_pedido` DISABLE KEYS */;
INSERT INTO `tb_pedido` VALUES (1,'2026-08-01 19:10:00',1,1,2,'Sem cebola',62.00,NULL,'ENTREGUE'),(2,'2026-08-01 19:25:00',2,1,1,'Bem passado',38.00,NULL,'ENTREGUE'),(3,'2026-08-01 19:40:00',1,2,3,'Maio extra',14.00,NULL,'ENTREGUE'),(4,'2026-08-01 20:00:00',3,1,1,'Capricha no molho',46.00,NULL,'ENTREGUE'),(5,'2026-08-01 20:15:00',4,NULL,2,NULL,64.00,NULL,'CANCELADO'),(6,'2026-08-01 20:30:00',2,2,4,'Molho à parte',93.00,NULL,'ENTREGUE'),(7,'2026-08-01 20:45:00',5,1,1,'Extra queijo',59.00,NULL,'SAIU_ENTREGA'),(8,'2026-08-01 21:00:00',1,2,3,NULL,27.00,NULL,'ENTREGUE'),(9,'2026-08-01 21:20:00',6,1,2,'Gelada',49.00,NULL,'ENTREGUE'),(10,'2026-08-01 21:35:00',3,2,1,'Copo bolha',36.00,NULL,'ENTREGUE');
/*!40000 ALTER TABLE `tb_pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_produto`
--

DROP TABLE IF EXISTS `tb_produto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_produto` (
  `id_produto` int NOT NULL AUTO_INCREMENT,
  `nome_produto` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_categoria` int NOT NULL,
  `preco_atual` decimal(8,2) NOT NULL,
  PRIMARY KEY (`id_produto`),
  KEY `idx_produto_categoria` (`id_categoria`),
  CONSTRAINT `fk_produto_categoria` FOREIGN KEY (`id_categoria`) REFERENCES `tb_categoria_produto` (`id_categoria`),
  CONSTRAINT `chk_produto_preco` CHECK ((`preco_atual` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_produto`
--

LOCK TABLES `tb_produto` WRITE;
/*!40000 ALTER TABLE `tb_produto` DISABLE KEYS */;
INSERT INTO `tb_produto` VALUES (1,'Tech Smash',1,25.00),(2,'Tech Bacon',1,32.00),(3,'Double Tech Cheese',1,38.00),(4,'Tech Veggie',1,28.00),(5,'Tech Monster',1,45.00),(6,'Tech Chicken',1,27.00),(7,'Coca-Cola Zero',2,6.00),(8,'Coca-Cola',2,6.00),(9,'Guaraná',2,6.00),(10,'Suco de Laranja',2,8.00),(11,'Água Mineral',2,4.00),(12,'Cerveja IPA',2,12.00),(13,'Batata Frita',4,14.00),(14,'Milkshake Chocolate',3,18.00);
/*!40000 ALTER TABLE `tb_produto` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-18 13:43:58
