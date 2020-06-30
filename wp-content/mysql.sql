-- MySQL dump 10.13  Distrib 5.7.29-32, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: wp_cmetree
-- ------------------------------------------------------
-- Server version	5.7.29-32-log

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
/*!50717 SELECT COUNT(*) INTO @rocksdb_has_p_s_session_variables FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'performance_schema' AND TABLE_NAME = 'session_variables' */;
/*!50717 SET @rocksdb_get_is_supported = IF (@rocksdb_has_p_s_session_variables, 'SELECT COUNT(*) INTO @rocksdb_is_supported FROM performance_schema.session_variables WHERE VARIABLE_NAME=\'rocksdb_bulk_load\'', 'SELECT 0') */;
/*!50717 PREPARE s FROM @rocksdb_get_is_supported */;
/*!50717 EXECUTE s */;
/*!50717 DEALLOCATE PREPARE s */;
/*!50717 SET @rocksdb_enable_bulk_load = IF (@rocksdb_is_supported, 'SET SESSION rocksdb_bulk_load = 1', 'SET @rocksdb_dummy_bulk_load = 0') */;
/*!50717 PREPARE s FROM @rocksdb_enable_bulk_load */;
/*!50717 EXECUTE s */;
/*!50717 DEALLOCATE PREPARE s */;

--
-- Table structure for table `tree`
--

DROP TABLE IF EXISTS `tree`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree` (
  `treeID` int(11) NOT NULL AUTO_INCREMENT,
  `treeSlug` varchar(255) NOT NULL DEFAULT '',
  `treeContent` varchar(512) NOT NULL DEFAULT '',
  `treeTitle` varchar(255) NOT NULL DEFAULT '',
  `treeCreatedAt` timestamp NOT NULL DEFAULT '1970-01-01 06:00:00',
  `treeUpdatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `treeDeleted` tinyint(1) DEFAULT '0',
  `treeOwner` int(11) DEFAULT NULL,
  `treeCreatedBy` int(11) DEFAULT NULL,
  `treeUpdatedBy` int(11) DEFAULT NULL,
  PRIMARY KEY (`treeID`),
  UNIQUE KEY `treeSlug_UNIQUE` (`treeSlug`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tree`
--

LOCK TABLES `tree` WRITE;
/*!40000 ALTER TABLE `tree` DISABLE KEYS */;
INSERT INTO `tree` VALUES (1,'citizen','','Are You Eligible to be a US Citizen?','2017-07-19 13:50:44','2017-08-16 09:41:30',0,1,1,1),(4,'testing-tree-create','','Testing Tree Create','1970-01-01 06:00:00','2020-04-22 16:59:26',0,172,172,172),(5,'testing-command','','Testing Command','1970-01-01 06:00:00','2020-06-19 19:24:18',0,17,17,17),(6,'testing-another','','Testing Another','1970-01-01 06:00:00','2020-06-19 19:57:52',0,17,17,17),(7,'how-to-register-to-vote-in-texas','','How to Register to Vote in Texas','1970-01-01 06:00:00','2020-06-23 17:41:42',0,172,172,172),(8,'test-one','','test one','1970-01-01 06:00:00','2020-06-22 20:59:38',0,172,172,172),(9,'test-two','','test two','1970-01-01 06:00:00','2020-06-22 21:10:40',0,172,172,172),(10,'test-three','','test three','1970-01-01 06:00:00','2020-06-22 21:29:14',0,172,172,172),(11,'test-four','','test four','1970-01-01 06:00:00','2020-06-22 21:43:24',0,172,172,172),(12,'test-five','','test five','1970-01-01 06:00:00','2020-06-22 21:47:22',0,172,172,172),(13,'test-six','','test six','1970-01-01 06:00:00','2020-06-22 21:51:47',0,172,172,172),(14,'test-seven','','test seven','1970-01-01 06:00:00','2020-06-22 21:55:05',0,172,172,172),(15,'vote','','Vote','1970-01-01 06:00:00','2020-06-23 18:00:46',0,172,172,172),(16,'citizen2','','Citizen2','1970-01-01 06:00:00','2020-06-24 15:58:43',0,172,172,172),(17,'citizen3','','Citizen3','1970-01-01 06:00:00','2020-06-26 01:10:12',0,172,172,172);
/*!40000 ALTER TABLE `tree` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`cmetree`@`%`*/ /*!50003 TRIGGER treeInsertTrigger
BEFORE INSERT ON `wp_cmetree`.`tree`
FOR EACH ROW
BEGIN
IF NEW.treeCreatedAt = '1970-01-01 %' THEN
SET NEW.treeCreatedAt = NOW();
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary table structure for view `treeAPI`
--

DROP TABLE IF EXISTS `treeAPI`;
/*!50001 DROP VIEW IF EXISTS `treeAPI`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeAPI` AS SELECT 
 1 AS `treeID`,
 1 AS `treeSlug`,
 1 AS `title`,
 1 AS `content`,
 1 AS `createdAt`,
 1 AS `updatedAt`,
 1 AS `owner`,
 1 AS `deleted`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `treeElement`
--

DROP TABLE IF EXISTS `treeElement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `treeElement` (
  `elID` int(11) NOT NULL AUTO_INCREMENT,
  `treeID` int(11) DEFAULT NULL,
  `elTypeID` int(11) DEFAULT NULL,
  `elTitle` varchar(255) NOT NULL DEFAULT '',
  `elContent` varchar(512) NOT NULL DEFAULT '',
  `elCreatedBy` int(11) DEFAULT NULL,
  `elUpdatedBy` int(11) DEFAULT NULL,
  `elCreatedAt` timestamp NOT NULL DEFAULT '1970-01-01 06:00:00',
  `elUpdatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `elDeleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`elID`),
  KEY `elTypeIDIDx` (`elTypeID`),
  KEY `treeIDIDx` (`treeID`),
  CONSTRAINT `elementElTypeID` FOREIGN KEY (`elTypeID`) REFERENCES `treeElementType` (`elTypeID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `elementTreeID` FOREIGN KEY (`treeID`) REFERENCES `tree` (`treeID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=475 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `treeElement`
--

LOCK TABLES `treeElement` WRITE;
/*!40000 ALTER TABLE `treeElement` DISABLE KEYS */;
INSERT INTO `treeElement` VALUES (1,1,1,'Attachment A','I have been a Permanent Resident for three to five years',1,1,'2017-07-19 13:50:44','2018-04-27 09:45:48',0),(2,1,2,'I am at least 18 years old.','',1,1,'2017-07-19 13:50:44','2018-04-27 09:45:49',0),(3,1,3,'True','',1,1,'2017-07-19 13:50:44','2018-04-27 09:45:50',0),(4,1,3,'False','',1,1,'2017-07-19 13:50:44','2018-04-27 09:45:51',0),(5,1,4,'Eligible','You can apply for US Citizenship if you want to.',1,1,'2017-07-19 13:50:44','2018-04-27 09:45:52',0),(6,1,4,'May Not Be Eligible','You will get rejected from US Citizenship if you apply right now.',1,1,'2017-07-19 13:50:44','2018-04-27 09:45:52',0),(7,1,3,'Start Over','Want to go through this decision tree again?',1,1,'2017-07-19 13:50:44','2018-04-27 09:45:53',0),(8,1,2,'I am a Permanent Resident of the United States.','',1,1,'2017-07-24 09:05:18','2018-04-27 09:45:55',0),(9,1,3,'True','',1,1,'2017-07-24 09:07:24','2018-04-27 09:45:55',0),(10,1,3,'False','',1,1,'2017-07-24 09:07:24','2018-04-27 09:45:56',0),(11,1,2,'I have been issued a Permanent Resident Card (formerly called Alien Registration Card).','',1,1,'2017-07-24 09:07:35','2018-04-27 09:45:57',0),(12,1,3,'True','',1,1,'2017-07-24 09:07:35','2018-04-27 09:45:57',0),(13,1,3,'False','',1,1,'2017-07-24 09:07:35','2018-04-27 09:45:58',0),(14,1,2,'I have been a permanent resident for','',1,1,'2017-07-24 09:07:35','2018-04-27 09:45:58',0),(15,1,3,'Less than three years','',1,1,'2017-07-24 09:07:35','2018-04-27 09:45:59',0),(16,1,3,'Three or more years','',1,1,'2017-07-24 09:07:35','2018-04-27 09:45:59',0),(17,1,3,'Five or more years','',1,1,'2017-07-24 09:07:35','2018-04-27 09:46:00',0),(18,1,2,'I am married to and living with a US Citizen.','',1,1,'2017-07-24 09:07:35','2018-04-27 09:46:01',0),(19,1,3,'True','',1,1,'2017-07-24 09:07:35','2018-04-27 09:46:01',0),(20,1,3,'False','',1,1,'2017-07-24 09:07:35','2018-04-27 09:46:02',0),(21,1,2,'I have been married to that US Citizen for at least the past three years.','',1,1,'2017-07-24 09:07:35','2018-04-27 09:46:03',0),(22,1,3,'True','',1,1,'2017-07-24 09:07:35','2018-04-27 09:46:04',0),(23,1,3,'False','',1,1,'2017-07-24 09:07:35','2018-04-27 09:46:03',0),(26,1,2,'During the past three years, I have not been out of the country for 18 months or more.','',1,1,'2017-07-24 09:07:35','2018-04-27 09:46:06',0),(27,1,3,'True','',1,1,'2017-07-24 09:07:35','2018-04-27 09:46:07',0),(28,1,3,'False','',1,1,'2017-07-24 09:07:35','2018-04-27 09:46:10',0),(29,1,2,'During the last five years, I have not been out of the US for 30 months or more.','',1,1,'2017-07-24 09:07:35','2018-04-27 09:46:13',0),(30,1,3,'True','',1,1,'2017-07-24 09:07:35','2018-04-27 09:46:16',0),(31,1,3,'False','',1,1,'2017-07-24 09:07:35','2018-04-27 09:47:53',0),(33,1,2,'My spouse has been a US Citizen for at least the past three years.','',1,1,'2017-07-24 09:07:35','2018-04-27 09:47:53',0),(34,1,3,'True','',1,1,'2017-07-24 09:07:35','2018-04-27 09:47:53',0),(35,1,3,'False','',1,1,'2017-07-24 09:07:35','2018-04-27 09:47:53',0),(36,1,5,'Start','',NULL,NULL,'2017-07-25 11:07:47','2018-04-27 09:47:53',0),(37,1,3,'Start Over','',1,1,'2017-08-02 14:21:26','2018-04-27 09:47:53',0),(38,1,3,'Start Over','',1,1,'2017-08-02 14:21:26','2018-04-27 09:47:53',0),(40,1,2,'During the last three to five years, I have not taken a trip out of the United States that lasted one year or more.','',1,1,'2017-08-14 16:37:22','2018-04-27 09:47:53',0),(41,1,3,'True','',1,1,'2017-08-14 16:37:22','2018-04-27 09:47:53',0),(42,1,3,'False','',1,1,'2017-08-14 16:37:22','2018-04-27 09:47:53',0),(43,1,2,'I have resided in the district or state in which I am applying for citizenship for the last three months.','',1,1,'2017-08-14 16:42:42','2018-04-27 09:47:53',0),(44,1,3,'True','',1,1,'2017-08-14 16:42:42','2018-04-27 09:47:53',0),(45,1,3,'False','',1,1,'2017-08-14 16:42:42','2018-04-27 09:47:53',0),(46,1,2,'I can read, write and speak basic English.','',1,1,'2017-08-14 16:54:19','2018-04-27 09:47:53',0),(47,1,3,'True','',1,1,'2017-08-14 16:54:19','2018-04-27 09:47:53',0),(48,1,3,'False','',1,1,'2017-08-14 16:54:19','2018-04-27 09:47:53',0),(49,1,2,'I know the fundamentals of U.S. history and the form and principles of the U.S. government.','',1,1,'2017-08-14 16:58:44','2018-04-27 09:47:53',0),(50,1,3,'True','',1,1,'2017-08-14 16:58:44','2018-04-27 09:47:53',0),(51,1,3,'False','',1,1,'2017-08-14 16:58:44','2018-04-27 09:47:53',0),(52,1,2,'I am a person of good moral character.','',1,1,'2017-08-14 17:01:47','2018-04-27 09:47:53',0),(53,1,3,'True','',1,1,'2017-08-14 17:01:47','2018-06-14 16:38:36',1),(54,1,3,'False','',1,1,'2017-08-14 17:01:47','2018-04-27 09:47:53',0),(61,1,2,'I am:','',1,1,'2017-08-15 09:21:27','2018-04-27 09:47:53',0),(62,1,2,'Since becoming a Permanent Resident, I have not taken a trip out of the United States that lasted for one year or more without an approved \"Application to Preserve Residence for Naturalization Purposes\" (Form N-470).','',1,1,'2017-08-15 09:22:05','2018-04-27 09:47:53',0),(63,1,2,'I am over 50 years old and have lived in the United States for at least 20 years since I became a Permanent Resident.','',1,1,'2017-08-15 09:22:14','2018-04-27 09:47:53',0),(64,1,2,'I am over 55 years old and have lived in the United States for at least 15 years since I became a Permanent Resident.','',1,1,'2017-08-15 09:45:44','2018-04-27 09:47:53',0),(65,1,2,'I have a disability that prevents me from fulfilling this requirement and will be filing a \"Medical Certification for Disability Exceptions\" (Form N-648) completed and signed by a doctor with my application.','',1,1,'2017-08-15 09:45:44','2018-04-27 09:47:53',0),(66,1,2,'I have a disability that prevents me from fulfilling the civics requirement, and I will be filing \"Medical Certification for Disability Exceptions\" (Form N-648) completed and signed by a doctor with my application.','',1,1,'2017-08-15 09:50:04','2018-04-27 09:47:53',0),(67,1,2,'I am female.','',1,1,'2017-08-15 09:58:27','2018-04-27 09:47:53',0),(68,1,2,'I have never deserted from the U.S. Armed Forces.','',1,1,'2017-08-15 09:58:27','2018-04-27 09:47:53',0),(69,1,2,'I have never received an exemption or discharge from the U.S. Armed Forces on the grounds that I am an alien. ','',1,1,'2017-08-15 09:58:27','2018-04-27 09:47:53',0),(70,1,2,'I am willing to perform either military or civilian service for the United States if required by law. (NOTE: If your religious teachings OR beliefs prohibit you from performing military service, you must be willing to perform non-military service.)','',1,1,'2017-08-15 09:58:27','2018-04-27 09:47:53',0),(71,1,2,'I will support the Constitution of the United States.','',1,1,'2017-08-15 09:58:27','2018-04-27 09:47:53',0),(72,1,2,'I understand and am willing to take an oath of allegiance to the United States.','',1,1,'2017-08-15 09:58:27','2018-04-27 09:47:53',0),(73,1,3,'A person who has served on board a vessel operated by or registered in the United States','',1,1,'2017-08-15 10:05:57','2018-04-27 09:47:53',0),(74,1,3,'An employee or an individual under contract to the U.S. Government.','',1,1,'2017-08-15 10:11:00','2018-04-27 09:47:53',0),(75,1,3,'A person who performs ministerial or priestly functions for a religious denomination or an interdenominational organization with a valid presence in the United States.','',1,1,'2017-08-15 10:11:00','2018-04-27 09:47:53',0),(76,1,3,'None of the above.','',1,1,'2017-08-15 10:11:00','2018-04-27 09:47:53',0),(77,1,3,'False','',1,1,'2017-08-15 10:40:59','2018-04-27 09:47:53',0),(78,1,3,'True','',1,1,'2017-08-15 10:40:59','2018-04-27 09:47:53',0),(79,1,3,'False','',1,1,'2017-08-15 10:45:55','2018-04-27 09:47:53',0),(80,1,3,'True','',1,1,'2017-08-15 10:45:55','2018-04-27 09:47:53',0),(81,1,3,'False','',1,1,'2017-08-15 10:46:53','2018-04-27 09:47:53',0),(82,1,3,'True','',1,1,'2017-08-15 10:46:53','2018-04-27 09:47:53',0),(83,1,3,'False','',1,1,'2017-08-15 10:48:09','2018-04-27 09:47:53',0),(84,1,3,'True','',1,1,'2017-08-15 10:48:09','2018-04-27 09:47:53',0),(85,1,3,'False','',1,1,'2017-08-15 10:55:23','2018-04-27 09:47:53',0),(86,1,3,'True','',1,1,'2017-08-15 10:55:23','2018-04-27 09:47:53',0),(87,1,3,'True','',1,1,'2017-08-15 10:58:01','2018-04-27 09:47:53',0),(88,1,2,' I am a male registered with the Selective Service.','',1,1,'2017-08-15 11:07:58','2018-04-27 09:47:53',0),(89,1,2,'I am a male who did not enter the United States under any status until after my 26th birthday.','',1,1,'2017-08-15 11:08:55','2018-04-27 09:47:53',0),(90,1,2,'I am a male who was in the United States between the ages of 18 and 26 but who did not register with the Selective Service, and I will send a \"Status Information Letter\" from the Selective Service explaining why I did not register with my application.','',1,1,'2017-08-15 11:10:14','2018-04-27 09:47:53',0),(91,1,2,'I am a male who was in the United States between the ages of 18 and 26 as a lawful nonimmigrant.','',1,1,'2017-08-15 11:11:23','2018-06-14 16:13:45',1),(92,1,3,'False','',1,1,'2017-08-15 11:13:02','2018-04-27 09:47:53',0),(93,1,3,'True','',1,1,'2017-08-15 11:13:02','2018-04-27 09:47:53',0),(94,1,3,'False','',1,1,'2017-08-15 11:14:34','2018-04-27 09:47:53',0),(95,1,3,'True','',1,1,'2017-08-15 11:14:34','2018-04-27 09:47:53',0),(96,1,3,'False','',1,1,'2017-08-15 11:17:00','2018-04-27 09:47:53',0),(97,1,3,'True','',1,1,'2017-08-15 11:17:00','2018-04-27 09:47:53',0),(98,1,3,'False','',1,1,'2017-08-15 11:17:49','2018-04-27 09:47:53',0),(99,1,3,'True','',1,1,'2017-08-15 11:17:49','2018-04-27 09:47:53',0),(100,1,3,'False','',1,1,'2017-08-15 11:19:13','2018-06-14 16:10:10',1),(101,1,3,'True','',1,1,'2017-08-15 11:19:13','2018-06-14 16:13:45',1),(102,1,3,'False','',1,1,'2017-08-15 11:20:15','2018-04-27 09:47:53',0),(103,1,3,'True','',1,1,'2017-08-15 11:20:15','2018-04-27 09:47:53',0),(104,1,3,'False','',1,1,'2017-08-15 11:21:00','2018-04-27 09:47:53',0),(105,1,3,'True','',1,1,'2017-08-15 11:21:00','2018-04-27 09:47:53',0),(106,1,3,'False','',1,1,'2017-08-15 11:23:15','2018-04-27 09:47:53',0),(107,1,3,'True','',1,1,'2017-08-15 11:23:15','2018-04-27 09:47:53',0),(108,1,3,'False','',1,1,'2017-08-15 11:24:07','2018-04-27 09:47:53',0),(109,1,3,'True','',1,1,'2017-08-15 11:24:07','2018-04-27 09:47:53',0),(110,1,3,'False','',1,1,'2017-08-15 11:25:14','2018-04-27 09:47:53',0),(111,1,3,'True','',1,1,'2017-08-15 11:25:14','2018-04-27 09:47:53',0),(112,1,1,'Attachment B','I have been out of the country for 30 months or more',1,1,'2017-08-15 11:29:35','2018-04-27 09:47:53',0),(113,1,1,'Attachment C','I have been out of the country for one year or more',1,1,'2017-08-15 11:29:35','2018-04-27 09:47:53',0),(114,1,1,'Attachment D','I cannot read, write or speak basic English',1,1,'2017-08-15 11:29:35','2018-04-27 09:47:53',0),(115,1,1,'Attachment E','I have a disability that prevents me from fulfilling the civics requirement',1,1,'2017-08-15 11:29:35','2018-04-27 09:47:53',0),(119,5,2,'My Question','',17,17,'1970-01-01 06:00:00','2020-06-19 19:47:32',0),(120,5,2,'My Question','',17,17,'1970-01-01 06:00:00','2020-06-19 19:48:17',0),(121,5,3,'Option 1','',172,172,'1970-01-01 06:00:00','2020-06-19 19:53:55',0),(122,5,3,'Option 2','',172,172,'1970-01-01 06:00:00','2020-06-19 19:54:00',0),(123,5,4,'','',172,172,'1970-01-01 06:00:00','2020-06-19 19:54:38',0),(124,6,4,'End Test','This is the end.',172,172,'1970-01-01 06:00:00','2020-06-19 20:03:59',0),(125,6,5,'Start Test','',172,172,'1970-01-01 06:00:00','2020-06-19 20:01:03',0),(126,6,2,'Test Question 1','',172,172,'1970-01-01 06:00:00','2020-06-19 20:04:30',0),(127,6,3,'Go to Question 2','',172,172,'1970-01-01 06:00:00','2020-06-19 20:04:42',0),(128,6,2,'Testing Question 2','',172,172,'1970-01-01 06:00:00','2020-06-19 20:05:00',0),(129,6,3,'Go to End','',172,172,'1970-01-01 06:00:00','2020-06-19 20:06:41',0),(130,6,3,'Go to End','',172,172,'1970-01-01 06:00:00','2020-06-19 20:07:16',0),(131,6,1,'New Group','This is the group content',172,172,'1970-01-01 06:00:00','2020-06-19 20:11:30',0),(132,6,2,'Question 3 is in the Group','',172,172,'1970-01-01 06:00:00','2020-06-19 20:11:38',0),(133,6,3,'Go to end','',172,172,'1970-01-01 06:00:00','2020-06-19 20:11:47',0),(134,6,3,'Go to End 2','',172,172,'1970-01-01 06:00:00','2020-06-19 20:12:09',1),(135,6,3,'Question 3','',172,172,'1970-01-01 06:00:00','2020-06-19 20:14:47',0),(136,7,5,'','',172,172,'1970-01-01 06:00:00','2020-06-22 17:45:20',1),(137,7,2,'','',172,172,'1970-01-01 06:00:00','2020-06-22 17:54:05',1),(138,7,5,'Are you registered to vote at your current address?','',172,172,'1970-01-01 06:00:00','2020-06-22 17:54:39',1),(139,7,2,'Are you registered to vote at your current address?','',172,172,'1970-01-01 06:00:00','2020-06-22 17:54:33',1),(140,7,2,'Are you registered to vote at your current address?','',172,172,'1970-01-01 06:00:00','2020-06-22 21:36:10',1),(141,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-22 21:36:09',1),(142,7,5,'Start','',172,172,'1970-01-01 06:00:00','2020-06-22 21:36:36',1),(143,1,3,'','',172,172,'1970-01-01 06:00:00','2020-06-22 17:56:22',1),(144,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-22 21:36:10',1),(145,7,3,'I don\'t know.','',172,172,'1970-01-01 06:00:00','2020-06-22 21:36:10',1),(146,7,4,'Thatâ€™s great. Be sure to vote in the next election.','COntent',172,172,'1970-01-01 06:00:00','2020-06-22 21:36:44',1),(147,7,4,'Decision tree ends.','** Temp content (what should be displayed ',172,172,'1970-01-01 06:00:00','2020-06-22 20:06:49',1),(148,7,2,'Are you a U.S. citizen?','',172,172,'1970-01-01 06:00:00','2020-06-22 20:47:30',1),(149,7,2,'Do you want to continue to find out how to register to vote in Texas?','',172,172,'1970-01-01 06:00:00','2020-06-22 21:36:13',1),(150,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-22 21:36:13',1),(151,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-22 20:47:30',1),(152,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-22 20:47:30',1),(153,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-22 21:36:13',1),(154,7,4,'You must be a U.S. citizen to vote in the state of Texas.','Content',172,172,'1970-01-01 06:00:00','2020-06-22 21:36:45',1),(155,7,2,'Are you a Texas resident?','',172,172,'1970-01-01 06:00:00','2020-06-22 20:47:27',1),(156,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-22 20:47:26',1),(157,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-22 20:47:26',1),(158,7,3,'I don\'t know','',172,172,'1970-01-01 06:00:00','2020-06-22 20:47:27',1),(159,7,2,'Are you at least 18 years old or older?','',172,172,'1970-01-01 06:00:00','2020-06-22 20:47:19',1),(160,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-22 20:47:19',1),(161,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-22 20:47:19',1),(162,7,2,'Are you currently at least 17 years and 10 months old and will you be age 18 by the Election Day you want to vote in? \n\nTo check when the next upcoming election is, visit https://www.votetexas.gov/. ','',172,172,'1970-01-01 06:00:00','2020-06-22 20:47:16',1),(163,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-22 20:47:16',1),(164,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-22 20:47:16',1),(165,7,4,'Unfortunately you must be at least 17 years and 10 months old, as well as 18 years old by Election Day, to register to vote in the state of Texas.','Content',172,172,'1970-01-01 06:00:00','2020-06-22 20:51:05',1),(166,7,2,'Have you ever been convicted of a felony?','',172,172,'1970-01-01 06:00:00','2020-06-22 20:47:07',1),(167,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-22 20:47:07',1),(168,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-22 20:47:07',1),(169,7,2,'Have you completed your sentence, probation, and parole? In other words, â€œAre you off paper?â€','',172,172,'1970-01-01 06:00:00','2020-06-22 20:47:03',1),(170,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-22 20:47:03',1),(171,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-22 20:47:03',1),(172,7,4,'You must have completed your sentence, probation, and parole to be eligible to vote in the state of Texas.','Content',172,172,'1970-01-01 06:00:00','2020-06-22 20:51:09',1),(173,7,2,'Have you ever been declared by a court exercising probate jurisdiction to be either totally mentally incapacitated or partially mentally incapacitated without the right to vote?','',172,172,'1970-01-01 06:00:00','2020-06-22 20:47:00',1),(174,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-22 20:47:00',1),(175,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-22 20:47:00',1),(176,7,2,'Are you a college student whose home address is in Texas?','',172,172,'1970-01-01 06:00:00','2020-06-22 20:46:56',1),(177,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-22 20:46:56',1),(178,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-22 20:46:56',1),(179,7,2,'Do you attend college in Texas?','',172,172,'1970-01-01 06:00:00','2020-06-22 20:46:50',1),(180,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-22 20:46:50',1),(181,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-22 20:46:50',1),(182,7,2,'You can choose to register either at your home address or at your university address. Where you choose to register will determine where you can vote and whatâ€™s on your ballot.\n\nDo you want to continue to find out how to register to vote in Texas?','',172,172,'1970-01-01 06:00:00','2020-06-22 20:46:44',1),(183,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-22 20:46:44',1),(184,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-22 20:46:44',1),(185,7,4,'You should be able to register to vote in Texas.','Visit https://www.votetexas.gov/register-to-vote/. Be sure to register by the deadline listed on the website, approximately 30 days before Election Day. There is no online voter registration in Texas, so print out the form this website provides and mail it to your local county Voter Registrar. You can find out the address of your local county Voter Registrar here: https://www.sos.state.tx.us/elections/voter/votregduties.shtml',172,172,'1970-01-01 06:00:00','2020-06-22 21:36:47',1),(186,7,4,'You must be a Texas resident to vote in the state of Texas. ','To register in your state of residency, visit turbovote.org for more information.',172,172,'1970-01-01 06:00:00','2020-06-22 21:36:49',1),(187,7,2,'Do you want to continue to find out how to register to vote in Texas?','',172,172,'1970-01-01 06:00:00','2020-06-22 20:47:22',1),(188,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-22 20:47:22',1),(189,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-22 20:47:22',1),(190,7,1,'Attachment A','Don\'t know if you are registered to vote at your current address?',172,172,'1970-01-01 06:00:00','2020-06-22 21:36:52',1),(191,7,1,'Attachment B','Do you want to continue to find out how to register to vote in Texas?',172,172,'1970-01-01 06:00:00','2020-06-22 20:42:43',1),(192,7,2,'Are you a US citizen?','',172,172,'1970-01-01 06:00:00','2020-06-22 21:36:17',1),(193,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-22 21:36:17',1),(194,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-22 21:36:17',1),(195,8,5,'Start','',172,172,'1970-01-01 06:00:00','2020-06-22 21:01:11',0),(196,8,2,'Are you registered to vote at your current address?','',172,172,'1970-01-01 06:00:00','2020-06-22 21:00:33',0),(197,8,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-22 21:00:40',0),(198,8,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-22 21:00:50',0),(199,8,3,'I don\'t know.','',172,172,'1970-01-01 06:00:00','2020-06-22 21:01:28',0),(200,8,2,'Do you want to continue to find out how to register to vote in Texas?','',172,172,'1970-01-01 06:00:00','2020-06-22 21:02:53',0),(201,8,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-22 21:03:20',0),(202,8,4,'Thatâ€™s great.','Be sure to vote in the next election. ',172,172,'1970-01-01 06:00:00','2020-06-22 21:04:03',0),(203,8,4,'You must register to vote in your state.','Question 2 as an end for testing.',172,172,'1970-01-01 06:00:00','2020-06-22 21:09:19',0),(204,8,1,'Group One Test Title','Group one test content ',172,172,'1970-01-01 06:00:00','2020-06-22 21:05:46',0),(205,8,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-22 21:08:10',0),(206,9,2,'Are you afraid of the dark?','',172,172,'1970-01-01 06:00:00','2020-06-22 21:11:16',0),(207,9,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-22 21:11:21',0),(208,9,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-22 21:11:24',0),(209,9,3,'Sort of','',172,172,'1970-01-01 06:00:00','2020-06-22 21:11:33',0),(210,9,2,'Are you 20 years old or older?','',172,172,'1970-01-01 06:00:00','2020-06-22 21:12:08',0),(211,9,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-22 21:12:14',0),(212,9,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-22 21:12:31',0),(213,9,4,'Great! You are not afraid of the dark.','test',172,172,'1970-01-01 06:00:00','2020-06-23 14:37:16',0),(214,9,4,'You need to grow up. ','test',172,172,'1970-01-01 06:00:00','2020-06-23 14:37:14',0),(215,9,4,'Get a counselor.','test',172,172,'1970-01-01 06:00:00','2020-06-23 15:26:44',1),(216,9,1,'Young = Scared','Young people get scared more often.',172,172,'1970-01-01 06:00:00','2020-06-22 21:18:43',0),(217,9,5,'Begin','',172,172,'1970-01-01 06:00:00','2020-06-22 21:15:47',0),(218,9,2,'Do you sleep with a favorite stuffed animal?','',172,172,'1970-01-01 06:00:00','2020-06-22 21:16:37',0),(219,9,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-22 21:16:46',0),(220,9,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-22 21:16:52',0),(221,9,4,'You should get a stuffed animal.','test',172,172,'1970-01-01 06:00:00','2020-06-23 15:26:41',1),(222,10,2,'Are you registered to vote at your current address?','',172,172,'1970-01-01 06:00:00','2020-06-22 21:30:04',0),(223,10,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-22 21:32:17',0),(224,10,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-22 21:32:22',0),(225,10,3,'','',172,172,'1970-01-01 06:00:00','2020-06-22 21:32:24',0),(226,7,2,'','',172,172,'1970-01-01 06:00:00','2020-06-22 21:36:40',1),(227,7,5,'start','',172,172,'1970-01-01 06:00:00','2020-06-22 21:37:22',0),(228,7,2,'Are you registered to vote at your current address?','',172,172,'1970-01-01 06:00:00','2020-06-22 21:42:13',1),(229,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-22 21:42:13',1),(230,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-22 21:42:13',1),(231,7,3,'I dont know.','',172,172,'1970-01-01 06:00:00','2020-06-22 21:42:13',1),(232,7,2,'','',172,172,'1970-01-01 06:00:00','2020-06-22 21:38:07',1),(233,7,4,'Thats great.','Be sure to vote in the next election.',172,172,'1970-01-01 06:00:00','2020-06-23 10:35:34',0),(234,7,1,'Group','content group',172,172,'1970-01-01 06:00:00','2020-06-23 19:59:14',1),(235,7,2,'Are you registered to vote at your current address?','',172,172,'1970-01-01 06:00:00','2020-06-23 12:14:52',0),(236,11,2,'Are you registered?','',172,172,'1970-01-01 06:00:00','2020-06-22 21:43:42',0),(237,11,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-22 21:43:46',0),(238,11,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-22 21:43:49',0),(239,11,3,'I dont know.','',172,172,'1970-01-01 06:00:00','2020-06-22 21:43:59',0),(240,11,4,'End title','end content',172,172,'1970-01-01 06:00:00','2020-06-22 21:44:14',0),(241,11,5,'start','',172,172,'1970-01-01 06:00:00','2020-06-22 21:44:21',0),(242,11,1,'group title','content',172,172,'1970-01-01 06:00:00','2020-06-22 21:46:47',0),(243,12,2,'Registered?','',172,172,'1970-01-01 06:00:00','2020-06-22 21:47:35',0),(244,12,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-22 21:47:38',0),(245,12,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-22 21:47:41',0),(246,12,3,'Dont know','',172,172,'1970-01-01 06:00:00','2020-06-22 21:47:47',0),(247,12,4,'End 01','01 content',172,172,'1970-01-01 06:00:00','2020-06-22 21:47:58',0),(248,12,5,'start','',172,172,'1970-01-01 06:00:00','2020-06-22 21:48:12',0),(249,12,1,'group','title',172,172,'1970-01-01 06:00:00','2020-06-22 21:48:26',0),(250,13,5,'start','',172,172,'1970-01-01 06:00:00','2020-06-22 21:51:58',0),(251,13,2,'Registered?','',172,172,'1970-01-01 06:00:00','2020-06-22 21:52:05',0),(252,13,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-22 21:52:08',0),(253,13,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-22 21:52:11',0),(254,13,4,'End 02','End 02 content',172,172,'1970-01-01 06:00:00','2020-06-22 21:52:23',0),(255,7,3,'','',172,172,'1970-01-01 06:00:00','2020-06-22 21:56:23',1),(256,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-22 21:56:32',0),(257,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-22 21:56:35',0),(258,7,3,'I don\'t know.','',172,172,'1970-01-01 06:00:00','2020-06-23 11:09:32',0),(259,7,2,'Do you want to continue to find out how to register to vote in Texas?','',172,172,'1970-01-01 06:00:00','2020-06-23 10:41:27',1),(260,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-23 10:41:27',1),(261,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-23 10:41:27',1),(262,7,4,'You must be a U.S. citizen to vote in the state of Texas.','',172,172,'1970-01-01 06:00:00','2020-06-23 12:09:25',0),(263,7,2,'You can check if you are registered to vote in Texas at https://teamrv-mvp.sos.texas.gov/MVP/mvp.do.\n\nDo you want to continue to find out how to register to vote in Texas?','',172,172,'1970-01-01 06:00:00','2020-06-23 20:02:00',0),(264,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-23 10:42:19',0),(265,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-23 10:42:26',0),(266,7,2,'Are you a U.S. citizen?','',172,172,'1970-01-01 06:00:00','2020-06-23 12:14:27',0),(267,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-23 10:47:35',0),(268,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-23 10:47:41',0),(269,7,2,'Are you a Texas resident?','',172,172,'1970-01-01 06:00:00','2020-06-23 10:59:10',1),(270,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-23 10:59:09',1),(271,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-23 10:59:09',1),(272,7,3,'I don\'t know.','',172,172,'1970-01-01 06:00:00','2020-06-23 10:59:09',1),(273,7,4,'You must be a Texas resident to vote in the state of Texas.','To register in your state of residency, visit turbovote.org for more information.',172,172,'1970-01-01 06:00:00','2020-06-23 10:59:32',1),(274,7,2,'Are you a Texas resident?','',172,172,'1970-01-01 06:00:00','2020-06-23 12:14:21',0),(275,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-23 11:04:08',0),(276,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-23 11:04:18',0),(277,7,3,'I don\'t know.','',172,172,'1970-01-01 06:00:00','2020-06-23 11:04:28',0),(278,7,1,'Group 2','Group 2 content',172,172,'1970-01-01 06:00:00','2020-06-23 11:14:05',1),(279,7,2,'Are you registered to vote at your current address?','',172,172,'1970-01-01 06:00:00','2020-06-23 11:14:36',1),(280,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-23 11:14:36',1),(281,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-23 11:14:36',1),(282,7,3,'I don\'t know.','',172,172,'1970-01-01 06:00:00','2020-06-23 11:14:36',1),(283,7,2,'Are you registered to vote at your current address?','',172,172,'1970-01-01 06:00:00','2020-06-23 16:08:07',0),(284,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-23 11:19:27',0),(285,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-23 11:19:32',0),(286,7,3,'I don\'t know.','',172,172,'1970-01-01 06:00:00','2020-06-23 11:27:27',1),(287,7,4,'You must be a Texas resident to vote in the state of Texas.','To register in your state of residency, visit turbovote.org for more information.',172,172,'1970-01-01 06:00:00','2020-06-23 11:35:07',0),(288,7,2,'A Texas resident is anyone who lives in the state of Texas. College students who are from Texas are considered Texas residents even if they attend college outside the state. \nDo you want to continue to find out how to register to vote in Texas?','',172,172,'1970-01-01 06:00:00','2020-06-23 16:17:59',0),(289,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-23 11:32:49',0),(290,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-23 11:32:53',0),(291,7,2,'Are you at least 18 years old or older?','',172,172,'1970-01-01 06:00:00','2020-06-23 12:14:09',0),(292,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-23 11:33:52',0),(293,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-23 11:33:57',0),(294,7,2,'Are you currently at least 17 years and 10 months old and will you be age 18 by the Election Day you want to vote in? To check when the next upcoming election is, visit https://www.votetexas.gov/.','',172,172,'1970-01-01 06:00:00','2020-06-23 12:14:04',0),(295,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-23 11:35:42',0),(296,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-23 11:35:46',0),(297,7,4,'Unfortunately you must be at least 17 years and 10 months old, as well as 18 years old by Election Day, to register to vote in the state of Texas.','',172,172,'1970-01-01 06:00:00','2020-06-23 11:37:16',0),(298,7,2,'Have you ever been convicted of a felony?','',172,172,'1970-01-01 06:00:00','2020-06-23 12:13:58',0),(299,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-23 11:37:53',0),(300,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-23 11:38:01',0),(301,7,2,'Have you completed your sentence, probation, and parole? In other words, â€œAre you off paper?â€','',172,172,'1970-01-01 06:00:00','2020-06-23 12:13:53',0),(302,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-23 11:38:39',0),(303,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-23 11:38:46',0),(304,7,2,'You are eligible to register to vote! \n\nHave you ever been declared by a court exercising probate jurisdiction to be either totally mentally incapacitated or partially mentally incapacitated without the right to vote?','',172,172,'1970-01-01 06:00:00','2020-06-23 12:16:05',0),(305,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-23 11:39:33',0),(306,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-23 11:39:39',0),(307,7,4,'You must not have been declared by a court exercising probate jurisdiction to be either totally mentally incapacitated or partially mentally incapacitated to vote in the state of Texas.','',172,172,'1970-01-01 06:00:00','2020-06-23 11:39:54',0),(308,7,2,'Are you a college student whose home address is in Texas?','',172,172,'1970-01-01 06:00:00','2020-06-23 12:13:34',0),(309,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-23 11:40:31',0),(310,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-23 11:40:39',0),(311,7,2,'Have you ever been declared by a court exercising probate jurisdiction to be either totally mentally incapacitated or partially mentally incapacitated without the right to vote?','',172,172,'1970-01-01 06:00:00','2020-06-23 12:13:41',0),(312,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-23 11:46:14',0),(313,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-23 11:46:20',0),(314,7,2,'Do you attend college in Texas?','',172,172,'1970-01-01 06:00:00','2020-06-23 12:13:28',0),(315,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-23 11:47:41',0),(316,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-23 11:47:47',0),(317,7,2,'You can choose to register either at your home address or at your university address. Where you choose to register will determine where you can vote and whatâ€™s on your ballot.\n\nDo you want to continue to find out how to register to vote in Texas?\n','',172,172,'1970-01-01 06:00:00','2020-06-23 12:13:22',0),(318,7,4,'You can choose to register either at your home address or at your university address. Where you choose to register will determine where you can vote and whatâ€™s on your ballot.\nDo you want to continue to find out how to register to vote in Texas?','',172,172,'1970-01-01 06:00:00','2020-06-23 11:50:15',1),(319,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-23 11:50:42',0),(320,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-23 11:50:50',0),(321,7,2,'# 11 ','',172,172,'1970-01-01 06:00:00','2020-06-23 11:51:38',1),(322,7,4,'You should be able to register to vote in Texas. Visit https://www.votetexas.gov/register-to-vote/.','Be sure to register by the deadline listed on the website, approximately 30 days before Election Day. There is no online voter registration in Texas, so print out the form this website provides and mail it to your local county Voter Registrar. You can find out the address of your local county Voter Registrar here: https://www.sos.state.tx.us/elections/voter/votregduties.shtml',172,172,'1970-01-01 06:00:00','2020-06-23 12:12:43',0),(323,7,2,'Do you want to continue to find out how to register to vote in Texas?','',172,172,'1970-01-01 06:00:00','2020-06-23 12:13:17',0),(324,7,3,'Yes','',172,172,'1970-01-01 06:00:00','2020-06-23 11:57:21',0),(325,7,3,'No','',172,172,'1970-01-01 06:00:00','2020-06-23 11:57:26',0),(326,7,4,'If you choose to register at your university address, please follow the guidelines for registration and voting found at campusvoteproject.org.','',172,172,'1970-01-01 06:00:00','2020-06-23 12:12:50',0),(327,7,4,'You must have completed your sentence, probation, and parole to be eligible to vote in the state of Texas.','',172,172,'1970-01-01 06:00:00','2020-06-23 12:12:56',0),(328,9,1,'Group 2','testing group',172,172,'1970-01-01 06:00:00','2020-06-23 14:07:19',0),(329,11,2,'Test Question','',172,172,'1970-01-01 06:00:00','2020-06-23 14:51:37',0),(330,11,3,'option 1','',172,172,'1970-01-01 06:00:00','2020-06-23 14:51:42',0),(331,11,3,'optino 2','',172,172,'1970-01-01 06:00:00','2020-06-23 14:51:59',0),(332,15,5,'Start','',172,172,'1970-01-01 06:00:00','2020-06-23 18:01:25',0),(333,15,2,'Question 1','',172,172,'1970-01-01 06:00:00','2020-06-23 18:01:31',0),(334,15,3,'Test option','',172,172,'1970-01-01 06:00:00','2020-06-23 18:01:35',0),(335,15,4,'End','test',172,172,'1970-01-01 06:00:00','2020-06-23 18:01:58',0),(336,15,1,'','',172,172,'1970-01-01 06:00:00','2020-06-23 18:02:19',1),(337,15,1,'Group','TEst',172,172,'1970-01-01 06:00:00','2020-06-23 18:04:05',1),(338,7,1,'Group','',172,172,'1970-01-01 06:00:00','2020-06-23 20:45:43',1),(339,7,1,'Group','',172,172,'1970-01-01 06:00:00','2020-06-23 20:46:55',0),(340,7,1,'Group 2','',172,172,'1970-01-01 06:00:00','2020-06-23 21:05:09',1),(341,7,1,'Group 3','',172,172,'1970-01-01 06:00:00','2020-06-23 21:05:01',1),(342,7,1,'Group 4','',172,172,'1970-01-01 06:00:00','2020-06-23 21:04:53',1),(343,16,2,'I am at least 18 years old.','',172,172,'1970-01-01 06:00:00','2020-06-24 15:59:22',0),(344,16,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-24 15:59:28',0),(345,16,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-24 15:59:33',0),(346,16,4,'Eligible','You can apply for US Citizenship if you want to.',172,172,'1970-01-01 06:00:00','2020-06-24 16:01:46',0),(347,16,4,'May Not Be Eligible','You will get rejected from US Citizenship if you apply right now.',172,172,'1970-01-01 06:00:00','2020-06-24 16:01:59',0),(348,16,5,'Start','',172,172,'1970-01-01 06:00:00','2020-06-24 16:07:21',0),(349,16,1,'Attachment A','I have been a Permanent Resident for three to five years',172,172,'1970-01-01 06:00:00','2020-06-24 16:50:48',0),(350,16,2,'I am a Permanent Resident of the United States.','',172,172,'1970-01-01 06:00:00','2020-06-24 16:47:44',0),(351,16,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-24 16:48:01',0),(352,16,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-24 16:48:10',0),(353,16,2,'I have been issued a Permanent Resident Card (formerly called Alien Registration Card).','',172,172,'1970-01-01 06:00:00','2020-06-24 16:49:16',0),(354,16,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-24 16:49:29',0),(355,16,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-24 16:49:39',0),(356,16,2,'I have been a permanent resident for','',172,172,'1970-01-01 06:00:00','2020-06-24 16:53:52',0),(357,16,3,'Less than three years','',172,172,'1970-01-01 06:00:00','2020-06-24 16:54:02',0),(358,16,3,'Three or more years','',172,172,'1970-01-01 06:00:00','2020-06-24 16:54:19',0),(359,16,3,'Five or more years','',172,172,'1970-01-01 06:00:00','2020-06-24 16:54:31',0),(360,16,2,'I am married to and living with a US Citizen.','',172,172,'1970-01-01 06:00:00','2020-06-24 16:54:48',0),(361,16,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-24 16:55:14',0),(362,16,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-24 16:55:28',0),(363,16,2,'I have been married to that US Citizen for at least the past three years.','',172,172,'1970-01-01 06:00:00','2020-06-24 16:56:32',0),(364,16,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-24 16:56:38',0),(365,16,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-24 16:57:07',0),(366,16,2,'My spouse has been a US Citizen for at least the past three years.','',172,172,'1970-01-01 06:00:00','2020-06-24 16:57:39',0),(367,16,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-24 16:57:45',0),(368,16,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-24 16:57:58',0),(369,16,2,'During the past three years, I have not been out of the country for 18 months or more.','',172,172,'1970-01-01 06:00:00','2020-06-24 16:58:42',0),(370,16,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-24 16:58:51',0),(371,16,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-24 16:59:02',0),(372,16,2,'During the last five years, I have not been out of the US for 30 months or more.','',172,172,'1970-01-01 06:00:00','2020-06-24 17:00:29',0),(373,16,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-24 17:00:36',0),(374,16,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-24 17:00:44',0),(375,16,2,'I am:','',172,172,'1970-01-01 06:00:00','2020-06-24 17:01:08',0),(376,16,3,'A person who has served on board a vessel operated by or registered in the United States','',172,172,'1970-01-01 06:00:00','2020-06-24 17:01:16',0),(377,16,3,'An employee or an individual under contract to the U.S. Government.','',172,172,'1970-01-01 06:00:00','2020-06-24 17:01:22',0),(378,16,3,'A person who performs ministerial or priestly functions for a religious denomination or an interdenominational organization with a valid presence in the United States.','',172,172,'1970-01-01 06:00:00','2020-06-24 17:01:32',0),(379,16,3,'None of the above.','',172,172,'1970-01-01 06:00:00','2020-06-24 17:01:45',0),(380,16,2,'','',172,172,'1970-01-01 06:00:00','2020-06-24 18:11:02',1),(381,17,2,'I am at least 18 years old.','',172,172,'1970-01-01 06:00:00','2020-06-26 01:12:03',0),(382,17,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-26 01:12:06',0),(383,17,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-26 01:12:17',0),(384,17,4,'Eligible','You can apply for US Citizenship if you want to.',172,172,'1970-01-01 06:00:00','2020-06-26 01:13:27',0),(385,17,4,'May Not Be Eligible','You will get rejected from US Citizenship if you apply right now.',172,172,'1970-01-01 06:00:00','2020-06-26 01:13:05',0),(386,17,1,'Att A','I have been a Permanent Resident for three to five years',172,172,'1970-01-01 06:00:00','2020-06-26 01:16:20',1),(387,17,5,'Start','',172,172,'1970-01-01 06:00:00','2020-06-26 01:15:38',0),(388,17,2,'I am a Permanent Resident of the United States.','',172,172,'1970-01-01 06:00:00','2020-06-26 01:17:20',0),(389,17,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-26 01:17:28',0),(390,17,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-26 01:17:36',0),(391,17,2,'I have been issued a Permanent Resident Card (formerly called Alien Registration Card).','',172,172,'1970-01-01 06:00:00','2020-06-26 01:18:59',0),(392,17,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-26 01:19:09',0),(393,17,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-26 01:19:23',0),(394,17,2,'I have been a permanent resident for','',172,172,'1970-01-01 06:00:00','2020-06-26 15:40:49',0),(395,17,3,'Less than three years','',172,172,'1970-01-01 06:00:00','2020-06-26 15:41:04',0),(396,17,3,'Three or more years','',172,172,'1970-01-01 06:00:00','2020-06-26 15:41:31',0),(397,17,3,'Five or more years','',172,172,'1970-01-01 06:00:00','2020-06-26 15:41:47',0),(398,17,2,'I am married to and living with a US Citizen.','',172,172,'1970-01-01 06:00:00','2020-06-26 15:43:13',0),(399,17,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-26 15:43:24',0),(400,17,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-26 15:43:34',0),(401,17,2,'I have been married to that US Citizen for at least the past three years.','',172,172,'1970-01-01 06:00:00','2020-06-26 15:44:42',0),(402,17,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-26 15:44:52',0),(403,17,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-26 15:45:03',0),(404,17,2,'My spouse has been a US Citizen for at least the past three years.','',172,172,'1970-01-01 06:00:00','2020-06-26 15:45:22',0),(405,17,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-26 15:45:28',0),(406,17,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-26 15:45:38',0),(407,17,2,'During the past three years, I have not been out of the country for 18 months or more.','',172,172,'1970-01-01 06:00:00','2020-06-26 15:47:34',0),(408,17,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-26 15:47:40',0),(409,17,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-26 15:47:51',0),(410,17,2,'During the last five years, I have not been out of the US for 30 months or more.','',172,172,'1970-01-01 06:00:00','2020-06-26 15:49:03',0),(411,17,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-26 15:49:10',0),(412,17,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-26 15:49:26',0),(413,17,2,'I am:','',172,172,'1970-01-01 06:00:00','2020-06-26 15:50:32',0),(414,17,3,'A person who has served on board a vessel operated by or registered in the United States','',172,172,'1970-01-01 06:00:00','2020-06-26 15:50:42',0),(415,17,3,'An employee or an individual under contract to the U.S. Government.','',172,172,'1970-01-01 06:00:00','2020-06-26 15:51:04',0),(416,17,3,'A person who performs ministerial or priestly functions for a religious denomination or an interdenominational organization with a valid presence in the United States.','',172,172,'1970-01-01 06:00:00','2020-06-26 15:51:27',0),(417,17,3,'None of the above.','',172,172,'1970-01-01 06:00:00','2020-06-26 15:51:43',0),(418,17,2,'During the last three to five years, I have not taken a trip out of the United States that lasted one year or more.','',172,172,'1970-01-01 06:00:00','2020-06-26 15:52:55',0),(419,17,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-26 15:53:00',0),(420,17,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-26 15:53:12',0),(421,17,2,'Since becoming a Permanent Resident, I have not taken a trip out of the United States that lasted for one year or more without an approved \"Application to Preserve Residence for Naturalization Purposes\" (Form N-470).','',172,172,'1970-01-01 06:00:00','2020-06-26 15:56:46',0),(422,17,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-26 15:56:50',0),(423,17,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-26 15:57:04',0),(424,17,2,'I have resided in the district or state in which I am applying for citizenship for the last three months.','',172,172,'1970-01-01 06:00:00','2020-06-26 15:57:56',0),(425,17,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-26 15:58:05',0),(426,17,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-26 15:58:18',0),(427,17,2,'I can read, write and speak basic English.','',172,172,'1970-01-01 06:00:00','2020-06-26 16:00:00',0),(428,17,2,'I am over 50 years old and have lived in the United States for at least 20 years since I became a Permanent Resident.','',172,172,'1970-01-01 06:00:00','2020-06-26 16:00:43',0),(429,17,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-26 16:00:07',0),(430,17,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-26 16:00:22',0),(431,17,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-26 16:00:50',0),(432,17,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-26 16:00:57',0),(433,17,2,'I am over 55 years old and have lived in the United States for at least 15 years since I became a Permanent Resident.','',172,172,'1970-01-01 06:00:00','2020-06-26 16:02:07',0),(434,17,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-26 16:02:13',0),(435,17,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-26 16:02:21',0),(436,17,2,'I have a disability that prevents me from fulfilling this requirement and will be filing a \"Medical Certification for Disability Exceptions\" (Form N-648) completed and signed by a doctor with my application.','',172,172,'1970-01-01 06:00:00','2020-06-26 16:02:36',0),(437,17,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-26 16:02:42',0),(438,17,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-26 16:02:52',0),(439,17,2,'I know the fundamentals of U.S. history and the form and principles of the U.S. government.','',172,172,'1970-01-01 06:00:00','2020-06-26 16:03:14',0),(440,17,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-26 16:04:28',0),(441,17,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-26 16:04:38',0),(442,17,2,'I have a disability that prevents me from fulfilling the civics requirement, and I will be filing \"Medical Certification for Disability Exceptions\" (Form N-648) completed and signed by a doctor with my application.','',172,172,'1970-01-01 06:00:00','2020-06-26 16:05:00',0),(443,17,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-26 16:05:08',0),(444,17,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-26 16:05:19',0),(445,17,2,'I am a person of good moral character.','',172,172,'1970-01-01 06:00:00','2020-06-26 16:05:33',0),(446,17,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-26 16:05:39',0),(447,17,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-26 16:05:48',0),(448,17,2,'I am female.','',172,172,'1970-01-01 06:00:00','2020-06-26 16:06:04',0),(449,17,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-26 16:06:13',0),(450,17,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-26 16:06:25',0),(451,17,2,'I am a male registered with the Selective Service.','',172,172,'1970-01-01 06:00:00','2020-06-26 16:06:48',0),(452,17,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-26 16:06:56',0),(453,17,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-26 16:07:06',0),(454,17,2,'I am a male who did not enter the United States under any status until after my 26th birthday.','',172,172,'1970-01-01 06:00:00','2020-06-26 16:07:44',0),(455,17,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-26 16:07:52',0),(456,17,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-26 16:08:04',0),(457,17,2,'I am a male who was in the United States between the ages of 18 and 26 but who did not register with the Selective Service, and I will send a \"Status Information Letter\" from the Selective Service explaining why I did not register with my application.','',172,172,'1970-01-01 06:00:00','2020-06-26 16:08:25',0),(458,17,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-26 16:08:33',0),(459,17,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-26 16:08:45',0),(460,17,2,'I have never deserted from the U.S. Armed Forces.','',172,172,'1970-01-01 06:00:00','2020-06-26 16:09:01',0),(461,17,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-26 16:09:09',0),(462,17,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-26 16:09:21',0),(463,17,2,'I have never received an exemption or discharge from the U.S. Armed Forces on the grounds that I am an alien.','',172,172,'1970-01-01 06:00:00','2020-06-26 16:09:41',0),(464,17,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-26 16:09:50',0),(465,17,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-26 16:10:02',0),(466,17,2,'I am willing to perform either military or civilian service for the United States if required by law. (NOTE: If your religious teachings OR beliefs prohibit you from performing military service, you must be willing to perform non-military service.)','',172,172,'1970-01-01 06:00:00','2020-06-26 16:10:19',0),(467,17,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-26 16:10:30',0),(468,17,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-26 16:10:43',0),(469,17,2,'I will support the Constitution of the United States.','',172,172,'1970-01-01 06:00:00','2020-06-26 16:11:00',0),(470,17,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-26 16:11:11',0),(471,17,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-26 16:11:27',0),(472,17,2,'I understand and am willing to take an oath of allegiance to the United States.','',172,172,'1970-01-01 06:00:00','2020-06-26 16:12:20',0),(473,17,3,'False','',172,172,'1970-01-01 06:00:00','2020-06-26 16:12:34',0),(474,17,3,'True','',172,172,'1970-01-01 06:00:00','2020-06-26 16:12:52',0);
/*!40000 ALTER TABLE `treeElement` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`cmetree`@`%`*/ /*!50003 TRIGGER treeElementInsertTrigger
BEFORE INSERT ON `wp_cmetree`.`treeElement`
FOR EACH ROW
BEGIN
IF NEW.elCreatedAt = '1970-01-01 %' THEN
SET NEW.elCreatedAt = NOW();
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `treeElementContainer`
--

DROP TABLE IF EXISTS `treeElementContainer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `treeElementContainer` (
  `elContainerID` int(11) NOT NULL AUTO_INCREMENT,
  `elID` int(11) DEFAULT NULL,
  `elIDChild` int(11) DEFAULT NULL,
  PRIMARY KEY (`elContainerID`),
  KEY `elIDIDx` (`elID`),
  KEY `elIDIDx1` (`elIDChild`),
  CONSTRAINT `containerElID` FOREIGN KEY (`elID`) REFERENCES `treeElement` (`elID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `containerElIDChild` FOREIGN KEY (`elIDChild`) REFERENCES `treeElement` (`elID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=348 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `treeElementContainer`
--

LOCK TABLES `treeElementContainer` WRITE;
/*!40000 ALTER TABLE `treeElementContainer` DISABLE KEYS */;
INSERT INTO `treeElementContainer` VALUES (2,2,3),(3,2,4),(4,8,9),(5,8,10),(6,11,12),(7,11,13),(8,14,15),(9,14,16),(10,14,17),(11,1,18),(12,18,19),(13,18,20),(14,1,21),(15,21,22),(16,21,23),(17,1,26),(18,26,27),(19,26,28),(20,29,30),(21,29,31),(22,1,33),(23,33,34),(24,33,35),(25,5,37),(26,6,38),(28,40,41),(30,40,42),(31,43,44),(32,43,45),(33,46,47),(34,46,48),(35,52,53),(36,52,54),(37,49,50),(38,49,51),(39,61,73),(40,61,74),(41,61,75),(42,61,76),(43,62,77),(44,62,78),(45,63,79),(46,63,80),(47,64,81),(48,64,82),(49,65,83),(50,65,84),(51,66,85),(52,66,86),(53,52,87),(54,67,92),(55,67,93),(56,88,94),(57,88,95),(58,89,96),(59,89,97),(60,90,98),(61,90,99),(62,91,100),(63,91,101),(64,68,102),(65,68,103),(66,69,104),(67,69,105),(68,70,106),(69,70,107),(70,71,108),(71,71,109),(72,72,110),(73,72,111),(74,112,61),(75,113,62),(76,114,63),(77,114,64),(78,114,65),(79,115,66),(81,120,122),(82,126,127),(83,126,129),(84,128,130),(85,132,133),(86,132,134),(87,131,132),(88,128,135),(89,140,141),(90,2,143),(91,140,144),(92,140,145),(93,149,150),(94,148,151),(95,148,152),(96,149,153),(97,155,156),(98,155,157),(99,155,158),(100,159,160),(101,159,161),(102,162,163),(103,162,164),(104,166,167),(105,166,168),(106,169,170),(107,169,171),(108,173,174),(109,173,175),(110,176,177),(111,176,178),(112,179,180),(113,179,181),(114,182,183),(115,182,184),(116,187,188),(117,187,189),(122,192,193),(123,192,194),(124,196,197),(125,196,198),(126,196,199),(127,200,201),(128,204,196),(130,204,200),(131,200,205),(132,206,207),(133,206,208),(134,206,209),(135,210,211),(136,210,212),(138,218,219),(139,218,220),(140,216,210),(142,222,223),(143,222,224),(144,222,225),(145,228,229),(146,228,230),(147,228,231),(149,236,237),(150,236,238),(151,236,239),(153,243,244),(154,243,245),(155,243,246),(156,249,243),(157,251,252),(158,251,253),(159,235,255),(160,235,256),(161,235,257),(162,235,258),(164,259,260),(165,259,261),(167,263,264),(168,263,265),(170,266,267),(171,266,268),(173,269,270),(174,269,271),(175,269,272),(178,274,275),(179,274,276),(180,274,277),(188,279,280),(189,279,281),(190,279,282),(215,283,284),(216,283,285),(217,283,286),(218,288,289),(219,288,290),(220,291,292),(221,291,293),(222,294,295),(223,294,296),(224,298,299),(225,298,300),(226,301,302),(227,301,303),(228,304,305),(229,304,306),(230,308,309),(231,308,310),(232,311,312),(233,311,313),(234,314,315),(235,314,316),(236,317,319),(237,317,320),(238,323,324),(239,323,325),(241,329,330),(242,329,331),(243,242,329),(245,328,218),(246,333,334),(251,339,283),(252,339,266),(253,339,274),(254,339,288),(262,343,344),(263,343,345),(264,349,343),(265,350,351),(266,350,352),(267,353,354),(268,353,355),(269,356,357),(270,356,358),(271,356,359),(272,360,361),(273,360,362),(274,363,364),(275,363,365),(276,366,367),(277,366,368),(278,369,370),(279,369,371),(280,372,373),(281,372,374),(282,375,376),(283,375,377),(284,375,378),(285,375,379),(286,381,382),(287,381,383),(289,388,389),(290,388,390),(291,391,392),(292,391,393),(293,394,395),(294,394,396),(295,394,397),(296,398,399),(297,398,400),(298,401,402),(299,401,403),(300,404,405),(301,404,406),(302,407,408),(303,407,409),(304,410,411),(305,410,412),(306,413,414),(307,413,415),(308,413,416),(309,413,417),(310,418,419),(311,418,420),(312,421,422),(313,421,423),(314,424,425),(315,424,426),(316,427,429),(317,427,430),(318,428,431),(319,428,432),(320,433,434),(321,433,435),(322,436,437),(323,436,438),(324,439,440),(325,439,441),(326,442,443),(327,442,444),(328,445,446),(329,445,447),(330,448,449),(331,448,450),(332,451,452),(333,451,453),(334,454,455),(335,454,456),(336,457,458),(337,457,459),(338,460,461),(339,460,462),(340,463,464),(341,463,465),(342,466,467),(343,466,468),(344,469,470),(345,469,471),(346,472,473),(347,472,474);
/*!40000 ALTER TABLE `treeElementContainer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `treeElementDestination`
--

DROP TABLE IF EXISTS `treeElementDestination`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `treeElementDestination` (
  `elDestinationID` int(11) NOT NULL AUTO_INCREMENT,
  `elID` int(11) DEFAULT NULL,
  `elIDDestination` int(11) DEFAULT NULL,
  PRIMARY KEY (`elDestinationID`),
  KEY `elIDIDx` (`elID`),
  KEY `elIDIDx1` (`elIDDestination`),
  CONSTRAINT `destinationElID` FOREIGN KEY (`elID`) REFERENCES `treeElement` (`elID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `destinationElIDDestination` FOREIGN KEY (`elIDDestination`) REFERENCES `treeElement` (`elID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=264 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `treeElementDestination`
--

LOCK TABLES `treeElementDestination` WRITE;
/*!40000 ALTER TABLE `treeElementDestination` DISABLE KEYS */;
INSERT INTO `treeElementDestination` VALUES (1,3,8),(2,4,6),(3,7,2),(4,10,6),(5,9,11),(6,13,6),(7,12,14),(8,15,6),(9,16,18),(10,17,29),(11,20,6),(12,19,21),(13,23,6),(14,22,33),(15,28,6),(16,27,29),(17,31,61),(18,30,40),(19,35,6),(20,34,26),(21,36,2),(22,37,1),(23,38,1),(24,42,62),(25,41,43),(26,45,6),(27,44,46),(28,48,63),(29,47,49),(30,51,66),(32,54,6),(33,50,52),(34,73,40),(35,74,40),(36,75,40),(37,76,6),(38,77,6),(39,78,43),(40,79,64),(41,80,49),(42,81,65),(43,82,49),(44,83,6),(45,84,49),(46,85,6),(47,86,52),(48,87,67),(49,92,88),(50,93,68),(51,94,89),(52,95,68),(53,96,90),(54,97,68),(55,98,6),(56,99,68),(57,100,6),(58,101,68),(59,102,6),(60,103,69),(61,104,6),(62,105,70),(63,106,6),(64,107,71),(65,108,6),(66,109,72),(67,110,6),(68,111,5),(70,127,128),(71,129,124),(72,130,124),(73,125,126),(74,133,124),(75,135,132),(76,142,140),(77,141,146),(78,145,149),(79,144,192),(80,150,140),(81,153,146),(82,152,154),(83,164,165),(84,184,146),(85,151,155),(86,156,159),(87,157,186),(88,188,159),(89,189,146),(90,160,166),(91,161,162),(92,163,166),(93,167,169),(94,168,173),(95,170,173),(96,171,172),(97,174,172),(98,175,176),(99,177,179),(100,178,185),(101,183,185),(102,158,187),(103,193,185),(104,194,154),(105,195,196),(106,201,196),(107,198,203),(108,199,200),(109,197,202),(110,205,202),(111,207,210),(112,208,213),(113,212,218),(114,211,214),(115,209,210),(116,217,206),(117,220,213),(118,219,214),(119,229,233),(120,230,233),(121,231,233),(122,227,235),(123,241,236),(124,237,240),(125,238,240),(126,239,240),(127,244,247),(128,245,247),(129,246,247),(130,248,243),(131,253,254),(132,252,254),(133,250,251),(134,256,233),(135,257,266),(136,258,263),(137,260,235),(138,261,262),(139,265,233),(140,264,283),(141,267,274),(142,268,262),(143,270,262),(144,271,262),(145,272,262),(146,275,291),(147,276,287),(148,277,288),(149,284,233),(150,285,266),(151,286,262),(152,290,233),(153,292,298),(154,293,294),(155,289,291),(156,295,298),(157,296,297),(158,299,301),(159,300,311),(160,305,307),(161,306,308),(162,309,314),(163,310,322),(164,302,304),(165,303,327),(166,312,307),(167,315,317),(168,316,233),(169,313,308),(170,320,233),(171,319,322),(172,324,322),(173,325,326),(174,330,236),(175,331,240),(176,334,335),(177,332,333),(178,344,347),(179,345,346),(180,348,343),(181,351,347),(182,352,353),(183,354,347),(184,355,346),(185,357,347),(186,358,360),(187,359,346),(188,361,347),(189,362,363),(190,364,347),(191,365,366),(192,367,347),(193,368,369),(194,370,347),(195,371,346),(196,376,346),(197,377,346),(198,378,346),(199,379,347),(200,373,375),(201,374,346),(202,382,384),(203,383,388),(204,387,381),(205,390,391),(206,389,385),(207,392,385),(208,393,394),(209,395,385),(210,396,398),(211,397,410),(212,399,385),(213,400,401),(214,402,385),(215,403,404),(216,405,385),(217,406,407),(218,408,385),(219,409,410),(220,411,413),(221,412,418),(222,414,418),(223,415,418),(224,416,418),(225,417,385),(226,419,421),(227,420,424),(228,422,385),(229,423,424),(230,425,385),(231,426,427),(232,429,428),(233,430,439),(234,431,433),(235,432,439),(236,434,442),(237,435,439),(238,437,385),(239,438,439),(240,440,442),(241,441,445),(242,443,385),(243,444,445),(244,446,385),(245,447,448),(246,449,451),(247,450,460),(248,452,454),(249,453,460),(250,455,457),(251,456,460),(252,458,385),(253,459,460),(254,461,385),(255,462,463),(256,464,385),(257,465,466),(258,467,385),(259,468,469),(260,470,385),(261,471,472),(262,473,385),(263,474,384);
/*!40000 ALTER TABLE `treeElementDestination` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `treeElementOrder`
--

DROP TABLE IF EXISTS `treeElementOrder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `treeElementOrder` (
  `elOrderID` int(11) NOT NULL AUTO_INCREMENT,
  `elID` int(11) DEFAULT NULL,
  `elOrder` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`elOrderID`),
  KEY `elIDIDx` (`elID`),
  CONSTRAINT `orderElID` FOREIGN KEY (`elID`) REFERENCES `treeElement` (`elID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=413 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `treeElementOrder`
--

LOCK TABLES `treeElementOrder` WRITE;
/*!40000 ALTER TABLE `treeElementOrder` DISABLE KEYS */;
INSERT INTO `treeElementOrder` VALUES (1,3,1),(2,4,0),(3,7,0),(4,1,0),(5,2,0),(6,8,1),(7,9,1),(8,10,0),(9,11,2),(10,12,1),(11,13,0),(12,14,3),(13,15,0),(14,16,1),(15,17,2),(16,18,4),(17,19,1),(18,20,0),(19,21,5),(20,22,1),(21,23,0),(22,26,7),(23,27,1),(24,28,0),(25,29,8),(26,30,1),(27,31,0),(28,33,6),(29,34,1),(30,35,0),(31,38,0),(32,37,0),(33,40,10),(34,41,1),(35,42,0),(36,43,12),(37,44,1),(38,45,0),(39,46,13),(40,47,1),(41,48,0),(42,49,17),(43,50,1),(44,51,0),(45,52,19),(46,53,1),(47,54,0),(48,61,9),(49,62,11),(50,63,14),(51,64,15),(52,65,16),(53,66,18),(54,67,20),(55,68,24),(56,69,25),(57,70,26),(58,71,27),(59,72,28),(60,73,0),(61,74,1),(62,75,2),(63,76,3),(64,77,0),(65,78,1),(66,79,0),(67,80,1),(68,81,0),(69,82,1),(70,83,0),(71,84,1),(72,85,0),(73,86,1),(74,87,2),(75,88,21),(76,89,22),(77,90,23),(78,91,24),(79,92,0),(80,93,1),(81,94,0),(82,95,1),(83,96,0),(84,97,1),(85,98,0),(86,99,1),(87,100,0),(88,101,0),(89,102,0),(90,103,1),(91,104,0),(92,105,1),(93,106,0),(94,107,1),(95,108,0),(96,109,1),(97,110,0),(98,111,1),(99,112,1),(100,113,2),(101,114,3),(102,115,4),(104,120,0),(105,121,0),(106,122,0),(107,126,0),(108,127,0),(109,128,1),(110,129,1),(111,130,0),(112,131,0),(113,132,2),(114,133,0),(115,134,1),(116,135,1),(117,137,0),(118,139,0),(119,140,0),(120,141,0),(121,143,2),(122,144,0),(123,145,0),(124,148,2),(125,149,0),(126,150,0),(127,151,0),(128,152,0),(129,153,0),(130,155,3),(131,156,0),(132,157,0),(133,158,0),(134,159,5),(135,160,0),(136,161,0),(137,162,6),(138,163,0),(139,164,0),(140,166,7),(141,167,0),(142,168,0),(143,169,8),(144,170,0),(145,171,0),(146,173,9),(147,174,0),(148,175,0),(149,176,10),(150,177,0),(151,178,0),(152,179,11),(153,180,0),(154,181,0),(155,182,12),(156,183,0),(157,184,0),(158,187,4),(159,188,0),(160,189,0),(161,190,0),(162,191,1),(163,192,0),(164,193,0),(165,194,0),(166,196,0),(167,197,0),(168,198,1),(169,199,2),(170,200,1),(171,201,0),(172,204,0),(173,205,1),(174,206,0),(175,207,0),(176,208,1),(177,209,2),(178,210,1),(179,211,0),(180,212,1),(181,216,0),(182,218,2),(183,219,0),(184,220,1),(185,222,0),(186,223,0),(187,224,1),(188,225,2),(189,226,0),(190,228,0),(191,229,0),(192,230,0),(193,231,0),(194,232,1),(195,234,0),(196,235,0),(197,236,0),(198,237,0),(199,238,1),(200,239,2),(201,242,0),(202,243,0),(203,244,0),(204,245,1),(205,246,2),(206,249,0),(207,251,0),(208,252,0),(209,253,1),(210,255,0),(211,256,0),(212,257,1),(213,258,2),(214,259,1),(215,260,0),(216,261,0),(217,263,1),(218,264,0),(219,265,1),(220,266,3),(221,267,0),(222,268,1),(223,269,3),(224,270,0),(225,271,0),(226,272,0),(227,274,4),(228,275,0),(229,276,1),(230,277,2),(231,278,1),(232,279,4),(233,280,0),(234,281,0),(235,282,0),(236,283,2),(237,284,0),(238,285,1),(239,286,2),(240,288,5),(241,289,0),(242,290,1),(243,291,6),(244,292,0),(245,293,1),(246,294,7),(247,295,0),(248,296,1),(249,298,8),(250,299,0),(251,300,1),(252,301,9),(253,302,0),(254,303,1),(255,304,10),(256,305,0),(257,306,1),(258,308,12),(259,309,0),(260,310,1),(261,311,11),(262,312,0),(263,313,1),(264,314,13),(265,315,0),(266,316,1),(267,317,14),(268,319,0),(269,320,1),(270,321,15),(271,323,15),(272,324,0),(273,325,1),(274,328,1),(275,329,1),(276,330,0),(277,331,1),(278,333,0),(279,334,0),(280,336,0),(281,337,0),(282,338,0),(283,339,0),(284,340,1),(285,341,2),(286,342,3),(287,343,0),(288,344,0),(289,345,1),(290,349,0),(291,350,1),(292,351,0),(293,352,1),(294,353,2),(295,354,0),(296,355,1),(297,356,3),(298,357,0),(299,358,1),(300,359,2),(301,360,4),(302,361,0),(303,362,1),(304,363,5),(305,364,0),(306,365,1),(307,366,6),(308,367,0),(309,368,1),(310,369,7),(311,370,0),(312,371,1),(313,372,8),(314,373,0),(315,374,1),(316,375,9),(317,376,0),(318,377,1),(319,378,2),(320,379,3),(321,380,10),(322,381,0),(323,382,0),(324,383,1),(325,386,0),(326,388,1),(327,389,0),(328,390,1),(329,391,2),(330,392,0),(331,393,1),(332,394,3),(333,395,0),(334,396,1),(335,397,2),(336,398,4),(337,399,0),(338,400,1),(339,401,5),(340,402,0),(341,403,1),(342,404,6),(343,405,0),(344,406,1),(345,407,7),(346,408,0),(347,409,1),(348,410,8),(349,411,0),(350,412,1),(351,413,9),(352,414,0),(353,415,1),(354,416,2),(355,417,3),(356,418,10),(357,419,0),(358,420,1),(359,421,11),(360,422,0),(361,423,1),(362,424,12),(363,425,0),(364,426,1),(365,427,13),(366,428,14),(367,429,0),(368,430,1),(369,431,0),(370,432,1),(371,433,15),(372,434,0),(373,435,1),(374,436,16),(375,437,0),(376,438,1),(377,439,17),(378,440,0),(379,441,1),(380,442,18),(381,443,0),(382,444,1),(383,445,19),(384,446,0),(385,447,1),(386,448,20),(387,449,0),(388,450,1),(389,451,21),(390,452,0),(391,453,1),(392,454,22),(393,455,0),(394,456,1),(395,457,23),(396,458,0),(397,459,1),(398,460,24),(399,461,0),(400,462,1),(401,463,25),(402,464,0),(403,465,1),(404,466,26),(405,467,0),(406,468,1),(407,469,27),(408,470,0),(409,471,1),(410,472,28),(411,473,0),(412,474,1);
/*!40000 ALTER TABLE `treeElementOrder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `treeElementType`
--

DROP TABLE IF EXISTS `treeElementType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `treeElementType` (
  `elTypeID` int(11) NOT NULL AUTO_INCREMENT,
  `elType` varchar(45) NOT NULL DEFAULT '',
  PRIMARY KEY (`elTypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `treeElementType`
--

LOCK TABLES `treeElementType` WRITE;
/*!40000 ALTER TABLE `treeElementType` DISABLE KEYS */;
INSERT INTO `treeElementType` VALUES (1,'group'),(2,'question'),(3,'option'),(4,'end'),(5,'start');
/*!40000 ALTER TABLE `treeElementType` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `treeEmbed`
--

DROP TABLE IF EXISTS `treeEmbed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `treeEmbed` (
  `embedID` int(11) NOT NULL AUTO_INCREMENT,
  `siteID` int(11) DEFAULT NULL,
  `treeID` int(11) DEFAULT NULL,
  `embedPath` varchar(255) NOT NULL DEFAULT '',
  `embedCreatedAt` timestamp NOT NULL DEFAULT '1970-01-01 06:00:00',
  `embedUpdatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `embedIsIframe` tinyint(1) DEFAULT '0',
  `embedIsDev` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`embedID`),
  UNIQUE KEY `treeEmbedUnique` (`siteID`,`treeID`,`embedPath`),
  KEY `embedTreeID` (`treeID`),
  CONSTRAINT `embedSiteID` FOREIGN KEY (`siteID`) REFERENCES `treeSite` (`siteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `embedTreeID` FOREIGN KEY (`treeID`) REFERENCES `tree` (`treeID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `treeEmbed`
--

LOCK TABLES `treeEmbed` WRITE;
/*!40000 ALTER TABLE `treeEmbed` DISABLE KEYS */;
INSERT INTO `treeEmbed` VALUES (1,1,1,'/preview/tree/1','1970-01-01 06:00:00','2018-06-15 19:32:20',0,0),(2,1,1,'/preview/tree/citizen','1970-01-01 06:00:00','2018-06-15 19:35:20',0,0),(3,2,1,'/decision-tree/','1970-01-01 06:00:00','2018-09-20 22:29:06',0,0),(4,3,1,'/decision-tree/','1970-01-01 06:00:00','2018-10-09 20:45:18',0,0),(5,4,1,'/decision-tree/','1970-01-01 06:00:00','2018-11-30 18:17:36',0,0),(6,4,1,'/decision-tree','1970-01-01 06:00:00','2019-04-08 19:11:12',0,0),(7,5,1,'/preview/tree/1','1970-01-01 06:00:00','2019-08-14 14:19:20',0,0),(8,5,1,'/preview/tree/citizen','1970-01-01 06:00:00','2019-08-14 14:19:24',0,0),(9,1,1,'//preview/tree/citizen','1970-01-01 06:00:00','2019-09-23 18:59:14',0,0),(10,1,1,'/api/v1/trees/citizen/iframe','1970-01-01 06:00:00','2019-10-08 13:18:50',0,0),(11,1,6,'/preview/tree/6','1970-01-01 06:00:00','2020-06-19 20:07:48',0,0),(12,1,9,'/preview/tree/test-two','1970-01-01 06:00:00','2020-06-22 21:19:35',0,0),(13,1,7,'/preview/tree/how-to-register-to-vote-in-texas','1970-01-01 06:00:00','2020-06-22 21:40:09',0,0),(14,1,7,'/api/v1/trees/how-to-register-to-vote-in-texas/iframe','1970-01-01 06:00:00','2020-06-22 21:41:28',0,0),(15,1,11,'/preview/tree/test-four','1970-01-01 06:00:00','2020-06-22 21:45:09',0,0),(16,1,11,'/api/v1/trees/test-four/iframe','1970-01-01 06:00:00','2020-06-22 21:45:25',0,0),(17,1,12,'/preview/tree/test-five','1970-01-01 06:00:00','2020-06-22 21:48:48',0,0),(18,1,12,'/api/v1/trees/test-five/iframe','1970-01-01 06:00:00','2020-06-22 21:49:22',0,0),(19,1,13,'/preview/tree/test-six','1970-01-01 06:00:00','2020-06-22 21:52:52',0,0),(20,1,13,'/api/v1/trees/test-six/iframe','1970-01-01 06:00:00','2020-06-22 21:53:19',0,0),(21,1,9,'/api/v1/trees/test-two/iframe','1970-01-01 06:00:00','2020-06-23 14:02:46',0,0),(22,1,1,'/api/v1/trees/test-two/iframe','1970-01-01 06:00:00','2020-06-23 14:45:12',0,0),(23,1,7,'/api/v1/trees/test-two/iframe','1970-01-01 06:00:00','2020-06-23 17:28:45',0,0),(24,1,15,'/preview/tree/vote','1970-01-01 06:00:00','2020-06-23 18:02:37',0,0),(25,1,16,'/preview/tree/citizen2','1970-01-01 06:00:00','2020-06-24 16:03:30',0,0),(26,1,16,'/api/v1/trees/citizen2/iframe','1970-01-01 06:00:00','2020-06-24 16:05:20',0,0),(27,1,17,'/api/v1/trees/citizen3/iframe','1970-01-01 06:00:00','2020-06-26 01:13:50',0,0),(28,1,17,'/preview/tree/citizen3','1970-01-01 06:00:00','2020-06-26 16:24:02',0,0);
/*!40000 ALTER TABLE `treeEmbed` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`cmetree`@`%`*/ /*!50003 TRIGGER treeEmbedTrigger
BEFORE INSERT ON `wp_cmetree`.`treeEmbed`
FOR EACH ROW
BEGIN
IF NEW.embedCreatedAt = '1970-01-01 %' THEN
SET NEW.embedCreatedAt = NOW();
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary table structure for view `treeEnd`
--

DROP TABLE IF EXISTS `treeEnd`;
/*!50001 DROP VIEW IF EXISTS `treeEnd`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeEnd` AS SELECT 
 1 AS `endID`,
 1 AS `treeID`,
 1 AS `title`,
 1 AS `content`,
 1 AS `deleted`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `treeGroup`
--

DROP TABLE IF EXISTS `treeGroup`;
/*!50001 DROP VIEW IF EXISTS `treeGroup`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeGroup` AS SELECT 
 1 AS `groupID`,
 1 AS `treeID`,
 1 AS `title`,
 1 AS `content`,
 1 AS `order`,
 1 AS `deleted`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `treeInteraction`
--

DROP TABLE IF EXISTS `treeInteraction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `treeInteraction` (
  `interactionID` int(11) NOT NULL AUTO_INCREMENT,
  `userID` varchar(45) DEFAULT NULL,
  `embedID` int(11) DEFAULT NULL,
  `treeID` int(11) DEFAULT NULL,
  `interactionTypeID` int(11) DEFAULT NULL,
  `stateTypeID` int(11) DEFAULT NULL,
  `interactionCreatedAt` timestamp NOT NULL DEFAULT '1970-01-01 06:00:00',
  `interactionUpdatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`interactionID`),
  KEY `interactionTypeIDIDx` (`interactionTypeID`),
  KEY `treeIDIDx` (`treeID`),
  KEY `interactionStateTypeID` (`stateTypeID`),
  KEY `interactionEmbedID` (`embedID`),
  CONSTRAINT `interactionElTypeID` FOREIGN KEY (`interactionTypeID`) REFERENCES `treeInteractionType` (`interactionTypeID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `interactionEmbedID` FOREIGN KEY (`embedID`) REFERENCES `treeEmbed` (`embedID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `interactionStateTypeID` FOREIGN KEY (`stateTypeID`) REFERENCES `treeStateType` (`stateTypeID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `interactionTreeID` FOREIGN KEY (`treeID`) REFERENCES `tree` (`treeID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2104 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `treeInteraction`
--

LOCK TABLES `treeInteraction` WRITE;
/*!40000 ALTER TABLE `treeInteraction` DISABLE KEYS */;
INSERT INTO `treeInteraction` VALUES (1,'8194c0140b86b97e72a3e1c520537f35',1,1,2,2,'1970-01-01 06:00:00','2018-06-15 19:32:20'),(2,'8194c0140b86b97e72a3e1c520537f35',1,1,5,2,'1970-01-01 06:00:00','2018-06-15 19:34:34'),(3,'8194c0140b86b97e72a3e1c520537f35',1,1,5,3,'1970-01-01 06:00:00','2018-06-15 19:34:35'),(4,'8194c0140b86b97e72a3e1c520537f35',2,1,2,3,'1970-01-01 06:00:00','2018-06-15 19:35:20'),(5,'8194c0140b86b97e72a3e1c520537f35',2,1,2,3,'1970-01-01 06:00:00','2018-06-15 19:36:35'),(6,'8194c0140b86b97e72a3e1c520537f35',2,1,4,4,'1970-01-01 06:00:00','2018-06-15 19:36:39'),(7,'8194c0140b86b97e72a3e1c520537f35',2,1,2,4,'1970-01-01 06:00:00','2018-06-15 19:47:56'),(8,'8194c0140b86b97e72a3e1c520537f35',2,1,2,4,'1970-01-01 06:00:00','2018-06-15 19:48:09'),(9,'a2d592c1b710a2d47ab5977aad16ed57',2,1,2,4,'1970-01-01 06:00:00','2018-06-15 19:57:01'),(10,'63e67fe63d88f7b6602b63bbc8ae15ea',2,1,1,1,'1970-01-01 06:00:00','2018-06-15 21:10:34'),(11,'3939b2dfc13b4b26ac21060e15b07c6b',2,1,1,1,'1970-01-01 06:00:00','2018-06-18 19:07:52'),(12,'3939b2dfc13b4b26ac21060e15b07c6b',2,1,3,2,'1970-01-01 06:00:00','2018-06-18 19:07:59'),(13,'b3995ad891d93c709dfc356d0fb13188',2,1,1,1,'1970-01-01 06:00:00','2018-06-20 19:06:41'),(14,'b3995ad891d93c709dfc356d0fb13188',2,1,3,2,'1970-01-01 06:00:00','2018-06-20 19:06:42'),(15,'b3995ad891d93c709dfc356d0fb13188',2,1,5,2,'1970-01-01 06:00:00','2018-06-20 19:06:45'),(16,'b3995ad891d93c709dfc356d0fb13188',2,1,5,2,'1970-01-01 06:00:00','2018-06-20 19:06:48'),(17,'b3995ad891d93c709dfc356d0fb13188',2,1,5,2,'1970-01-01 06:00:00','2018-06-20 19:06:49'),(18,'b3995ad891d93c709dfc356d0fb13188',2,1,5,2,'1970-01-01 06:00:00','2018-06-20 19:06:51'),(19,'b3995ad891d93c709dfc356d0fb13188',2,1,5,2,'1970-01-01 06:00:00','2018-06-20 19:06:52'),(20,'b3995ad891d93c709dfc356d0fb13188',2,1,5,2,'1970-01-01 06:00:00','2018-06-20 19:06:53'),(21,'b3995ad891d93c709dfc356d0fb13188',2,1,5,2,'1970-01-01 06:00:00','2018-06-20 19:06:54'),(22,'b3995ad891d93c709dfc356d0fb13188',2,1,5,2,'1970-01-01 06:00:00','2018-06-20 19:06:55'),(23,'b3995ad891d93c709dfc356d0fb13188',2,1,5,2,'1970-01-01 06:00:00','2018-06-20 19:06:56'),(24,'b3995ad891d93c709dfc356d0fb13188',2,1,5,2,'1970-01-01 06:00:00','2018-06-20 19:06:57'),(25,'b3995ad891d93c709dfc356d0fb13188',2,1,5,3,'1970-01-01 06:00:00','2018-06-20 19:06:58'),(26,'b3995ad891d93c709dfc356d0fb13188',2,1,2,3,'1970-01-01 06:00:00','2018-06-21 21:02:09'),(27,'b3995ad891d93c709dfc356d0fb13188',2,1,7,2,'1970-01-01 06:00:00','2018-06-21 21:02:12'),(28,'b3995ad891d93c709dfc356d0fb13188',2,1,2,2,'1970-01-01 06:00:00','2018-07-13 18:27:44'),(29,'aa90ffee1e75d6409a0667ffb69a4833',2,1,1,1,'1970-01-01 06:00:00','2018-07-13 18:34:47'),(30,'b3995ad891d93c709dfc356d0fb13188',2,1,2,2,'1970-01-01 06:00:00','2018-07-16 16:16:22'),(31,'b3995ad891d93c709dfc356d0fb13188',2,1,2,2,'1970-01-01 06:00:00','2018-08-06 17:47:49'),(32,'f4485a5c4c41770b60cc8c9c7de8485e',2,1,1,1,'1970-01-01 06:00:00','2018-08-06 17:57:52'),(33,'bcec4c8fe183327137ea6922c1dac2b2',2,1,1,1,'1970-01-01 06:00:00','2018-08-06 21:28:21'),(34,'bcec4c8fe183327137ea6922c1dac2b2',2,1,3,2,'1970-01-01 06:00:00','2018-08-06 21:28:27'),(35,'bcec4c8fe183327137ea6922c1dac2b2',2,1,5,2,'1970-01-01 06:00:00','2018-08-06 21:28:34'),(36,'bcec4c8fe183327137ea6922c1dac2b2',2,1,5,2,'1970-01-01 06:00:00','2018-08-06 21:28:40'),(37,'bcec4c8fe183327137ea6922c1dac2b2',2,1,5,3,'1970-01-01 06:00:00','2018-08-06 21:28:46'),(38,'bcec4c8fe183327137ea6922c1dac2b2',2,1,7,2,'1970-01-01 06:00:00','2018-08-06 21:28:51'),(39,'bcec4c8fe183327137ea6922c1dac2b2',2,1,5,2,'1970-01-01 06:00:00','2018-08-06 21:28:52'),(40,'bcec4c8fe183327137ea6922c1dac2b2',2,1,5,2,'1970-01-01 06:00:00','2018-08-06 21:28:55'),(41,'bcec4c8fe183327137ea6922c1dac2b2',2,1,5,2,'1970-01-01 06:00:00','2018-08-06 21:28:57'),(42,'bcec4c8fe183327137ea6922c1dac2b2',2,1,5,2,'1970-01-01 06:00:00','2018-08-06 21:30:09'),(43,'bcec4c8fe183327137ea6922c1dac2b2',2,1,5,2,'1970-01-01 06:00:00','2018-08-06 21:30:13'),(44,'bcec4c8fe183327137ea6922c1dac2b2',2,1,5,2,'1970-01-01 06:00:00','2018-08-06 21:30:21'),(45,'bcec4c8fe183327137ea6922c1dac2b2',2,1,5,2,'1970-01-01 06:00:00','2018-08-06 21:30:24'),(46,'f4485a5c4c41770b60cc8c9c7de8485e',2,1,2,1,'1970-01-01 06:00:00','2018-08-06 22:03:09'),(47,'ef8ce9138e4ec73ce010380396334bce',3,1,1,1,'1970-01-01 06:00:00','2018-09-20 22:29:06'),(48,'ef8ce9138e4ec73ce010380396334bce',3,1,3,2,'1970-01-01 06:00:00','2018-09-20 22:29:36'),(49,'ef8ce9138e4ec73ce010380396334bce',3,1,5,2,'1970-01-01 06:00:00','2018-09-20 22:29:38'),(50,'ef8ce9138e4ec73ce010380396334bce',3,1,5,3,'1970-01-01 06:00:00','2018-09-20 22:29:39'),(51,'ef8ce9138e4ec73ce010380396334bce',3,1,7,2,'1970-01-01 06:00:00','2018-09-20 22:29:41'),(52,'ef8ce9138e4ec73ce010380396334bce',3,1,5,3,'1970-01-01 06:00:00','2018-09-20 22:29:43'),(53,'ef8ce9138e4ec73ce010380396334bce',3,1,7,2,'1970-01-01 06:00:00','2018-09-20 22:29:44'),(54,'ef8ce9138e4ec73ce010380396334bce',3,1,5,2,'1970-01-01 06:00:00','2018-09-20 22:29:46'),(55,'ef8ce9138e4ec73ce010380396334bce',3,1,5,3,'1970-01-01 06:00:00','2018-09-20 22:29:48'),(56,'ef8ce9138e4ec73ce010380396334bce',3,1,7,2,'1970-01-01 06:00:00','2018-09-20 22:29:52'),(57,'ef8ce9138e4ec73ce010380396334bce',3,1,5,2,'1970-01-01 06:00:00','2018-09-20 22:29:53'),(58,'ef8ce9138e4ec73ce010380396334bce',3,1,5,2,'1970-01-01 06:00:00','2018-09-20 22:29:54'),(59,'ef8ce9138e4ec73ce010380396334bce',3,1,5,2,'1970-01-01 06:00:00','2018-09-20 22:29:59'),(60,'ef8ce9138e4ec73ce010380396334bce',3,1,5,3,'1970-01-01 06:00:00','2018-09-20 22:30:01'),(61,'ef8ce9138e4ec73ce010380396334bce',3,1,7,2,'1970-01-01 06:00:00','2018-09-20 22:30:04'),(62,'ef8ce9138e4ec73ce010380396334bce',3,1,5,2,'1970-01-01 06:00:00','2018-09-20 22:30:05'),(63,'ef8ce9138e4ec73ce010380396334bce',3,1,5,2,'1970-01-01 06:00:00','2018-09-20 22:30:05'),(64,'ef8ce9138e4ec73ce010380396334bce',3,1,5,2,'1970-01-01 06:00:00','2018-09-20 22:30:06'),(65,'ef8ce9138e4ec73ce010380396334bce',3,1,5,2,'1970-01-01 06:00:00','2018-09-20 22:30:07'),(66,'ef8ce9138e4ec73ce010380396334bce',3,1,5,3,'1970-01-01 06:00:00','2018-09-20 22:30:09'),(67,'ef8ce9138e4ec73ce010380396334bce',3,1,7,2,'1970-01-01 06:00:00','2018-09-20 22:30:10'),(68,'ef8ce9138e4ec73ce010380396334bce',3,1,5,2,'1970-01-01 06:00:00','2018-09-20 22:30:12'),(69,'ef8ce9138e4ec73ce010380396334bce',3,1,5,2,'1970-01-01 06:00:00','2018-09-20 22:30:12'),(70,'ef8ce9138e4ec73ce010380396334bce',3,1,5,2,'1970-01-01 06:00:00','2018-09-20 22:30:13'),(71,'ef8ce9138e4ec73ce010380396334bce',3,1,5,2,'1970-01-01 06:00:00','2018-09-20 22:30:14'),(72,'ef8ce9138e4ec73ce010380396334bce',3,1,5,2,'1970-01-01 06:00:00','2018-09-20 22:30:17'),(73,'ef8ce9138e4ec73ce010380396334bce',3,1,5,3,'1970-01-01 06:00:00','2018-09-20 22:30:18'),(74,'ef8ce9138e4ec73ce010380396334bce',3,1,7,2,'1970-01-01 06:00:00','2018-09-20 22:30:19'),(75,'ef8ce9138e4ec73ce010380396334bce',3,1,5,2,'1970-01-01 06:00:00','2018-09-20 22:30:21'),(76,'ef8ce9138e4ec73ce010380396334bce',3,1,5,2,'1970-01-01 06:00:00','2018-09-20 22:30:22'),(77,'ef8ce9138e4ec73ce010380396334bce',3,1,5,2,'1970-01-01 06:00:00','2018-09-20 22:30:23'),(78,'ef8ce9138e4ec73ce010380396334bce',3,1,5,2,'1970-01-01 06:00:00','2018-09-20 22:30:23'),(79,'ef8ce9138e4ec73ce010380396334bce',3,1,5,2,'1970-01-01 06:00:00','2018-09-20 22:30:26'),(80,'ef8ce9138e4ec73ce010380396334bce',3,1,5,2,'1970-01-01 06:00:00','2018-09-20 22:30:29'),(81,'ef8ce9138e4ec73ce010380396334bce',3,1,5,2,'1970-01-01 06:00:00','2018-09-20 22:30:33'),(82,'ef8ce9138e4ec73ce010380396334bce',3,1,5,2,'1970-01-01 06:00:00','2018-09-20 22:30:36'),(83,'ef8ce9138e4ec73ce010380396334bce',3,1,5,2,'1970-01-01 06:00:00','2018-09-20 22:30:37'),(84,'ef8ce9138e4ec73ce010380396334bce',3,1,5,2,'1970-01-01 06:00:00','2018-09-20 22:30:39'),(85,'ef8ce9138e4ec73ce010380396334bce',3,1,5,3,'1970-01-01 06:00:00','2018-09-20 22:30:45'),(86,'ef8ce9138e4ec73ce010380396334bce',3,1,4,4,'1970-01-01 06:00:00','2018-09-20 22:30:47'),(87,'ef8ce9138e4ec73ce010380396334bce',3,1,6,3,'1970-01-01 06:00:00','2018-09-20 22:30:53'),(88,'cd48290ae943f8dde9a4637b79dc22e0',3,1,1,1,'1970-01-01 06:00:00','2018-09-27 21:33:53'),(89,'cd48290ae943f8dde9a4637b79dc22e0',3,1,3,2,'1970-01-01 06:00:00','2018-09-27 21:33:55'),(90,'cd48290ae943f8dde9a4637b79dc22e0',3,1,5,3,'1970-01-01 06:00:00','2018-09-27 21:33:56'),(91,'9b20d0f631c50601885ea7d0b108d831',3,1,1,1,'1970-01-01 06:00:00','2018-10-02 05:01:58'),(92,'9b20d0f631c50601885ea7d0b108d831',3,1,3,2,'1970-01-01 06:00:00','2018-10-02 05:02:05'),(93,'e84800b60d35f066b229a63b9ff6a30f',3,1,1,1,'1970-01-01 06:00:00','2018-10-02 05:02:56'),(94,'ad01921775e2587d2310a60187fe6a05',3,1,1,1,'1970-01-01 06:00:00','2018-10-07 15:27:35'),(95,'ad01921775e2587d2310a60187fe6a05',3,1,3,2,'1970-01-01 06:00:00','2018-10-07 15:27:54'),(96,'ad01921775e2587d2310a60187fe6a05',3,1,5,2,'1970-01-01 06:00:00','2018-10-07 15:27:56'),(97,'ad01921775e2587d2310a60187fe6a05',3,1,5,2,'1970-01-01 06:00:00','2018-10-07 15:27:59'),(98,'ad01921775e2587d2310a60187fe6a05',3,1,5,3,'1970-01-01 06:00:00','2018-10-07 15:28:01'),(99,'ad01921775e2587d2310a60187fe6a05',3,1,7,2,'1970-01-01 06:00:00','2018-10-07 15:28:05'),(100,'ad01921775e2587d2310a60187fe6a05',3,1,5,3,'1970-01-01 06:00:00','2018-10-07 15:28:07'),(101,'ad01921775e2587d2310a60187fe6a05',3,1,7,2,'1970-01-01 06:00:00','2018-10-07 15:28:08'),(102,'ad01921775e2587d2310a60187fe6a05',3,1,5,2,'1970-01-01 06:00:00','2018-10-07 15:28:09'),(103,'ad01921775e2587d2310a60187fe6a05',3,1,5,2,'1970-01-01 06:00:00','2018-10-07 15:28:11'),(104,'ad01921775e2587d2310a60187fe6a05',3,1,5,2,'1970-01-01 06:00:00','2018-10-07 15:28:14'),(105,'ad01921775e2587d2310a60187fe6a05',3,1,5,2,'1970-01-01 06:00:00','2018-10-07 15:28:17'),(106,'ad01921775e2587d2310a60187fe6a05',3,1,5,3,'1970-01-01 06:00:00','2018-10-07 15:28:19'),(107,'ad01921775e2587d2310a60187fe6a05',3,1,4,4,'1970-01-01 06:00:00','2018-10-07 15:28:23'),(108,'ad01921775e2587d2310a60187fe6a05',3,1,3,2,'1970-01-01 06:00:00','2018-10-07 15:33:12'),(109,'ad01921775e2587d2310a60187fe6a05',3,1,5,2,'1970-01-01 06:00:00','2018-10-07 15:33:23'),(110,'ad01921775e2587d2310a60187fe6a05',3,1,5,2,'1970-01-01 06:00:00','2018-10-07 15:33:26'),(111,'ad01921775e2587d2310a60187fe6a05',3,1,5,2,'1970-01-01 06:00:00','2018-10-07 15:33:33'),(112,'ad01921775e2587d2310a60187fe6a05',3,1,5,2,'1970-01-01 06:00:00','2018-10-07 15:33:34'),(113,'ad01921775e2587d2310a60187fe6a05',3,1,5,2,'1970-01-01 06:00:00','2018-10-07 15:33:40'),(114,'ad01921775e2587d2310a60187fe6a05',3,1,5,2,'1970-01-01 06:00:00','2018-10-07 15:33:44'),(115,'ad01921775e2587d2310a60187fe6a05',3,1,5,2,'1970-01-01 06:00:00','2018-10-07 15:33:48'),(116,'ad01921775e2587d2310a60187fe6a05',3,1,5,2,'1970-01-01 06:00:00','2018-10-07 15:33:51'),(117,'ad01921775e2587d2310a60187fe6a05',3,1,5,2,'1970-01-01 06:00:00','2018-10-07 15:33:54'),(118,'ad01921775e2587d2310a60187fe6a05',3,1,5,2,'1970-01-01 06:00:00','2018-10-07 15:33:57'),(119,'ad01921775e2587d2310a60187fe6a05',3,1,5,2,'1970-01-01 06:00:00','2018-10-07 15:34:00'),(120,'ad01921775e2587d2310a60187fe6a05',3,1,5,2,'1970-01-01 06:00:00','2018-10-07 15:34:03'),(121,'ad01921775e2587d2310a60187fe6a05',3,1,5,2,'1970-01-01 06:00:00','2018-10-07 15:34:08'),(122,'ad01921775e2587d2310a60187fe6a05',3,1,5,2,'1970-01-01 06:00:00','2018-10-07 15:34:14'),(123,'ad01921775e2587d2310a60187fe6a05',3,1,5,2,'1970-01-01 06:00:00','2018-10-07 15:34:21'),(124,'ad01921775e2587d2310a60187fe6a05',3,1,5,3,'1970-01-01 06:00:00','2018-10-07 15:34:22'),(125,'ad01921775e2587d2310a60187fe6a05',3,1,4,4,'1970-01-01 06:00:00','2018-10-07 15:34:29'),(126,'ad01921775e2587d2310a60187fe6a05',3,1,6,2,'1970-01-01 06:00:00','2018-10-07 15:34:38'),(127,'ad01921775e2587d2310a60187fe6a05',3,1,6,2,'1970-01-01 06:00:00','2018-10-07 15:34:47'),(128,'ad01921775e2587d2310a60187fe6a05',3,1,6,2,'1970-01-01 06:00:00','2018-10-07 15:34:48'),(129,'ad01921775e2587d2310a60187fe6a05',3,1,6,2,'1970-01-01 06:00:00','2018-10-07 15:34:51'),(130,'b9ccafdf034ff4948b81b40ac28da438',3,1,1,1,'1970-01-01 06:00:00','2018-10-08 13:48:50'),(131,'cecf01b6dda08eab038cf38f1ef0f557',4,1,1,1,'1970-01-01 06:00:00','2018-10-09 20:45:18'),(132,'a35e9a7cad1557cb471a5e366c021401',4,1,1,1,'1970-01-01 06:00:00','2018-10-09 20:52:45'),(133,'a35e9a7cad1557cb471a5e366c021401',4,1,3,2,'1970-01-01 06:00:00','2018-10-09 20:52:46'),(134,'a35e9a7cad1557cb471a5e366c021401',4,1,5,3,'1970-01-01 06:00:00','2018-10-09 20:52:47'),(135,'a35e9a7cad1557cb471a5e366c021401',4,1,4,4,'1970-01-01 06:00:00','2018-10-09 20:52:48'),(136,'9495e6e1f3af22484d5321e11e42e386',3,1,1,1,'1970-01-01 06:00:00','2018-10-12 18:40:28'),(137,'9495e6e1f3af22484d5321e11e42e386',3,1,3,2,'1970-01-01 06:00:00','2018-10-12 18:40:35'),(138,'9495e6e1f3af22484d5321e11e42e386',3,1,5,2,'1970-01-01 06:00:00','2018-10-12 18:40:38'),(139,'9495e6e1f3af22484d5321e11e42e386',3,1,5,2,'1970-01-01 06:00:00','2018-10-12 18:40:39'),(140,'9495e6e1f3af22484d5321e11e42e386',3,1,5,2,'1970-01-01 06:00:00','2018-10-12 18:40:42'),(141,'9495e6e1f3af22484d5321e11e42e386',3,1,5,2,'1970-01-01 06:00:00','2018-10-12 18:40:43'),(142,'9495e6e1f3af22484d5321e11e42e386',3,1,5,3,'1970-01-01 06:00:00','2018-10-12 18:40:44'),(143,'9495e6e1f3af22484d5321e11e42e386',3,1,4,4,'1970-01-01 06:00:00','2018-10-12 18:40:47'),(144,'9495e6e1f3af22484d5321e11e42e386',3,1,5,4,'1970-01-01 06:00:00','2018-10-12 18:40:51'),(145,'9495e6e1f3af22484d5321e11e42e386',3,1,3,2,'1970-01-01 06:00:00','2018-10-12 18:41:13'),(146,'4be2a16e8e98f5c822a6b79d4e36bbe8',3,1,1,1,'1970-01-01 06:00:00','2018-10-12 20:10:37'),(147,'3a26bdf00bd91b2ef70feba4720203c6',3,1,1,1,'1970-01-01 06:00:00','2018-10-22 21:41:27'),(148,'3a26bdf00bd91b2ef70feba4720203c6',3,1,3,2,'1970-01-01 06:00:00','2018-10-22 21:41:38'),(149,'16c14ab167a73dd96c44b461c37eb498',3,1,1,1,'1970-01-01 06:00:00','2018-10-22 21:42:56'),(150,'16c14ab167a73dd96c44b461c37eb498',3,1,3,2,'1970-01-01 06:00:00','2018-10-22 21:43:13'),(151,'16c14ab167a73dd96c44b461c37eb498',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:43:16'),(152,'16c14ab167a73dd96c44b461c37eb498',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:43:18'),(153,'16c14ab167a73dd96c44b461c37eb498',3,1,5,3,'1970-01-01 06:00:00','2018-10-22 21:43:23'),(154,'5bb0978f49ab1407aab9e91232723526',3,1,1,1,'1970-01-01 06:00:00','2018-10-22 21:43:45'),(155,'5bb0978f49ab1407aab9e91232723526',3,1,3,2,'1970-01-01 06:00:00','2018-10-22 21:44:19'),(156,'5bb0978f49ab1407aab9e91232723526',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:44:21'),(157,'5bb0978f49ab1407aab9e91232723526',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:44:23'),(158,'5bb0978f49ab1407aab9e91232723526',3,1,5,3,'1970-01-01 06:00:00','2018-10-22 21:44:27'),(159,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,1,1,'1970-01-01 06:00:00','2018-10-22 21:46:00'),(160,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,3,2,'1970-01-01 06:00:00','2018-10-22 21:46:25'),(161,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:46:26'),(162,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:46:28'),(163,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,6,2,'1970-01-01 06:00:00','2018-10-22 21:46:35'),(164,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,6,2,'1970-01-01 06:00:00','2018-10-22 21:46:37'),(165,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:46:38'),(166,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,6,2,'1970-01-01 06:00:00','2018-10-22 21:46:41'),(167,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,3,'1970-01-01 06:00:00','2018-10-22 21:46:41'),(168,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,6,4,'1970-01-01 06:00:00','2018-10-22 21:46:48'),(169,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,3,2,'1970-01-01 06:00:00','2018-10-22 21:46:53'),(170,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:47:00'),(171,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,3,'1970-01-01 06:00:00','2018-10-22 21:47:04'),(172,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,4,4,'1970-01-01 06:00:00','2018-10-22 21:47:11'),(173,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,3,2,'1970-01-01 06:00:00','2018-10-22 21:47:18'),(174,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:47:51'),(175,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,6,2,'1970-01-01 06:00:00','2018-10-22 21:47:53'),(176,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,3,'1970-01-01 06:00:00','2018-10-22 21:47:54'),(177,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,7,2,'1970-01-01 06:00:00','2018-10-22 21:47:55'),(178,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:47:57'),(179,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:47:59'),(180,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:48:01'),(181,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,3,'1970-01-01 06:00:00','2018-10-22 21:48:04'),(182,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,6,2,'1970-01-01 06:00:00','2018-10-22 21:48:07'),(183,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,6,3,'1970-01-01 06:00:00','2018-10-22 21:48:08'),(184,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,6,2,'1970-01-01 06:00:00','2018-10-22 21:48:10'),(185,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:48:12'),(186,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,3,'1970-01-01 06:00:00','2018-10-22 21:48:14'),(187,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,1,1,'1970-01-01 06:00:00','2018-10-22 21:48:15'),(188,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,6,2,'1970-01-01 06:00:00','2018-10-22 21:48:18'),(189,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:48:19'),(190,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,3,'1970-01-01 06:00:00','2018-10-22 21:48:21'),(191,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,6,2,'1970-01-01 06:00:00','2018-10-22 21:48:23'),(192,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:48:24'),(193,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,3,2,'1970-01-01 06:00:00','2018-10-22 21:48:48'),(194,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:48:50'),(195,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:48:52'),(196,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,5,3,'1970-01-01 06:00:00','2018-10-22 21:48:56'),(197,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,6,2,'1970-01-01 06:00:00','2018-10-22 21:48:57'),(198,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,6,2,'1970-01-01 06:00:00','2018-10-22 21:48:58'),(199,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,7,2,'1970-01-01 06:00:00','2018-10-22 21:49:01'),(200,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:49:03'),(201,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:49:05'),(202,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,5,3,'1970-01-01 06:00:00','2018-10-22 21:49:07'),(203,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,7,2,'1970-01-01 06:00:00','2018-10-22 21:49:08'),(204,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:49:10'),(205,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:49:12'),(206,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,5,3,'1970-01-01 06:00:00','2018-10-22 21:49:15'),(207,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,7,2,'1970-01-01 06:00:00','2018-10-22 21:49:21'),(208,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:49:23'),(209,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:49:25'),(210,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,3,'1970-01-01 06:00:00','2018-10-22 21:49:26'),(211,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,6,2,'1970-01-01 06:00:00','2018-10-22 21:49:28'),(212,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:49:28'),(213,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:49:31'),(214,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:49:33'),(215,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:49:36'),(216,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,3,'1970-01-01 06:00:00','2018-10-22 21:49:41'),(217,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,6,2,'1970-01-01 06:00:00','2018-10-22 21:49:42'),(218,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:49:43'),(219,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:49:46'),(220,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:49:46'),(221,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:49:48'),(222,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:49:49'),(223,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:49:56'),(224,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:50:01'),(225,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:50:05'),(226,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:50:07'),(227,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:50:10'),(228,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:50:12'),(229,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:50:15'),(230,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:50:17'),(231,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:50:21'),(232,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:50:25'),(233,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:50:30'),(234,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:50:30'),(235,'92cd93f44d6e7ec11a4f5480b61bbab8',3,1,5,3,'1970-01-01 06:00:00','2018-10-22 21:50:32'),(236,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:50:32'),(237,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:50:35'),(238,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:50:37'),(239,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:50:39'),(240,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:50:41'),(241,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:51:09'),(242,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,6,2,'1970-01-01 06:00:00','2018-10-22 21:51:10'),(243,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:51:13'),(244,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:51:15'),(245,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,5,3,'1970-01-01 06:00:00','2018-10-22 21:51:16'),(246,'bcfa58cdbdf73ee2db672166ba32a0ae',3,1,7,2,'1970-01-01 06:00:00','2018-10-22 21:51:19'),(247,'38b410b29027bf115037535566e29ecd',3,1,1,1,'1970-01-01 06:00:00','2018-10-22 21:59:41'),(248,'38b410b29027bf115037535566e29ecd',3,1,3,2,'1970-01-01 06:00:00','2018-10-22 21:59:53'),(249,'38b410b29027bf115037535566e29ecd',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:59:55'),(250,'38b410b29027bf115037535566e29ecd',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 21:59:59'),(251,'38b410b29027bf115037535566e29ecd',3,1,5,3,'1970-01-01 06:00:00','2018-10-22 22:00:01'),(252,'38b410b29027bf115037535566e29ecd',3,1,7,2,'1970-01-01 06:00:00','2018-10-22 22:00:05'),(253,'38b410b29027bf115037535566e29ecd',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 22:00:07'),(254,'38b410b29027bf115037535566e29ecd',3,1,5,2,'1970-01-01 06:00:00','2018-10-22 22:00:09'),(255,'38b410b29027bf115037535566e29ecd',3,1,5,3,'1970-01-01 06:00:00','2018-10-22 22:00:12'),(256,'38b410b29027bf115037535566e29ecd',3,1,4,4,'1970-01-01 06:00:00','2018-10-22 22:00:14'),(257,'3135f7a748b0219829895dcd4c075359',3,1,1,1,'1970-01-01 06:00:00','2018-10-22 22:03:16'),(258,'3135f7a748b0219829895dcd4c075359',3,1,3,2,'1970-01-01 06:00:00','2018-10-22 22:04:12'),(259,'038f89082bd26848226710f8d482ed42',3,1,1,1,'1970-01-01 06:00:00','2018-10-24 00:58:48'),(260,'038f89082bd26848226710f8d482ed42',3,1,3,2,'1970-01-01 06:00:00','2018-10-24 02:26:38'),(261,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:26:40'),(262,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:26:42'),(263,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:26:51'),(264,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:26:52'),(265,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:26:55'),(266,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:26:58'),(267,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:27:11'),(268,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:27:12'),(269,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:27:14'),(270,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:27:15'),(271,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:27:17'),(272,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:27:19'),(273,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:27:24'),(274,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:27:26'),(275,'038f89082bd26848226710f8d482ed42',3,1,5,3,'1970-01-01 06:00:00','2018-10-24 02:27:27'),(276,'038f89082bd26848226710f8d482ed42',3,1,7,2,'1970-01-01 06:00:00','2018-10-24 02:27:31'),(277,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:27:32'),(278,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:27:32'),(279,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:27:33'),(280,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:27:34'),(281,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:27:35'),(282,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:27:37'),(283,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:27:39'),(284,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:27:40'),(285,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:27:40'),(286,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:27:41'),(287,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:27:44'),(288,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:27:46'),(289,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:27:50'),(290,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:27:52'),(291,'038f89082bd26848226710f8d482ed42',3,1,5,2,'1970-01-01 06:00:00','2018-10-24 02:27:53'),(292,'038f89082bd26848226710f8d482ed42',3,1,5,3,'1970-01-01 06:00:00','2018-10-24 02:27:54'),(293,'89c17ca2a00dc8b9536411c30100b53b',3,1,1,1,'1970-01-01 06:00:00','2018-10-29 18:25:25'),(294,'89c17ca2a00dc8b9536411c30100b53b',3,1,3,2,'1970-01-01 06:00:00','2018-10-29 18:25:42'),(295,'89c17ca2a00dc8b9536411c30100b53b',3,1,5,2,'1970-01-01 06:00:00','2018-10-29 18:25:44'),(296,'89c17ca2a00dc8b9536411c30100b53b',3,1,5,2,'1970-01-01 06:00:00','2018-10-29 18:25:47'),(297,'89c17ca2a00dc8b9536411c30100b53b',3,1,5,3,'1970-01-01 06:00:00','2018-10-29 18:25:55'),(298,'89c17ca2a00dc8b9536411c30100b53b',3,1,7,2,'1970-01-01 06:00:00','2018-10-29 18:26:00'),(299,'89c17ca2a00dc8b9536411c30100b53b',3,1,5,2,'1970-01-01 06:00:00','2018-10-29 18:26:03'),(300,'89c17ca2a00dc8b9536411c30100b53b',3,1,5,2,'1970-01-01 06:00:00','2018-10-29 18:26:05'),(301,'89c17ca2a00dc8b9536411c30100b53b',3,1,5,2,'1970-01-01 06:00:00','2018-10-29 18:26:07'),(302,'89c17ca2a00dc8b9536411c30100b53b',3,1,5,2,'1970-01-01 06:00:00','2018-10-29 18:26:10'),(303,'89c17ca2a00dc8b9536411c30100b53b',3,1,5,2,'1970-01-01 06:00:00','2018-10-29 18:26:12'),(304,'89c17ca2a00dc8b9536411c30100b53b',3,1,5,2,'1970-01-01 06:00:00','2018-10-29 18:26:14'),(305,'89c17ca2a00dc8b9536411c30100b53b',3,1,5,2,'1970-01-01 06:00:00','2018-10-29 18:26:16'),(306,'89c17ca2a00dc8b9536411c30100b53b',3,1,5,3,'1970-01-01 06:00:00','2018-10-29 18:26:18'),(307,'89c17ca2a00dc8b9536411c30100b53b',3,1,4,4,'1970-01-01 06:00:00','2018-10-29 18:26:22'),(308,'2e548d62940b69270d5b0d6e2448f2a4',4,1,1,1,'1970-01-01 06:00:00','2018-11-02 19:35:42'),(309,'b325958d0f3d6dc94edc0d9cea0204ea',3,1,1,1,'1970-01-01 06:00:00','2018-11-02 19:36:19'),(310,'b5dc226fcac8dca11e27ecbd16c7d9b3',4,1,1,1,'1970-01-01 06:00:00','2018-11-02 19:37:59'),(311,'dad23db944a200c99a0668e5a00e2003',3,1,1,1,'1970-01-01 06:00:00','2018-11-02 19:40:45'),(312,'f77c388a583f058718d0d6b7a0719721',4,1,1,1,'1970-01-01 06:00:00','2018-11-02 20:08:05'),(313,'1080e0e2f900ca02f3863d6fa16ca6bd',3,1,1,1,'1970-01-01 06:00:00','2018-11-02 20:22:09'),(314,'af44e5542d5fb83fad90f087416e23ba',4,1,1,1,'1970-01-01 06:00:00','2018-11-02 20:24:21'),(315,'fcfbfeafacdc746552cdc06e5bb4f090',4,1,1,1,'1970-01-01 06:00:00','2018-11-02 20:25:07'),(316,'3e600d01568f680cd07ec65211eaef55',4,1,1,1,'1970-01-01 06:00:00','2018-11-02 20:26:10'),(317,'bdef21b71de1663f312c9515747af421',4,1,1,1,'1970-01-01 06:00:00','2018-11-02 20:29:18'),(318,'09b354873909a64b3e1c0c2226fe35a7',4,1,1,1,'1970-01-01 06:00:00','2018-11-02 20:36:09'),(319,'20e1ebdc822329bd71b83578d18c13f7',4,1,1,1,'1970-01-01 06:00:00','2018-11-02 20:36:18'),(320,'5ae9d07c6008d68454bb36879f9067f6',3,1,1,1,'1970-01-01 06:00:00','2018-11-06 18:24:56'),(321,'679401078f360143c212fcd7d4821ab5',4,1,1,1,'1970-01-01 06:00:00','2018-11-06 19:17:40'),(322,'ce233eadb1a646591af7b1e32677b0f7',4,1,1,1,'1970-01-01 06:00:00','2018-11-06 19:48:08'),(323,'9474b21c95a66824cb083c9c0003467c',4,1,1,1,'1970-01-01 06:00:00','2018-11-06 19:51:02'),(324,'39c8c5f0ac85b4b0ce2b0b806b47c3ad',4,1,1,1,'1970-01-01 06:00:00','2018-11-06 19:54:57'),(325,'d51c98010e25b3455e1c1f916e465eb7',3,1,1,1,'1970-01-01 06:00:00','2018-11-07 16:32:31'),(326,'d51c98010e25b3455e1c1f916e465eb7',3,1,3,2,'1970-01-01 06:00:00','2018-11-07 16:32:37'),(327,'d51c98010e25b3455e1c1f916e465eb7',3,1,5,2,'1970-01-01 06:00:00','2018-11-07 16:32:38'),(328,'d51c98010e25b3455e1c1f916e465eb7',3,1,5,2,'1970-01-01 06:00:00','2018-11-07 16:32:39'),(329,'d51c98010e25b3455e1c1f916e465eb7',3,1,5,2,'1970-01-01 06:00:00','2018-11-07 16:32:39'),(330,'d51c98010e25b3455e1c1f916e465eb7',3,1,5,2,'1970-01-01 06:00:00','2018-11-07 16:32:41'),(331,'d51c98010e25b3455e1c1f916e465eb7',3,1,5,2,'1970-01-01 06:00:00','2018-11-07 16:32:42'),(332,'d51c98010e25b3455e1c1f916e465eb7',3,1,5,2,'1970-01-01 06:00:00','2018-11-07 16:32:43'),(333,'d51c98010e25b3455e1c1f916e465eb7',3,1,5,2,'1970-01-01 06:00:00','2018-11-07 16:32:43'),(334,'d51c98010e25b3455e1c1f916e465eb7',3,1,5,2,'1970-01-01 06:00:00','2018-11-07 16:32:43'),(335,'d51c98010e25b3455e1c1f916e465eb7',3,1,5,2,'1970-01-01 06:00:00','2018-11-07 16:32:44'),(336,'d51c98010e25b3455e1c1f916e465eb7',3,1,5,2,'1970-01-01 06:00:00','2018-11-07 16:32:45'),(337,'d51c98010e25b3455e1c1f916e465eb7',3,1,5,2,'1970-01-01 06:00:00','2018-11-07 16:32:47'),(338,'d51c98010e25b3455e1c1f916e465eb7',3,1,5,2,'1970-01-01 06:00:00','2018-11-07 16:32:48'),(339,'d51c98010e25b3455e1c1f916e465eb7',3,1,5,2,'1970-01-01 06:00:00','2018-11-07 16:32:50'),(340,'d51c98010e25b3455e1c1f916e465eb7',3,1,5,2,'1970-01-01 06:00:00','2018-11-07 16:32:50'),(341,'d51c98010e25b3455e1c1f916e465eb7',3,1,5,2,'1970-01-01 06:00:00','2018-11-07 16:32:51'),(342,'d51c98010e25b3455e1c1f916e465eb7',3,1,5,2,'1970-01-01 06:00:00','2018-11-07 16:32:51'),(343,'d51c98010e25b3455e1c1f916e465eb7',3,1,5,2,'1970-01-01 06:00:00','2018-11-07 16:32:54'),(344,'d51c98010e25b3455e1c1f916e465eb7',3,1,5,2,'1970-01-01 06:00:00','2018-11-07 16:32:55'),(345,'d51c98010e25b3455e1c1f916e465eb7',3,1,5,2,'1970-01-01 06:00:00','2018-11-07 16:32:57'),(346,'d51c98010e25b3455e1c1f916e465eb7',3,1,5,3,'1970-01-01 06:00:00','2018-11-07 16:32:58'),(347,'d51c98010e25b3455e1c1f916e465eb7',3,1,7,2,'1970-01-01 06:00:00','2018-11-07 16:33:06'),(348,'d51c98010e25b3455e1c1f916e465eb7',3,1,5,3,'1970-01-01 06:00:00','2018-11-07 16:33:09'),(349,'d51c98010e25b3455e1c1f916e465eb7',3,1,7,2,'1970-01-01 06:00:00','2018-11-07 16:33:12'),(350,'d51c98010e25b3455e1c1f916e465eb7',3,1,5,2,'1970-01-01 06:00:00','2018-11-07 16:33:13'),(351,'d51c98010e25b3455e1c1f916e465eb7',3,1,5,2,'1970-01-01 06:00:00','2018-11-07 16:33:14'),(352,'f8675d78a22501cf7bf7f9f759724404',3,1,1,1,'1970-01-01 06:00:00','2018-11-07 18:52:43'),(353,'84f05cc13bfa2c8fc86219ac5e426289',5,1,1,1,'1970-01-01 06:00:00','2018-11-30 18:17:36'),(354,'b099f1773bc496c0437048d8d3896e15',5,1,1,1,'1970-01-01 06:00:00','2018-11-30 18:20:13'),(355,'1bdc72eca72629209f38614387c4e507',5,1,1,1,'1970-01-01 06:00:00','2018-11-30 18:21:23'),(356,'84f40d96e4eca000179c512f5ce857c9',5,1,1,1,'1970-01-01 06:00:00','2018-11-30 18:21:50'),(357,'c08d343bcb9e437956d228e482e11a6c',3,1,1,1,'1970-01-01 06:00:00','2018-11-30 21:14:48'),(358,'98890b6240ec14337a578d10892536bf',5,1,1,1,'1970-01-01 06:00:00','2018-12-06 20:25:25'),(359,'98890b6240ec14337a578d10892536bf',5,1,3,2,'1970-01-01 06:00:00','2018-12-06 20:25:55'),(360,'846911aace9fab2c8b4b7aca55b3efa0',5,1,1,1,'1970-01-01 06:00:00','2018-12-06 20:25:59'),(361,'1332b1ddfad388df141bd89559a512b4',3,1,1,1,'1970-01-01 06:00:00','2018-12-06 20:26:02'),(362,'1332b1ddfad388df141bd89559a512b4',3,1,3,2,'1970-01-01 06:00:00','2018-12-06 20:26:47'),(363,'1332b1ddfad388df141bd89559a512b4',3,1,5,2,'1970-01-01 06:00:00','2018-12-06 20:26:48'),(364,'1332b1ddfad388df141bd89559a512b4',3,1,5,2,'1970-01-01 06:00:00','2018-12-06 20:26:49'),(365,'1332b1ddfad388df141bd89559a512b4',3,1,5,2,'1970-01-01 06:00:00','2018-12-06 20:26:51'),(366,'1332b1ddfad388df141bd89559a512b4',3,1,5,2,'1970-01-01 06:00:00','2018-12-06 20:26:51'),(367,'1332b1ddfad388df141bd89559a512b4',3,1,5,2,'1970-01-01 06:00:00','2018-12-06 20:26:52'),(368,'846911aace9fab2c8b4b7aca55b3efa0',5,1,3,2,'1970-01-01 06:00:00','2018-12-06 20:26:59'),(369,'846911aace9fab2c8b4b7aca55b3efa0',5,1,5,2,'1970-01-01 06:00:00','2018-12-06 20:27:01'),(370,'846911aace9fab2c8b4b7aca55b3efa0',5,1,5,2,'1970-01-01 06:00:00','2018-12-06 20:27:02'),(371,'846911aace9fab2c8b4b7aca55b3efa0',5,1,5,3,'1970-01-01 06:00:00','2018-12-06 20:27:07'),(372,'846911aace9fab2c8b4b7aca55b3efa0',5,1,6,4,'1970-01-01 06:00:00','2018-12-06 20:27:11'),(373,'846911aace9fab2c8b4b7aca55b3efa0',5,1,5,4,'1970-01-01 06:00:00','2018-12-06 20:27:18'),(374,'846911aace9fab2c8b4b7aca55b3efa0',5,1,3,2,'1970-01-01 06:00:00','2018-12-06 20:27:26'),(375,'867239a9d94f54566818d9d9034634cf',5,1,1,1,'1970-01-01 06:00:00','2018-12-06 20:27:31'),(376,'867239a9d94f54566818d9d9034634cf',5,1,3,2,'1970-01-01 06:00:00','2018-12-06 20:28:16'),(377,'1162602b180ba22b5df729a2d2c8c827',5,1,1,1,'1970-01-01 06:00:00','2018-12-06 20:31:04'),(378,'fe08670eb4ed108558ef2d9abcdd6056',3,1,1,1,'1970-01-01 06:00:00','2019-02-20 18:19:06'),(379,'fe08670eb4ed108558ef2d9abcdd6056',3,1,3,2,'1970-01-01 06:00:00','2019-02-20 18:19:28'),(380,'fe08670eb4ed108558ef2d9abcdd6056',3,1,5,2,'1970-01-01 06:00:00','2019-02-20 18:19:30'),(381,'fe08670eb4ed108558ef2d9abcdd6056',3,1,5,2,'1970-01-01 06:00:00','2019-02-20 18:19:32'),(382,'fe08670eb4ed108558ef2d9abcdd6056',3,1,5,3,'1970-01-01 06:00:00','2019-02-20 18:19:37'),(383,'fe08670eb4ed108558ef2d9abcdd6056',3,1,7,2,'1970-01-01 06:00:00','2019-02-20 18:19:40'),(384,'fe08670eb4ed108558ef2d9abcdd6056',3,1,5,2,'1970-01-01 06:00:00','2019-02-20 18:19:47'),(385,'fe08670eb4ed108558ef2d9abcdd6056',3,1,5,2,'1970-01-01 06:00:00','2019-02-20 18:19:49'),(386,'fe08670eb4ed108558ef2d9abcdd6056',3,1,5,2,'1970-01-01 06:00:00','2019-02-20 18:19:53'),(387,'fe08670eb4ed108558ef2d9abcdd6056',3,1,5,2,'1970-01-01 06:00:00','2019-02-20 18:19:55'),(388,'fe08670eb4ed108558ef2d9abcdd6056',3,1,5,2,'1970-01-01 06:00:00','2019-02-20 18:20:05'),(389,'fe08670eb4ed108558ef2d9abcdd6056',3,1,5,2,'1970-01-01 06:00:00','2019-02-20 18:20:09'),(390,'fe08670eb4ed108558ef2d9abcdd6056',3,1,5,2,'1970-01-01 06:00:00','2019-02-20 18:21:07'),(391,'fe08670eb4ed108558ef2d9abcdd6056',3,1,5,2,'1970-01-01 06:00:00','2019-02-20 18:21:09'),(392,'fe08670eb4ed108558ef2d9abcdd6056',3,1,5,2,'1970-01-01 06:00:00','2019-02-20 18:21:14'),(393,'fe08670eb4ed108558ef2d9abcdd6056',3,1,5,2,'1970-01-01 06:00:00','2019-02-20 18:21:17'),(394,'fe08670eb4ed108558ef2d9abcdd6056',3,1,5,2,'1970-01-01 06:00:00','2019-02-20 18:21:19'),(395,'fe08670eb4ed108558ef2d9abcdd6056',3,1,5,2,'1970-01-01 06:00:00','2019-02-20 18:21:21'),(396,'fe08670eb4ed108558ef2d9abcdd6056',3,1,5,2,'1970-01-01 06:00:00','2019-02-20 18:22:04'),(397,'fe08670eb4ed108558ef2d9abcdd6056',3,1,5,2,'1970-01-01 06:00:00','2019-02-20 18:22:05'),(398,'fe08670eb4ed108558ef2d9abcdd6056',3,1,5,3,'1970-01-01 06:00:00','2019-02-20 18:22:09'),(399,'fe08670eb4ed108558ef2d9abcdd6056',3,1,4,4,'1970-01-01 06:00:00','2019-02-20 18:22:13'),(400,'304d81fd23fc530329ea5d5c3e6b7780',3,1,1,1,'1970-01-01 06:00:00','2019-03-01 16:49:36'),(401,'304d81fd23fc530329ea5d5c3e6b7780',3,1,3,2,'1970-01-01 06:00:00','2019-03-01 16:50:13'),(402,'304d81fd23fc530329ea5d5c3e6b7780',3,1,5,2,'1970-01-01 06:00:00','2019-03-01 16:50:15'),(403,'304d81fd23fc530329ea5d5c3e6b7780',3,1,5,2,'1970-01-01 06:00:00','2019-03-01 16:50:17'),(404,'304d81fd23fc530329ea5d5c3e6b7780',3,1,5,2,'1970-01-01 06:00:00','2019-03-01 16:50:20'),(405,'304d81fd23fc530329ea5d5c3e6b7780',3,1,5,2,'1970-01-01 06:00:00','2019-03-01 16:50:22'),(406,'304d81fd23fc530329ea5d5c3e6b7780',3,1,5,3,'1970-01-01 06:00:00','2019-03-01 16:50:23'),(407,'304d81fd23fc530329ea5d5c3e6b7780',3,1,4,4,'1970-01-01 06:00:00','2019-03-01 16:50:27'),(408,'b98a6376f616dad7505c410ae30d4d99',5,1,1,1,'1970-01-01 06:00:00','2019-03-04 19:05:22'),(409,'0611aee743b97c3f15a3cf8e588d7477',5,1,1,1,'1970-01-01 06:00:00','2019-03-04 19:06:29'),(410,'b98a6376f616dad7505c410ae30d4d99',5,1,3,2,'1970-01-01 06:00:00','2019-03-04 19:06:39'),(411,'b98a6376f616dad7505c410ae30d4d99',5,1,5,3,'1970-01-01 06:00:00','2019-03-04 19:06:40'),(412,'b98a6376f616dad7505c410ae30d4d99',5,1,7,2,'1970-01-01 06:00:00','2019-03-04 19:06:44'),(413,'b98a6376f616dad7505c410ae30d4d99',5,1,5,2,'1970-01-01 06:00:00','2019-03-04 19:06:46'),(414,'b98a6376f616dad7505c410ae30d4d99',5,1,5,3,'1970-01-01 06:00:00','2019-03-04 19:06:48'),(415,'b98a6376f616dad7505c410ae30d4d99',5,1,7,2,'1970-01-01 06:00:00','2019-03-04 19:06:52'),(416,'b98a6376f616dad7505c410ae30d4d99',5,1,5,3,'1970-01-01 06:00:00','2019-03-04 19:06:55'),(417,'b98a6376f616dad7505c410ae30d4d99',5,1,7,2,'1970-01-01 06:00:00','2019-03-04 19:06:56'),(418,'b98a6376f616dad7505c410ae30d4d99',5,1,5,2,'1970-01-01 06:00:00','2019-03-04 19:07:02'),(419,'b98a6376f616dad7505c410ae30d4d99',5,1,5,2,'1970-01-01 06:00:00','2019-03-04 19:07:04'),(420,'b98a6376f616dad7505c410ae30d4d99',5,1,5,2,'1970-01-01 06:00:00','2019-03-04 19:07:11'),(421,'b98a6376f616dad7505c410ae30d4d99',5,1,5,3,'1970-01-01 06:00:00','2019-03-04 19:07:14'),(422,'b98a6376f616dad7505c410ae30d4d99',5,1,7,2,'1970-01-01 06:00:00','2019-03-04 19:07:15'),(423,'b98a6376f616dad7505c410ae30d4d99',5,1,5,2,'1970-01-01 06:00:00','2019-03-04 19:07:17'),(424,'b98a6376f616dad7505c410ae30d4d99',5,1,5,2,'1970-01-01 06:00:00','2019-03-04 19:07:19'),(425,'b98a6376f616dad7505c410ae30d4d99',5,1,5,2,'1970-01-01 06:00:00','2019-03-04 19:07:21'),(426,'b98a6376f616dad7505c410ae30d4d99',5,1,5,2,'1970-01-01 06:00:00','2019-03-04 19:07:25'),(427,'b98a6376f616dad7505c410ae30d4d99',5,1,5,2,'1970-01-01 06:00:00','2019-03-04 19:07:29'),(428,'b98a6376f616dad7505c410ae30d4d99',5,1,5,2,'1970-01-01 06:00:00','2019-03-04 19:07:38'),(429,'b98a6376f616dad7505c410ae30d4d99',5,1,5,2,'1970-01-01 06:00:00','2019-03-04 19:07:42'),(430,'b98a6376f616dad7505c410ae30d4d99',5,1,5,3,'1970-01-01 06:00:00','2019-03-04 19:07:46'),(431,'722e335a6b6712ec1ac6ed9908dc5fd2',2,1,1,1,'1970-01-01 06:00:00','2019-03-11 16:32:53'),(432,'722e335a6b6712ec1ac6ed9908dc5fd2',2,1,2,1,'1970-01-01 06:00:00','2019-03-19 13:24:55'),(433,'722e335a6b6712ec1ac6ed9908dc5fd2',2,1,2,1,'1970-01-01 06:00:00','2019-03-26 16:25:55'),(434,'9dab84cd450bb191a0b356b561805c16',5,1,1,1,'1970-01-01 06:00:00','2019-04-04 13:16:01'),(435,'cbc155c0e2612972fb877c50957c911a',5,1,1,1,'1970-01-01 06:00:00','2019-04-04 13:16:29'),(436,'cbc155c0e2612972fb877c50957c911a',5,1,3,2,'1970-01-01 06:00:00','2019-04-04 13:17:18'),(437,'cbc155c0e2612972fb877c50957c911a',5,1,5,2,'1970-01-01 06:00:00','2019-04-04 13:17:19'),(438,'cbc155c0e2612972fb877c50957c911a',5,1,5,2,'1970-01-01 06:00:00','2019-04-04 13:17:21'),(439,'cbc155c0e2612972fb877c50957c911a',5,1,5,3,'1970-01-01 06:00:00','2019-04-04 13:17:23'),(440,'cbc155c0e2612972fb877c50957c911a',5,1,4,4,'1970-01-01 06:00:00','2019-04-04 13:17:30'),(441,'503729b8727a6b3972a8b426e837bc3b',5,1,1,1,'1970-01-01 06:00:00','2019-04-08 19:07:51'),(442,'d95835006dc27b128e7c4a7027217f3f',5,1,1,1,'1970-01-01 06:00:00','2019-04-08 19:08:24'),(443,'9b7de627d44650eeebabd967777a6720',5,1,1,1,'1970-01-01 06:00:00','2019-04-08 19:10:01'),(444,'b280fdbd87983eeead7d1f526065a08a',5,1,1,1,'1970-01-01 06:00:00','2019-04-08 19:10:14'),(445,'f4f64cd6d4bfa42575541a7b4ba936c1',5,1,1,1,'1970-01-01 06:00:00','2019-04-08 19:10:30'),(446,'d6a9ae5cf7bdfacc3c747b3e20306788',6,1,1,1,'1970-01-01 06:00:00','2019-04-08 19:11:12'),(447,'98c38c6e5a302033ca188943816ee06c',6,1,1,1,'1970-01-01 06:00:00','2019-04-08 19:11:21'),(448,'b0dcdd13c84b3282064a2519c8f9176d',3,1,1,1,'1970-01-01 06:00:00','2019-05-15 23:28:03'),(449,'b0dcdd13c84b3282064a2519c8f9176d',3,1,3,2,'1970-01-01 06:00:00','2019-05-15 23:28:06'),(450,'b0dcdd13c84b3282064a2519c8f9176d',3,1,5,3,'1970-01-01 06:00:00','2019-05-15 23:28:07'),(451,'b0dcdd13c84b3282064a2519c8f9176d',3,1,4,4,'1970-01-01 06:00:00','2019-05-15 23:28:09'),(452,'b0dcdd13c84b3282064a2519c8f9176d',3,1,5,4,'1970-01-01 06:00:00','2019-05-15 23:28:11'),(453,'0611aac76fc22707fa304fb5acd2ef44',2,1,1,1,'1970-01-01 06:00:00','2019-06-17 20:57:27'),(454,'0611aac76fc22707fa304fb5acd2ef44',2,1,3,2,'1970-01-01 06:00:00','2019-06-17 20:57:32'),(455,'0611aac76fc22707fa304fb5acd2ef44',2,1,5,2,'1970-01-01 06:00:00','2019-06-17 20:57:34'),(456,'0611aac76fc22707fa304fb5acd2ef44',2,1,5,2,'1970-01-01 06:00:00','2019-06-17 20:57:35'),(457,'0611aac76fc22707fa304fb5acd2ef44',2,1,6,4,'1970-01-01 06:00:00','2019-06-17 20:57:37'),(458,'0611aac76fc22707fa304fb5acd2ef44',2,1,6,2,'1970-01-01 06:00:00','2019-06-17 20:57:40'),(459,'0611aac76fc22707fa304fb5acd2ef44',2,1,6,2,'1970-01-01 06:00:00','2019-06-17 20:57:44'),(460,'0611aac76fc22707fa304fb5acd2ef44',2,1,6,2,'1970-01-01 06:00:00','2019-06-17 20:57:46'),(461,'0611aac76fc22707fa304fb5acd2ef44',2,1,6,2,'1970-01-01 06:00:00','2019-06-17 20:57:53'),(462,'0611aac76fc22707fa304fb5acd2ef44',2,1,6,2,'1970-01-01 06:00:00','2019-06-17 20:57:54'),(463,'0611aac76fc22707fa304fb5acd2ef44',2,1,5,2,'1970-01-01 06:00:00','2019-06-17 20:57:56'),(464,'0611aac76fc22707fa304fb5acd2ef44',2,1,5,2,'1970-01-01 06:00:00','2019-06-17 20:57:57'),(465,'642085ab57ff0a22522b65a85ffc051f',3,1,1,1,'1970-01-01 06:00:00','2019-07-25 21:41:11'),(466,'642085ab57ff0a22522b65a85ffc051f',3,1,3,2,'1970-01-01 06:00:00','2019-07-25 21:41:36'),(467,'642085ab57ff0a22522b65a85ffc051f',3,1,5,3,'1970-01-01 06:00:00','2019-07-25 21:41:37'),(468,'642085ab57ff0a22522b65a85ffc051f',3,1,7,2,'1970-01-01 06:00:00','2019-07-25 21:41:39'),(469,'d48c9b85987fb42fba9f3f79ddfa780d',7,1,1,1,'1970-01-01 06:00:00','2019-08-14 14:19:20'),(470,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,2,1,'1970-01-01 06:00:00','2019-08-14 14:19:24'),(471,'d48c9b85987fb42fba9f3f79ddfa780d',7,1,2,1,'1970-01-01 06:00:00','2019-08-14 14:19:27'),(472,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,2,1,'1970-01-01 06:00:00','2019-08-14 14:19:28'),(473,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,3,2,'1970-01-01 06:00:00','2019-08-14 14:20:02'),(474,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,5,2,'1970-01-01 06:00:00','2019-08-14 14:20:04'),(475,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,5,2,'1970-01-01 06:00:00','2019-08-14 14:20:04'),(476,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,6,2,'1970-01-01 06:00:00','2019-08-14 14:20:05'),(477,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,5,2,'1970-01-01 06:00:00','2019-08-14 14:20:06'),(478,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,5,3,'1970-01-01 06:00:00','2019-08-14 14:20:07'),(479,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,4,4,'1970-01-01 06:00:00','2019-08-14 14:20:09'),(480,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,5,4,'1970-01-01 06:00:00','2019-08-14 14:20:13'),(481,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,5,4,'1970-01-01 06:00:00','2019-08-14 14:20:14'),(482,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,5,4,'1970-01-01 06:00:00','2019-08-14 14:20:16'),(483,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,5,4,'1970-01-01 06:00:00','2019-08-14 14:20:17'),(484,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,5,4,'1970-01-01 06:00:00','2019-08-14 14:20:18'),(485,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,5,4,'1970-01-01 06:00:00','2019-08-14 14:20:19'),(486,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,5,4,'1970-01-01 06:00:00','2019-08-14 14:20:22'),(487,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,5,4,'1970-01-01 06:00:00','2019-08-14 14:20:23'),(488,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,5,4,'1970-01-01 06:00:00','2019-08-14 14:20:25'),(489,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,5,4,'1970-01-01 06:00:00','2019-08-14 14:20:26'),(490,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,5,4,'1970-01-01 06:00:00','2019-08-14 14:20:27'),(491,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,5,4,'1970-01-01 06:00:00','2019-08-14 14:20:29'),(492,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,5,4,'1970-01-01 06:00:00','2019-08-14 14:20:30'),(493,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,3,2,'1970-01-01 06:00:00','2019-08-14 14:20:35'),(494,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,6,4,'1970-01-01 06:00:00','2019-08-14 14:20:36'),(495,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,2,4,'1970-01-01 06:00:00','2019-08-14 14:22:17'),(496,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,2,4,'1970-01-01 06:00:00','2019-08-14 14:22:18'),(497,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,2,4,'1970-01-01 06:00:00','2019-08-14 14:22:19'),(498,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,2,4,'1970-01-01 06:00:00','2019-08-14 14:22:20'),(499,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,2,4,'1970-01-01 06:00:00','2019-08-14 14:22:21'),(500,'e15f79023d7a86ab193b01ff0db4edd8',8,1,1,1,'1970-01-01 06:00:00','2019-08-14 14:32:11'),(501,'e15f79023d7a86ab193b01ff0db4edd8',8,1,3,2,'1970-01-01 06:00:00','2019-08-14 14:32:32'),(502,'e15f79023d7a86ab193b01ff0db4edd8',8,1,5,2,'1970-01-01 06:00:00','2019-08-14 14:32:36'),(503,'e15f79023d7a86ab193b01ff0db4edd8',8,1,5,2,'1970-01-01 06:00:00','2019-08-14 14:32:38'),(504,'e15f79023d7a86ab193b01ff0db4edd8',8,1,5,2,'1970-01-01 06:00:00','2019-08-14 14:32:41'),(505,'e15f79023d7a86ab193b01ff0db4edd8',8,1,5,2,'1970-01-01 06:00:00','2019-08-14 14:32:45'),(506,'e15f79023d7a86ab193b01ff0db4edd8',8,1,5,2,'1970-01-01 06:00:00','2019-08-14 14:32:49'),(507,'e15f79023d7a86ab193b01ff0db4edd8',8,1,5,2,'1970-01-01 06:00:00','2019-08-14 14:32:50'),(508,'e15f79023d7a86ab193b01ff0db4edd8',8,1,5,2,'1970-01-01 06:00:00','2019-08-14 14:32:54'),(509,'e15f79023d7a86ab193b01ff0db4edd8',8,1,5,2,'1970-01-01 06:00:00','2019-08-14 14:32:56'),(510,'e15f79023d7a86ab193b01ff0db4edd8',8,1,5,2,'1970-01-01 06:00:00','2019-08-14 14:32:58'),(511,'e15f79023d7a86ab193b01ff0db4edd8',8,1,5,2,'1970-01-01 06:00:00','2019-08-14 14:32:59'),(512,'e15f79023d7a86ab193b01ff0db4edd8',8,1,5,2,'1970-01-01 06:00:00','2019-08-14 14:33:02'),(513,'e15f79023d7a86ab193b01ff0db4edd8',8,1,5,2,'1970-01-01 06:00:00','2019-08-14 14:33:04'),(514,'e15f79023d7a86ab193b01ff0db4edd8',8,1,5,2,'1970-01-01 06:00:00','2019-08-14 14:33:07'),(515,'e15f79023d7a86ab193b01ff0db4edd8',8,1,5,2,'1970-01-01 06:00:00','2019-08-14 14:33:09'),(516,'e15f79023d7a86ab193b01ff0db4edd8',8,1,5,2,'1970-01-01 06:00:00','2019-08-14 14:33:15'),(517,'e15f79023d7a86ab193b01ff0db4edd8',8,1,5,2,'1970-01-01 06:00:00','2019-08-14 14:33:17'),(518,'e15f79023d7a86ab193b01ff0db4edd8',8,1,5,3,'1970-01-01 06:00:00','2019-08-14 14:33:18'),(519,'e15f79023d7a86ab193b01ff0db4edd8',8,1,4,4,'1970-01-01 06:00:00','2019-08-14 14:33:23'),(520,'e15f79023d7a86ab193b01ff0db4edd8',8,1,2,4,'1970-01-01 06:00:00','2019-08-14 15:31:26'),(521,'bab3e98e560773564c81eb4995503cdc',3,1,1,1,'1970-01-01 06:00:00','2019-08-21 13:54:35'),(522,'8e02ac33c0254ef67b57cdb1e3aede79',8,1,1,1,'1970-01-01 06:00:00','2019-08-21 19:16:49'),(523,'6ba6937bad0701a51080657b2620e68e',8,1,1,1,'1970-01-01 06:00:00','2019-08-21 19:16:49'),(524,'6ba6937bad0701a51080657b2620e68e',8,1,3,2,'1970-01-01 06:00:00','2019-08-21 19:17:04'),(525,'8e02ac33c0254ef67b57cdb1e3aede79',8,1,3,2,'1970-01-01 06:00:00','2019-08-21 19:17:07'),(526,'6ba6937bad0701a51080657b2620e68e',8,1,5,2,'1970-01-01 06:00:00','2019-08-21 19:17:07'),(527,'6ba6937bad0701a51080657b2620e68e',8,1,5,2,'1970-01-01 06:00:00','2019-08-21 19:22:51'),(528,'6ba6937bad0701a51080657b2620e68e',8,1,5,2,'1970-01-01 06:00:00','2019-08-21 19:22:53'),(529,'6ba6937bad0701a51080657b2620e68e',8,1,5,2,'1970-01-01 06:00:00','2019-08-21 19:22:55'),(530,'6ba6937bad0701a51080657b2620e68e',8,1,5,2,'1970-01-01 06:00:00','2019-08-21 19:22:57'),(531,'6ba6937bad0701a51080657b2620e68e',8,1,5,2,'1970-01-01 06:00:00','2019-08-21 19:23:01'),(532,'6ba6937bad0701a51080657b2620e68e',8,1,5,2,'1970-01-01 06:00:00','2019-08-21 19:23:07'),(533,'6ba6937bad0701a51080657b2620e68e',8,1,5,2,'1970-01-01 06:00:00','2019-08-21 19:23:10'),(534,'6ba6937bad0701a51080657b2620e68e',8,1,5,2,'1970-01-01 06:00:00','2019-08-21 19:23:11'),(535,'6ba6937bad0701a51080657b2620e68e',8,1,5,2,'1970-01-01 06:00:00','2019-08-21 19:23:16'),(536,'6ba6937bad0701a51080657b2620e68e',8,1,5,2,'1970-01-01 06:00:00','2019-08-21 19:23:17'),(537,'6ba6937bad0701a51080657b2620e68e',8,1,5,2,'1970-01-01 06:00:00','2019-08-21 19:23:19'),(538,'6ba6937bad0701a51080657b2620e68e',8,1,5,2,'1970-01-01 06:00:00','2019-08-21 19:23:30'),(539,'6ba6937bad0701a51080657b2620e68e',8,1,5,2,'1970-01-01 06:00:00','2019-08-21 19:23:38'),(540,'6ba6937bad0701a51080657b2620e68e',8,1,5,2,'1970-01-01 06:00:00','2019-08-21 19:24:00'),(541,'6ba6937bad0701a51080657b2620e68e',8,1,5,3,'1970-01-01 06:00:00','2019-08-21 19:24:02'),(542,'3e77756c9f90e38eb057cd37ce563052',8,1,1,1,'1970-01-01 06:00:00','2019-08-23 18:52:24'),(543,'3e77756c9f90e38eb057cd37ce563052',8,1,3,2,'1970-01-01 06:00:00','2019-08-23 18:58:07'),(544,'3e77756c9f90e38eb057cd37ce563052',8,1,5,2,'1970-01-01 06:00:00','2019-08-23 18:58:26'),(545,'3e77756c9f90e38eb057cd37ce563052',8,1,5,2,'1970-01-01 06:00:00','2019-08-23 18:58:37'),(546,'3e77756c9f90e38eb057cd37ce563052',8,1,5,2,'1970-01-01 06:00:00','2019-08-23 18:58:56'),(547,'3e77756c9f90e38eb057cd37ce563052',8,1,5,2,'1970-01-01 06:00:00','2019-08-23 18:59:14'),(548,'3e77756c9f90e38eb057cd37ce563052',8,1,5,2,'1970-01-01 06:00:00','2019-08-23 18:59:24'),(549,'3e77756c9f90e38eb057cd37ce563052',8,1,5,2,'1970-01-01 06:00:00','2019-08-23 18:59:29'),(550,'3e77756c9f90e38eb057cd37ce563052',8,1,5,2,'1970-01-01 06:00:00','2019-08-23 18:59:34'),(551,'3e77756c9f90e38eb057cd37ce563052',8,1,5,2,'1970-01-01 06:00:00','2019-08-23 18:59:36'),(552,'3e77756c9f90e38eb057cd37ce563052',8,1,5,2,'1970-01-01 06:00:00','2019-08-23 18:59:38'),(553,'3e77756c9f90e38eb057cd37ce563052',8,1,5,2,'1970-01-01 06:00:00','2019-08-23 18:59:42'),(554,'3e77756c9f90e38eb057cd37ce563052',8,1,5,2,'1970-01-01 06:00:00','2019-08-23 18:59:44'),(555,'3e77756c9f90e38eb057cd37ce563052',8,1,5,2,'1970-01-01 06:00:00','2019-08-23 18:59:46'),(556,'3e77756c9f90e38eb057cd37ce563052',8,1,5,2,'1970-01-01 06:00:00','2019-08-23 18:59:50'),(557,'3e77756c9f90e38eb057cd37ce563052',8,1,5,2,'1970-01-01 06:00:00','2019-08-23 18:59:55'),(558,'3e77756c9f90e38eb057cd37ce563052',8,1,5,2,'1970-01-01 06:00:00','2019-08-23 18:59:56'),(559,'3e77756c9f90e38eb057cd37ce563052',8,1,5,2,'1970-01-01 06:00:00','2019-08-23 19:00:04'),(560,'3e77756c9f90e38eb057cd37ce563052',8,1,5,2,'1970-01-01 06:00:00','2019-08-23 19:00:05'),(561,'3e77756c9f90e38eb057cd37ce563052',8,1,5,3,'1970-01-01 06:00:00','2019-08-23 19:00:07'),(562,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,2,4,'1970-01-01 06:00:00','2019-08-26 20:24:14'),(563,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,2,4,'1970-01-01 06:00:00','2019-08-27 21:33:23'),(564,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,2,4,'1970-01-01 06:00:00','2019-08-27 21:34:15'),(565,'4fdcdff599c742c4df0fde84316dca73',8,1,1,1,'1970-01-01 06:00:00','2019-08-27 21:34:31'),(566,'4fdcdff599c742c4df0fde84316dca73',8,1,3,2,'1970-01-01 06:00:00','2019-08-27 21:34:41'),(567,'4fdcdff599c742c4df0fde84316dca73',8,1,5,2,'1970-01-01 06:00:00','2019-08-27 21:34:46'),(568,'4fdcdff599c742c4df0fde84316dca73',8,1,5,2,'1970-01-01 06:00:00','2019-08-27 21:34:48'),(569,'4fdcdff599c742c4df0fde84316dca73',8,1,5,3,'1970-01-01 06:00:00','2019-08-27 21:34:53'),(570,'4fdcdff599c742c4df0fde84316dca73',8,1,7,2,'1970-01-01 06:00:00','2019-08-27 21:35:40'),(571,'4fdcdff599c742c4df0fde84316dca73',8,1,5,2,'1970-01-01 06:00:00','2019-08-27 21:35:43'),(572,'4fdcdff599c742c4df0fde84316dca73',8,1,5,3,'1970-01-01 06:00:00','2019-08-27 21:35:47'),(573,'4fdcdff599c742c4df0fde84316dca73',8,1,7,2,'1970-01-01 06:00:00','2019-08-27 21:35:49'),(574,'4fdcdff599c742c4df0fde84316dca73',8,1,5,2,'1970-01-01 06:00:00','2019-08-27 21:35:53'),(575,'4fdcdff599c742c4df0fde84316dca73',8,1,5,2,'1970-01-01 06:00:00','2019-08-27 21:35:56'),(576,'4fdcdff599c742c4df0fde84316dca73',8,1,5,2,'1970-01-01 06:00:00','2019-08-27 21:36:01'),(577,'4fdcdff599c742c4df0fde84316dca73',8,1,5,2,'1970-01-01 06:00:00','2019-08-27 21:36:04'),(578,'4fdcdff599c742c4df0fde84316dca73',8,1,5,2,'1970-01-01 06:00:00','2019-08-27 21:36:12'),(579,'4fdcdff599c742c4df0fde84316dca73',8,1,5,2,'1970-01-01 06:00:00','2019-08-27 21:36:18'),(580,'4fdcdff599c742c4df0fde84316dca73',8,1,5,3,'1970-01-01 06:00:00','2019-08-27 21:36:20'),(581,'4fdcdff599c742c4df0fde84316dca73',8,1,7,2,'1970-01-01 06:00:00','2019-08-27 21:36:30'),(582,'4fdcdff599c742c4df0fde84316dca73',8,1,5,3,'1970-01-01 06:00:00','2019-08-27 21:36:34'),(583,'4fdcdff599c742c4df0fde84316dca73',8,1,7,2,'1970-01-01 06:00:00','2019-08-27 21:36:36'),(584,'4fdcdff599c742c4df0fde84316dca73',8,1,5,2,'1970-01-01 06:00:00','2019-08-27 21:36:37'),(585,'4fdcdff599c742c4df0fde84316dca73',8,1,5,2,'1970-01-01 06:00:00','2019-08-27 21:36:51'),(586,'4fdcdff599c742c4df0fde84316dca73',8,1,5,2,'1970-01-01 06:00:00','2019-08-27 21:37:09'),(587,'4fdcdff599c742c4df0fde84316dca73',8,1,5,2,'1970-01-01 06:00:00','2019-08-27 21:37:19'),(588,'4fdcdff599c742c4df0fde84316dca73',8,1,5,3,'1970-01-01 06:00:00','2019-08-27 21:37:52'),(589,'4fdcdff599c742c4df0fde84316dca73',8,1,4,4,'1970-01-01 06:00:00','2019-08-27 21:37:54'),(590,'84aa0cf5c16d90d1d41e602afd3267f2',3,1,1,1,'1970-01-01 06:00:00','2019-09-04 18:10:20'),(591,'6ba6937bad0701a51080657b2620e68e',8,1,2,3,'1970-01-01 06:00:00','2019-09-18 20:16:37'),(592,'6ba6937bad0701a51080657b2620e68e',8,1,6,2,'1970-01-01 06:00:00','2019-09-18 20:17:02'),(593,'6ba6937bad0701a51080657b2620e68e',8,1,6,2,'1970-01-01 06:00:00','2019-09-18 20:17:03'),(594,'6ba6937bad0701a51080657b2620e68e',8,1,6,2,'1970-01-01 06:00:00','2019-09-18 20:17:04'),(595,'6ba6937bad0701a51080657b2620e68e',8,1,6,2,'1970-01-01 06:00:00','2019-09-18 20:17:05'),(596,'6ba6937bad0701a51080657b2620e68e',8,1,6,2,'1970-01-01 06:00:00','2019-09-18 20:17:06'),(597,'6ba6937bad0701a51080657b2620e68e',8,1,6,2,'1970-01-01 06:00:00','2019-09-18 20:17:08'),(598,'6ba6937bad0701a51080657b2620e68e',8,1,5,2,'1970-01-01 06:00:00','2019-09-18 20:17:13'),(599,'6ba6937bad0701a51080657b2620e68e',8,1,5,2,'1970-01-01 06:00:00','2019-09-18 20:17:16'),(600,'6ba6937bad0701a51080657b2620e68e',8,1,5,2,'1970-01-01 06:00:00','2019-09-18 20:17:18'),(601,'1787290f1415c44009083cc48580b140',8,1,1,1,'1970-01-01 06:00:00','2019-09-21 03:18:06'),(602,'1787290f1415c44009083cc48580b140',8,1,3,2,'1970-01-01 06:00:00','2019-09-21 03:18:14'),(603,'1787290f1415c44009083cc48580b140',8,1,5,2,'1970-01-01 06:00:00','2019-09-21 03:18:24'),(604,'1787290f1415c44009083cc48580b140',8,1,5,2,'1970-01-01 06:00:00','2019-09-21 03:18:26'),(605,'1787290f1415c44009083cc48580b140',8,1,5,2,'1970-01-01 06:00:00','2019-09-21 03:18:38'),(606,'1787290f1415c44009083cc48580b140',8,1,5,2,'1970-01-01 06:00:00','2019-09-21 03:18:50'),(607,'1787290f1415c44009083cc48580b140',8,1,5,2,'1970-01-01 06:00:00','2019-09-21 03:18:56'),(608,'1787290f1415c44009083cc48580b140',8,1,5,2,'1970-01-01 06:00:00','2019-09-21 03:19:04'),(609,'1787290f1415c44009083cc48580b140',8,1,5,2,'1970-01-01 06:00:00','2019-09-21 03:19:12'),(610,'1787290f1415c44009083cc48580b140',8,1,5,2,'1970-01-01 06:00:00','2019-09-21 03:19:15'),(611,'1787290f1415c44009083cc48580b140',8,1,5,2,'1970-01-01 06:00:00','2019-09-21 03:19:19'),(612,'1787290f1415c44009083cc48580b140',8,1,5,2,'1970-01-01 06:00:00','2019-09-21 03:19:22'),(613,'1787290f1415c44009083cc48580b140',8,1,5,2,'1970-01-01 06:00:00','2019-09-21 03:19:25'),(614,'1787290f1415c44009083cc48580b140',8,1,5,2,'1970-01-01 06:00:00','2019-09-21 03:19:31'),(615,'1787290f1415c44009083cc48580b140',8,1,5,2,'1970-01-01 06:00:00','2019-09-21 03:19:35'),(616,'1787290f1415c44009083cc48580b140',8,1,5,2,'1970-01-01 06:00:00','2019-09-21 03:19:39'),(617,'1787290f1415c44009083cc48580b140',8,1,5,2,'1970-01-01 06:00:00','2019-09-21 03:19:51'),(618,'1787290f1415c44009083cc48580b140',8,1,5,2,'1970-01-01 06:00:00','2019-09-21 03:19:53'),(619,'1787290f1415c44009083cc48580b140',8,1,5,3,'1970-01-01 06:00:00','2019-09-21 03:19:57'),(620,'1787290f1415c44009083cc48580b140',8,1,4,4,'1970-01-01 06:00:00','2019-09-21 03:20:17'),(621,'1787290f1415c44009083cc48580b140',8,1,2,4,'1970-01-01 06:00:00','2019-09-21 21:09:58'),(622,'1787290f1415c44009083cc48580b140',8,1,3,2,'1970-01-01 06:00:00','2019-09-21 21:10:01'),(623,'1787290f1415c44009083cc48580b140',8,1,2,2,'1970-01-01 06:00:00','2019-09-22 00:22:48'),(624,'0611aac76fc22707fa304fb5acd2ef44',9,1,2,2,'1970-01-01 06:00:00','2019-09-23 18:59:14'),(625,'0611aac76fc22707fa304fb5acd2ef44',2,1,2,2,'1970-01-01 06:00:00','2019-09-23 19:49:01'),(626,'d48c9b85987fb42fba9f3f79ddfa780d',8,1,2,4,'1970-01-01 06:00:00','2019-09-23 19:52:18'),(627,'0611aac76fc22707fa304fb5acd2ef44',2,1,2,2,'1970-01-01 06:00:00','2019-10-08 13:18:04'),(628,'0611aac76fc22707fa304fb5acd2ef44',10,1,2,2,'1970-01-01 06:00:00','2019-10-08 13:18:50'),(629,'0611aac76fc22707fa304fb5acd2ef44',10,1,2,2,'1970-01-01 06:00:00','2019-10-08 13:18:51'),(630,'0611aac76fc22707fa304fb5acd2ef44',10,1,6,4,'1970-01-01 06:00:00','2019-10-08 13:18:54'),(631,'0611aac76fc22707fa304fb5acd2ef44',10,1,2,4,'1970-01-01 06:00:00','2019-10-08 13:19:11'),(632,'0611aac76fc22707fa304fb5acd2ef44',10,1,3,2,'1970-01-01 06:00:00','2019-10-08 13:19:13'),(633,'0611aac76fc22707fa304fb5acd2ef44',10,1,5,2,'1970-01-01 06:00:00','2019-10-08 13:19:14'),(634,'0611aac76fc22707fa304fb5acd2ef44',10,1,5,2,'1970-01-01 06:00:00','2019-10-08 13:19:15'),(635,'0611aac76fc22707fa304fb5acd2ef44',10,1,5,2,'1970-01-01 06:00:00','2019-10-08 13:19:16'),(636,'0611aac76fc22707fa304fb5acd2ef44',10,1,6,4,'1970-01-01 06:00:00','2019-10-08 13:19:17'),(637,'0611aac76fc22707fa304fb5acd2ef44',10,1,2,4,'1970-01-01 06:00:00','2019-10-08 13:19:28'),(638,'0611aac76fc22707fa304fb5acd2ef44',2,1,2,4,'1970-01-01 06:00:00','2019-10-08 13:19:40'),(639,'ff98648e51e86aaa3dda8b0b7451d463',2,1,1,1,'1970-01-01 06:00:00','2019-10-08 13:19:48'),(640,'0611aac76fc22707fa304fb5acd2ef44',2,1,2,4,'1970-01-01 06:00:00','2019-10-08 13:20:43'),(641,'0611aac76fc22707fa304fb5acd2ef44',2,1,2,4,'1970-01-01 06:00:00','2019-10-08 13:25:54'),(642,'7b58bfd0291e877128561a8f129ae903',2,1,1,1,'1970-01-01 06:00:00','2019-10-08 15:00:39'),(643,'7b58bfd0291e877128561a8f129ae903',2,1,2,1,'1970-01-01 06:00:00','2019-10-08 15:14:49'),(644,'7b58bfd0291e877128561a8f129ae903',2,1,3,2,'1970-01-01 06:00:00','2019-10-08 15:14:56'),(645,'7b58bfd0291e877128561a8f129ae903',2,1,5,3,'1970-01-01 06:00:00','2019-10-08 15:14:57'),(646,'7b58bfd0291e877128561a8f129ae903',2,1,7,2,'1970-01-01 06:00:00','2019-10-08 15:15:00'),(647,'7b58bfd0291e877128561a8f129ae903',2,1,5,2,'1970-01-01 06:00:00','2019-10-08 15:15:01'),(648,'7b58bfd0291e877128561a8f129ae903',2,1,5,2,'1970-01-01 06:00:00','2019-10-08 15:15:02'),(649,'7b58bfd0291e877128561a8f129ae903',2,1,5,2,'1970-01-01 06:00:00','2019-10-08 15:15:04'),(650,'7b58bfd0291e877128561a8f129ae903',2,1,5,2,'1970-01-01 06:00:00','2019-10-08 15:15:06'),(651,'7b58bfd0291e877128561a8f129ae903',2,1,5,2,'1970-01-01 06:00:00','2019-10-08 15:15:08'),(652,'7b58bfd0291e877128561a8f129ae903',2,1,5,2,'1970-01-01 06:00:00','2019-10-08 15:15:10'),(653,'7b58bfd0291e877128561a8f129ae903',2,1,5,2,'1970-01-01 06:00:00','2019-10-08 15:15:10'),(654,'7b58bfd0291e877128561a8f129ae903',2,1,5,2,'1970-01-01 06:00:00','2019-10-08 15:15:11'),(655,'7b58bfd0291e877128561a8f129ae903',2,1,5,2,'1970-01-01 06:00:00','2019-10-08 15:15:12'),(656,'7b58bfd0291e877128561a8f129ae903',2,1,5,2,'1970-01-01 06:00:00','2019-10-08 15:15:13'),(657,'7b58bfd0291e877128561a8f129ae903',2,1,5,2,'1970-01-01 06:00:00','2019-10-08 15:15:14'),(658,'7b58bfd0291e877128561a8f129ae903',2,1,5,2,'1970-01-01 06:00:00','2019-10-08 15:15:15'),(659,'7b58bfd0291e877128561a8f129ae903',2,1,5,2,'1970-01-01 06:00:00','2019-10-08 15:15:16'),(660,'7b58bfd0291e877128561a8f129ae903',2,1,5,2,'1970-01-01 06:00:00','2019-10-08 15:15:17'),(661,'7b58bfd0291e877128561a8f129ae903',2,1,5,2,'1970-01-01 06:00:00','2019-10-08 15:15:18'),(662,'7b58bfd0291e877128561a8f129ae903',2,1,5,2,'1970-01-01 06:00:00','2019-10-08 15:15:19'),(663,'7b58bfd0291e877128561a8f129ae903',2,1,5,2,'1970-01-01 06:00:00','2019-10-08 15:15:20'),(664,'7b58bfd0291e877128561a8f129ae903',2,1,5,2,'1970-01-01 06:00:00','2019-10-08 15:15:21'),(665,'7b58bfd0291e877128561a8f129ae903',2,1,5,2,'1970-01-01 06:00:00','2019-10-08 15:15:22'),(666,'7b58bfd0291e877128561a8f129ae903',2,1,5,3,'1970-01-01 06:00:00','2019-10-08 15:15:23'),(667,'7b58bfd0291e877128561a8f129ae903',2,1,7,2,'1970-01-01 06:00:00','2019-10-08 15:15:25'),(668,'0611aac76fc22707fa304fb5acd2ef44',10,1,2,4,'1970-01-01 06:00:00','2019-10-28 19:12:16'),(669,'0611aac76fc22707fa304fb5acd2ef44',2,1,2,4,'1970-01-01 06:00:00','2019-10-28 19:12:27'),(670,'c75e66bb8423564cba8b9e0e8a759f92',2,1,1,1,'1970-01-01 06:00:00','2019-10-28 20:20:18'),(671,'1651aa13a89cf5c006c4a5e5c7e0a0aa',2,1,1,1,'1970-01-01 06:00:00','2019-11-02 05:39:35'),(672,'1651aa13a89cf5c006c4a5e5c7e0a0aa',2,1,3,2,'1970-01-01 06:00:00','2019-11-02 05:39:42'),(673,'1651aa13a89cf5c006c4a5e5c7e0a0aa',2,1,5,2,'1970-01-01 06:00:00','2019-11-02 05:39:44'),(674,'1651aa13a89cf5c006c4a5e5c7e0a0aa',2,1,5,3,'1970-01-01 06:00:00','2019-11-02 05:39:47'),(675,'1651aa13a89cf5c006c4a5e5c7e0a0aa',2,1,7,2,'1970-01-01 06:00:00','2019-11-02 05:39:54'),(676,'1651aa13a89cf5c006c4a5e5c7e0a0aa',2,1,5,2,'1970-01-01 06:00:00','2019-11-02 05:39:56'),(677,'1651aa13a89cf5c006c4a5e5c7e0a0aa',2,1,5,2,'1970-01-01 06:00:00','2019-11-02 05:40:01'),(678,'1651aa13a89cf5c006c4a5e5c7e0a0aa',2,1,5,3,'1970-01-01 06:00:00','2019-11-02 05:40:09'),(679,'1651aa13a89cf5c006c4a5e5c7e0a0aa',2,1,2,3,'1970-01-01 06:00:00','2019-11-02 05:45:54'),(680,'1651aa13a89cf5c006c4a5e5c7e0a0aa',2,1,2,3,'1970-01-01 06:00:00','2019-11-02 05:46:12'),(681,'1651aa13a89cf5c006c4a5e5c7e0a0aa',2,1,2,3,'1970-01-01 06:00:00','2019-11-02 05:46:31'),(682,'0611aac76fc22707fa304fb5acd2ef44',2,1,2,4,'1970-01-01 06:00:00','2019-11-19 16:53:33'),(683,'0611aac76fc22707fa304fb5acd2ef44',2,1,2,4,'1970-01-01 06:00:00','2019-11-19 16:54:20'),(684,'0611aac76fc22707fa304fb5acd2ef44',2,1,3,2,'1970-01-01 06:00:00','2019-11-19 16:58:35'),(685,'0611aac76fc22707fa304fb5acd2ef44',2,1,5,3,'1970-01-01 06:00:00','2019-11-19 16:58:58'),(686,'0611aac76fc22707fa304fb5acd2ef44',2,1,7,2,'1970-01-01 06:00:00','2019-11-19 16:59:00'),(687,'0611aac76fc22707fa304fb5acd2ef44',2,1,5,2,'1970-01-01 06:00:00','2019-11-19 16:59:24'),(688,'0611aac76fc22707fa304fb5acd2ef44',2,1,6,2,'1970-01-01 06:00:00','2019-11-19 16:59:38'),(689,'0611aac76fc22707fa304fb5acd2ef44',2,1,6,4,'1970-01-01 06:00:00','2019-11-19 16:59:54'),(690,'0611aac76fc22707fa304fb5acd2ef44',2,1,5,4,'1970-01-01 06:00:00','2019-11-19 17:02:27'),(691,'0611aac76fc22707fa304fb5acd2ef44',2,1,5,4,'1970-01-01 06:00:00','2019-11-19 17:02:29'),(692,'0611aac76fc22707fa304fb5acd2ef44',2,1,5,4,'1970-01-01 06:00:00','2019-11-19 17:02:35'),(693,'0611aac76fc22707fa304fb5acd2ef44',2,1,5,4,'1970-01-01 06:00:00','2019-11-19 17:02:38'),(694,'0611aac76fc22707fa304fb5acd2ef44',2,1,5,4,'1970-01-01 06:00:00','2019-11-19 17:02:40'),(695,'0611aac76fc22707fa304fb5acd2ef44',2,1,5,4,'1970-01-01 06:00:00','2019-11-19 17:02:42'),(696,'0611aac76fc22707fa304fb5acd2ef44',2,1,5,4,'1970-01-01 06:00:00','2019-11-19 17:03:02'),(697,'0611aac76fc22707fa304fb5acd2ef44',2,1,5,4,'1970-01-01 06:00:00','2019-11-19 17:03:04'),(698,'0611aac76fc22707fa304fb5acd2ef44',2,1,5,4,'1970-01-01 06:00:00','2019-11-19 17:03:05'),(699,'0611aac76fc22707fa304fb5acd2ef44',2,1,6,2,'1970-01-01 06:00:00','2019-11-19 17:10:05'),(700,'0611aac76fc22707fa304fb5acd2ef44',2,1,5,2,'1970-01-01 06:00:00','2019-11-19 17:10:08'),(701,'0611aac76fc22707fa304fb5acd2ef44',2,1,5,3,'1970-01-01 06:00:00','2019-11-19 17:10:09'),(702,'8e75832ba15c06387765bbb7c1d48605',2,1,1,1,'1970-01-01 06:00:00','2019-11-19 17:10:18'),(703,'8e75832ba15c06387765bbb7c1d48605',2,1,3,2,'1970-01-01 06:00:00','2019-11-19 17:10:29'),(704,'8e75832ba15c06387765bbb7c1d48605',2,1,5,2,'1970-01-01 06:00:00','2019-11-19 17:10:33'),(705,'8e75832ba15c06387765bbb7c1d48605',2,1,5,2,'1970-01-01 06:00:00','2019-11-19 17:10:33'),(706,'0611aac76fc22707fa304fb5acd2ef44',2,1,2,3,'1970-01-01 06:00:00','2019-11-19 17:19:14'),(707,'0611aac76fc22707fa304fb5acd2ef44',2,1,6,2,'1970-01-01 06:00:00','2019-11-19 17:24:45'),(708,'0611aac76fc22707fa304fb5acd2ef44',2,1,6,3,'1970-01-01 06:00:00','2019-11-19 17:24:46'),(709,'0611aac76fc22707fa304fb5acd2ef44',2,1,6,2,'1970-01-01 06:00:00','2019-11-19 17:24:47'),(710,'0611aac76fc22707fa304fb5acd2ef44',2,1,5,2,'1970-01-01 06:00:00','2019-11-19 17:24:56'),(711,'0611aac76fc22707fa304fb5acd2ef44',2,1,6,2,'1970-01-01 06:00:00','2019-11-19 17:24:58'),(712,'0611aac76fc22707fa304fb5acd2ef44',2,1,6,2,'1970-01-01 06:00:00','2019-11-19 17:24:59'),(713,'0611aac76fc22707fa304fb5acd2ef44',2,1,5,2,'1970-01-01 06:00:00','2019-11-19 17:24:59'),(714,'0611aac76fc22707fa304fb5acd2ef44',2,1,5,2,'1970-01-01 06:00:00','2019-11-19 17:25:00'),(715,'0611aac76fc22707fa304fb5acd2ef44',2,1,6,2,'1970-01-01 06:00:00','2019-11-19 17:25:01'),(716,'0611aac76fc22707fa304fb5acd2ef44',2,1,5,3,'1970-01-01 06:00:00','2019-11-19 17:25:06'),(717,'0611aac76fc22707fa304fb5acd2ef44',2,1,7,2,'1970-01-01 06:00:00','2019-11-19 17:25:09'),(718,'0611aac76fc22707fa304fb5acd2ef44',2,1,5,2,'1970-01-01 06:00:00','2019-11-19 17:25:14'),(719,'0611aac76fc22707fa304fb5acd2ef44',2,1,5,2,'1970-01-01 06:00:00','2019-11-19 17:25:14'),(720,'0611aac76fc22707fa304fb5acd2ef44',2,1,5,2,'1970-01-01 06:00:00','2019-11-19 17:25:15'),(721,'0611aac76fc22707fa304fb5acd2ef44',2,1,5,2,'1970-01-01 06:00:00','2019-11-19 17:25:16'),(722,'0611aac76fc22707fa304fb5acd2ef44',2,1,2,2,'1970-01-01 06:00:00','2019-11-19 22:12:50'),(723,'a3a9982a155764bef535662efe7f86a2',2,1,1,1,'1970-01-01 06:00:00','2019-12-25 20:13:19'),(724,'a3a9982a155764bef535662efe7f86a2',2,1,1,1,'1970-01-01 06:00:00','2019-12-25 20:23:38'),(725,'a3a9982a155764bef535662efe7f86a2',2,1,1,1,'1970-01-01 06:00:00','2020-02-08 04:50:51'),(726,'bc67ed2c56362e459630e6899b321419',8,1,1,1,'1970-01-01 06:00:00','2020-02-11 18:38:42'),(727,'bc67ed2c56362e459630e6899b321419',8,1,2,1,'1970-01-01 06:00:00','2020-02-11 18:40:44'),(728,'a1594f0d098df55d9ad304103e23bb31',8,1,1,1,'1970-01-01 06:00:00','2020-02-12 15:28:39'),(729,'a1594f0d098df55d9ad304103e23bb31',8,1,3,2,'1970-01-01 06:00:00','2020-02-12 15:28:48'),(730,'a1594f0d098df55d9ad304103e23bb31',8,1,5,2,'1970-01-01 06:00:00','2020-02-12 15:28:57'),(731,'a1594f0d098df55d9ad304103e23bb31',8,1,5,2,'1970-01-01 06:00:00','2020-02-12 15:29:08'),(732,'a1594f0d098df55d9ad304103e23bb31',8,1,5,3,'1970-01-01 06:00:00','2020-02-12 15:29:14'),(733,'a1594f0d098df55d9ad304103e23bb31',8,1,7,2,'1970-01-01 06:00:00','2020-02-12 15:29:19'),(734,'a1594f0d098df55d9ad304103e23bb31',8,1,5,2,'1970-01-01 06:00:00','2020-02-12 15:29:21'),(735,'a1594f0d098df55d9ad304103e23bb31',8,1,5,2,'1970-01-01 06:00:00','2020-02-12 15:29:23'),(736,'a1594f0d098df55d9ad304103e23bb31',8,1,5,3,'1970-01-01 06:00:00','2020-02-12 15:29:28'),(737,'a1594f0d098df55d9ad304103e23bb31',8,1,4,4,'1970-01-01 06:00:00','2020-02-12 15:29:30'),(738,'a1594f0d098df55d9ad304103e23bb31',8,1,2,4,'1970-01-01 06:00:00','2020-02-13 19:55:56'),(739,'a1594f0d098df55d9ad304103e23bb31',8,1,3,2,'1970-01-01 06:00:00','2020-02-13 19:56:05'),(740,'a1594f0d098df55d9ad304103e23bb31',8,1,5,2,'1970-01-01 06:00:00','2020-02-13 19:56:08'),(741,'a1594f0d098df55d9ad304103e23bb31',8,1,5,2,'1970-01-01 06:00:00','2020-02-13 19:56:10'),(742,'a1594f0d098df55d9ad304103e23bb31',8,1,5,2,'1970-01-01 06:00:00','2020-02-13 19:56:15'),(743,'a1594f0d098df55d9ad304103e23bb31',8,1,5,2,'1970-01-01 06:00:00','2020-02-13 19:56:20'),(744,'a1594f0d098df55d9ad304103e23bb31',8,1,5,2,'1970-01-01 06:00:00','2020-02-13 19:56:22'),(745,'a1594f0d098df55d9ad304103e23bb31',8,1,5,2,'1970-01-01 06:00:00','2020-02-13 19:56:25'),(746,'a1594f0d098df55d9ad304103e23bb31',8,1,5,3,'1970-01-01 06:00:00','2020-02-13 19:56:27'),(747,'a1594f0d098df55d9ad304103e23bb31',8,1,7,2,'1970-01-01 06:00:00','2020-02-13 19:56:30'),(748,'69a94c5600f4bc011bc951165d0f9d64',8,1,1,1,'1970-01-01 06:00:00','2020-02-17 18:01:09'),(749,'69a94c5600f4bc011bc951165d0f9d64',8,1,3,2,'1970-01-01 06:00:00','2020-02-17 18:01:11'),(750,'69a94c5600f4bc011bc951165d0f9d64',8,1,5,3,'1970-01-01 06:00:00','2020-02-17 18:01:13'),(751,'69a94c5600f4bc011bc951165d0f9d64',8,1,7,2,'1970-01-01 06:00:00','2020-02-17 18:01:14'),(752,'69a94c5600f4bc011bc951165d0f9d64',8,1,5,2,'1970-01-01 06:00:00','2020-02-17 18:01:16'),(753,'69a94c5600f4bc011bc951165d0f9d64',8,1,5,2,'1970-01-01 06:00:00','2020-02-17 18:01:18'),(754,'69a94c5600f4bc011bc951165d0f9d64',8,1,5,3,'1970-01-01 06:00:00','2020-02-17 18:01:22'),(755,'69a94c5600f4bc011bc951165d0f9d64',8,1,7,2,'1970-01-01 06:00:00','2020-02-17 18:01:23'),(756,'69a94c5600f4bc011bc951165d0f9d64',8,1,5,2,'1970-01-01 06:00:00','2020-02-17 18:01:25'),(757,'69a94c5600f4bc011bc951165d0f9d64',8,1,5,2,'1970-01-01 06:00:00','2020-02-17 18:01:27'),(758,'69a94c5600f4bc011bc951165d0f9d64',8,1,6,2,'1970-01-01 06:00:00','2020-02-17 18:01:33'),(759,'69a94c5600f4bc011bc951165d0f9d64',8,1,5,2,'1970-01-01 06:00:00','2020-02-17 18:01:36'),(760,'69a94c5600f4bc011bc951165d0f9d64',8,1,5,2,'1970-01-01 06:00:00','2020-02-17 18:01:42'),(761,'69a94c5600f4bc011bc951165d0f9d64',8,1,5,2,'1970-01-01 06:00:00','2020-02-17 18:01:44'),(762,'69a94c5600f4bc011bc951165d0f9d64',8,1,5,2,'1970-01-01 06:00:00','2020-02-17 18:01:49'),(763,'69a94c5600f4bc011bc951165d0f9d64',8,1,5,2,'1970-01-01 06:00:00','2020-02-17 18:01:56'),(764,'69a94c5600f4bc011bc951165d0f9d64',8,1,5,2,'1970-01-01 06:00:00','2020-02-17 18:02:02'),(765,'69a94c5600f4bc011bc951165d0f9d64',8,1,5,2,'1970-01-01 06:00:00','2020-02-17 18:02:04'),(766,'69a94c5600f4bc011bc951165d0f9d64',8,1,5,2,'1970-01-01 06:00:00','2020-02-17 18:02:05'),(767,'69a94c5600f4bc011bc951165d0f9d64',8,1,5,2,'1970-01-01 06:00:00','2020-02-17 18:02:08'),(768,'69a94c5600f4bc011bc951165d0f9d64',8,1,5,2,'1970-01-01 06:00:00','2020-02-17 18:02:10'),(769,'69a94c5600f4bc011bc951165d0f9d64',8,1,5,2,'1970-01-01 06:00:00','2020-02-17 18:02:14'),(770,'69a94c5600f4bc011bc951165d0f9d64',8,1,5,2,'1970-01-01 06:00:00','2020-02-17 18:02:17'),(771,'69a94c5600f4bc011bc951165d0f9d64',8,1,5,2,'1970-01-01 06:00:00','2020-02-17 18:02:20'),(772,'69a94c5600f4bc011bc951165d0f9d64',8,1,5,2,'1970-01-01 06:00:00','2020-02-17 18:02:23'),(773,'69a94c5600f4bc011bc951165d0f9d64',8,1,5,2,'1970-01-01 06:00:00','2020-02-17 18:02:25'),(774,'69a94c5600f4bc011bc951165d0f9d64',8,1,5,3,'1970-01-01 06:00:00','2020-02-17 18:02:28'),(775,'69a94c5600f4bc011bc951165d0f9d64',8,1,2,3,'1970-01-01 06:00:00','2020-02-19 22:45:13'),(776,'2f8890235ebeaf123ec07f1cb7be7640',3,1,1,1,'1970-01-01 06:00:00','2020-02-26 15:40:54'),(777,'2f8890235ebeaf123ec07f1cb7be7640',3,1,3,2,'1970-01-01 06:00:00','2020-02-26 15:41:02'),(778,'2f8890235ebeaf123ec07f1cb7be7640',3,1,5,2,'1970-01-01 06:00:00','2020-02-26 15:41:04'),(779,'2f8890235ebeaf123ec07f1cb7be7640',3,1,5,2,'1970-01-01 06:00:00','2020-02-26 15:41:06'),(780,'2f8890235ebeaf123ec07f1cb7be7640',3,1,5,3,'1970-01-01 06:00:00','2020-02-26 15:41:10'),(781,'bb46e0784413bbd754f5fb12f4f4eed9',8,1,1,1,'1970-01-01 06:00:00','2020-03-04 15:51:37'),(782,'bb46e0784413bbd754f5fb12f4f4eed9',8,1,3,2,'1970-01-01 06:00:00','2020-03-04 15:51:42'),(783,'bb46e0784413bbd754f5fb12f4f4eed9',8,1,6,4,'1970-01-01 06:00:00','2020-03-04 15:52:09'),(784,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,1,1,'1970-01-01 06:00:00','2020-03-17 22:13:32'),(785,'e19542924e1d595b70b2e5a0b0340cb5',2,1,1,1,'1970-01-01 06:00:00','2020-03-17 22:13:44'),(786,'e19542924e1d595b70b2e5a0b0340cb5',2,1,3,2,'1970-01-01 06:00:00','2020-03-17 22:13:47'),(787,'e19542924e1d595b70b2e5a0b0340cb5',2,1,5,2,'1970-01-01 06:00:00','2020-03-17 22:13:53'),(788,'e19542924e1d595b70b2e5a0b0340cb5',2,1,5,2,'1970-01-01 06:00:00','2020-03-17 22:13:59'),(789,'e19542924e1d595b70b2e5a0b0340cb5',2,1,5,3,'1970-01-01 06:00:00','2020-03-17 22:14:05'),(790,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,3,2,'1970-01-01 06:00:00','2020-03-17 22:14:22'),(791,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,5,2,'1970-01-01 06:00:00','2020-03-17 22:14:23'),(792,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,5,2,'1970-01-01 06:00:00','2020-03-17 22:14:24'),(793,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,5,2,'1970-01-01 06:00:00','2020-03-17 22:14:25'),(794,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,6,4,'1970-01-01 06:00:00','2020-03-17 22:14:26'),(795,'e19542924e1d595b70b2e5a0b0340cb5',2,1,2,3,'1970-01-01 06:00:00','2020-03-20 16:42:17'),(796,'e19542924e1d595b70b2e5a0b0340cb5',2,1,2,3,'1970-01-01 06:00:00','2020-03-23 23:35:36'),(797,'e19542924e1d595b70b2e5a0b0340cb5',2,1,2,3,'1970-01-01 06:00:00','2020-03-24 03:24:28'),(798,'e19542924e1d595b70b2e5a0b0340cb5',2,1,2,3,'1970-01-01 06:00:00','2020-03-24 16:37:49'),(799,'e19542924e1d595b70b2e5a0b0340cb5',2,1,2,3,'1970-01-01 06:00:00','2020-03-25 20:01:41'),(800,'e19542924e1d595b70b2e5a0b0340cb5',2,1,2,3,'1970-01-01 06:00:00','2020-03-25 21:31:21'),(801,'a3a9982a155764bef535662efe7f86a2',2,1,1,1,'1970-01-01 06:00:00','2020-03-28 11:32:27'),(802,'e19542924e1d595b70b2e5a0b0340cb5',2,1,2,3,'1970-01-01 06:00:00','2020-04-01 21:20:32'),(803,'e19542924e1d595b70b2e5a0b0340cb5',2,1,2,3,'1970-01-01 06:00:00','2020-04-02 18:14:17'),(804,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,2,4,'1970-01-01 06:00:00','2020-04-20 16:44:37'),(805,'0fa5722c63860268d6ab8de8c3e783b9',2,1,1,1,'1970-01-01 06:00:00','2020-04-20 20:06:42'),(806,'0fa5722c63860268d6ab8de8c3e783b9',2,1,3,2,'1970-01-01 06:00:00','2020-04-20 20:06:50'),(807,'0fa5722c63860268d6ab8de8c3e783b9',2,1,5,2,'1970-01-01 06:00:00','2020-04-20 20:06:53'),(808,'0fa5722c63860268d6ab8de8c3e783b9',2,1,5,2,'1970-01-01 06:00:00','2020-04-20 20:06:55'),(809,'0fa5722c63860268d6ab8de8c3e783b9',2,1,5,2,'1970-01-01 06:00:00','2020-04-20 20:06:57'),(810,'0fa5722c63860268d6ab8de8c3e783b9',2,1,5,3,'1970-01-01 06:00:00','2020-04-20 20:06:59'),(811,'0fa5722c63860268d6ab8de8c3e783b9',2,1,4,4,'1970-01-01 06:00:00','2020-04-20 20:07:00'),(812,'0fa5722c63860268d6ab8de8c3e783b9',2,1,5,4,'1970-01-01 06:00:00','2020-04-20 20:07:02'),(813,'0fa5722c63860268d6ab8de8c3e783b9',2,1,2,4,'1970-01-01 06:00:00','2020-04-20 20:23:53'),(814,'0fa5722c63860268d6ab8de8c3e783b9',2,1,2,4,'1970-01-01 06:00:00','2020-04-20 20:30:13'),(815,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,2,4,'1970-01-01 06:00:00','2020-04-20 21:18:15'),(816,'e19542924e1d595b70b2e5a0b0340cb5',2,1,2,3,'1970-01-01 06:00:00','2020-04-22 15:58:49'),(817,'e19542924e1d595b70b2e5a0b0340cb5',2,1,7,2,'1970-01-01 06:00:00','2020-04-22 16:05:17'),(818,'e19542924e1d595b70b2e5a0b0340cb5',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:05:23'),(819,'e19542924e1d595b70b2e5a0b0340cb5',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:05:25'),(820,'e19542924e1d595b70b2e5a0b0340cb5',2,1,5,3,'1970-01-01 06:00:00','2020-04-22 16:05:27'),(821,'e19542924e1d595b70b2e5a0b0340cb5',2,1,7,2,'1970-01-01 06:00:00','2020-04-22 16:05:30'),(822,'e19542924e1d595b70b2e5a0b0340cb5',2,1,5,3,'1970-01-01 06:00:00','2020-04-22 16:06:23'),(823,'bcc7d2d560f4f63870fdc73d4ae64261',2,1,1,1,'1970-01-01 06:00:00','2020-04-22 16:07:33'),(824,'bcc7d2d560f4f63870fdc73d4ae64261',2,1,3,2,'1970-01-01 06:00:00','2020-04-22 16:10:32'),(825,'bcc7d2d560f4f63870fdc73d4ae64261',2,1,5,3,'1970-01-01 06:00:00','2020-04-22 16:10:32'),(826,'bcc7d2d560f4f63870fdc73d4ae64261',2,1,4,4,'1970-01-01 06:00:00','2020-04-22 16:10:34'),(827,'bcc7d2d560f4f63870fdc73d4ae64261',2,1,3,2,'1970-01-01 06:00:00','2020-04-22 16:10:36'),(828,'bcc7d2d560f4f63870fdc73d4ae64261',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:10:37'),(829,'bcc7d2d560f4f63870fdc73d4ae64261',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:10:38'),(830,'bcc7d2d560f4f63870fdc73d4ae64261',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:10:38'),(831,'bcc7d2d560f4f63870fdc73d4ae64261',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:10:40'),(832,'bcc7d2d560f4f63870fdc73d4ae64261',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:10:40'),(833,'bcc7d2d560f4f63870fdc73d4ae64261',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:10:41'),(834,'bcc7d2d560f4f63870fdc73d4ae64261',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:10:42'),(835,'bcc7d2d560f4f63870fdc73d4ae64261',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:10:43'),(836,'bcc7d2d560f4f63870fdc73d4ae64261',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:10:44'),(837,'bcc7d2d560f4f63870fdc73d4ae64261',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:10:45'),(838,'bcc7d2d560f4f63870fdc73d4ae64261',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:10:46'),(839,'bcc7d2d560f4f63870fdc73d4ae64261',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:10:48'),(840,'bcc7d2d560f4f63870fdc73d4ae64261',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:10:50'),(841,'bcc7d2d560f4f63870fdc73d4ae64261',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:10:50'),(842,'bcc7d2d560f4f63870fdc73d4ae64261',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:10:53'),(843,'bcc7d2d560f4f63870fdc73d4ae64261',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:10:54'),(844,'bcc7d2d560f4f63870fdc73d4ae64261',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:10:55'),(845,'bcc7d2d560f4f63870fdc73d4ae64261',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:10:56'),(846,'bcc7d2d560f4f63870fdc73d4ae64261',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:10:58'),(847,'bcc7d2d560f4f63870fdc73d4ae64261',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:10:59'),(848,'bcc7d2d560f4f63870fdc73d4ae64261',2,1,5,3,'1970-01-01 06:00:00','2020-04-22 16:11:00'),(849,'bcc7d2d560f4f63870fdc73d4ae64261',2,1,4,4,'1970-01-01 06:00:00','2020-04-22 16:11:02'),(850,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,2,4,'1970-01-01 06:00:00','2020-04-22 16:13:45'),(851,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,3,2,'1970-01-01 06:00:00','2020-04-22 16:13:59'),(852,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,5,3,'1970-01-01 06:00:00','2020-04-22 16:14:53'),(853,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,4,4,'1970-01-01 06:00:00','2020-04-22 16:15:08'),(854,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,5,4,'1970-01-01 06:00:00','2020-04-22 16:16:06'),(855,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,5,4,'1970-01-01 06:00:00','2020-04-22 16:16:10'),(856,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,5,4,'1970-01-01 06:00:00','2020-04-22 16:16:11'),(857,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,5,4,'1970-01-01 06:00:00','2020-04-22 16:16:13'),(858,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,5,4,'1970-01-01 06:00:00','2020-04-22 16:16:13'),(859,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,5,4,'1970-01-01 06:00:00','2020-04-22 16:16:18'),(860,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,5,4,'1970-01-01 06:00:00','2020-04-22 16:16:24'),(861,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,6,2,'1970-01-01 06:00:00','2020-04-22 16:17:41'),(862,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:17:44'),(863,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:17:44'),(864,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:17:46'),(865,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:17:57'),(866,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:18:00'),(867,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,6,2,'1970-01-01 06:00:00','2020-04-22 16:18:47'),(868,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,6,4,'1970-01-01 06:00:00','2020-04-22 16:18:48'),(869,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,2,4,'1970-01-01 06:00:00','2020-04-22 16:56:10'),(870,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,2,4,'1970-01-01 06:00:00','2020-04-22 16:56:13'),(871,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,3,2,'1970-01-01 06:00:00','2020-04-22 16:56:21'),(872,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:56:22'),(873,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:56:23'),(874,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,5,2,'1970-01-01 06:00:00','2020-04-22 16:56:26'),(875,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,6,2,'1970-01-01 06:00:00','2020-04-22 16:56:27'),(876,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,6,4,'1970-01-01 06:00:00','2020-04-22 16:56:30'),(877,'e19542924e1d595b70b2e5a0b0340cb5',2,1,2,3,'1970-01-01 06:00:00','2020-04-23 18:39:16'),(878,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,2,4,'1970-01-01 06:00:00','2020-06-19 19:08:53'),(879,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,3,2,'1970-01-01 06:00:00','2020-06-19 19:12:35'),(880,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,5,2,'1970-01-01 06:00:00','2020-06-19 19:12:35'),(881,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,1,1,'1970-01-01 06:00:00','2020-06-19 20:07:48'),(882,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,3,2,'1970-01-01 06:00:00','2020-06-19 20:07:54'),(883,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,2,1,'1970-01-01 06:00:00','2020-06-19 20:08:13'),(884,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,3,2,'1970-01-01 06:00:00','2020-06-19 20:08:15'),(885,'cf50cb4ef4b8ef031a6e049f1154adba',2,1,2,2,'1970-01-01 06:00:00','2020-06-19 20:08:45'),(886,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,2,1,'1970-01-01 06:00:00','2020-06-19 20:12:20'),(887,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,3,2,'1970-01-01 06:00:00','2020-06-19 20:12:22'),(888,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,4,4,'1970-01-01 06:00:00','2020-06-19 20:12:30'),(889,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,2,4,'1970-01-01 06:00:00','2020-06-19 20:12:48'),(890,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,5,4,'1970-01-01 06:00:00','2020-06-19 20:13:06'),(891,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,5,4,'1970-01-01 06:00:00','2020-06-19 20:13:07'),(892,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,5,4,'1970-01-01 06:00:00','2020-06-19 20:13:07'),(893,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,5,4,'1970-01-01 06:00:00','2020-06-19 20:13:08'),(894,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,5,4,'1970-01-01 06:00:00','2020-06-19 20:13:09'),(895,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,5,4,'1970-01-01 06:00:00','2020-06-19 20:13:09'),(896,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,2,4,'1970-01-01 06:00:00','2020-06-19 20:14:14'),(897,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,3,2,'1970-01-01 06:00:00','2020-06-19 20:14:19'),(898,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,5,2,'1970-01-01 06:00:00','2020-06-19 20:14:21'),(899,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,5,3,'1970-01-01 06:00:00','2020-06-19 20:14:23'),(900,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,7,2,'1970-01-01 06:00:00','2020-06-19 20:14:24'),(901,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,5,3,'1970-01-01 06:00:00','2020-06-19 20:14:26'),(902,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,7,2,'1970-01-01 06:00:00','2020-06-19 20:14:28'),(903,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,5,2,'1970-01-01 06:00:00','2020-06-19 20:14:29'),(904,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,2,2,'1970-01-01 06:00:00','2020-06-19 20:15:01'),(905,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,5,2,'1970-01-01 06:00:00','2020-06-19 20:15:02'),(906,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,5,3,'1970-01-01 06:00:00','2020-06-19 20:15:04'),(907,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,7,2,'1970-01-01 06:00:00','2020-06-19 20:15:05'),(908,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,5,2,'1970-01-01 06:00:00','2020-06-19 20:15:09'),(909,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,5,3,'1970-01-01 06:00:00','2020-06-19 20:15:10'),(910,'cf50cb4ef4b8ef031a6e049f1154adba',11,6,2,3,'1970-01-01 06:00:00','2020-06-19 20:46:12'),(911,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,2,1,'1970-01-01 06:00:00','2020-06-22 17:46:38'),(912,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,3,2,'1970-01-01 06:00:00','2020-06-22 17:46:42'),(913,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,3,'1970-01-01 06:00:00','2020-06-22 17:48:32'),(914,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,7,2,'1970-01-01 06:00:00','2020-06-22 17:48:36'),(915,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,3,'1970-01-01 06:00:00','2020-06-22 17:48:40'),(916,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,7,2,'1970-01-01 06:00:00','2020-06-22 17:48:42'),(917,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 17:48:45'),(918,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 17:48:46'),(919,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 17:48:48'),(920,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,2,2,'1970-01-01 06:00:00','2020-06-22 17:55:52'),(921,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,6,2,'1970-01-01 06:00:00','2020-06-22 17:55:57'),(922,'af3f2414a74035dd619dc55f9c8ac023',2,1,1,1,'1970-01-01 06:00:00','2020-06-22 18:11:09'),(923,'af3f2414a74035dd619dc55f9c8ac023',2,1,3,2,'1970-01-01 06:00:00','2020-06-22 18:11:11'),(924,'af3f2414a74035dd619dc55f9c8ac023',10,1,2,2,'1970-01-01 06:00:00','2020-06-22 19:44:18'),(925,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:44:21'),(926,'65ef6927d53c9ccce79e5fe1618c29e1',10,1,2,2,'1970-01-01 06:00:00','2020-06-22 19:44:35'),(927,'af3f2414a74035dd619dc55f9c8ac023',10,1,2,2,'1970-01-01 06:00:00','2020-06-22 19:45:02'),(928,'65ef6927d53c9ccce79e5fe1618c29e1',10,1,2,2,'1970-01-01 06:00:00','2020-06-22 19:45:05'),(929,'af3f2414a74035dd619dc55f9c8ac023',10,1,6,2,'1970-01-01 06:00:00','2020-06-22 19:45:09'),(930,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:45:09'),(931,'65ef6927d53c9ccce79e5fe1618c29e1',10,1,2,2,'1970-01-01 06:00:00','2020-06-22 19:45:12'),(932,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:16'),(933,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:16'),(934,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:17'),(935,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:19'),(936,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:19'),(937,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:21'),(938,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:21'),(939,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:21'),(940,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:21'),(941,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:22'),(942,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:23'),(943,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:23'),(944,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:24'),(945,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:24'),(946,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:25'),(947,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:26'),(948,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:27'),(949,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:27'),(950,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:27'),(951,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:28'),(952,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:29'),(953,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,3,'1970-01-01 06:00:00','2020-06-22 19:47:29'),(954,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:29'),(955,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:33'),(956,'af3f2414a74035dd619dc55f9c8ac023',10,1,4,4,'1970-01-01 06:00:00','2020-06-22 19:47:35'),(957,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:35'),(958,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:37'),(959,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:39'),(960,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:42'),(961,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:43'),(962,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:45'),(963,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,3,'1970-01-01 06:00:00','2020-06-22 19:47:46'),(964,'af3f2414a74035dd619dc55f9c8ac023',10,1,3,2,'1970-01-01 06:00:00','2020-06-22 19:47:50'),(965,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:52'),(966,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:52'),(967,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:53'),(968,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:54'),(969,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:54'),(970,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:55'),(971,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:56'),(972,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:57'),(973,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:58'),(974,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:47:59'),(975,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:48:01'),(976,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:48:02'),(977,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:48:03'),(978,'af3f2414a74035dd619dc55f9c8ac023',10,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:48:03'),(979,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,7,2,'1970-01-01 06:00:00','2020-06-22 19:48:03'),(980,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,3,'1970-01-01 06:00:00','2020-06-22 19:48:05'),(981,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,7,2,'1970-01-01 06:00:00','2020-06-22 19:48:15'),(982,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,3,'1970-01-01 06:00:00','2020-06-22 19:48:17'),(983,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,7,2,'1970-01-01 06:00:00','2020-06-22 19:48:20'),(984,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 19:48:22'),(985,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,3,'1970-01-01 06:00:00','2020-06-22 19:48:24'),(986,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,7,2,'1970-01-01 06:00:00','2020-06-22 19:48:29'),(987,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 20:34:01'),(988,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 20:34:14'),(989,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 20:34:26'),(990,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 20:34:37'),(991,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 20:34:44'),(992,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 20:35:18'),(993,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 20:35:30'),(994,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 20:35:39'),(995,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 20:35:45'),(996,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 20:35:59'),(997,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 20:36:08'),(998,'65ef6927d53c9ccce79e5fe1618c29e1',12,9,1,1,'1970-01-01 06:00:00','2020-06-22 21:19:35'),(999,'65ef6927d53c9ccce79e5fe1618c29e1',12,9,3,2,'1970-01-01 06:00:00','2020-06-22 21:19:42'),(1000,'65ef6927d53c9ccce79e5fe1618c29e1',12,9,5,2,'1970-01-01 06:00:00','2020-06-22 21:20:01'),(1001,'65ef6927d53c9ccce79e5fe1618c29e1',12,9,2,2,'1970-01-01 06:00:00','2020-06-22 21:20:18'),(1002,'65ef6927d53c9ccce79e5fe1618c29e1',12,9,2,2,'1970-01-01 06:00:00','2020-06-22 21:20:29'),(1003,'65ef6927d53c9ccce79e5fe1618c29e1',12,9,6,4,'1970-01-01 06:00:00','2020-06-22 21:20:31'),(1004,'65ef6927d53c9ccce79e5fe1618c29e1',12,9,2,4,'1970-01-01 06:00:00','2020-06-22 21:20:58'),(1005,'65ef6927d53c9ccce79e5fe1618c29e1',12,9,3,2,'1970-01-01 06:00:00','2020-06-22 21:21:02'),(1006,'65ef6927d53c9ccce79e5fe1618c29e1',12,9,5,2,'1970-01-01 06:00:00','2020-06-22 21:21:07'),(1007,'65ef6927d53c9ccce79e5fe1618c29e1',12,9,5,3,'1970-01-01 06:00:00','2020-06-22 21:21:09'),(1008,'65ef6927d53c9ccce79e5fe1618c29e1',12,9,7,2,'1970-01-01 06:00:00','2020-06-22 21:21:12'),(1009,'65ef6927d53c9ccce79e5fe1618c29e1',12,9,5,3,'1970-01-01 06:00:00','2020-06-22 21:21:13'),(1010,'65ef6927d53c9ccce79e5fe1618c29e1',12,9,7,2,'1970-01-01 06:00:00','2020-06-22 21:21:16'),(1011,'af3f2414a74035dd619dc55f9c8ac023',12,9,1,1,'1970-01-01 06:00:00','2020-06-22 21:25:13'),(1012,'af3f2414a74035dd619dc55f9c8ac023',12,9,3,2,'1970-01-01 06:00:00','2020-06-22 21:25:14'),(1013,'af3f2414a74035dd619dc55f9c8ac023',12,9,2,1,'1970-01-01 06:00:00','2020-06-22 21:26:44'),(1014,'af3f2414a74035dd619dc55f9c8ac023',12,9,3,2,'1970-01-01 06:00:00','2020-06-22 21:26:50'),(1015,'af3f2414a74035dd619dc55f9c8ac023',12,9,2,2,'1970-01-01 06:00:00','2020-06-22 21:27:35'),(1016,'af3f2414a74035dd619dc55f9c8ac023',12,9,5,2,'1970-01-01 06:00:00','2020-06-22 21:27:47'),(1017,'af3f2414a74035dd619dc55f9c8ac023',12,9,5,3,'1970-01-01 06:00:00','2020-06-22 21:27:49'),(1018,'65ef6927d53c9ccce79e5fe1618c29e1',12,9,5,2,'1970-01-01 06:00:00','2020-06-22 21:27:55'),(1019,'af3f2414a74035dd619dc55f9c8ac023',12,9,7,2,'1970-01-01 06:00:00','2020-06-22 21:29:29'),(1020,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,1,1,'1970-01-01 06:00:00','2020-06-22 21:40:09'),(1021,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,1,'1970-01-01 06:00:00','2020-06-22 21:40:16'),(1022,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,1,'1970-01-01 06:00:00','2020-06-22 21:40:18'),(1023,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,1,'1970-01-01 06:00:00','2020-06-22 21:40:19'),(1024,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,3,2,'1970-01-01 06:00:00','2020-06-22 21:40:20'),(1025,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,2,'1970-01-01 06:00:00','2020-06-22 21:40:24'),(1026,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,3,'1970-01-01 06:00:00','2020-06-22 21:40:38'),(1027,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,7,2,'1970-01-01 06:00:00','2020-06-22 21:40:40'),(1028,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,3,'1970-01-01 06:00:00','2020-06-22 21:40:41'),(1029,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,7,2,'1970-01-01 06:00:00','2020-06-22 21:40:44'),(1030,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,3,'1970-01-01 06:00:00','2020-06-22 21:40:45'),(1031,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,7,2,'1970-01-01 06:00:00','2020-06-22 21:40:47'),(1032,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,2,2,'1970-01-01 06:00:00','2020-06-22 21:41:28'),(1033,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,2,'1970-01-01 06:00:00','2020-06-22 21:41:58'),(1034,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,2,'1970-01-01 06:00:00','2020-06-22 21:42:02'),(1035,'65ef6927d53c9ccce79e5fe1618c29e1',15,11,1,1,'1970-01-01 06:00:00','2020-06-22 21:45:09'),(1036,'65ef6927d53c9ccce79e5fe1618c29e1',16,11,2,1,'1970-01-01 06:00:00','2020-06-22 21:45:25'),(1037,'65ef6927d53c9ccce79e5fe1618c29e1',15,11,3,2,'1970-01-01 06:00:00','2020-06-22 21:45:42'),(1038,'65ef6927d53c9ccce79e5fe1618c29e1',16,11,2,2,'1970-01-01 06:00:00','2020-06-22 21:45:51'),(1039,'65ef6927d53c9ccce79e5fe1618c29e1',16,11,2,2,'1970-01-01 06:00:00','2020-06-22 21:47:00'),(1040,'65ef6927d53c9ccce79e5fe1618c29e1',17,12,1,1,'1970-01-01 06:00:00','2020-06-22 21:48:48'),(1041,'65ef6927d53c9ccce79e5fe1618c29e1',18,12,2,1,'1970-01-01 06:00:00','2020-06-22 21:49:22'),(1042,'65ef6927d53c9ccce79e5fe1618c29e1',18,12,2,1,'1970-01-01 06:00:00','2020-06-22 21:49:26'),(1043,'65ef6927d53c9ccce79e5fe1618c29e1',18,12,3,2,'1970-01-01 06:00:00','2020-06-22 21:49:36'),(1044,'65ef6927d53c9ccce79e5fe1618c29e1',18,12,2,2,'1970-01-01 06:00:00','2020-06-22 21:49:41'),(1045,'65ef6927d53c9ccce79e5fe1618c29e1',17,12,2,2,'1970-01-01 06:00:00','2020-06-22 21:49:54'),(1046,'65ef6927d53c9ccce79e5fe1618c29e1',17,12,2,2,'1970-01-01 06:00:00','2020-06-22 21:50:03'),(1047,'65ef6927d53c9ccce79e5fe1618c29e1',17,12,2,1,'1970-01-01 06:00:00','2020-06-22 21:50:18'),(1048,'65ef6927d53c9ccce79e5fe1618c29e1',17,12,3,2,'1970-01-01 06:00:00','2020-06-22 21:50:22'),(1049,'65ef6927d53c9ccce79e5fe1618c29e1',17,12,2,2,'1970-01-01 06:00:00','2020-06-22 21:50:26'),(1050,'af3f2414a74035dd619dc55f9c8ac023',17,12,1,1,'1970-01-01 06:00:00','2020-06-22 21:51:04'),(1051,'af3f2414a74035dd619dc55f9c8ac023',17,12,3,2,'1970-01-01 06:00:00','2020-06-22 21:51:05'),(1052,'af3f2414a74035dd619dc55f9c8ac023',17,12,2,1,'1970-01-01 06:00:00','2020-06-22 21:51:10'),(1053,'af3f2414a74035dd619dc55f9c8ac023',17,12,2,1,'1970-01-01 06:00:00','2020-06-22 21:51:11'),(1054,'af3f2414a74035dd619dc55f9c8ac023',17,12,2,1,'1970-01-01 06:00:00','2020-06-22 21:51:11'),(1055,'af3f2414a74035dd619dc55f9c8ac023',17,12,2,1,'1970-01-01 06:00:00','2020-06-22 21:51:11'),(1056,'af3f2414a74035dd619dc55f9c8ac023',15,11,1,1,'1970-01-01 06:00:00','2020-06-22 21:51:18'),(1057,'af3f2414a74035dd619dc55f9c8ac023',15,11,3,2,'1970-01-01 06:00:00','2020-06-22 21:51:20'),(1058,'af3f2414a74035dd619dc55f9c8ac023',15,11,2,2,'1970-01-01 06:00:00','2020-06-22 21:51:21'),(1059,'65ef6927d53c9ccce79e5fe1618c29e1',19,13,1,1,'1970-01-01 06:00:00','2020-06-22 21:52:52'),(1060,'af3f2414a74035dd619dc55f9c8ac023',19,13,1,1,'1970-01-01 06:00:00','2020-06-22 21:53:05'),(1061,'65ef6927d53c9ccce79e5fe1618c29e1',20,13,2,1,'1970-01-01 06:00:00','2020-06-22 21:53:19'),(1062,'65ef6927d53c9ccce79e5fe1618c29e1',20,13,3,2,'1970-01-01 06:00:00','2020-06-22 21:53:30'),(1063,'65ef6927d53c9ccce79e5fe1618c29e1',19,13,2,2,'1970-01-01 06:00:00','2020-06-22 21:54:00'),(1064,'65ef6927d53c9ccce79e5fe1618c29e1',20,13,2,2,'1970-01-01 06:00:00','2020-06-22 21:54:15'),(1065,'af3f2414a74035dd619dc55f9c8ac023',19,13,2,1,'1970-01-01 06:00:00','2020-06-22 21:54:23'),(1066,'af3f2414a74035dd619dc55f9c8ac023',19,13,3,2,'1970-01-01 06:00:00','2020-06-22 21:54:28'),(1067,'af3f2414a74035dd619dc55f9c8ac023',19,13,2,2,'1970-01-01 06:00:00','2020-06-22 21:54:33'),(1068,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,1,'1970-01-01 06:00:00','2020-06-22 21:57:41'),(1069,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,3,2,'1970-01-01 06:00:00','2020-06-22 21:57:51'),(1070,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,2,'1970-01-01 06:00:00','2020-06-22 21:57:54'),(1071,'af3f2414a74035dd619dc55f9c8ac023',13,7,1,1,'1970-01-01 06:00:00','2020-06-22 21:58:08'),(1072,'af3f2414a74035dd619dc55f9c8ac023',14,7,2,1,'1970-01-01 06:00:00','2020-06-22 21:58:25'),(1073,'af3f2414a74035dd619dc55f9c8ac023',14,7,3,2,'1970-01-01 06:00:00','2020-06-22 21:58:26'),(1074,'af3f2414a74035dd619dc55f9c8ac023',14,7,2,2,'1970-01-01 06:00:00','2020-06-22 21:58:29'),(1075,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,2,'1970-01-01 06:00:00','2020-06-22 22:01:20'),(1076,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,3,'1970-01-01 06:00:00','2020-06-22 22:01:24'),(1077,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,4,4,'1970-01-01 06:00:00','2020-06-22 22:01:27'),(1078,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,4,'1970-01-01 06:00:00','2020-06-22 22:02:20'),(1079,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,6,2,'1970-01-01 06:00:00','2020-06-22 22:03:07'),(1080,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,6,4,'1970-01-01 06:00:00','2020-06-22 22:03:09'),(1081,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,6,2,'1970-01-01 06:00:00','2020-06-22 22:03:14'),(1082,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,6,3,'1970-01-01 06:00:00','2020-06-22 22:03:17'),(1083,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,6,2,'1970-01-01 06:00:00','2020-06-22 22:03:19'),(1084,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,6,4,'1970-01-01 06:00:00','2020-06-22 22:03:20'),(1085,'af3f2414a74035dd619dc55f9c8ac023',2,1,2,2,'1970-01-01 06:00:00','2020-06-22 22:03:31'),(1086,'af3f2414a74035dd619dc55f9c8ac023',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 22:03:40'),(1087,'af3f2414a74035dd619dc55f9c8ac023',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 22:03:41'),(1088,'af3f2414a74035dd619dc55f9c8ac023',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 22:03:42'),(1089,'af3f2414a74035dd619dc55f9c8ac023',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 22:03:43'),(1090,'af3f2414a74035dd619dc55f9c8ac023',2,1,5,2,'1970-01-01 06:00:00','2020-06-22 22:03:44'),(1091,'af3f2414a74035dd619dc55f9c8ac023',2,1,5,3,'1970-01-01 06:00:00','2020-06-22 22:03:45'),(1092,'2eb5db075f2fd995795306af5bcd7b89',2,1,1,1,'1970-01-01 06:00:00','2020-06-22 22:03:53'),(1093,'2eb5db075f2fd995795306af5bcd7b89',2,1,3,2,'1970-01-01 06:00:00','2020-06-22 22:03:57'),(1094,'6521a8d43d8f7ac54d2a7d1915cd6bd5',2,1,1,1,'1970-01-01 06:00:00','2020-06-22 22:04:22'),(1095,'6521a8d43d8f7ac54d2a7d1915cd6bd5',2,1,3,2,'1970-01-01 06:00:00','2020-06-22 22:04:26'),(1096,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,4,'1970-01-01 06:00:00','2020-06-22 22:07:51'),(1097,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,3,2,'1970-01-01 06:00:00','2020-06-22 22:07:54'),(1098,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,2,'1970-01-01 06:00:00','2020-06-22 22:07:56'),(1099,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,2,'1970-01-01 06:00:00','2020-06-22 22:08:10'),(1100,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,2,'1970-01-01 06:00:00','2020-06-22 22:08:24'),(1101,'af3f2414a74035dd619dc55f9c8ac023',14,7,2,2,'1970-01-01 06:00:00','2020-06-22 22:20:22'),(1102,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,2,'1970-01-01 06:00:00','2020-06-23 10:34:52'),(1103,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,2,'1970-01-01 06:00:00','2020-06-23 10:39:03'),(1104,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,2,'1970-01-01 06:00:00','2020-06-23 10:42:52'),(1105,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,2,'1970-01-01 06:00:00','2020-06-23 10:43:00'),(1106,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,2,'1970-01-01 06:00:00','2020-06-23 10:45:06'),(1107,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,3,'1970-01-01 06:00:00','2020-06-23 10:45:12'),(1108,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,4,4,'1970-01-01 06:00:00','2020-06-23 10:45:13'),(1109,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,3,2,'1970-01-01 06:00:00','2020-06-23 10:45:15'),(1110,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,3,'1970-01-01 06:00:00','2020-06-23 10:45:23'),(1111,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,4,4,'1970-01-01 06:00:00','2020-06-23 10:45:25'),(1112,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,3,2,'1970-01-01 06:00:00','2020-06-23 10:45:27'),(1113,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,3,'1970-01-01 06:00:00','2020-06-23 10:45:27'),(1114,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,4,4,'1970-01-01 06:00:00','2020-06-23 10:45:29'),(1115,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,3,2,'1970-01-01 06:00:00','2020-06-23 10:45:56'),(1116,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,2,'1970-01-01 06:00:00','2020-06-23 10:51:05'),(1117,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,3,'1970-01-01 06:00:00','2020-06-23 10:51:08'),(1118,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,4,4,'1970-01-01 06:00:00','2020-06-23 10:51:10'),(1119,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,3,2,'1970-01-01 06:00:00','2020-06-23 10:51:12'),(1120,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 10:51:15'),(1121,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,3,'1970-01-01 06:00:00','2020-06-23 10:51:20'),(1122,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,7,2,'1970-01-01 06:00:00','2020-06-23 10:51:22'),(1123,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,2,'1970-01-01 06:00:00','2020-06-23 11:00:37'),(1124,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,2,'1970-01-01 06:00:00','2020-06-23 11:02:22'),(1125,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,2,'1970-01-01 06:00:00','2020-06-23 12:10:39'),(1126,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,3,'1970-01-01 06:00:00','2020-06-23 12:10:42'),(1127,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,4,4,'1970-01-01 06:00:00','2020-06-23 12:10:46'),(1128,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,3,2,'1970-01-01 06:00:00','2020-06-23 12:10:53'),(1129,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:10:56'),(1130,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:10:59'),(1131,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:11:03'),(1132,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:11:05'),(1133,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:11:06'),(1134,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,3,'1970-01-01 06:00:00','2020-06-23 12:11:09'),(1135,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,6,2,'1970-01-01 06:00:00','2020-06-23 12:11:15'),(1136,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,3,'1970-01-01 06:00:00','2020-06-23 12:11:19'),(1137,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,6,2,'1970-01-01 06:00:00','2020-06-23 12:11:22'),(1138,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:11:23'),(1139,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:11:26'),(1140,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:11:29'),(1141,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:11:34'),(1142,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:11:36'),(1143,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:11:41'),(1144,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:11:44'),(1145,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,3,'1970-01-01 06:00:00','2020-06-23 12:11:55'),(1146,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,6,2,'1970-01-01 06:00:00','2020-06-23 12:12:00'),(1147,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:12:02'),(1148,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,3,'1970-01-01 06:00:00','2020-06-23 12:12:07'),(1149,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,6,2,'1970-01-01 06:00:00','2020-06-23 12:12:11'),(1150,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:12:14'),(1151,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,3,'1970-01-01 06:00:00','2020-06-23 12:12:16'),(1152,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,7,2,'1970-01-01 06:00:00','2020-06-23 12:12:23'),(1153,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:12:26'),(1154,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,3,'1970-01-01 06:00:00','2020-06-23 12:12:27'),(1155,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,4,4,'1970-01-01 06:00:00','2020-06-23 12:12:29'),(1156,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,3,2,'1970-01-01 06:00:00','2020-06-23 12:15:02'),(1157,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,2,'1970-01-01 06:00:00','2020-06-23 12:15:06'),(1158,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,3,'1970-01-01 06:00:00','2020-06-23 12:15:11'),(1159,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,4,4,'1970-01-01 06:00:00','2020-06-23 12:15:12'),(1160,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,3,2,'1970-01-01 06:00:00','2020-06-23 12:15:15'),(1161,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:15:19'),(1162,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:15:22'),(1163,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,3,'1970-01-01 06:00:00','2020-06-23 12:15:24'),(1164,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,7,2,'1970-01-01 06:00:00','2020-06-23 12:15:28'),(1165,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:15:31'),(1166,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:15:33'),(1167,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:15:35'),(1168,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:15:38'),(1169,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:15:39'),(1170,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:15:41'),(1171,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,3,'1970-01-01 06:00:00','2020-06-23 12:15:46'),(1172,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,6,2,'1970-01-01 06:00:00','2020-06-23 12:15:50'),(1173,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:16:33'),(1174,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:16:35'),(1175,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:16:37'),(1176,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:16:45'),(1177,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:16:48'),(1178,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 12:16:50'),(1179,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,3,'1970-01-01 06:00:00','2020-06-23 12:17:03'),(1180,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,3,'1970-01-01 06:00:00','2020-06-23 12:17:42'),(1181,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,7,2,'1970-01-01 06:00:00','2020-06-23 12:17:45'),(1182,'65ef6927d53c9ccce79e5fe1618c29e1',20,13,2,2,'1970-01-01 06:00:00','2020-06-23 12:19:20'),(1183,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,2,2,'1970-01-01 06:00:00','2020-06-23 12:19:39'),(1184,'af3f2414a74035dd619dc55f9c8ac023',14,7,2,2,'1970-01-01 06:00:00','2020-06-23 13:53:49'),(1185,'2eb5db075f2fd995795306af5bcd7b89',14,7,1,1,'1970-01-01 06:00:00','2020-06-23 13:53:59'),(1186,'2eb5db075f2fd995795306af5bcd7b89',14,7,3,2,'1970-01-01 06:00:00','2020-06-23 13:54:02'),(1187,'2eb5db075f2fd995795306af5bcd7b89',14,7,2,2,'1970-01-01 06:00:00','2020-06-23 13:54:03'),(1188,'2eb5db075f2fd995795306af5bcd7b89',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 13:54:05'),(1189,'2eb5db075f2fd995795306af5bcd7b89',14,7,7,2,'1970-01-01 06:00:00','2020-06-23 13:54:10'),(1190,'2eb5db075f2fd995795306af5bcd7b89',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 13:54:11'),(1191,'2eb5db075f2fd995795306af5bcd7b89',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 13:54:12'),(1192,'2eb5db075f2fd995795306af5bcd7b89',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 13:54:13'),(1193,'2eb5db075f2fd995795306af5bcd7b89',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 13:54:14'),(1194,'2eb5db075f2fd995795306af5bcd7b89',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 13:54:15'),(1195,'2eb5db075f2fd995795306af5bcd7b89',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 13:54:16'),(1196,'2eb5db075f2fd995795306af5bcd7b89',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 13:54:17'),(1197,'2eb5db075f2fd995795306af5bcd7b89',14,7,7,2,'1970-01-01 06:00:00','2020-06-23 13:54:21'),(1198,'af3f2414a74035dd619dc55f9c8ac023',18,12,2,1,'1970-01-01 06:00:00','2020-06-23 13:57:58'),(1199,'af3f2414a74035dd619dc55f9c8ac023',18,12,3,2,'1970-01-01 06:00:00','2020-06-23 13:58:00'),(1200,'af3f2414a74035dd619dc55f9c8ac023',18,12,2,2,'1970-01-01 06:00:00','2020-06-23 13:58:02'),(1201,'af3f2414a74035dd619dc55f9c8ac023',16,11,2,2,'1970-01-01 06:00:00','2020-06-23 13:58:12'),(1202,'af3f2414a74035dd619dc55f9c8ac023',21,9,2,2,'1970-01-01 06:00:00','2020-06-23 14:02:46'),(1203,'c15d4ffc8bbe071013377f990bf2d6bd',21,9,1,1,'1970-01-01 06:00:00','2020-06-23 14:02:54'),(1204,'c15d4ffc8bbe071013377f990bf2d6bd',21,9,2,1,'1970-01-01 06:00:00','2020-06-23 14:04:10'),(1205,'c15d4ffc8bbe071013377f990bf2d6bd',21,9,2,1,'1970-01-01 06:00:00','2020-06-23 14:04:11'),(1206,'f91994e7c0313632d802696ebc3b2f30',21,9,1,1,'1970-01-01 06:00:00','2020-06-23 14:04:19'),(1207,'af3f2414a74035dd619dc55f9c8ac023',2,1,2,3,'1970-01-01 06:00:00','2020-06-23 14:05:20'),(1208,'f91994e7c0313632d802696ebc3b2f30',21,9,2,1,'1970-01-01 06:00:00','2020-06-23 14:05:35'),(1209,'f91994e7c0313632d802696ebc3b2f30',2,1,1,1,'1970-01-01 06:00:00','2020-06-23 14:06:04'),(1210,'f91994e7c0313632d802696ebc3b2f30',21,9,2,1,'1970-01-01 06:00:00','2020-06-23 14:07:36'),(1211,'f91994e7c0313632d802696ebc3b2f30',21,9,2,1,'1970-01-01 06:00:00','2020-06-23 14:07:38'),(1212,'f91994e7c0313632d802696ebc3b2f30',21,9,2,1,'1970-01-01 06:00:00','2020-06-23 14:07:38'),(1213,'f91994e7c0313632d802696ebc3b2f30',21,9,2,1,'1970-01-01 06:00:00','2020-06-23 14:07:40'),(1214,'f91994e7c0313632d802696ebc3b2f30',21,9,3,2,'1970-01-01 06:00:00','2020-06-23 14:08:01'),(1215,'f91994e7c0313632d802696ebc3b2f30',21,9,2,2,'1970-01-01 06:00:00','2020-06-23 14:08:30'),(1216,'f91994e7c0313632d802696ebc3b2f30',21,9,2,2,'1970-01-01 06:00:00','2020-06-23 14:08:38'),(1217,'f91994e7c0313632d802696ebc3b2f30',21,9,2,2,'1970-01-01 06:00:00','2020-06-23 14:08:43'),(1218,'3cfcf93664b50aeb24d266df2bb8f96a',21,9,1,1,'1970-01-01 06:00:00','2020-06-23 14:09:35'),(1219,'3cfcf93664b50aeb24d266df2bb8f96a',21,9,2,1,'1970-01-01 06:00:00','2020-06-23 14:16:11'),(1220,'3cfcf93664b50aeb24d266df2bb8f96a',21,9,3,2,'1970-01-01 06:00:00','2020-06-23 14:16:14'),(1221,'3cfcf93664b50aeb24d266df2bb8f96a',21,9,2,2,'1970-01-01 06:00:00','2020-06-23 14:16:16'),(1222,'3cfcf93664b50aeb24d266df2bb8f96a',21,9,5,2,'1970-01-01 06:00:00','2020-06-23 14:16:22'),(1223,'3cfcf93664b50aeb24d266df2bb8f96a',21,9,5,3,'1970-01-01 06:00:00','2020-06-23 14:16:23'),(1224,'3cfcf93664b50aeb24d266df2bb8f96a',21,9,4,4,'1970-01-01 06:00:00','2020-06-23 14:16:24'),(1225,'3cfcf93664b50aeb24d266df2bb8f96a',14,7,1,1,'1970-01-01 06:00:00','2020-06-23 14:17:23'),(1226,'3cfcf93664b50aeb24d266df2bb8f96a',14,7,2,1,'1970-01-01 06:00:00','2020-06-23 14:17:26'),(1227,'3cfcf93664b50aeb24d266df2bb8f96a',14,7,3,2,'1970-01-01 06:00:00','2020-06-23 14:17:28'),(1228,'3cfcf93664b50aeb24d266df2bb8f96a',14,7,2,2,'1970-01-01 06:00:00','2020-06-23 14:17:29'),(1229,'3cfcf93664b50aeb24d266df2bb8f96a',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 14:17:36'),(1230,'3cfcf93664b50aeb24d266df2bb8f96a',14,7,7,2,'1970-01-01 06:00:00','2020-06-23 14:17:38'),(1231,'3cfcf93664b50aeb24d266df2bb8f96a',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 14:17:39'),(1232,'3cfcf93664b50aeb24d266df2bb8f96a',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 14:17:41'),(1233,'3cfcf93664b50aeb24d266df2bb8f96a',14,7,7,2,'1970-01-01 06:00:00','2020-06-23 14:17:42'),(1234,'3cfcf93664b50aeb24d266df2bb8f96a',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 14:17:43'),(1235,'3cfcf93664b50aeb24d266df2bb8f96a',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 14:17:44'),(1236,'3cfcf93664b50aeb24d266df2bb8f96a',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 14:17:46'),(1237,'3cfcf93664b50aeb24d266df2bb8f96a',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 14:17:47'),(1238,'3cfcf93664b50aeb24d266df2bb8f96a',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 14:17:48'),(1239,'3cfcf93664b50aeb24d266df2bb8f96a',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 14:17:49'),(1240,'3cfcf93664b50aeb24d266df2bb8f96a',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 14:17:50'),(1241,'3cfcf93664b50aeb24d266df2bb8f96a',14,7,4,4,'1970-01-01 06:00:00','2020-06-23 14:17:52'),(1242,'3cfcf93664b50aeb24d266df2bb8f96a',14,7,5,4,'1970-01-01 06:00:00','2020-06-23 14:18:15'),(1243,'3cfcf93664b50aeb24d266df2bb8f96a',14,7,3,2,'1970-01-01 06:00:00','2020-06-23 14:18:29'),(1244,'03b0169f4d685be843cb0d7d4c800e58',14,7,1,1,'1970-01-01 06:00:00','2020-06-23 14:18:40'),(1245,'03b0169f4d685be843cb0d7d4c800e58',14,7,2,1,'1970-01-01 06:00:00','2020-06-23 14:18:55'),(1246,'03b0169f4d685be843cb0d7d4c800e58',10,1,1,1,'1970-01-01 06:00:00','2020-06-23 14:19:09'),(1247,'03b0169f4d685be843cb0d7d4c800e58',10,1,3,2,'1970-01-01 06:00:00','2020-06-23 14:19:44'),(1248,'03b0169f4d685be843cb0d7d4c800e58',2,1,2,2,'1970-01-01 06:00:00','2020-06-23 14:21:09'),(1249,'03b0169f4d685be843cb0d7d4c800e58',10,1,2,2,'1970-01-01 06:00:00','2020-06-23 14:23:37'),(1250,'03b0169f4d685be843cb0d7d4c800e58',21,9,1,1,'1970-01-01 06:00:00','2020-06-23 14:35:15'),(1251,'03b0169f4d685be843cb0d7d4c800e58',21,9,2,1,'1970-01-01 06:00:00','2020-06-23 14:38:34'),(1252,'03b0169f4d685be843cb0d7d4c800e58',21,9,2,1,'1970-01-01 06:00:00','2020-06-23 14:38:35'),(1253,'03b0169f4d685be843cb0d7d4c800e58',21,9,2,1,'1970-01-01 06:00:00','2020-06-23 14:38:39'),(1254,'03b0169f4d685be843cb0d7d4c800e58',21,9,3,2,'1970-01-01 06:00:00','2020-06-23 14:38:41'),(1255,'03b0169f4d685be843cb0d7d4c800e58',21,9,2,2,'1970-01-01 06:00:00','2020-06-23 14:38:42'),(1256,'03b0169f4d685be843cb0d7d4c800e58',21,9,5,2,'1970-01-01 06:00:00','2020-06-23 14:38:46'),(1257,'03b0169f4d685be843cb0d7d4c800e58',21,9,5,3,'1970-01-01 06:00:00','2020-06-23 14:38:47'),(1258,'03b0169f4d685be843cb0d7d4c800e58',22,1,2,2,'1970-01-01 06:00:00','2020-06-23 14:45:12'),(1259,'03b0169f4d685be843cb0d7d4c800e58',22,1,2,2,'1970-01-01 06:00:00','2020-06-23 14:45:20'),(1260,'b51171827cf97aefe7e7d1f23258412c',22,1,1,1,'1970-01-01 06:00:00','2020-06-23 14:45:35'),(1261,'b51171827cf97aefe7e7d1f23258412c',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 14:47:31'),(1262,'b51171827cf97aefe7e7d1f23258412c',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 14:47:33'),(1263,'b51171827cf97aefe7e7d1f23258412c',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 14:47:34'),(1264,'b51171827cf97aefe7e7d1f23258412c',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 14:47:34'),(1265,'b51171827cf97aefe7e7d1f23258412c',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 14:48:35'),(1266,'b51171827cf97aefe7e7d1f23258412c',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 14:48:36'),(1267,'b51171827cf97aefe7e7d1f23258412c',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 14:48:37'),(1268,'b51171827cf97aefe7e7d1f23258412c',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 14:48:38'),(1269,'3e2a2be75faee8fbe0a4f12a4e768e10',22,1,1,1,'1970-01-01 06:00:00','2020-06-23 14:48:46'),(1270,'3e2a2be75faee8fbe0a4f12a4e768e10',16,11,1,1,'1970-01-01 06:00:00','2020-06-23 14:50:08'),(1271,'3e2a2be75faee8fbe0a4f12a4e768e10',16,11,3,2,'1970-01-01 06:00:00','2020-06-23 14:50:10'),(1272,'3e2a2be75faee8fbe0a4f12a4e768e10',16,11,2,2,'1970-01-01 06:00:00','2020-06-23 14:50:11'),(1273,'fb603a04da7b29a7d59d6e382c027dce',16,11,1,1,'1970-01-01 06:00:00','2020-06-23 14:52:25'),(1274,'fb603a04da7b29a7d59d6e382c027dce',16,11,2,1,'1970-01-01 06:00:00','2020-06-23 14:58:22'),(1275,'fb603a04da7b29a7d59d6e382c027dce',22,1,1,1,'1970-01-01 06:00:00','2020-06-23 15:04:36'),(1276,'fb603a04da7b29a7d59d6e382c027dce',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 15:06:32'),(1277,'fb603a04da7b29a7d59d6e382c027dce',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 15:06:50'),(1278,'fb603a04da7b29a7d59d6e382c027dce',18,12,1,1,'1970-01-01 06:00:00','2020-06-23 15:07:04'),(1279,'fb603a04da7b29a7d59d6e382c027dce',16,11,2,1,'1970-01-01 06:00:00','2020-06-23 15:07:40'),(1280,'fb603a04da7b29a7d59d6e382c027dce',16,11,3,2,'1970-01-01 06:00:00','2020-06-23 15:07:53'),(1281,'fb603a04da7b29a7d59d6e382c027dce',16,11,2,2,'1970-01-01 06:00:00','2020-06-23 15:07:56'),(1282,'fb603a04da7b29a7d59d6e382c027dce',16,11,5,3,'1970-01-01 06:00:00','2020-06-23 15:08:02'),(1283,'fb603a04da7b29a7d59d6e382c027dce',16,11,4,4,'1970-01-01 06:00:00','2020-06-23 15:08:04'),(1284,'fb603a04da7b29a7d59d6e382c027dce',16,11,3,2,'1970-01-01 06:00:00','2020-06-23 15:08:05'),(1285,'fb603a04da7b29a7d59d6e382c027dce',16,11,5,3,'1970-01-01 06:00:00','2020-06-23 15:08:07'),(1286,'fb603a04da7b29a7d59d6e382c027dce',16,11,7,2,'1970-01-01 06:00:00','2020-06-23 15:08:10'),(1287,'fb603a04da7b29a7d59d6e382c027dce',14,7,1,1,'1970-01-01 06:00:00','2020-06-23 15:08:22'),(1288,'fb603a04da7b29a7d59d6e382c027dce',10,1,2,1,'1970-01-01 06:00:00','2020-06-23 15:08:35'),(1289,'fb603a04da7b29a7d59d6e382c027dce',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 15:09:19'),(1290,'fb603a04da7b29a7d59d6e382c027dce',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 15:11:05'),(1291,'fb603a04da7b29a7d59d6e382c027dce',21,9,1,1,'1970-01-01 06:00:00','2020-06-23 15:12:48'),(1292,'fb603a04da7b29a7d59d6e382c027dce',21,9,2,1,'1970-01-01 06:00:00','2020-06-23 15:12:50'),(1293,'fb603a04da7b29a7d59d6e382c027dce',21,9,3,2,'1970-01-01 06:00:00','2020-06-23 15:12:51'),(1294,'fb603a04da7b29a7d59d6e382c027dce',21,9,2,2,'1970-01-01 06:00:00','2020-06-23 15:13:33'),(1295,'fb603a04da7b29a7d59d6e382c027dce',21,9,2,2,'1970-01-01 06:00:00','2020-06-23 15:13:39'),(1296,'5c476714443accfae6213f5269533cc8',21,9,1,1,'1970-01-01 06:00:00','2020-06-23 15:13:44'),(1297,'5c476714443accfae6213f5269533cc8',21,9,3,2,'1970-01-01 06:00:00','2020-06-23 15:13:49'),(1298,'5c476714443accfae6213f5269533cc8',21,9,2,2,'1970-01-01 06:00:00','2020-06-23 15:13:53'),(1299,'5c476714443accfae6213f5269533cc8',10,1,1,1,'1970-01-01 06:00:00','2020-06-23 15:22:25'),(1300,'5c476714443accfae6213f5269533cc8',10,1,3,2,'1970-01-01 06:00:00','2020-06-23 15:22:40'),(1301,'5c476714443accfae6213f5269533cc8',10,1,5,2,'1970-01-01 06:00:00','2020-06-23 15:22:41'),(1302,'5c476714443accfae6213f5269533cc8',10,1,5,2,'1970-01-01 06:00:00','2020-06-23 15:22:42'),(1303,'5c476714443accfae6213f5269533cc8',10,1,5,3,'1970-01-01 06:00:00','2020-06-23 15:22:43'),(1304,'5c476714443accfae6213f5269533cc8',10,1,4,4,'1970-01-01 06:00:00','2020-06-23 15:22:45'),(1305,'5c476714443accfae6213f5269533cc8',14,7,1,1,'1970-01-01 06:00:00','2020-06-23 15:23:18'),(1306,'5c476714443accfae6213f5269533cc8',14,7,3,2,'1970-01-01 06:00:00','2020-06-23 15:23:20'),(1307,'5c476714443accfae6213f5269533cc8',14,7,2,2,'1970-01-01 06:00:00','2020-06-23 15:23:22'),(1308,'5c476714443accfae6213f5269533cc8',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 15:23:24'),(1309,'5c476714443accfae6213f5269533cc8',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 15:23:25'),(1310,'5c476714443accfae6213f5269533cc8',14,7,4,4,'1970-01-01 06:00:00','2020-06-23 15:23:27'),(1311,'5c476714443accfae6213f5269533cc8',10,1,2,4,'1970-01-01 06:00:00','2020-06-23 15:23:41'),(1312,'5c476714443accfae6213f5269533cc8',21,9,2,2,'1970-01-01 06:00:00','2020-06-23 15:27:27'),(1313,'c255df1c6be85ac3f249df056d7fcd5e',21,9,1,1,'1970-01-01 06:00:00','2020-06-23 15:27:33'),(1314,'c255df1c6be85ac3f249df056d7fcd5e',21,9,2,1,'1970-01-01 06:00:00','2020-06-23 15:27:35'),(1315,'c255df1c6be85ac3f249df056d7fcd5e',21,9,2,1,'1970-01-01 06:00:00','2020-06-23 15:27:36'),(1316,'c255df1c6be85ac3f249df056d7fcd5e',21,9,2,1,'1970-01-01 06:00:00','2020-06-23 15:27:36'),(1317,'c255df1c6be85ac3f249df056d7fcd5e',21,9,2,1,'1970-01-01 06:00:00','2020-06-23 15:27:37'),(1318,'c255df1c6be85ac3f249df056d7fcd5e',21,9,2,1,'1970-01-01 06:00:00','2020-06-23 15:27:37'),(1319,'c255df1c6be85ac3f249df056d7fcd5e',21,9,3,2,'1970-01-01 06:00:00','2020-06-23 15:27:40'),(1320,'c255df1c6be85ac3f249df056d7fcd5e',21,9,2,2,'1970-01-01 06:00:00','2020-06-23 15:27:41'),(1321,'c255df1c6be85ac3f249df056d7fcd5e',21,9,2,2,'1970-01-01 06:00:00','2020-06-23 15:31:10'),(1322,'c255df1c6be85ac3f249df056d7fcd5e',10,1,1,1,'1970-01-01 06:00:00','2020-06-23 15:31:16'),(1323,'c255df1c6be85ac3f249df056d7fcd5e',10,1,3,2,'1970-01-01 06:00:00','2020-06-23 15:31:22'),(1324,'c255df1c6be85ac3f249df056d7fcd5e',10,1,6,4,'1970-01-01 06:00:00','2020-06-23 15:32:23'),(1325,'c255df1c6be85ac3f249df056d7fcd5e',14,7,1,1,'1970-01-01 06:00:00','2020-06-23 15:32:38'),(1326,'c255df1c6be85ac3f249df056d7fcd5e',14,7,3,2,'1970-01-01 06:00:00','2020-06-23 15:32:39'),(1327,'c255df1c6be85ac3f249df056d7fcd5e',14,7,2,2,'1970-01-01 06:00:00','2020-06-23 15:32:40'),(1328,'c255df1c6be85ac3f249df056d7fcd5e',14,7,6,4,'1970-01-01 06:00:00','2020-06-23 15:32:41'),(1329,'c255df1c6be85ac3f249df056d7fcd5e',14,7,2,4,'1970-01-01 06:00:00','2020-06-23 15:39:57'),(1330,'c255df1c6be85ac3f249df056d7fcd5e',10,1,2,4,'1970-01-01 06:00:00','2020-06-23 15:40:14'),(1331,'c255df1c6be85ac3f249df056d7fcd5e',10,1,3,2,'1970-01-01 06:00:00','2020-06-23 15:40:21'),(1332,'a68a983b241f57dcab36328bb3442f32',10,1,1,1,'1970-01-01 06:00:00','2020-06-23 15:40:30'),(1333,'a68a983b241f57dcab36328bb3442f32',10,1,3,2,'1970-01-01 06:00:00','2020-06-23 15:40:36'),(1334,'a68a983b241f57dcab36328bb3442f32',10,1,6,4,'1970-01-01 06:00:00','2020-06-23 15:40:37'),(1335,'a68a983b241f57dcab36328bb3442f32',14,7,1,1,'1970-01-01 06:00:00','2020-06-23 15:56:00'),(1336,'a68a983b241f57dcab36328bb3442f32',14,7,3,2,'1970-01-01 06:00:00','2020-06-23 15:56:35'),(1337,'a68a983b241f57dcab36328bb3442f32',14,7,2,2,'1970-01-01 06:00:00','2020-06-23 15:56:36'),(1338,'0fb4a0bfe715bd226d5344f3d979f77b',14,7,1,1,'1970-01-01 06:00:00','2020-06-23 15:56:47'),(1339,'0fb4a0bfe715bd226d5344f3d979f77b',14,7,3,2,'1970-01-01 06:00:00','2020-06-23 15:56:48'),(1340,'0fb4a0bfe715bd226d5344f3d979f77b',14,7,2,2,'1970-01-01 06:00:00','2020-06-23 15:56:58'),(1341,'af3f2414a74035dd619dc55f9c8ac023',14,7,2,2,'1970-01-01 06:00:00','2020-06-23 15:58:51'),(1342,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,1,1,'1970-01-01 06:00:00','2020-06-23 15:59:14'),(1343,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,3,2,'1970-01-01 06:00:00','2020-06-23 15:59:48'),(1344,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 16:00:04'),(1345,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:00:06'),(1346,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:00:07'),(1347,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,2,2,'1970-01-01 06:00:00','2020-06-23 16:00:27'),(1348,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:00:36'),(1349,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,2,2,'1970-01-01 06:00:00','2020-06-23 16:00:46'),(1350,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,2,2,'1970-01-01 06:00:00','2020-06-23 16:00:50'),(1351,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 16:00:55'),(1352,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,7,2,'1970-01-01 06:00:00','2020-06-23 16:00:57'),(1353,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:00:59'),(1354,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:01:00'),(1355,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:01:01'),(1356,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:01:03'),(1357,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:01:04'),(1358,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:01:16'),(1359,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:01:18'),(1360,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:01:20'),(1361,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 16:01:23'),(1362,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,7,2,'1970-01-01 06:00:00','2020-06-23 16:01:30'),(1363,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:01:32'),(1364,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 16:01:33'),(1365,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,7,2,'1970-01-01 06:00:00','2020-06-23 16:01:35'),(1366,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:01:37'),(1367,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 16:01:38'),(1368,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,7,2,'1970-01-01 06:00:00','2020-06-23 16:01:40'),(1369,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:01:43'),(1370,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:01:45'),(1371,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:02:44'),(1372,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:02:46'),(1373,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 16:02:47'),(1374,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,4,4,'1970-01-01 06:00:00','2020-06-23 16:02:51'),(1375,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,2,2,'1970-01-01 06:00:00','2020-06-23 16:02:54'),(1376,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,2,'1970-01-01 06:00:00','2020-06-23 16:03:17'),(1377,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,2,2,'1970-01-01 06:00:00','2020-06-23 16:05:10'),(1378,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,2,2,'1970-01-01 06:00:00','2020-06-23 16:07:10'),(1379,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,2,2,'1970-01-01 06:00:00','2020-06-23 16:08:37'),(1380,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 16:08:38'),(1381,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,4,4,'1970-01-01 06:00:00','2020-06-23 16:08:40'),(1382,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,3,2,'1970-01-01 06:00:00','2020-06-23 16:08:42'),(1383,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 16:08:47'),(1384,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,4,4,'1970-01-01 06:00:00','2020-06-23 16:08:48'),(1385,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,3,2,'1970-01-01 06:00:00','2020-06-23 16:08:50'),(1386,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:08:54'),(1387,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,2,4,'1970-01-01 06:00:00','2020-06-23 16:08:55'),(1388,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:08:55'),(1389,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:08:57'),(1390,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,2,4,'1970-01-01 06:00:00','2020-06-23 16:08:58'),(1391,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:09:00'),(1392,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,3,2,'1970-01-01 06:00:00','2020-06-23 16:09:00'),(1393,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:09:01'),(1394,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:09:03'),(1395,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 16:09:03'),(1396,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 16:09:04'),(1397,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,4,4,'1970-01-01 06:00:00','2020-06-23 16:09:04'),(1398,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,3,2,'1970-01-01 06:00:00','2020-06-23 16:09:06'),(1399,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:09:08'),(1400,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:09:09'),(1401,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:09:11'),(1402,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:09:16'),(1403,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:09:18'),(1404,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:09:20'),(1405,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 16:09:22'),(1406,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,7,2,'1970-01-01 06:00:00','2020-06-23 16:09:25'),(1407,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 16:09:26'),(1408,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,7,2,'1970-01-01 06:00:00','2020-06-23 16:09:28'),(1409,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:09:29'),(1410,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 16:09:30'),(1411,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,7,2,'1970-01-01 06:00:00','2020-06-23 16:09:31'),(1412,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 16:09:32'),(1413,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,7,2,'1970-01-01 06:00:00','2020-06-23 16:09:34'),(1414,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:09:35'),(1415,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:09:36'),(1416,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:09:38'),(1417,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:09:39'),(1418,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:09:41'),(1419,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:09:42'),(1420,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 16:09:45'),(1421,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,7,2,'1970-01-01 06:00:00','2020-06-23 16:09:47'),(1422,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,6,2,'1970-01-01 06:00:00','2020-06-23 16:13:39'),(1423,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:13:44'),(1424,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,6,2,'1970-01-01 06:00:00','2020-06-23 16:13:47'),(1425,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 16:13:48'),(1426,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,4,4,'1970-01-01 06:00:00','2020-06-23 16:13:50'),(1427,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,3,2,'1970-01-01 06:00:00','2020-06-23 16:13:52'),(1428,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 16:13:54'),(1429,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,7,2,'1970-01-01 06:00:00','2020-06-23 16:13:55'),(1430,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:13:57'),(1431,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 16:14:00'),(1432,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,7,2,'1970-01-01 06:00:00','2020-06-23 16:14:02'),(1433,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:14:05'),(1434,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:14:12'),(1435,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:14:18'),(1436,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:14:21'),(1437,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 16:14:38'),(1438,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,6,2,'1970-01-01 06:00:00','2020-06-23 16:15:02'),(1439,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:15:11'),(1440,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,2,2,'1970-01-01 06:00:00','2020-06-23 16:15:13'),(1441,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 16:15:13'),(1442,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 16:15:14'),(1443,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,7,2,'1970-01-01 06:00:00','2020-06-23 16:15:15'),(1444,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,7,2,'1970-01-01 06:00:00','2020-06-23 16:15:16'),(1445,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:15:17'),(1446,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:15:18'),(1447,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:15:19'),(1448,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:15:19'),(1449,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,6,2,'1970-01-01 06:00:00','2020-06-23 16:15:47'),(1450,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,6,4,'1970-01-01 06:00:00','2020-06-23 16:15:51'),(1451,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,3,2,'1970-01-01 06:00:00','2020-06-23 16:15:52'),(1452,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:15:56'),(1453,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:15:58'),(1454,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 16:16:04'),(1455,'0fb4a0bfe715bd226d5344f3d979f77b',14,7,2,2,'1970-01-01 06:00:00','2020-06-23 16:44:40'),(1456,'e35d249b9288fec216cca87e98ee5109',14,7,1,1,'1970-01-01 06:00:00','2020-06-23 16:44:47'),(1457,'e35d249b9288fec216cca87e98ee5109',22,1,1,1,'1970-01-01 06:00:00','2020-06-23 16:45:08'),(1458,'e35d249b9288fec216cca87e98ee5109',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 16:51:59'),(1459,'e35d249b9288fec216cca87e98ee5109',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 16:52:51'),(1460,'e35d249b9288fec216cca87e98ee5109',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 17:08:21'),(1461,'d872b917e5bd43d94baffa48dc0e4cfd',22,1,1,1,'1970-01-01 06:00:00','2020-06-23 17:19:22'),(1462,'d7f114755aa581f5738f2b53567e0b8b',22,1,1,1,'1970-01-01 06:00:00','2020-06-23 17:20:52'),(1463,'d7f114755aa581f5738f2b53567e0b8b',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 17:25:09'),(1464,'d7f114755aa581f5738f2b53567e0b8b',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 17:25:09'),(1465,'d7f114755aa581f5738f2b53567e0b8b',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 17:27:43'),(1466,'d7f114755aa581f5738f2b53567e0b8b',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 17:27:44'),(1467,'e4ed42978b2613c71f648100bb1c3368',22,1,1,1,'1970-01-01 06:00:00','2020-06-23 17:27:51'),(1468,'e4ed42978b2613c71f648100bb1c3368',23,7,1,1,'1970-01-01 06:00:00','2020-06-23 17:28:45'),(1469,'e4ed42978b2613c71f648100bb1c3368',23,7,2,1,'1970-01-01 06:00:00','2020-06-23 17:29:28'),(1470,'e4ed42978b2613c71f648100bb1c3368',23,7,2,1,'1970-01-01 06:00:00','2020-06-23 17:30:19'),(1471,'e4ed42978b2613c71f648100bb1c3368',23,7,2,1,'1970-01-01 06:00:00','2020-06-23 17:30:21'),(1472,'e4ed42978b2613c71f648100bb1c3368',23,7,3,2,'1970-01-01 06:00:00','2020-06-23 17:30:43'),(1473,'e4ed42978b2613c71f648100bb1c3368',23,7,2,2,'1970-01-01 06:00:00','2020-06-23 17:30:43'),(1474,'add093d9b2f05bf88c574ff20c2d5342',23,7,1,1,'1970-01-01 06:00:00','2020-06-23 17:31:34'),(1475,'12c62ccd8eddb3c59e2b1c25ff12a232',22,1,1,1,'1970-01-01 06:00:00','2020-06-23 17:36:39'),(1476,'12c62ccd8eddb3c59e2b1c25ff12a232',22,1,3,2,'1970-01-01 06:00:00','2020-06-23 17:36:45'),(1477,'a5db437404cd17536e7f17d5fca6232d',22,1,1,1,'1970-01-01 06:00:00','2020-06-23 17:37:25'),(1478,'a5db437404cd17536e7f17d5fca6232d',22,1,3,2,'1970-01-01 06:00:00','2020-06-23 17:37:26'),(1479,'9b8ee8596c0858e9b2b4e67381affd9f',23,7,1,1,'1970-01-01 06:00:00','2020-06-23 17:38:50'),(1480,'9b8ee8596c0858e9b2b4e67381affd9f',22,1,1,1,'1970-01-01 06:00:00','2020-06-23 17:39:33'),(1481,'9b8ee8596c0858e9b2b4e67381affd9f',23,7,2,1,'1970-01-01 06:00:00','2020-06-23 17:41:23'),(1482,'9b8ee8596c0858e9b2b4e67381affd9f',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 17:43:26'),(1483,'9b8ee8596c0858e9b2b4e67381affd9f',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 17:43:33'),(1484,'c3770747153ef4a0584bde160eecf79f',22,1,1,1,'1970-01-01 06:00:00','2020-06-23 17:43:40'),(1485,'c3770747153ef4a0584bde160eecf79f',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 17:44:11'),(1486,'c3770747153ef4a0584bde160eecf79f',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 17:44:12'),(1487,'c3770747153ef4a0584bde160eecf79f',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 17:44:13'),(1488,'c3770747153ef4a0584bde160eecf79f',23,7,1,1,'1970-01-01 06:00:00','2020-06-23 17:50:32'),(1489,'c3770747153ef4a0584bde160eecf79f',23,7,2,1,'1970-01-01 06:00:00','2020-06-23 17:50:34'),(1490,'c3770747153ef4a0584bde160eecf79f',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 17:51:33'),(1491,'c3770747153ef4a0584bde160eecf79f',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 17:51:34'),(1492,'c3770747153ef4a0584bde160eecf79f',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 17:51:34'),(1493,'c3770747153ef4a0584bde160eecf79f',23,7,2,1,'1970-01-01 06:00:00','2020-06-23 17:52:42'),(1494,'c3770747153ef4a0584bde160eecf79f',23,7,2,1,'1970-01-01 06:00:00','2020-06-23 17:52:43'),(1495,'c3770747153ef4a0584bde160eecf79f',23,7,2,1,'1970-01-01 06:00:00','2020-06-23 17:52:44'),(1496,'c3770747153ef4a0584bde160eecf79f',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 17:53:16'),(1497,'c3770747153ef4a0584bde160eecf79f',23,7,2,1,'1970-01-01 06:00:00','2020-06-23 17:53:52'),(1498,'c3770747153ef4a0584bde160eecf79f',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 17:54:44'),(1499,'c3770747153ef4a0584bde160eecf79f',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 17:55:29'),(1500,'c3770747153ef4a0584bde160eecf79f',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 17:55:29'),(1501,'c3770747153ef4a0584bde160eecf79f',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 18:00:59'),(1502,'c3770747153ef4a0584bde160eecf79f',24,15,1,1,'1970-01-01 06:00:00','2020-06-23 18:02:37'),(1503,'c3770747153ef4a0584bde160eecf79f',24,15,3,2,'1970-01-01 06:00:00','2020-06-23 18:02:43'),(1504,'c3770747153ef4a0584bde160eecf79f',24,15,2,2,'1970-01-01 06:00:00','2020-06-23 18:02:45'),(1505,'c3770747153ef4a0584bde160eecf79f',24,15,2,2,'1970-01-01 06:00:00','2020-06-23 18:03:00'),(1506,'af3f2414a74035dd619dc55f9c8ac023',24,15,1,1,'1970-01-01 06:00:00','2020-06-23 18:03:08'),(1507,'af3f2414a74035dd619dc55f9c8ac023',24,15,2,1,'1970-01-01 06:00:00','2020-06-23 18:03:49'),(1508,'af3f2414a74035dd619dc55f9c8ac023',24,15,2,1,'1970-01-01 06:00:00','2020-06-23 18:04:16'),(1509,'af3f2414a74035dd619dc55f9c8ac023',24,15,3,2,'1970-01-01 06:00:00','2020-06-23 18:04:35'),(1510,'af3f2414a74035dd619dc55f9c8ac023',24,15,2,1,'1970-01-01 06:00:00','2020-06-23 18:04:43'),(1511,'c3770747153ef4a0584bde160eecf79f',23,7,2,1,'1970-01-01 06:00:00','2020-06-23 18:06:12'),(1512,'c3770747153ef4a0584bde160eecf79f',23,7,2,1,'1970-01-01 06:00:00','2020-06-23 18:06:15'),(1513,'c3770747153ef4a0584bde160eecf79f',23,7,2,1,'1970-01-01 06:00:00','2020-06-23 18:06:49'),(1514,'c3770747153ef4a0584bde160eecf79f',10,1,2,1,'1970-01-01 06:00:00','2020-06-23 18:07:13'),(1515,'c3770747153ef4a0584bde160eecf79f',23,7,3,2,'1970-01-01 06:00:00','2020-06-23 18:07:33'),(1516,'c3770747153ef4a0584bde160eecf79f',23,7,2,2,'1970-01-01 06:00:00','2020-06-23 18:07:41'),(1517,'c3770747153ef4a0584bde160eecf79f',23,7,5,3,'1970-01-01 06:00:00','2020-06-23 18:07:44'),(1518,'c3770747153ef4a0584bde160eecf79f',23,7,7,2,'1970-01-01 06:00:00','2020-06-23 18:07:46'),(1519,'c3770747153ef4a0584bde160eecf79f',23,7,5,2,'1970-01-01 06:00:00','2020-06-23 18:07:47'),(1520,'c3770747153ef4a0584bde160eecf79f',23,7,5,2,'1970-01-01 06:00:00','2020-06-23 18:07:50'),(1521,'c3770747153ef4a0584bde160eecf79f',23,7,5,3,'1970-01-01 06:00:00','2020-06-23 18:07:50'),(1522,'c3770747153ef4a0584bde160eecf79f',23,7,7,2,'1970-01-01 06:00:00','2020-06-23 18:07:53'),(1523,'c3770747153ef4a0584bde160eecf79f',23,7,5,2,'1970-01-01 06:00:00','2020-06-23 18:07:53'),(1524,'c3770747153ef4a0584bde160eecf79f',23,7,5,3,'1970-01-01 06:00:00','2020-06-23 18:07:54'),(1525,'c3770747153ef4a0584bde160eecf79f',23,7,4,4,'1970-01-01 06:00:00','2020-06-23 18:07:56'),(1526,'c3770747153ef4a0584bde160eecf79f',23,7,2,4,'1970-01-01 06:00:00','2020-06-23 18:08:34'),(1527,'c3770747153ef4a0584bde160eecf79f',14,7,2,4,'1970-01-01 06:00:00','2020-06-23 18:08:56'),(1528,'c3770747153ef4a0584bde160eecf79f',14,7,3,2,'1970-01-01 06:00:00','2020-06-23 18:08:58'),(1529,'c3770747153ef4a0584bde160eecf79f',23,7,2,2,'1970-01-01 06:00:00','2020-06-23 18:09:01'),(1530,'d5ff656b5eff7bcd37cb70519d94c4e5',23,7,1,1,'1970-01-01 06:00:00','2020-06-23 18:09:15'),(1531,'d5ff656b5eff7bcd37cb70519d94c4e5',23,7,2,1,'1970-01-01 06:00:00','2020-06-23 18:09:17'),(1532,'d5ff656b5eff7bcd37cb70519d94c4e5',23,7,2,1,'1970-01-01 06:00:00','2020-06-23 18:09:18'),(1533,'d5ff656b5eff7bcd37cb70519d94c4e5',23,7,2,1,'1970-01-01 06:00:00','2020-06-23 18:09:19'),(1534,'d5ff656b5eff7bcd37cb70519d94c4e5',23,7,2,1,'1970-01-01 06:00:00','2020-06-23 18:09:19'),(1535,'d5ff656b5eff7bcd37cb70519d94c4e5',23,7,3,2,'1970-01-01 06:00:00','2020-06-23 18:09:20'),(1536,'d5ff656b5eff7bcd37cb70519d94c4e5',23,7,2,2,'1970-01-01 06:00:00','2020-06-23 18:09:24'),(1537,'d5ff656b5eff7bcd37cb70519d94c4e5',23,7,5,3,'1970-01-01 06:00:00','2020-06-23 18:09:26'),(1538,'d5ff656b5eff7bcd37cb70519d94c4e5',23,7,4,4,'1970-01-01 06:00:00','2020-06-23 18:09:27'),(1539,'d5ff656b5eff7bcd37cb70519d94c4e5',22,1,1,1,'1970-01-01 06:00:00','2020-06-23 18:10:24'),(1540,'d5ff656b5eff7bcd37cb70519d94c4e5',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 18:10:26'),(1541,'d5ff656b5eff7bcd37cb70519d94c4e5',22,1,2,1,'1970-01-01 06:00:00','2020-06-23 18:11:56'),(1542,'d32b79ee819eb2ffc0362601b0090fe5',22,1,1,1,'1970-01-01 06:00:00','2020-06-23 18:12:47'),(1543,'cccd6167bdbc3f53fdd1c14a64eee7e5',23,7,1,1,'1970-01-01 06:00:00','2020-06-23 18:14:27'),(1544,'cccd6167bdbc3f53fdd1c14a64eee7e5',23,7,3,2,'1970-01-01 06:00:00','2020-06-23 18:14:34'),(1545,'cccd6167bdbc3f53fdd1c14a64eee7e5',23,7,2,2,'1970-01-01 06:00:00','2020-06-23 18:14:42'),(1546,'cccd6167bdbc3f53fdd1c14a64eee7e5',23,7,2,2,'1970-01-01 06:00:00','2020-06-23 18:14:44'),(1547,'cccd6167bdbc3f53fdd1c14a64eee7e5',23,7,2,2,'1970-01-01 06:00:00','2020-06-23 18:15:16'),(1548,'4a9fb7f356d03a930dad57e6bf700cd5',23,7,1,1,'1970-01-01 06:00:00','2020-06-23 18:15:21'),(1549,'4a9fb7f356d03a930dad57e6bf700cd5',23,7,3,2,'1970-01-01 06:00:00','2020-06-23 18:15:32'),(1550,'4a9fb7f356d03a930dad57e6bf700cd5',23,7,2,2,'1970-01-01 06:00:00','2020-06-23 18:15:41'),(1551,'4a9fb7f356d03a930dad57e6bf700cd5',23,7,2,2,'1970-01-01 06:00:00','2020-06-23 18:16:06'),(1552,'c2c26340f93374f405bb88160d203cbf',23,7,1,1,'1970-01-01 06:00:00','2020-06-23 18:16:12'),(1553,'c2c26340f93374f405bb88160d203cbf',23,7,2,1,'1970-01-01 06:00:00','2020-06-23 18:22:33'),(1554,'c2c26340f93374f405bb88160d203cbf',23,7,2,1,'1970-01-01 06:00:00','2020-06-23 18:22:44'),(1555,'780af7f034d996295413b2a73df4d3f2',23,7,1,1,'1970-01-01 06:00:00','2020-06-23 18:22:52'),(1556,'ecdc61c513c6f1f67b2d6b3d4d750b72',23,7,1,1,'1970-01-01 06:00:00','2020-06-23 18:24:13'),(1557,'af3f2414a74035dd619dc55f9c8ac023',23,7,2,2,'1970-01-01 06:00:00','2020-06-23 18:24:32'),(1558,'64d49eab0bb64d719309cbb7a1d43ae1',23,7,1,1,'1970-01-01 06:00:00','2020-06-23 18:24:37'),(1559,'64d49eab0bb64d719309cbb7a1d43ae1',23,7,2,1,'1970-01-01 06:00:00','2020-06-23 18:24:37'),(1560,'64d49eab0bb64d719309cbb7a1d43ae1',23,7,2,1,'1970-01-01 06:00:00','2020-06-23 18:24:38'),(1561,'64d49eab0bb64d719309cbb7a1d43ae1',23,7,2,1,'1970-01-01 06:00:00','2020-06-23 18:24:38'),(1562,'64d49eab0bb64d719309cbb7a1d43ae1',23,7,2,1,'1970-01-01 06:00:00','2020-06-23 18:25:13'),(1563,'b4ec0fae0b76a22d8c744c769f7eeda0',23,7,1,1,'1970-01-01 06:00:00','2020-06-23 18:25:22'),(1564,'883da0a1491cbc417660884b263cb5f6',23,7,1,1,'1970-01-01 06:00:00','2020-06-23 18:26:50'),(1565,'883da0a1491cbc417660884b263cb5f6',23,7,3,2,'1970-01-01 06:00:00','2020-06-23 18:26:54'),(1566,'883da0a1491cbc417660884b263cb5f6',23,7,2,2,'1970-01-01 06:00:00','2020-06-23 18:28:03'),(1567,'883da0a1491cbc417660884b263cb5f6',23,7,5,3,'1970-01-01 06:00:00','2020-06-23 18:28:08'),(1568,'883da0a1491cbc417660884b263cb5f6',23,7,4,4,'1970-01-01 06:00:00','2020-06-23 18:28:09'),(1569,'883da0a1491cbc417660884b263cb5f6',23,7,2,4,'1970-01-01 06:00:00','2020-06-23 18:28:15'),(1570,'234c2866ca17045ce3ac45c2c0d31d32',23,7,1,1,'1970-01-01 06:00:00','2020-06-23 18:28:33'),(1571,'234c2866ca17045ce3ac45c2c0d31d32',23,7,3,2,'1970-01-01 06:00:00','2020-06-23 18:28:40'),(1572,'58fd54161b7effcbbc1527132dc57fd8',23,7,1,1,'1970-01-01 06:00:00','2020-06-23 18:29:49'),(1573,'58fd54161b7effcbbc1527132dc57fd8',23,7,3,2,'1970-01-01 06:00:00','2020-06-23 18:29:52'),(1574,'48e9cf3b5565b1d5f8cb82f67d838ad1',23,7,1,1,'1970-01-01 06:00:00','2020-06-23 18:31:04'),(1575,'48e9cf3b5565b1d5f8cb82f67d838ad1',23,7,3,2,'1970-01-01 06:00:00','2020-06-23 18:31:06'),(1576,'48e9cf3b5565b1d5f8cb82f67d838ad1',23,7,2,2,'1970-01-01 06:00:00','2020-06-23 18:32:41'),(1577,'1757e70f6e76374a485f3a3c54df4a75',23,7,1,1,'1970-01-01 06:00:00','2020-06-23 18:32:47'),(1578,'1757e70f6e76374a485f3a3c54df4a75',23,7,3,2,'1970-01-01 06:00:00','2020-06-23 18:32:50'),(1579,'72c4b1ff3b660fa9d6a1b34ab6d8129e',23,7,1,1,'1970-01-01 06:00:00','2020-06-23 18:33:48'),(1580,'72c4b1ff3b660fa9d6a1b34ab6d8129e',23,7,3,2,'1970-01-01 06:00:00','2020-06-23 18:33:49'),(1581,'7ffc3cbfbb2b5a2cd9e7f4e85c46ce77',23,7,1,1,'1970-01-01 06:00:00','2020-06-23 18:34:45'),(1582,'7ffc3cbfbb2b5a2cd9e7f4e85c46ce77',23,7,3,2,'1970-01-01 06:00:00','2020-06-23 18:34:47'),(1583,'7ffc3cbfbb2b5a2cd9e7f4e85c46ce77',23,7,2,2,'1970-01-01 06:00:00','2020-06-23 18:34:48'),(1584,'7ffc3cbfbb2b5a2cd9e7f4e85c46ce77',23,7,2,2,'1970-01-01 06:00:00','2020-06-23 18:34:52'),(1585,'0387c79e5a35c356348e0888e6685d81',23,7,1,1,'1970-01-01 06:00:00','2020-06-23 18:34:58'),(1586,'0387c79e5a35c356348e0888e6685d81',14,7,2,1,'1970-01-01 06:00:00','2020-06-23 18:36:01'),(1587,'0387c79e5a35c356348e0888e6685d81',14,7,3,2,'1970-01-01 06:00:00','2020-06-23 18:36:36'),(1588,'0387c79e5a35c356348e0888e6685d81',14,7,2,2,'1970-01-01 06:00:00','2020-06-23 18:36:37'),(1589,'0387c79e5a35c356348e0888e6685d81',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 18:36:39'),(1590,'0387c79e5a35c356348e0888e6685d81',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 18:36:40'),(1591,'0387c79e5a35c356348e0888e6685d81',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 18:36:41'),(1592,'0387c79e5a35c356348e0888e6685d81',14,7,4,4,'1970-01-01 06:00:00','2020-06-23 18:36:46'),(1593,'4fbc58ae6f89193415e6a2ae1b0e8625',13,7,1,1,'1970-01-01 06:00:00','2020-06-23 19:59:34'),(1594,'4fbc58ae6f89193415e6a2ae1b0e8625',13,7,3,2,'1970-01-01 06:00:00','2020-06-23 19:59:42'),(1595,'4fbc58ae6f89193415e6a2ae1b0e8625',13,7,2,2,'1970-01-01 06:00:00','2020-06-23 19:59:44'),(1596,'4fbc58ae6f89193415e6a2ae1b0e8625',13,7,5,3,'1970-01-01 06:00:00','2020-06-23 19:59:59'),(1597,'4fbc58ae6f89193415e6a2ae1b0e8625',13,7,7,2,'1970-01-01 06:00:00','2020-06-23 20:00:00'),(1598,'4fbc58ae6f89193415e6a2ae1b0e8625',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 20:00:01'),(1599,'4fbc58ae6f89193415e6a2ae1b0e8625',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 20:00:03'),(1600,'4fbc58ae6f89193415e6a2ae1b0e8625',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 20:00:03'),(1601,'4fbc58ae6f89193415e6a2ae1b0e8625',13,7,5,3,'1970-01-01 06:00:00','2020-06-23 20:00:04'),(1602,'4fbc58ae6f89193415e6a2ae1b0e8625',13,7,7,2,'1970-01-01 06:00:00','2020-06-23 20:00:06'),(1603,'4fbc58ae6f89193415e6a2ae1b0e8625',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 20:00:41'),(1604,'4fbc58ae6f89193415e6a2ae1b0e8625',13,7,2,2,'1970-01-01 06:00:00','2020-06-23 20:01:49'),(1605,'4fbc58ae6f89193415e6a2ae1b0e8625',13,7,2,2,'1970-01-01 06:00:00','2020-06-23 20:02:10'),(1606,'4fbc58ae6f89193415e6a2ae1b0e8625',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 20:02:56'),(1607,'4fbc58ae6f89193415e6a2ae1b0e8625',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 20:02:57'),(1608,'4fbc58ae6f89193415e6a2ae1b0e8625',13,7,5,3,'1970-01-01 06:00:00','2020-06-23 20:02:57'),(1609,'4fbc58ae6f89193415e6a2ae1b0e8625',13,7,4,4,'1970-01-01 06:00:00','2020-06-23 20:02:59'),(1610,'4fbc58ae6f89193415e6a2ae1b0e8625',13,7,3,2,'1970-01-01 06:00:00','2020-06-23 20:03:07'),(1611,'4fbc58ae6f89193415e6a2ae1b0e8625',13,7,5,3,'1970-01-01 06:00:00','2020-06-23 20:03:09'),(1612,'4fbc58ae6f89193415e6a2ae1b0e8625',13,7,4,4,'1970-01-01 06:00:00','2020-06-23 20:03:10'),(1613,'059adee0130f305aa228986672d1d7db',13,7,1,1,'1970-01-01 06:00:00','2020-06-23 20:03:47'),(1614,'059adee0130f305aa228986672d1d7db',13,7,3,2,'1970-01-01 06:00:00','2020-06-23 20:03:49'),(1615,'059adee0130f305aa228986672d1d7db',13,7,2,2,'1970-01-01 06:00:00','2020-06-23 20:03:50'),(1616,'059adee0130f305aa228986672d1d7db',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 20:03:51'),(1617,'059adee0130f305aa228986672d1d7db',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 20:03:52'),(1618,'059adee0130f305aa228986672d1d7db',13,7,5,3,'1970-01-01 06:00:00','2020-06-23 20:03:54'),(1619,'059adee0130f305aa228986672d1d7db',13,7,4,4,'1970-01-01 06:00:00','2020-06-23 20:03:55'),(1620,'059adee0130f305aa228986672d1d7db',13,7,2,4,'1970-01-01 06:00:00','2020-06-23 20:05:11'),(1621,'059adee0130f305aa228986672d1d7db',13,7,2,4,'1970-01-01 06:00:00','2020-06-23 20:05:18'),(1622,'059adee0130f305aa228986672d1d7db',13,7,2,4,'1970-01-01 06:00:00','2020-06-23 20:05:47'),(1623,'059adee0130f305aa228986672d1d7db',13,7,3,2,'1970-01-01 06:00:00','2020-06-23 20:05:49'),(1624,'059adee0130f305aa228986672d1d7db',13,7,5,3,'1970-01-01 06:00:00','2020-06-23 20:05:52'),(1625,'059adee0130f305aa228986672d1d7db',13,7,7,2,'1970-01-01 06:00:00','2020-06-23 20:05:53'),(1626,'059adee0130f305aa228986672d1d7db',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 20:05:54'),(1627,'059adee0130f305aa228986672d1d7db',13,7,5,3,'1970-01-01 06:00:00','2020-06-23 20:05:55'),(1628,'059adee0130f305aa228986672d1d7db',13,7,4,4,'1970-01-01 06:00:00','2020-06-23 20:05:56'),(1629,'af3f2414a74035dd619dc55f9c8ac023',13,7,2,2,'1970-01-01 06:00:00','2020-06-23 20:15:09'),(1630,'3f700d266c30c3b2780735bcbef760fa',13,7,1,1,'1970-01-01 06:00:00','2020-06-23 20:15:18'),(1631,'3f700d266c30c3b2780735bcbef760fa',13,7,2,1,'1970-01-01 06:00:00','2020-06-23 20:15:20'),(1632,'3f700d266c30c3b2780735bcbef760fa',13,7,3,2,'1970-01-01 06:00:00','2020-06-23 20:15:20'),(1633,'3f700d266c30c3b2780735bcbef760fa',13,7,2,2,'1970-01-01 06:00:00','2020-06-23 20:15:21'),(1634,'3f700d266c30c3b2780735bcbef760fa',13,7,5,2,'1970-01-01 06:00:00','2020-06-23 20:15:22'),(1635,'3f700d266c30c3b2780735bcbef760fa',13,7,5,3,'1970-01-01 06:00:00','2020-06-23 20:15:25'),(1636,'3f700d266c30c3b2780735bcbef760fa',13,7,4,4,'1970-01-01 06:00:00','2020-06-23 20:15:25'),(1637,'af3f2414a74035dd619dc55f9c8ac023',13,7,5,3,'1970-01-01 06:00:00','2020-06-23 20:26:58'),(1638,'af3f2414a74035dd619dc55f9c8ac023',13,7,4,4,'1970-01-01 06:00:00','2020-06-23 20:26:59'),(1639,'af3f2414a74035dd619dc55f9c8ac023',2,1,2,3,'1970-01-01 06:00:00','2020-06-23 20:39:27'),(1640,'af3f2414a74035dd619dc55f9c8ac023',2,1,7,2,'1970-01-01 06:00:00','2020-06-23 20:39:29'),(1641,'af3f2414a74035dd619dc55f9c8ac023',2,1,5,3,'1970-01-01 06:00:00','2020-06-23 20:39:30'),(1642,'af3f2414a74035dd619dc55f9c8ac023',2,1,4,4,'1970-01-01 06:00:00','2020-06-23 20:39:32'),(1643,'3f700d266c30c3b2780735bcbef760fa',13,7,2,4,'1970-01-01 06:00:00','2020-06-23 20:45:01'),(1644,'e6d0ff681e84978642ad2d0a5e522049',14,7,1,1,'1970-01-01 06:00:00','2020-06-23 20:45:28'),(1645,'e6d0ff681e84978642ad2d0a5e522049',14,7,2,1,'1970-01-01 06:00:00','2020-06-23 20:45:48'),(1646,'e6d0ff681e84978642ad2d0a5e522049',14,7,3,2,'1970-01-01 06:00:00','2020-06-23 20:46:25'),(1647,'e6d0ff681e84978642ad2d0a5e522049',14,7,2,2,'1970-01-01 06:00:00','2020-06-23 20:46:30'),(1648,'e6d0ff681e84978642ad2d0a5e522049',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 20:46:33'),(1649,'e6d0ff681e84978642ad2d0a5e522049',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 20:46:35'),(1650,'e6d0ff681e84978642ad2d0a5e522049',14,7,4,4,'1970-01-01 06:00:00','2020-06-23 20:46:37'),(1651,'c983b43a06f4403c19a0f4957b90d4d6',14,7,1,1,'1970-01-01 06:00:00','2020-06-23 20:47:34'),(1652,'c983b43a06f4403c19a0f4957b90d4d6',14,7,2,1,'1970-01-01 06:00:00','2020-06-23 20:47:38'),(1653,'c983b43a06f4403c19a0f4957b90d4d6',14,7,3,2,'1970-01-01 06:00:00','2020-06-23 20:47:40'),(1654,'c983b43a06f4403c19a0f4957b90d4d6',14,7,2,2,'1970-01-01 06:00:00','2020-06-23 20:47:41'),(1655,'c983b43a06f4403c19a0f4957b90d4d6',14,7,5,2,'1970-01-01 06:00:00','2020-06-23 20:47:43'),(1656,'c983b43a06f4403c19a0f4957b90d4d6',14,7,5,3,'1970-01-01 06:00:00','2020-06-23 20:47:43'),(1657,'c983b43a06f4403c19a0f4957b90d4d6',14,7,4,4,'1970-01-01 06:00:00','2020-06-23 20:47:44'),(1658,'c983b43a06f4403c19a0f4957b90d4d6',10,1,1,1,'1970-01-01 06:00:00','2020-06-23 20:48:32'),(1659,'c983b43a06f4403c19a0f4957b90d4d6',10,1,3,2,'1970-01-01 06:00:00','2020-06-23 20:48:34'),(1660,'c983b43a06f4403c19a0f4957b90d4d6',10,1,5,2,'1970-01-01 06:00:00','2020-06-23 20:48:36'),(1661,'c983b43a06f4403c19a0f4957b90d4d6',10,1,5,2,'1970-01-01 06:00:00','2020-06-23 20:48:37'),(1662,'c983b43a06f4403c19a0f4957b90d4d6',10,1,5,2,'1970-01-01 06:00:00','2020-06-23 20:48:38'),(1663,'c983b43a06f4403c19a0f4957b90d4d6',10,1,5,2,'1970-01-01 06:00:00','2020-06-23 20:48:39'),(1664,'c983b43a06f4403c19a0f4957b90d4d6',10,1,5,2,'1970-01-01 06:00:00','2020-06-23 20:48:40'),(1665,'c983b43a06f4403c19a0f4957b90d4d6',10,1,5,3,'1970-01-01 06:00:00','2020-06-23 20:48:40'),(1666,'c983b43a06f4403c19a0f4957b90d4d6',10,1,4,4,'1970-01-01 06:00:00','2020-06-23 20:48:42'),(1667,'c983b43a06f4403c19a0f4957b90d4d6',10,1,5,4,'1970-01-01 06:00:00','2020-06-23 20:48:58'),(1668,'5768845cad4c36ce4580a10c82ec9574',14,7,1,1,'1970-01-01 06:00:00','2020-06-23 20:49:42'),(1669,'5768845cad4c36ce4580a10c82ec9574',22,1,1,1,'1970-01-01 06:00:00','2020-06-23 20:56:07'),(1670,'5768845cad4c36ce4580a10c82ec9574',23,7,2,1,'1970-01-01 06:00:00','2020-06-23 20:56:59'),(1671,'5768845cad4c36ce4580a10c82ec9574',14,7,2,1,'1970-01-01 06:00:00','2020-06-23 20:58:04'),(1672,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,2,'1970-01-01 06:00:00','2020-06-23 21:00:15'),(1673,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,6,4,'1970-01-01 06:00:00','2020-06-23 21:00:19'),(1674,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,4,'1970-01-01 06:00:00','2020-06-23 21:00:23'),(1675,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,3,2,'1970-01-01 06:00:00','2020-06-23 21:00:28'),(1676,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,5,3,'1970-01-01 06:00:00','2020-06-23 21:01:13'),(1677,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,7,2,'1970-01-01 06:00:00','2020-06-23 21:01:15'),(1678,'65ef6927d53c9ccce79e5fe1618c29e1',13,7,2,2,'1970-01-01 06:00:00','2020-06-23 21:01:48'),(1679,'65ef6927d53c9ccce79e5fe1618c29e1',2,1,2,2,'1970-01-01 06:00:00','2020-06-23 21:02:14'),(1680,'5768845cad4c36ce4580a10c82ec9574',14,7,2,1,'1970-01-01 06:00:00','2020-06-23 21:02:46'),(1681,'e19542924e1d595b70b2e5a0b0340cb5',2,1,2,2,'1970-01-01 06:00:00','2020-06-24 13:32:49'),(1682,'e19542924e1d595b70b2e5a0b0340cb5',2,1,2,2,'1970-01-01 06:00:00','2020-06-24 15:57:50'),(1683,'65ef6927d53c9ccce79e5fe1618c29e1',25,16,1,1,'1970-01-01 06:00:00','2020-06-24 16:03:30'),(1684,'65ef6927d53c9ccce79e5fe1618c29e1',14,7,2,2,'1970-01-01 06:00:00','2020-06-24 16:04:57'),(1685,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,2,1,'1970-01-01 06:00:00','2020-06-24 16:05:20'),(1686,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,2,1,'1970-01-01 06:00:00','2020-06-24 16:05:31'),(1687,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,2,1,'1970-01-01 06:00:00','2020-06-24 16:05:47'),(1688,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,2,1,'1970-01-01 06:00:00','2020-06-24 16:05:51'),(1689,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,2,1,'1970-01-01 06:00:00','2020-06-24 16:06:21'),(1690,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,2,1,'1970-01-01 06:00:00','2020-06-24 16:07:07'),(1691,'65ef6927d53c9ccce79e5fe1618c29e1',25,16,2,1,'1970-01-01 06:00:00','2020-06-24 16:07:10'),(1692,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,2,1,'1970-01-01 06:00:00','2020-06-24 16:07:34'),(1693,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,3,2,'1970-01-01 06:00:00','2020-06-24 16:07:41'),(1694,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,2,1,'1970-01-01 06:00:00','2020-06-24 16:07:45'),(1695,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,3,2,'1970-01-01 06:00:00','2020-06-24 16:07:47'),(1696,'65ef6927d53c9ccce79e5fe1618c29e1',25,16,2,2,'1970-01-01 06:00:00','2020-06-24 16:07:59'),(1697,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,2,2,'1970-01-01 06:00:00','2020-06-24 16:08:06'),(1698,'c2b8f06422f83046addfa4967e465732',26,16,1,1,'1970-01-01 06:00:00','2020-06-24 16:08:18'),(1699,'c2b8f06422f83046addfa4967e465732',26,16,3,2,'1970-01-01 06:00:00','2020-06-24 16:08:24'),(1700,'c2b8f06422f83046addfa4967e465732',26,16,2,2,'1970-01-01 06:00:00','2020-06-24 16:10:21'),(1701,'c2b8f06422f83046addfa4967e465732',26,16,2,2,'1970-01-01 06:00:00','2020-06-24 16:12:58'),(1702,'c2b8f06422f83046addfa4967e465732',26,16,2,2,'1970-01-01 06:00:00','2020-06-24 16:14:02'),(1703,'c2b8f06422f83046addfa4967e465732',26,16,2,2,'1970-01-01 06:00:00','2020-06-24 16:14:11'),(1704,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,2,2,'1970-01-01 06:00:00','2020-06-24 16:24:29'),(1705,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,2,1,'1970-01-01 06:00:00','2020-06-24 16:24:33'),(1706,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,7,2,'1970-01-01 06:00:00','2020-06-24 16:24:37'),(1707,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,4,4,'1970-01-01 06:00:00','2020-06-24 16:24:41'),(1708,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,2,4,'1970-01-01 06:00:00','2020-06-24 16:24:47'),(1709,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,2,4,'1970-01-01 06:00:00','2020-06-24 16:24:50'),(1710,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,2,4,'1970-01-01 06:00:00','2020-06-24 16:24:58'),(1711,'75927fb4c769559389a684fed3bab697',14,7,1,1,'1970-01-01 06:00:00','2020-06-24 16:41:45'),(1712,'75927fb4c769559389a684fed3bab697',14,7,3,2,'1970-01-01 06:00:00','2020-06-24 16:41:52'),(1713,'75927fb4c769559389a684fed3bab697',14,7,5,3,'1970-01-01 06:00:00','2020-06-24 16:42:00'),(1714,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 16:42:04'),(1715,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 16:42:06'),(1716,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,3,2,'1970-01-01 06:00:00','2020-06-24 16:46:57'),(1717,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,2,2,'1970-01-01 06:00:00','2020-06-24 16:47:05'),(1718,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,2,2,'1970-01-01 06:00:00','2020-06-24 16:48:32'),(1719,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,2,2,'1970-01-01 06:00:00','2020-06-24 16:48:44'),(1720,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,5,3,'1970-01-01 06:00:00','2020-06-24 16:48:47'),(1721,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,7,2,'1970-01-01 06:00:00','2020-06-24 16:48:49'),(1722,'65ef6927d53c9ccce79e5fe1618c29e1',25,16,2,2,'1970-01-01 06:00:00','2020-06-24 16:48:56'),(1723,'65ef6927d53c9ccce79e5fe1618c29e1',25,16,2,2,'1970-01-01 06:00:00','2020-06-24 16:50:11'),(1724,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,2,2,'1970-01-01 06:00:00','2020-06-24 16:50:15'),(1725,'75927fb4c769559389a684fed3bab697',14,7,2,2,'1970-01-01 06:00:00','2020-06-24 16:53:30'),(1726,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 16:54:04'),(1727,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 16:54:07'),(1728,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 16:54:08'),(1729,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 16:54:10'),(1730,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 16:54:11'),(1731,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 16:54:14'),(1732,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 16:54:18'),(1733,'75927fb4c769559389a684fed3bab697',14,7,5,3,'1970-01-01 06:00:00','2020-06-24 16:54:21'),(1734,'75927fb4c769559389a684fed3bab697',14,7,7,2,'1970-01-01 06:00:00','2020-06-24 16:54:41'),(1735,'75927fb4c769559389a684fed3bab697',14,7,2,2,'1970-01-01 06:00:00','2020-06-24 16:54:50'),(1736,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 16:54:56'),(1737,'75927fb4c769559389a684fed3bab697',14,7,5,3,'1970-01-01 06:00:00','2020-06-24 16:55:05'),(1738,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,2,2,'1970-01-01 06:00:00','2020-06-24 16:55:59'),(1739,'65ef6927d53c9ccce79e5fe1618c29e1',25,16,2,2,'1970-01-01 06:00:00','2020-06-24 16:56:19'),(1740,'65ef6927d53c9ccce79e5fe1618c29e1',25,16,2,2,'1970-01-01 06:00:00','2020-06-24 16:58:21'),(1741,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,2,2,'1970-01-01 06:00:00','2020-06-24 16:58:25'),(1742,'722e335a6b6712ec1ac6ed9908dc5fd2',14,7,2,2,'1970-01-01 06:00:00','2020-06-24 17:20:56'),(1743,'65ef6927d53c9ccce79e5fe1618c29e1',10,1,2,2,'1970-01-01 06:00:00','2020-06-24 17:21:00'),(1744,'722e335a6b6712ec1ac6ed9908dc5fd2',10,1,2,1,'1970-01-01 06:00:00','2020-06-24 17:21:05'),(1745,'722e335a6b6712ec1ac6ed9908dc5fd2',10,1,3,2,'1970-01-01 06:00:00','2020-06-24 17:21:06'),(1746,'722e335a6b6712ec1ac6ed9908dc5fd2',10,1,5,2,'1970-01-01 06:00:00','2020-06-24 17:21:14'),(1747,'722e335a6b6712ec1ac6ed9908dc5fd2',10,1,5,2,'1970-01-01 06:00:00','2020-06-24 17:21:15'),(1748,'722e335a6b6712ec1ac6ed9908dc5fd2',10,1,5,3,'1970-01-01 06:00:00','2020-06-24 17:21:19'),(1749,'65ef6927d53c9ccce79e5fe1618c29e1',10,1,5,2,'1970-01-01 06:00:00','2020-06-24 17:21:19'),(1750,'65ef6927d53c9ccce79e5fe1618c29e1',10,1,5,2,'1970-01-01 06:00:00','2020-06-24 17:21:20'),(1751,'722e335a6b6712ec1ac6ed9908dc5fd2',10,1,7,2,'1970-01-01 06:00:00','2020-06-24 17:21:20'),(1752,'722e335a6b6712ec1ac6ed9908dc5fd2',10,1,5,2,'1970-01-01 06:00:00','2020-06-24 17:21:22'),(1753,'65ef6927d53c9ccce79e5fe1618c29e1',10,1,6,2,'1970-01-01 06:00:00','2020-06-24 17:21:22'),(1754,'722e335a6b6712ec1ac6ed9908dc5fd2',10,1,5,2,'1970-01-01 06:00:00','2020-06-24 17:21:23'),(1755,'65ef6927d53c9ccce79e5fe1618c29e1',10,1,6,2,'1970-01-01 06:00:00','2020-06-24 17:21:23'),(1756,'722e335a6b6712ec1ac6ed9908dc5fd2',10,1,5,2,'1970-01-01 06:00:00','2020-06-24 17:21:24'),(1757,'65ef6927d53c9ccce79e5fe1618c29e1',10,1,6,2,'1970-01-01 06:00:00','2020-06-24 17:21:25'),(1758,'65ef6927d53c9ccce79e5fe1618c29e1',10,1,6,4,'1970-01-01 06:00:00','2020-06-24 17:21:27'),(1759,'722e335a6b6712ec1ac6ed9908dc5fd2',10,1,5,2,'1970-01-01 06:00:00','2020-06-24 17:21:27'),(1760,'722e335a6b6712ec1ac6ed9908dc5fd2',10,1,5,2,'1970-01-01 06:00:00','2020-06-24 17:21:29'),(1761,'65ef6927d53c9ccce79e5fe1618c29e1',10,1,3,2,'1970-01-01 06:00:00','2020-06-24 17:21:34'),(1762,'722e335a6b6712ec1ac6ed9908dc5fd2',10,1,5,2,'1970-01-01 06:00:00','2020-06-24 17:21:34'),(1763,'722e335a6b6712ec1ac6ed9908dc5fd2',10,1,5,2,'1970-01-01 06:00:00','2020-06-24 17:21:36'),(1764,'722e335a6b6712ec1ac6ed9908dc5fd2',10,1,5,2,'1970-01-01 06:00:00','2020-06-24 17:21:37'),(1765,'722e335a6b6712ec1ac6ed9908dc5fd2',10,1,5,2,'1970-01-01 06:00:00','2020-06-24 17:21:38'),(1766,'722e335a6b6712ec1ac6ed9908dc5fd2',10,1,5,2,'1970-01-01 06:00:00','2020-06-24 17:21:38'),(1767,'722e335a6b6712ec1ac6ed9908dc5fd2',10,1,5,2,'1970-01-01 06:00:00','2020-06-24 17:21:39'),(1768,'722e335a6b6712ec1ac6ed9908dc5fd2',10,1,5,2,'1970-01-01 06:00:00','2020-06-24 17:21:40'),(1769,'722e335a6b6712ec1ac6ed9908dc5fd2',10,1,5,2,'1970-01-01 06:00:00','2020-06-24 17:21:41'),(1770,'722e335a6b6712ec1ac6ed9908dc5fd2',10,1,5,2,'1970-01-01 06:00:00','2020-06-24 17:21:42'),(1771,'722e335a6b6712ec1ac6ed9908dc5fd2',10,1,5,2,'1970-01-01 06:00:00','2020-06-24 17:21:43'),(1772,'722e335a6b6712ec1ac6ed9908dc5fd2',10,1,5,3,'1970-01-01 06:00:00','2020-06-24 17:21:44'),(1773,'722e335a6b6712ec1ac6ed9908dc5fd2',10,1,4,4,'1970-01-01 06:00:00','2020-06-24 17:21:47'),(1774,'e19542924e1d595b70b2e5a0b0340cb5',2,1,2,2,'1970-01-01 06:00:00','2020-06-24 17:21:56'),(1775,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,2,2,'1970-01-01 06:00:00','2020-06-24 17:22:25'),(1776,'75927fb4c769559389a684fed3bab697',14,7,2,3,'1970-01-01 06:00:00','2020-06-24 17:42:07'),(1777,'75927fb4c769559389a684fed3bab697',14,7,7,2,'1970-01-01 06:00:00','2020-06-24 17:42:17'),(1778,'75927fb4c769559389a684fed3bab697',14,7,5,3,'1970-01-01 06:00:00','2020-06-24 17:42:25'),(1779,'75927fb4c769559389a684fed3bab697',14,7,7,2,'1970-01-01 06:00:00','2020-06-24 17:46:43'),(1780,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:46:45'),(1781,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:46:48'),(1782,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:47:33'),(1783,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:47:54'),(1784,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:48:00'),(1785,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:48:09'),(1786,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:48:16'),(1787,'75927fb4c769559389a684fed3bab697',14,7,5,3,'1970-01-01 06:00:00','2020-06-24 17:48:48'),(1788,'75927fb4c769559389a684fed3bab697',14,7,7,2,'1970-01-01 06:00:00','2020-06-24 17:49:00'),(1789,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:49:03'),(1790,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:49:05'),(1791,'75927fb4c769559389a684fed3bab697',14,7,5,3,'1970-01-01 06:00:00','2020-06-24 17:49:08'),(1792,'75927fb4c769559389a684fed3bab697',14,7,7,2,'1970-01-01 06:00:00','2020-06-24 17:50:11'),(1793,'75927fb4c769559389a684fed3bab697',14,7,5,3,'1970-01-01 06:00:00','2020-06-24 17:50:13'),(1794,'75927fb4c769559389a684fed3bab697',14,7,7,2,'1970-01-01 06:00:00','2020-06-24 17:50:16'),(1795,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:50:18'),(1796,'75927fb4c769559389a684fed3bab697',14,7,5,3,'1970-01-01 06:00:00','2020-06-24 17:50:20'),(1797,'75927fb4c769559389a684fed3bab697',14,7,7,2,'1970-01-01 06:00:00','2020-06-24 17:50:28'),(1798,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:50:30'),(1799,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:52:35'),(1800,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:52:35'),(1801,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:52:38'),(1802,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:52:40'),(1803,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:52:44'),(1804,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:52:46'),(1805,'75927fb4c769559389a684fed3bab697',14,7,5,3,'1970-01-01 06:00:00','2020-06-24 17:54:23'),(1806,'75927fb4c769559389a684fed3bab697',14,7,7,2,'1970-01-01 06:00:00','2020-06-24 17:54:32'),(1807,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:54:35'),(1808,'75927fb4c769559389a684fed3bab697',14,7,5,3,'1970-01-01 06:00:00','2020-06-24 17:54:41'),(1809,'75927fb4c769559389a684fed3bab697',14,7,7,2,'1970-01-01 06:00:00','2020-06-24 17:54:43'),(1810,'75927fb4c769559389a684fed3bab697',14,7,5,3,'1970-01-01 06:00:00','2020-06-24 17:54:45'),(1811,'75927fb4c769559389a684fed3bab697',14,7,7,2,'1970-01-01 06:00:00','2020-06-24 17:54:48'),(1812,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:54:50'),(1813,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:54:52'),(1814,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:54:55'),(1815,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:54:56'),(1816,'75927fb4c769559389a684fed3bab697',14,7,5,3,'1970-01-01 06:00:00','2020-06-24 17:55:03'),(1817,'75927fb4c769559389a684fed3bab697',14,7,7,2,'1970-01-01 06:00:00','2020-06-24 17:55:46'),(1818,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:55:49'),(1819,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:55:53'),(1820,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:55:57'),(1821,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:55:58'),(1822,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:56:02'),(1823,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:56:12'),(1824,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:56:18'),(1825,'75927fb4c769559389a684fed3bab697',14,7,5,3,'1970-01-01 06:00:00','2020-06-24 17:56:23'),(1826,'75927fb4c769559389a684fed3bab697',14,7,7,2,'1970-01-01 06:00:00','2020-06-24 17:56:35'),(1827,'75927fb4c769559389a684fed3bab697',14,7,5,3,'1970-01-01 06:00:00','2020-06-24 17:56:37'),(1828,'75927fb4c769559389a684fed3bab697',14,7,7,2,'1970-01-01 06:00:00','2020-06-24 17:56:39'),(1829,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:56:41'),(1830,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:56:44'),(1831,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:56:47'),(1832,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:56:48'),(1833,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:56:50'),(1834,'75927fb4c769559389a684fed3bab697',14,7,5,3,'1970-01-01 06:00:00','2020-06-24 17:57:01'),(1835,'75927fb4c769559389a684fed3bab697',14,7,7,2,'1970-01-01 06:00:00','2020-06-24 17:57:07'),(1836,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:57:11'),(1837,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:57:25'),(1838,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:57:28'),(1839,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:57:29'),(1840,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:57:32'),(1841,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:57:35'),(1842,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:57:42'),(1843,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:57:46'),(1844,'75927fb4c769559389a684fed3bab697',14,7,5,3,'1970-01-01 06:00:00','2020-06-24 17:57:54'),(1845,'75927fb4c769559389a684fed3bab697',14,7,7,2,'1970-01-01 06:00:00','2020-06-24 17:57:56'),(1846,'75927fb4c769559389a684fed3bab697',14,7,5,3,'1970-01-01 06:00:00','2020-06-24 17:58:01'),(1847,'75927fb4c769559389a684fed3bab697',14,7,7,2,'1970-01-01 06:00:00','2020-06-24 17:58:03'),(1848,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:58:05'),(1849,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:58:08'),(1850,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:58:13'),(1851,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:58:14'),(1852,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:58:17'),(1853,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:58:33'),(1854,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 17:59:50'),(1855,'75927fb4c769559389a684fed3bab697',14,7,5,3,'1970-01-01 06:00:00','2020-06-24 17:59:53'),(1856,'75927fb4c769559389a684fed3bab697',14,7,7,2,'1970-01-01 06:00:00','2020-06-24 18:01:31'),(1857,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:01:35'),(1858,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:01:37'),(1859,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:01:39'),(1860,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:01:41'),(1861,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:01:43'),(1862,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:01:48'),(1863,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:01:50'),(1864,'75927fb4c769559389a684fed3bab697',14,7,5,3,'1970-01-01 06:00:00','2020-06-24 18:01:53'),(1865,'75927fb4c769559389a684fed3bab697',14,7,2,3,'1970-01-01 06:00:00','2020-06-24 18:02:04'),(1866,'75927fb4c769559389a684fed3bab697',14,7,7,2,'1970-01-01 06:00:00','2020-06-24 18:02:21'),(1867,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:02:35'),(1868,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:02:44'),(1869,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:02:51'),(1870,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:02:56'),(1871,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:03:04'),(1872,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:03:17'),(1873,'75927fb4c769559389a684fed3bab697',14,7,5,3,'1970-01-01 06:00:00','2020-06-24 18:03:34'),(1874,'75927fb4c769559389a684fed3bab697',14,7,7,2,'1970-01-01 06:00:00','2020-06-24 18:03:41'),(1875,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:03:43'),(1876,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:03:45'),(1877,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:03:46'),(1878,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:03:47'),(1879,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:03:50'),(1880,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:03:51'),(1881,'75927fb4c769559389a684fed3bab697',14,7,5,3,'1970-01-01 06:00:00','2020-06-24 18:03:58'),(1882,'75927fb4c769559389a684fed3bab697',14,7,7,2,'1970-01-01 06:00:00','2020-06-24 18:04:00'),(1883,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:04:04'),(1884,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:04:06'),(1885,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:04:07'),(1886,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:04:09'),(1887,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:04:11'),(1888,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:04:13'),(1889,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:04:16'),(1890,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:04:29'),(1891,'75927fb4c769559389a684fed3bab697',14,7,5,3,'1970-01-01 06:00:00','2020-06-24 18:04:36'),(1892,'75927fb4c769559389a684fed3bab697',14,7,7,2,'1970-01-01 06:00:00','2020-06-24 18:04:39'),(1893,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:04:41'),(1894,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:04:43'),(1895,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:04:46'),(1896,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:04:47'),(1897,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:04:49'),(1898,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:04:51'),(1899,'75927fb4c769559389a684fed3bab697',14,7,5,2,'1970-01-01 06:00:00','2020-06-24 18:04:55'),(1900,'75927fb4c769559389a684fed3bab697',14,7,5,3,'1970-01-01 06:00:00','2020-06-24 18:04:58'),(1901,'65ef6927d53c9ccce79e5fe1618c29e1',10,1,2,2,'1970-01-01 06:00:00','2020-06-24 18:08:29'),(1902,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,2,2,'1970-01-01 06:00:00','2020-06-24 18:08:44'),(1903,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,2,2,'1970-01-01 06:00:00','2020-06-24 18:11:31'),(1904,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,5,3,'1970-01-01 06:00:00','2020-06-24 18:11:34'),(1905,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,7,2,'1970-01-01 06:00:00','2020-06-24 18:11:35'),(1906,'65ef6927d53c9ccce79e5fe1618c29e1',25,16,2,2,'1970-01-01 06:00:00','2020-06-24 18:11:42'),(1907,'75927fb4c769559389a684fed3bab697',14,7,2,3,'1970-01-01 06:00:00','2020-06-24 18:11:43'),(1908,'e874f0ee23e77cc2d5cbe788055ce57d',25,16,1,1,'1970-01-01 06:00:00','2020-06-24 18:11:49'),(1909,'65ef6927d53c9ccce79e5fe1618c29e1',26,16,2,2,'1970-01-01 06:00:00','2020-06-24 18:18:07'),(1910,'af3f2414a74035dd619dc55f9c8ac023',14,7,2,4,'1970-01-01 06:00:00','2020-06-24 19:57:31'),(1911,'af3f2414a74035dd619dc55f9c8ac023',14,7,3,2,'1970-01-01 06:00:00','2020-06-24 19:57:39'),(1912,'af3f2414a74035dd619dc55f9c8ac023',14,7,5,3,'1970-01-01 06:00:00','2020-06-24 19:57:49'),(1913,'af3f2414a74035dd619dc55f9c8ac023',14,7,4,4,'1970-01-01 06:00:00','2020-06-24 19:57:50'),(1914,'af3f2414a74035dd619dc55f9c8ac023',14,7,2,4,'1970-01-01 06:00:00','2020-06-24 19:57:55'),(1915,'af3f2414a74035dd619dc55f9c8ac023',14,7,3,2,'1970-01-01 06:00:00','2020-06-24 19:58:18'),(1916,'dade0a72c7226806ff2481aa31c6ab1a',14,7,1,1,'1970-01-01 06:00:00','2020-06-24 19:58:37'),(1917,'dade0a72c7226806ff2481aa31c6ab1a',14,7,3,2,'1970-01-01 06:00:00','2020-06-24 19:58:40'),(1918,'dade0a72c7226806ff2481aa31c6ab1a',14,7,2,2,'1970-01-01 06:00:00','2020-06-24 19:58:44'),(1919,'af3f2414a74035dd619dc55f9c8ac023',26,16,1,1,'1970-01-01 06:00:00','2020-06-24 19:59:49'),(1920,'af3f2414a74035dd619dc55f9c8ac023',26,16,3,2,'1970-01-01 06:00:00','2020-06-24 19:59:56'),(1921,'af3f2414a74035dd619dc55f9c8ac023',26,16,2,2,'1970-01-01 06:00:00','2020-06-24 19:59:58'),(1922,'184e3de73361524fc5288c2f26a7709a',14,7,1,1,'1970-01-01 06:00:00','2020-06-25 13:39:07'),(1923,'184e3de73361524fc5288c2f26a7709a',14,7,3,2,'1970-01-01 06:00:00','2020-06-25 13:40:43'),(1924,'184e3de73361524fc5288c2f26a7709a',14,7,5,2,'1970-01-01 06:00:00','2020-06-25 13:44:28'),(1925,'184e3de73361524fc5288c2f26a7709a',14,7,5,2,'1970-01-01 06:00:00','2020-06-25 13:44:37'),(1926,'184e3de73361524fc5288c2f26a7709a',14,7,2,2,'1970-01-01 06:00:00','2020-06-25 13:45:08'),(1927,'184e3de73361524fc5288c2f26a7709a',14,7,5,3,'1970-01-01 06:00:00','2020-06-25 13:45:54'),(1928,'184e3de73361524fc5288c2f26a7709a',14,7,7,2,'1970-01-01 06:00:00','2020-06-25 13:45:59'),(1929,'184e3de73361524fc5288c2f26a7709a',14,7,5,2,'1970-01-01 06:00:00','2020-06-25 13:46:00'),(1930,'184e3de73361524fc5288c2f26a7709a',14,7,5,2,'1970-01-01 06:00:00','2020-06-25 13:46:08'),(1931,'184e3de73361524fc5288c2f26a7709a',14,7,5,2,'1970-01-01 06:00:00','2020-06-25 13:46:09'),(1932,'184e3de73361524fc5288c2f26a7709a',14,7,5,2,'1970-01-01 06:00:00','2020-06-25 13:46:10'),(1933,'184e3de73361524fc5288c2f26a7709a',14,7,5,2,'1970-01-01 06:00:00','2020-06-25 13:46:12'),(1934,'184e3de73361524fc5288c2f26a7709a',14,7,5,2,'1970-01-01 06:00:00','2020-06-25 13:46:14'),(1935,'184e3de73361524fc5288c2f26a7709a',14,7,5,3,'1970-01-01 06:00:00','2020-06-25 13:46:14'),(1936,'184e3de73361524fc5288c2f26a7709a',14,7,7,2,'1970-01-01 06:00:00','2020-06-25 13:46:16'),(1937,'184e3de73361524fc5288c2f26a7709a',14,7,5,2,'1970-01-01 06:00:00','2020-06-25 13:46:18'),(1938,'184e3de73361524fc5288c2f26a7709a',14,7,5,2,'1970-01-01 06:00:00','2020-06-25 13:46:20'),(1939,'184e3de73361524fc5288c2f26a7709a',14,7,5,3,'1970-01-01 06:00:00','2020-06-25 13:46:22'),(1940,'184e3de73361524fc5288c2f26a7709a',14,7,7,2,'1970-01-01 06:00:00','2020-06-25 13:46:24'),(1941,'184e3de73361524fc5288c2f26a7709a',14,7,5,2,'1970-01-01 06:00:00','2020-06-25 13:46:28'),(1942,'184e3de73361524fc5288c2f26a7709a',14,7,5,3,'1970-01-01 06:00:00','2020-06-25 13:46:33'),(1943,'184e3de73361524fc5288c2f26a7709a',14,7,2,3,'1970-01-01 06:00:00','2020-06-25 13:47:52'),(1944,'184e3de73361524fc5288c2f26a7709a',14,7,6,4,'1970-01-01 06:00:00','2020-06-25 13:47:59'),(1945,'184e3de73361524fc5288c2f26a7709a',14,7,6,4,'1970-01-01 06:00:00','2020-06-25 13:48:30'),(1946,'184e3de73361524fc5288c2f26a7709a',14,7,2,4,'1970-01-01 06:00:00','2020-06-25 13:48:45'),(1947,'184e3de73361524fc5288c2f26a7709a',14,7,6,2,'1970-01-01 06:00:00','2020-06-25 13:48:53'),(1948,'184e3de73361524fc5288c2f26a7709a',14,7,6,4,'1970-01-01 06:00:00','2020-06-25 13:48:56'),(1949,'184e3de73361524fc5288c2f26a7709a',14,7,6,2,'1970-01-01 06:00:00','2020-06-25 13:49:02'),(1950,'184e3de73361524fc5288c2f26a7709a',14,7,2,2,'1970-01-01 06:00:00','2020-06-25 13:49:11'),(1951,'184e3de73361524fc5288c2f26a7709a',14,7,6,4,'1970-01-01 06:00:00','2020-06-25 13:49:13'),(1952,'184e3de73361524fc5288c2f26a7709a',14,7,6,2,'1970-01-01 06:00:00','2020-06-25 13:49:23'),(1953,'184e3de73361524fc5288c2f26a7709a',14,7,6,2,'1970-01-01 06:00:00','2020-06-25 13:49:26'),(1954,'184e3de73361524fc5288c2f26a7709a',14,7,6,4,'1970-01-01 06:00:00','2020-06-25 13:49:27'),(1955,'184e3de73361524fc5288c2f26a7709a',14,7,2,4,'1970-01-01 06:00:00','2020-06-25 13:49:36'),(1956,'184e3de73361524fc5288c2f26a7709a',14,7,6,2,'1970-01-01 06:00:00','2020-06-25 13:49:52'),(1957,'184e3de73361524fc5288c2f26a7709a',14,7,6,4,'1970-01-01 06:00:00','2020-06-25 13:49:52'),(1958,'184e3de73361524fc5288c2f26a7709a',14,7,2,4,'1970-01-01 06:00:00','2020-06-25 13:53:20'),(1959,'184e3de73361524fc5288c2f26a7709a',14,7,3,2,'1970-01-01 06:00:00','2020-06-25 13:53:29'),(1960,'184e3de73361524fc5288c2f26a7709a',14,7,5,3,'1970-01-01 06:00:00','2020-06-25 13:53:36'),(1961,'184e3de73361524fc5288c2f26a7709a',14,7,3,2,'1970-01-01 06:00:00','2020-06-25 13:54:35'),(1962,'184e3de73361524fc5288c2f26a7709a',14,7,6,4,'1970-01-01 06:00:00','2020-06-25 13:54:39'),(1963,'184e3de73361524fc5288c2f26a7709a',14,7,3,2,'1970-01-01 06:00:00','2020-06-25 13:54:40'),(1964,'184e3de73361524fc5288c2f26a7709a',14,7,6,4,'1970-01-01 06:00:00','2020-06-25 13:54:43'),(1965,'184e3de73361524fc5288c2f26a7709a',14,7,3,2,'1970-01-01 06:00:00','2020-06-25 13:54:46'),(1966,'184e3de73361524fc5288c2f26a7709a',14,7,4,4,'1970-01-01 06:00:00','2020-06-25 14:00:46'),(1967,'184e3de73361524fc5288c2f26a7709a',14,7,3,2,'1970-01-01 06:00:00','2020-06-25 14:00:58'),(1968,'184e3de73361524fc5288c2f26a7709a',14,7,5,3,'1970-01-01 06:00:00','2020-06-25 14:01:01'),(1969,'184e3de73361524fc5288c2f26a7709a',14,7,4,4,'1970-01-01 06:00:00','2020-06-25 14:01:09'),(1970,'184e3de73361524fc5288c2f26a7709a',14,7,6,2,'1970-01-01 06:00:00','2020-06-25 14:01:24'),(1971,'184e3de73361524fc5288c2f26a7709a',14,7,6,3,'1970-01-01 06:00:00','2020-06-25 14:01:26'),(1972,'184e3de73361524fc5288c2f26a7709a',14,7,6,2,'1970-01-01 06:00:00','2020-06-25 14:01:28'),(1973,'184e3de73361524fc5288c2f26a7709a',14,7,6,4,'1970-01-01 06:00:00','2020-06-25 14:01:31'),(1974,'184e3de73361524fc5288c2f26a7709a',14,7,6,2,'1970-01-01 06:00:00','2020-06-25 14:01:38'),(1975,'184e3de73361524fc5288c2f26a7709a',14,7,5,3,'1970-01-01 06:00:00','2020-06-25 14:02:57'),(1976,'996609d46087a273705bb9d70da265de',14,7,1,1,'1970-01-01 06:00:00','2020-06-25 19:14:44'),(1977,'996609d46087a273705bb9d70da265de',14,7,3,2,'1970-01-01 06:00:00','2020-06-25 19:43:22'),(1978,'996609d46087a273705bb9d70da265de',14,7,5,3,'1970-01-01 06:00:00','2020-06-25 19:43:26'),(1979,'996609d46087a273705bb9d70da265de',14,7,5,2,'1970-01-01 06:00:00','2020-06-25 19:43:29'),(1980,'996609d46087a273705bb9d70da265de',14,7,5,2,'1970-01-01 06:00:00','2020-06-25 19:43:37'),(1981,'996609d46087a273705bb9d70da265de',14,7,5,2,'1970-01-01 06:00:00','2020-06-25 19:43:39'),(1982,'996609d46087a273705bb9d70da265de',14,7,3,2,'1970-01-01 06:00:00','2020-06-25 19:49:26'),(1983,'996609d46087a273705bb9d70da265de',14,7,5,3,'1970-01-01 06:00:00','2020-06-25 19:49:35'),(1984,'996609d46087a273705bb9d70da265de',14,7,5,2,'1970-01-01 06:00:00','2020-06-25 19:49:36'),(1985,'996609d46087a273705bb9d70da265de',14,7,5,2,'1970-01-01 06:00:00','2020-06-25 19:49:43'),(1986,'996609d46087a273705bb9d70da265de',14,7,5,2,'1970-01-01 06:00:00','2020-06-25 19:49:50'),(1987,'b8ae1c5fb6e462867bcc27e728948570',2,1,1,1,'1970-01-01 06:00:00','2020-06-26 01:03:42'),(1988,'b8ae1c5fb6e462867bcc27e728948570',25,16,1,1,'1970-01-01 06:00:00','2020-06-26 01:03:53'),(1989,'2745ca71668dbdd6cfd3dd26939556cd',26,16,1,1,'1970-01-01 06:00:00','2020-06-26 01:07:36'),(1990,'2745ca71668dbdd6cfd3dd26939556cd',26,16,3,2,'1970-01-01 06:00:00','2020-06-26 01:07:41'),(1991,'2745ca71668dbdd6cfd3dd26939556cd',26,16,2,1,'1970-01-01 06:00:00','2020-06-26 01:07:48'),(1992,'2745ca71668dbdd6cfd3dd26939556cd',26,16,3,2,'1970-01-01 06:00:00','2020-06-26 01:07:50'),(1993,'2745ca71668dbdd6cfd3dd26939556cd',26,16,2,2,'1970-01-01 06:00:00','2020-06-26 01:07:52'),(1994,'b8ae1c5fb6e462867bcc27e728948570',2,1,3,2,'1970-01-01 06:00:00','2020-06-26 01:10:30'),(1995,'2745ca71668dbdd6cfd3dd26939556cd',27,17,1,1,'1970-01-01 06:00:00','2020-06-26 01:13:50'),(1996,'b8ae1c5fb6e462867bcc27e728948570',2,1,2,2,'1970-01-01 06:00:00','2020-06-26 01:14:16'),(1997,'2745ca71668dbdd6cfd3dd26939556cd',27,17,2,1,'1970-01-01 06:00:00','2020-06-26 01:14:24'),(1998,'2745ca71668dbdd6cfd3dd26939556cd',27,17,2,1,'1970-01-01 06:00:00','2020-06-26 01:14:26'),(1999,'2745ca71668dbdd6cfd3dd26939556cd',27,17,2,1,'1970-01-01 06:00:00','2020-06-26 01:15:04'),(2000,'1b311995acc224a41c69bc837aef8b6b',27,17,1,1,'1970-01-01 06:00:00','2020-06-26 01:15:13'),(2001,'1b311995acc224a41c69bc837aef8b6b',27,17,2,1,'1970-01-01 06:00:00','2020-06-26 01:15:53'),(2002,'1b311995acc224a41c69bc837aef8b6b',27,17,3,2,'1970-01-01 06:00:00','2020-06-26 01:15:54'),(2003,'1b311995acc224a41c69bc837aef8b6b',27,17,2,1,'1970-01-01 06:00:00','2020-06-26 01:15:59'),(2004,'1b311995acc224a41c69bc837aef8b6b',27,17,3,2,'1970-01-01 06:00:00','2020-06-26 01:16:00'),(2005,'1b311995acc224a41c69bc837aef8b6b',27,17,2,2,'1970-01-01 06:00:00','2020-06-26 01:16:01'),(2006,'1b311995acc224a41c69bc837aef8b6b',27,17,2,2,'1970-01-01 06:00:00','2020-06-26 01:16:37'),(2007,'1b311995acc224a41c69bc837aef8b6b',27,17,2,2,'1970-01-01 06:00:00','2020-06-26 01:16:48'),(2008,'1b311995acc224a41c69bc837aef8b6b',27,17,5,3,'1970-01-01 06:00:00','2020-06-26 01:16:53'),(2009,'1b311995acc224a41c69bc837aef8b6b',27,17,4,4,'1970-01-01 06:00:00','2020-06-26 01:16:54'),(2010,'1b311995acc224a41c69bc837aef8b6b',27,17,3,2,'1970-01-01 06:00:00','2020-06-26 01:16:55'),(2011,'1b311995acc224a41c69bc837aef8b6b',27,17,5,3,'1970-01-01 06:00:00','2020-06-26 01:16:57'),(2012,'1b311995acc224a41c69bc837aef8b6b',27,17,7,2,'1970-01-01 06:00:00','2020-06-26 01:16:58'),(2013,'1b311995acc224a41c69bc837aef8b6b',27,17,2,2,'1970-01-01 06:00:00','2020-06-26 01:17:56'),(2014,'1b311995acc224a41c69bc837aef8b6b',27,17,5,3,'1970-01-01 06:00:00','2020-06-26 01:18:00'),(2015,'1b311995acc224a41c69bc837aef8b6b',27,17,7,2,'1970-01-01 06:00:00','2020-06-26 01:18:02'),(2016,'1b311995acc224a41c69bc837aef8b6b',27,17,5,3,'1970-01-01 06:00:00','2020-06-26 01:18:03'),(2017,'1b311995acc224a41c69bc837aef8b6b',27,17,7,2,'1970-01-01 06:00:00','2020-06-26 01:18:04'),(2018,'1b311995acc224a41c69bc837aef8b6b',27,17,5,3,'1970-01-01 06:00:00','2020-06-26 01:18:06'),(2019,'1b311995acc224a41c69bc837aef8b6b',27,17,7,2,'1970-01-01 06:00:00','2020-06-26 01:18:08'),(2020,'1b311995acc224a41c69bc837aef8b6b',27,17,2,2,'1970-01-01 06:00:00','2020-06-26 01:18:38'),(2021,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 01:18:40'),(2022,'1b311995acc224a41c69bc837aef8b6b',27,17,5,3,'1970-01-01 06:00:00','2020-06-26 01:18:42'),(2023,'1b311995acc224a41c69bc837aef8b6b',27,17,7,2,'1970-01-01 06:00:00','2020-06-26 01:18:43'),(2024,'1b311995acc224a41c69bc837aef8b6b',27,17,2,2,'1970-01-01 06:00:00','2020-06-26 01:19:55'),(2025,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 01:19:57'),(2026,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 01:19:59'),(2027,'1b311995acc224a41c69bc837aef8b6b',27,17,5,3,'1970-01-01 06:00:00','2020-06-26 01:19:59'),(2028,'1b311995acc224a41c69bc837aef8b6b',27,17,7,2,'1970-01-01 06:00:00','2020-06-26 01:20:01'),(2029,'1b311995acc224a41c69bc837aef8b6b',27,17,2,2,'1970-01-01 06:00:00','2020-06-26 15:40:26'),(2030,'1b311995acc224a41c69bc837aef8b6b',27,17,2,2,'1970-01-01 06:00:00','2020-06-26 15:42:08'),(2031,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 15:42:10'),(2032,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 15:42:11'),(2033,'1b311995acc224a41c69bc837aef8b6b',27,17,5,3,'1970-01-01 06:00:00','2020-06-26 15:42:12'),(2034,'1b311995acc224a41c69bc837aef8b6b',27,17,7,2,'1970-01-01 06:00:00','2020-06-26 15:42:14'),(2035,'1b311995acc224a41c69bc837aef8b6b',27,17,2,2,'1970-01-01 06:00:00','2020-06-26 15:42:50'),(2036,'1b311995acc224a41c69bc837aef8b6b',27,17,2,2,'1970-01-01 06:00:00','2020-06-26 15:44:20'),(2037,'1b311995acc224a41c69bc837aef8b6b',27,17,2,2,'1970-01-01 06:00:00','2020-06-26 15:46:05'),(2038,'b8ae1c5fb6e462867bcc27e728948570',2,1,2,2,'1970-01-01 06:00:00','2020-06-26 15:47:02'),(2039,'1b311995acc224a41c69bc837aef8b6b',27,17,2,2,'1970-01-01 06:00:00','2020-06-26 15:48:27'),(2040,'1b311995acc224a41c69bc837aef8b6b',27,17,2,2,'1970-01-01 06:00:00','2020-06-26 15:52:20'),(2041,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 15:52:24'),(2042,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 15:52:24'),(2043,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 15:52:26'),(2044,'1b311995acc224a41c69bc837aef8b6b',27,17,5,3,'1970-01-01 06:00:00','2020-06-26 15:52:29'),(2045,'1b311995acc224a41c69bc837aef8b6b',27,17,7,2,'1970-01-01 06:00:00','2020-06-26 15:52:30'),(2046,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 15:52:32'),(2047,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 15:52:33'),(2048,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 15:52:35'),(2049,'1b311995acc224a41c69bc837aef8b6b',27,17,5,3,'1970-01-01 06:00:00','2020-06-26 15:52:37'),(2050,'1b311995acc224a41c69bc837aef8b6b',27,17,7,2,'1970-01-01 06:00:00','2020-06-26 15:52:39'),(2051,'1b311995acc224a41c69bc837aef8b6b',27,17,2,2,'1970-01-01 06:00:00','2020-06-26 15:54:41'),(2052,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 15:54:44'),(2053,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 15:54:47'),(2054,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 15:54:52'),(2055,'1b311995acc224a41c69bc837aef8b6b',27,17,5,3,'1970-01-01 06:00:00','2020-06-26 15:54:55'),(2056,'1b311995acc224a41c69bc837aef8b6b',27,17,7,2,'1970-01-01 06:00:00','2020-06-26 15:54:56'),(2057,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 15:55:00'),(2058,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 15:55:01'),(2059,'1b311995acc224a41c69bc837aef8b6b',27,17,5,3,'1970-01-01 06:00:00','2020-06-26 15:55:04'),(2060,'1b311995acc224a41c69bc837aef8b6b',27,17,7,2,'1970-01-01 06:00:00','2020-06-26 15:55:06'),(2061,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 15:55:08'),(2062,'1b311995acc224a41c69bc837aef8b6b',27,17,5,3,'1970-01-01 06:00:00','2020-06-26 15:55:10'),(2063,'1b311995acc224a41c69bc837aef8b6b',27,17,7,2,'1970-01-01 06:00:00','2020-06-26 15:55:11'),(2064,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 15:55:14'),(2065,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 15:55:15'),(2066,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 15:55:19'),(2067,'1b311995acc224a41c69bc837aef8b6b',27,17,2,2,'1970-01-01 06:00:00','2020-06-26 15:59:20'),(2068,'1b311995acc224a41c69bc837aef8b6b',27,17,6,4,'1970-01-01 06:00:00','2020-06-26 15:59:22'),(2069,'1b311995acc224a41c69bc837aef8b6b',27,17,3,2,'1970-01-01 06:00:00','2020-06-26 15:59:26'),(2070,'1b311995acc224a41c69bc837aef8b6b',27,17,2,2,'1970-01-01 06:00:00','2020-06-26 15:59:33'),(2071,'1b311995acc224a41c69bc837aef8b6b',27,17,2,2,'1970-01-01 06:00:00','2020-06-26 16:01:28'),(2072,'1b311995acc224a41c69bc837aef8b6b',27,17,2,2,'1970-01-01 06:00:00','2020-06-26 16:07:28'),(2073,'1b311995acc224a41c69bc837aef8b6b',27,17,2,2,'1970-01-01 06:00:00','2020-06-26 16:11:53'),(2074,'1b311995acc224a41c69bc837aef8b6b',27,17,2,2,'1970-01-01 06:00:00','2020-06-26 16:15:40'),(2075,'1b311995acc224a41c69bc837aef8b6b',27,17,2,2,'1970-01-01 06:00:00','2020-06-26 16:22:10'),(2076,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 16:22:13'),(2077,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 16:22:15'),(2078,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 16:22:18'),(2079,'1b311995acc224a41c69bc837aef8b6b',27,17,5,3,'1970-01-01 06:00:00','2020-06-26 16:22:21'),(2080,'1b311995acc224a41c69bc837aef8b6b',27,17,7,2,'1970-01-01 06:00:00','2020-06-26 16:22:23'),(2081,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 16:22:24'),(2082,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 16:22:25'),(2083,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 16:22:28'),(2084,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 16:22:30'),(2085,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 16:22:34'),(2086,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 16:22:42'),(2087,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 16:22:47'),(2088,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 16:22:49'),(2089,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 16:22:52'),(2090,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 16:22:55'),(2091,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 16:23:00'),(2092,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 16:23:02'),(2093,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 16:23:10'),(2094,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 16:23:15'),(2095,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 16:23:21'),(2096,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 16:23:25'),(2097,'1b311995acc224a41c69bc837aef8b6b',27,17,5,2,'1970-01-01 06:00:00','2020-06-26 16:23:30'),(2098,'1b311995acc224a41c69bc837aef8b6b',27,17,5,3,'1970-01-01 06:00:00','2020-06-26 16:23:33'),(2099,'1b311995acc224a41c69bc837aef8b6b',27,17,7,2,'1970-01-01 06:00:00','2020-06-26 16:23:36'),(2100,'eff8f8a05a4b4b4c343972d4e89fc1a0',2,1,1,1,'1970-01-01 06:00:00','2020-06-26 16:23:50'),(2101,'eff8f8a05a4b4b4c343972d4e89fc1a0',28,17,1,1,'1970-01-01 06:00:00','2020-06-26 16:24:02'),(2102,'eff8f8a05a4b4b4c343972d4e89fc1a0',28,17,2,1,'1970-01-01 06:00:00','2020-06-26 16:24:47'),(2103,'1b311995acc224a41c69bc837aef8b6b',27,17,2,2,'1970-01-01 06:00:00','2020-06-26 16:29:09');
/*!40000 ALTER TABLE `treeInteraction` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`cmetree`@`%`*/ /*!50003 TRIGGER treeInteractionTrigger
BEFORE INSERT ON `wp_cmetree`.`treeInteraction`
FOR EACH ROW
BEGIN
IF NEW.interactionCreatedAt = '1970-01-01 %' THEN
SET NEW.interactionCreatedAt = NOW();
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `treeInteractionElement`
--

DROP TABLE IF EXISTS `treeInteractionElement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `treeInteractionElement` (
  `interactionElID` int(11) NOT NULL AUTO_INCREMENT,
  `interactionID` int(11) DEFAULT NULL,
  `elID` int(11) DEFAULT NULL,
  PRIMARY KEY (`interactionElID`),
  KEY `elIDIDx` (`elID`),
  KEY `interactionElInteractionID` (`interactionID`),
  CONSTRAINT `interactionElID` FOREIGN KEY (`elID`) REFERENCES `treeElement` (`elID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `interactionElInteractionID` FOREIGN KEY (`interactionID`) REFERENCES `treeInteraction` (`interactionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1043 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `treeInteractionElement`
--

LOCK TABLES `treeInteractionElement` WRITE;
/*!40000 ALTER TABLE `treeInteractionElement` DISABLE KEYS */;
INSERT INTO `treeInteractionElement` VALUES (1,2,9),(2,3,13),(3,15,3),(4,16,9),(5,17,12),(6,18,16),(7,19,19),(8,20,22),(9,21,34),(10,22,27),(11,23,30),(12,24,42),(13,25,77),(14,35,3),(15,36,9),(16,37,13),(17,39,3),(18,40,9),(19,41,12),(20,42,17),(21,43,31),(22,44,74),(23,45,41),(24,49,3),(25,50,10),(26,52,4),(27,54,3),(28,55,10),(29,57,3),(30,58,9),(31,59,12),(32,60,15),(33,62,3),(34,63,9),(35,64,12),(36,65,16),(37,66,20),(38,68,3),(39,69,9),(40,70,12),(41,71,16),(42,72,19),(43,73,23),(44,75,3),(45,76,9),(46,77,12),(47,78,17),(48,79,31),(49,80,73),(50,81,41),(51,82,44),(52,83,47),(53,84,51),(54,85,85),(55,90,4),(56,96,3),(57,97,9),(58,98,13),(59,100,4),(60,102,3),(61,103,9),(62,104,12),(63,105,16),(64,106,20),(65,109,3),(66,110,9),(67,111,12),(68,112,17),(69,113,30),(70,114,41),(71,115,44),(72,116,47),(73,117,50),(74,118,87),(75,119,93),(76,120,103),(77,121,105),(78,122,107),(79,123,109),(80,124,111),(81,134,4),(82,138,3),(83,139,9),(84,140,12),(85,141,16),(86,142,20),(87,144,4),(88,151,3),(89,152,9),(90,153,13),(91,156,3),(92,157,9),(93,158,13),(94,161,3),(95,162,9),(96,165,12),(97,167,13),(98,170,3),(99,171,10),(100,174,3),(101,176,4),(102,178,3),(103,179,9),(104,180,12),(105,181,15),(106,185,16),(107,186,20),(108,189,19),(109,190,23),(110,192,22),(111,194,3),(112,195,9),(113,196,13),(114,200,3),(115,201,34),(116,202,10),(117,204,3),(118,205,9),(119,206,13),(120,208,3),(121,209,9),(122,210,28),(123,212,12),(124,213,27),(125,214,30),(126,215,42),(127,216,77),(128,218,78),(129,219,44),(130,220,17),(131,221,47),(132,222,31),(133,223,74),(134,224,41),(135,225,44),(136,226,47),(137,227,50),(138,228,87),(139,229,93),(140,230,103),(141,231,105),(142,232,107),(143,233,109),(144,234,50),(145,235,111),(146,236,87),(147,237,92),(148,238,95),(149,239,103),(150,240,105),(151,241,107),(152,243,107),(153,244,109),(154,245,111),(155,249,3),(156,250,9),(157,251,13),(158,253,3),(159,254,9),(160,255,13),(161,261,3),(162,262,9),(163,263,12),(164,264,17),(165,265,30),(166,266,41),(167,267,44),(168,268,47),(169,269,50),(170,270,87),(171,271,92),(172,272,94),(173,273,96),(174,274,99),(175,275,102),(176,277,3),(177,278,9),(178,279,12),(179,280,17),(180,281,30),(181,282,41),(182,283,44),(183,284,47),(184,285,50),(185,286,87),(186,287,93),(187,288,103),(188,289,105),(189,290,107),(190,291,109),(191,292,111),(192,295,3),(193,296,9),(194,297,13),(195,299,3),(196,300,9),(197,301,12),(198,302,16),(199,303,19),(200,304,22),(201,305,34),(202,306,28),(203,327,3),(204,328,9),(205,329,12),(206,330,16),(207,331,19),(208,332,22),(209,333,34),(210,334,27),(211,335,30),(212,336,42),(213,337,78),(214,338,44),(215,339,47),(216,340,50),(217,341,87),(218,342,93),(219,343,103),(220,344,105),(221,345,107),(222,346,108),(223,348,4),(224,350,3),(225,351,9),(226,363,3),(227,364,9),(228,365,12),(229,366,17),(230,367,30),(231,369,3),(232,370,9),(233,371,13),(234,373,20),(235,380,3),(236,381,9),(237,382,13),(238,384,3),(239,385,9),(240,386,12),(241,387,17),(242,388,30),(243,389,41),(244,390,44),(245,391,47),(246,392,50),(247,393,87),(248,394,93),(249,395,103),(250,396,105),(251,397,107),(252,398,108),(253,402,3),(254,403,9),(255,404,12),(256,405,16),(257,406,20),(258,411,4),(259,413,3),(260,414,10),(261,416,4),(262,418,3),(263,419,9),(264,420,12),(265,421,15),(266,423,3),(267,424,9),(268,425,12),(269,426,17),(270,427,31),(271,428,75),(272,429,42),(273,430,77),(274,437,3),(275,438,9),(276,439,13),(277,450,4),(278,452,3),(279,455,3),(280,456,9),(281,463,12),(282,464,17),(283,467,4),(284,474,3),(285,475,9),(286,477,9),(287,478,13),(288,480,12),(289,481,16),(290,482,19),(291,483,22),(292,484,34),(293,485,27),(294,486,75),(295,487,42),(296,488,78),(297,489,44),(298,490,47),(299,491,50),(300,492,54),(301,502,3),(302,503,9),(303,504,12),(304,505,17),(305,506,30),(306,507,41),(307,508,44),(308,509,47),(309,510,50),(310,511,87),(311,512,92),(312,513,95),(313,514,103),(314,515,105),(315,516,107),(316,517,109),(317,518,111),(318,526,3),(319,527,9),(320,528,12),(321,529,17),(322,530,30),(323,531,41),(324,532,44),(325,533,47),(326,534,50),(327,535,87),(328,536,93),(329,537,103),(330,538,105),(331,539,107),(332,540,109),(333,541,111),(334,544,3),(335,545,9),(336,546,12),(337,547,17),(338,548,30),(339,549,41),(340,550,44),(341,551,47),(342,552,50),(343,553,87),(344,554,92),(345,555,94),(346,556,97),(347,557,103),(348,558,105),(349,559,107),(350,560,109),(351,561,111),(352,567,3),(353,568,9),(354,569,13),(355,571,3),(356,572,10),(357,574,3),(358,575,9),(359,576,12),(360,577,17),(361,578,30),(362,579,42),(363,580,77),(364,582,4),(365,584,3),(366,585,9),(367,586,12),(368,587,16),(369,588,20),(370,598,3),(371,599,9),(372,600,12),(373,603,3),(374,604,9),(375,605,12),(376,606,17),(377,607,30),(378,608,41),(379,609,44),(380,610,47),(381,611,50),(382,612,87),(383,613,92),(384,614,95),(385,615,103),(386,616,105),(387,617,107),(388,618,109),(389,619,111),(390,633,3),(391,634,9),(392,635,12),(393,645,4),(394,647,3),(395,648,9),(396,649,12),(397,650,16),(398,651,19),(399,652,22),(400,653,34),(401,654,27),(402,655,30),(403,656,41),(404,657,44),(405,658,47),(406,659,50),(407,660,87),(408,661,93),(409,662,103),(410,663,105),(411,664,107),(412,665,109),(413,666,111),(414,673,3),(415,674,10),(416,676,3),(417,677,9),(418,678,13),(419,685,4),(420,687,3),(421,690,9),(422,691,12),(423,692,16),(424,693,19),(425,694,22),(426,695,27),(427,696,75),(428,697,42),(429,698,78),(430,700,3),(431,701,10),(432,704,3),(433,705,9),(434,710,9),(435,713,12),(436,714,17),(437,716,10),(438,718,3),(439,719,9),(440,720,12),(441,721,17),(442,730,3),(443,731,9),(444,732,13),(445,734,3),(446,735,9),(447,736,13),(448,740,3),(449,741,9),(450,742,12),(451,743,16),(452,744,19),(453,745,22),(454,746,35),(455,750,4),(456,752,3),(457,753,9),(458,754,13),(459,756,3),(460,757,9),(461,759,9),(462,760,12),(463,761,17),(464,762,30),(465,763,41),(466,764,44),(467,765,47),(468,766,50),(469,767,87),(470,768,92),(471,769,95),(472,770,103),(473,771,105),(474,772,107),(475,773,109),(476,774,111),(477,778,3),(478,779,9),(479,780,13),(480,787,3),(481,788,9),(482,789,13),(483,791,3),(484,792,9),(485,793,12),(486,807,3),(487,808,9),(488,809,12),(489,810,15),(490,812,3),(491,818,3),(492,819,9),(493,820,13),(494,822,4),(495,825,4),(496,828,3),(497,829,9),(498,830,12),(499,831,16),(500,832,19),(501,833,22),(502,834,34),(503,835,27),(504,836,30),(505,837,41),(506,838,44),(507,839,47),(508,840,50),(509,841,87),(510,842,92),(511,843,95),(512,844,103),(513,845,105),(514,846,107),(515,847,109),(516,848,111),(517,852,4),(518,854,16),(519,855,19),(520,856,22),(521,857,34),(522,858,27),(523,859,31),(524,860,42),(525,862,3),(526,863,9),(527,864,12),(528,865,16),(529,866,19),(530,872,3),(531,873,9),(532,874,12),(533,880,3),(534,890,130),(535,891,127),(536,892,127),(537,893,130),(538,894,130),(539,895,127),(540,898,127),(541,899,130),(542,901,129),(543,903,127),(544,905,135),(545,906,133),(546,908,127),(547,909,130),(548,913,4),(549,915,4),(550,917,3),(551,918,9),(552,919,12),(553,925,3),(554,930,3),(555,932,9),(556,933,12),(557,934,17),(558,935,30),(559,936,3),(560,937,41),(561,938,9),(562,939,44),(563,940,12),(564,941,47),(565,942,50),(566,943,17),(567,944,87),(568,945,93),(569,946,103),(570,947,30),(571,948,105),(572,949,41),(573,950,107),(574,951,44),(575,952,109),(576,953,111),(577,954,47),(578,955,50),(579,957,87),(580,958,93),(581,959,103),(582,960,105),(583,961,107),(584,962,109),(585,963,111),(586,965,3),(587,966,9),(588,967,12),(589,968,16),(590,969,19),(591,970,22),(592,971,34),(593,972,27),(594,973,30),(595,974,41),(596,975,44),(597,976,47),(598,977,50),(599,978,87),(600,980,4),(601,982,4),(602,984,3),(603,985,10),(604,987,3),(605,988,9),(606,989,12),(607,990,16),(608,991,19),(609,992,22),(610,993,34),(611,994,27),(612,995,30),(613,996,41),(614,997,44),(615,1000,207),(616,1006,207),(617,1007,211),(618,1009,208),(619,1016,207),(620,1017,211),(621,1018,209),(622,1026,229),(623,1028,230),(624,1030,231),(625,1076,256),(626,1086,93),(627,1087,103),(628,1088,105),(629,1089,107),(630,1090,109),(631,1091,111),(632,1107,256),(633,1110,257),(634,1113,258),(635,1117,256),(636,1120,257),(637,1121,267),(638,1126,256),(639,1129,257),(640,1130,267),(641,1131,275),(642,1132,292),(643,1133,299),(644,1134,303),(645,1136,268),(646,1138,257),(647,1139,267),(648,1140,277),(649,1141,289),(650,1142,292),(651,1143,299),(652,1144,302),(653,1145,305),(654,1147,293),(655,1148,296),(656,1150,267),(657,1151,276),(658,1153,257),(659,1154,268),(660,1158,256),(661,1161,257),(662,1162,267),(663,1163,276),(664,1165,257),(665,1166,267),(666,1167,275),(667,1168,292),(668,1169,299),(669,1170,302),(670,1171,305),(671,1173,275),(672,1174,292),(673,1175,300),(674,1176,313),(675,1177,309),(676,1178,315),(677,1179,319),(678,1188,256),(679,1190,257),(680,1191,267),(681,1192,275),(682,1193,292),(683,1194,299),(684,1195,302),(685,1196,305),(686,1222,207),(687,1223,211),(688,1229,256),(689,1231,257),(690,1232,268),(691,1234,257),(692,1235,267),(693,1236,275),(694,1237,292),(695,1238,299),(696,1239,302),(697,1240,305),(698,1242,306),(699,1256,207),(700,1257,211),(701,1282,237),(702,1285,238),(703,1301,3),(704,1302,9),(705,1303,13),(706,1308,257),(707,1309,268),(708,1344,256),(709,1345,257),(710,1346,258),(711,1348,264),(712,1351,284),(713,1353,257),(714,1354,267),(715,1355,275),(716,1356,292),(717,1357,300),(718,1358,313),(719,1359,309),(720,1360,315),(721,1361,319),(722,1363,257),(723,1364,268),(724,1366,257),(725,1367,268),(726,1369,258),(727,1370,264),(728,1371,285),(729,1372,267),(730,1373,276),(731,1380,256),(732,1383,256),(733,1386,257),(734,1388,267),(735,1389,275),(736,1391,292),(737,1393,299),(738,1394,302),(739,1395,256),(740,1396,305),(741,1399,257),(742,1400,267),(743,1401,275),(744,1402,292),(745,1403,300),(746,1404,313),(747,1405,310),(748,1407,256),(749,1409,257),(750,1410,268),(751,1412,256),(752,1414,257),(753,1415,267),(754,1416,275),(755,1417,292),(756,1418,300),(757,1419,313),(758,1420,310),(759,1423,257),(760,1425,256),(761,1428,256),(762,1430,257),(763,1431,268),(764,1433,258),(765,1434,264),(766,1435,285),(767,1436,267),(768,1437,276),(769,1439,264),(770,1441,284),(771,1442,256),(772,1445,257),(773,1446,267),(774,1447,258),(775,1448,277),(776,1452,257),(777,1453,267),(778,1454,277),(779,1517,256),(780,1519,257),(781,1520,267),(782,1521,276),(783,1523,257),(784,1524,268),(785,1537,256),(786,1567,256),(787,1589,258),(788,1590,264),(789,1591,284),(790,1596,256),(791,1598,258),(792,1599,264),(793,1600,285),(794,1601,268),(795,1603,258),(796,1606,264),(797,1607,285),(798,1608,268),(799,1611,256),(800,1616,258),(801,1617,264),(802,1618,284),(803,1624,256),(804,1626,257),(805,1627,268),(806,1634,258),(807,1635,265),(808,1637,256),(809,1641,4),(810,1648,258),(811,1649,265),(812,1655,257),(813,1656,268),(814,1660,3),(815,1661,9),(816,1662,12),(817,1663,16),(818,1664,19),(819,1665,23),(820,1667,45),(821,1676,256),(822,1713,256),(823,1714,257),(824,1715,258),(825,1720,344),(826,1726,264),(827,1727,285),(828,1728,267),(829,1729,275),(830,1730,292),(831,1731,300),(832,1732,313),(833,1733,310),(834,1736,258),(835,1737,265),(836,1746,3),(837,1747,9),(838,1748,13),(839,1749,47),(840,1750,51),(841,1752,3),(842,1754,9),(843,1756,12),(844,1759,17),(845,1760,30),(846,1762,41),(847,1763,44),(848,1764,47),(849,1765,50),(850,1766,87),(851,1767,93),(852,1768,103),(853,1769,105),(854,1770,107),(855,1771,109),(856,1772,111),(857,1778,256),(858,1780,257),(859,1781,267),(860,1782,277),(861,1783,289),(862,1784,292),(863,1785,299),(864,1786,302),(865,1787,305),(866,1789,257),(867,1790,267),(868,1791,276),(869,1793,256),(870,1795,257),(871,1796,268),(872,1798,258),(873,1799,264),(874,1800,285),(875,1801,267),(876,1802,277),(877,1803,289),(878,1804,293),(879,1805,296),(880,1807,258),(881,1808,265),(882,1810,256),(883,1812,257),(884,1813,267),(885,1814,275),(886,1815,293),(887,1816,296),(888,1818,257),(889,1819,267),(890,1820,275),(891,1821,292),(892,1822,300),(893,1823,313),(894,1824,309),(895,1825,316),(896,1827,256),(897,1829,257),(898,1830,267),(899,1831,275),(900,1832,292),(901,1833,300),(902,1834,312),(903,1836,257),(904,1837,267),(905,1838,275),(906,1839,292),(907,1840,300),(908,1841,313),(909,1842,309),(910,1843,315),(911,1844,320),(912,1846,256),(913,1848,257),(914,1849,267),(915,1850,275),(916,1851,292),(917,1852,299),(918,1853,302),(919,1854,306),(920,1855,310),(921,1857,257),(922,1858,267),(923,1859,275),(924,1860,292),(925,1861,300),(926,1862,313),(927,1863,309),(928,1864,316),(929,1867,257),(930,1868,267),(931,1869,275),(932,1870,292),(933,1871,300),(934,1872,313),(935,1873,310),(936,1875,257),(937,1876,267),(938,1877,275),(939,1878,292),(940,1879,300),(941,1880,313),(942,1881,310),(943,1883,257),(944,1884,267),(945,1885,275),(946,1886,292),(947,1887,300),(948,1888,313),(949,1889,309),(950,1890,315),(951,1891,320),(952,1893,257),(953,1894,267),(954,1895,275),(955,1896,292),(956,1897,300),(957,1898,313),(958,1899,309),(959,1900,316),(960,1904,344),(961,1912,256),(962,1924,257),(963,1925,264),(964,1927,284),(965,1929,257),(966,1930,267),(967,1931,275),(968,1932,292),(969,1933,299),(970,1934,302),(971,1935,305),(972,1937,257),(973,1938,267),(974,1939,276),(975,1941,258),(976,1942,265),(977,1960,256),(978,1968,256),(979,1975,276),(980,1978,256),(981,1979,257),(982,1980,258),(983,1981,257),(984,1983,256),(985,1984,257),(986,1985,267),(987,1986,275),(988,2008,382),(989,2011,382),(990,2014,382),(991,2016,383),(992,2018,382),(993,2021,383),(994,2022,390),(995,2025,383),(996,2026,390),(997,2027,393),(998,2031,383),(999,2032,390),(1000,2033,393),(1001,2041,383),(1002,2042,390),(1003,2043,393),(1004,2044,397),(1005,2046,383),(1006,2047,390),(1007,2048,393),(1008,2049,395),(1009,2052,383),(1010,2053,390),(1011,2054,393),(1012,2055,395),(1013,2057,383),(1014,2058,390),(1015,2059,392),(1016,2061,383),(1017,2062,389),(1018,2064,383),(1019,2065,390),(1020,2066,393),(1021,2076,383),(1022,2077,390),(1023,2078,393),(1024,2079,395),(1025,2081,383),(1026,2082,390),(1027,2083,393),(1028,2084,397),(1029,2085,412),(1030,2086,420),(1031,2087,426),(1032,2088,430),(1033,2089,441),(1034,2090,447),(1035,2091,449),(1036,2092,452),(1037,2093,456),(1038,2094,462),(1039,2095,465),(1040,2096,468),(1041,2097,471),(1042,2098,474);
/*!40000 ALTER TABLE `treeInteractionElement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `treeInteractionEnd`
--

DROP TABLE IF EXISTS `treeInteractionEnd`;
/*!50001 DROP VIEW IF EXISTS `treeInteractionEnd`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeInteractionEnd` AS SELECT 
 1 AS `interactionID`,
 1 AS `userID`,
 1 AS `treeID`,
 1 AS `endID`,
 1 AS `interactionCreatedAt`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `treeInteractionHistory`
--

DROP TABLE IF EXISTS `treeInteractionHistory`;
/*!50001 DROP VIEW IF EXISTS `treeInteractionHistory`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeInteractionHistory` AS SELECT 
 1 AS `interactionID`,
 1 AS `userID`,
 1 AS `treeID`,
 1 AS `destinationStateType`,
 1 AS `destinationStateID`,
 1 AS `interactionCreatedAt`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `treeInteractionLoad`
--

DROP TABLE IF EXISTS `treeInteractionLoad`;
/*!50001 DROP VIEW IF EXISTS `treeInteractionLoad`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeInteractionLoad` AS SELECT 
 1 AS `interactionID`,
 1 AS `userID`,
 1 AS `treeID`,
 1 AS `interactionCreatedAt`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `treeInteractionOption`
--

DROP TABLE IF EXISTS `treeInteractionOption`;
/*!50001 DROP VIEW IF EXISTS `treeInteractionOption`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeInteractionOption` AS SELECT 
 1 AS `interactionID`,
 1 AS `userID`,
 1 AS `treeID`,
 1 AS `optionID`,
 1 AS `destinationStateType`,
 1 AS `destinationStateID`,
 1 AS `interactionCreatedAt`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `treeInteractionOverview`
--

DROP TABLE IF EXISTS `treeInteractionOverview`;
/*!50001 DROP VIEW IF EXISTS `treeInteractionOverview`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeInteractionOverview` AS SELECT 
 1 AS `interactionID`,
 1 AS `userID`,
 1 AS `treeID`,
 1 AS `interactionCreatedAt`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `treeInteractionQuestion`
--

DROP TABLE IF EXISTS `treeInteractionQuestion`;
/*!50001 DROP VIEW IF EXISTS `treeInteractionQuestion`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeInteractionQuestion` AS SELECT 
 1 AS `interactionID`,
 1 AS `userID`,
 1 AS `treeID`,
 1 AS `questionID`,
 1 AS `interactionCreatedAt`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `treeInteractionReload`
--

DROP TABLE IF EXISTS `treeInteractionReload`;
/*!50001 DROP VIEW IF EXISTS `treeInteractionReload`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeInteractionReload` AS SELECT 
 1 AS `interactionID`,
 1 AS `userID`,
 1 AS `treeID`,
 1 AS `interactionCreatedAt`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `treeInteractionStart`
--

DROP TABLE IF EXISTS `treeInteractionStart`;
/*!50001 DROP VIEW IF EXISTS `treeInteractionStart`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeInteractionStart` AS SELECT 
 1 AS `interactionID`,
 1 AS `userID`,
 1 AS `treeID`,
 1 AS `destinationStateType`,
 1 AS `destinationStateID`,
 1 AS `interactionCreatedAt`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `treeInteractionType`
--

DROP TABLE IF EXISTS `treeInteractionType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `treeInteractionType` (
  `interactionTypeID` int(11) NOT NULL AUTO_INCREMENT,
  `interactionType` varchar(45) NOT NULL DEFAULT '',
  PRIMARY KEY (`interactionTypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `treeInteractionType`
--

LOCK TABLES `treeInteractionType` WRITE;
/*!40000 ALTER TABLE `treeInteractionType` DISABLE KEYS */;
INSERT INTO `treeInteractionType` VALUES (1,'load'),(2,'reload'),(3,'start'),(4,'overview'),(5,'option'),(6,'history'),(7,'restart');
/*!40000 ALTER TABLE `treeInteractionType` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `treeInteractions`
--

DROP TABLE IF EXISTS `treeInteractions`;
/*!50001 DROP VIEW IF EXISTS `treeInteractions`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeInteractions` AS SELECT 
 1 AS `interactionID`,
 1 AS `userID`,
 1 AS `treeID`,
 1 AS `interactionType`,
 1 AS `stateType`,
 1 AS `interactionCreatedAt`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `treeInteractionsMaxDateByUserAndTree`
--

DROP TABLE IF EXISTS `treeInteractionsMaxDateByUserAndTree`;
/*!50001 DROP VIEW IF EXISTS `treeInteractionsMaxDateByUserAndTree`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeInteractionsMaxDateByUserAndTree` AS SELECT 
 1 AS `userID`,
 1 AS `treeID`,
 1 AS `interactionCreatedAt`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `treeOption`
--

DROP TABLE IF EXISTS `treeOption`;
/*!50001 DROP VIEW IF EXISTS `treeOption`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeOption` AS SELECT 
 1 AS `optionID`,
 1 AS `treeID`,
 1 AS `questionID`,
 1 AS `title`,
 1 AS `content`,
 1 AS `order`,
 1 AS `destinationID`,
 1 AS `destinationType`,
 1 AS `deleted`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `treeQuestion`
--

DROP TABLE IF EXISTS `treeQuestion`;
/*!50001 DROP VIEW IF EXISTS `treeQuestion`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeQuestion` AS SELECT 
 1 AS `questionID`,
 1 AS `treeID`,
 1 AS `groupID`,
 1 AS `title`,
 1 AS `content`,
 1 AS `order`,
 1 AS `deleted`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `treeSite`
--

DROP TABLE IF EXISTS `treeSite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `treeSite` (
  `siteID` int(11) NOT NULL AUTO_INCREMENT,
  `siteName` varchar(255) NOT NULL DEFAULT '',
  `siteHost` varchar(255) NOT NULL DEFAULT '',
  `siteCreatedAt` timestamp NOT NULL DEFAULT '1970-01-01 06:00:00',
  `siteUpdatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `siteIsDev` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`siteID`),
  UNIQUE KEY `treeSiteSiteHost` (`siteHost`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `treeSite`
--

LOCK TABLES `treeSite` WRITE;
/*!40000 ALTER TABLE `treeSite` DISABLE KEYS */;
INSERT INTO `treeSite` VALUES (1,'Example Decision Tree','tree.mediaengagement.org','1970-01-01 06:00:00','2018-06-15 18:39:27',0),(2,'Decision Tree â€“ Center for Media Engagement','mediaengagement.org','1970-01-01 06:00:00','2018-09-20 22:29:06',0),(3,'Decision Tree - Center for Media Engagement','mediaengagement.test','1970-01-01 06:00:00','2018-10-09 20:45:18',0),(4,'Decision Tree - Center for Media Engagement','cmengagetest.staging.wpengine.com','1970-01-01 06:00:00','2018-11-30 18:17:36',0),(5,'Example Decision Tree','cmetree.wpengine.com','1970-01-01 06:00:00','2019-08-14 14:19:20',0);
/*!40000 ALTER TABLE `treeSite` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`cmetree`@`%`*/ /*!50003 TRIGGER treeSiteTrigger
BEFORE INSERT ON `wp_cmetree`.`treeSite`
FOR EACH ROW
BEGIN
IF NEW.siteCreatedAt = '1970-01-01 %' THEN
SET NEW.siteCreatedAt = NOW();
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary table structure for view `treeStart`
--

DROP TABLE IF EXISTS `treeStart`;
/*!50001 DROP VIEW IF EXISTS `treeStart`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeStart` AS SELECT 
 1 AS `startID`,
 1 AS `treeID`,
 1 AS `title`,
 1 AS `content`,
 1 AS `destinationID`,
 1 AS `deleted`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `treeState`
--

DROP TABLE IF EXISTS `treeState`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `treeState` (
  `stateID` int(11) NOT NULL AUTO_INCREMENT,
  `interactionID` int(11) DEFAULT NULL,
  `elID` int(11) DEFAULT NULL,
  PRIMARY KEY (`stateID`),
  KEY `elIDIDx` (`elID`),
  KEY `stateInteractionID` (`interactionID`),
  CONSTRAINT `stateElID` FOREIGN KEY (`elID`) REFERENCES `treeElement` (`elID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `stateInteractionID` FOREIGN KEY (`interactionID`) REFERENCES `treeInteraction` (`interactionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1247 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `treeState`
--

LOCK TABLES `treeState` WRITE;
/*!40000 ALTER TABLE `treeState` DISABLE KEYS */;
INSERT INTO `treeState` VALUES (1,2,11),(2,3,6),(3,12,2),(4,14,2),(5,15,8),(6,16,11),(7,17,14),(8,18,18),(9,19,21),(10,20,33),(11,21,26),(12,22,29),(13,23,40),(14,24,62),(15,25,6),(16,34,2),(17,35,8),(18,36,11),(19,37,6),(20,39,8),(21,40,11),(22,41,14),(23,42,29),(24,43,61),(25,44,40),(26,45,43),(27,48,2),(28,49,8),(29,50,6),(30,52,6),(31,54,8),(32,55,6),(33,57,8),(34,58,11),(35,59,14),(36,60,6),(37,62,8),(38,63,11),(39,64,14),(40,65,18),(41,66,6),(42,68,8),(43,69,11),(44,70,14),(45,71,18),(46,72,21),(47,73,6),(48,75,8),(49,76,11),(50,77,14),(51,78,29),(52,79,61),(53,80,40),(54,81,43),(55,82,46),(56,83,49),(57,84,66),(58,85,6),(59,87,6),(60,89,2),(61,90,6),(62,92,2),(63,95,2),(64,96,8),(65,97,11),(66,98,6),(67,100,6),(68,102,8),(69,103,11),(70,104,14),(71,105,18),(72,106,6),(73,108,2),(74,109,8),(75,110,11),(76,111,14),(77,112,29),(78,113,40),(79,114,43),(80,115,46),(81,116,49),(82,117,52),(83,118,67),(84,119,68),(85,120,69),(86,121,70),(87,122,71),(88,123,72),(89,124,5),(90,126,70),(91,127,69),(92,128,67),(93,129,68),(94,133,2),(95,134,6),(96,137,2),(97,138,8),(98,139,11),(99,140,14),(100,141,18),(101,142,6),(102,145,2),(103,148,2),(104,150,2),(105,151,8),(106,152,11),(107,153,6),(108,155,2),(109,156,8),(110,157,11),(111,158,6),(112,160,2),(113,161,8),(114,162,11),(115,163,8),(116,164,11),(117,165,14),(118,166,11),(119,167,6),(120,169,2),(121,170,8),(122,171,6),(123,173,2),(124,174,8),(125,175,2),(126,176,6),(127,178,8),(128,179,11),(129,180,14),(130,181,6),(131,182,14),(132,183,6),(133,184,14),(134,185,18),(135,186,6),(136,188,18),(137,189,21),(138,190,6),(139,191,21),(140,192,33),(141,193,2),(142,194,8),(143,195,11),(144,196,6),(145,197,21),(146,198,33),(147,200,8),(148,201,26),(149,202,6),(150,204,8),(151,205,11),(152,206,6),(153,208,8),(154,209,11),(155,210,6),(156,211,26),(157,212,14),(158,213,29),(159,214,40),(160,215,62),(161,216,6),(162,217,62),(163,218,43),(164,219,46),(165,220,29),(166,221,49),(167,222,61),(168,223,40),(169,224,43),(170,225,46),(171,226,49),(172,227,52),(173,228,67),(174,229,68),(175,230,69),(176,231,70),(177,232,71),(178,233,72),(179,234,52),(180,235,5),(181,236,67),(182,237,88),(183,238,68),(184,239,69),(185,240,70),(186,241,71),(187,242,70),(188,243,71),(189,244,72),(190,245,5),(191,248,2),(192,249,8),(193,250,11),(194,251,6),(195,253,8),(196,254,11),(197,255,6),(198,258,2),(199,260,2),(200,261,8),(201,262,11),(202,263,14),(203,264,29),(204,265,40),(205,266,43),(206,267,46),(207,268,49),(208,269,52),(209,270,67),(210,271,88),(211,272,89),(212,273,90),(213,274,68),(214,275,6),(215,277,8),(216,278,11),(217,279,14),(218,280,29),(219,281,40),(220,282,43),(221,283,46),(222,284,49),(223,285,52),(224,286,67),(225,287,68),(226,288,69),(227,289,70),(228,290,71),(229,291,72),(230,292,5),(231,294,2),(232,295,8),(233,296,11),(234,297,6),(235,299,8),(236,300,11),(237,301,14),(238,302,18),(239,303,21),(240,304,33),(241,305,26),(242,306,6),(243,326,2),(244,327,8),(245,328,11),(246,329,14),(247,330,18),(248,331,21),(249,332,33),(250,333,26),(251,334,29),(252,335,40),(253,336,62),(254,337,43),(255,338,46),(256,339,49),(257,340,52),(258,341,67),(259,342,68),(260,343,69),(261,344,70),(262,345,71),(263,346,6),(264,348,6),(265,350,8),(266,351,11),(267,359,2),(268,362,2),(269,363,8),(270,364,11),(271,365,14),(272,366,29),(273,367,40),(274,368,2),(275,369,8),(276,370,11),(277,371,6),(278,374,2),(279,376,2),(280,379,2),(281,380,8),(282,381,11),(283,382,6),(284,384,8),(285,385,11),(286,386,14),(287,387,29),(288,388,40),(289,389,43),(290,390,46),(291,391,49),(292,392,52),(293,393,67),(294,394,68),(295,395,69),(296,396,70),(297,397,71),(298,398,6),(299,401,2),(300,402,8),(301,403,11),(302,404,14),(303,405,18),(304,406,6),(305,410,2),(306,411,6),(307,413,8),(308,414,6),(309,416,6),(310,418,8),(311,419,11),(312,420,14),(313,421,6),(314,423,8),(315,424,11),(316,425,14),(317,426,29),(318,427,61),(319,428,40),(320,429,62),(321,430,6),(322,436,2),(323,437,8),(324,438,11),(325,439,6),(326,449,2),(327,450,6),(328,454,2),(329,455,8),(330,456,11),(331,458,8),(332,459,11),(333,460,2),(334,461,8),(335,462,11),(336,463,14),(337,464,29),(338,466,2),(339,467,6),(340,473,2),(341,474,8),(342,475,11),(343,476,8),(344,477,11),(345,478,6),(346,493,2),(347,501,2),(348,502,8),(349,503,11),(350,504,14),(351,505,29),(352,506,40),(353,507,43),(354,508,46),(355,509,49),(356,510,52),(357,511,67),(358,512,88),(359,513,68),(360,514,69),(361,515,70),(362,516,71),(363,517,72),(364,518,5),(365,524,2),(366,525,2),(367,526,8),(368,527,11),(369,528,14),(370,529,29),(371,530,40),(372,531,43),(373,532,46),(374,533,49),(375,534,52),(376,535,67),(377,536,68),(378,537,69),(379,538,70),(380,539,71),(381,540,72),(382,541,5),(383,543,2),(384,544,8),(385,545,11),(386,546,14),(387,547,29),(388,548,40),(389,549,43),(390,550,46),(391,551,49),(392,552,52),(393,553,67),(394,554,88),(395,555,89),(396,556,68),(397,557,69),(398,558,70),(399,559,71),(400,560,72),(401,561,5),(402,566,2),(403,567,8),(404,568,11),(405,569,6),(406,571,8),(407,572,6),(408,574,8),(409,575,11),(410,576,14),(411,577,29),(412,578,40),(413,579,62),(414,580,6),(415,582,6),(416,584,8),(417,585,11),(418,586,14),(419,587,18),(420,588,6),(421,592,69),(422,593,52),(423,594,46),(424,595,40),(425,596,11),(426,597,2),(427,598,8),(428,599,11),(429,600,14),(430,602,2),(431,603,8),(432,604,11),(433,605,14),(434,606,29),(435,607,40),(436,608,43),(437,609,46),(438,610,49),(439,611,52),(440,612,67),(441,613,88),(442,614,68),(443,615,69),(444,616,70),(445,617,71),(446,618,72),(447,619,5),(448,622,2),(449,632,2),(450,633,8),(451,634,11),(452,635,14),(453,644,2),(454,645,6),(455,647,8),(456,648,11),(457,649,14),(458,650,18),(459,651,21),(460,652,33),(461,653,26),(462,654,29),(463,655,40),(464,656,43),(465,657,46),(466,658,49),(467,659,52),(468,660,67),(469,661,68),(470,662,69),(471,663,70),(472,664,71),(473,665,72),(474,666,5),(475,672,2),(476,673,8),(477,674,6),(478,676,8),(479,677,11),(480,678,6),(481,684,2),(482,685,6),(483,687,8),(484,688,2),(485,699,2),(486,700,8),(487,701,6),(488,703,2),(489,704,8),(490,705,11),(491,707,8),(492,708,6),(493,709,8),(494,710,11),(495,711,8),(496,712,11),(497,713,14),(498,714,29),(499,715,8),(500,716,6),(501,718,8),(502,719,11),(503,720,14),(504,721,29),(505,729,2),(506,730,8),(507,731,11),(508,732,6),(509,734,8),(510,735,11),(511,736,6),(512,739,2),(513,740,8),(514,741,11),(515,742,14),(516,743,18),(517,744,21),(518,745,33),(519,746,6),(520,749,2),(521,750,6),(522,752,8),(523,753,11),(524,754,6),(525,756,8),(526,757,11),(527,758,8),(528,759,11),(529,760,14),(530,761,29),(531,762,40),(532,763,43),(533,764,46),(534,765,49),(535,766,52),(536,767,67),(537,768,88),(538,769,68),(539,770,69),(540,771,70),(541,772,71),(542,773,72),(543,774,5),(544,777,2),(545,778,8),(546,779,11),(547,780,6),(548,782,2),(549,786,2),(550,787,8),(551,788,11),(552,789,6),(553,790,2),(554,791,8),(555,792,11),(556,793,14),(557,806,2),(558,807,8),(559,808,11),(560,809,14),(561,810,6),(562,818,8),(563,819,11),(564,820,6),(565,822,6),(566,824,2),(567,825,6),(568,827,2),(569,828,8),(570,829,11),(571,830,14),(572,831,18),(573,832,21),(574,833,33),(575,834,26),(576,835,29),(577,836,40),(578,837,43),(579,838,46),(580,839,49),(581,840,52),(582,841,67),(583,842,88),(584,843,68),(585,844,69),(586,845,70),(587,846,71),(588,847,72),(589,848,5),(590,851,2),(591,852,6),(592,861,2),(593,862,8),(594,863,11),(595,864,14),(596,865,18),(597,866,21),(598,867,2),(599,871,2),(600,872,8),(601,873,11),(602,874,14),(603,875,8),(604,879,2),(605,880,8),(606,882,126),(607,884,126),(608,887,126),(609,897,126),(610,898,128),(611,899,124),(612,901,124),(613,903,128),(614,905,132),(615,906,124),(616,908,128),(617,909,124),(618,912,2),(619,913,6),(620,915,6),(621,917,8),(622,918,11),(623,919,14),(624,921,2),(625,923,2),(626,925,8),(627,929,2),(628,930,8),(629,932,11),(630,933,14),(631,934,29),(632,935,40),(633,936,8),(634,937,43),(635,938,11),(636,939,46),(637,940,14),(638,941,49),(639,942,52),(640,943,29),(641,944,67),(642,945,68),(643,946,69),(644,947,40),(645,948,70),(646,949,43),(647,950,71),(648,951,46),(649,952,72),(650,953,5),(651,954,49),(652,955,52),(653,957,67),(654,958,68),(655,959,69),(656,960,70),(657,961,71),(658,962,72),(659,963,5),(660,964,2),(661,965,8),(662,966,11),(663,967,14),(664,968,18),(665,969,21),(666,970,33),(667,971,26),(668,972,29),(669,973,40),(670,974,43),(671,975,46),(672,976,49),(673,977,52),(674,978,67),(675,980,6),(676,982,6),(677,984,8),(678,985,6),(679,987,8),(680,988,11),(681,989,14),(682,990,18),(683,991,21),(684,992,33),(685,993,26),(686,994,29),(687,995,40),(688,996,43),(689,997,46),(690,999,206),(691,1000,210),(692,1005,206),(693,1006,210),(694,1007,215),(695,1009,213),(696,1012,206),(697,1014,206),(698,1016,210),(699,1017,215),(700,1018,210),(701,1024,228),(702,1026,233),(703,1028,233),(704,1030,233),(705,1037,236),(706,1043,243),(707,1048,243),(708,1051,243),(709,1057,236),(710,1062,251),(711,1066,251),(712,1069,235),(713,1073,235),(714,1076,233),(715,1079,235),(716,1081,235),(717,1082,233),(718,1083,235),(719,1086,68),(720,1087,69),(721,1088,70),(722,1089,71),(723,1090,72),(724,1091,5),(725,1093,2),(726,1095,2),(727,1097,235),(728,1107,233),(729,1109,235),(730,1110,262),(731,1112,235),(732,1113,233),(733,1115,235),(734,1117,233),(735,1119,235),(736,1120,266),(737,1121,262),(738,1126,233),(739,1128,235),(740,1129,266),(741,1130,274),(742,1131,291),(743,1132,298),(744,1133,301),(745,1134,327),(746,1135,266),(747,1136,262),(748,1137,235),(749,1138,266),(750,1139,274),(751,1140,288),(752,1141,291),(753,1142,298),(754,1143,301),(755,1144,304),(756,1145,307),(757,1146,291),(758,1147,294),(759,1148,297),(760,1149,266),(761,1150,274),(762,1151,287),(763,1153,266),(764,1154,262),(765,1156,235),(766,1158,233),(767,1160,235),(768,1161,266),(769,1162,274),(770,1163,287),(771,1165,266),(772,1166,274),(773,1167,291),(774,1168,298),(775,1169,301),(776,1170,304),(777,1171,307),(778,1172,274),(779,1173,291),(780,1174,298),(781,1175,311),(782,1176,308),(783,1177,314),(784,1178,317),(785,1179,322),(786,1186,235),(787,1188,233),(788,1190,266),(789,1191,274),(790,1192,291),(791,1193,298),(792,1194,301),(793,1195,304),(794,1196,307),(795,1199,243),(796,1214,206),(797,1220,206),(798,1222,210),(799,1223,215),(800,1227,235),(801,1229,233),(802,1231,266),(803,1232,262),(804,1234,266),(805,1235,274),(806,1236,291),(807,1237,298),(808,1238,301),(809,1239,304),(810,1240,307),(811,1243,235),(812,1247,2),(813,1254,206),(814,1256,210),(815,1257,215),(816,1271,236),(817,1280,236),(818,1282,240),(819,1284,236),(820,1285,240),(821,1293,206),(822,1297,206),(823,1300,2),(824,1301,8),(825,1302,11),(826,1303,6),(827,1306,235),(828,1308,266),(829,1309,262),(830,1319,206),(831,1323,2),(832,1326,235),(833,1331,2),(834,1333,2),(835,1336,235),(836,1339,235),(837,1343,235),(838,1344,233),(839,1345,266),(840,1346,263),(841,1348,283),(842,1351,233),(843,1353,266),(844,1354,274),(845,1355,291),(846,1356,298),(847,1357,311),(848,1358,308),(849,1359,314),(850,1360,317),(851,1361,322),(852,1363,266),(853,1364,262),(854,1366,266),(855,1367,262),(856,1369,263),(857,1370,283),(858,1371,266),(859,1372,274),(860,1373,287),(861,1380,233),(862,1382,235),(863,1383,233),(864,1385,235),(865,1386,266),(866,1388,274),(867,1389,291),(868,1391,298),(869,1392,235),(870,1393,301),(871,1394,304),(872,1395,233),(873,1396,307),(874,1398,235),(875,1399,266),(876,1400,274),(877,1401,291),(878,1402,298),(879,1403,311),(880,1404,308),(881,1405,322),(882,1407,233),(883,1409,266),(884,1410,262),(885,1412,233),(886,1414,266),(887,1415,274),(888,1416,291),(889,1417,298),(890,1418,311),(891,1419,308),(892,1420,322),(893,1422,235),(894,1423,266),(895,1424,235),(896,1425,233),(897,1427,235),(898,1428,233),(899,1430,266),(900,1431,262),(901,1433,263),(902,1434,283),(903,1435,266),(904,1436,274),(905,1437,287),(906,1438,263),(907,1439,283),(908,1441,233),(909,1442,233),(910,1445,266),(911,1446,274),(912,1447,263),(913,1448,288),(914,1449,235),(915,1451,235),(916,1452,266),(917,1453,274),(918,1454,288),(919,1472,235),(920,1476,2),(921,1478,2),(922,1503,333),(923,1509,333),(924,1515,235),(925,1517,233),(926,1519,266),(927,1520,274),(928,1521,287),(929,1523,266),(930,1524,262),(931,1528,235),(932,1535,235),(933,1537,233),(934,1544,235),(935,1549,235),(936,1565,235),(937,1567,233),(938,1571,235),(939,1573,235),(940,1575,235),(941,1578,235),(942,1580,235),(943,1582,235),(944,1587,235),(945,1589,263),(946,1590,283),(947,1591,233),(948,1594,235),(949,1596,233),(950,1598,263),(951,1599,283),(952,1600,266),(953,1601,262),(954,1603,263),(955,1606,283),(956,1607,266),(957,1608,262),(958,1610,235),(959,1611,233),(960,1614,235),(961,1616,263),(962,1617,283),(963,1618,233),(964,1623,235),(965,1624,233),(966,1626,266),(967,1627,262),(968,1632,235),(969,1634,263),(970,1635,233),(971,1637,233),(972,1641,6),(973,1646,235),(974,1648,263),(975,1649,233),(976,1653,235),(977,1655,266),(978,1656,262),(979,1659,2),(980,1660,8),(981,1661,11),(982,1662,14),(983,1663,18),(984,1664,21),(985,1665,6),(986,1675,235),(987,1676,233),(988,1693,343),(989,1695,343),(990,1699,343),(991,1712,235),(992,1713,233),(993,1714,266),(994,1715,263),(995,1716,343),(996,1720,347),(997,1726,283),(998,1727,266),(999,1728,274),(1000,1729,291),(1001,1730,298),(1002,1731,311),(1003,1732,308),(1004,1733,322),(1005,1736,263),(1006,1737,233),(1007,1745,2),(1008,1746,8),(1009,1747,11),(1010,1748,6),(1011,1749,49),(1012,1750,66),(1013,1752,8),(1014,1753,26),(1015,1754,11),(1016,1755,18),(1017,1756,14),(1018,1757,11),(1019,1759,29),(1020,1760,40),(1021,1761,2),(1022,1762,43),(1023,1763,46),(1024,1764,49),(1025,1765,52),(1026,1766,67),(1027,1767,68),(1028,1768,69),(1029,1769,70),(1030,1770,71),(1031,1771,72),(1032,1772,5),(1033,1778,233),(1034,1780,266),(1035,1781,274),(1036,1782,288),(1037,1783,291),(1038,1784,298),(1039,1785,301),(1040,1786,304),(1041,1787,307),(1042,1789,266),(1043,1790,274),(1044,1791,287),(1045,1793,233),(1046,1795,266),(1047,1796,262),(1048,1798,263),(1049,1799,283),(1050,1800,266),(1051,1801,274),(1052,1802,288),(1053,1803,291),(1054,1804,294),(1055,1805,297),(1056,1807,263),(1057,1808,233),(1058,1810,233),(1059,1812,266),(1060,1813,274),(1061,1814,291),(1062,1815,294),(1063,1816,297),(1064,1818,266),(1065,1819,274),(1066,1820,291),(1067,1821,298),(1068,1822,311),(1069,1823,308),(1070,1824,314),(1071,1825,233),(1072,1827,233),(1073,1829,266),(1074,1830,274),(1075,1831,291),(1076,1832,298),(1077,1833,311),(1078,1834,307),(1079,1836,266),(1080,1837,274),(1081,1838,291),(1082,1839,298),(1083,1840,311),(1084,1841,308),(1085,1842,314),(1086,1843,317),(1087,1844,233),(1088,1846,233),(1089,1848,266),(1090,1849,274),(1091,1850,291),(1092,1851,298),(1093,1852,301),(1094,1853,304),(1095,1854,308),(1096,1855,322),(1097,1857,266),(1098,1858,274),(1099,1859,291),(1100,1860,298),(1101,1861,311),(1102,1862,308),(1103,1863,314),(1104,1864,233),(1105,1867,266),(1106,1868,274),(1107,1869,291),(1108,1870,298),(1109,1871,311),(1110,1872,308),(1111,1873,322),(1112,1875,266),(1113,1876,274),(1114,1877,291),(1115,1878,298),(1116,1879,311),(1117,1880,308),(1118,1881,322),(1119,1883,266),(1120,1884,274),(1121,1885,291),(1122,1886,298),(1123,1887,311),(1124,1888,308),(1125,1889,314),(1126,1890,317),(1127,1891,233),(1128,1893,266),(1129,1894,274),(1130,1895,291),(1131,1896,298),(1132,1897,311),(1133,1898,308),(1134,1899,314),(1135,1900,233),(1136,1904,347),(1137,1911,235),(1138,1912,233),(1139,1915,235),(1140,1917,235),(1141,1920,343),(1142,1923,235),(1143,1924,266),(1144,1925,283),(1145,1927,233),(1146,1929,266),(1147,1930,274),(1148,1931,291),(1149,1932,298),(1150,1933,301),(1151,1934,304),(1152,1935,307),(1153,1937,266),(1154,1938,274),(1155,1939,287),(1156,1941,263),(1157,1942,233),(1158,1947,235),(1159,1949,235),(1160,1952,263),(1161,1953,235),(1162,1956,235),(1163,1959,235),(1164,1960,233),(1165,1961,235),(1166,1963,235),(1167,1965,235),(1168,1967,235),(1169,1968,233),(1170,1970,235),(1171,1971,233),(1172,1972,235),(1173,1974,235),(1174,1975,287),(1175,1977,235),(1176,1978,233),(1177,1979,266),(1178,1980,263),(1179,1981,266),(1180,1982,235),(1181,1983,233),(1182,1984,266),(1183,1985,274),(1184,1986,291),(1185,1990,343),(1186,1992,343),(1187,1994,2),(1188,2002,381),(1189,2004,381),(1190,2008,384),(1191,2010,381),(1192,2011,384),(1193,2014,384),(1194,2016,385),(1195,2018,384),(1196,2021,388),(1197,2022,384),(1198,2025,388),(1199,2026,391),(1200,2027,384),(1201,2031,388),(1202,2032,391),(1203,2033,384),(1204,2041,388),(1205,2042,391),(1206,2043,394),(1207,2044,384),(1208,2046,388),(1209,2047,391),(1210,2048,394),(1211,2049,385),(1212,2052,388),(1213,2053,391),(1214,2054,394),(1215,2055,385),(1216,2057,388),(1217,2058,391),(1218,2059,385),(1219,2061,388),(1220,2062,385),(1221,2064,388),(1222,2065,391),(1223,2066,394),(1224,2069,381),(1225,2076,388),(1226,2077,391),(1227,2078,394),(1228,2079,385),(1229,2081,388),(1230,2082,391),(1231,2083,394),(1232,2084,410),(1233,2085,418),(1234,2086,424),(1235,2087,427),(1236,2088,439),(1237,2089,445),(1238,2090,448),(1239,2091,451),(1240,2092,454),(1241,2093,460),(1242,2094,463),(1243,2095,466),(1244,2096,469),(1245,2097,472),(1246,2098,384);
/*!40000 ALTER TABLE `treeState` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `treeStateBounce`
--

DROP TABLE IF EXISTS `treeStateBounce`;
/*!50001 DROP VIEW IF EXISTS `treeStateBounce`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeStateBounce` AS SELECT 
 1 AS `interactionID`,
 1 AS `treeID`,
 1 AS `stateBounced`,
 1 AS `elID`,
 1 AS `interactionCreatedAt`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `treeStateType`
--

DROP TABLE IF EXISTS `treeStateType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `treeStateType` (
  `stateTypeID` int(11) NOT NULL AUTO_INCREMENT,
  `stateType` varchar(45) NOT NULL DEFAULT '',
  PRIMARY KEY (`stateTypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `treeStateType`
--

LOCK TABLES `treeStateType` WRITE;
/*!40000 ALTER TABLE `treeStateType` DISABLE KEYS */;
INSERT INTO `treeStateType` VALUES (1,'intro'),(2,'question'),(3,'end'),(4,'overview');
/*!40000 ALTER TABLE `treeStateType` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `treeapi`
--

DROP TABLE IF EXISTS `treeapi`;
/*!50001 DROP VIEW IF EXISTS `treeapi`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeapi` AS SELECT 
 1 AS `treeID`,
 1 AS `treeSlug`,
 1 AS `title`,
 1 AS `content`,
 1 AS `createdAt`,
 1 AS `updatedAt`,
 1 AS `owner`,
 1 AS `deleted`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `treeend`
--

DROP TABLE IF EXISTS `treeend`;
/*!50001 DROP VIEW IF EXISTS `treeend`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeend` AS SELECT 
 1 AS `endID`,
 1 AS `treeID`,
 1 AS `title`,
 1 AS `content`,
 1 AS `deleted`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `treegroup`
--

DROP TABLE IF EXISTS `treegroup`;
/*!50001 DROP VIEW IF EXISTS `treegroup`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treegroup` AS SELECT 
 1 AS `groupID`,
 1 AS `treeID`,
 1 AS `title`,
 1 AS `content`,
 1 AS `order`,
 1 AS `deleted`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `treeinteractionend`
--

DROP TABLE IF EXISTS `treeinteractionend`;
/*!50001 DROP VIEW IF EXISTS `treeinteractionend`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeinteractionend` AS SELECT 
 1 AS `interactionID`,
 1 AS `userID`,
 1 AS `treeID`,
 1 AS `endID`,
 1 AS `interactionCreatedAt`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `treeinteractionhistory`
--

DROP TABLE IF EXISTS `treeinteractionhistory`;
/*!50001 DROP VIEW IF EXISTS `treeinteractionhistory`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeinteractionhistory` AS SELECT 
 1 AS `interactionID`,
 1 AS `userID`,
 1 AS `treeID`,
 1 AS `destinationStateType`,
 1 AS `destinationStateID`,
 1 AS `interactionCreatedAt`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `treeinteractionload`
--

DROP TABLE IF EXISTS `treeinteractionload`;
/*!50001 DROP VIEW IF EXISTS `treeinteractionload`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeinteractionload` AS SELECT 
 1 AS `interactionID`,
 1 AS `userID`,
 1 AS `treeID`,
 1 AS `interactionCreatedAt`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `treeinteractionoption`
--

DROP TABLE IF EXISTS `treeinteractionoption`;
/*!50001 DROP VIEW IF EXISTS `treeinteractionoption`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeinteractionoption` AS SELECT 
 1 AS `interactionID`,
 1 AS `userID`,
 1 AS `treeID`,
 1 AS `optionID`,
 1 AS `destinationStateType`,
 1 AS `destinationStateID`,
 1 AS `interactionCreatedAt`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `treeinteractionoverview`
--

DROP TABLE IF EXISTS `treeinteractionoverview`;
/*!50001 DROP VIEW IF EXISTS `treeinteractionoverview`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeinteractionoverview` AS SELECT 
 1 AS `interactionID`,
 1 AS `userID`,
 1 AS `treeID`,
 1 AS `interactionCreatedAt`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `treeinteractionquestion`
--

DROP TABLE IF EXISTS `treeinteractionquestion`;
/*!50001 DROP VIEW IF EXISTS `treeinteractionquestion`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeinteractionquestion` AS SELECT 
 1 AS `interactionID`,
 1 AS `userID`,
 1 AS `treeID`,
 1 AS `questionID`,
 1 AS `interactionCreatedAt`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `treeinteractionreload`
--

DROP TABLE IF EXISTS `treeinteractionreload`;
/*!50001 DROP VIEW IF EXISTS `treeinteractionreload`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeinteractionreload` AS SELECT 
 1 AS `interactionID`,
 1 AS `userID`,
 1 AS `treeID`,
 1 AS `interactionCreatedAt`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `treeinteractions`
--

DROP TABLE IF EXISTS `treeinteractions`;
/*!50001 DROP VIEW IF EXISTS `treeinteractions`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeinteractions` AS SELECT 
 1 AS `interactionID`,
 1 AS `userID`,
 1 AS `treeID`,
 1 AS `interactionType`,
 1 AS `stateType`,
 1 AS `interactionCreatedAt`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `treeinteractionsmaxdatebyuserandtree`
--

DROP TABLE IF EXISTS `treeinteractionsmaxdatebyuserandtree`;
/*!50001 DROP VIEW IF EXISTS `treeinteractionsmaxdatebyuserandtree`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeinteractionsmaxdatebyuserandtree` AS SELECT 
 1 AS `userID`,
 1 AS `treeID`,
 1 AS `interactionCreatedAt`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `treeinteractionstart`
--

DROP TABLE IF EXISTS `treeinteractionstart`;
/*!50001 DROP VIEW IF EXISTS `treeinteractionstart`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeinteractionstart` AS SELECT 
 1 AS `interactionID`,
 1 AS `userID`,
 1 AS `treeID`,
 1 AS `destinationStateType`,
 1 AS `destinationStateID`,
 1 AS `interactionCreatedAt`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `treeoption`
--

DROP TABLE IF EXISTS `treeoption`;
/*!50001 DROP VIEW IF EXISTS `treeoption`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treeoption` AS SELECT 
 1 AS `optionID`,
 1 AS `treeID`,
 1 AS `questionID`,
 1 AS `title`,
 1 AS `content`,
 1 AS `order`,
 1 AS `destinationID`,
 1 AS `destinationType`,
 1 AS `deleted`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `treequestion`
--

DROP TABLE IF EXISTS `treequestion`;
/*!50001 DROP VIEW IF EXISTS `treequestion`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treequestion` AS SELECT 
 1 AS `questionID`,
 1 AS `treeID`,
 1 AS `groupID`,
 1 AS `title`,
 1 AS `content`,
 1 AS `order`,
 1 AS `deleted`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `treestart`
--

DROP TABLE IF EXISTS `treestart`;
/*!50001 DROP VIEW IF EXISTS `treestart`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treestart` AS SELECT 
 1 AS `startID`,
 1 AS `treeID`,
 1 AS `title`,
 1 AS `content`,
 1 AS `destinationID`,
 1 AS `deleted`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `treestatebounce`
--

DROP TABLE IF EXISTS `treestatebounce`;
/*!50001 DROP VIEW IF EXISTS `treestatebounce`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `treestatebounce` AS SELECT 
 1 AS `interactionID`,
 1 AS `treeID`,
 1 AS `stateBounced`,
 1 AS `elID`,
 1 AS `interactionCreatedAt`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `wp_commentmeta`
--

DROP TABLE IF EXISTS `wp_commentmeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wp_commentmeta` (
  `meta_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `comment_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `meta_key` varchar(255) COLLATE utf8mb4_unicode_520_ci DEFAULT NULL,
  `meta_value` longtext COLLATE utf8mb4_unicode_520_ci,
  PRIMARY KEY (`meta_id`),
  KEY `comment_id` (`comment_id`),
  KEY `meta_key` (`meta_key`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_commentmeta`
--

LOCK TABLES `wp_commentmeta` WRITE;
/*!40000 ALTER TABLE `wp_commentmeta` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_commentmeta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_comments`
--

DROP TABLE IF EXISTS `wp_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wp_comments` (
  `comment_ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `comment_post_ID` bigint(20) unsigned NOT NULL DEFAULT '0',
  `comment_author` tinytext COLLATE utf8mb4_unicode_520_ci NOT NULL,
  `comment_author_email` varchar(100) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  `comment_author_url` varchar(200) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  `comment_author_IP` varchar(100) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  `comment_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `comment_date_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `comment_content` text COLLATE utf8mb4_unicode_520_ci NOT NULL,
  `comment_karma` int(11) NOT NULL DEFAULT '0',
  `comment_approved` varchar(20) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '1',
  `comment_agent` varchar(255) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  `comment_type` varchar(20) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  `comment_parent` bigint(20) unsigned NOT NULL DEFAULT '0',
  `user_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`comment_ID`),
  KEY `comment_post_ID` (`comment_post_ID`),
  KEY `comment_approved_date_gmt` (`comment_approved`,`comment_date_gmt`),
  KEY `comment_date_gmt` (`comment_date_gmt`),
  KEY `comment_parent` (`comment_parent`),
  KEY `comment_author_email` (`comment_author_email`(10))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_comments`
--

LOCK TABLES `wp_comments` WRITE;
/*!40000 ALTER TABLE `wp_comments` DISABLE KEYS */;
INSERT INTO `wp_comments` VALUES (1,1,'A WordPress Commenter','wapuu@wordpress.example','https://wpengine.com/','','2017-11-16 14:47:09','2017-11-16 14:47:09','Hi, this is a comment.\nTo get started with moderating, editing, and deleting comments, please visit the Comments screen in the dashboard.\nCommenter avatars come from <a href=\"https://gravatar.com\">Gravatar</a>.',0,'1','','',0,0);
/*!40000 ALTER TABLE `wp_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_links`
--

DROP TABLE IF EXISTS `wp_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wp_links` (
  `link_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `link_url` varchar(255) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  `link_name` varchar(255) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  `link_image` varchar(255) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  `link_target` varchar(25) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  `link_description` varchar(255) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  `link_visible` varchar(20) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT 'Y',
  `link_owner` bigint(20) unsigned NOT NULL DEFAULT '1',
  `link_rating` int(11) NOT NULL DEFAULT '0',
  `link_updated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `link_rel` varchar(255) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  `link_notes` mediumtext COLLATE utf8mb4_unicode_520_ci NOT NULL,
  `link_rss` varchar(255) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`link_id`),
  KEY `link_visible` (`link_visible`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_links`
--

LOCK TABLES `wp_links` WRITE;
/*!40000 ALTER TABLE `wp_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_options`
--

DROP TABLE IF EXISTS `wp_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wp_options` (
  `option_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `option_name` varchar(191) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  `option_value` longtext COLLATE utf8mb4_unicode_520_ci NOT NULL,
  `autoload` varchar(20) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT 'yes',
  PRIMARY KEY (`option_id`),
  UNIQUE KEY `option_name` (`option_name`),
  KEY `wpe_autoload_options_index` (`autoload`)
) ENGINE=InnoDB AUTO_INCREMENT=1523 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_options`
--

LOCK TABLES `wp_options` WRITE;
/*!40000 ALTER TABLE `wp_options` DISABLE KEYS */;
INSERT INTO `wp_options` VALUES (1,'siteurl','http://cmetree.wpengine.com','yes'),(2,'home','http://cmetree.wpengine.com','yes'),(3,'blogname','Brett Bowlin Blog','yes'),(4,'blogdescription','Your SUPER-powered WP Engine Blog','yes'),(5,'users_can_register','0','yes'),(6,'admin_email','brettbowlin@gmail.com','yes'),(7,'start_of_week','1','yes'),(8,'use_balanceTags','0','yes'),(9,'use_smilies','1','yes'),(10,'require_name_email','1','yes'),(11,'comments_notify','1','yes'),(12,'posts_per_rss','10','yes'),(13,'rss_use_excerpt','0','yes'),(14,'mailserver_url','mail.example.com','yes'),(15,'mailserver_login','login@example.com','yes'),(16,'mailserver_pass','password','yes'),(17,'mailserver_port','110','yes'),(18,'default_category','1','yes'),(19,'default_comment_status','open','yes'),(20,'default_ping_status','open','yes'),(21,'default_pingback_flag','0','yes'),(22,'posts_per_page','10','yes'),(23,'date_format','F j, Y','yes'),(24,'time_format','g:i a','yes'),(25,'links_updated_date_format','F j, Y g:i a','yes'),(26,'comment_moderation','0','yes'),(27,'moderation_notify','1','yes'),(28,'permalink_structure','','yes'),(29,'rewrite_rules','','yes'),(30,'hack_file','0','yes'),(31,'blog_charset','UTF-8','yes'),(32,'moderation_keys','','no'),(33,'active_plugins','a:0:{}','yes'),(34,'category_base','','yes'),(35,'ping_sites','http://rpc.pingomatic.com/','yes'),(36,'comment_max_links','2','yes'),(37,'gmt_offset','0','yes'),(38,'default_email_category','1','yes'),(39,'recently_edited','','no'),(40,'template','twentyseventeen','yes'),(41,'stylesheet','twentyseventeen','yes'),(42,'comment_whitelist','1','yes'),(43,'blacklist_keys','','no'),(44,'comment_registration','0','yes'),(45,'html_type','text/html','yes'),(46,'use_trackback','0','yes'),(47,'default_role','subscriber','yes'),(48,'db_version','38590','yes'),(49,'uploads_use_yearmonth_folders','1','yes'),(50,'upload_path','','yes'),(51,'blog_public','0','yes'),(52,'default_link_category','2','yes'),(53,'show_on_front','posts','yes'),(54,'tag_base','','yes'),(55,'show_avatars','1','yes'),(56,'avatar_rating','G','yes'),(57,'upload_url_path','','yes'),(58,'thumbnail_size_w','150','yes'),(59,'thumbnail_size_h','150','yes'),(60,'thumbnail_crop','1','yes'),(61,'medium_size_w','300','yes'),(62,'medium_size_h','300','yes'),(63,'avatar_default','mystery','yes'),(64,'large_size_w','1024','yes'),(65,'large_size_h','1024','yes'),(66,'image_default_link_type','none','yes'),(67,'image_default_size','','yes'),(68,'image_default_align','','yes'),(69,'close_comments_for_old_posts','0','yes'),(70,'close_comments_days_old','14','yes'),(71,'thread_comments','1','yes'),(72,'thread_comments_depth','5','yes'),(73,'page_comments','0','yes'),(74,'comments_per_page','50','yes'),(75,'default_comments_page','newest','yes'),(76,'comment_order','asc','yes'),(77,'sticky_posts','a:0:{}','yes'),(78,'widget_categories','a:2:{i:2;a:4:{s:5:\"title\";s:0:\"\";s:5:\"count\";i:0;s:12:\"hierarchical\";i:0;s:8:\"dropdown\";i:0;}s:12:\"_multiwidget\";i:1;}','yes'),(79,'widget_text','a:0:{}','yes'),(80,'widget_rss','a:0:{}','yes'),(81,'uninstall_plugins','a:0:{}','no'),(82,'timezone_string','','yes'),(83,'page_for_posts','0','yes'),(84,'page_on_front','0','yes'),(85,'default_post_format','0','yes'),(86,'link_manager_enabled','0','yes'),(87,'finished_splitting_shared_terms','1','yes'),(88,'site_icon','0','yes'),(89,'medium_large_size_w','768','yes'),(90,'medium_large_size_h','0','yes'),(91,'initial_db_version','38590','yes'),(92,'wp_user_roles','a:5:{s:13:\"administrator\";a:2:{s:4:\"name\";s:13:\"Administrator\";s:12:\"capabilities\";a:61:{s:13:\"switch_themes\";b:1;s:11:\"edit_themes\";b:1;s:16:\"activate_plugins\";b:1;s:12:\"edit_plugins\";b:1;s:10:\"edit_users\";b:1;s:10:\"edit_files\";b:1;s:14:\"manage_options\";b:1;s:17:\"moderate_comments\";b:1;s:17:\"manage_categories\";b:1;s:12:\"manage_links\";b:1;s:12:\"upload_files\";b:1;s:6:\"import\";b:1;s:15:\"unfiltered_html\";b:1;s:10:\"edit_posts\";b:1;s:17:\"edit_others_posts\";b:1;s:20:\"edit_published_posts\";b:1;s:13:\"publish_posts\";b:1;s:10:\"edit_pages\";b:1;s:4:\"read\";b:1;s:8:\"level_10\";b:1;s:7:\"level_9\";b:1;s:7:\"level_8\";b:1;s:7:\"level_7\";b:1;s:7:\"level_6\";b:1;s:7:\"level_5\";b:1;s:7:\"level_4\";b:1;s:7:\"level_3\";b:1;s:7:\"level_2\";b:1;s:7:\"level_1\";b:1;s:7:\"level_0\";b:1;s:17:\"edit_others_pages\";b:1;s:20:\"edit_published_pages\";b:1;s:13:\"publish_pages\";b:1;s:12:\"delete_pages\";b:1;s:19:\"delete_others_pages\";b:1;s:22:\"delete_published_pages\";b:1;s:12:\"delete_posts\";b:1;s:19:\"delete_others_posts\";b:1;s:22:\"delete_published_posts\";b:1;s:20:\"delete_private_posts\";b:1;s:18:\"edit_private_posts\";b:1;s:18:\"read_private_posts\";b:1;s:20:\"delete_private_pages\";b:1;s:18:\"edit_private_pages\";b:1;s:18:\"read_private_pages\";b:1;s:12:\"delete_users\";b:1;s:12:\"create_users\";b:1;s:17:\"unfiltered_upload\";b:1;s:14:\"edit_dashboard\";b:1;s:14:\"update_plugins\";b:1;s:14:\"delete_plugins\";b:1;s:15:\"install_plugins\";b:1;s:13:\"update_themes\";b:1;s:14:\"install_themes\";b:1;s:11:\"update_core\";b:1;s:10:\"list_users\";b:1;s:12:\"remove_users\";b:1;s:13:\"promote_users\";b:1;s:18:\"edit_theme_options\";b:1;s:13:\"delete_themes\";b:1;s:6:\"export\";b:1;}}s:6:\"editor\";a:2:{s:4:\"name\";s:6:\"Editor\";s:12:\"capabilities\";a:34:{s:17:\"moderate_comments\";b:1;s:17:\"manage_categories\";b:1;s:12:\"manage_links\";b:1;s:12:\"upload_files\";b:1;s:15:\"unfiltered_html\";b:1;s:10:\"edit_posts\";b:1;s:17:\"edit_others_posts\";b:1;s:20:\"edit_published_posts\";b:1;s:13:\"publish_posts\";b:1;s:10:\"edit_pages\";b:1;s:4:\"read\";b:1;s:7:\"level_7\";b:1;s:7:\"level_6\";b:1;s:7:\"level_5\";b:1;s:7:\"level_4\";b:1;s:7:\"level_3\";b:1;s:7:\"level_2\";b:1;s:7:\"level_1\";b:1;s:7:\"level_0\";b:1;s:17:\"edit_others_pages\";b:1;s:20:\"edit_published_pages\";b:1;s:13:\"publish_pages\";b:1;s:12:\"delete_pages\";b:1;s:19:\"delete_others_pages\";b:1;s:22:\"delete_published_pages\";b:1;s:12:\"delete_posts\";b:1;s:19:\"delete_others_posts\";b:1;s:22:\"delete_published_posts\";b:1;s:20:\"delete_private_posts\";b:1;s:18:\"edit_private_posts\";b:1;s:18:\"read_private_posts\";b:1;s:20:\"delete_private_pages\";b:1;s:18:\"edit_private_pages\";b:1;s:18:\"read_private_pages\";b:1;}}s:6:\"author\";a:2:{s:4:\"name\";s:6:\"Author\";s:12:\"capabilities\";a:10:{s:12:\"upload_files\";b:1;s:10:\"edit_posts\";b:1;s:20:\"edit_published_posts\";b:1;s:13:\"publish_posts\";b:1;s:4:\"read\";b:1;s:7:\"level_2\";b:1;s:7:\"level_1\";b:1;s:7:\"level_0\";b:1;s:12:\"delete_posts\";b:1;s:22:\"delete_published_posts\";b:1;}}s:11:\"contributor\";a:2:{s:4:\"name\";s:11:\"Contributor\";s:12:\"capabilities\";a:5:{s:10:\"edit_posts\";b:1;s:4:\"read\";b:1;s:7:\"level_1\";b:1;s:7:\"level_0\";b:1;s:12:\"delete_posts\";b:1;}}s:10:\"subscriber\";a:2:{s:4:\"name\";s:10:\"Subscriber\";s:12:\"capabilities\";a:2:{s:4:\"read\";b:1;s:7:\"level_0\";b:1;}}}','yes'),(93,'fresh_site','1','yes'),(94,'widget_search','a:2:{i:2;a:1:{s:5:\"title\";s:0:\"\";}s:12:\"_multiwidget\";i:1;}','yes'),(95,'widget_recent-posts','a:2:{i:2;a:2:{s:5:\"title\";s:0:\"\";s:6:\"number\";i:5;}s:12:\"_multiwidget\";i:1;}','yes'),(96,'widget_recent-comments','a:2:{i:2;a:2:{s:5:\"title\";s:0:\"\";s:6:\"number\";i:5;}s:12:\"_multiwidget\";i:1;}','yes'),(97,'widget_archives','a:2:{i:2;a:3:{s:5:\"title\";s:0:\"\";s:5:\"count\";i:0;s:8:\"dropdown\";i:0;}s:12:\"_multiwidget\";i:1;}','yes'),(98,'widget_meta','a:2:{i:2;a:1:{s:5:\"title\";s:0:\"\";}s:12:\"_multiwidget\";i:1;}','yes'),(99,'sidebars_widgets','a:5:{s:19:\"wp_inactive_widgets\";a:0:{}s:9:\"sidebar-1\";a:6:{i:0;s:8:\"search-2\";i:1;s:14:\"recent-posts-2\";i:2;s:17:\"recent-comments-2\";i:3;s:10:\"archives-2\";i:4;s:12:\"categories-2\";i:5;s:6:\"meta-2\";}s:9:\"sidebar-2\";a:0:{}s:9:\"sidebar-3\";a:0:{}s:13:\"array_version\";i:3;}','yes'),(100,'widget_pages','a:1:{s:12:\"_multiwidget\";i:1;}','yes'),(101,'widget_calendar','a:1:{s:12:\"_multiwidget\";i:1;}','yes'),(102,'widget_media_audio','a:1:{s:12:\"_multiwidget\";i:1;}','yes'),(103,'widget_media_image','a:1:{s:12:\"_multiwidget\";i:1;}','yes'),(104,'widget_media_gallery','a:1:{s:12:\"_multiwidget\";i:1;}','yes'),(105,'widget_media_video','a:1:{s:12:\"_multiwidget\";i:1;}','yes'),(106,'widget_tag_cloud','a:1:{s:12:\"_multiwidget\";i:1;}','yes'),(107,'widget_nav_menu','a:1:{s:12:\"_multiwidget\";i:1;}','yes'),(108,'widget_custom_html','a:1:{s:12:\"_multiwidget\";i:1;}','yes'),(109,'cron','a:7:{i:1592931165;a:1:{s:34:\"wp_privacy_delete_old_export_files\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:6:\"hourly\";s:4:\"args\";a:0:{}s:8:\"interval\";i:3600;}}}i:1592934215;a:1:{s:46:\"WPEngineSecurityAuditor_Scans_fingerprint_core\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:2:{s:8:\"schedule\";b:0;s:4:\"args\";a:0:{}}}}i:1592940434;a:1:{s:49:\"WPEngineSecurityAuditor_Scans_fingerprint_plugins\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:2:{s:8:\"schedule\";b:0;s:4:\"args\";a:0:{}}}}i:1592966830;a:3:{s:16:\"wp_version_check\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:10:\"twicedaily\";s:4:\"args\";a:0:{}s:8:\"interval\";i:43200;}}s:17:\"wp_update_plugins\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:10:\"twicedaily\";s:4:\"args\";a:0:{}s:8:\"interval\";i:43200;}}s:16:\"wp_update_themes\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:10:\"twicedaily\";s:4:\"args\";a:0:{}s:8:\"interval\";i:43200;}}}i:1592970976;a:1:{s:39:\"WPEngineSecurityAuditor_Scans_scheduler\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:10:\"twicedaily\";s:4:\"args\";a:0:{}s:8:\"interval\";i:43200;}}}i:1592973634;a:1:{s:48:\"WPEngineSecurityAuditor_Scans_fingerprint_themes\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:2:{s:8:\"schedule\";b:0;s:4:\"args\";a:0:{}}}}s:7:\"version\";i:2;}','yes'),(111,'widget_wpe_powered_by_widget','a:1:{s:12:\"_multiwidget\";i:1;}','yes'),(159,'theme_mods_twentyseventeen','a:1:{s:18:\"custom_css_post_id\";i:-1;}','yes'),(162,'_transient_is_multi_author','0','yes'),(1189,'_site_transient_update_core','O:8:\"stdClass\":4:{s:7:\"updates\";a:7:{i:0;O:8:\"stdClass\":10:{s:8:\"response\";s:7:\"upgrade\";s:8:\"download\";s:59:\"https://downloads.wordpress.org/release/wordpress-5.4.2.zip\";s:6:\"locale\";s:5:\"en_US\";s:8:\"packages\";O:8:\"stdClass\":5:{s:4:\"full\";s:59:\"https://downloads.wordpress.org/release/wordpress-5.4.2.zip\";s:10:\"no_content\";s:70:\"https://downloads.wordpress.org/release/wordpress-5.4.2-no-content.zip\";s:11:\"new_bundled\";s:71:\"https://downloads.wordpress.org/release/wordpress-5.4.2-new-bundled.zip\";s:7:\"partial\";b:0;s:8:\"rollback\";b:0;}s:7:\"current\";s:5:\"5.4.2\";s:7:\"version\";s:5:\"5.4.2\";s:11:\"php_version\";s:6:\"5.6.20\";s:13:\"mysql_version\";s:3:\"5.0\";s:11:\"new_bundled\";s:3:\"5.3\";s:15:\"partial_version\";s:0:\"\";}i:1;O:8:\"stdClass\":11:{s:8:\"response\";s:10:\"autoupdate\";s:8:\"download\";s:59:\"https://downloads.wordpress.org/release/wordpress-5.4.2.zip\";s:6:\"locale\";s:5:\"en_US\";s:8:\"packages\";O:8:\"stdClass\":5:{s:4:\"full\";s:59:\"https://downloads.wordpress.org/release/wordpress-5.4.2.zip\";s:10:\"no_content\";s:70:\"https://downloads.wordpress.org/release/wordpress-5.4.2-no-content.zip\";s:11:\"new_bundled\";s:71:\"https://downloads.wordpress.org/release/wordpress-5.4.2-new-bundled.zip\";s:7:\"partial\";b:0;s:8:\"rollback\";b:0;}s:7:\"current\";s:5:\"5.4.2\";s:7:\"version\";s:5:\"5.4.2\";s:11:\"php_version\";s:6:\"5.6.20\";s:13:\"mysql_version\";s:3:\"5.0\";s:11:\"new_bundled\";s:3:\"5.3\";s:15:\"partial_version\";s:0:\"\";s:9:\"new_files\";s:1:\"1\";}i:2;O:8:\"stdClass\":11:{s:8:\"response\";s:10:\"autoupdate\";s:8:\"download\";s:59:\"https://downloads.wordpress.org/release/wordpress-5.3.4.zip\";s:6:\"locale\";s:5:\"en_US\";s:8:\"packages\";O:8:\"stdClass\":5:{s:4:\"full\";s:59:\"https://downloads.wordpress.org/release/wordpress-5.3.4.zip\";s:10:\"no_content\";s:70:\"https://downloads.wordpress.org/release/wordpress-5.3.4-no-content.zip\";s:11:\"new_bundled\";s:71:\"https://downloads.wordpress.org/release/wordpress-5.3.4-new-bundled.zip\";s:7:\"partial\";b:0;s:8:\"rollback\";b:0;}s:7:\"current\";s:5:\"5.3.4\";s:7:\"version\";s:5:\"5.3.4\";s:11:\"php_version\";s:6:\"5.6.20\";s:13:\"mysql_version\";s:3:\"5.0\";s:11:\"new_bundled\";s:3:\"5.3\";s:15:\"partial_version\";s:0:\"\";s:9:\"new_files\";s:1:\"1\";}i:3;O:8:\"stdClass\":11:{s:8:\"response\";s:10:\"autoupdate\";s:8:\"download\";s:59:\"https://downloads.wordpress.org/release/wordpress-5.2.7.zip\";s:6:\"locale\";s:5:\"en_US\";s:8:\"packages\";O:8:\"stdClass\":5:{s:4:\"full\";s:59:\"https://downloads.wordpress.org/release/wordpress-5.2.7.zip\";s:10:\"no_content\";s:70:\"https://downloads.wordpress.org/release/wordpress-5.2.7-no-content.zip\";s:11:\"new_bundled\";s:71:\"https://downloads.wordpress.org/release/wordpress-5.2.7-new-bundled.zip\";s:7:\"partial\";b:0;s:8:\"rollback\";b:0;}s:7:\"current\";s:5:\"5.2.7\";s:7:\"version\";s:5:\"5.2.7\";s:11:\"php_version\";s:6:\"5.6.20\";s:13:\"mysql_version\";s:3:\"5.0\";s:11:\"new_bundled\";s:3:\"5.3\";s:15:\"partial_version\";s:0:\"\";s:9:\"new_files\";s:1:\"1\";}i:4;O:8:\"stdClass\":11:{s:8:\"response\";s:10:\"autoupdate\";s:8:\"download\";s:59:\"https://downloads.wordpress.org/release/wordpress-5.1.6.zip\";s:6:\"locale\";s:5:\"en_US\";s:8:\"packages\";O:8:\"stdClass\":5:{s:4:\"full\";s:59:\"https://downloads.wordpress.org/release/wordpress-5.1.6.zip\";s:10:\"no_content\";s:70:\"https://downloads.wordpress.org/release/wordpress-5.1.6-no-content.zip\";s:11:\"new_bundled\";s:71:\"https://downloads.wordpress.org/release/wordpress-5.1.6-new-bundled.zip\";s:7:\"partial\";b:0;s:8:\"rollback\";b:0;}s:7:\"current\";s:5:\"5.1.6\";s:7:\"version\";s:5:\"5.1.6\";s:11:\"php_version\";s:5:\"5.2.4\";s:13:\"mysql_version\";s:3:\"5.0\";s:11:\"new_bundled\";s:3:\"5.3\";s:15:\"partial_version\";s:0:\"\";s:9:\"new_files\";s:1:\"1\";}i:5;O:8:\"stdClass\":11:{s:8:\"response\";s:10:\"autoupdate\";s:8:\"download\";s:60:\"https://downloads.wordpress.org/release/wordpress-5.0.10.zip\";s:6:\"locale\";s:5:\"en_US\";s:8:\"packages\";O:8:\"stdClass\":5:{s:4:\"full\";s:60:\"https://downloads.wordpress.org/release/wordpress-5.0.10.zip\";s:10:\"no_content\";s:71:\"https://downloads.wordpress.org/release/wordpress-5.0.10-no-content.zip\";s:11:\"new_bundled\";s:72:\"https://downloads.wordpress.org/release/wordpress-5.0.10-new-bundled.zip\";s:7:\"partial\";b:0;s:8:\"rollback\";b:0;}s:7:\"current\";s:6:\"5.0.10\";s:7:\"version\";s:6:\"5.0.10\";s:11:\"php_version\";s:5:\"5.2.4\";s:13:\"mysql_version\";s:3:\"5.0\";s:11:\"new_bundled\";s:3:\"5.3\";s:15:\"partial_version\";s:0:\"\";s:9:\"new_files\";s:1:\"1\";}i:6;O:8:\"stdClass\":11:{s:8:\"response\";s:10:\"autoupdate\";s:8:\"download\";s:60:\"https://downloads.wordpress.org/release/wordpress-4.9.15.zip\";s:6:\"locale\";s:5:\"en_US\";s:8:\"packages\";O:8:\"stdClass\":5:{s:4:\"full\";s:60:\"https://downloads.wordpress.org/release/wordpress-4.9.15.zip\";s:10:\"no_content\";s:71:\"https://downloads.wordpress.org/release/wordpress-4.9.15-no-content.zip\";s:11:\"new_bundled\";s:72:\"https://downloads.wordpress.org/release/wordpress-4.9.15-new-bundled.zip\";s:7:\"partial\";s:70:\"https://downloads.wordpress.org/release/wordpress-4.9.15-partial-6.zip\";s:8:\"rollback\";s:71:\"https://downloads.wordpress.org/release/wordpress-4.9.15-rollback-6.zip\";}s:7:\"current\";s:6:\"4.9.15\";s:7:\"version\";s:6:\"4.9.15\";s:11:\"php_version\";s:5:\"5.2.4\";s:13:\"mysql_version\";s:3:\"5.0\";s:11:\"new_bundled\";s:3:\"5.3\";s:15:\"partial_version\";s:5:\"4.9.6\";s:9:\"new_files\";s:0:\"\";}}s:12:\"last_checked\";i:1592930852;s:15:\"version_checked\";s:5:\"4.9.6\";s:12:\"translations\";a:0:{}}','no'),(1519,'_site_transient_timeout_theme_roots','1592932653','no'),(1520,'_site_transient_theme_roots','a:3:{s:13:\"twentyfifteen\";s:7:\"/themes\";s:15:\"twentyseventeen\";s:7:\"/themes\";s:13:\"twentysixteen\";s:7:\"/themes\";}','no'),(1521,'_site_transient_update_themes','O:8:\"stdClass\":4:{s:12:\"last_checked\";i:1592930853;s:7:\"checked\";a:3:{s:13:\"twentyfifteen\";s:3:\"2.0\";s:15:\"twentyseventeen\";s:3:\"1.6\";s:13:\"twentysixteen\";s:3:\"1.5\";}s:8:\"response\";a:3:{s:13:\"twentyfifteen\";a:6:{s:5:\"theme\";s:13:\"twentyfifteen\";s:11:\"new_version\";s:3:\"2.6\";s:3:\"url\";s:43:\"https://wordpress.org/themes/twentyfifteen/\";s:7:\"package\";s:59:\"https://downloads.wordpress.org/theme/twentyfifteen.2.6.zip\";s:8:\"requires\";b:0;s:12:\"requires_php\";s:5:\"5.2.4\";}s:15:\"twentyseventeen\";a:6:{s:5:\"theme\";s:15:\"twentyseventeen\";s:11:\"new_version\";s:3:\"2.3\";s:3:\"url\";s:45:\"https://wordpress.org/themes/twentyseventeen/\";s:7:\"package\";s:61:\"https://downloads.wordpress.org/theme/twentyseventeen.2.3.zip\";s:8:\"requires\";s:3:\"4.7\";s:12:\"requires_php\";s:5:\"5.2.4\";}s:13:\"twentysixteen\";a:6:{s:5:\"theme\";s:13:\"twentysixteen\";s:11:\"new_version\";s:3:\"2.1\";s:3:\"url\";s:43:\"https://wordpress.org/themes/twentysixteen/\";s:7:\"package\";s:59:\"https://downloads.wordpress.org/theme/twentysixteen.2.1.zip\";s:8:\"requires\";s:3:\"4.4\";s:12:\"requires_php\";s:5:\"5.2.4\";}}s:12:\"translations\";a:0:{}}','no'),(1522,'_site_transient_update_plugins','O:8:\"stdClass\":5:{s:12:\"last_checked\";i:1592930853;s:7:\"checked\";a:1:{s:19:\"akismet/akismet.php\";s:5:\"4.0.3\";}s:8:\"response\";a:1:{s:19:\"akismet/akismet.php\";O:8:\"stdClass\":12:{s:2:\"id\";s:21:\"w.org/plugins/akismet\";s:4:\"slug\";s:7:\"akismet\";s:6:\"plugin\";s:19:\"akismet/akismet.php\";s:11:\"new_version\";s:5:\"4.1.6\";s:3:\"url\";s:38:\"https://wordpress.org/plugins/akismet/\";s:7:\"package\";s:56:\"https://downloads.wordpress.org/plugin/akismet.4.1.6.zip\";s:5:\"icons\";a:2:{s:2:\"2x\";s:59:\"https://ps.w.org/akismet/assets/icon-256x256.png?rev=969272\";s:2:\"1x\";s:59:\"https://ps.w.org/akismet/assets/icon-128x128.png?rev=969272\";}s:7:\"banners\";a:1:{s:2:\"1x\";s:61:\"https://ps.w.org/akismet/assets/banner-772x250.jpg?rev=479904\";}s:11:\"banners_rtl\";a:0:{}s:6:\"tested\";s:5:\"5.4.2\";s:12:\"requires_php\";b:0;s:13:\"compatibility\";O:8:\"stdClass\":0:{}}}s:12:\"translations\";a:0:{}s:9:\"no_update\";a:0:{}}','no');
/*!40000 ALTER TABLE `wp_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_postmeta`
--

DROP TABLE IF EXISTS `wp_postmeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wp_postmeta` (
  `meta_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `post_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `meta_key` varchar(255) COLLATE utf8mb4_unicode_520_ci DEFAULT NULL,
  `meta_value` longtext COLLATE utf8mb4_unicode_520_ci,
  PRIMARY KEY (`meta_id`),
  KEY `post_id` (`post_id`),
  KEY `meta_key` (`meta_key`(191))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_postmeta`
--

LOCK TABLES `wp_postmeta` WRITE;
/*!40000 ALTER TABLE `wp_postmeta` DISABLE KEYS */;
INSERT INTO `wp_postmeta` VALUES (1,2,'_wp_page_template','default');
/*!40000 ALTER TABLE `wp_postmeta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_posts`
--

DROP TABLE IF EXISTS `wp_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wp_posts` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `post_author` bigint(20) unsigned NOT NULL DEFAULT '0',
  `post_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_date_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_content` longtext COLLATE utf8mb4_unicode_520_ci NOT NULL,
  `post_title` text COLLATE utf8mb4_unicode_520_ci NOT NULL,
  `post_excerpt` text COLLATE utf8mb4_unicode_520_ci NOT NULL,
  `post_status` varchar(20) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT 'publish',
  `comment_status` varchar(20) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT 'open',
  `ping_status` varchar(20) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT 'open',
  `post_password` varchar(255) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  `post_name` varchar(200) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  `to_ping` text COLLATE utf8mb4_unicode_520_ci NOT NULL,
  `pinged` text COLLATE utf8mb4_unicode_520_ci NOT NULL,
  `post_modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_modified_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_content_filtered` longtext COLLATE utf8mb4_unicode_520_ci NOT NULL,
  `post_parent` bigint(20) unsigned NOT NULL DEFAULT '0',
  `guid` varchar(255) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  `menu_order` int(11) NOT NULL DEFAULT '0',
  `post_type` varchar(20) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT 'post',
  `post_mime_type` varchar(100) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  `comment_count` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `post_name` (`post_name`(191)),
  KEY `type_status_date` (`post_type`,`post_status`,`post_date`,`ID`),
  KEY `post_parent` (`post_parent`),
  KEY `post_author` (`post_author`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_posts`
--

LOCK TABLES `wp_posts` WRITE;
/*!40000 ALTER TABLE `wp_posts` DISABLE KEYS */;
INSERT INTO `wp_posts` VALUES (1,1,'2017-11-16 14:47:09','2017-11-16 14:47:09','Welcome to WordPress. This is your first post. Edit or delete it, then start writing!','Hello world!','','publish','open','open','','hello-world','','','2017-11-16 14:47:09','2017-11-16 14:47:09','',0,'http://wpengine.com9/?p=1',0,'post','',1),(2,1,'2017-11-16 14:47:09','2017-11-16 14:47:09','This is an example page. It\'s different from a blog post because it will stay in one place and will show up in your site navigation (in most themes). Most people start with an About page that introduces them to potential site visitors. It might say something like this:\n\n<blockquote>Hi there! I\'m a bike messenger by day, aspiring actor by night, and this is my website. I live in Los Angeles, have a great dog named Jack, and I like pi&#241;a coladas. (And gettin\' caught in the rain.)</blockquote>\n\n...or something like this:\n\n<blockquote>The XYZ Doohickey Company was founded in 1971, and has been providing quality doohickeys to the public ever since. Located in Gotham City, XYZ employs over 2,000 people and does all kinds of awesome things for the Gotham community.</blockquote>\n\nAs a new WordPress user, you should go to <a href=\"http://wpengine.com9/wp-admin/\">your dashboard</a> to delete this page and create new pages for your content. Have fun!','Sample Page','','publish','closed','open','','sample-page','','','2017-11-16 14:47:09','2017-11-16 14:47:09','',0,'http://wpengine.com9/?page_id=2',0,'page','',0);
/*!40000 ALTER TABLE `wp_posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_term_relationships`
--

DROP TABLE IF EXISTS `wp_term_relationships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wp_term_relationships` (
  `object_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `term_taxonomy_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `term_order` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`object_id`,`term_taxonomy_id`),
  KEY `term_taxonomy_id` (`term_taxonomy_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_term_relationships`
--

LOCK TABLES `wp_term_relationships` WRITE;
/*!40000 ALTER TABLE `wp_term_relationships` DISABLE KEYS */;
INSERT INTO `wp_term_relationships` VALUES (1,1,0);
/*!40000 ALTER TABLE `wp_term_relationships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_term_taxonomy`
--

DROP TABLE IF EXISTS `wp_term_taxonomy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wp_term_taxonomy` (
  `term_taxonomy_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `term_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `taxonomy` varchar(32) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  `description` longtext COLLATE utf8mb4_unicode_520_ci NOT NULL,
  `parent` bigint(20) unsigned NOT NULL DEFAULT '0',
  `count` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`term_taxonomy_id`),
  UNIQUE KEY `term_id_taxonomy` (`term_id`,`taxonomy`),
  KEY `taxonomy` (`taxonomy`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_term_taxonomy`
--

LOCK TABLES `wp_term_taxonomy` WRITE;
/*!40000 ALTER TABLE `wp_term_taxonomy` DISABLE KEYS */;
INSERT INTO `wp_term_taxonomy` VALUES (1,1,'category','',0,1);
/*!40000 ALTER TABLE `wp_term_taxonomy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_termmeta`
--

DROP TABLE IF EXISTS `wp_termmeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wp_termmeta` (
  `meta_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `term_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `meta_key` varchar(255) COLLATE utf8mb4_unicode_520_ci DEFAULT NULL,
  `meta_value` longtext COLLATE utf8mb4_unicode_520_ci,
  PRIMARY KEY (`meta_id`),
  KEY `term_id` (`term_id`),
  KEY `meta_key` (`meta_key`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_termmeta`
--

LOCK TABLES `wp_termmeta` WRITE;
/*!40000 ALTER TABLE `wp_termmeta` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_termmeta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_terms`
--

DROP TABLE IF EXISTS `wp_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wp_terms` (
  `term_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(200) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  `slug` varchar(200) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  `term_group` bigint(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`term_id`),
  KEY `slug` (`slug`(191)),
  KEY `name` (`name`(191))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_terms`
--

LOCK TABLES `wp_terms` WRITE;
/*!40000 ALTER TABLE `wp_terms` DISABLE KEYS */;
INSERT INTO `wp_terms` VALUES (1,'Uncategorized','uncategorized',0);
/*!40000 ALTER TABLE `wp_terms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_usermeta`
--

DROP TABLE IF EXISTS `wp_usermeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wp_usermeta` (
  `umeta_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `meta_key` varchar(255) COLLATE utf8mb4_unicode_520_ci DEFAULT NULL,
  `meta_value` longtext COLLATE utf8mb4_unicode_520_ci,
  PRIMARY KEY (`umeta_id`),
  KEY `user_id` (`user_id`),
  KEY `meta_key` (`meta_key`(191))
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_usermeta`
--

LOCK TABLES `wp_usermeta` WRITE;
/*!40000 ALTER TABLE `wp_usermeta` DISABLE KEYS */;
INSERT INTO `wp_usermeta` VALUES (1,1,'nickname','wpengine'),(2,1,'first_name',''),(3,1,'last_name',''),(4,1,'description','This is the \"wpengine\" admin user that our staff uses to gain access to your admin area to provide support and troubleshooting. It can only be accessed by a button in our secure log that auto generates a password and dumps that password after the staff member has logged in. We have taken extreme measures to ensure that our own user is not going to be misused to harm any of our clients sites.'),(5,1,'rich_editing','true'),(6,1,'syntax_highlighting','true'),(7,1,'comment_shortcuts','false'),(8,1,'admin_color','fresh'),(9,1,'use_ssl','0'),(10,1,'show_admin_bar_front','true'),(11,1,'locale',''),(12,1,'wp_capabilities','a:1:{s:13:\"administrator\";b:1;}'),(13,1,'wp_user_level','10'),(14,1,'dismissed_wp_pointers',''),(15,1,'show_welcome_panel','1'),(16,2,'nickname','cmetree'),(17,2,'first_name',''),(18,2,'last_name',''),(19,2,'description',''),(20,2,'rich_editing','true'),(21,2,'syntax_highlighting','true'),(22,2,'comment_shortcuts','false'),(23,2,'admin_color','fresh'),(24,2,'use_ssl','0'),(25,2,'show_admin_bar_front','true'),(26,2,'locale',''),(27,2,'wp_capabilities','a:1:{s:13:\"administrator\";b:1;}'),(28,2,'wp_user_level','10'),(29,1,'session_tokens','a:1:{s:64:\"d4fabeb52907fc7902eb7706fdc63209bec34383d210a99fb872f9082a6927ca\";a:3:{s:10:\"expiration\";i:1559431200;s:2:\"ip\";s:9:\"127.0.0.1\";s:5:\"login\";i:1559258400;}}');
/*!40000 ALTER TABLE `wp_usermeta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_users`
--

DROP TABLE IF EXISTS `wp_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wp_users` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_login` varchar(60) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  `user_pass` varchar(255) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  `user_nicename` varchar(50) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  `user_email` varchar(100) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  `user_url` varchar(100) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  `user_registered` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `user_activation_key` varchar(255) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  `user_status` int(11) NOT NULL DEFAULT '0',
  `display_name` varchar(250) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `user_login_key` (`user_login`),
  KEY `user_nicename` (`user_nicename`),
  KEY `user_email` (`user_email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_users`
--

LOCK TABLES `wp_users` WRITE;
/*!40000 ALTER TABLE `wp_users` DISABLE KEYS */;
INSERT INTO `wp_users` VALUES (1,'wpengine','$P$BMC3.lA5qv3m/YqcSHPeS44AQ5QItE/','wpengine','bitbucket@wpengine.com','http://wpengine.com','2017-11-16 14:47:09','',0,'wpengine'),(2,'cmetree','$P$BhB.aOulHVRdjQqvQmILZEIkMQMozi1','cmetree','brettbowlin@gmail.com','http://cmetree.wpengine.com','2018-05-25 19:52:54','',0,'cmetree');
/*!40000 ALTER TABLE `wp_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'wp_cmetree'
--

--
-- Dumping routines for database 'wp_cmetree'
--

--
-- Final view structure for view `treeAPI`
--

/*!50001 DROP VIEW IF EXISTS `treeAPI`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeAPI` AS select `tree`.`treeID` AS `treeID`,`tree`.`treeSlug` AS `treeSlug`,`tree`.`treeTitle` AS `title`,`tree`.`treeContent` AS `content`,`tree`.`treeCreatedAt` AS `createdAt`,`tree`.`treeUpdatedAt` AS `updatedAt`,`tree`.`treeOwner` AS `owner`,`tree`.`treeDeleted` AS `deleted` from `tree` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeEnd`
--

/*!50001 DROP VIEW IF EXISTS `treeEnd`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeEnd` AS select `el`.`elID` AS `endID`,`el`.`treeID` AS `treeID`,`el`.`elTitle` AS `title`,`el`.`elContent` AS `content`,`el`.`elDeleted` AS `deleted` from (`treeElement` `el` join `treeElementType` `elType` on((`el`.`elTypeID` = `elType`.`elTypeID`))) where (`elType`.`elType` = 'end') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeGroup`
--

/*!50001 DROP VIEW IF EXISTS `treeGroup`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeGroup` AS select `el`.`elID` AS `groupID`,`el`.`treeID` AS `treeID`,`el`.`elTitle` AS `title`,`el`.`elContent` AS `content`,`elOrder`.`elOrder` AS `order`,`el`.`elDeleted` AS `deleted` from ((`treeElement` `el` join `treeElementType` `elType` on((`el`.`elTypeID` = `elType`.`elTypeID`))) join `treeElementOrder` `elOrder` on((`el`.`elID` = `elOrder`.`elID`))) where (`elType`.`elType` = 'group') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeInteractionEnd`
--

/*!50001 DROP VIEW IF EXISTS `treeInteractionEnd`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeInteractionEnd` AS select `interactions`.`interactionID` AS `interactionID`,`interactions`.`userID` AS `userID`,`interactions`.`treeID` AS `treeID`,`state`.`elID` AS `endID`,`interactions`.`interactionCreatedAt` AS `interactionCreatedAt` from (`treeInteractions` `interactions` join `treeState` `state` on((`interactions`.`interactionID` = `state`.`interactionID`))) where (`interactions`.`stateType` = 'end') order by `interactions`.`interactionID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeInteractionHistory`
--

/*!50001 DROP VIEW IF EXISTS `treeInteractionHistory`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeInteractionHistory` AS select `interactions`.`interactionID` AS `interactionID`,`interactions`.`userID` AS `userID`,`interactions`.`treeID` AS `treeID`,`interactions`.`stateType` AS `destinationStateType`,`state`.`elID` AS `destinationStateID`,`interactions`.`interactionCreatedAt` AS `interactionCreatedAt` from (`treeInteractions` `interactions` left join `treeState` `state` on((`interactions`.`interactionID` = `state`.`interactionID`))) where (`interactions`.`interactionType` = 'history') order by `interactions`.`interactionID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeInteractionLoad`
--

/*!50001 DROP VIEW IF EXISTS `treeInteractionLoad`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeInteractionLoad` AS select `interactions`.`interactionID` AS `interactionID`,`interactions`.`userID` AS `userID`,`interactions`.`treeID` AS `treeID`,`interactions`.`interactionCreatedAt` AS `interactionCreatedAt` from `treeInteractions` `interactions` where (`interactions`.`interactionType` = 'load') order by `interactions`.`interactionID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeInteractionOption`
--

/*!50001 DROP VIEW IF EXISTS `treeInteractionOption`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeInteractionOption` AS select `interactions`.`interactionID` AS `interactionID`,`interactions`.`userID` AS `userID`,`interactions`.`treeID` AS `treeID`,`interactionEl`.`elID` AS `optionID`,`interactions`.`stateType` AS `destinationStateType`,`state`.`elID` AS `destinationStateID`,`interactions`.`interactionCreatedAt` AS `interactionCreatedAt` from ((`treeInteractions` `interactions` left join `treeState` `state` on((`interactions`.`interactionID` = `state`.`interactionID`))) join `treeInteractionElement` `interactionEl` on((`interactions`.`interactionID` = `interactionEl`.`interactionID`))) where (`interactions`.`interactionType` = 'option') order by `interactions`.`interactionID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeInteractionOverview`
--

/*!50001 DROP VIEW IF EXISTS `treeInteractionOverview`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeInteractionOverview` AS select `interactions`.`interactionID` AS `interactionID`,`interactions`.`userID` AS `userID`,`interactions`.`treeID` AS `treeID`,`interactions`.`interactionCreatedAt` AS `interactionCreatedAt` from `treeInteractions` `interactions` where (`interactions`.`interactionType` = 'overview') order by `interactions`.`interactionID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeInteractionQuestion`
--

/*!50001 DROP VIEW IF EXISTS `treeInteractionQuestion`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeInteractionQuestion` AS select `interactions`.`interactionID` AS `interactionID`,`interactions`.`userID` AS `userID`,`interactions`.`treeID` AS `treeID`,`state`.`elID` AS `questionID`,`interactions`.`interactionCreatedAt` AS `interactionCreatedAt` from (`treeInteractions` `interactions` join `treeState` `state` on((`interactions`.`interactionID` = `state`.`interactionID`))) where (`interactions`.`stateType` = 'question') order by `interactions`.`interactionID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeInteractionReload`
--

/*!50001 DROP VIEW IF EXISTS `treeInteractionReload`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeInteractionReload` AS select `interactions`.`interactionID` AS `interactionID`,`interactions`.`userID` AS `userID`,`interactions`.`treeID` AS `treeID`,`interactions`.`interactionCreatedAt` AS `interactionCreatedAt` from `treeInteractions` `interactions` where (`interactions`.`interactionType` = 'reload') order by `interactions`.`interactionID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeInteractionStart`
--

/*!50001 DROP VIEW IF EXISTS `treeInteractionStart`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeInteractionStart` AS select `interactions`.`interactionID` AS `interactionID`,`interactions`.`userID` AS `userID`,`interactions`.`treeID` AS `treeID`,`interactions`.`stateType` AS `destinationStateType`,`state`.`elID` AS `destinationStateID`,`interactions`.`interactionCreatedAt` AS `interactionCreatedAt` from (`treeInteractions` `interactions` join `treeState` `state` on((`interactions`.`interactionID` = `state`.`interactionID`))) where (`interactions`.`interactionType` = 'start') order by `interactions`.`interactionID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeInteractions`
--

/*!50001 DROP VIEW IF EXISTS `treeInteractions`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeInteractions` AS select `interaction`.`interactionID` AS `interactionID`,`interaction`.`userID` AS `userID`,`interaction`.`treeID` AS `treeID`,`interactionType`.`interactionType` AS `interactionType`,`stateType`.`stateType` AS `stateType`,`interaction`.`interactionCreatedAt` AS `interactionCreatedAt` from ((`treeInteraction` `interaction` join `treeInteractionType` `interactionType` on((`interaction`.`interactionTypeID` = `interactionType`.`interactionTypeID`))) join `treeStateType` `stateType` on((`interaction`.`stateTypeID` = `stateType`.`stateTypeID`))) order by `interaction`.`interactionID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeInteractionsMaxDateByUserAndTree`
--

/*!50001 DROP VIEW IF EXISTS `treeInteractionsMaxDateByUserAndTree`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeInteractionsMaxDateByUserAndTree` AS select `treeInteractions`.`userID` AS `userID`,`treeInteractions`.`treeID` AS `treeID`,max(`treeInteractions`.`interactionCreatedAt`) AS `interactionCreatedAt` from `treeInteractions` group by `treeInteractions`.`userID`,`treeInteractions`.`treeID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeOption`
--

/*!50001 DROP VIEW IF EXISTS `treeOption`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeOption` AS select `el`.`elID` AS `optionID`,`el`.`treeID` AS `treeID`,`question`.`elID` AS `questionID`,`el`.`elTitle` AS `title`,`el`.`elContent` AS `content`,`elOrder`.`elOrder` AS `order`,`destination`.`elIDDestination` AS `destinationID`,`destinationType`.`elType` AS `destinationType`,`el`.`elDeleted` AS `deleted` from ((((((`treeElement` `el` join `treeElementType` `elType` on((`el`.`elTypeID` = `elType`.`elTypeID`))) join `treeElementOrder` `elOrder` on((`el`.`elID` = `elOrder`.`elID`))) join `treeElementContainer` `question` on((`el`.`elID` = `question`.`elIDChild`))) left join `treeElementDestination` `destination` on((`el`.`elID` = `destination`.`elID`))) left join `treeElement` `destinationEl` on((`destinationEl`.`elID` = `destination`.`elIDDestination`))) left join `treeElementType` `destinationType` on((`destinationType`.`elTypeID` = `destinationEl`.`elTypeID`))) where (`elType`.`elType` = 'option') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeQuestion`
--

/*!50001 DROP VIEW IF EXISTS `treeQuestion`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeQuestion` AS select `el`.`elID` AS `questionID`,`el`.`treeID` AS `treeID`,`elGroup`.`elID` AS `groupID`,`el`.`elTitle` AS `title`,`el`.`elContent` AS `content`,`elOrder`.`elOrder` AS `order`,`el`.`elDeleted` AS `deleted` from (((`treeElement` `el` join `treeElementType` `elType` on((`el`.`elTypeID` = `elType`.`elTypeID`))) join `treeElementOrder` `elOrder` on((`el`.`elID` = `elOrder`.`elID`))) left join `treeElementContainer` `elGroup` on((`el`.`elID` = `elGroup`.`elIDChild`))) where (`elType`.`elType` = 'question') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeStart`
--

/*!50001 DROP VIEW IF EXISTS `treeStart`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeStart` AS select `el`.`elID` AS `startID`,`el`.`treeID` AS `treeID`,`el`.`elTitle` AS `title`,`el`.`elContent` AS `content`,`destination`.`elIDDestination` AS `destinationID`,`el`.`elDeleted` AS `deleted` from ((`treeElement` `el` join `treeElementType` `elType` on((`el`.`elTypeID` = `elType`.`elTypeID`))) left join `treeElementDestination` `destination` on((`el`.`elID` = `destination`.`elID`))) where (`elType`.`elType` = 'start') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeStateBounce`
--

/*!50001 DROP VIEW IF EXISTS `treeStateBounce`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeStateBounce` AS select `interactions`.`interactionID` AS `interactionID`,`interactions`.`treeID` AS `treeID`,`interactions`.`stateType` AS `stateBounced`,`state`.`elID` AS `elID`,`interactions`.`interactionCreatedAt` AS `interactionCreatedAt` from ((`treeInteractions` `interactions` left join `treeState` `state` on((`interactions`.`interactionID` = `state`.`interactionID`))) join `treeInteractionsMaxDateByUserAndTree` `maxDate` on(((`interactions`.`userID` = `maxDate`.`userID`) and (`interactions`.`interactionCreatedAt` = `maxDate`.`interactionCreatedAt`)))) order by `interactions`.`interactionID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeapi`
--

/*!50001 DROP VIEW IF EXISTS `treeapi`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeapi` AS select `tree`.`treeID` AS `treeID`,`tree`.`treeSlug` AS `treeSlug`,`tree`.`treeTitle` AS `title`,`tree`.`treeContent` AS `content`,`tree`.`treeCreatedAt` AS `createdAt`,`tree`.`treeUpdatedAt` AS `updatedAt`,`tree`.`treeOwner` AS `owner`,`tree`.`treeDeleted` AS `deleted` from `tree` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeend`
--

/*!50001 DROP VIEW IF EXISTS `treeend`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeend` AS select `el`.`elID` AS `endID`,`el`.`treeID` AS `treeID`,`el`.`elTitle` AS `title`,`el`.`elContent` AS `content`,`el`.`elDeleted` AS `deleted` from (`treeElement` `el` join `treeElementType` `elType` on((`el`.`elTypeID` = `elType`.`elTypeID`))) where (`elType`.`elType` = 'end') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treegroup`
--

/*!50001 DROP VIEW IF EXISTS `treegroup`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treegroup` AS select `el`.`elID` AS `groupID`,`el`.`treeID` AS `treeID`,`el`.`elTitle` AS `title`,`el`.`elContent` AS `content`,`elOrder`.`elOrder` AS `order`,`el`.`elDeleted` AS `deleted` from ((`treeElement` `el` join `treeElementType` `elType` on((`el`.`elTypeID` = `elType`.`elTypeID`))) join `treeElementOrder` `elOrder` on((`el`.`elID` = `elOrder`.`elID`))) where (`elType`.`elType` = 'group') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeinteractionend`
--

/*!50001 DROP VIEW IF EXISTS `treeinteractionend`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeinteractionend` AS select `interactions`.`interactionID` AS `interactionID`,`interactions`.`userID` AS `userID`,`interactions`.`treeID` AS `treeID`,`state`.`elID` AS `endID`,`interactions`.`interactionCreatedAt` AS `interactionCreatedAt` from (`treeinteractions` `interactions` join `treeState` `state` on((`interactions`.`interactionID` = `state`.`interactionID`))) where (`interactions`.`stateType` = 'end') order by `interactions`.`interactionID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeinteractionhistory`
--

/*!50001 DROP VIEW IF EXISTS `treeinteractionhistory`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeinteractionhistory` AS select `interactions`.`interactionID` AS `interactionID`,`interactions`.`userID` AS `userID`,`interactions`.`treeID` AS `treeID`,`interactions`.`stateType` AS `destinationStateType`,`state`.`elID` AS `destinationStateID`,`interactions`.`interactionCreatedAt` AS `interactionCreatedAt` from (`treeinteractions` `interactions` left join `treeState` `state` on((`interactions`.`interactionID` = `state`.`interactionID`))) where (`interactions`.`interactionType` = 'history') order by `interactions`.`interactionID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeinteractionload`
--

/*!50001 DROP VIEW IF EXISTS `treeinteractionload`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeinteractionload` AS select `interactions`.`interactionID` AS `interactionID`,`interactions`.`userID` AS `userID`,`interactions`.`treeID` AS `treeID`,`interactions`.`interactionCreatedAt` AS `interactionCreatedAt` from `treeinteractions` `interactions` where (`interactions`.`interactionType` = 'load') order by `interactions`.`interactionID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeinteractionoption`
--

/*!50001 DROP VIEW IF EXISTS `treeinteractionoption`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeinteractionoption` AS select `interactions`.`interactionID` AS `interactionID`,`interactions`.`userID` AS `userID`,`interactions`.`treeID` AS `treeID`,`interactionEl`.`elID` AS `optionID`,`interactions`.`stateType` AS `destinationStateType`,`state`.`elID` AS `destinationStateID`,`interactions`.`interactionCreatedAt` AS `interactionCreatedAt` from ((`treeinteractions` `interactions` left join `treeState` `state` on((`interactions`.`interactionID` = `state`.`interactionID`))) join `treeInteractionElement` `interactionEl` on((`interactions`.`interactionID` = `interactionEl`.`interactionID`))) where (`interactions`.`interactionType` = 'option') order by `interactions`.`interactionID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeinteractionoverview`
--

/*!50001 DROP VIEW IF EXISTS `treeinteractionoverview`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeinteractionoverview` AS select `interactions`.`interactionID` AS `interactionID`,`interactions`.`userID` AS `userID`,`interactions`.`treeID` AS `treeID`,`interactions`.`interactionCreatedAt` AS `interactionCreatedAt` from `treeinteractions` `interactions` where (`interactions`.`interactionType` = 'overview') order by `interactions`.`interactionID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeinteractionquestion`
--

/*!50001 DROP VIEW IF EXISTS `treeinteractionquestion`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeinteractionquestion` AS select `interactions`.`interactionID` AS `interactionID`,`interactions`.`userID` AS `userID`,`interactions`.`treeID` AS `treeID`,`state`.`elID` AS `questionID`,`interactions`.`interactionCreatedAt` AS `interactionCreatedAt` from (`treeinteractions` `interactions` join `treeState` `state` on((`interactions`.`interactionID` = `state`.`interactionID`))) where (`interactions`.`stateType` = 'question') order by `interactions`.`interactionID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeinteractionreload`
--

/*!50001 DROP VIEW IF EXISTS `treeinteractionreload`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeinteractionreload` AS select `interactions`.`interactionID` AS `interactionID`,`interactions`.`userID` AS `userID`,`interactions`.`treeID` AS `treeID`,`interactions`.`interactionCreatedAt` AS `interactionCreatedAt` from `treeinteractions` `interactions` where (`interactions`.`interactionType` = 'reload') order by `interactions`.`interactionID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeinteractions`
--

/*!50001 DROP VIEW IF EXISTS `treeinteractions`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeinteractions` AS select `interaction`.`interactionID` AS `interactionID`,`interaction`.`userID` AS `userID`,`interaction`.`treeID` AS `treeID`,`interactionType`.`interactionType` AS `interactionType`,`stateType`.`stateType` AS `stateType`,`interaction`.`interactionCreatedAt` AS `interactionCreatedAt` from ((`treeInteraction` `interaction` join `treeInteractionType` `interactionType` on((`interaction`.`interactionTypeID` = `interactionType`.`interactionTypeID`))) join `treeStateType` `stateType` on((`interaction`.`stateTypeID` = `stateType`.`stateTypeID`))) order by `interaction`.`interactionID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeinteractionsmaxdatebyuserandtree`
--

/*!50001 DROP VIEW IF EXISTS `treeinteractionsmaxdatebyuserandtree`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeinteractionsmaxdatebyuserandtree` AS select `treeinteractions`.`userID` AS `userID`,`treeinteractions`.`treeID` AS `treeID`,max(`treeinteractions`.`interactionCreatedAt`) AS `interactionCreatedAt` from `treeinteractions` group by `treeinteractions`.`userID`,`treeinteractions`.`treeID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeinteractionstart`
--

/*!50001 DROP VIEW IF EXISTS `treeinteractionstart`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeinteractionstart` AS select `interactions`.`interactionID` AS `interactionID`,`interactions`.`userID` AS `userID`,`interactions`.`treeID` AS `treeID`,`interactions`.`stateType` AS `destinationStateType`,`state`.`elID` AS `destinationStateID`,`interactions`.`interactionCreatedAt` AS `interactionCreatedAt` from (`treeinteractions` `interactions` join `treeState` `state` on((`interactions`.`interactionID` = `state`.`interactionID`))) where (`interactions`.`interactionType` = 'start') order by `interactions`.`interactionID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treeoption`
--

/*!50001 DROP VIEW IF EXISTS `treeoption`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treeoption` AS select `el`.`elID` AS `optionID`,`el`.`treeID` AS `treeID`,`question`.`elID` AS `questionID`,`el`.`elTitle` AS `title`,`el`.`elContent` AS `content`,`elOrder`.`elOrder` AS `order`,`destination`.`elIDDestination` AS `destinationID`,`destinationType`.`elType` AS `destinationType`,`el`.`elDeleted` AS `deleted` from ((((((`treeElement` `el` join `treeElementType` `elType` on((`el`.`elTypeID` = `elType`.`elTypeID`))) join `treeElementOrder` `elOrder` on((`el`.`elID` = `elOrder`.`elID`))) join `treeElementContainer` `question` on((`el`.`elID` = `question`.`elIDChild`))) left join `treeElementDestination` `destination` on((`el`.`elID` = `destination`.`elID`))) left join `treeElement` `destinationEl` on((`destinationEl`.`elID` = `destination`.`elIDDestination`))) left join `treeElementType` `destinationType` on((`destinationType`.`elTypeID` = `destinationEl`.`elTypeID`))) where (`elType`.`elType` = 'option') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treequestion`
--

/*!50001 DROP VIEW IF EXISTS `treequestion`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treequestion` AS select `el`.`elID` AS `questionID`,`el`.`treeID` AS `treeID`,`elGroup`.`elID` AS `groupID`,`el`.`elTitle` AS `title`,`el`.`elContent` AS `content`,`elOrder`.`elOrder` AS `order`,`el`.`elDeleted` AS `deleted` from (((`treeElement` `el` join `treeElementType` `elType` on((`el`.`elTypeID` = `elType`.`elTypeID`))) join `treeElementOrder` `elOrder` on((`el`.`elID` = `elOrder`.`elID`))) left join `treeElementContainer` `elGroup` on((`el`.`elID` = `elGroup`.`elIDChild`))) where (`elType`.`elType` = 'question') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treestart`
--

/*!50001 DROP VIEW IF EXISTS `treestart`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treestart` AS select `el`.`elID` AS `startID`,`el`.`treeID` AS `treeID`,`el`.`elTitle` AS `title`,`el`.`elContent` AS `content`,`destination`.`elIDDestination` AS `destinationID`,`el`.`elDeleted` AS `deleted` from ((`treeElement` `el` join `treeElementType` `elType` on((`el`.`elTypeID` = `elType`.`elTypeID`))) left join `treeElementDestination` `destination` on((`el`.`elID` = `destination`.`elID`))) where (`elType`.`elType` = 'start') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `treestatebounce`
--

/*!50001 DROP VIEW IF EXISTS `treestatebounce`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`cmetree`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `treestatebounce` AS select `interactions`.`interactionID` AS `interactionID`,`interactions`.`treeID` AS `treeID`,`interactions`.`stateType` AS `stateBounced`,`state`.`elID` AS `elID`,`interactions`.`interactionCreatedAt` AS `interactionCreatedAt` from ((`treeinteractions` `interactions` left join `treeState` `state` on((`interactions`.`interactionID` = `state`.`interactionID`))) join `treeinteractionsmaxdatebyuserandtree` `maxDate` on(((`interactions`.`userID` = `maxDate`.`userID`) and (`interactions`.`interactionCreatedAt` = `maxDate`.`interactionCreatedAt`)))) order by `interactions`.`interactionID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50112 SET @disable_bulk_load = IF (@is_rocksdb_supported, 'SET SESSION rocksdb_bulk_load = @old_rocksdb_bulk_load', 'SET @dummy_rocksdb_bulk_load = 0') */;
/*!50112 PREPARE s FROM @disable_bulk_load */;
/*!50112 EXECUTE s */;
/*!50112 DEALLOCATE PREPARE s */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
