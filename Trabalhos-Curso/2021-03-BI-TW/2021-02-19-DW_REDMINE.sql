-- MySQL dump 10.13  Distrib 8.0.22, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: dw_redmine
-- ------------------------------------------------------
-- Server version	5.7.31-log

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
-- Table structure for table `tb_dim_categoria`
--

DROP TABLE IF EXISTS `tb_dim_categoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_dim_categoria` (
  `id_categoria` int(11) NOT NULL AUTO_INCREMENT,
  `no_categoria` varchar(100) DEFAULT NULL,
  `no_subcategoria` varchar(100) NOT NULL,
  `nk_categoria` int(11) DEFAULT NULL,
  `nk_subcategoria` int(11) DEFAULT NULL,
  `tp_categoria` char(10) DEFAULT NULL,
  `tp_subcategoria` char(10) DEFAULT NULL,
  PRIMARY KEY (`id_categoria`)
) ENGINE=InnoDB AUTO_INCREMENT=10973 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_dim_categoria`
--

LOCK TABLES `tb_dim_categoria` WRITE;
/*!40000 ALTER TABLE `tb_dim_categoria` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_dim_categoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_dim_data`
--

DROP TABLE IF EXISTS `tb_dim_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_dim_data` (
  `id_data` varchar(10) NOT NULL,
  `nu_dia` int(11) DEFAULT NULL,
  `nu_mes` int(11) DEFAULT NULL,
  `nu_ano` int(11) DEFAULT NULL,
  `nu_semana` int(11) DEFAULT NULL,
  `nu_quarter` int(11) DEFAULT NULL,
  `nu_dia_semana` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_data`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_dim_data`
--

LOCK TABLES `tb_dim_data` WRITE;
/*!40000 ALTER TABLE `tb_dim_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_dim_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_dim_departamento_solicitante`
--

DROP TABLE IF EXISTS `tb_dim_departamento_solicitante`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_dim_departamento_solicitante` (
  `id_departamento_solicitante` int(11) NOT NULL AUTO_INCREMENT,
  `no_departamento_solicitante` varchar(100) DEFAULT NULL,
  `no_area_solicitante` varchar(100) DEFAULT NULL,
  `nk_departamento_solicitante` varchar(100) NOT NULL,
  PRIMARY KEY (`id_departamento_solicitante`)
) ENGINE=InnoDB AUTO_INCREMENT=9140 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_dim_departamento_solicitante`
--

LOCK TABLES `tb_dim_departamento_solicitante` WRITE;
/*!40000 ALTER TABLE `tb_dim_departamento_solicitante` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_dim_departamento_solicitante` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_dim_dias_estagio`
--

DROP TABLE IF EXISTS `tb_dim_dias_estagio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_dim_dias_estagio` (
  `nu_dias_estagio` int(11) NOT NULL,
  PRIMARY KEY (`nu_dias_estagio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_dim_dias_estagio`
--

LOCK TABLES `tb_dim_dias_estagio` WRITE;
/*!40000 ALTER TABLE `tb_dim_dias_estagio` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_dim_dias_estagio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_dim_prioridade`
--

DROP TABLE IF EXISTS `tb_dim_prioridade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_dim_prioridade` (
  `id_prioridade` int(11) NOT NULL AUTO_INCREMENT,
  `no_prioridade` varchar(20) NOT NULL,
  `nk_priority_id` int(11) NOT NULL,
  PRIMARY KEY (`id_prioridade`)
) ENGINE=InnoDB AUTO_INCREMENT=337 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_dim_prioridade`
--

LOCK TABLES `tb_dim_prioridade` WRITE;
/*!40000 ALTER TABLE `tb_dim_prioridade` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_dim_prioridade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_dim_projeto`
--

DROP TABLE IF EXISTS `tb_dim_projeto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_dim_projeto` (
  `id_projeto` int(11) NOT NULL AUTO_INCREMENT,
  `no_gerencia_projeto` varchar(20) NOT NULL,
  `no_departamento_projeto` varchar(20) DEFAULT NULL,
  `no_area_projeto` varchar(20) NOT NULL,
  `nk_projeto` int(11) NOT NULL,
  PRIMARY KEY (`id_projeto`)
) ENGINE=InnoDB AUTO_INCREMENT=235 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_dim_projeto`
--

LOCK TABLES `tb_dim_projeto` WRITE;
/*!40000 ALTER TABLE `tb_dim_projeto` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_dim_projeto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_dim_situacao`
--

DROP TABLE IF EXISTS `tb_dim_situacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_dim_situacao` (
  `id_situacao` int(11) NOT NULL AUTO_INCREMENT,
  `no_situacao` varchar(50) NOT NULL,
  `nk_situacao` int(11) NOT NULL,
  PRIMARY KEY (`id_situacao`)
) ENGINE=InnoDB AUTO_INCREMENT=463 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_dim_situacao`
--

LOCK TABLES `tb_dim_situacao` WRITE;
/*!40000 ALTER TABLE `tb_dim_situacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_dim_situacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_dim_tipo_tarefa`
--

DROP TABLE IF EXISTS `tb_dim_tipo_tarefa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_dim_tipo_tarefa` (
  `id_tipo_tarefa` int(11) NOT NULL AUTO_INCREMENT,
  `no_tipo_tarefa` varchar(100) NOT NULL,
  `nk_tipo_tarefa` int(11) NOT NULL,
  PRIMARY KEY (`id_tipo_tarefa`)
) ENGINE=InnoDB AUTO_INCREMENT=452 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_dim_tipo_tarefa`
--

LOCK TABLES `tb_dim_tipo_tarefa` WRITE;
/*!40000 ALTER TABLE `tb_dim_tipo_tarefa` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_dim_tipo_tarefa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_fato`
--

DROP TABLE IF EXISTS `tb_fato`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_fato` (
  `id_fato` int(11) NOT NULL AUTO_INCREMENT,
  `nk_issue_id` int(11) DEFAULT NULL,
  `id_departamento_solicitante` int(11) DEFAULT NULL,
  `id_prioridade` int(11) DEFAULT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  `id_situacao` int(11) DEFAULT NULL,
  `id_tipo_tarefa` int(11) DEFAULT NULL,
  `id_projeto` int(11) DEFAULT NULL,
  `id_data_solicitacao` varchar(10) DEFAULT NULL,
  `id_data_conclusao` varchar(10) DEFAULT NULL,
  `id_data_conclusao_solicitada` varchar(10) DEFAULT NULL,
  `nu_total_tempo` int(11) DEFAULT NULL,
  `nu_tempo_analise` int(11) DEFAULT NULL,
  `nu_tempo_execucao` int(11) DEFAULT NULL,
  `nu_tempo_revisao` int(11) DEFAULT NULL,
  `nu_tempo_especificacao` int(11) DEFAULT NULL,
  `nu_tempo_gestao` int(11) DEFAULT NULL,
  `nu_tempo_reuniao` int(11) DEFAULT NULL,
  `nu_tempo_capacitacao` int(11) DEFAULT NULL,
  `nu_dias_revisao` int(11) DEFAULT NULL,
  `nu_dias_andamento` int(11) DEFAULT NULL,
  `nu_dias_suspensa` int(11) DEFAULT NULL,
  `nu_dias_aguardando_revisao` int(11) DEFAULT NULL,
  `nu_dias_nova` int(11) DEFAULT NULL,
  `qtd_fato` int(11) DEFAULT NULL,
  `ind_desempenho` char(1) DEFAULT NULL,
  PRIMARY KEY (`id_fato`),
  UNIQUE KEY `tb_fato_idx` (`nk_issue_id`),
  KEY `dim_projeto_tb_fato_fk_idx` (`id_projeto`),
  KEY `dim_categoria_tb_fato_fk` (`id_categoria`),
  KEY `dim_departamento_solicitante_tb_fato_fk` (`id_departamento_solicitante`),
  KEY `dim_prioridade_tb_fato_fk` (`id_prioridade`),
  KEY `dim_situacao_tb_fato_fk` (`id_situacao`),
  KEY `dim_tipo_tarefa_tb_fato_fk` (`id_tipo_tarefa`),
  KEY `dim_tempo_tb_fato_dt_sol_idx` (`id_data_solicitacao`),
  KEY `dim_data_tb_fato_fk_data_conclusao_idx` (`id_data_conclusao`),
  KEY `dim_data_tb_fato_fk_data_conclusao_sol_idx` (`id_data_conclusao_solicitada`),
  KEY `dim_nu_dias_est_nova_tb_fato_fk_idx` (`nu_dias_nova`),
  KEY `dim_nu_dias_est_rev_tb_fato_fk_idx` (`nu_dias_revisao`),
  KEY `dim_nu_dias_est_andamento_tb_fato_fk_idx` (`nu_dias_andamento`),
  KEY `dim_nu_dias_est_susp_tb_fato_fk_idx` (`nu_dias_suspensa`),
  KEY `dim_nu_dias_est_agRev_tb_fato_fk_idx` (`nu_dias_aguardando_revisao`),
  CONSTRAINT `dim_categoria_tb_fato_fk` FOREIGN KEY (`id_categoria`) REFERENCES `tb_dim_categoria` (`id_categoria`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_data_tb_fato_fk_data_conclusao` FOREIGN KEY (`id_data_conclusao`) REFERENCES `tb_dim_data` (`id_data`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_data_tb_fato_fk_data_conclusao_sol` FOREIGN KEY (`id_data_conclusao_solicitada`) REFERENCES `tb_dim_data` (`id_data`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_data_tb_fato_fk_data_solicitacao` FOREIGN KEY (`id_data_solicitacao`) REFERENCES `tb_dim_data` (`id_data`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_departamento_solicitante_tb_fato_fk` FOREIGN KEY (`id_departamento_solicitante`) REFERENCES `tb_dim_departamento_solicitante` (`id_departamento_solicitante`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_nu_dias_est_agRev_tb_fato_fk` FOREIGN KEY (`nu_dias_aguardando_revisao`) REFERENCES `tb_dim_dias_estagio` (`nu_dias_estagio`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_nu_dias_est_andamento_tb_fato_fk` FOREIGN KEY (`nu_dias_andamento`) REFERENCES `tb_dim_dias_estagio` (`nu_dias_estagio`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_nu_dias_est_nova_tb_fato_fk` FOREIGN KEY (`nu_dias_nova`) REFERENCES `tb_dim_dias_estagio` (`nu_dias_estagio`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_nu_dias_est_rev_tb_fato_fk` FOREIGN KEY (`nu_dias_revisao`) REFERENCES `tb_dim_dias_estagio` (`nu_dias_estagio`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_nu_dias_est_susp_tb_fato_fk` FOREIGN KEY (`nu_dias_suspensa`) REFERENCES `tb_dim_dias_estagio` (`nu_dias_estagio`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_prioridade_tb_fato_fk` FOREIGN KEY (`id_prioridade`) REFERENCES `tb_dim_prioridade` (`id_prioridade`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_projeto_tb_fato_fk` FOREIGN KEY (`id_projeto`) REFERENCES `tb_dim_projeto` (`id_projeto`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_situacao_tb_fato_fk` FOREIGN KEY (`id_situacao`) REFERENCES `tb_dim_situacao` (`id_situacao`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_tipo_tarefa_tb_fato_fk` FOREIGN KEY (`id_tipo_tarefa`) REFERENCES `tb_dim_tipo_tarefa` (`id_tipo_tarefa`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=452312 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_fato`
--

LOCK TABLES `tb_fato` WRITE;
/*!40000 ALTER TABLE `tb_fato` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_fato` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'dw_redmine'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-02-19  6:47:08
