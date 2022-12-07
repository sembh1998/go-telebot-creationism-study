CREATE DATABASE  IF NOT EXISTS `telegrambotdb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `telegrambotdb`;
-- MySQL dump 10.13  Distrib 8.0.31, for Linux (x86_64)
--
-- Host: database-telegram-bot.ctyfro7sstme.us-east-1.rds.amazonaws.com    Database: telegrambotdb
-- ------------------------------------------------------
-- Server version	8.0.28

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
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '';

--
-- Table structure for table `client`
--

DROP TABLE IF EXISTS `client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `chat_id` varchar(45) NOT NULL,
  `telegram_user_id` varchar(45) NOT NULL,
  `waiting_for_answer` bit(1) DEFAULT NULL COMMENT '1: yes;\n0: not',
  `questions_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_client_questions1_idx` (`questions_id`),
  CONSTRAINT `fk_client_questions1` FOREIGN KEY (`questions_id`) REFERENCES `questions` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `client`
--

LOCK TABLES `client` WRITE;
/*!40000 ALTER TABLE `client` DISABLE KEYS */;
INSERT INTO `client` VALUES (1,'Sem Benavente','794594555','794594555',_binary '\0',8),(2,'Romario ','2138441861','2138441861',_binary '',NULL);
/*!40000 ALTER TABLE `client` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `client_has_questions`
--

DROP TABLE IF EXISTS `client_has_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client_has_questions` (
  `client_id` int NOT NULL,
  `questions_id` int NOT NULL,
  `options_id` int NOT NULL,
  `date` datetime NOT NULL,
  `state` bit(1) NOT NULL COMMENT '1: active;\n0: deleted',
  KEY `fk_client_has_questions_questions1_idx` (`questions_id`),
  KEY `fk_client_has_questions_client1_idx` (`client_id`),
  KEY `fk_client_has_questions_options1_idx` (`options_id`),
  CONSTRAINT `fk_client_has_questions_client1` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`),
  CONSTRAINT `fk_client_has_questions_options1` FOREIGN KEY (`options_id`) REFERENCES `options` (`id`),
  CONSTRAINT `fk_client_has_questions_questions1` FOREIGN KEY (`questions_id`) REFERENCES `questions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `client_has_questions`
--

LOCK TABLES `client_has_questions` WRITE;
/*!40000 ALTER TABLE `client_has_questions` DISABLE KEYS */;
INSERT INTO `client_has_questions` VALUES (1,1,1,'2022-12-07 04:08:36',_binary '\0'),(1,1,1,'2022-12-07 04:10:14',_binary '\0'),(1,2,7,'2022-12-07 04:51:59',_binary '\0'),(1,8,25,'2022-12-07 05:22:44',_binary '\0'),(1,5,16,'2022-12-07 05:23:00',_binary '\0'),(1,9,28,'2022-12-07 05:23:17',_binary '\0'),(1,3,10,'2022-12-07 05:23:32',_binary '\0'),(1,4,15,'2022-12-07 05:23:47',_binary '\0'),(1,1,3,'2022-12-07 05:23:56',_binary '\0'),(1,7,22,'2022-12-07 05:24:07',_binary '\0'),(1,6,18,'2022-12-07 05:24:21',_binary '\0'),(1,10,31,'2022-12-07 05:24:40',_binary '\0'),(1,2,8,'2022-12-07 05:24:49',_binary '\0'),(1,5,17,'2022-12-07 05:25:07',_binary '\0'),(1,1,2,'2022-12-07 05:25:18',_binary '\0'),(1,8,26,'2022-12-07 05:25:36',_binary '\0'),(1,2,8,'2022-12-07 05:25:47',_binary '\0'),(1,9,29,'2022-12-07 05:25:57',_binary '\0'),(1,10,30,'2022-12-07 05:26:10',_binary '\0'),(1,4,14,'2022-12-07 05:26:28',_binary '\0'),(1,3,10,'2022-12-07 05:26:35',_binary '\0'),(1,7,21,'2022-12-07 05:26:43',_binary '\0'),(1,6,20,'2022-12-07 05:26:52',_binary '\0'),(1,7,22,'2022-12-07 05:32:47',_binary ''),(1,3,9,'2022-12-07 05:33:03',_binary ''),(1,4,15,'2022-12-07 05:33:15',_binary ''),(1,6,19,'2022-12-07 05:33:24',_binary ''),(1,9,28,'2022-12-07 05:33:32',_binary ''),(1,5,16,'2022-12-07 05:33:42',_binary ''),(1,2,7,'2022-12-07 05:33:51',_binary ''),(1,10,31,'2022-12-07 05:33:59',_binary ''),(1,1,3,'2022-12-07 05:34:08',_binary ''),(1,8,27,'2022-12-07 05:34:17',_binary '');
/*!40000 ALTER TABLE `client_has_questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `options`
--

DROP TABLE IF EXISTS `options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `options` (
  `id` int NOT NULL AUTO_INCREMENT,
  `option` varchar(1000) NOT NULL,
  `questions_id` int NOT NULL,
  `is_correct` bit(1) NOT NULL COMMENT '1: It is the correct answer;\n0: It isn''t the correct answer',
  PRIMARY KEY (`id`),
  KEY `fk_options_questions1_idx` (`questions_id`),
  CONSTRAINT `fk_options_questions1` FOREIGN KEY (`questions_id`) REFERENCES `questions` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `options`
--

LOCK TABLES `options` WRITE;
/*!40000 ALTER TABLE `options` DISABLE KEYS */;
INSERT INTO `options` VALUES (1,'5 días',1,_binary '\0'),(2,'6 días',1,_binary '\0'),(3,'7 días',1,_binary ''),(4,'8 días',1,_binary '\0'),(7,'son días literales',2,_binary ''),(8,'representan millones de años',2,_binary '\0'),(9,'no',3,_binary ''),(10,'si',3,_binary '\0'),(11,'tal vez',3,_binary '\0'),(12,'no estoy seguro',3,_binary '\0'),(13,'Mujer con mujer',4,_binary '\0'),(14,'Hombre con hombre',4,_binary '\0'),(15,'Hombre con mujer',4,_binary ''),(16,'Dios lo santificó',5,_binary ''),(17,'No tiene nada de especial',5,_binary '\0'),(18,'Dormía todo el día',6,_binary '\0'),(19,'Tenía un trabajo',6,_binary ''),(20,'Vagaba',6,_binary '\0'),(21,'Sí',7,_binary '\0'),(22,'No',7,_binary ''),(23,'Tal vez',7,_binary '\0'),(24,'No lo se',7,_binary '\0'),(25,'No',8,_binary '\0'),(26,'Más o menos',8,_binary '\0'),(27,'Si',8,_binary ''),(28,'Domingo',9,_binary ''),(29,'Lunes',9,_binary '\0'),(30,'Sí',10,_binary '\0'),(31,'No',10,_binary ''),(32,'Tengo dudas',10,_binary '\0');
/*!40000 ALTER TABLE `options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `questions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `question` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questions`
--

LOCK TABLES `questions` WRITE;
/*!40000 ALTER TABLE `questions` DISABLE KEYS */;
INSERT INTO `questions` VALUES (1,'#1. ¿Cuantos días duró la creación?'),(2,'#2. ¿los días de la creación son literales o representan millones de años?'),(3,'#3. ¿Proviene el hombre de la evolución?'),(4,'#4. ¿Cómo estaba conformada la primera familia creada?'),(5,'#5. ¿Qué de especial tiene el día sábado?'),(6,'#6. ¿El hombre luego de ser creado vagaba o tenía un trabajo?'),(7,'#7. ¿Comía el hombre carne en el edén?'),(8,'#8. ¿Creo Dios todo?'),(9,'#9. ¿Cuál es el primer día de la semana?'),(10,'#10. ¿Ha cambiado el día de reposo del sábado al domingo?');
/*!40000 ALTER TABLE `questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `references`
--

DROP TABLE IF EXISTS `references`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `references` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `text` varchar(2000) NOT NULL,
  `questions_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_references_questions1_idx` (`questions_id`),
  CONSTRAINT `fk_references_questions1` FOREIGN KEY (`questions_id`) REFERENCES `questions` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `references`
--

LOCK TABLES `references` WRITE;
/*!40000 ALTER TABLE `references` DISABLE KEYS */;
INSERT INTO `references` VALUES (1,'Éxodo 20:11','https://www.biblegateway.com/passage/?search=%C3%89xodo%2020%3A11&version=RVR1960',1),(2,'Génesis 1:1 al 2:3','https://www.biblegateway.com/passage/?search=G%C3%A9nesis%201%3A1-2%3A3&version=RVR1995',1),(3,'Éxodo 20:11','https://www.biblegateway.com/passage/?search=%C3%89xodo%2020%3A11&version=RVR1960',2),(4,'Génesis 1:5,8,13,19,23,31','https://www.biblegateway.com/passage/?search=G%C3%A9nesis+1%3A5%2C8%2C13%2C19%2C23%2C31&version=RVR1960',2),(5,'Génesis 1:27','https://www.biblegateway.com/passage/?search=G%C3%A9nesis+1%3A27&version=RVR1960',3),(6,'Génesis 1:24','https://www.biblegateway.com/passage/?search=G%C3%A9nesis+1%3A24&version=RVR1960',4),(7,'Marcos 10:6','https://www.biblegateway.com/passage/?search=Marcos+10%3A6&version=RVR1960',4),(8,'Génesis 2:2-3','https://www.biblegateway.com/passage/?search=G%C3%A9nesis+2%3A2-3&version=RVR1960',5),(9,'Génesis 1:27-28','https://www.biblegateway.com/passage/?search=G%C3%A9nesis+1%3A27-28&version=RVR1960',6),(10,'Génesis 2:19-20','https://www.biblegateway.com/passage/?search=G%C3%A9nesis+2%3A19-20&version=RVR1960',6),(11,'Génesis 1:29','https://www.biblegateway.com/passage/?search=G%C3%A9nesis+1%3A29&version=RVR1960',7),(12,'Génesis 2:16-17','https://www.biblegateway.com/passage/?search=G%C3%A9nesis+2%3A16-17&version=RVR1960',7),(13,'Génesis 1:1','https://www.biblegateway.com/passage/?search=G%C3%A9nesis+1%3A1&version=RVR1960',8),(14,'Dias en portugues','https://www.berlitz.com/es-mx/blog/dias-de-la-semana-en-portugues',9),(15,'En el cristianismo es el domingo','https://es.wikipedia.org/wiki/Domingo',9),(16,'Mateo 5:17','https://www.biblegateway.com/passage/?search=Mateo+5%3A17&version=RVR1960',10);
/*!40000 ALTER TABLE `references` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-12-07  0:44:34
