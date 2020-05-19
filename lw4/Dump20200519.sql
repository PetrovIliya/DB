-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: computers
-- ------------------------------------------------------
-- Server version	5.5.23

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
-- Table structure for table `component`
--

DROP TABLE IF EXISTS `component`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `component` (
  `component_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `type` int(10) unsigned NOT NULL,
  `price` int(10) unsigned NOT NULL,
  `weight` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`component_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `component`
--

LOCK TABLES `component` WRITE;
/*!40000 ALTER TABLE `component` DISABLE KEYS */;
INSERT INTO `component` VALUES (1,'test',1,100,50),(2,'kingston ram',1,150,10),(3,'china ram',1,50,20),(4,'kingston ram',2,160,11),(5,'superName',1,200,16);
/*!40000 ALTER TABLE `component` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `computer`
--

DROP TABLE IF EXISTS `computer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `computer` (
  `computer_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `type` int(10) unsigned NOT NULL,
  `serial_number` int(10) unsigned NOT NULL,
  `width` int(10) unsigned DEFAULT NULL,
  `height` int(10) unsigned DEFAULT NULL,
  `equpment_id` int(10) unsigned DEFAULT NULL,
  `manufacture_date` datetime DEFAULT NULL,
  PRIMARY KEY (`computer_id`),
  KEY `equipment_fk_idx` (`equpment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `computer`
--

LOCK TABLES `computer` WRITE;
/*!40000 ALTER TABLE `computer` DISABLE KEYS */;
INSERT INTO `computer` VALUES (1,'ASUS Aaspire 5',2,1321254589,50,10,1,'2019-05-19 00:00:00'),(2,'somename1',1,14665,40,15,6,'2019-05-19 00:00:00'),(3,'somename2',1,565945,60,20,7,'2019-05-19 00:00:00'),(4,'somename3',1,23154,70,30,8,'2019-05-19 00:00:00'),(5,'somename4',1,12665,80,25,9,'2019-05-19 00:00:00'),(6,'somename5',1,132131233,11,22,6,'2019-05-20 00:00:00');
/*!40000 ALTER TABLE `computer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `equipment`
--

DROP TABLE IF EXISTS `equipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `equipment` (
  `equipment_Id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `type` int(10) unsigned DEFAULT NULL,
  `manufacturer_company_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`equipment_Id`),
  KEY `mc_fk_idx` (`manufacturer_company_id`),
  CONSTRAINT `mc_fk` FOREIGN KEY (`manufacturer_company_id`) REFERENCES `manufacturer_company` (`manufacturer_company_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `equipment`
--

LOCK TABLES `equipment` WRITE;
/*!40000 ALTER TABLE `equipment` DISABLE KEYS */;
INSERT INTO `equipment` VALUES (1,'super hight',2,1),(6,'someName1',1,2),(7,'someName2',1,3),(8,'someName3',1,4),(9,'someName4',1,5);
/*!40000 ALTER TABLE `equipment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `equipment_component`
--

DROP TABLE IF EXISTS `equipment_component`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `equipment_component` (
  `computer_component_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `equipment_id` int(10) unsigned NOT NULL,
  `component_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`computer_component_id`),
  KEY `component_fk_idx` (`component_id`),
  KEY `equipment_fk_idx` (`equipment_id`),
  CONSTRAINT `component_fk` FOREIGN KEY (`component_id`) REFERENCES `component` (`component_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `equipment_fk` FOREIGN KEY (`equipment_id`) REFERENCES `equipment` (`equipment_Id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `equipment_component`
--

LOCK TABLES `equipment_component` WRITE;
/*!40000 ALTER TABLE `equipment_component` DISABLE KEYS */;
INSERT INTO `equipment_component` VALUES (1,1,1),(2,6,2),(3,7,3),(4,8,4),(5,9,5);
/*!40000 ALTER TABLE `equipment_component` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `manufacturer_company`
--

DROP TABLE IF EXISTS `manufacturer_company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manufacturer_company` (
  `manufacturer_company_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `adress` varchar(255) DEFAULT NULL,
  `reputation` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`manufacturer_company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manufacturer_company`
--

LOCK TABLES `manufacturer_company` WRITE;
/*!40000 ALTER TABLE `manufacturer_company` DISABLE KEYS */;
INSERT INTO `manufacturer_company` VALUES (1,'Asus','some addres',69),(2,'compnayName1','some addres2',25),(3,'compnayName2','some addre3',11),(4,'compnayName3','some addres4',100),(5,'compnayName4','some addres5',56);
/*!40000 ALTER TABLE `manufacturer_company` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-05-19 18:48:41
