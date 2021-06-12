-- #####################################################################################################################
-- PartKeepr database dump for local testing
-- #####################################################################################################################
--
-- MariaDB dump 10.19  Distrib 10.5.10-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: partkeepr
-- ------------------------------------------------------
-- Server version	10.5.10-MariaDB-1:10.5.10+maria~focal

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

DROP DATABASE IF EXISTS partkeepr;
CREATE DATABASE partkeepr;
USE partkeepr;

--
-- Table structure for table `BatchJob`
--

DROP TABLE IF EXISTS `BatchJob`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `BatchJob` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `baseEntity` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_AF3CBF045E237E06` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BatchJob`
--

LOCK TABLES `BatchJob` WRITE;
/*!40000 ALTER TABLE `BatchJob` DISABLE KEYS */;
/*!40000 ALTER TABLE `BatchJob` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BatchJobQueryField`
--

DROP TABLE IF EXISTS `BatchJobQueryField`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `BatchJobQueryField` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `property` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `operator` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `value` longtext COLLATE utf8_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8_unicode_ci NOT NULL,
  `dynamic` tinyint(1) NOT NULL,
  `batchJob_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_6118E78CABE62C64` (`batchJob_id`),
  CONSTRAINT `FK_6118E78CABE62C64` FOREIGN KEY (`batchJob_id`) REFERENCES `BatchJob` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BatchJobQueryField`
--

LOCK TABLES `BatchJobQueryField` WRITE;
/*!40000 ALTER TABLE `BatchJobQueryField` DISABLE KEYS */;
/*!40000 ALTER TABLE `BatchJobQueryField` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BatchJobUpdateField`
--

DROP TABLE IF EXISTS `BatchJobUpdateField`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `BatchJobUpdateField` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `property` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `value` longtext COLLATE utf8_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8_unicode_ci NOT NULL,
  `dynamic` tinyint(1) NOT NULL,
  `batchJob_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_E1ADA7DFABE62C64` (`batchJob_id`),
  CONSTRAINT `FK_E1ADA7DFABE62C64` FOREIGN KEY (`batchJob_id`) REFERENCES `BatchJob` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BatchJobUpdateField`
--

LOCK TABLES `BatchJobUpdateField` WRITE;
/*!40000 ALTER TABLE `BatchJobUpdateField` DISABLE KEYS */;
/*!40000 ALTER TABLE `BatchJobUpdateField` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CachedImage`
--

DROP TABLE IF EXISTS `CachedImage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CachedImage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `originalId` int(11) NOT NULL,
  `originalType` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `cacheFile` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CachedImage`
--

LOCK TABLES `CachedImage` WRITE;
/*!40000 ALTER TABLE `CachedImage` DISABLE KEYS */;
/*!40000 ALTER TABLE `CachedImage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CronLogger`
--

DROP TABLE IF EXISTS `CronLogger`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CronLogger` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lastRunDate` datetime NOT NULL,
  `cronjob` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cronjob` (`cronjob`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CronLogger`
--

LOCK TABLES `CronLogger` WRITE;
/*!40000 ALTER TABLE `CronLogger` DISABLE KEYS */;
INSERT INTO `CronLogger` VALUES (11,'2021-06-11 21:50:02','partkeepr:cron:synctips'),(12,'2021-06-11 21:50:02','partkeepr:cron:create-statistic-snapshot');
/*!40000 ALTER TABLE `CronLogger` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Distributor`
--

DROP TABLE IF EXISTS `Distributor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Distributor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `address` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fax` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `skuurl` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `enabledForReports` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_2559D8A65E237E06` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Distributor`
--

LOCK TABLES `Distributor` WRITE;
/*!40000 ALTER TABLE `Distributor` DISABLE KEYS */;
INSERT INTO `Distributor` VALUES (1,'Amazon','','https://amazon.de','','','','','',0),(2,'material4print','','https://materia4print.de','','','','','',0),(3,'Reichelt Elektronik','','https://www.reichelt.de','','','','','',0);
/*!40000 ALTER TABLE `Distributor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FOSUser`
--

DROP TABLE IF EXISTS `FOSUser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `FOSUser` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `username_canonical` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  `salt` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `last_login` datetime DEFAULT NULL,
  `locked` tinyint(1) NOT NULL,
  `expired` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL,
  `confirmation_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password_requested_at` datetime DEFAULT NULL,
  `roles` longtext COLLATE utf8_unicode_ci NOT NULL COMMENT '(DC2Type:array)',
  `credentials_expired` tinyint(1) NOT NULL,
  `credentials_expire_at` datetime DEFAULT NULL,
  `email_canonical` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_37EF34F492FC23A8` (`username_canonical`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FOSUser`
--

LOCK TABLES `FOSUser` WRITE;
/*!40000 ALTER TABLE `FOSUser` DISABLE KEYS */;
INSERT INTO `FOSUser` VALUES (1,'whity','whity',1,'nmak6q3yp80o4gks8o08w4owk40k4k','dlPMpONDOC09lBZJIbuaGW5MN34/0TyyBbeUxCqERT+jORBC+UbWTfupJRWHP9mX+X2Luu603ppsR9j8GFEN/w==',NULL,0,0,NULL,NULL,NULL,'a:1:{i:0;s:16:\"ROLE_SUPER_ADMIN\";}',0,NULL,'cyberknecht@chaos-hip.de','cyberknecht@chaos-hip.de'),(2,'maggi','maggi',1,'do16os5tri0wcg8k0k8wcsk0gg8co4s','lDSGwTtWhjA7i7mSMkUgD153SAO78TC+jkV1LEGZHlrG9yOhbXOsSbF4tJgFIaJYkgUfrUqy8nYOrLP3VVUeWA==',NULL,0,0,NULL,NULL,NULL,'a:0:{}',0,NULL,'maggi@evkihip.de','maggi@evkihip.de');
/*!40000 ALTER TABLE `FOSUser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Footprint`
--

DROP TABLE IF EXISTS `Footprint`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Footprint` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_id` int(11) DEFAULT NULL,
  `name` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_7CF324945E237E06` (`name`),
  KEY `IDX_7CF3249412469DE2` (`category_id`),
  CONSTRAINT `FK_7CF3249412469DE2` FOREIGN KEY (`category_id`) REFERENCES `FootprintCategory` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Footprint`
--

LOCK TABLES `Footprint` WRITE;
/*!40000 ALTER TABLE `Footprint` DISABLE KEYS */;
INSERT INTO `Footprint` VALUES (1,3,'CBGA-32','32-Lead Ceramic Ball Grid Array'),(2,5,'FCBGA-576','576-Ball Ball Grid Array, Thermally Enhanced'),(3,7,'PBGA-119','119-Ball Plastic Ball Grid Array'),(4,9,'PBGA-169','169-Ball Plastic Ball Grid Array'),(5,11,'PBGA-225','225-Ball Plastic a Ball Grid Array'),(6,13,'PBGA-260','260-Ball Plastic Ball Grid Array'),(7,15,'PBGA-297','297-Ball Plastic Ball Grid Array'),(8,17,'PBGA-304','304-Lead Plastic Ball Grid Array'),(9,19,'PBGA-316','316-Lead Plastic Ball Grid Array'),(10,21,'PBGA-324','324-Ball Plastic Ball Grid Array'),(11,23,'PBGA-385','385-Lead Ball Grid Array'),(12,25,'PBGA-400','400-Ball Plastic Ball Grid Array'),(13,27,'PBGA-484','484-Ball Plastic Ball Grid Array'),(14,29,'PBGA-625','625-Ball Plastic Ball Grid Array'),(15,31,'PBGA-676','676-Ball Plastic Ball Grid Array'),(16,33,'SBGA-256','256-Ball Ball Grid Array, Thermally Enhanced'),(17,35,'SBGA-304','304-Ball Ball Grid Array, Thermally Enhanced'),(18,37,'SBGA-432','432-Ball Ball Grid Array, Thermally Enhanced'),(19,39,'CerDIP-8','8-Lead Ceramic Dual In-Line Package'),(20,41,'CerDIP-14','14-Lead Ceramic Dual In-Line Package'),(21,43,'CerDIP-16','16-Lead Ceramic Dual In-Line Package'),(22,45,'CerDIP-18','18-Lead Ceramic Dual In-Line Package'),(23,47,'CerDIP-20','20-Lead Ceramic Dual In-Line Package'),(24,49,'CerDIP-24 Narrow','24-Lead Ceramic Dual In-Line Package - Narrow Body'),(25,51,'CerDIP-24 Wide','24-Lead Ceramic Dual In-Line Package - Wide Body'),(26,53,'CerDIP-28','28-Lead Ceramic Dual In-Line Package'),(27,55,'CerDIP-40','40-Lead Ceramic Dual In-Line Package'),(28,57,'PDIP-8','8-Lead Plastic Dual In-Line Package'),(29,59,'PDIP-14','14-Lead Plastic Dual In-Line Package'),(30,61,'PDIP-16','16-Lead Plastic Dual In-Line Package'),(31,63,'PDIP-18','18-Lead Plastic Dual In-Line Package'),(32,65,'PDIP-20','20-Lead Plastic Dual In-Line Package'),(33,67,'PDIP-24','24-Lead Plastic Dual In-Line Package'),(34,69,'PDIP-28 Narrow','28-Lead Plastic Dual In-Line Package, Narrow Body'),(35,71,'PDIP-28 Wide','28-Lead Plastic Dual In-Line Package, Wide Body'),(36,NULL,'SOIC-N-EP-8','8-Lead Standard Small Outline Package, with Expose Pad');
/*!40000 ALTER TABLE `Footprint` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FootprintAttachment`
--

DROP TABLE IF EXISTS `FootprintAttachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `FootprintAttachment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `footprint_id` int(11) DEFAULT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `filename` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `originalname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mimetype` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `size` int(11) NOT NULL,
  `extension` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_7B7388A151364C98` (`footprint_id`),
  CONSTRAINT `FK_7B7388A151364C98` FOREIGN KEY (`footprint_id`) REFERENCES `Footprint` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FootprintAttachment`
--

LOCK TABLES `FootprintAttachment` WRITE;
/*!40000 ALTER TABLE `FootprintAttachment` DISABLE KEYS */;
/*!40000 ALTER TABLE `FootprintAttachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FootprintCategory`
--

DROP TABLE IF EXISTS `FootprintCategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `FootprintCategory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `lft` int(11) NOT NULL,
  `rgt` int(11) NOT NULL,
  `lvl` int(11) NOT NULL,
  `root` int(11) DEFAULT NULL,
  `name` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `categoryPath` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_C026BA6A727ACA70` (`parent_id`),
  KEY `IDX_C026BA6ADA439252` (`lft`),
  KEY `IDX_C026BA6AD5E02D69` (`rgt`),
  CONSTRAINT `FK_C026BA6A727ACA70` FOREIGN KEY (`parent_id`) REFERENCES `FootprintCategory` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FootprintCategory`
--

LOCK TABLES `FootprintCategory` WRITE;
/*!40000 ALTER TABLE `FootprintCategory` DISABLE KEYS */;
INSERT INTO `FootprintCategory` VALUES (1,NULL,1,142,0,1,'Root Category',NULL,'Root Category'),(2,1,2,5,1,1,'BGA',NULL,'Root Category ➤ BGA'),(3,2,3,4,2,1,'CBGA',NULL,'Root Category ➤ BGA ➤ CBGA'),(4,1,6,9,1,1,'BGA',NULL,'Root Category ➤ BGA'),(5,4,7,8,2,1,'FCBGA',NULL,'Root Category ➤ BGA ➤ FCBGA'),(6,1,10,13,1,1,'BGA',NULL,'Root Category ➤ BGA'),(7,6,11,12,2,1,'PBGA',NULL,'Root Category ➤ BGA ➤ PBGA'),(8,1,14,17,1,1,'BGA',NULL,'Root Category ➤ BGA'),(9,8,15,16,2,1,'PBGA',NULL,'Root Category ➤ BGA ➤ PBGA'),(10,1,18,21,1,1,'BGA',NULL,'Root Category ➤ BGA'),(11,10,19,20,2,1,'PBGA',NULL,'Root Category ➤ BGA ➤ PBGA'),(12,1,22,25,1,1,'BGA',NULL,'Root Category ➤ BGA'),(13,12,23,24,2,1,'PBGA',NULL,'Root Category ➤ BGA ➤ PBGA'),(14,1,26,29,1,1,'BGA',NULL,'Root Category ➤ BGA'),(15,14,27,28,2,1,'PBGA',NULL,'Root Category ➤ BGA ➤ PBGA'),(16,1,30,33,1,1,'BGA',NULL,'Root Category ➤ BGA'),(17,16,31,32,2,1,'PBGA',NULL,'Root Category ➤ BGA ➤ PBGA'),(18,1,34,37,1,1,'BGA',NULL,'Root Category ➤ BGA'),(19,18,35,36,2,1,'PBGA',NULL,'Root Category ➤ BGA ➤ PBGA'),(20,1,38,41,1,1,'BGA',NULL,'Root Category ➤ BGA'),(21,20,39,40,2,1,'PBGA',NULL,'Root Category ➤ BGA ➤ PBGA'),(22,1,42,45,1,1,'BGA',NULL,'Root Category ➤ BGA'),(23,22,43,44,2,1,'PBGA',NULL,'Root Category ➤ BGA ➤ PBGA'),(24,1,46,49,1,1,'BGA',NULL,'Root Category ➤ BGA'),(25,24,47,48,2,1,'PBGA',NULL,'Root Category ➤ BGA ➤ PBGA'),(26,1,50,53,1,1,'BGA',NULL,'Root Category ➤ BGA'),(27,26,51,52,2,1,'PBGA',NULL,'Root Category ➤ BGA ➤ PBGA'),(28,1,54,57,1,1,'BGA',NULL,'Root Category ➤ BGA'),(29,28,55,56,2,1,'PBGA',NULL,'Root Category ➤ BGA ➤ PBGA'),(30,1,58,61,1,1,'BGA',NULL,'Root Category ➤ BGA'),(31,30,59,60,2,1,'PBGA',NULL,'Root Category ➤ BGA ➤ PBGA'),(32,1,62,65,1,1,'BGA',NULL,'Root Category ➤ BGA'),(33,32,63,64,2,1,'PBGA',NULL,'Root Category ➤ BGA ➤ PBGA'),(34,1,66,69,1,1,'BGA',NULL,'Root Category ➤ BGA'),(35,34,67,68,2,1,'PBGA',NULL,'Root Category ➤ BGA ➤ PBGA'),(36,1,70,73,1,1,'BGA',NULL,'Root Category ➤ BGA'),(37,36,71,72,2,1,'PBGA',NULL,'Root Category ➤ BGA ➤ PBGA'),(38,1,74,77,1,1,'DIP',NULL,'Root Category ➤ DIP'),(39,38,75,76,2,1,'CERDIP',NULL,'Root Category ➤ DIP ➤ CERDIP'),(40,1,78,81,1,1,'DIP',NULL,'Root Category ➤ DIP'),(41,40,79,80,2,1,'CERDIP',NULL,'Root Category ➤ DIP ➤ CERDIP'),(42,1,82,85,1,1,'DIP',NULL,'Root Category ➤ DIP'),(43,42,83,84,2,1,'CERDIP',NULL,'Root Category ➤ DIP ➤ CERDIP'),(44,1,86,89,1,1,'DIP',NULL,'Root Category ➤ DIP'),(45,44,87,88,2,1,'CERDIP',NULL,'Root Category ➤ DIP ➤ CERDIP'),(46,1,90,93,1,1,'DIP',NULL,'Root Category ➤ DIP'),(47,46,91,92,2,1,'CERDIP',NULL,'Root Category ➤ DIP ➤ CERDIP'),(48,1,94,97,1,1,'DIP',NULL,'Root Category ➤ DIP'),(49,48,95,96,2,1,'CERDIP',NULL,'Root Category ➤ DIP ➤ CERDIP'),(50,1,98,101,1,1,'DIP',NULL,'Root Category ➤ DIP'),(51,50,99,100,2,1,'CERDIP',NULL,'Root Category ➤ DIP ➤ CERDIP'),(52,1,102,105,1,1,'DIP',NULL,'Root Category ➤ DIP'),(53,52,103,104,2,1,'CERDIP',NULL,'Root Category ➤ DIP ➤ CERDIP'),(54,1,106,109,1,1,'DIP',NULL,'Root Category ➤ DIP'),(55,54,107,108,2,1,'CERDIP',NULL,'Root Category ➤ DIP ➤ CERDIP'),(56,1,110,113,1,1,'DIP',NULL,'Root Category ➤ DIP'),(57,56,111,112,2,1,'PDIP',NULL,'Root Category ➤ DIP ➤ PDIP'),(58,1,114,117,1,1,'DIP',NULL,'Root Category ➤ DIP'),(59,58,115,116,2,1,'PDIP',NULL,'Root Category ➤ DIP ➤ PDIP'),(60,1,118,121,1,1,'DIP',NULL,'Root Category ➤ DIP'),(61,60,119,120,2,1,'PDIP',NULL,'Root Category ➤ DIP ➤ PDIP'),(62,1,122,125,1,1,'DIP',NULL,'Root Category ➤ DIP'),(63,62,123,124,2,1,'PDIP',NULL,'Root Category ➤ DIP ➤ PDIP'),(64,1,126,129,1,1,'DIP',NULL,'Root Category ➤ DIP'),(65,64,127,128,2,1,'PDIP',NULL,'Root Category ➤ DIP ➤ PDIP'),(66,1,130,133,1,1,'DIP',NULL,'Root Category ➤ DIP'),(67,66,131,132,2,1,'PDIP',NULL,'Root Category ➤ DIP ➤ PDIP'),(68,1,134,137,1,1,'DIP',NULL,'Root Category ➤ DIP'),(69,68,135,136,2,1,'PDIP',NULL,'Root Category ➤ DIP ➤ PDIP'),(70,1,138,141,1,1,'DIP',NULL,'Root Category ➤ DIP'),(71,70,139,140,2,1,'PDIP',NULL,'Root Category ➤ DIP ➤ PDIP');
/*!40000 ALTER TABLE `FootprintCategory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FootprintImage`
--

DROP TABLE IF EXISTS `FootprintImage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `FootprintImage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `footprint_id` int(11) DEFAULT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `filename` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `originalname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mimetype` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `size` int(11) NOT NULL,
  `extension` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_3B22699151364C98` (`footprint_id`),
  CONSTRAINT `FK_3B22699151364C98` FOREIGN KEY (`footprint_id`) REFERENCES `Footprint` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FootprintImage`
--

LOCK TABLES `FootprintImage` WRITE;
/*!40000 ALTER TABLE `FootprintImage` DISABLE KEYS */;
INSERT INTO `FootprintImage` VALUES (1,1,'footprint','18d9903a-882d-11eb-a745-66e9f77ef34d','CBGA-32.png','image/png',23365,'png',NULL,'2021-03-18 22:01:23'),(2,2,'footprint','18db6e78-882d-11eb-bbcb-1262b804b5b4','FCBGA-576.png','image/png',47861,'png',NULL,'2021-03-18 22:01:23'),(3,3,'footprint','18dbbe8c-882d-11eb-9d25-9a8d4ec1d9d0','PBGA-119.png','image/png',32537,'png',NULL,'2021-03-18 22:01:23'),(4,4,'footprint','18dc00f4-882d-11eb-890a-96213874e6a5','PBGA-169.png','image/png',36699,'png',NULL,'2021-03-18 22:01:23'),(5,5,'footprint','18dc438e-882d-11eb-8b89-d06805ad00f4','PBGA-225.png','image/png',39366,'png',NULL,'2021-03-18 22:01:23'),(6,6,'footprint','18dc9532-882d-11eb-935f-af9a40c7df1d','PBGA-260.png','image/png',61202,'png',NULL,'2021-03-18 22:01:23'),(7,7,'footprint','18dcf126-882d-11eb-88e4-33de835afcbd','PBGA-297.png','image/png',68013,'png',NULL,'2021-03-18 22:01:23'),(8,8,'footprint','18dd46b2-882d-11eb-9661-5f212332f8d3','PBGA-304.png','image/png',55833,'png',NULL,'2021-03-18 22:01:23'),(9,9,'footprint','18dd91c6-882d-11eb-8388-ea061c790357','PBGA-316.png','image/png',55996,'png',NULL,'2021-03-18 22:01:23'),(10,10,'footprint','18ddd654-882d-11eb-be88-1e6498a7eb1f','PBGA-324.png','image/png',44882,'png',NULL,'2021-03-18 22:01:23'),(11,11,'footprint','18de18f8-882d-11eb-a398-1e979ace3f31','PBGA-385.png','image/png',35146,'png',NULL,'2021-03-18 22:01:23'),(12,12,'footprint','18de62a4-882d-11eb-bb42-f3e628f765d0','PBGA-400.png','image/png',67933,'png',NULL,'2021-03-18 22:01:23'),(13,13,'footprint','18dea818-882d-11eb-9f6a-f28117c7284d','PBGA-484.png','image/png',49851,'png',NULL,'2021-03-18 22:01:23'),(14,14,'footprint','18def318-882d-11eb-9c8a-be5f5c6c322b','PBGA-625.png','image/png',65307,'png',NULL,'2021-03-18 22:01:23'),(15,15,'footprint','18dfcca2-882d-11eb-b095-0e6e571cdade','PBGA-676.png','image/png',54708,'png',NULL,'2021-03-18 22:01:23'),(16,16,'footprint','18e02760-882d-11eb-93fe-9088a0a8ee97','SBGA-256.png','image/png',48636,'png',NULL,'2021-03-18 22:01:23'),(17,17,'footprint','18e09178-882d-11eb-8b38-6f6ac191d8e8','SBGA-304.png','image/png',51944,'png',NULL,'2021-03-18 22:01:23'),(18,18,'footprint','18e0fb22-882d-11eb-a44d-167c22fa299b','SBGA-432.png','image/png',63247,'png',NULL,'2021-03-18 22:01:23'),(19,19,'footprint','18e19776-882d-11eb-8130-6f894c7d0f34','CERDIP-8.png','image/png',13544,'png',NULL,'2021-03-18 22:01:23'),(20,20,'footprint','18e1eb22-882d-11eb-a1d4-1d78de5f8753','CERDIP-14.png','image/png',14226,'png',NULL,'2021-03-18 22:01:23'),(21,21,'footprint','18e22a56-882d-11eb-b903-c4035f450d54','CERDIP-16.png','image/png',14576,'png',NULL,'2021-03-18 22:01:23'),(22,22,'footprint','18e26980-882d-11eb-a3b4-c65d204284e7','CERDIP-18.png','image/png',9831,'png',NULL,'2021-03-18 22:01:23'),(23,23,'footprint','18e2a792-882d-11eb-b80d-f9d1aaf359fb','CERDIP-20.png','image/png',10209,'png',NULL,'2021-03-18 22:01:23'),(24,24,'footprint','18e2e054-882d-11eb-aff1-7c347ae6f4c0','CERDIP-24-N.png','image/png',11582,'png',NULL,'2021-03-18 22:01:23'),(25,25,'footprint','18e33504-882d-11eb-8600-a8822a65e821','CERDIP-24-W.png','image/png',12407,'png',NULL,'2021-03-18 22:01:23'),(26,26,'footprint','18e3895a-882d-11eb-8138-86d7312e789d','CERDIP-28.png','image/png',12233,'png',NULL,'2021-03-18 22:01:23'),(27,27,'footprint','18e3c55a-882d-11eb-9c6e-200e57a23295','CERDIP-40.png','image/png',12421,'png',NULL,'2021-03-18 22:01:23'),(28,28,'footprint','18e419c4-882d-11eb-9b96-7c5878329be6','PDIP-8.png','image/png',13537,'png',NULL,'2021-03-18 22:01:23'),(29,29,'footprint','18e4543e-882d-11eb-b781-c3ea77e923f7','PDIP-14.png','image/png',13779,'png',NULL,'2021-03-18 22:01:23'),(30,30,'footprint','18e4926e-882d-11eb-be3a-6f2f0857fb6a','PDIP-16.png','image/png',18305,'png',NULL,'2021-03-18 22:01:23'),(31,31,'footprint','18e4f7d6-882d-11eb-9df3-9a5141c1927f','PDIP-18.png','image/png',14893,'png',NULL,'2021-03-18 22:01:23'),(32,32,'footprint','18e54b50-882d-11eb-926c-2754a57407a3','PDIP-20.png','image/png',14429,'png',NULL,'2021-03-18 22:01:23'),(33,33,'footprint','18e5e81c-882d-11eb-be92-4707c337fbe4','PDIP-24.png','image/png',14647,'png',NULL,'2021-03-18 22:01:23'),(34,34,'footprint','18e62b06-882d-11eb-8e7c-ce787b776b19','PDIP-28-N.png','image/png',18703,'png',NULL,'2021-03-18 22:01:23'),(35,35,'footprint','18e66382-882d-11eb-9827-a9c7c5f74f1e','PDIP-28-W.png','image/png',15728,'png',NULL,'2021-03-18 22:01:23');
/*!40000 ALTER TABLE `FootprintImage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GridPreset`
--

DROP TABLE IF EXISTS `GridPreset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GridPreset` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `grid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `configuration` longtext COLLATE utf8_unicode_ci NOT NULL,
  `gridDefault` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_grid_unique` (`grid`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GridPreset`
--

LOCK TABLES `GridPreset` WRITE;
/*!40000 ALTER TABLE `GridPreset` DISABLE KEYS */;
INSERT INTO `GridPreset` VALUES (1,'PartKeepr.PartsGrid','Test','[{\"dataIndex\":\"\",\"text\":\"<span class=\\\"web-icon fugue-icon paper-clip\\\"></span>\",\"hidden\":false,\"width\":30,\"tooltip\":\"Has attachments?\",\"renderers\":[{\"rtype\":\"partAttachment\",\"rendererConfig\":null}]},{\"dataIndex\":\"needsReview\",\"text\":\"<span class=\\\"web-icon flag_orange\\\"></span>\",\"hidden\":false,\"width\":30,\"tooltip\":\"Needs Review?\",\"renderers\":[{\"rtype\":\"icon\",\"rendererConfig\":{\"iconCls\":\"web-icon flag_orange\"}}]},{\"dataIndex\":\"metaPart\",\"text\":\"<span class=\\\"web-icon bricks\\\"></span>\",\"hidden\":false,\"width\":30,\"tooltip\":\"Meta Part\",\"renderers\":[{\"rtype\":\"icon\",\"rendererConfig\":{\"iconCls\":\"web-icon bricks\"}}]},{\"dataIndex\":\"name\",\"text\":\"Name\",\"hidden\":false,\"flex\":1,\"tooltip\":\"\",\"renderers\":[]},{\"dataIndex\":\"description\",\"text\":\"Description\",\"hidden\":false,\"flex\":2,\"tooltip\":\"\",\"renderers\":[]},{\"dataIndex\":\"storageLocation.name\",\"text\":\"Storage Location\",\"hidden\":false,\"width\":100,\"tooltip\":\"\",\"renderers\":[]},{\"dataIndex\":\"status\",\"text\":\"Status\",\"hidden\":false,\"width\":100,\"tooltip\":\"\",\"renderers\":[]},{\"dataIndex\":\"partCondition\",\"text\":\"Condition\",\"hidden\":false,\"width\":100,\"tooltip\":\"\",\"renderers\":[]},{\"dataIndex\":\"stockLevel\",\"text\":\"Stock\",\"hidden\":false,\"width\":100,\"tooltip\":\"\",\"renderers\":[{\"rtype\":\"stockLevel\",\"rendererConfig\":null}]},{\"dataIndex\":\"minStockLevel\",\"text\":\"Min. Stock\",\"hidden\":false,\"width\":100,\"tooltip\":\"\",\"renderers\":[{\"rtype\":\"stockLevel\",\"rendererConfig\":null}]},{\"dataIndex\":\"averagePrice\",\"text\":\"Avg. Price\",\"hidden\":false,\"width\":100,\"tooltip\":\"\",\"renderers\":[{\"rtype\":\"currency\",\"rendererConfig\":null}]},{\"dataIndex\":\"footprint.name\",\"text\":\"Footprint\",\"hidden\":false,\"width\":100,\"tooltip\":\"\",\"renderers\":[]},{\"dataIndex\":\"category.categoryPath\",\"text\":\"Category\",\"hidden\":true,\"width\":100,\"tooltip\":\"\",\"renderers\":[]},{\"dataIndex\":\"createDate\",\"text\":\"Create Date\",\"hidden\":true,\"width\":100,\"tooltip\":\"\",\"renderers\":[]},{\"dataIndex\":\"@id\",\"text\":\"Internal ID\",\"hidden\":false,\"width\":100,\"tooltip\":\"\",\"renderers\":[{\"rtype\":\"internalID\",\"rendererConfig\":null}]},{\"dataIndex\":\"@id\",\"text\":\"Besitzer\",\"hidden\":false,\"flex\":1,\"tooltip\":\"\",\"renderers\":[{\"rtype\":\"partParameter\",\"rendererConfig\":{\"parameterName\":\"Besitzer\"}}]}]',0);
/*!40000 ALTER TABLE `GridPreset` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ImportPreset`
--

DROP TABLE IF EXISTS `ImportPreset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ImportPreset` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `baseEntity` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `configuration` longtext COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_entity_unique` (`baseEntity`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ImportPreset`
--

LOCK TABLES `ImportPreset` WRITE;
/*!40000 ALTER TABLE `ImportPreset` DISABLE KEYS */;
/*!40000 ALTER TABLE `ImportPreset` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Manufacturer`
--

DROP TABLE IF EXISTS `Manufacturer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Manufacturer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `address` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fax` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_253B3D245E237E06` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=293 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Manufacturer`
--

LOCK TABLES `Manufacturer` WRITE;
/*!40000 ALTER TABLE `Manufacturer` DISABLE KEYS */;
INSERT INTO `Manufacturer` VALUES (1,'Integrated Circuit Designs',NULL,NULL,NULL,NULL,NULL,NULL),(2,'ACTEL',NULL,NULL,NULL,NULL,NULL,NULL),(3,'ALTINC',NULL,NULL,NULL,NULL,NULL,NULL),(4,'Aeroflex',NULL,NULL,NULL,NULL,NULL,NULL),(5,'Agilent Technologies',NULL,NULL,NULL,NULL,NULL,NULL),(6,'AKM Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(7,'Alesis Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(8,'ALi (Acer Laboratories Inc.)',NULL,NULL,NULL,NULL,NULL,NULL),(9,'Allayer Communications',NULL,NULL,NULL,NULL,NULL,NULL),(10,'Allegro Microsystems',NULL,NULL,NULL,NULL,NULL,NULL),(11,'Alliance Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(12,'Alpha Industries',NULL,NULL,NULL,NULL,NULL,NULL),(13,'Alpha Microelectronics',NULL,NULL,NULL,NULL,NULL,NULL),(14,'Altera',NULL,NULL,NULL,NULL,NULL,NULL),(15,'Advanced Micro Devices (AMD)',NULL,NULL,NULL,NULL,NULL,NULL),(16,'American Microsystems, Inc. (AMI)',NULL,NULL,NULL,NULL,NULL,NULL),(17,'Amic Technology',NULL,NULL,NULL,NULL,NULL,NULL),(18,'Amphus',NULL,NULL,NULL,NULL,NULL,NULL),(19,'Anachip Corp.',NULL,NULL,NULL,NULL,NULL,NULL),(20,'ANADIGICs',NULL,NULL,NULL,NULL,NULL,NULL),(21,'Analog Devices',NULL,NULL,NULL,NULL,NULL,NULL),(22,'Analog Systems',NULL,NULL,NULL,NULL,NULL,NULL),(23,'Anchor Chips',NULL,NULL,NULL,NULL,NULL,NULL),(24,'Apex Microtechnology',NULL,NULL,NULL,NULL,NULL,NULL),(25,'ARK Logic',NULL,NULL,NULL,NULL,NULL,NULL),(26,'ASD',NULL,NULL,NULL,NULL,NULL,NULL),(27,'Astec Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(28,'ATC (Analog Technologie)',NULL,NULL,NULL,NULL,NULL,NULL),(29,'ATecoM',NULL,NULL,NULL,NULL,NULL,NULL),(30,'ATI Technologies',NULL,NULL,NULL,NULL,NULL,NULL),(31,'Atmel',NULL,NULL,NULL,NULL,NULL,NULL),(32,'AT&T',NULL,NULL,NULL,NULL,NULL,NULL),(33,'AudioCodes',NULL,NULL,NULL,NULL,NULL,NULL),(34,'Aura Vision',NULL,NULL,NULL,NULL,NULL,NULL),(35,'Aureal',NULL,NULL,NULL,NULL,NULL,NULL),(36,'Austin Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(37,'Avance Logic',NULL,NULL,NULL,NULL,NULL,NULL),(38,'Bel Fuse',NULL,NULL,NULL,NULL,NULL,NULL),(39,'Benchmarq Microelectronics',NULL,NULL,NULL,NULL,NULL,NULL),(40,'BI Technologies',NULL,NULL,NULL,NULL,NULL,NULL),(41,'Bowmar/White',NULL,NULL,NULL,NULL,NULL,NULL),(42,'Brightflash',NULL,NULL,NULL,NULL,NULL,NULL),(43,'Broadcom',NULL,NULL,NULL,NULL,NULL,NULL),(44,'Brooktree(now Rockwell)',NULL,NULL,NULL,NULL,NULL,NULL),(45,'Burr Brown',NULL,NULL,NULL,NULL,NULL,NULL),(46,'California Micro Devices',NULL,NULL,NULL,NULL,NULL,NULL),(47,'Calogic',NULL,NULL,NULL,NULL,NULL,NULL),(48,'Catalyst Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(49,'Centon Electronics',NULL,NULL,NULL,NULL,NULL,NULL),(50,'Ceramate Technical',NULL,NULL,NULL,NULL,NULL,NULL),(51,'Cherry Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(52,'Chipcon AS',NULL,NULL,NULL,NULL,NULL,NULL),(53,'Chips',NULL,NULL,NULL,NULL,NULL,NULL),(54,'Chrontel',NULL,NULL,NULL,NULL,NULL,NULL),(55,'Cirrus Logic',NULL,NULL,NULL,NULL,NULL,NULL),(56,'ComCore Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(57,'Conexant',NULL,NULL,NULL,NULL,NULL,NULL),(58,'Cosmo Electronics',NULL,NULL,NULL,NULL,NULL,NULL),(59,'Chrystal',NULL,NULL,NULL,NULL,NULL,NULL),(60,'Cygnal',NULL,NULL,NULL,NULL,NULL,NULL),(61,'Cypress Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(62,'Cyrix Corporation',NULL,NULL,NULL,NULL,NULL,NULL),(63,'Daewoo Electronics Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(64,'Dallas Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(65,'Davicom Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(66,'Data Delay Devices',NULL,NULL,NULL,NULL,NULL,NULL),(67,'Diamond Technologies',NULL,NULL,NULL,NULL,NULL,NULL),(68,'DIOTEC',NULL,NULL,NULL,NULL,NULL,NULL),(69,'DTC Data Technology',NULL,NULL,NULL,NULL,NULL,NULL),(70,'DVDO',NULL,NULL,NULL,NULL,NULL,NULL),(71,'EG&G',NULL,NULL,NULL,NULL,NULL,NULL),(72,'Elan Microelectronics',NULL,NULL,NULL,NULL,NULL,NULL),(73,'ELANTEC',NULL,NULL,NULL,NULL,NULL,NULL),(74,'Electronic Arrays',NULL,NULL,NULL,NULL,NULL,NULL),(75,'Elite Flash Storage Technology Inc. (EFST)',NULL,NULL,NULL,NULL,NULL,NULL),(76,'EM Microelectronik - Marin',NULL,NULL,NULL,NULL,NULL,NULL),(77,'Enhanced Memory Systems',NULL,NULL,NULL,NULL,NULL,NULL),(78,'Ensoniq Corp',NULL,NULL,NULL,NULL,NULL,NULL),(79,'EON Silicon Devices',NULL,NULL,NULL,NULL,NULL,NULL),(80,'Epson',NULL,NULL,NULL,NULL,NULL,NULL),(81,'Ericsson',NULL,NULL,NULL,NULL,NULL,NULL),(82,'ESS Technology',NULL,NULL,NULL,NULL,NULL,NULL),(83,'Electronic Technology',NULL,NULL,NULL,NULL,NULL,NULL),(84,'EXAR',NULL,NULL,NULL,NULL,NULL,NULL),(85,'Excel Semiconductor Inc.',NULL,NULL,NULL,NULL,NULL,NULL),(86,'Fairschild',NULL,NULL,NULL,NULL,NULL,NULL),(87,'Freescale Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(88,'Fujitsu',NULL,NULL,NULL,NULL,NULL,NULL),(89,'Galileo Technology',NULL,NULL,NULL,NULL,NULL,NULL),(90,'Galvantech',NULL,NULL,NULL,NULL,NULL,NULL),(91,'GEC Plessey',NULL,NULL,NULL,NULL,NULL,NULL),(92,'Gennum',NULL,NULL,NULL,NULL,NULL,NULL),(93,'General Electric (Harris)',NULL,NULL,NULL,NULL,NULL,NULL),(94,'General Instruments',NULL,NULL,NULL,NULL,NULL,NULL),(95,'G-Link Technology',NULL,NULL,NULL,NULL,NULL,NULL),(96,'Goal Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(97,'Goldstar',NULL,NULL,NULL,NULL,NULL,NULL),(98,'Gould',NULL,NULL,NULL,NULL,NULL,NULL),(99,'Greenwich Instruments',NULL,NULL,NULL,NULL,NULL,NULL),(100,'General Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(101,'Harris Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(102,'VEB',NULL,NULL,NULL,NULL,NULL,NULL),(103,'Hitachi Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(104,'Holtek',NULL,NULL,NULL,NULL,NULL,NULL),(105,'Hewlett Packard',NULL,NULL,NULL,NULL,NULL,NULL),(106,'Hualon',NULL,NULL,NULL,NULL,NULL,NULL),(107,'Hynix Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(108,'Hyundai',NULL,NULL,NULL,NULL,NULL,NULL),(109,'IC Design',NULL,NULL,NULL,NULL,NULL,NULL),(110,'Integrated Circuit Systems (ICS)',NULL,NULL,NULL,NULL,NULL,NULL),(111,'IC - Haus',NULL,NULL,NULL,NULL,NULL,NULL),(112,'ICSI (Integrated Circuit Solution Inc.)',NULL,NULL,NULL,NULL,NULL,NULL),(113,'I-Cube',NULL,NULL,NULL,NULL,NULL,NULL),(114,'IC Works',NULL,NULL,NULL,NULL,NULL,NULL),(115,'Integrated Device Technology (IDT)',NULL,NULL,NULL,NULL,NULL,NULL),(116,'IGS Technologies',NULL,NULL,NULL,NULL,NULL,NULL),(117,'IMPALA Linear',NULL,NULL,NULL,NULL,NULL,NULL),(118,'IMP',NULL,NULL,NULL,NULL,NULL,NULL),(119,'Infineon',NULL,NULL,NULL,NULL,NULL,NULL),(120,'INMOS',NULL,NULL,NULL,NULL,NULL,NULL),(121,'Intel',NULL,NULL,NULL,NULL,NULL,NULL),(122,'Intersil',NULL,NULL,NULL,NULL,NULL,NULL),(123,'International Rectifier',NULL,NULL,NULL,NULL,NULL,NULL),(124,'Information Storage Devices',NULL,NULL,NULL,NULL,NULL,NULL),(125,'ISSI (Integrated Silicon Solution, Inc.)',NULL,NULL,NULL,NULL,NULL,NULL),(126,'Integrated Technology Express',NULL,NULL,NULL,NULL,NULL,NULL),(127,'ITT Semiconductor (Micronas Intermetall)',NULL,NULL,NULL,NULL,NULL,NULL),(128,'IXYS',NULL,NULL,NULL,NULL,NULL,NULL),(129,'Korea Electronics (KEC)',NULL,NULL,NULL,NULL,NULL,NULL),(130,'Kota Microcircuits',NULL,NULL,NULL,NULL,NULL,NULL),(131,'Lattice Semiconductor Corp.',NULL,NULL,NULL,NULL,NULL,NULL),(132,'Lansdale Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(133,'Level One Communications',NULL,NULL,NULL,NULL,NULL,NULL),(134,'LG Semicon (Lucky Goldstar Electronic Co.)',NULL,NULL,NULL,NULL,NULL,NULL),(135,'Linear Technology',NULL,NULL,NULL,NULL,NULL,NULL),(136,'Linfinity Microelectronics',NULL,NULL,NULL,NULL,NULL,NULL),(137,'Lite-On',NULL,NULL,NULL,NULL,NULL,NULL),(138,'Lucent Technologies (AT&T Microelectronics)',NULL,NULL,NULL,NULL,NULL,NULL),(139,'Macronix International',NULL,NULL,NULL,NULL,NULL,NULL),(140,'Marvell Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(141,'Matsushita Panasonic',NULL,NULL,NULL,NULL,NULL,NULL),(142,'Maxim Dallas',NULL,NULL,NULL,NULL,NULL,NULL),(143,'Media Vision',NULL,NULL,NULL,NULL,NULL,NULL),(144,'Microchip (Arizona Michrochip Technology)',NULL,NULL,NULL,NULL,NULL,NULL),(145,'Matra MHS',NULL,NULL,NULL,NULL,NULL,NULL),(146,'Micrel Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(147,'Micronas',NULL,NULL,NULL,NULL,NULL,NULL),(148,'Micronix Integrated Systems',NULL,NULL,NULL,NULL,NULL,NULL),(149,'Micron Technology, Inc.',NULL,NULL,NULL,NULL,NULL,NULL),(150,'Microsemi',NULL,NULL,NULL,NULL,NULL,NULL),(151,'Mini-Circuits',NULL,NULL,NULL,NULL,NULL,NULL),(152,'Mitel Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(153,'Mitsubishi Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(154,'Micro Linear',NULL,NULL,NULL,NULL,NULL,NULL),(155,'MMI (Monolithic Memories, Inc.)',NULL,NULL,NULL,NULL,NULL,NULL),(156,'Mosaic Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(157,'Mosel Vitelic',NULL,NULL,NULL,NULL,NULL,NULL),(158,'MOS Technologies',NULL,NULL,NULL,NULL,NULL,NULL),(159,'Mostek',NULL,NULL,NULL,NULL,NULL,NULL),(160,'MoSys',NULL,NULL,NULL,NULL,NULL,NULL),(161,'Motorola',NULL,NULL,NULL,NULL,NULL,NULL),(162,'Microtune',NULL,NULL,NULL,NULL,NULL,NULL),(163,'M-Systems',NULL,NULL,NULL,NULL,NULL,NULL),(164,'Murata Manufacturing',NULL,NULL,NULL,NULL,NULL,NULL),(165,'MWave (IBM)',NULL,NULL,NULL,NULL,NULL,NULL),(166,'Myson Technology',NULL,NULL,NULL,NULL,NULL,NULL),(167,'NEC Electronics',NULL,NULL,NULL,NULL,NULL,NULL),(168,'NexFlash Technologies',NULL,NULL,NULL,NULL,NULL,NULL),(169,'New Japan Radio',NULL,NULL,NULL,NULL,NULL,NULL),(170,'National Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(171,'NVidia Corporation',NULL,NULL,NULL,NULL,NULL,NULL),(172,'Oak Technology',NULL,NULL,NULL,NULL,NULL,NULL),(173,'Oki Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(174,'Opti',NULL,NULL,NULL,NULL,NULL,NULL),(175,'Orbit Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(176,'Oren Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(177,'Performance Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(178,'Pericom Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(179,'PhaseLink Laboratories',NULL,NULL,NULL,NULL,NULL,NULL),(180,'Philips Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(181,'PLX Technology',NULL,NULL,NULL,NULL,NULL,NULL),(182,'PMC- Sierra',NULL,NULL,NULL,NULL,NULL,NULL),(183,'Precision Monolithics',NULL,NULL,NULL,NULL,NULL,NULL),(184,'Princeton Technology',NULL,NULL,NULL,NULL,NULL,NULL),(185,'PowerSmart',NULL,NULL,NULL,NULL,NULL,NULL),(186,'QuickLogic',NULL,NULL,NULL,NULL,NULL,NULL),(187,'Qlogic',NULL,NULL,NULL,NULL,NULL,NULL),(188,'Quality Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(189,'Rabbit Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(190,'Ramtron International Co.',NULL,NULL,NULL,NULL,NULL,NULL),(191,'Raytheon Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(192,'RCA Solid State',NULL,NULL,NULL,NULL,NULL,NULL),(193,'Realtek Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(194,'Rectron',NULL,NULL,NULL,NULL,NULL,NULL),(195,'Rendition',NULL,NULL,NULL,NULL,NULL,NULL),(196,'Renesas Technology',NULL,NULL,NULL,NULL,NULL,NULL),(197,'Rockwell',NULL,NULL,NULL,NULL,NULL,NULL),(198,'Rohm Corp.',NULL,NULL,NULL,NULL,NULL,NULL),(199,'S3',NULL,NULL,NULL,NULL,NULL,NULL),(200,'Sage',NULL,NULL,NULL,NULL,NULL,NULL),(201,'Saifun Semiconductors Ltd.',NULL,NULL,NULL,NULL,NULL,NULL),(202,'Sames',NULL,NULL,NULL,NULL,NULL,NULL),(203,'Samsung',NULL,NULL,NULL,NULL,NULL,NULL),(204,'Sanken',NULL,NULL,NULL,NULL,NULL,NULL),(205,'Sanyo',NULL,NULL,NULL,NULL,NULL,NULL),(206,'Scenix',NULL,NULL,NULL,NULL,NULL,NULL),(207,'Samsung Electronics',NULL,NULL,NULL,NULL,NULL,NULL),(208,'SEEQ Technology',NULL,NULL,NULL,NULL,NULL,NULL),(209,'Seiko Instruments',NULL,NULL,NULL,NULL,NULL,NULL),(210,'Semtech',NULL,NULL,NULL,NULL,NULL,NULL),(211,'SGS-Ates',NULL,NULL,NULL,NULL,NULL,NULL),(212,'SGS-Thomson Microelectonics ST-M)',NULL,NULL,NULL,NULL,NULL,NULL),(213,'Sharp Microelectronics (USA)',NULL,NULL,NULL,NULL,NULL,NULL),(214,'Shindengen',NULL,NULL,NULL,NULL,NULL,NULL),(215,'Siemens Microelectronics, Inc.',NULL,NULL,NULL,NULL,NULL,NULL),(216,'Sierra',NULL,NULL,NULL,NULL,NULL,NULL),(217,'Sigma Tel',NULL,NULL,NULL,NULL,NULL,NULL),(218,'Signetics',NULL,NULL,NULL,NULL,NULL,NULL),(219,'Silicon Laboratories',NULL,NULL,NULL,NULL,NULL,NULL),(220,'Silicon Magic',NULL,NULL,NULL,NULL,NULL,NULL),(221,'Simtec Corp.',NULL,NULL,NULL,NULL,NULL,NULL),(222,'Siliconix',NULL,NULL,NULL,NULL,NULL,NULL),(223,'Siliconians',NULL,NULL,NULL,NULL,NULL,NULL),(224,'Sipex',NULL,NULL,NULL,NULL,NULL,NULL),(225,'Silicon Integrated Systems',NULL,NULL,NULL,NULL,NULL,NULL),(226,'SMC',NULL,NULL,NULL,NULL,NULL,NULL),(227,'Standard Microsystems',NULL,NULL,NULL,NULL,NULL,NULL),(228,'Sony Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(229,'Space Electronics',NULL,NULL,NULL,NULL,NULL,NULL),(230,'Spectek',NULL,NULL,NULL,NULL,NULL,NULL),(231,'Signal Processing Technologies',NULL,NULL,NULL,NULL,NULL,NULL),(232,'Solid State Scientific',NULL,NULL,NULL,NULL,NULL,NULL),(233,'Silicon Storage Technology (SST)',NULL,NULL,NULL,NULL,NULL,NULL),(234,'STMicroelectronics',NULL,NULL,NULL,NULL,NULL,NULL),(235,'SUMMIT Microelectronics',NULL,NULL,NULL,NULL,NULL,NULL),(236,'Synergy Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(237,'Synertek',NULL,NULL,NULL,NULL,NULL,NULL),(238,'Taiwan Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(239,'TDK Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(240,'Teccor Electronics',NULL,NULL,NULL,NULL,NULL,NULL),(241,'TelCom Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(242,'Teledyne',NULL,NULL,NULL,NULL,NULL,NULL),(243,'Telefunken',NULL,NULL,NULL,NULL,NULL,NULL),(244,'Teltone',NULL,NULL,NULL,NULL,NULL,NULL),(245,'Thomson-CSF',NULL,NULL,NULL,NULL,NULL,NULL),(246,'Texas Instruments',NULL,NULL,NULL,NULL,NULL,NULL),(247,'Toko Amerika',NULL,NULL,NULL,NULL,NULL,NULL),(248,'Toshiba (US)',NULL,NULL,NULL,NULL,NULL,NULL),(249,'Trident',NULL,NULL,NULL,NULL,NULL,NULL),(250,'TriQuint Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(251,'Triscend',NULL,NULL,NULL,NULL,NULL,NULL),(252,'Tseng Labs',NULL,NULL,NULL,NULL,NULL,NULL),(253,'Tundra',NULL,NULL,NULL,NULL,NULL,NULL),(254,'Turbo IC',NULL,NULL,NULL,NULL,NULL,NULL),(255,'Ubicom',NULL,NULL,NULL,NULL,NULL,NULL),(256,'United Microelectronics Corp (UMC)',NULL,NULL,NULL,NULL,NULL,NULL),(257,'Unitrode',NULL,NULL,NULL,NULL,NULL,NULL),(258,'USAR Systems',NULL,NULL,NULL,NULL,NULL,NULL),(259,'United Technologies Microelectronics Center (UTMC)',NULL,NULL,NULL,NULL,NULL,NULL),(260,'Utron',NULL,NULL,NULL,NULL,NULL,NULL),(261,'V3 Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(262,'Vadem',NULL,NULL,NULL,NULL,NULL,NULL),(263,'Vanguard International Semiconductor',NULL,NULL,NULL,NULL,NULL,NULL),(264,'Vantis',NULL,NULL,NULL,NULL,NULL,NULL),(265,'Via Technologies',NULL,NULL,NULL,NULL,NULL,NULL),(266,'Virata',NULL,NULL,NULL,NULL,NULL,NULL),(267,'Vishay',NULL,NULL,NULL,NULL,NULL,NULL),(268,'Vision Tech',NULL,NULL,NULL,NULL,NULL,NULL),(269,'Vitelic',NULL,NULL,NULL,NULL,NULL,NULL),(270,'VLSI Technology',NULL,NULL,NULL,NULL,NULL,NULL),(271,'Volterra',NULL,NULL,NULL,NULL,NULL,NULL),(272,'VTC',NULL,NULL,NULL,NULL,NULL,NULL),(273,'Waferscale Integration (WSI)',NULL,NULL,NULL,NULL,NULL,NULL),(274,'Western Digital',NULL,NULL,NULL,NULL,NULL,NULL),(275,'Weitek',NULL,NULL,NULL,NULL,NULL,NULL),(276,'Winbond',NULL,NULL,NULL,NULL,NULL,NULL),(277,'Wofson Microelectronics',NULL,NULL,NULL,NULL,NULL,NULL),(278,'Xwmics',NULL,NULL,NULL,NULL,NULL,NULL),(279,'Xicor',NULL,NULL,NULL,NULL,NULL,NULL),(280,'Xilinx',NULL,NULL,NULL,NULL,NULL,NULL),(281,'Yamaha',NULL,NULL,NULL,NULL,NULL,NULL),(282,'Zetex Semiconductors',NULL,NULL,NULL,NULL,NULL,NULL),(283,'Zilog',NULL,NULL,NULL,NULL,NULL,NULL),(284,'ZMD (Zentrum Mikroelektronik Dresden)',NULL,NULL,NULL,NULL,NULL,NULL),(285,'Zoran',NULL,NULL,NULL,NULL,NULL,NULL),(286,'Ultimaker BV','Stationsplein 32\n3511 ED Utrecht\nNetherlands','https://ultimaker.com','info@ultimaker.com','','+31 (0) 88 383 4000',''),(287,'Reichelt Elektronik','','https://www.reichelt.de','','','',''),(288,'Creality','18F, JinXiuHongDu Building, Meilong Blvd., Longhua Dist., \nShenzhen, \nChina 518131','https://www.creality.com','info@creality.com','','+86 0755-2107-4150',''),(289,'material4print','','https://material4print.de','','','',''),(290,'Varta','VARTA-Platz 1 \n73479 Ellwangen \nGermany','http://varta.com','info@varta-ag.com','','+49 (0) 7961 921 - 699',''),(291,'Einhell','','','','','',''),(292,'CTC','','','','','','');
/*!40000 ALTER TABLE `Manufacturer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ManufacturerICLogo`
--

DROP TABLE IF EXISTS `ManufacturerICLogo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ManufacturerICLogo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `manufacturer_id` int(11) DEFAULT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `filename` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `originalname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mimetype` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `size` int(11) NOT NULL,
  `extension` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_3F1EF213A23B42D` (`manufacturer_id`),
  CONSTRAINT `FK_3F1EF213A23B42D` FOREIGN KEY (`manufacturer_id`) REFERENCES `Manufacturer` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=347 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ManufacturerICLogo`
--

LOCK TABLES `ManufacturerICLogo` WRITE;
/*!40000 ALTER TABLE `ManufacturerICLogo` DISABLE KEYS */;
INSERT INTO `ManufacturerICLogo` VALUES (1,1,'iclogo','193b9f28-882d-11eb-b8f3-9161441a1192','acer.png','image/png',2195,'png',NULL,'2021-03-18 22:01:24'),(2,2,'iclogo','193c3fb4-882d-11eb-bc44-7403fbe0e726','actel.png','image/png',5003,'png',NULL,'2021-03-18 22:01:24'),(3,3,'iclogo','193c5c6a-882d-11eb-8391-ee6a2a2ad79b','advldev.png','image/png',1835,'png',NULL,'2021-03-18 22:01:24'),(4,4,'iclogo','193c7812-882d-11eb-ae0f-1260628d974a','aeroflex1.png','image/png',9649,'png',NULL,'2021-03-18 22:01:24'),(5,4,'iclogo','193c83c0-882d-11eb-a208-ab698aded5f9','aeroflex2.png','image/png',4562,'png',NULL,'2021-03-18 22:01:24'),(6,5,'iclogo','193c9838-882d-11eb-ac50-a4d00868b655','agilent.png','image/png',5264,'png',NULL,'2021-03-18 22:01:24'),(7,6,'iclogo','193cb16a-882d-11eb-bd31-dd34ef5e9f88','akm.png','image/png',2204,'png',NULL,'2021-03-18 22:01:24'),(8,7,'iclogo','193cc9ac-882d-11eb-bcb5-8fc52e0e1623','alesis.png','image/png',1475,'png',NULL,'2021-03-18 22:01:24'),(9,8,'iclogo','193ce22a-882d-11eb-891c-65bb9d87f35a','ali1.png','image/png',2462,'png',NULL,'2021-03-18 22:01:24'),(10,8,'iclogo','193cec02-882d-11eb-a194-b774fadc32ca','ali2.png','image/png',1784,'png',NULL,'2021-03-18 22:01:24'),(11,9,'iclogo','193d0070-882d-11eb-9129-11060b8a9882','allayer.png','image/png',1869,'png',NULL,'2021-03-18 22:01:24'),(12,10,'iclogo','193d16e6-882d-11eb-9962-5f67506fed06','allegro.png','image/png',1475,'png',NULL,'2021-03-18 22:01:24'),(13,11,'iclogo','193d2d5c-882d-11eb-8d4a-8a7c48318aff','alliance.png','image/png',1949,'png',NULL,'2021-03-18 22:01:24'),(14,12,'iclogo','193d431e-882d-11eb-bef7-dbf4486771cc','alphaind.png','image/png',1403,'png',NULL,'2021-03-18 22:01:24'),(15,13,'iclogo','193d5ac0-882d-11eb-bd8f-a03666134c95','alphamic.png','image/png',2989,'png',NULL,'2021-03-18 22:01:24'),(16,13,'iclogo','193d660a-882d-11eb-a989-85fb3e06761d','alpha.png','image/png',1534,'png',NULL,'2021-03-18 22:01:24'),(17,14,'iclogo','193d7df2-882d-11eb-8ef5-d44aa083ef16','altera.png','image/png',4064,'png',NULL,'2021-03-18 22:01:24'),(18,15,'iclogo','193d9486-882d-11eb-9f35-18ecb5dbf2de','amd.png','image/png',1709,'png',NULL,'2021-03-18 22:01:24'),(19,16,'iclogo','193db7a4-882d-11eb-b71f-be11d00c2b7f','ami1.png','image/png',2399,'png',NULL,'2021-03-18 22:01:24'),(20,16,'iclogo','193dca50-882d-11eb-9fa0-302b7a4b98dc','ami2.png','image/png',1706,'png',NULL,'2021-03-18 22:01:24'),(21,17,'iclogo','193de53a-882d-11eb-8de5-49288d9410cc','amic.png','image/png',2228,'png',NULL,'2021-03-18 22:01:24'),(22,18,'iclogo','193e01e6-882d-11eb-b74e-8390e605bb22','ampus.png','image/png',6150,'png',NULL,'2021-03-18 22:01:24'),(23,19,'iclogo','193e2612-882d-11eb-9bcd-e199d3d29d06','anachip.png','image/png',3549,'png',NULL,'2021-03-18 22:01:24'),(24,20,'iclogo','193e4426-882d-11eb-a6d7-53ac516c12a9','anadigic.png','image/png',5147,'png',NULL,'2021-03-18 22:01:24'),(25,21,'iclogo','193e644c-882d-11eb-b635-318d29656df8','analog1.png','image/png',1262,'png',NULL,'2021-03-18 22:01:24'),(26,21,'iclogo','193e76ee-882d-11eb-9860-36c06930dd7e','analog.png','image/png',1403,'png',NULL,'2021-03-18 22:01:24'),(27,22,'iclogo','193e980e-882d-11eb-b010-744f3495c751','anasys.png','image/png',3309,'png',NULL,'2021-03-18 22:01:24'),(28,23,'iclogo','193eb5f0-882d-11eb-a74c-9c681d9ca1cb','anchorch.png','image/png',1475,'png',NULL,'2021-03-18 22:01:24'),(29,24,'iclogo','193ed8b4-882d-11eb-b03c-43278c6bd539','apex1.png','image/png',2627,'png',NULL,'2021-03-18 22:01:24'),(30,24,'iclogo','193eeb7e-882d-11eb-80a1-c0179b371376','apex.png','image/png',3974,'png',NULL,'2021-03-18 22:01:24'),(31,25,'iclogo','193f2422-882d-11eb-a2a0-8b7007bd8e2d','ark.png','image/png',2089,'png',NULL,'2021-03-18 22:01:24'),(32,26,'iclogo','193f42ea-882d-11eb-96d5-6e9fcc16aea9','asd.png','image/png',5024,'png',NULL,'2021-03-18 22:01:24'),(33,27,'iclogo','193f68ce-882d-11eb-a6d2-e88c5eccd186','astec.png','image/png',3369,'png',NULL,'2021-03-18 22:01:24'),(34,28,'iclogo','193f8408-882d-11eb-8dc7-aec4934925f7','atc.png','image/png',8660,'png',NULL,'2021-03-18 22:01:24'),(35,29,'iclogo','193fa528-882d-11eb-bc47-f097974b6cdd','atecom.png','image/png',1709,'png',NULL,'2021-03-18 22:01:24'),(36,30,'iclogo','193fc648-882d-11eb-966a-495a259c924b','ati.png','image/png',2630,'png',NULL,'2021-03-18 22:01:24'),(37,31,'iclogo','193fe65a-882d-11eb-bad2-27e11b51ad4f','atmel.png','image/png',2843,'png',NULL,'2021-03-18 22:01:24'),(38,32,'iclogo','194007c0-882d-11eb-917e-8a9bf5cb8912','att.png','image/png',2816,'png',NULL,'2021-03-18 22:01:24'),(39,33,'iclogo','194023ea-882d-11eb-8cac-18f0277e854d','audiocod.png','image/png',2429,'png',NULL,'2021-03-18 22:01:24'),(40,34,'iclogo','19404032-882d-11eb-8f6a-7173b20a92b5','auravis.png','image/png',2281,'png',NULL,'2021-03-18 22:01:24'),(41,35,'iclogo','19405bb2-882d-11eb-a048-7bff0707caab','aureal.png','image/png',2109,'png',NULL,'2021-03-18 22:01:24'),(42,36,'iclogo','19407840-882d-11eb-8232-598385232855','austin.png','image/png',2464,'png',NULL,'2021-03-18 22:01:24'),(43,37,'iclogo','194094d8-882d-11eb-a0e3-527391f77345','averlog.png','image/png',1552,'png',NULL,'2021-03-18 22:01:24'),(44,38,'iclogo','1940b1c0-882d-11eb-8253-a9696744e3f8','belfuse.png','image/png',2204,'png',NULL,'2021-03-18 22:01:24'),(45,39,'iclogo','1940cf02-882d-11eb-a07f-27a32fbcdc5f','benchmrq.png','image/png',1370,'png',NULL,'2021-03-18 22:01:24'),(46,40,'iclogo','1940ed3e-882d-11eb-8a2d-5c3803de7ee4','bi.png','image/png',2008,'png',NULL,'2021-03-18 22:01:24'),(47,41,'iclogo','1941081e-882d-11eb-9f24-6f3a36e9f233','bowmar_white.png','image/png',4652,'png',NULL,'2021-03-18 22:01:24'),(48,42,'iclogo','19412808-882d-11eb-897a-032dfa27c829','bright.png','image/png',6839,'png',NULL,'2021-03-18 22:01:24'),(49,43,'iclogo','19414702-882d-11eb-95ca-0a3c7f8bc816','broadcom.png','image/png',6056,'png',NULL,'2021-03-18 22:01:24'),(50,44,'iclogo','19415904-882d-11eb-a090-0dbf981c5193','brooktre.png','image/png',1364,'png',NULL,'2021-03-18 22:01:24'),(51,45,'iclogo','19416c32-882d-11eb-9c39-27db7e9b6086','burrbrwn.png','image/png',3563,'png',NULL,'2021-03-18 22:01:24'),(52,46,'iclogo','19418776-882d-11eb-910f-a15def99770a','calmicro.png','image/png',2109,'png',NULL,'2021-03-18 22:01:24'),(53,47,'iclogo','1941a51c-882d-11eb-a70e-0f8cfd5c9b7b','calogic.png','image/png',3367,'png',NULL,'2021-03-18 22:01:24'),(54,48,'iclogo','1941c092-882d-11eb-9944-a1ca95bf5421','catalys1.png','image/png',1922,'png',NULL,'2021-03-18 22:01:24'),(55,48,'iclogo','1941d1b8-882d-11eb-bf89-4b2ac32fafe3','catalyst.png','image/png',2228,'png',NULL,'2021-03-18 22:01:24'),(56,49,'iclogo','1941f63e-882d-11eb-abcf-9cf1fa56a944','ccube.png','image/png',1309,'png',NULL,'2021-03-18 22:01:24'),(57,50,'iclogo','19421254-882d-11eb-9af2-da3185c29bd0','ceramate1.png','image/png',2917,'png',NULL,'2021-03-18 22:01:24'),(58,50,'iclogo','1942244c-882d-11eb-9a6c-51542e7ee15b','ceramate2.png','image/png',2917,'png',NULL,'2021-03-18 22:01:24'),(59,51,'iclogo','19423e82-882d-11eb-af8f-4c853cb2afe7','cherry.png','image/png',2507,'png',NULL,'2021-03-18 22:01:24'),(60,52,'iclogo','19425a0c-882d-11eb-92a7-d67989b8abfc','chipcon1.png','image/png',8655,'png',NULL,'2021-03-18 22:01:24'),(61,52,'iclogo','194270b4-882d-11eb-8c72-0b761ef49eb3','chipcon2.png','image/png',2923,'png',NULL,'2021-03-18 22:01:24'),(62,53,'iclogo','19428482-882d-11eb-9bc3-53923bd3d87a','chips.png','image/png',2864,'png',NULL,'2021-03-18 22:01:24'),(63,54,'iclogo','19429e90-882d-11eb-b7cc-6ee6a6096f81','chrontel.png','image/png',1476,'png',NULL,'2021-03-18 22:01:24'),(64,55,'iclogo','1942b8d0-882d-11eb-a2f5-e5ea795991c0','cirrus.png','image/png',3218,'png',NULL,'2021-03-18 22:01:24'),(65,56,'iclogo','1942d518-882d-11eb-9e98-9610ac8e223d','comcore.png','image/png',1709,'png',NULL,'2021-03-18 22:01:24'),(66,57,'iclogo','1942e95e-882d-11eb-8ee8-d882d2185ca4','conexant.png','image/png',2051,'png',NULL,'2021-03-18 22:01:24'),(67,58,'iclogo','1942fd4a-882d-11eb-ade6-37c874e7fe30','cosmo.png','image/png',1709,'png',NULL,'2021-03-18 22:01:24'),(68,59,'iclogo','19431136-882d-11eb-900c-1209c9e44022','crystal.png','image/png',3605,'png',NULL,'2021-03-18 22:01:24'),(69,60,'iclogo','19432d88-882d-11eb-a1cc-727f7610ab52','cygnal.png','image/png',2135,'png',NULL,'2021-03-18 22:01:24'),(70,61,'iclogo','1943470a-882d-11eb-b56d-921a311ca88a','cypres1.png','image/png',2504,'png',NULL,'2021-03-18 22:01:24'),(71,61,'iclogo','19434fa2-882d-11eb-9824-aa1fc4a310ee','cypress.png','image/png',4275,'png',NULL,'2021-03-18 22:01:24'),(72,62,'iclogo','19436302-882d-11eb-a9fe-4920873c0406','cyrix.png','image/png',2204,'png',NULL,'2021-03-18 22:01:24'),(73,63,'iclogo','1943764e-882d-11eb-a068-422bd7e57590','daewoo.png','image/png',1907,'png',NULL,'2021-03-18 22:01:24'),(74,64,'iclogo','1943892c-882d-11eb-979d-f8cde53da4cf','dallas1.png','image/png',1469,'png',NULL,'2021-03-18 22:01:24'),(75,64,'iclogo','194391ec-882d-11eb-9c11-71000c1ab36e','dallas2.png','image/png',1309,'png',NULL,'2021-03-18 22:01:24'),(76,64,'iclogo','194398f4-882d-11eb-9618-ddfb719b1a19','dallas3.png','image/png',1869,'png',NULL,'2021-03-18 22:01:24'),(77,65,'iclogo','1943ab1e-882d-11eb-aec8-4426f5cad604','davicom.png','image/png',4589,'png',NULL,'2021-03-18 22:01:24'),(78,66,'iclogo','1943ca0e-882d-11eb-906e-8cf61bd5e93b','ddd.png','image/png',3235,'png',NULL,'2021-03-18 22:01:24'),(79,67,'iclogo','1943dc7e-882d-11eb-a96c-043c8c71e5bf','diamond.png','image/png',2504,'png',NULL,'2021-03-18 22:01:24'),(80,68,'iclogo','1943ed40-882d-11eb-83c4-b4453e9d9f46','diotec.png','image/png',1454,'png',NULL,'2021-03-18 22:01:24'),(81,69,'iclogo','1943fefc-882d-11eb-ae2d-dfdfcad7cf7f','dtc1.png','image/png',2513,'png',NULL,'2021-03-18 22:01:24'),(82,69,'iclogo','19440b36-882d-11eb-9b3e-0d7e01628fe0','dtc2.png','image/png',1670,'png',NULL,'2021-03-18 22:01:24'),(83,70,'iclogo','194420c6-882d-11eb-a935-9403dbb64059','dvdo.png','image/png',2357,'png',NULL,'2021-03-18 22:01:24'),(84,71,'iclogo','194432dc-882d-11eb-94d0-4f2ae0b6c3af','egg.png','image/png',1628,'png',NULL,'2021-03-18 22:01:24'),(85,72,'iclogo','19444682-882d-11eb-beb0-a506c79e0c64','elan.png','image/png',13826,'png',NULL,'2021-03-18 22:01:24'),(86,73,'iclogo','19445cc6-882d-11eb-8174-918e1653a55b','elantec1.png','image/png',1400,'png',NULL,'2021-03-18 22:01:24'),(87,73,'iclogo','194464dc-882d-11eb-aa53-932810d7a266','elantec.png','image/png',3274,'png',NULL,'2021-03-18 22:01:24'),(88,74,'iclogo','1944765c-882d-11eb-a89d-261e19ae3fc8','elec_arrays.png','image/png',5602,'png',NULL,'2021-03-18 22:01:24'),(89,75,'iclogo','194489e4-882d-11eb-8b20-fd62a1468d85','elite[1].png','image/png',8285,'png',NULL,'2021-03-18 22:01:24'),(90,76,'iclogo','19449d62-882d-11eb-b158-ce48cd9c706f','emmicro.png','image/png',3599,'png',NULL,'2021-03-18 22:01:24'),(91,77,'iclogo','1944b450-882d-11eb-bb44-ec653fb071a9','enhmemsy.png','image/png',1403,'png',NULL,'2021-03-18 22:01:24'),(92,78,'iclogo','1944c9d6-882d-11eb-af27-52de412f426f','ensoniq.png','image/png',3557,'png',NULL,'2021-03-18 22:01:24'),(93,79,'iclogo','1944ddc2-882d-11eb-82e5-31f52a9e25b0','eon.png','image/png',5393,'png',NULL,'2021-03-18 22:01:24'),(94,80,'iclogo','1944f096-882d-11eb-80f1-f39d7f8036ef','epson1.png','image/png',2349,'png',NULL,'2021-03-18 22:01:24'),(95,80,'iclogo','1944f87a-882d-11eb-8f27-1c3164f861fa','epson2.png','image/png',2405,'png',NULL,'2021-03-18 22:01:24'),(96,81,'iclogo','194509be-882d-11eb-a937-9010be86561f','ericsson.png','image/png',4184,'png',NULL,'2021-03-18 22:01:24'),(97,82,'iclogo','1945208e-882d-11eb-a787-3246dc99abb3','ess.png','image/png',3030,'png',NULL,'2021-03-18 22:01:24'),(98,83,'iclogo','19453326-882d-11eb-be6b-53ee946eaac8','etc.png','image/png',2189,'png',NULL,'2021-03-18 22:01:24'),(99,84,'iclogo','1945455a-882d-11eb-9f9d-dc1805d96d92','exar.png','image/png',2771,'png',NULL,'2021-03-18 22:01:24'),(100,85,'iclogo','19455630-882d-11eb-b009-31f2076bb78b','excelsemi1.png','image/png',7632,'png',NULL,'2021-03-18 22:01:24'),(101,85,'iclogo','19455edc-882d-11eb-9aed-5a81baf4bed4','excelsemi2.png','image/png',2339,'png',NULL,'2021-03-18 22:01:24'),(102,85,'iclogo','1945659e-882d-11eb-8477-67e1b7f78776','exel.png','image/png',2771,'png',NULL,'2021-03-18 22:01:24'),(103,86,'iclogo','19457868-882d-11eb-8f3a-91e3cc5da047','fairchil.png','image/png',1552,'png',NULL,'2021-03-18 22:01:24'),(104,87,'iclogo','19458a6a-882d-11eb-b88e-4091099a5d6d','freescale.png','image/png',3840,'png',NULL,'2021-03-18 22:01:24'),(105,88,'iclogo','19459b2c-882d-11eb-b4c0-2904dd6fa470','fujielec.png','image/png',5048,'png',NULL,'2021-03-18 22:01:24'),(106,88,'iclogo','1945a36a-882d-11eb-900c-20b92ee87339','fujitsu2.png','image/png',1860,'png',NULL,'2021-03-18 22:01:24'),(107,89,'iclogo','1945b45e-882d-11eb-8056-886cde61ebd8','galileo.png','image/png',3779,'png',NULL,'2021-03-18 22:01:24'),(108,90,'iclogo','1945c516-882d-11eb-9f48-78b98923762f','galvant.png','image/png',2669,'png',NULL,'2021-03-18 22:01:24'),(109,91,'iclogo','1945da10-882d-11eb-9d95-aa99835cfadf','gecples.png','image/png',2312,'png',NULL,'2021-03-18 22:01:24'),(110,92,'iclogo','1945ed98-882d-11eb-b822-78626fb674e1','gennum.png','image/png',2614,'png',NULL,'2021-03-18 22:01:24'),(111,93,'iclogo','19460076-882d-11eb-9d27-d17a65bff37a','ge.png','image/png',2321,'png',NULL,'2021-03-18 22:01:24'),(112,94,'iclogo','194612a0-882d-11eb-b490-a72771beb416','gi1.png','image/png',1385,'png',NULL,'2021-03-18 22:01:24'),(113,94,'iclogo','19461bc4-882d-11eb-93a3-0e777acddf9b','gi.png','image/png',1691,'png',NULL,'2021-03-18 22:01:24'),(114,95,'iclogo','19462cd6-882d-11eb-ada1-e7975a701396','glink.png','image/png',1706,'png',NULL,'2021-03-18 22:01:24'),(115,96,'iclogo','19464036-882d-11eb-b304-ae5d314e2806','goal1.png','image/png',9092,'png',NULL,'2021-03-18 22:01:24'),(116,96,'iclogo','19464a68-882d-11eb-9f8a-cc713155de16','goal2.png','image/png',9649,'png',NULL,'2021-03-18 22:01:24'),(117,97,'iclogo','19465bac-882d-11eb-b40f-0fb6f6730b72','goldstar1.png','image/png',2923,'png',NULL,'2021-03-18 22:01:24'),(118,97,'iclogo','19466476-882d-11eb-921d-b060ec8d5334','goldstar2.png','image/png',11387,'png',NULL,'2021-03-18 22:01:24'),(119,98,'iclogo','1946797a-882d-11eb-a043-5afb2eb647db','gould.png','image/png',1549,'png',NULL,'2021-03-18 22:01:24'),(120,99,'iclogo','19468b5e-882d-11eb-81a8-8e6686bfe84c','greenwich.png','image/png',9761,'png',NULL,'2021-03-18 22:01:24'),(121,100,'iclogo','19469f72-882d-11eb-9bc3-7e09fd78eeea','gsemi.png','image/png',1704,'png',NULL,'2021-03-18 22:01:24'),(122,101,'iclogo','1946b246-882d-11eb-a9fb-3668ac20fb3c','harris1.png','image/png',1549,'png',NULL,'2021-03-18 22:01:24'),(123,101,'iclogo','1946ba7a-882d-11eb-b0f9-caffa7efe49f','harris2.png','image/png',1874,'png',NULL,'2021-03-18 22:01:24'),(124,102,'iclogo','1946ce70-882d-11eb-bdcb-a5c25105c519','hfo.png','image/png',1958,'png',NULL,'2021-03-18 22:01:24'),(125,103,'iclogo','1946e0c2-882d-11eb-ad57-7aaa64fac1af','hitachi.png','image/png',2611,'png',NULL,'2021-03-18 22:01:24'),(126,104,'iclogo','1946f332-882d-11eb-b904-cfeacc245975','holtek.png','image/png',2160,'png',NULL,'2021-03-18 22:01:24'),(127,105,'iclogo','194704d0-882d-11eb-bf4d-828a0cbcc55e','hp.png','image/png',2464,'png',NULL,'2021-03-18 22:01:24'),(128,106,'iclogo','19471808-882d-11eb-935a-8eca9bb38141','hualon.png','image/png',2864,'png',NULL,'2021-03-18 22:01:24'),(129,107,'iclogo','19472a14-882d-11eb-a273-3005c10d785f','hynix.png','image/png',8444,'png',NULL,'2021-03-18 22:01:24'),(130,108,'iclogo','19473ebe-882d-11eb-ae72-afd6965360b1','hyundai2.png','image/png',2269,'png',NULL,'2021-03-18 22:01:24'),(131,109,'iclogo','19475408-882d-11eb-a864-f21f31f92451','icdesign.png','image/png',3014,'png',NULL,'2021-03-18 22:01:24'),(132,110,'iclogo','19476a74-882d-11eb-8642-94513c23673d','icd.png','image/png',1641,'png',NULL,'2021-03-18 22:01:24'),(133,110,'iclogo','19477528-882d-11eb-b44c-c2cf088e27aa','ics.png','image/png',2042,'png',NULL,'2021-03-18 22:01:24'),(134,111,'iclogo','1947873e-882d-11eb-9544-6f9003788234','ichaus1.png','image/png',3370,'png',NULL,'2021-03-18 22:01:24'),(135,111,'iclogo','19478f22-882d-11eb-a98d-8ef7c3569ed0','ichaus.png','image/png',1552,'png',NULL,'2021-03-18 22:01:24'),(136,112,'iclogo','1947a228-882d-11eb-a849-8096cf5caf0e','icsi.png','image/png',4049,'png',NULL,'2021-03-18 22:01:24'),(137,113,'iclogo','1947b48e-882d-11eb-817f-d5ff76e2cb44','icube.png','image/png',1629,'png',NULL,'2021-03-18 22:01:24'),(138,114,'iclogo','1947c6ae-882d-11eb-a2d8-94b01679c1e1','icworks.png','image/png',1874,'png',NULL,'2021-03-18 22:01:24'),(139,115,'iclogo','1947d7ac-882d-11eb-bbbc-01b85f57721b','idt1.png','image/png',3995,'png',NULL,'2021-03-18 22:01:24'),(140,115,'iclogo','1947df7c-882d-11eb-baa9-0bc04255ce1d','idt.png','image/png',1553,'png',NULL,'2021-03-18 22:01:24'),(141,116,'iclogo','1947f264-882d-11eb-ae7b-0ca9d817f711','igstech.png','image/png',3832,'png',NULL,'2021-03-18 22:01:24'),(142,117,'iclogo','194803d0-882d-11eb-ab22-c0ca98cb1337','impala.png','image/png',1628,'png',NULL,'2021-03-18 22:01:24'),(143,118,'iclogo','1948158c-882d-11eb-bb98-f910194c6848','imp.png','image/png',2175,'png',NULL,'2021-03-18 22:01:24'),(144,119,'iclogo','194826b2-882d-11eb-b3a1-c93fa74c0a55','infineon.png','image/png',4511,'png',NULL,'2021-03-18 22:01:24'),(145,120,'iclogo','19483788-882d-11eb-8cb8-15069bd1a4fe','inmos.png','image/png',3365,'png',NULL,'2021-03-18 22:01:24'),(146,121,'iclogo','19484d22-882d-11eb-9630-a62aa3c8adf3','intel2.png','image/png',2010,'png',NULL,'2021-03-18 22:01:24'),(147,122,'iclogo','19485f1a-882d-11eb-aac5-c58d0556e7df','intresil4.png','image/png',2614,'png',NULL,'2021-03-18 22:01:24'),(148,122,'iclogo','194867b2-882d-11eb-bd65-1124e3eb4772','intrsil1.png','image/png',1874,'png',NULL,'2021-03-18 22:01:24'),(149,122,'iclogo','19487108-882d-11eb-9b9b-c95a8de73b3f','intrsil2.png','image/png',2520,'png',NULL,'2021-03-18 22:01:24'),(150,122,'iclogo','194878a6-882d-11eb-b71c-fd9ac815ac59','intrsil3.png','image/png',3295,'png',NULL,'2021-03-18 22:01:24'),(151,123,'iclogo','19488b8e-882d-11eb-bb5a-3e02231b34cf','ir.png','image/png',2729,'png',NULL,'2021-03-18 22:01:24'),(152,124,'iclogo','1948a024-882d-11eb-af3f-93f07a1ad038','isd.png','image/png',2554,'png',NULL,'2021-03-18 22:01:24'),(153,125,'iclogo','1948b294-882d-11eb-8001-e92b8fb667d7','issi.png','image/png',3030,'png',NULL,'2021-03-18 22:01:24'),(154,126,'iclogo','1948c50e-882d-11eb-80ae-7d00694d232c','ite.png','image/png',3302,'png',NULL,'2021-03-18 22:01:24'),(155,127,'iclogo','1948d8f0-882d-11eb-b654-1d3abe7820d8','itt.png','image/png',2483,'png',NULL,'2021-03-18 22:01:24'),(156,128,'iclogo','1948ec00-882d-11eb-bf73-349a553f5734','ixys.png','image/png',3575,'png',NULL,'2021-03-18 22:01:24'),(157,129,'iclogo','1948fe02-882d-11eb-aa87-049d68f8de42','kec.png','image/png',2567,'png',NULL,'2021-03-18 22:01:24'),(158,130,'iclogo','19490f8c-882d-11eb-8c5e-f45c97825164','kota.png','image/png',1552,'png',NULL,'2021-03-18 22:01:24'),(159,131,'iclogo','1949229c-882d-11eb-9ed8-27804c41dd4c','lattice1.png','image/png',1768,'png',NULL,'2021-03-18 22:01:24'),(160,131,'iclogo','19492a6c-882d-11eb-9c74-0a4dac141b06','lattice2.png','image/png',1519,'png',NULL,'2021-03-18 22:01:24'),(161,131,'iclogo','194931a6-882d-11eb-893f-34a5702c87b0','lattice3.png','image/png',1216,'png',NULL,'2021-03-18 22:01:24'),(162,132,'iclogo','1949436c-882d-11eb-8a34-0e13c478ed8e','lds1.png','image/png',2136,'png',NULL,'2021-03-18 22:01:24'),(163,132,'iclogo','19494baa-882d-11eb-83f3-883b969ffee8','lds.png','image/png',1959,'png',NULL,'2021-03-18 22:01:24'),(164,133,'iclogo','19495e60-882d-11eb-add0-e34ade2b1db0','levone.png','image/png',4189,'png',NULL,'2021-03-18 22:01:24'),(165,134,'iclogo','1949718e-882d-11eb-9d6d-f521b5757b6f','lgs1.png','image/png',2417,'png',NULL,'2021-03-18 22:01:24'),(166,134,'iclogo','194979b8-882d-11eb-8891-e333643df720','lgs.png','image/png',737,'png',NULL,'2021-03-18 22:01:24'),(167,135,'iclogo','19498ea8-882d-11eb-a43e-3ad70d637d57','linear.png','image/png',2486,'png',NULL,'2021-03-18 22:01:24'),(168,136,'iclogo','1949a0e6-882d-11eb-8892-1871c004bc3d','linfin.png','image/png',4844,'png',NULL,'2021-03-18 22:01:24'),(169,137,'iclogo','1949b266-882d-11eb-8ebf-cfe2c405a118','liteon.png','image/png',2388,'png',NULL,'2021-03-18 22:01:24'),(170,138,'iclogo','1949c6ac-882d-11eb-9b67-623aec952484','lucent.png','image/png',1709,'png',NULL,'2021-03-18 22:01:24'),(171,139,'iclogo','1949daf2-882d-11eb-ba56-ca8b40b58c8d','macronix.png','image/png',2324,'png',NULL,'2021-03-18 22:01:24'),(172,140,'iclogo','1949ed58-882d-11eb-9c62-7d1f86b86635','marvell.png','image/png',3131,'png',NULL,'2021-03-18 22:01:24'),(173,141,'iclogo','1949fdfc-882d-11eb-b8d4-0ef12844353f','matsush1.png','image/png',1709,'png',NULL,'2021-03-18 22:01:24'),(174,141,'iclogo','194a0694-882d-11eb-a7bb-85c7f824497a','matsushi.png','image/png',2029,'png',NULL,'2021-03-18 22:01:24'),(175,142,'iclogo','194a1968-882d-11eb-a8f6-8e1070a62bfe','maxim.png','image/png',2690,'png',NULL,'2021-03-18 22:01:24'),(176,143,'iclogo','194a316e-882d-11eb-86db-5269adcf827f','mediavi1.png','image/png',2189,'png',NULL,'2021-03-18 22:01:24'),(177,143,'iclogo','194a39c0-882d-11eb-b27a-0b27fd9cd940','mediavi2.png','image/png',2487,'png',NULL,'2021-03-18 22:01:24'),(178,144,'iclogo','194a4e9c-882d-11eb-8a43-c810e34f2e70','me.png','image/png',2411,'png',NULL,'2021-03-18 22:01:24'),(179,144,'iclogo','194a5888-882d-11eb-8845-22b874e8161c','microchp.png','image/png',2814,'png',NULL,'2021-03-18 22:01:24'),(180,145,'iclogo','194a6c24-882d-11eb-84d4-f4e42a70a925','mhs2.png','image/png',2036,'png',NULL,'2021-03-18 22:01:24'),(181,145,'iclogo','194a7714-882d-11eb-95c6-ca07351b286d','mhs.png','image/png',1870,'png',NULL,'2021-03-18 22:01:24'),(182,146,'iclogo','194a8b50-882d-11eb-8569-335e895340d8','micrel1.png','image/png',9695,'png',NULL,'2021-03-18 22:01:24'),(183,146,'iclogo','194a95c8-882d-11eb-9c99-21ff524a3279','micrel2.png','image/png',9695,'png',NULL,'2021-03-18 22:01:24'),(184,147,'iclogo','194aa810-882d-11eb-8a46-4bda847ac941','micronas.png','image/png',1871,'png',NULL,'2021-03-18 22:01:24'),(185,148,'iclogo','194abb2a-882d-11eb-a6e9-bef9d23c880a','micronix.png','image/png',1856,'png',NULL,'2021-03-18 22:01:24'),(186,149,'iclogo','194ace6c-882d-11eb-bdd3-3d90dd555f2e','micron.png','image/png',1763,'png',NULL,'2021-03-18 22:01:24'),(187,150,'iclogo','194ae30c-882d-11eb-a8de-97bb10b24879','microsemi1.png','image/png',3714,'png',NULL,'2021-03-18 22:01:24'),(188,150,'iclogo','194aeb4a-882d-11eb-83cf-72a0e67c7360','microsemi2.png','image/png',11992,'png',NULL,'2021-03-18 22:01:24'),(189,151,'iclogo','194afefa-882d-11eb-961f-55060582ea32','minicirc.png','image/png',1391,'png',NULL,'2021-03-18 22:01:24'),(190,152,'iclogo','194b0fbc-882d-11eb-8c26-a4a89972a7a9','mitel.png','image/png',2819,'png',NULL,'2021-03-18 22:01:24'),(191,153,'iclogo','194b2286-882d-11eb-949d-88abbf34d987','mitsubis.png','image/png',2311,'png',NULL,'2021-03-18 22:01:24'),(192,154,'iclogo','194b3370-882d-11eb-80bc-fd5b3f0952a1','mlinear.png','image/png',3377,'png',NULL,'2021-03-18 22:01:24'),(193,155,'iclogo','194b448c-882d-11eb-b592-b5d8b1a6f6f2','mmi.png','image/png',2692,'png',NULL,'2021-03-18 22:01:24'),(194,156,'iclogo','194b58e6-882d-11eb-b9ef-490e30c783de','mosaic.png','image/png',2959,'png',NULL,'2021-03-18 22:01:24'),(195,157,'iclogo','194b6caa-882d-11eb-883d-145e3f9cbf60','moselvit.png','image/png',2504,'png',NULL,'2021-03-18 22:01:24'),(196,158,'iclogo','194b7f24-882d-11eb-809d-2209b5e226db','mos.png','image/png',2857,'png',NULL,'2021-03-18 22:01:24'),(197,159,'iclogo','194b91f8-882d-11eb-a6ed-74b0c3b6d08f','mostek1.png','image/png',7502,'png',NULL,'2021-03-18 22:01:24'),(198,159,'iclogo','194b9ab8-882d-11eb-b941-9ef652ab5f12','mostek2.png','image/png',7502,'png',NULL,'2021-03-18 22:01:24'),(199,159,'iclogo','194ba224-882d-11eb-84f0-afcc84e7f1af','mostek3.png','image/png',2514,'png',NULL,'2021-03-18 22:01:24'),(200,160,'iclogo','194bb408-882d-11eb-bb07-66cce40a7547','mosys.png','image/png',2321,'png',NULL,'2021-03-18 22:01:24'),(201,161,'iclogo','194bc736-882d-11eb-a8e0-19d9d7a312f5','motorol1.png','image/png',999,'png',NULL,'2021-03-18 22:01:24'),(202,161,'iclogo','194bcf7e-882d-11eb-a54d-73b987c0daad','motorol2.png','image/png',2417,'png',NULL,'2021-03-18 22:01:24'),(203,162,'iclogo','194bdfc8-882d-11eb-a870-ddaacd637807','mpd.png','image/png',2663,'png',NULL,'2021-03-18 22:01:24'),(204,163,'iclogo','194bf95e-882d-11eb-99c9-35bbb9aab1fb','msystem.png','image/png',1670,'png',NULL,'2021-03-18 22:01:24'),(205,164,'iclogo','194c11e6-882d-11eb-9e29-167178d5f656','murata1.png','image/png',4874,'png',NULL,'2021-03-18 22:01:24'),(206,164,'iclogo','194c1bf0-882d-11eb-beb2-cab7aba0dc78','murata.png','image/png',4777,'png',NULL,'2021-03-18 22:01:24'),(207,165,'iclogo','194c2fe6-882d-11eb-9cd5-5dfa2e3f6c3a','mwave.png','image/png',3370,'png',NULL,'2021-03-18 22:01:24'),(208,166,'iclogo','194c4404-882d-11eb-b15c-617e3eb99360','myson.png','image/png',1932,'png',NULL,'2021-03-18 22:01:24'),(209,167,'iclogo','194c5700-882d-11eb-a71f-29bc206d21c5','nec1.png','image/png',3166,'png',NULL,'2021-03-18 22:01:24'),(210,167,'iclogo','194c61b4-882d-11eb-a1da-c5b8f41b5118','nec2.png','image/png',3071,'png',NULL,'2021-03-18 22:01:24'),(211,168,'iclogo','194c73de-882d-11eb-b192-421b542cee3c','nexflash.png','image/png',7789,'png',NULL,'2021-03-18 22:01:24'),(212,169,'iclogo','194c8720-882d-11eb-865e-3dcf8b228c69','njr.png','image/png',3419,'png',NULL,'2021-03-18 22:01:24'),(213,170,'iclogo','194c9a1c-882d-11eb-8893-e37aeaebe837','ns1.png','image/png',1959,'png',NULL,'2021-03-18 22:01:24'),(214,170,'iclogo','194ca41c-882d-11eb-a25e-b48e55e07cad','ns2.png','image/png',1952,'png',NULL,'2021-03-18 22:01:24'),(215,171,'iclogo','194cb664-882d-11eb-b266-98d78e56611d','nvidia.png','image/png',1874,'png',NULL,'2021-03-18 22:01:24'),(216,172,'iclogo','194ccfb4-882d-11eb-9b3e-757a8ca77525','oak.png','image/png',2614,'png',NULL,'2021-03-18 22:01:24'),(217,173,'iclogo','194ce1de-882d-11eb-afce-b25d851ad169','oki1.png','image/png',2267,'png',NULL,'2021-03-18 22:01:24'),(218,173,'iclogo','194cea62-882d-11eb-b077-adea396fc052','oki.png','image/png',2546,'png',NULL,'2021-03-18 22:01:24'),(219,174,'iclogo','194cfbce-882d-11eb-95b4-06d14376f527','opti.png','image/png',1684,'png',NULL,'2021-03-18 22:01:24'),(220,175,'iclogo','194d0c5e-882d-11eb-85c5-4b00938e2e84','orbit.png','image/png',3347,'png',NULL,'2021-03-18 22:01:24'),(221,176,'iclogo','194d1e7e-882d-11eb-90dc-aaa6b070efb0','oren.png','image/png',3497,'png',NULL,'2021-03-18 22:01:24'),(222,177,'iclogo','194d30b2-882d-11eb-9722-7e79b4bc8d23','perform.png','image/png',3284,'png',NULL,'2021-03-18 22:01:24'),(223,178,'iclogo','194d42e6-882d-11eb-96cb-7e9cd4c1b81e','pericom.png','image/png',2311,'png',NULL,'2021-03-18 22:01:24'),(224,179,'iclogo','194d54d4-882d-11eb-8e23-daeb39e9327b','phaslink.png','image/png',2669,'png',NULL,'2021-03-18 22:01:24'),(225,180,'iclogo','194d6762-882d-11eb-b98a-ce0c27d80580','philips.png','image/png',8690,'png',NULL,'2021-03-18 22:01:24'),(226,181,'iclogo','194d7928-882d-11eb-a704-57853474bbd5','plx.png','image/png',4749,'png',NULL,'2021-03-18 22:01:24'),(227,182,'iclogo','194d89b8-882d-11eb-882e-22393fea8a56','pmc.png','image/png',3497,'png',NULL,'2021-03-18 22:01:24'),(228,183,'iclogo','194d9d18-882d-11eb-8cef-5c396ede94c7','pmi.png','image/png',3807,'png',NULL,'2021-03-18 22:01:24'),(229,184,'iclogo','194db172-882d-11eb-8bdf-5428fbee4728','ptc.png','image/png',2669,'png',NULL,'2021-03-18 22:01:24'),(230,185,'iclogo','194dc360-882d-11eb-9eff-282f4da1e858','pwrsmart.png','image/png',1389,'png',NULL,'2021-03-18 22:01:24'),(231,186,'iclogo','194dd4c2-882d-11eb-b251-7f642022e0d4','qlogic.png','image/png',1709,'png',NULL,'2021-03-18 22:01:24'),(232,187,'iclogo','194de6ec-882d-11eb-909c-f50bbf6494e8','qualcomm.png','image/png',3326,'png',NULL,'2021-03-18 22:01:24'),(233,188,'iclogo','194df79a-882d-11eb-8d3f-7856f212920d','quality.png','image/png',1309,'png',NULL,'2021-03-18 22:01:24'),(234,189,'iclogo','194e0924-882d-11eb-99a5-66374489a667','rabbit.png','image/png',2857,'png',NULL,'2021-03-18 22:01:24'),(235,190,'iclogo','194e19dc-882d-11eb-af80-23fd07561de0','ramtron.png','image/png',1573,'png',NULL,'2021-03-18 22:01:24'),(236,191,'iclogo','194e2a1c-882d-11eb-b78b-6ee247fa77f7','raytheon.png','image/png',4303,'png',NULL,'2021-03-18 22:01:24'),(237,192,'iclogo','194e3cdc-882d-11eb-9446-f944d4f4df76','rca.png','image/png',1860,'png',NULL,'2021-03-18 22:01:24'),(238,193,'iclogo','194e4d62-882d-11eb-8853-3549801517b7','realtek.png','image/png',2993,'png',NULL,'2021-03-18 22:01:24'),(239,194,'iclogo','194e5ece-882d-11eb-a3b5-2962a425cbd6','rectron.png','image/png',1691,'png',NULL,'2021-03-18 22:01:24'),(240,195,'iclogo','194e718e-882d-11eb-990d-1498e0d77057','rendit.png','image/png',1370,'png',NULL,'2021-03-18 22:01:24'),(241,196,'iclogo','194e81c4-882d-11eb-a166-360fa58be4df','renesas.png','image/png',8761,'png',NULL,'2021-03-18 22:01:24'),(242,197,'iclogo','194e9312-882d-11eb-9d74-325d5157f835','rockwell.png','image/png',1704,'png',NULL,'2021-03-18 22:01:24'),(243,198,'iclogo','194ea4d8-882d-11eb-a7c1-285feb744900','rohm.png','image/png',2693,'png',NULL,'2021-03-18 22:01:24'),(244,199,'iclogo','194eb590-882d-11eb-9425-d9a1dc61199b','s3.png','image/png',2189,'png',NULL,'2021-03-18 22:01:24'),(245,200,'iclogo','194ec706-882d-11eb-8976-76d340522979','sage.png','image/png',2735,'png',NULL,'2021-03-18 22:01:24'),(246,201,'iclogo','194ed890-882d-11eb-a026-d29465e79e0c','saifun.png','image/png',19242,'png',NULL,'2021-03-18 22:01:24'),(247,202,'iclogo','194eebdc-882d-11eb-b7d0-717e3cbd0423','sames.png','image/png',2614,'png',NULL,'2021-03-18 22:01:24'),(248,203,'iclogo','194efc9e-882d-11eb-94a7-425a50bdacf2','samsung.png','image/png',1841,'png',NULL,'2021-03-18 22:01:24'),(249,204,'iclogo','194f0e14-882d-11eb-a9fb-85929aeb0b34','sanken1.png','image/png',2214,'png',NULL,'2021-03-18 22:01:24'),(250,204,'iclogo','194f1634-882d-11eb-a2a9-18967b81332f','sanken.png','image/png',5309,'png',NULL,'2021-03-18 22:01:24'),(251,205,'iclogo','194f25ac-882d-11eb-a5c4-79a975db8fb2','sanyo1.png','image/png',2228,'png',NULL,'2021-03-18 22:01:24'),(252,205,'iclogo','194f2de0-882d-11eb-aa2d-d86be7b78813','sanyo.png','image/png',2455,'png',NULL,'2021-03-18 22:01:24'),(253,206,'iclogo','194f3ee8-882d-11eb-9b6a-590b40766d43','scenix.png','image/png',1869,'png',NULL,'2021-03-18 22:01:24'),(254,207,'iclogo','194f4f6e-882d-11eb-814f-ec4d3107f08c','sec1.png','image/png',9392,'png',NULL,'2021-03-18 22:01:24'),(255,207,'iclogo','194f5856-882d-11eb-b5e9-295ea1b56c68','sec.png','image/png',2051,'png',NULL,'2021-03-18 22:01:24'),(256,208,'iclogo','194f6850-882d-11eb-811e-610d919a680b','seeq.png','image/png',2903,'png',NULL,'2021-03-18 22:01:24'),(257,209,'iclogo','194f79a8-882d-11eb-b0d8-63c4c9512eb9','seikoi.png','image/png',1709,'png',NULL,'2021-03-18 22:01:24'),(258,209,'iclogo','194f81a0-882d-11eb-a6a3-efefb4112603','semelab.png','image/png',1709,'png',NULL,'2021-03-18 22:01:24'),(259,210,'iclogo','194f9276-882d-11eb-a28f-3072fe1b0667','semtech.png','image/png',1431,'png',NULL,'2021-03-18 22:01:24'),(260,211,'iclogo','194fa496-882d-11eb-b729-9d794e4e6151','sgs1.png','image/png',2339,'png',NULL,'2021-03-18 22:01:24'),(261,212,'iclogo','194fb4ea-882d-11eb-8e1a-2478d397f843','sgs2.png','image/png',1874,'png',NULL,'2021-03-18 22:01:24'),(262,213,'iclogo','194fc462-882d-11eb-a396-7c75eaf154ad','sharp.png','image/png',2258,'png',NULL,'2021-03-18 22:01:24'),(263,214,'iclogo','194fd5ec-882d-11eb-9e63-984f8ef65441','shindgen.png','image/png',1629,'png',NULL,'2021-03-18 22:01:24'),(264,215,'iclogo','194fe5fa-882d-11eb-9a62-5932a155037e','siemens1.png','image/png',1216,'png',NULL,'2021-03-18 22:01:24'),(265,215,'iclogo','194fed98-882d-11eb-8318-c9b8b0184ddd','siemens2.png','image/png',2916,'png',NULL,'2021-03-18 22:01:24'),(266,216,'iclogo','19500008-882d-11eb-b62a-febf28e8a915','sierra.png','image/png',2321,'png',NULL,'2021-03-18 22:01:24'),(267,217,'iclogo','1950117e-882d-11eb-846a-b02a6aa6731b','sigmatel.png','image/png',1790,'png',NULL,'2021-03-18 22:01:24'),(268,218,'iclogo','195022ae-882d-11eb-9398-acb168838008','signetic.png','image/png',1519,'png',NULL,'2021-03-18 22:01:24'),(269,219,'iclogo','195034d8-882d-11eb-9801-105091ee7ec9','siliconlabs.png','image/png',5540,'png',NULL,'2021-03-18 22:01:24'),(270,220,'iclogo','1950486a-882d-11eb-adbc-dd16df629f64','siliconm.png','image/png',3817,'png',NULL,'2021-03-18 22:01:24'),(271,221,'iclogo','19506020-882d-11eb-ad5e-681a7c2a212b','silicons.png','image/png',2320,'png',NULL,'2021-03-18 22:01:24'),(272,221,'iclogo','1950689a-882d-11eb-932f-9380ac09c046','simtek.png','image/png',1874,'png',NULL,'2021-03-18 22:01:24'),(273,222,'iclogo','19507b3c-882d-11eb-ab57-a9678ee9c103','siliconx.png','image/png',2464,'png',NULL,'2021-03-18 22:01:24'),(274,223,'iclogo','19508bae-882d-11eb-86d9-6afc7a144b2d','silnans.png','image/png',1549,'png',NULL,'2021-03-18 22:01:24'),(275,224,'iclogo','19509f54-882d-11eb-a699-a9aef1ffe9a3','sipex.png','image/png',4029,'png',NULL,'2021-03-18 22:01:24'),(276,225,'iclogo','1950b25a-882d-11eb-ba9a-b461051ec3bb','sis.png','image/png',3608,'png',NULL,'2021-03-18 22:01:24'),(277,226,'iclogo','1950c52e-882d-11eb-8ddd-7c4509475e57','smc1.png','image/png',1763,'png',NULL,'2021-03-18 22:01:24'),(278,227,'iclogo','1950d794-882d-11eb-a82d-e01d4a06defe','smsc1.png','image/png',1781,'png',NULL,'2021-03-18 22:01:24'),(279,227,'iclogo','1950e02c-882d-11eb-a4db-fbd1c28ca2a3','smsc.png','image/png',2117,'png',NULL,'2021-03-18 22:01:24'),(280,228,'iclogo','1950f1ac-882d-11eb-b9bb-14a530f4f39b','sony.png','image/png',2476,'png',NULL,'2021-03-18 22:01:24'),(281,229,'iclogo','1951034a-882d-11eb-a239-1d2a10218276','space.png','image/png',3377,'png',NULL,'2021-03-18 22:01:24'),(282,230,'iclogo','19511876-882d-11eb-8ddb-1e3ed76cfd94','spectek.png','image/png',2228,'png',NULL,'2021-03-18 22:01:24'),(283,231,'iclogo','19512942-882d-11eb-aa21-078f49bbdcd9','spt.png','image/png',3419,'png',NULL,'2021-03-18 22:01:24'),(284,232,'iclogo','19513c16-882d-11eb-8acf-2b689bb9fafb','sss.png','image/png',1871,'png',NULL,'2021-03-18 22:01:24'),(285,233,'iclogo','19514cba-882d-11eb-a6d6-58985a646ffb','sst.png','image/png',3072,'png',NULL,'2021-03-18 22:01:24'),(286,234,'iclogo','19515ef8-882d-11eb-b083-ad33bb97a060','st.png','image/png',1604,'png',NULL,'2021-03-18 22:01:24'),(287,235,'iclogo','19517244-882d-11eb-aaf9-e9cd156d0d1b','summit.png','image/png',11440,'png',NULL,'2021-03-18 22:01:24'),(288,236,'iclogo','19518540-882d-11eb-b676-644d4840565b','synergy.png','image/png',1709,'png',NULL,'2021-03-18 22:01:24'),(289,237,'iclogo','1951954e-882d-11eb-a435-5589143fc07c','synertek.png','image/png',1789,'png',NULL,'2021-03-18 22:01:24'),(290,238,'iclogo','1951a660-882d-11eb-98e0-776b74aa7afe','taiwsemi.png','image/png',1475,'png',NULL,'2021-03-18 22:01:24'),(291,239,'iclogo','1951bb0a-882d-11eb-812e-b7cd364f2018','tdk.png','image/png',3687,'png',NULL,'2021-03-18 22:01:24'),(292,240,'iclogo','1951cc44-882d-11eb-a2cb-2befee0c79a7','teccor.png','image/png',1869,'png',NULL,'2021-03-18 22:01:24'),(293,241,'iclogo','1951de5a-882d-11eb-a624-1a4601728e1d','telcom.png','image/png',2555,'png',NULL,'2021-03-18 22:01:24'),(294,242,'iclogo','1951ee7c-882d-11eb-91d5-05000f832763','teledyne.png','image/png',1904,'png',NULL,'2021-03-18 22:01:24'),(295,243,'iclogo','19520204-882d-11eb-bb31-7ccf8567dbec','telefunk.png','image/png',2715,'png',NULL,'2021-03-18 22:01:24'),(296,244,'iclogo','195215be-882d-11eb-9e1c-033896944aec','teltone.png','image/png',4303,'png',NULL,'2021-03-18 22:01:24'),(297,245,'iclogo','19522ac2-882d-11eb-909e-6171f7a6a25c','thomscsf.png','image/png',1874,'png',NULL,'2021-03-18 22:01:24'),(298,246,'iclogo','19523ada-882d-11eb-b2e2-4d1472d70555','ti1.png','image/png',1869,'png',NULL,'2021-03-18 22:01:24'),(299,246,'iclogo','19524390-882d-11eb-aed5-3559a8785876','ti.png','image/png',1789,'png',NULL,'2021-03-18 22:01:24'),(300,247,'iclogo','195255d8-882d-11eb-a45c-d5ba66cd2a20','toko.png','image/png',1907,'png',NULL,'2021-03-18 22:01:24'),(301,248,'iclogo','1952682a-882d-11eb-9219-f23761d2dee4','toshiba1.png','image/png',1922,'png',NULL,'2021-03-18 22:01:24'),(302,248,'iclogo','195270a4-882d-11eb-9276-55873a6261a5','toshiba2.png','image/png',1309,'png',NULL,'2021-03-18 22:01:24'),(303,248,'iclogo','19527798-882d-11eb-820e-2a1d0da67d6c','toshiba3.png','image/png',2269,'png',NULL,'2021-03-18 22:01:24'),(304,249,'iclogo','19528828-882d-11eb-b65a-f2a033f3b2a6','trident.png','image/png',1414,'png',NULL,'2021-03-18 22:01:24'),(305,250,'iclogo','19529976-882d-11eb-bd3c-805fd0fb6251','triquint.png','image/png',2294,'png',NULL,'2021-03-18 22:01:24'),(306,251,'iclogo','1952abd2-882d-11eb-a3f6-628c01d7b743','triscend.png','image/png',4521,'png',NULL,'2021-03-18 22:01:24'),(307,252,'iclogo','1952bce4-882d-11eb-b6b2-6f6915111408','tseng.png','image/png',1466,'png',NULL,'2021-03-18 22:01:24'),(308,253,'iclogo','1952ce8c-882d-11eb-9484-574a0c00e82a','tundra.png','image/png',1709,'png',NULL,'2021-03-18 22:01:24'),(309,254,'iclogo','1952df12-882d-11eb-820e-7f3ecbb389e9','turbo_ic.png','image/png',7784,'png',NULL,'2021-03-18 22:01:24'),(310,255,'iclogo','1952f15a-882d-11eb-8f4a-adf7c220cfa0','ubicom.png','image/png',2047,'png',NULL,'2021-03-18 22:01:24'),(311,256,'iclogo','19530442-882d-11eb-96e6-64da842e5dea','umc.png','image/png',3032,'png',NULL,'2021-03-18 22:01:24'),(312,257,'iclogo','19531586-882d-11eb-a97b-e0dd1d18f981','unitrode.png','image/png',1309,'png',NULL,'2021-03-18 22:01:24'),(313,258,'iclogo','19532738-882d-11eb-916e-a6fb9e835d74','usar1.png','image/png',2771,'png',NULL,'2021-03-18 22:01:24'),(314,258,'iclogo','19532f26-882d-11eb-a02e-930bb7df2eef','usar.png','image/png',2793,'png',NULL,'2021-03-18 22:01:24'),(315,259,'iclogo','19534042-882d-11eb-b227-08ba9466ab01','utmc.png','image/png',2047,'png',NULL,'2021-03-18 22:01:24'),(316,260,'iclogo','19535334-882d-11eb-829a-3f8abe1a54d7','utron.png','image/png',2047,'png',NULL,'2021-03-18 22:01:24'),(317,261,'iclogo','1953646e-882d-11eb-9f97-9fc1fe651ca4','v3.png','image/png',3248,'png',NULL,'2021-03-18 22:01:24'),(318,262,'iclogo','1953762a-882d-11eb-a9f4-321a83ee54ac','vadem.png','image/png',1874,'png',NULL,'2021-03-18 22:01:24'),(319,263,'iclogo','195388ea-882d-11eb-8c0f-8cdbd47f5106','vanguard.png','image/png',1454,'png',NULL,'2021-03-18 22:01:24'),(320,264,'iclogo','1953998e-882d-11eb-8b6d-95ef93be874b','vantis.png','image/png',1475,'png',NULL,'2021-03-18 22:01:24'),(321,265,'iclogo','1953a92e-882d-11eb-9e44-a96b1a16eb63','via.png','image/png',1922,'png',NULL,'2021-03-18 22:01:24'),(322,266,'iclogo','1953ba72-882d-11eb-8bd7-804af96074e8','virata.png','image/png',3764,'png',NULL,'2021-03-18 22:01:24'),(323,267,'iclogo','1953cb02-882d-11eb-9bf5-1280ab4fb03c','vishay.png','image/png',4410,'png',NULL,'2021-03-18 22:01:24'),(324,268,'iclogo','1953dca0-882d-11eb-88ae-777161b22b27','vistech.png','image/png',1942,'png',NULL,'2021-03-18 22:01:24'),(325,269,'iclogo','1953efe2-882d-11eb-8471-99c8bf90afa3','vitelic.png','image/png',1691,'png',NULL,'2021-03-18 22:01:24'),(326,270,'iclogo','19540022-882d-11eb-bb4c-88aa66485fcf','vlsi.png','image/png',1874,'png',NULL,'2021-03-18 22:01:24'),(327,271,'iclogo','195411de-882d-11eb-834d-405d867e949c','volterra.png','image/png',2029,'png',NULL,'2021-03-18 22:01:24'),(328,272,'iclogo','19542318-882d-11eb-bb42-97e3e372e0fd','vtc.png','image/png',2223,'png',NULL,'2021-03-18 22:01:24'),(329,273,'iclogo','19543470-882d-11eb-9107-475935fbf38c','wafscale.png','image/png',2985,'png',NULL,'2021-03-18 22:01:24'),(330,274,'iclogo','1954462c-882d-11eb-8b5f-3726b3d05e57','wdc1.png','image/png',1784,'png',NULL,'2021-03-18 22:01:24'),(331,274,'iclogo','19544e24-882d-11eb-8980-c39047c1b31b','wdc2.png','image/png',1403,'png',NULL,'2021-03-18 22:01:24'),(332,275,'iclogo','195463fa-882d-11eb-8b64-2ce08a7be10d','weitek.png','image/png',1468,'png',NULL,'2021-03-18 22:01:24'),(333,276,'iclogo','1954758e-882d-11eb-892c-805b0539c85d','winbond.png','image/png',5402,'png',NULL,'2021-03-18 22:01:24'),(334,277,'iclogo','1954892a-882d-11eb-a5ba-8bfb12cef4ee','wolf.png','image/png',2343,'png',NULL,'2021-03-18 22:01:24'),(335,278,'iclogo','1954994c-882d-11eb-8716-cccbe3c0a1e3','xemics.png','image/png',2029,'png',NULL,'2021-03-18 22:01:24'),(336,279,'iclogo','1954aa0e-882d-11eb-857a-0356fde18bec','xicor1.png','image/png',1259,'png',NULL,'2021-03-18 22:01:24'),(337,279,'iclogo','1954b1b6-882d-11eb-85eb-be09a762109e','xicor.png','image/png',3389,'png',NULL,'2021-03-18 22:01:24'),(338,280,'iclogo','1954c570-882d-11eb-bcf7-761177268b40','xilinx.png','image/png',4186,'png',NULL,'2021-03-18 22:01:24'),(339,281,'iclogo','1954d8b2-882d-11eb-9619-e1ddb3c0ce6c','yamaha.png','image/png',1779,'png',NULL,'2021-03-18 22:01:24'),(340,282,'iclogo','1954eb54-882d-11eb-85b0-642ea154d51a','zetex.png','image/png',1255,'png',NULL,'2021-03-18 22:01:24'),(341,283,'iclogo','19550134-882d-11eb-80c8-7f10e0829637','zilog1.png','image/png',1958,'png',NULL,'2021-03-18 22:01:24'),(342,283,'iclogo','1955092c-882d-11eb-a806-110877ebb728','zilog2.png','image/png',2204,'png',NULL,'2021-03-18 22:01:24'),(343,283,'iclogo','19550fda-882d-11eb-a701-b438ddef2e4f','zilog3.png','image/png',2614,'png',NULL,'2021-03-18 22:01:24'),(344,283,'iclogo','195516d8-882d-11eb-a6fa-0c656e900880','zilog4.png','image/png',2405,'png',NULL,'2021-03-18 22:01:24'),(345,284,'iclogo','195529b6-882d-11eb-9f69-3dfeea49141e','zmda.png','image/png',3709,'png',NULL,'2021-03-18 22:01:24'),(346,285,'iclogo','19553c62-882d-11eb-9739-aea8a1757478','zoran.png','image/png',2784,'png',NULL,'2021-03-18 22:01:24');
/*!40000 ALTER TABLE `ManufacturerICLogo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MetaPartParameterCriteria`
--

DROP TABLE IF EXISTS `MetaPartParameterCriteria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `MetaPartParameterCriteria` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `part_id` int(11) DEFAULT NULL,
  `unit_id` int(11) DEFAULT NULL,
  `partParameterName` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `operator` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `value` double DEFAULT NULL,
  `normalizedValue` double DEFAULT NULL,
  `stringValue` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `valueType` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `siPrefix_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_6EE1D3924CE34BEC` (`part_id`),
  KEY `IDX_6EE1D39219187357` (`siPrefix_id`),
  KEY `IDX_6EE1D392F8BD700D` (`unit_id`),
  CONSTRAINT `FK_6EE1D39219187357` FOREIGN KEY (`siPrefix_id`) REFERENCES `SiPrefix` (`id`),
  CONSTRAINT `FK_6EE1D3924CE34BEC` FOREIGN KEY (`part_id`) REFERENCES `Part` (`id`),
  CONSTRAINT `FK_6EE1D392F8BD700D` FOREIGN KEY (`unit_id`) REFERENCES `Unit` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MetaPartParameterCriteria`
--

LOCK TABLES `MetaPartParameterCriteria` WRITE;
/*!40000 ALTER TABLE `MetaPartParameterCriteria` DISABLE KEYS */;
/*!40000 ALTER TABLE `MetaPartParameterCriteria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Part`
--

DROP TABLE IF EXISTS `Part`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Part` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_id` int(11) DEFAULT NULL,
  `footprint_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` longtext COLLATE utf8_unicode_ci NOT NULL,
  `stockLevel` int(11) NOT NULL,
  `minStockLevel` int(11) NOT NULL,
  `averagePrice` decimal(13,4) NOT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `needsReview` tinyint(1) NOT NULL,
  `partCondition` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `productionRemarks` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `createDate` datetime DEFAULT NULL,
  `internalPartNumber` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `removals` tinyint(1) NOT NULL,
  `lowStock` tinyint(1) NOT NULL,
  `metaPart` tinyint(1) NOT NULL DEFAULT 0,
  `partUnit_id` int(11) DEFAULT NULL,
  `storageLocation_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_E93DDFF812469DE2` (`category_id`),
  KEY `IDX_E93DDFF851364C98` (`footprint_id`),
  KEY `IDX_E93DDFF8F7A36E87` (`partUnit_id`),
  KEY `IDX_E93DDFF873CD58AF` (`storageLocation_id`),
  CONSTRAINT `FK_E93DDFF812469DE2` FOREIGN KEY (`category_id`) REFERENCES `PartCategory` (`id`),
  CONSTRAINT `FK_E93DDFF851364C98` FOREIGN KEY (`footprint_id`) REFERENCES `Footprint` (`id`),
  CONSTRAINT `FK_E93DDFF873CD58AF` FOREIGN KEY (`storageLocation_id`) REFERENCES `StorageLocation` (`id`),
  CONSTRAINT `FK_E93DDFF8F7A36E87` FOREIGN KEY (`partUnit_id`) REFERENCES `PartUnit` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Part`
--

LOCK TABLES `Part` WRITE;
/*!40000 ALTER TABLE `Part` DISABLE KEYS */;
INSERT INTO `Part` VALUES (1,4,NULL,'CTC Bizer','Dual-Extrusion-Drucker | MakerBot-Nachbau','2021-03-18 Verliehen an Stefan',1,0,0.0000,'',1,'Dauerleihgabe','Leihgabe von Stefan','2021-03-18 22:31:57','',0,0,0,1,5),(2,4,NULL,'Ultimaker S5','Professioneller Drucker mit Dual-Extrusion','',1,0,0.0000,'',1,'','Im Besitz der VHS','2021-03-18 22:33:05','',0,0,0,1,5),(3,4,NULL,'Creality Ender 3','Günstiger Einsteigerdrucker basierend auf einem I3','',1,0,0.0000,'',1,'','','2021-03-18 22:35:07','',0,0,0,1,5),(6,9,NULL,'LG Flatron','TFT Monitor von Petra','',1,1,0.0000,'',0,'Dauerleihgabe von Petra','','2021-03-27 14:59:17','',0,0,0,1,5),(7,10,NULL,'Olimex STM32-P107','Entwickelrboard mit ARM Cortex M3 CPU','https://www.olimex.com/Products/ARM/ST/STM32-P107/',1,0,29.9500,'',1,'','','2021-03-31 19:33:04','',0,0,0,1,8),(8,10,NULL,'Olimex LPC-P1227','Entwicklerboard mit ARM Cortex M0 CPU','',1,0,0.0000,'',1,'','','2021-04-04 22:44:55','',0,0,0,1,8),(9,15,NULL,'GP-319','Knopfzelle Bauform 319','',0,0,0.0000,'',1,'','','2021-04-04 22:49:14','',0,0,0,1,8),(10,11,NULL,'RPI MUSB 2 SATA','Raspberry Pi - Konverter Micro-USB auf SATA','',1,0,25.5000,'',1,'','','2021-04-04 22:57:07','',0,0,0,1,8),(11,11,NULL,'Logic Shrimp logic analyzer ','Logikanalysator zur Signalauswertung','',1,0,0.0000,'',1,'','','2021-04-04 23:03:15','',0,0,0,1,8),(12,12,NULL,'MCIMX28LCD ','4.3\" LCD Display, Auflösung: 800x480px','',1,0,0.0000,'Abgekündigt',1,'','','2021-04-04 23:10:05','',0,0,0,1,8),(13,7,NULL,'JPEG Trigger (DEV-10549)','Platine zum Speichern von Bildern einer externen Kamera','',1,0,0.0000,'',1,'','','2021-04-04 23:14:30','',0,0,0,1,8),(14,7,NULL,'SSOP to DIP Adapter 20-Pin','Breakout Board','',4,0,5.0000,'',1,'','','2021-04-04 23:17:15','',0,0,0,1,8),(15,7,NULL,'SSOP to DIP Adapter - 8-Pin','Breakout Board','',4,0,5.0000,'',1,'','','2021-04-04 23:20:20','',0,0,0,1,8),(16,7,NULL,'Spannungsregle 2,5-9,5V','','https://www.pololu.com/product/791/specs',3,0,0.0000,'',1,'','','2021-04-04 23:24:04','',0,0,0,1,8),(17,14,NULL,'AAA NiMH - 550 mAh','','',2,0,0.0000,'',1,'','','2021-04-06 18:40:01','',0,0,0,1,8),(18,14,NULL,'9V NiMH - 200 mAh','9 Volt Blockbatterie in Akkuausführung','',1,0,0.0000,'',1,'','','2021-04-06 18:45:14','',0,0,0,1,8),(19,16,NULL,'Batterietester','','',1,0,0.0000,'',1,'','','2021-04-06 18:46:56','',0,0,0,1,8),(20,18,NULL,'Heißluftpistole Einhell TE-HA 2000 E','','',1,0,0.0000,'',1,'','','2021-04-06 18:58:56','',0,0,0,1,8);
/*!40000 ALTER TABLE `Part` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PartAttachment`
--

DROP TABLE IF EXISTS `PartAttachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PartAttachment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `part_id` int(11) DEFAULT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `filename` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `originalname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mimetype` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `size` int(11) NOT NULL,
  `extension` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `created` datetime NOT NULL,
  `isImage` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_76D73D864CE34BEC` (`part_id`),
  CONSTRAINT `FK_76D73D864CE34BEC` FOREIGN KEY (`part_id`) REFERENCES `Part` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PartAttachment`
--

LOCK TABLES `PartAttachment` WRITE;
/*!40000 ALTER TABLE `PartAttachment` DISABLE KEYS */;
INSERT INTO `PartAttachment` VALUES (2,1,'PartAttachment','57b33066-8834-11eb-8327-4e9d86d2e192','51ktzS5oT9L.jpg','image/jpeg',42094,'jpeg',NULL,'2021-03-18 22:53:15',1),(3,2,'PartAttachment','7d89de66-8834-11eb-9836-eb94d7b61725','ULTIMAKER_S5_01.png','image/png',1443550,'png',NULL,'2021-03-18 22:54:19',1),(4,3,'PartAttachment','9bfb7436-8834-11eb-a04d-e4bd177c217c','20180903105257_61939.jpg_500x500.jpg','image/jpeg',43845,'jpeg',NULL,'2021-03-18 22:55:10',1),(5,6,'PartAttachment','b9eab7f0-8f04-11eb-a692-b0747ccfbd8d','Petra_Monitor-2Kabel_LG210301.jpg','image/jpeg',38292,'jpeg',NULL,'2021-03-27 15:00:02',1),(6,7,'PartAttachment','4e5a811e-9247-11eb-aff4-8cd1aec707c3','STM32-P107-02.jpg','image/jpeg',32112,'jpeg',NULL,'2021-03-31 19:34:11',1),(7,8,'PartAttachment','9d23a57c-9586-11eb-872f-5b117e5dd5a9','Olimex-LPC-P1227.jpg','image/jpeg',22491,'jpeg',NULL,'2021-04-04 22:44:55',1),(8,10,'PartAttachment','51390858-9588-11eb-913d-112ec1050a3d','RPI_MUSB_2_SATA_01.jpg','image/jpeg',10711,'',NULL,'2021-04-04 22:57:07',NULL),(9,9,'PartAttachment','6fbfa034-9588-11eb-a8ab-dbdbe18e3387','GP319.jpg','image/jpeg',16600,'jpeg',NULL,'2021-04-04 22:57:58',1),(10,11,'PartAttachment','2cd3c358-9589-11eb-a0c7-db91f4647183','Logic-shrimp-v1.jpg','image/jpeg',54457,'',NULL,'2021-04-04 23:03:16',NULL),(11,12,'PartAttachment','20e3b1a6-958a-11eb-88dd-df10bc1c1cea','MCIMX28LCD.JPG','image/jpeg',19389,'',NULL,'2021-04-04 23:10:05',NULL),(12,13,'PartAttachment','bf259596-958a-11eb-b900-c438c0c9c459','DEV-10549.jpg','image/jpeg',61071,'',NULL,'2021-04-04 23:14:30',NULL),(13,14,'PartAttachment','3c211c64-958b-11eb-a80b-d9b6f3d57763','SSOP to DIP Adapter 20-Pin.jpg','image/jpeg',41344,'',NULL,'2021-04-04 23:18:00',NULL),(14,15,'PartAttachment','8f8883c4-958b-11eb-85a4-9f27ab9796a6','00497-01b.jpg','image/jpeg',87101,'',NULL,'2021-04-04 23:20:20',NULL),(15,16,'PartAttachment','1549e3ae-958c-11eb-8316-28509fbdd2b9','Polulu-Boost-Regulator.jpg','image/jpeg',47386,'',NULL,'2021-04-04 23:24:05',NULL),(16,17,'PartAttachment','1ebf4dfe-96f7-11eb-af20-fa3c95cd5c9a','aaa.jpg','image/jpeg',42631,'jpeg',NULL,'2021-04-06 18:42:48',1),(17,18,'PartAttachment','858b8732-96f7-11eb-a46a-01c16bfa7b2d','9v.jpg','image/jpeg',41076,'jpeg',NULL,'2021-04-06 18:45:40',1),(18,19,'PartAttachment','c6f5b6e8-96f7-11eb-a07b-cdeca26e6c94','Batterietester.jpg','image/jpeg',57585,'jpeg',NULL,'2021-04-06 18:47:30',1),(19,19,'PartAttachment','ed85fe6c-96f7-11eb-9065-e099d137f9d8','Bedienungsanleitung_Varta_Batterietester.jpg','image/jpeg',141697,'jpeg',NULL,'2021-04-06 18:48:35',1),(20,20,'PartAttachment','7f2025f4-96f9-11eb-9cbe-7b31c41b869b','Einhell__TE-HA_2000_E.jpg','image/jpeg',149391,'jpeg',NULL,'2021-04-06 18:59:48',1);
/*!40000 ALTER TABLE `PartAttachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PartCategory`
--

DROP TABLE IF EXISTS `PartCategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PartCategory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `lft` int(11) NOT NULL,
  `rgt` int(11) NOT NULL,
  `lvl` int(11) NOT NULL,
  `root` int(11) DEFAULT NULL,
  `name` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `categoryPath` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_131FB619727ACA70` (`parent_id`),
  KEY `IDX_131FB619DA439252` (`lft`),
  KEY `IDX_131FB619D5E02D69` (`rgt`),
  CONSTRAINT `FK_131FB619727ACA70` FOREIGN KEY (`parent_id`) REFERENCES `PartCategory` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PartCategory`
--

LOCK TABLES `PartCategory` WRITE;
/*!40000 ALTER TABLE `PartCategory` DISABLE KEYS */;
INSERT INTO `PartCategory` VALUES (1,NULL,1,36,0,1,'Root Category',NULL,'Root Category'),(2,1,2,5,1,1,'Verbrauchsmaterialien','','Root Category ➤ Verbrauchsmaterialien'),(3,1,6,13,1,1,'3d-Druck','','Root Category ➤ 3d-Druck'),(4,3,7,8,2,1,'Drucker','','Root Category ➤ 3d-Druck ➤ Drucker'),(5,3,9,10,2,1,'Filament','','Root Category ➤ 3d-Druck ➤ Filament'),(6,3,11,12,2,1,'Werkzeug','','Root Category ➤ 3d-Druck ➤ Werkzeug'),(7,1,14,21,1,1,'Elektronik','','Root Category ➤ Elektronik'),(8,1,22,25,1,1,'Computer & Hardware','','Root Category ➤ Computer & Hardware'),(9,8,23,24,2,1,'Monitore','','Root Category ➤ Computer & Hardware ➤ Monitore'),(10,7,15,16,2,1,'Entwicklerboards','','Root Category ➤ Elektronik ➤ Entwicklerboards'),(11,7,17,18,2,1,'Konverter','Platinen und Konverter um Signale zu übersetzen','Root Category ➤ Elektronik ➤ Konverter'),(12,7,19,20,2,1,'Displays','TFT- und LCD-Displays für Entwiklerboards','Root Category ➤ Elektronik ➤ Displays'),(13,1,26,29,1,1,'Energieversorgung','','Root Category ➤ Energieversorgung'),(14,13,27,28,2,1,'Akkus','','Root Category ➤ Energieversorgung ➤ Akkus'),(15,2,3,4,2,1,'Batterien','','Root Category ➤ Verbrauchsmaterialien ➤ Batterien'),(16,1,30,31,1,1,'Messgeräte','','Root Category ➤ Messgeräte'),(17,1,32,35,1,1,'Werkzeug','','Root Category ➤ Werkzeug'),(18,17,33,34,2,1,'Geräte','','Root Category ➤ Werkzeug ➤ Geräte');
/*!40000 ALTER TABLE `PartCategory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PartDistributor`
--

DROP TABLE IF EXISTS `PartDistributor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PartDistributor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `part_id` int(11) DEFAULT NULL,
  `distributor_id` int(11) DEFAULT NULL,
  `orderNumber` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `packagingUnit` int(11) NOT NULL,
  `price` decimal(13,4) DEFAULT NULL,
  `currency` varchar(3) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sku` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ignoreForReports` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_FBA293844CE34BEC` (`part_id`),
  KEY `IDX_FBA293842D863A58` (`distributor_id`),
  CONSTRAINT `FK_FBA293842D863A58` FOREIGN KEY (`distributor_id`) REFERENCES `Distributor` (`id`),
  CONSTRAINT `FK_FBA293844CE34BEC` FOREIGN KEY (`part_id`) REFERENCES `Part` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PartDistributor`
--

LOCK TABLES `PartDistributor` WRITE;
/*!40000 ALTER TABLE `PartDistributor` DISABLE KEYS */;
INSERT INTO `PartDistributor` VALUES (3,10,3,'',1,25.5000,NULL,'',NULL);
/*!40000 ALTER TABLE `PartDistributor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PartKeeprUser`
--

DROP TABLE IF EXISTS `PartKeeprUser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PartKeeprUser` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `provider_id` int(11) DEFAULT NULL,
  `username` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `admin` tinyint(1) NOT NULL,
  `legacy` tinyint(1) NOT NULL,
  `lastSeen` datetime DEFAULT NULL,
  `active` tinyint(1) NOT NULL,
  `protected` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_provider` (`username`,`provider_id`),
  KEY `IDX_7572D706A53A8AA` (`provider_id`),
  CONSTRAINT `FK_7572D706A53A8AA` FOREIGN KEY (`provider_id`) REFERENCES `UserProvider` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PartKeeprUser`
--

LOCK TABLES `PartKeeprUser` WRITE;
/*!40000 ALTER TABLE `PartKeeprUser` DISABLE KEYS */;
INSERT INTO `PartKeeprUser` VALUES (1,1,'whity',NULL,NULL,0,0,NULL,1,0),(2,1,'maggi','','maggi@evkihip.de',0,0,NULL,1,0);
/*!40000 ALTER TABLE `PartKeeprUser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PartManufacturer`
--

DROP TABLE IF EXISTS `PartManufacturer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PartManufacturer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `part_id` int(11) DEFAULT NULL,
  `manufacturer_id` int(11) DEFAULT NULL,
  `partNumber` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_F085878B4CE34BEC` (`part_id`),
  KEY `IDX_F085878BA23B42D` (`manufacturer_id`),
  CONSTRAINT `FK_F085878B4CE34BEC` FOREIGN KEY (`part_id`) REFERENCES `Part` (`id`),
  CONSTRAINT `FK_F085878BA23B42D` FOREIGN KEY (`manufacturer_id`) REFERENCES `Manufacturer` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PartManufacturer`
--

LOCK TABLES `PartManufacturer` WRITE;
/*!40000 ALTER TABLE `PartManufacturer` DISABLE KEYS */;
INSERT INTO `PartManufacturer` VALUES (1,3,288,''),(3,1,292,''),(4,17,290,''),(5,18,290,''),(6,19,290,''),(7,20,291,'TE-HA 2000 E');
/*!40000 ALTER TABLE `PartManufacturer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PartParameter`
--

DROP TABLE IF EXISTS `PartParameter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PartParameter` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `part_id` int(11) DEFAULT NULL,
  `unit_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `value` double DEFAULT NULL,
  `normalizedValue` double DEFAULT NULL,
  `maximumValue` double DEFAULT NULL,
  `normalizedMaxValue` double DEFAULT NULL,
  `minimumValue` double DEFAULT NULL,
  `normalizedMinValue` double DEFAULT NULL,
  `stringValue` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `valueType` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `siPrefix_id` int(11) DEFAULT NULL,
  `minSiPrefix_id` int(11) DEFAULT NULL,
  `maxSiPrefix_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_A28A98594CE34BEC` (`part_id`),
  KEY `IDX_A28A9859F8BD700D` (`unit_id`),
  KEY `IDX_A28A985919187357` (`siPrefix_id`),
  KEY `IDX_A28A9859569AA479` (`minSiPrefix_id`),
  KEY `IDX_A28A9859EFBC3F08` (`maxSiPrefix_id`),
  CONSTRAINT `FK_A28A985919187357` FOREIGN KEY (`siPrefix_id`) REFERENCES `SiPrefix` (`id`),
  CONSTRAINT `FK_A28A98594CE34BEC` FOREIGN KEY (`part_id`) REFERENCES `Part` (`id`),
  CONSTRAINT `FK_A28A9859569AA479` FOREIGN KEY (`minSiPrefix_id`) REFERENCES `SiPrefix` (`id`),
  CONSTRAINT `FK_A28A9859EFBC3F08` FOREIGN KEY (`maxSiPrefix_id`) REFERENCES `SiPrefix` (`id`),
  CONSTRAINT `FK_A28A9859F8BD700D` FOREIGN KEY (`unit_id`) REFERENCES `Unit` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PartParameter`
--

LOCK TABLES `PartParameter` WRITE;
/*!40000 ALTER TABLE `PartParameter` DISABLE KEYS */;
INSERT INTO `PartParameter` VALUES (1,3,NULL,'Besitzer','Besitzer des Gerätes',NULL,NULL,NULL,NULL,NULL,NULL,'Repaircafé Hilpoltstein','string',NULL,NULL,NULL),(2,1,NULL,'Besitzer','Besitzer des Gerätes',NULL,NULL,NULL,NULL,NULL,NULL,'Stefan Westphal','string',NULL,NULL,NULL),(3,2,NULL,'Besitzer','Besitzer des Gerätes',NULL,NULL,NULL,NULL,NULL,NULL,'VHS Roth','string',NULL,NULL,NULL),(5,6,NULL,'Besitzer','',NULL,NULL,NULL,NULL,NULL,NULL,'Petra Beringer','string',NULL,NULL,NULL),(6,7,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,'','numeric',NULL,NULL,NULL);
/*!40000 ALTER TABLE `PartParameter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PartUnit`
--

DROP TABLE IF EXISTS `PartUnit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PartUnit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `shortName` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `is_default` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PartUnit`
--

LOCK TABLES `PartUnit` WRITE;
/*!40000 ALTER TABLE `PartUnit` DISABLE KEYS */;
INSERT INTO `PartUnit` VALUES (1,'Pieces','pcs',1);
/*!40000 ALTER TABLE `PartUnit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Project`
--

DROP TABLE IF EXISTS `Project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Project` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_E00EE972A76ED395` (`user_id`),
  CONSTRAINT `FK_E00EE972A76ED395` FOREIGN KEY (`user_id`) REFERENCES `PartKeeprUser` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Project`
--

LOCK TABLES `Project` WRITE;
/*!40000 ALTER TABLE `Project` DISABLE KEYS */;
/*!40000 ALTER TABLE `Project` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ProjectAttachment`
--

DROP TABLE IF EXISTS `ProjectAttachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ProjectAttachment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `filename` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `originalname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mimetype` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `size` int(11) NOT NULL,
  `extension` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_44010C5B166D1F9C` (`project_id`),
  CONSTRAINT `FK_44010C5B166D1F9C` FOREIGN KEY (`project_id`) REFERENCES `Project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProjectAttachment`
--

LOCK TABLES `ProjectAttachment` WRITE;
/*!40000 ALTER TABLE `ProjectAttachment` DISABLE KEYS */;
/*!40000 ALTER TABLE `ProjectAttachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ProjectPart`
--

DROP TABLE IF EXISTS `ProjectPart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ProjectPart` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `part_id` int(11) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `remarks` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `overageType` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `overage` int(11) NOT NULL DEFAULT 0,
  `lotNumber` longtext COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_B0B193364CE34BEC` (`part_id`),
  KEY `IDX_B0B19336166D1F9C` (`project_id`),
  CONSTRAINT `FK_B0B19336166D1F9C` FOREIGN KEY (`project_id`) REFERENCES `Project` (`id`),
  CONSTRAINT `FK_B0B193364CE34BEC` FOREIGN KEY (`part_id`) REFERENCES `Part` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProjectPart`
--

LOCK TABLES `ProjectPart` WRITE;
/*!40000 ALTER TABLE `ProjectPart` DISABLE KEYS */;
/*!40000 ALTER TABLE `ProjectPart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ProjectRun`
--

DROP TABLE IF EXISTS `ProjectRun`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ProjectRun` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `runDateTime` datetime NOT NULL,
  `quantity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_574A3B5C166D1F9C` (`project_id`),
  CONSTRAINT `FK_574A3B5C166D1F9C` FOREIGN KEY (`project_id`) REFERENCES `Project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProjectRun`
--

LOCK TABLES `ProjectRun` WRITE;
/*!40000 ALTER TABLE `ProjectRun` DISABLE KEYS */;
/*!40000 ALTER TABLE `ProjectRun` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ProjectRunPart`
--

DROP TABLE IF EXISTS `ProjectRunPart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ProjectRunPart` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `part_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `lotNumber` longtext COLLATE utf8_unicode_ci NOT NULL,
  `projectRun_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_BF41064B1A221EF0` (`projectRun_id`),
  KEY `IDX_BF41064B4CE34BEC` (`part_id`),
  CONSTRAINT `FK_BF41064B1A221EF0` FOREIGN KEY (`projectRun_id`) REFERENCES `ProjectRun` (`id`),
  CONSTRAINT `FK_BF41064B4CE34BEC` FOREIGN KEY (`part_id`) REFERENCES `Part` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProjectRunPart`
--

LOCK TABLES `ProjectRunPart` WRITE;
/*!40000 ALTER TABLE `ProjectRunPart` DISABLE KEYS */;
/*!40000 ALTER TABLE `ProjectRunPart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Report`
--

DROP TABLE IF EXISTS `Report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Report` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `createDateTime` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Report`
--

LOCK TABLES `Report` WRITE;
/*!40000 ALTER TABLE `Report` DISABLE KEYS */;
INSERT INTO `Report` VALUES (1,NULL,'2021-03-19 18:44:01');
/*!40000 ALTER TABLE `Report` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ReportPart`
--

DROP TABLE IF EXISTS `ReportPart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ReportPart` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_id` int(11) DEFAULT NULL,
  `part_id` int(11) DEFAULT NULL,
  `distributor_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_1BF0BD554BD2A4C0` (`report_id`),
  KEY `IDX_1BF0BD554CE34BEC` (`part_id`),
  KEY `IDX_1BF0BD552D863A58` (`distributor_id`),
  CONSTRAINT `FK_1BF0BD552D863A58` FOREIGN KEY (`distributor_id`) REFERENCES `Distributor` (`id`),
  CONSTRAINT `FK_1BF0BD554BD2A4C0` FOREIGN KEY (`report_id`) REFERENCES `Report` (`id`),
  CONSTRAINT `FK_1BF0BD554CE34BEC` FOREIGN KEY (`part_id`) REFERENCES `Part` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ReportPart`
--

LOCK TABLES `ReportPart` WRITE;
/*!40000 ALTER TABLE `ReportPart` DISABLE KEYS */;
/*!40000 ALTER TABLE `ReportPart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ReportProject`
--

DROP TABLE IF EXISTS `ReportProject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ReportProject` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_id` int(11) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_83B0909B4BD2A4C0` (`report_id`),
  KEY `IDX_83B0909B166D1F9C` (`project_id`),
  CONSTRAINT `FK_83B0909B166D1F9C` FOREIGN KEY (`project_id`) REFERENCES `Project` (`id`),
  CONSTRAINT `FK_83B0909B4BD2A4C0` FOREIGN KEY (`report_id`) REFERENCES `Report` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ReportProject`
--

LOCK TABLES `ReportProject` WRITE;
/*!40000 ALTER TABLE `ReportProject` DISABLE KEYS */;
/*!40000 ALTER TABLE `ReportProject` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SchemaVersions`
--

DROP TABLE IF EXISTS `SchemaVersions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SchemaVersions` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SchemaVersions`
--

LOCK TABLES `SchemaVersions` WRITE;
/*!40000 ALTER TABLE `SchemaVersions` DISABLE KEYS */;
INSERT INTO `SchemaVersions` VALUES ('20150608120000'),('20150708120022'),('20150724174030'),('20151001180120'),('20151002183125'),('20151031163951'),('20151208162723'),('20160103145302'),('20170108122512'),('20170108143802'),('20170113203042'),('20170601175559');
/*!40000 ALTER TABLE `SchemaVersions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SiPrefix`
--

DROP TABLE IF EXISTS `SiPrefix`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SiPrefix` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `prefix` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `symbol` varchar(2) COLLATE utf8_unicode_ci NOT NULL,
  `exponent` int(11) NOT NULL,
  `base` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SiPrefix`
--

LOCK TABLES `SiPrefix` WRITE;
/*!40000 ALTER TABLE `SiPrefix` DISABLE KEYS */;
INSERT INTO `SiPrefix` VALUES (1,'yotta','Y',24,10),(2,'zetta','Z',21,10),(3,'exa','E',18,10),(4,'peta','P',15,10),(5,'tera','T',12,10),(6,'giga','G',9,10),(7,'mega','M',6,10),(8,'kilo','k',3,10),(9,'hecto','h',2,10),(10,'deca','da',1,10),(11,'-','',0,10),(12,'deci','d',-1,10),(13,'centi','c',-2,10),(14,'milli','m',-3,10),(15,'micro','μ',-6,10),(16,'nano','n',-9,10),(17,'pico','p',-12,10),(18,'femto','f',-15,10),(19,'atto','a',-18,10),(20,'zepto','z',-21,10),(21,'yocto','y',-24,10),(22,'kibi','Ki',1,1024),(23,'mebi','Mi',2,1024),(24,'gibi','Gi',3,1024),(25,'tebi','Ti',4,1024),(26,'pebi','Pi',5,1024),(27,'exbi','Ei',6,1024),(28,'zebi','Zi',7,1024),(29,'yobi','Yi',8,1024);
/*!40000 ALTER TABLE `SiPrefix` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `StatisticSnapshot`
--

DROP TABLE IF EXISTS `StatisticSnapshot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `StatisticSnapshot` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dateTime` datetime NOT NULL,
  `parts` int(11) NOT NULL,
  `categories` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=324 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `StatisticSnapshot`
--

LOCK TABLES `StatisticSnapshot` WRITE;
/*!40000 ALTER TABLE `StatisticSnapshot` DISABLE KEYS */;
INSERT INTO `StatisticSnapshot` VALUES (1,'2021-03-18 22:02:04',0,1),(2,'2021-03-18 22:03:51',0,1),(3,'2021-03-19 04:10:01',3,5),(4,'2021-03-19 16:10:02',3,5),(5,'2021-03-19 19:04:03',3,5),(6,'2021-03-19 19:06:47',3,5),(7,'2021-03-19 19:07:35',3,5),(8,'2021-03-20 01:10:02',5,5),(9,'2021-03-20 13:10:02',5,5),(10,'2021-03-20 19:20:01',5,5),(11,'2021-03-21 01:20:06',5,5),(12,'2021-03-21 07:30:02',5,5),(13,'2021-03-21 13:40:02',5,5),(14,'2021-03-21 19:50:11',5,5),(15,'2021-03-22 02:00:06',5,5),(16,'2021-03-22 08:10:06',5,5),(17,'2021-03-22 14:20:01',5,5),(18,'2021-03-22 20:20:02',5,7),(19,'2021-03-23 02:20:02',5,7),(20,'2021-03-23 08:20:02',5,7),(21,'2021-03-23 14:30:02',5,7),(22,'2021-03-23 20:40:12',5,7),(23,'2021-03-24 02:50:01',5,7),(24,'2021-03-24 08:50:01',5,7),(25,'2021-03-24 14:50:06',5,7),(26,'2021-03-24 21:00:02',5,7),(27,'2021-03-25 03:10:06',5,7),(28,'2021-03-25 09:20:12',5,7),(29,'2021-03-25 15:30:06',5,7),(30,'2021-03-25 21:40:02',5,7),(31,'2021-03-26 03:40:02',5,7),(32,'2021-03-26 09:50:05',5,7),(33,'2021-03-26 16:00:11',5,7),(34,'2021-03-26 22:10:07',5,7),(35,'2021-03-27 04:20:01',5,7),(36,'2021-03-27 10:20:06',5,7),(37,'2021-03-27 16:30:01',6,9),(38,'2021-03-28 05:30:02',6,9),(39,'2021-03-28 11:40:01',6,9),(40,'2021-03-28 23:40:02',6,9),(41,'2021-03-29 05:50:06',6,9),(42,'2021-03-29 12:00:07',6,9),(43,'2021-03-29 18:10:02',6,9),(44,'2021-03-30 00:10:02',6,9),(45,'2021-03-30 06:20:07',6,9),(46,'2021-03-30 12:30:01',6,9),(47,'2021-03-30 18:30:11',6,9),(48,'2021-03-31 00:40:01',6,9),(49,'2021-03-31 06:40:02',6,9),(50,'2021-03-31 12:50:01',6,9),(51,'2021-03-31 18:50:01',6,9),(52,'2021-04-01 00:50:01',7,10),(53,'2021-04-01 06:50:01',7,10),(54,'2021-04-01 12:50:01',7,10),(55,'2021-04-01 18:50:02',7,10),(56,'2021-04-02 01:00:01',7,10),(57,'2021-04-02 07:00:01',7,10),(58,'2021-04-02 19:10:01',7,10),(59,'2021-04-03 01:10:01',7,10),(60,'2021-04-03 07:10:02',7,10),(61,'2021-04-03 13:20:02',7,10),(62,'2021-04-03 19:30:01',7,10),(63,'2021-04-04 01:30:01',7,10),(64,'2021-04-04 07:30:02',7,10),(65,'2021-04-04 19:30:01',7,10),(66,'2021-04-05 01:30:02',16,12),(67,'2021-04-05 07:40:02',16,12),(68,'2021-04-05 13:50:01',16,12),(69,'2021-04-05 19:50:01',16,12),(70,'2021-04-06 01:50:01',16,12),(71,'2021-04-06 07:50:02',16,12),(72,'2021-04-06 14:00:01',16,12),(73,'2021-04-06 20:00:01',20,18),(74,'2021-04-07 02:00:02',20,18),(75,'2021-04-07 08:10:01',20,18),(76,'2021-04-07 20:10:01',20,18),(77,'2021-04-08 02:10:01',20,18),(78,'2021-04-08 08:10:01',20,18),(79,'2021-04-08 14:10:01',20,18),(80,'2021-04-08 20:10:01',20,18),(81,'2021-04-09 02:10:02',20,18),(82,'2021-04-09 08:20:02',20,18),(83,'2021-04-09 14:20:02',20,18),(84,'2021-04-09 20:30:02',20,18),(85,'2021-04-10 02:40:02',20,18),(86,'2021-04-10 08:50:01',20,18),(87,'2021-04-10 14:50:01',20,18),(88,'2021-04-10 20:50:01',20,18),(89,'2021-04-11 02:50:02',20,18),(90,'2021-04-11 09:00:02',20,18),(91,'2021-04-11 15:10:02',20,18),(92,'2021-04-11 21:20:01',20,18),(93,'2021-04-12 03:20:01',20,18),(94,'2021-04-12 09:20:02',20,18),(95,'2021-04-12 15:30:02',20,18),(96,'2021-04-12 21:40:02',20,18),(97,'2021-04-13 03:50:02',20,18),(98,'2021-04-13 10:00:01',20,18),(99,'2021-04-13 16:00:02',20,18),(100,'2021-04-14 04:00:01',20,18),(101,'2021-04-14 10:00:01',20,18),(102,'2021-04-14 16:00:01',20,18),(103,'2021-04-14 22:00:01',20,18),(104,'2021-04-15 04:00:01',20,18),(105,'2021-04-15 10:00:02',20,18),(106,'2021-04-15 16:00:02',20,18),(107,'2021-04-15 22:10:02',20,18),(108,'2021-04-16 04:20:01',20,18),(109,'2021-04-16 16:20:01',20,18),(110,'2021-04-16 22:20:02',20,18),(111,'2021-04-17 04:30:01',20,18),(112,'2021-04-17 10:30:01',20,18),(113,'2021-04-17 16:30:01',20,18),(114,'2021-04-17 22:30:01',20,18),(115,'2021-04-18 04:30:02',20,18),(116,'2021-04-18 10:30:02',20,18),(117,'2021-04-18 16:30:02',20,18),(118,'2021-04-18 22:40:01',20,18),(119,'2021-04-19 04:40:02',20,18),(120,'2021-04-19 10:50:02',20,18),(121,'2021-04-19 17:00:01',20,18),(122,'2021-04-19 23:00:01',18,18),(123,'2021-04-20 05:00:02',18,18),(124,'2021-04-20 11:10:02',18,18),(125,'2021-04-20 17:10:02',18,18),(126,'2021-04-20 23:20:02',18,18),(127,'2021-04-21 05:30:02',18,18),(128,'2021-04-21 11:40:02',18,18),(129,'2021-04-21 17:50:01',18,18),(130,'2021-04-21 23:50:01',18,18),(131,'2021-04-22 05:50:02',18,18),(132,'2021-04-22 12:00:03',18,18),(133,'2021-04-22 18:10:01',18,18),(134,'2021-04-23 00:10:01',18,18),(135,'2021-04-23 06:10:01',18,18),(136,'2021-04-23 12:10:02',18,18),(137,'2021-04-23 18:20:01',18,18),(138,'2021-04-24 00:20:01',18,18),(139,'2021-04-24 06:20:02',18,18),(140,'2021-04-24 12:20:02',18,18),(141,'2021-04-24 18:30:01',18,18),(142,'2021-04-25 00:30:01',18,18),(143,'2021-04-25 06:30:02',18,18),(144,'2021-04-25 12:40:01',18,18),(145,'2021-04-25 18:40:01',18,18),(146,'2021-04-26 00:40:01',18,18),(147,'2021-04-26 06:40:01',18,18),(148,'2021-04-26 12:40:01',18,18),(149,'2021-04-26 18:40:01',18,18),(150,'2021-04-27 00:40:01',18,18),(151,'2021-04-27 06:40:02',18,18),(152,'2021-04-27 18:50:01',18,18),(153,'2021-04-28 00:50:01',18,18),(154,'2021-04-28 06:50:02',18,18),(155,'2021-04-28 13:00:01',18,18),(156,'2021-04-28 19:00:02',18,18),(157,'2021-04-29 01:10:01',18,18),(158,'2021-04-29 07:10:02',18,18),(159,'2021-04-29 13:10:02',18,18),(160,'2021-04-29 19:10:02',18,18),(161,'2021-04-30 01:10:02',18,18),(162,'2021-04-30 07:20:02',18,18),(163,'2021-04-30 13:30:01',18,18),(164,'2021-04-30 19:30:01',18,18),(165,'2021-05-01 01:30:01',18,18),(166,'2021-05-01 07:30:02',18,18),(167,'2021-05-01 13:40:01',18,18),(168,'2021-05-01 19:40:01',18,18),(169,'2021-05-02 01:40:02',18,18),(170,'2021-05-02 07:40:02',18,18),(171,'2021-05-02 13:40:02',18,18),(172,'2021-05-02 19:40:02',18,18),(173,'2021-05-03 01:40:02',18,18),(174,'2021-05-03 07:50:01',18,18),(175,'2021-05-03 13:50:02',18,18),(176,'2021-05-03 20:00:02',18,18),(177,'2021-05-04 02:10:01',18,18),(178,'2021-05-04 08:10:02',18,18),(179,'2021-05-04 14:20:01',18,18),(180,'2021-05-05 02:20:02',18,18),(181,'2021-05-05 14:20:01',18,18),(182,'2021-05-05 20:20:01',18,18),(183,'2021-05-06 02:20:01',18,18),(184,'2021-05-06 08:20:02',18,18),(185,'2021-05-06 14:30:01',18,18),(186,'2021-05-06 20:30:01',18,18),(187,'2021-05-07 02:30:01',18,18),(188,'2021-05-07 08:30:02',18,18),(189,'2021-05-07 14:40:02',18,18),(190,'2021-05-07 20:50:02',18,18),(191,'2021-05-08 02:50:02',18,18),(192,'2021-05-08 08:50:02',18,18),(193,'2021-05-08 15:00:01',18,18),(194,'2021-05-08 21:00:02',18,18),(195,'2021-05-09 03:10:02',18,18),(196,'2021-05-09 09:20:02',18,18),(197,'2021-05-09 15:30:01',18,18),(198,'2021-05-09 21:30:01',18,18),(199,'2021-05-10 03:30:01',18,18),(200,'2021-05-10 09:30:02',18,18),(201,'2021-05-10 15:40:02',18,18),(202,'2021-05-10 21:50:02',18,18),(203,'2021-05-11 04:00:02',18,18),(204,'2021-05-11 10:10:02',18,18),(205,'2021-05-11 16:10:02',18,18),(206,'2021-05-11 22:20:02',18,18),(207,'2021-05-12 04:30:01',18,18),(208,'2021-05-12 10:30:02',18,18),(209,'2021-05-12 16:40:02',18,18),(210,'2021-05-12 22:50:01',18,18),(211,'2021-05-13 04:50:02',18,18),(212,'2021-05-13 11:00:01',18,18),(213,'2021-05-13 17:00:02',18,18),(214,'2021-05-13 23:10:02',18,18),(215,'2021-05-14 05:20:01',18,18),(216,'2021-05-14 11:20:01',18,18),(217,'2021-05-14 17:20:02',18,18),(218,'2021-05-14 23:30:02',18,18),(219,'2021-05-15 05:30:02',18,18),(220,'2021-05-15 11:40:01',18,18),(221,'2021-05-15 17:40:02',18,18),(222,'2021-05-15 23:40:02',18,18),(223,'2021-05-16 05:50:02',18,18),(224,'2021-05-16 12:00:02',18,18),(225,'2021-05-16 18:10:01',18,18),(226,'2021-05-17 06:10:02',18,18),(227,'2021-05-17 12:20:01',18,18),(228,'2021-05-17 18:20:01',18,18),(229,'2021-05-18 00:20:01',18,18),(230,'2021-05-18 06:20:01',18,18),(231,'2021-05-18 12:20:02',18,18),(232,'2021-05-18 18:20:02',18,18),(233,'2021-05-19 00:30:02',18,18),(234,'2021-05-19 06:40:01',18,18),(235,'2021-05-19 12:40:02',18,18),(236,'2021-05-19 18:40:02',18,18),(237,'2021-05-20 00:50:02',18,18),(238,'2021-05-20 07:00:01',18,18),(239,'2021-05-20 13:00:01',18,18),(240,'2021-05-20 19:00:02',18,18),(241,'2021-05-21 01:00:02',18,18),(242,'2021-05-21 07:10:01',18,18),(243,'2021-05-21 13:10:02',18,18),(244,'2021-05-21 19:20:02',18,18),(245,'2021-05-22 01:30:01',18,18),(246,'2021-05-22 07:30:02',18,18),(247,'2021-05-22 13:40:01',18,18),(248,'2021-05-22 19:40:02',18,18),(249,'2021-05-23 01:50:02',18,18),(250,'2021-05-23 08:00:01',18,18),(251,'2021-05-23 14:00:03',18,18),(252,'2021-05-23 20:10:01',18,18),(253,'2021-05-24 02:10:01',18,18),(254,'2021-05-24 08:10:01',18,18),(255,'2021-05-24 14:10:01',18,18),(256,'2021-05-25 02:10:01',18,18),(257,'2021-05-25 08:10:01',18,18),(258,'2021-05-25 14:10:02',18,18),(259,'2021-05-25 20:10:02',18,18),(260,'2021-05-26 02:20:01',18,18),(261,'2021-05-26 08:20:02',18,18),(262,'2021-05-26 14:30:01',18,18),(263,'2021-05-27 02:30:01',18,18),(264,'2021-05-27 08:30:02',18,18),(265,'2021-05-27 14:40:01',18,18),(266,'2021-05-27 20:40:01',18,18),(267,'2021-05-28 02:40:01',18,18),(268,'2021-05-28 08:40:01',18,18),(269,'2021-05-28 14:40:02',18,18),(270,'2021-05-28 20:50:02',18,18),(271,'2021-05-29 03:00:02',18,18),(272,'2021-05-29 09:10:02',18,18),(273,'2021-05-29 15:10:02',18,18),(274,'2021-05-29 21:10:02',18,18),(275,'2021-05-30 03:10:02',18,18),(276,'2021-05-30 09:20:01',18,18),(277,'2021-05-30 15:20:01',18,18),(278,'2021-05-30 21:20:01',18,18),(279,'2021-05-31 03:20:01',18,18),(280,'2021-05-31 09:20:01',18,18),(281,'2021-05-31 15:20:01',18,18),(282,'2021-05-31 21:20:02',18,18),(283,'2021-06-01 03:30:01',18,18),(284,'2021-06-01 09:30:02',18,18),(285,'2021-06-01 15:40:01',18,18),(286,'2021-06-01 21:40:01',18,18),(287,'2021-06-02 03:40:01',18,18),(288,'2021-06-02 09:40:02',18,18),(289,'2021-06-02 15:50:01',18,18),(290,'2021-06-02 21:50:01',18,18),(291,'2021-06-03 03:50:38',18,18),(292,'2021-06-03 10:00:01',18,18),(293,'2021-06-03 16:00:02',18,18),(294,'2021-06-03 22:00:02',18,18),(295,'2021-06-04 04:00:02',18,18),(296,'2021-06-04 10:10:01',18,18),(297,'2021-06-04 16:10:02',18,18),(298,'2021-06-04 22:20:02',18,18),(299,'2021-06-05 04:30:02',18,18),(300,'2021-06-05 10:40:01',18,18),(301,'2021-06-05 16:40:02',18,18),(302,'2021-06-05 22:40:02',18,18),(303,'2021-06-06 04:50:02',18,18),(304,'2021-06-06 16:50:02',18,18),(305,'2021-06-06 22:50:02',18,18),(306,'2021-06-07 05:00:01',18,18),(307,'2021-06-07 11:00:02',18,18),(308,'2021-06-07 17:10:02',18,18),(309,'2021-06-07 21:06:43',18,18),(310,'2021-06-08 03:10:02',18,18),(311,'2021-06-08 09:20:02',18,18),(312,'2021-06-08 15:30:01',18,18),(313,'2021-06-08 21:30:01',18,18),(314,'2021-06-09 03:30:01',18,18),(315,'2021-06-09 15:30:01',18,18),(316,'2021-06-09 21:30:01',18,18),(317,'2021-06-10 03:30:02',18,18),(318,'2021-06-10 15:30:02',18,18),(319,'2021-06-10 21:40:01',18,18),(320,'2021-06-11 03:40:01',18,18),(321,'2021-06-11 09:40:02',18,18),(322,'2021-06-11 15:50:01',18,18),(323,'2021-06-11 21:50:02',18,18);
/*!40000 ALTER TABLE `StatisticSnapshot` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `StatisticSnapshotUnit`
--

DROP TABLE IF EXISTS `StatisticSnapshotUnit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `StatisticSnapshotUnit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stockLevel` int(11) NOT NULL,
  `statisticSnapshot_id` int(11) DEFAULT NULL,
  `partUnit_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_368BD669A16DD05F` (`statisticSnapshot_id`),
  KEY `IDX_368BD669F7A36E87` (`partUnit_id`),
  CONSTRAINT `FK_368BD669A16DD05F` FOREIGN KEY (`statisticSnapshot_id`) REFERENCES `StatisticSnapshot` (`id`),
  CONSTRAINT `FK_368BD669F7A36E87` FOREIGN KEY (`partUnit_id`) REFERENCES `PartUnit` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=324 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `StatisticSnapshotUnit`
--

LOCK TABLES `StatisticSnapshotUnit` WRITE;
/*!40000 ALTER TABLE `StatisticSnapshotUnit` DISABLE KEYS */;
INSERT INTO `StatisticSnapshotUnit` VALUES (1,0,1,1),(2,0,2,1),(3,3,3,1),(4,3,4,1),(5,3,5,1),(6,3,6,1),(7,3,7,1),(8,7,8,1),(9,7,9,1),(10,7,10,1),(11,7,11,1),(12,7,12,1),(13,7,13,1),(14,7,14,1),(15,7,15,1),(16,7,16,1),(17,7,17,1),(18,7,18,1),(19,7,19,1),(20,7,20,1),(21,7,21,1),(22,7,22,1),(23,7,23,1),(24,7,24,1),(25,7,25,1),(26,7,26,1),(27,7,27,1),(28,7,28,1),(29,7,29,1),(30,7,30,1),(31,7,31,1),(32,7,32,1),(33,7,33,1),(34,7,34,1),(35,7,35,1),(36,7,36,1),(37,8,37,1),(38,8,38,1),(39,8,39,1),(40,8,40,1),(41,8,41,1),(42,8,42,1),(43,8,43,1),(44,8,44,1),(45,8,45,1),(46,8,46,1),(47,8,47,1),(48,8,48,1),(49,8,49,1),(50,8,50,1),(51,8,51,1),(52,9,52,1),(53,9,53,1),(54,9,54,1),(55,9,55,1),(56,9,56,1),(57,9,57,1),(58,9,58,1),(59,9,59,1),(60,9,60,1),(61,9,61,1),(62,9,62,1),(63,9,63,1),(64,9,64,1),(65,9,65,1),(66,25,66,1),(67,25,67,1),(68,25,68,1),(69,25,69,1),(70,25,70,1),(71,25,71,1),(72,25,72,1),(73,30,73,1),(74,30,74,1),(75,30,75,1),(76,30,76,1),(77,30,77,1),(78,30,78,1),(79,30,79,1),(80,30,80,1),(81,30,81,1),(82,30,82,1),(83,30,83,1),(84,30,84,1),(85,30,85,1),(86,30,86,1),(87,30,87,1),(88,30,88,1),(89,30,89,1),(90,30,90,1),(91,30,91,1),(92,30,92,1),(93,30,93,1),(94,30,94,1),(95,30,95,1),(96,30,96,1),(97,30,97,1),(98,30,98,1),(99,30,99,1),(100,30,100,1),(101,30,101,1),(102,30,102,1),(103,30,103,1),(104,30,104,1),(105,30,105,1),(106,30,106,1),(107,30,107,1),(108,30,108,1),(109,30,109,1),(110,30,110,1),(111,30,111,1),(112,30,112,1),(113,30,113,1),(114,30,114,1),(115,30,115,1),(116,30,116,1),(117,30,117,1),(118,30,118,1),(119,30,119,1),(120,30,120,1),(121,30,121,1),(122,26,122,1),(123,26,123,1),(124,26,124,1),(125,26,125,1),(126,26,126,1),(127,26,127,1),(128,26,128,1),(129,26,129,1),(130,26,130,1),(131,26,131,1),(132,26,132,1),(133,26,133,1),(134,26,134,1),(135,26,135,1),(136,26,136,1),(137,26,137,1),(138,26,138,1),(139,26,139,1),(140,26,140,1),(141,26,141,1),(142,26,142,1),(143,26,143,1),(144,26,144,1),(145,26,145,1),(146,26,146,1),(147,26,147,1),(148,26,148,1),(149,26,149,1),(150,26,150,1),(151,26,151,1),(152,26,152,1),(153,26,153,1),(154,26,154,1),(155,26,155,1),(156,26,156,1),(157,26,157,1),(158,26,158,1),(159,26,159,1),(160,26,160,1),(161,26,161,1),(162,26,162,1),(163,26,163,1),(164,26,164,1),(165,26,165,1),(166,26,166,1),(167,26,167,1),(168,26,168,1),(169,26,169,1),(170,26,170,1),(171,26,171,1),(172,26,172,1),(173,26,173,1),(174,26,174,1),(175,26,175,1),(176,26,176,1),(177,26,177,1),(178,26,178,1),(179,26,179,1),(180,26,180,1),(181,26,181,1),(182,26,182,1),(183,26,183,1),(184,26,184,1),(185,26,185,1),(186,26,186,1),(187,26,187,1),(188,26,188,1),(189,26,189,1),(190,26,190,1),(191,26,191,1),(192,26,192,1),(193,26,193,1),(194,26,194,1),(195,26,195,1),(196,26,196,1),(197,26,197,1),(198,26,198,1),(199,26,199,1),(200,26,200,1),(201,26,201,1),(202,26,202,1),(203,26,203,1),(204,26,204,1),(205,26,205,1),(206,26,206,1),(207,26,207,1),(208,26,208,1),(209,26,209,1),(210,26,210,1),(211,26,211,1),(212,26,212,1),(213,26,213,1),(214,26,214,1),(215,26,215,1),(216,26,216,1),(217,26,217,1),(218,26,218,1),(219,26,219,1),(220,26,220,1),(221,26,221,1),(222,26,222,1),(223,26,223,1),(224,26,224,1),(225,26,225,1),(226,26,226,1),(227,26,227,1),(228,26,228,1),(229,26,229,1),(230,26,230,1),(231,26,231,1),(232,26,232,1),(233,26,233,1),(234,26,234,1),(235,26,235,1),(236,26,236,1),(237,26,237,1),(238,26,238,1),(239,26,239,1),(240,26,240,1),(241,26,241,1),(242,26,242,1),(243,26,243,1),(244,26,244,1),(245,26,245,1),(246,26,246,1),(247,26,247,1),(248,26,248,1),(249,26,249,1),(250,26,250,1),(251,26,251,1),(252,26,252,1),(253,26,253,1),(254,26,254,1),(255,26,255,1),(256,26,256,1),(257,26,257,1),(258,26,258,1),(259,26,259,1),(260,26,260,1),(261,26,261,1),(262,26,262,1),(263,26,263,1),(264,26,264,1),(265,26,265,1),(266,26,266,1),(267,26,267,1),(268,26,268,1),(269,26,269,1),(270,26,270,1),(271,26,271,1),(272,26,272,1),(273,26,273,1),(274,26,274,1),(275,26,275,1),(276,26,276,1),(277,26,277,1),(278,26,278,1),(279,26,279,1),(280,26,280,1),(281,26,281,1),(282,26,282,1),(283,26,283,1),(284,26,284,1),(285,26,285,1),(286,26,286,1),(287,26,287,1),(288,26,288,1),(289,26,289,1),(290,26,290,1),(291,26,291,1),(292,26,292,1),(293,26,293,1),(294,26,294,1),(295,26,295,1),(296,26,296,1),(297,26,297,1),(298,26,298,1),(299,26,299,1),(300,26,300,1),(301,26,301,1),(302,26,302,1),(303,26,303,1),(304,26,304,1),(305,26,305,1),(306,26,306,1),(307,26,307,1),(308,26,308,1),(309,26,309,1),(310,26,310,1),(311,26,311,1),(312,26,312,1),(313,26,313,1),(314,26,314,1),(315,26,315,1),(316,26,316,1),(317,26,317,1),(318,26,318,1),(319,26,319,1),(320,26,320,1),(321,26,321,1),(322,26,322,1),(323,26,323,1);
/*!40000 ALTER TABLE `StatisticSnapshotUnit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `StockEntry`
--

DROP TABLE IF EXISTS `StockEntry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `StockEntry` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `part_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `stockLevel` int(11) NOT NULL,
  `price` decimal(13,4) DEFAULT NULL,
  `dateTime` datetime NOT NULL,
  `correction` tinyint(1) NOT NULL,
  `comment` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_E182997B4CE34BEC` (`part_id`),
  KEY `IDX_E182997BA76ED395` (`user_id`),
  CONSTRAINT `FK_E182997B4CE34BEC` FOREIGN KEY (`part_id`) REFERENCES `Part` (`id`),
  CONSTRAINT `FK_E182997BA76ED395` FOREIGN KEY (`user_id`) REFERENCES `PartKeeprUser` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `StockEntry`
--

LOCK TABLES `StockEntry` WRITE;
/*!40000 ALTER TABLE `StockEntry` DISABLE KEYS */;
INSERT INTO `StockEntry` VALUES (1,1,1,1,0.0000,'2021-03-18 22:31:57',0,NULL),(2,2,NULL,1,0.0000,'2021-03-18 22:33:05',0,NULL),(3,3,NULL,1,0.0000,'2021-03-18 22:35:07',0,NULL),(13,6,1,1,0.0000,'2021-03-27 14:59:17',0,NULL),(14,7,NULL,1,29.9500,'2021-03-31 19:33:04',0,NULL),(15,7,NULL,1,29.9500,'2021-03-31 19:33:04',0,NULL),(16,7,2,-1,NULL,'2021-03-31 19:34:51',0,''),(17,8,NULL,1,0.0000,'2021-04-04 22:44:55',0,NULL),(18,10,NULL,1,25.5000,'2021-04-04 22:57:07',0,NULL),(19,11,NULL,1,0.0000,'2021-04-04 23:03:16',0,NULL),(20,12,NULL,1,0.0000,'2021-04-04 23:10:05',0,NULL),(21,13,NULL,1,0.0000,'2021-04-04 23:14:30',0,NULL),(22,14,NULL,4,5.0000,'2021-04-04 23:17:16',0,NULL),(23,15,NULL,4,5.0000,'2021-04-04 23:20:20',0,NULL),(24,16,NULL,3,0.0000,'2021-04-04 23:24:05',0,NULL),(25,17,NULL,2,0.0000,'2021-04-06 18:40:01',0,NULL),(26,17,NULL,2,0.0000,'2021-04-06 18:40:01',0,NULL),(27,17,1,-2,0.0000,'2021-04-06 18:44:20',0,'Korrigiert'),(28,18,1,1,0.0000,'2021-04-06 18:45:57',0,''),(29,19,1,1,NULL,'2021-04-06 18:47:02',0,''),(30,20,NULL,1,0.0000,'2021-04-06 18:58:56',0,NULL);
/*!40000 ALTER TABLE `StockEntry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `StorageLocation`
--

DROP TABLE IF EXISTS `StorageLocation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `StorageLocation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_2C59071C5E237E06` (`name`),
  KEY `IDX_2C59071C12469DE2` (`category_id`),
  CONSTRAINT `FK_2C59071C12469DE2` FOREIGN KEY (`category_id`) REFERENCES `StorageLocationCategory` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `StorageLocation`
--

LOCK TABLES `StorageLocation` WRITE;
/*!40000 ALTER TABLE `StorageLocation` DISABLE KEYS */;
INSERT INTO `StorageLocation` VALUES (1,3,'Rollwagen'),(2,3,'Regal links'),(3,3,'Regal mitte'),(4,3,'Regal rechts'),(5,3,'Innenraum'),(6,4,'> Heinz'),(7,4,'> Stefan'),(8,3,'Unbekannt');
/*!40000 ALTER TABLE `StorageLocation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `StorageLocationCategory`
--

DROP TABLE IF EXISTS `StorageLocationCategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `StorageLocationCategory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `lft` int(11) NOT NULL,
  `rgt` int(11) NOT NULL,
  `lvl` int(11) NOT NULL,
  `root` int(11) DEFAULT NULL,
  `name` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `categoryPath` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_3E39FA47727ACA70` (`parent_id`),
  KEY `IDX_3E39FA47DA439252` (`lft`),
  KEY `IDX_3E39FA47D5E02D69` (`rgt`),
  CONSTRAINT `FK_3E39FA47727ACA70` FOREIGN KEY (`parent_id`) REFERENCES `StorageLocationCategory` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `StorageLocationCategory`
--

LOCK TABLES `StorageLocationCategory` WRITE;
/*!40000 ALTER TABLE `StorageLocationCategory` DISABLE KEYS */;
INSERT INTO `StorageLocationCategory` VALUES (1,NULL,1,8,0,1,'Root Category',NULL,'Root Category'),(2,1,2,5,1,1,'HdG','Haus des Gastes','Root Category ➤ HdG'),(3,2,3,4,2,1,'Töpferraum','','Root Category ➤ HdG ➤ Töpferraum'),(4,1,6,7,1,1,'Ausgeliehen an','','Root Category ➤ Ausgeliehen an');
/*!40000 ALTER TABLE `StorageLocationCategory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `StorageLocationImage`
--

DROP TABLE IF EXISTS `StorageLocationImage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `StorageLocationImage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `filename` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `originalname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mimetype` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `size` int(11) NOT NULL,
  `extension` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `created` datetime NOT NULL,
  `storageLocation_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_666717F073CD58AF` (`storageLocation_id`),
  CONSTRAINT `FK_666717F073CD58AF` FOREIGN KEY (`storageLocation_id`) REFERENCES `StorageLocation` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `StorageLocationImage`
--

LOCK TABLES `StorageLocationImage` WRITE;
/*!40000 ALTER TABLE `StorageLocationImage` DISABLE KEYS */;
/*!40000 ALTER TABLE `StorageLocationImage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SystemNotice`
--

DROP TABLE IF EXISTS `SystemNotice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SystemNotice` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8_unicode_ci NOT NULL,
  `acknowledged` tinyint(1) NOT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SystemNotice`
--

LOCK TABLES `SystemNotice` WRITE;
/*!40000 ALTER TABLE `SystemNotice` DISABLE KEYS */;
/*!40000 ALTER TABLE `SystemNotice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SystemPreference`
--

DROP TABLE IF EXISTS `SystemPreference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SystemPreference` (
  `preferenceKey` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `preferenceValue` longtext COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`preferenceKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SystemPreference`
--

LOCK TABLES `SystemPreference` WRITE;
/*!40000 ALTER TABLE `SystemPreference` DISABLE KEYS */;
/*!40000 ALTER TABLE `SystemPreference` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TempImage`
--

DROP TABLE IF EXISTS `TempImage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TempImage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `filename` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `originalname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mimetype` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `size` int(11) NOT NULL,
  `extension` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TempImage`
--

LOCK TABLES `TempImage` WRITE;
/*!40000 ALTER TABLE `TempImage` DISABLE KEYS */;
INSERT INTO `TempImage` VALUES (1,'temp','c72d19c2-8832-11eb-a674-6aef79b6346a','3dp_ultimaker_logo-300x271.jpg','image/jpeg',12171,'',NULL,'2021-03-18 22:42:03'),(2,'temp','d6d80d5a-8832-11eb-80dc-8e42b6eb7ca1','3dp_ultimaker_logo-300x271.jpg','image/jpeg',12171,'',NULL,'2021-03-18 22:42:29'),(3,'temp','e2fc52d0-8832-11eb-87fa-1d3e9922d494','3dp_ultimaker_logo-300x271.jpg','image/jpeg',12171,'',NULL,'2021-03-18 22:42:50'),(4,'temp','7f03db30-8833-11eb-8d19-d1d3888405cb','3dp_ultimaker_logo-300x271.jpg','image/jpeg',12171,'',NULL,'2021-03-18 22:47:12');
/*!40000 ALTER TABLE `TempImage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TempUploadedFile`
--

DROP TABLE IF EXISTS `TempUploadedFile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TempUploadedFile` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `filename` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `originalname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mimetype` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `size` int(11) NOT NULL,
  `extension` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TempUploadedFile`
--

LOCK TABLES `TempUploadedFile` WRITE;
/*!40000 ALTER TABLE `TempUploadedFile` DISABLE KEYS */;
INSERT INTO `TempUploadedFile` VALUES (2,'tempfile','bd24ac6e-8833-11eb-8cf3-dc2727568df0','webcam.png','inode/x-empty',0,'',NULL,'2021-03-18 22:48:56'),(8,'tempfile','9b3e4cf8-9586-11eb-8d51-05e40395645a','Olimex-LPC-P1227.jpg','',22491,'jpeg',NULL,'2021-04-04 22:44:52'),(9,'tempfile','4f5ce8d8-9588-11eb-93e4-637b8c0bd130','RPI_MUSB_2_SATA_01.jpg','',10711,'jpeg',NULL,'2021-04-04 22:57:04'),(11,'tempfile','23b0cbb8-9589-11eb-8a32-4590df2519e4','Logic-shrimp-v1.jpg','',54457,'jpeg',NULL,'2021-04-04 23:03:00'),(12,'tempfile','0fc100cc-958a-11eb-b73a-59d34bddca2d','MCIMX28LCD.JPG','',19389,'jpeg',NULL,'2021-04-04 23:09:36'),(13,'tempfile','bd96fc74-958a-11eb-9de8-f02ce5ffb004','DEV-10549.jpg','',61071,'jpeg',NULL,'2021-04-04 23:14:28'),(15,'tempfile','7faf5892-958b-11eb-91ff-7eb026053af9','00497-01b.jpg','',87101,'jpeg',NULL,'2021-04-04 23:19:54'),(16,'tempfile','0c216f40-958c-11eb-823d-9050ff881616','Polulu-Boost-Regulator.jpg','',47386,'jpeg',NULL,'2021-04-04 23:23:49');
/*!40000 ALTER TABLE `TempUploadedFile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TipOfTheDay`
--

DROP TABLE IF EXISTS `TipOfTheDay`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TipOfTheDay` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TipOfTheDay`
--

LOCK TABLES `TipOfTheDay` WRITE;
/*!40000 ALTER TABLE `TipOfTheDay` DISABLE KEYS */;
/*!40000 ALTER TABLE `TipOfTheDay` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TipOfTheDayHistory`
--

DROP TABLE IF EXISTS `TipOfTheDayHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TipOfTheDayHistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_3177BC2A76ED395` (`user_id`),
  CONSTRAINT `FK_3177BC2A76ED395` FOREIGN KEY (`user_id`) REFERENCES `PartKeeprUser` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TipOfTheDayHistory`
--

LOCK TABLES `TipOfTheDayHistory` WRITE;
/*!40000 ALTER TABLE `TipOfTheDayHistory` DISABLE KEYS */;
/*!40000 ALTER TABLE `TipOfTheDayHistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Unit`
--

DROP TABLE IF EXISTS `Unit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Unit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `symbol` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Unit`
--

LOCK TABLES `Unit` WRITE;
/*!40000 ALTER TABLE `Unit` DISABLE KEYS */;
INSERT INTO `Unit` VALUES (1,'Meter','m'),(2,'Gram','g'),(3,'Second','s'),(4,'Kelvin','K'),(5,'Mol','mol'),(6,'Candela','cd'),(7,'Ampere','A'),(8,'Ohm','Ω'),(9,'Volt','V'),(10,'Hertz','Hz'),(11,'Newton','N'),(12,'Pascal','Pa'),(13,'Joule','J'),(14,'Watt','W'),(15,'Coulomb','C'),(16,'Farad','F'),(17,'Siemens','S'),(18,'Weber','Wb'),(19,'Tesla','T'),(20,'Henry','H'),(21,'Celsius','°C'),(22,'Lumen','lm'),(23,'Lux','lx'),(24,'Becquerel','Bq'),(25,'Gray','Gy'),(26,'Sievert','Sv'),(27,'Katal','kat'),(28,'Ampere Hour','Ah');
/*!40000 ALTER TABLE `Unit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UnitSiPrefixes`
--

DROP TABLE IF EXISTS `UnitSiPrefixes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UnitSiPrefixes` (
  `unit_id` int(11) NOT NULL,
  `siprefix_id` int(11) NOT NULL,
  PRIMARY KEY (`unit_id`,`siprefix_id`),
  KEY `IDX_72356740F8BD700D` (`unit_id`),
  KEY `IDX_723567409BE9F1F4` (`siprefix_id`),
  CONSTRAINT `FK_723567409BE9F1F4` FOREIGN KEY (`siprefix_id`) REFERENCES `SiPrefix` (`id`),
  CONSTRAINT `FK_72356740F8BD700D` FOREIGN KEY (`unit_id`) REFERENCES `Unit` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UnitSiPrefixes`
--

LOCK TABLES `UnitSiPrefixes` WRITE;
/*!40000 ALTER TABLE `UnitSiPrefixes` DISABLE KEYS */;
INSERT INTO `UnitSiPrefixes` VALUES (1,8),(1,11),(1,12),(1,13),(1,14),(1,15),(1,16),(2,8),(2,11),(2,14),(3,11),(3,14),(4,11),(5,11),(6,14),(7,8),(7,11),(7,14),(7,15),(7,16),(7,17),(8,5),(8,6),(8,8),(8,11),(8,14),(8,15),(9,8),(9,11),(9,14),(10,5),(10,6),(10,8),(10,11),(10,14),(11,8),(11,11),(12,8),(12,11),(12,14),(13,8),(13,11),(13,14),(13,15),(14,6),(14,7),(14,8),(14,11),(14,14),(14,15),(15,8),(15,11),(16,11),(16,14),(16,15),(16,16),(16,17),(17,11),(17,14),(18,11),(19,11),(20,11),(20,14),(20,15),(21,11),(22,11),(23,11),(24,11),(25,11),(26,11),(26,14),(26,15),(27,11),(28,8),(28,11),(28,14);
/*!40000 ALTER TABLE `UnitSiPrefixes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserPreference`
--

DROP TABLE IF EXISTS `UserPreference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UserPreference` (
  `user_id` int(11) NOT NULL,
  `preferenceKey` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `preferenceValue` longtext COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`preferenceKey`,`user_id`),
  KEY `IDX_922CE7A2A76ED395` (`user_id`),
  CONSTRAINT `FK_922CE7A2A76ED395` FOREIGN KEY (`user_id`) REFERENCES `PartKeeprUser` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserPreference`
--

LOCK TABLES `UserPreference` WRITE;
/*!40000 ALTER TABLE `UserPreference` DISABLE KEYS */;
INSERT INTO `UserPreference` VALUES (1,'partkeepr.categorytree.showdescriptions','s:4:\"true\";'),(2,'partkeepr.categorytree.showdescriptions','s:4:\"true\";'),(1,'partkeepr.partmanager.compactlayout','s:5:\"false\";'),(2,'partkeepr.partmanager.compactlayout','s:5:\"false\";'),(1,'partkeepr.tipoftheday.showtips','s:5:\"false\";'),(2,'partkeepr.tipoftheday.showtips','s:5:\"false\";'),(1,'partkeepr.user.theme','s:9:\"\"classic\"\";'),(2,'partkeepr.user.theme','s:9:\"\"classic\"\";');
/*!40000 ALTER TABLE `UserPreference` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserProvider`
--

DROP TABLE IF EXISTS `UserProvider`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UserProvider` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `editable` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserProvider`
--

LOCK TABLES `UserProvider` WRITE;
/*!40000 ALTER TABLE `UserProvider` DISABLE KEYS */;
INSERT INTO `UserProvider` VALUES (1,'Builtin',1);
/*!40000 ALTER TABLE `UserProvider` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-06-12  1:00:04
