-- MySQL dump 10.13  Distrib 8.0.46, for Linux (x86_64)
--
-- Host: localhost    Database: bantaypurrpaws
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `adoption_applications`
--

DROP TABLE IF EXISTS `adoption_applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `adoption_applications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pet_id` int NOT NULL,
  `user_id` int NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `contact_number` varchar(512) NOT NULL,
  `email` varchar(512) NOT NULL,
  `address` text,
  `occupation` varchar(100) NOT NULL,
  `reason_for_adoption` text,
  `home_type` varchar(80) DEFAULT NULL,
  `existing_pets` enum('yes','no') NOT NULL,
  `agreement` tinyint(1) NOT NULL DEFAULT '0',
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `schedule_date` date DEFAULT NULL,
  `schedule_time` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `pet_id` (`pet_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `adoption_applications_ibfk_1` FOREIGN KEY (`pet_id`) REFERENCES `pets` (`id`) ON DELETE CASCADE,
  CONSTRAINT `adoption_applications_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adoption_applications`
--

LOCK TABLES `adoption_applications` WRITE;
/*!40000 ALTER TABLE `adoption_applications` DISABLE KEYS */;
INSERT INTO `adoption_applications` VALUES (4,5,17,'Jeofrey James Colon','enc:v1:V122PdUPPRSmjZkKXzougr1TWJdIFzbzTHQMFZfoTHS+jidyjog5YNo02Ecblpbc8ClR','enc:v1:L1XYT+f3VDtQ5CZ4QOpkOXD3URXLAFsNzfVfD3K+DK8BA5SOHvroOHN72+AhwjDXqhRZJLTZh/IcrUpjB/wz',NULL,'Kssmms',NULL,NULL,'yes',1,'approved','2026-06-07 12:44:08','2026-06-07 12:48:04','2026-06-30','20:44:00');
/*!40000 ALTER TABLE `adoption_applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blocked_ips`
--

DROP TABLE IF EXISTS `blocked_ips`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blocked_ips` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ip_address` varchar(64) NOT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `blocked_by` int DEFAULT NULL,
  `risk_score` int NOT NULL DEFAULT '0',
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ip_address` (`ip_address`),
  KEY `blocked_by` (`blocked_by`),
  CONSTRAINT `blocked_ips_ibfk_1` FOREIGN KEY (`blocked_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blocked_ips`
--

LOCK TABLES `blocked_ips` WRITE;
/*!40000 ALTER TABLE `blocked_ips` DISABLE KEYS */;
/*!40000 ALTER TABLE `blocked_ips` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_attempts`
--

DROP TABLE IF EXISTS `login_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_attempts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `email` varchar(512) NOT NULL,
  `ip_address` varchar(64) NOT NULL,
  `user_agent` text,
  `device_type` varchar(100) DEFAULT NULL,
  `browser` varchar(100) DEFAULT NULL,
  `os` varchar(100) DEFAULT NULL,
  `device_fingerprint` varchar(128) DEFAULT NULL,
  `location_country` varchar(100) DEFAULT NULL,
  `location_city` varchar(100) DEFAULT NULL,
  `risk_level` enum('low','medium','high','critical') NOT NULL DEFAULT 'low',
  `status` enum('pending','approved','denied','otp_sent','verified','failed','blocked','suspicious') NOT NULL DEFAULT 'pending',
  `challenge_token` varchar(128) DEFAULT NULL,
  `number_shown` tinyint DEFAULT NULL,
  `number_options` varchar(20) DEFAULT NULL,
  `number_matched` tinyint(1) DEFAULT NULL,
  `email_action` enum('approved','denied') DEFAULT NULL,
  `is_suspicious` tinyint(1) NOT NULL DEFAULT '0',
  `attempts_count` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_la_email` (`email`(191)),
  KEY `idx_la_ip` (`ip_address`),
  KEY `idx_la_fingerprint` (`device_fingerprint`),
  KEY `idx_la_status` (`status`),
  KEY `idx_la_created` (`created_at`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `login_attempts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_attempts`
--

LOCK TABLES `login_attempts` WRITE;
/*!40000 ALTER TABLE `login_attempts` DISABLE KEYS */;
INSERT INTO `login_attempts` VALUES (1,13,'anthony.domasig@evsu.edu.ph','::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','Desktop','Chrome 149','Linux','04b9a0a9fbf890252494475e46b6976afe4751e4166d576fc63851f217c18396',NULL,NULL,'low','failed',NULL,NULL,NULL,NULL,NULL,0,0,'2026-06-07 02:34:52','2026-06-07 02:34:52'),(2,13,'anthony.domasig@evsu.edu.ph','::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','Desktop','Chrome 149','Linux','04b9a0a9fbf890252494475e46b6976afe4751e4166d576fc63851f217c18396',NULL,NULL,'low','verified','6a9940032da89deb4f7ec05485c2eb0764d5f1eefb18aaa0',61,'70,61,31',1,'approved',0,0,'2026-06-07 02:36:04','2026-06-07 02:36:29'),(3,13,'anthony.domasig@evsu.edu.ph','::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','Desktop','Chrome 149','Linux','04b9a0a9fbf890252494475e46b6976afe4751e4166d576fc63851f217c18396',NULL,NULL,'low','verified','6b4c7d42dad2f01c0014e13e884b101035c2bf52997e6071',15,'27,38,15',1,'approved',0,0,'2026-06-07 02:48:49','2026-06-07 02:49:29'),(4,13,'anthony.domasig@evsu.edu.ph','::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','Desktop','Chrome 149','Linux','04b9a0a9fbf890252494475e46b6976afe4751e4166d576fc63851f217c18396',NULL,NULL,'low','failed',NULL,NULL,NULL,NULL,NULL,0,0,'2026-06-07 02:54:21','2026-06-07 02:54:21'),(5,13,'anthony.domasig@evsu.edu.ph','::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','Desktop','Chrome 149','Linux','04b9a0a9fbf890252494475e46b6976afe4751e4166d576fc63851f217c18396',NULL,NULL,'medium','failed','66af7839399180b7bcad95b85287e5f4cbaedb93447c0514',19,'22,19,49',0,'approved',0,0,'2026-06-07 02:54:32','2026-06-07 02:54:55'),(6,13,'anthony.domasig@evsu.edu.ph','::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','Desktop','Chrome 149','Linux','04b9a0a9fbf890252494475e46b6976afe4751e4166d576fc63851f217c18396',NULL,NULL,'medium','verified','517d356c7e8535cb38103ef760fbaf4ad5f7f4bec2814e6b',33,'33,37,48',1,'approved',0,0,'2026-06-07 03:50:23','2026-06-07 03:50:46'),(7,13,'anthony.domasig@evsu.edu.ph','::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','Desktop','Chrome 149','Linux','04b9a0a9fbf890252494475e46b6976afe4751e4166d576fc63851f217c18396',NULL,NULL,'low','verified','d30d8649ac018b0c895db28bd96c2770d4c14a2aca105ecc',74,'90,52,74',1,'approved',0,0,'2026-06-07 05:20:13','2026-06-07 05:20:26'),(8,13,'anthony.domasig@evsu.edu.ph','::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','Desktop','Chrome 149','Linux','04b9a0a9fbf890252494475e46b6976afe4751e4166d576fc63851f217c18396',NULL,NULL,'low','verified','b6698f08267b02c94f4f6175a85d6e790d759667e8724181',58,'58,10,51',1,'approved',0,0,'2026-06-07 05:35:38','2026-06-07 05:36:02'),(9,13,'anthony.domasig@evsu.edu.ph','::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','Desktop','Chrome 149','Linux','bb69e4f4b748d0986ba3b86f7ab0b5d674797aeb98766de9f58de16fa078b6ec',NULL,NULL,'low','verified','fccaf33936a98b687b7ee78b688d88aec570890654a4ee3a',71,'51,95,71',1,'approved',0,0,'2026-06-07 08:45:41','2026-06-07 08:46:05'),(10,13,'anthony.domasig@evsu.edu.ph','::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','Desktop','Chrome 149','Linux','bb69e4f4b748d0986ba3b86f7ab0b5d674797aeb98766de9f58de16fa078b6ec',NULL,NULL,'low','approved','c89f6fab05212bea98f73d60e6f4b90a3c9b08c8f311d4a9',82,'82,67,20',NULL,'approved',0,0,'2026-06-07 08:59:22','2026-06-07 08:59:31'),(11,13,'anthony.domasig@evsu.edu.ph','::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','Desktop','Chrome 149','Linux','bb69e4f4b748d0986ba3b86f7ab0b5d674797aeb98766de9f58de16fa078b6ec',NULL,NULL,'low','approved','8883000f0e703de3a5f4d549f553b3ef9d50d640576fca2e',15,'88,59,15',NULL,'approved',0,0,'2026-06-07 09:19:29','2026-06-07 09:19:44'),(12,13,'anthony.domasig@evsu.edu.ph','::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','Desktop','Chrome 149','Linux','bb69e4f4b748d0986ba3b86f7ab0b5d674797aeb98766de9f58de16fa078b6ec',NULL,NULL,'low','verified','930cde6100566a5d3a996de0d784a33d09847bbcfd182944',31,'41,62,31',1,'approved',0,0,'2026-06-07 10:52:27','2026-06-07 11:10:38'),(13,13,'anthony.domasig@evsu.edu.ph','::1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','Desktop','Chrome 149','Linux','bb69e4f4b748d0986ba3b86f7ab0b5d674797aeb98766de9f58de16fa078b6ec',NULL,NULL,'low','verified','f52ef86810e45f9032f9d3cbada1036c34b44cba8a146638',25,'35,41,25',1,'approved',0,0,'2026-06-07 11:11:30','2026-06-07 11:12:01'),(14,13,'anthony.domasig@evsu.edu.ph','2405:8d40:48d2:809:f8d0:15ff:fe1e:fa51','Mozilla/5.0 (Linux; Android 14; LLY-LX2 Build/HONORLLY-L32; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/148.0.7778.178 Mobile Safari/537.36[FBAN/EMA;FBLC/en_US;FBAV/514.0.0.7.104;FBCX/modulariab;]','Mobile','Chrome 148','Android 14','db00765982c748827b8c84090da1a0c0313594dd87740b9f26cb1e5192d9e6c1',NULL,NULL,'low','verified','b550e7438edb3af644e716d46b4f0434de9894a895bcc6ec',35,'36,67,35',1,'approved',0,0,'2026-06-07 11:23:16','2026-06-07 11:25:45'),(15,14,'claudify0@gmail.com','143.44.164.57','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','Desktop','Chrome 149','Linux','ad251a742fc3bb838670dfb13b417423cccf48f4013b15bd8796e4e16fb0cdae',NULL,NULL,'low','pending','6994660846375db2181406a48bfc73b8725580b9b8137014',NULL,NULL,NULL,NULL,0,0,'2026-06-07 11:29:59','2026-06-07 11:29:59'),(16,14,'claudify0@gmail.com','143.44.164.57','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','Desktop','Chrome 149','Linux','ad251a742fc3bb838670dfb13b417423cccf48f4013b15bd8796e4e16fb0cdae',NULL,NULL,'low','failed',NULL,NULL,NULL,NULL,NULL,0,0,'2026-06-07 11:32:13','2026-06-07 11:32:13'),(17,14,'claudify0@gmail.com','143.44.164.57','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','Desktop','Chrome 149','Linux','ad251a742fc3bb838670dfb13b417423cccf48f4013b15bd8796e4e16fb0cdae',NULL,NULL,'low','pending','976728a47abaafc17722a899e79fbd714f28aa2ceac3211c',NULL,NULL,NULL,NULL,0,0,'2026-06-07 11:32:19','2026-06-07 11:32:19'),(18,14,'claudify0@gmail.com','2405:8d40:48d2:809:f8d0:15ff:fe1e:fa51','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36','Mobile','Chrome 148','Android 10','f3eb192175b04680fb2c6c665a07871fffb8c83f6d6169b964b02e1c5a60d45d',NULL,NULL,'low','verified','80f9f5f62bde405634682f720e85cf66b2c474d6fdf6f4c4',82,'26,28,82',1,'approved',0,0,'2026-06-07 11:37:22','2026-06-07 11:38:33'),(19,13,'anthony.domasig@evsu.edu.ph','143.44.164.57','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','Desktop','Chrome 149','Linux','ad251a742fc3bb838670dfb13b417423cccf48f4013b15bd8796e4e16fb0cdae',NULL,NULL,'low','verified','b7e9a42a5fb9bfb94e3527a5263a3f99f2b8f869c00c5ec9',84,'84,24,43',1,'approved',0,0,'2026-06-07 11:39:42','2026-06-07 11:42:10'),(20,14,'claudify0@gmail.com','143.44.164.57','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','Desktop','Chrome 149','Linux','ad251a742fc3bb838670dfb13b417423cccf48f4013b15bd8796e4e16fb0cdae',NULL,NULL,'low','verified','64744d87521b0e6f432ef70a32eadffb26737de857b722f8',65,'10,58,65',1,'approved',0,0,'2026-06-07 11:51:50','2026-06-07 11:52:25'),(21,13,'anthony.domasig@evsu.edu.ph','143.44.164.57','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','Desktop','Chrome 149','Linux','dfb6b7cc74213688607143183fe71c6b94611a86a5a81f0d05535b2219453c12',NULL,NULL,'low','verified','370eb1438d8108560cc7ac1a4a6c48fa1d7ab4b7a9147ce8',74,'13,26,74',1,'approved',0,0,'2026-06-07 11:54:28','2026-06-07 11:54:52'),(22,15,'algiepawaan@gmail.com','2405:8d40:48d2:809:f8d0:15ff:fe1e:fa51','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36','Mobile','Chrome 148','Android 10','f3eb192175b04680fb2c6c665a07871fffb8c83f6d6169b964b02e1c5a60d45d',NULL,NULL,'low','failed',NULL,NULL,NULL,NULL,NULL,0,0,'2026-06-07 11:55:11','2026-06-07 11:55:11'),(23,15,'algiepawaan@gmail.com','2405:8d40:48d2:809:f8d0:15ff:fe1e:fa51','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36','Mobile','Chrome 148','Android 10','f3eb192175b04680fb2c6c665a07871fffb8c83f6d6169b964b02e1c5a60d45d',NULL,NULL,'low','denied','d125433b79427908006ac38f4a7bafdb705187ec6021cd3f',NULL,NULL,NULL,'denied',1,0,'2026-06-07 11:55:23','2026-06-07 11:56:21'),(24,13,'anthony.domasig@evsu.edu.ph','143.44.164.57','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','Desktop','Chrome 149','Linux','ad251a742fc3bb838670dfb13b417423cccf48f4013b15bd8796e4e16fb0cdae',NULL,NULL,'low','verified','a7eb2e894fb96612441646dc237b2c6408018db7b670fb98',57,'30,57,76',1,'approved',0,0,'2026-06-07 12:26:13','2026-06-07 12:26:56'),(25,NULL,'juniferjose05@gmail.com','175.176.68.153','Mozilla/5.0 (Linux; Android 14; TECNO CK8n Build/UP1A.231005.007; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/148.0.7778.215 Mobile Safari/537.36 [FB_IAB/FB4A;FBAV/564.0.0.42.89;]','Mobile','Chrome 148','Android 14','bf71ebaf161ea021acac6a10fc7f7a42329abfc9f0f826e8039f115babe4944f',NULL,NULL,'low','failed',NULL,NULL,NULL,NULL,NULL,1,0,'2026-06-07 12:32:28','2026-06-07 12:32:28'),(26,13,'anthony.domasig@evsu.edu.ph','143.44.164.57','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','Desktop','Chrome 149','Linux','ad251a742fc3bb838670dfb13b417423cccf48f4013b15bd8796e4e16fb0cdae',NULL,NULL,'low','verified','3b14b73c4a0180999923f730138969d945a86f866c389cdc',92,'48,67,92',1,'approved',0,0,'2026-06-07 12:47:02','2026-06-07 12:47:28'),(27,19,'juniferjose05@gmail.com','175.176.68.153','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36','Desktop','Chrome 148','Linux','04f8e057e55e56926fb605b2a18446da179e29954603d20ec7338ddf6aa6c0fc',NULL,NULL,'low','verified','71e1fced50b82fc550b5353096601b769d3661ea5d0705d1',27,'27,14,76',1,'approved',0,0,'2026-06-07 13:05:25','2026-06-07 13:09:14'),(28,19,'juniferjose05@gmail.com','175.176.68.153','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36','Desktop','Chrome 148','Linux','04f8e057e55e56926fb605b2a18446da179e29954603d20ec7338ddf6aa6c0fc',NULL,NULL,'low','pending','2da1c9eb6123a182b3c0c2be0a9bef71c98649793643929e',NULL,NULL,NULL,NULL,0,0,'2026-06-07 13:06:57','2026-06-07 13:06:57');
/*!40000 ALTER TABLE `login_attempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `application_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `notification_type` varchar(32) NOT NULL DEFAULT 'adoption',
  `message` varchar(255) NOT NULL,
  `link_url` varchar(512) DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `application_id` (`application_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `adoption_applications` (`id`) ON DELETE CASCADE,
  CONSTRAINT `notifications_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,NULL,NULL,'system','Welcome to BantayPurrPaws! Your email was verified.',NULL,0,'2026-06-05 15:40:09'),(2,NULL,NULL,'system','You logged in successfully.',NULL,0,'2026-06-05 15:50:17'),(3,NULL,NULL,'system','You logged in successfully.',NULL,0,'2026-06-05 17:09:34'),(4,NULL,NULL,'system','You logged in successfully.',NULL,0,'2026-06-05 17:54:05'),(5,NULL,NULL,'system','Welcome to BantayPurrPaws! Your email was verified.',NULL,0,'2026-06-05 18:26:02'),(6,NULL,NULL,'system','You logged in successfully.',NULL,0,'2026-06-05 19:09:35'),(7,NULL,NULL,'system','You logged in successfully.',NULL,0,'2026-06-05 19:18:22'),(8,NULL,NULL,'system','You logged in successfully.',NULL,0,'2026-06-05 19:32:16'),(9,NULL,NULL,'system','Welcome to BantayPurrPaws! Your email was verified.',NULL,0,'2026-06-05 19:45:57'),(11,NULL,NULL,'system','You logged in successfully.',NULL,0,'2026-06-05 20:24:10'),(12,NULL,NULL,'system','You logged in successfully.',NULL,0,'2026-06-05 23:39:07'),(13,NULL,NULL,'system','You logged in successfully.',NULL,0,'2026-06-05 23:55:45'),(14,NULL,NULL,'system','You logged in successfully.',NULL,0,'2026-06-05 23:56:56'),(15,NULL,NULL,'announcement','Sample Announcement','announcements.php',0,'2026-06-06 00:21:26'),(16,NULL,NULL,'system','Welcome to BantayPurrPaws! Your email was verified.',NULL,1,'2026-06-06 00:26:01'),(17,NULL,NULL,'report','Watashi Wa submitted rescue report BPP-FAD5DC4F','admin/reports.php?q=BPP-FAD5DC4F',1,'2026-06-06 00:33:19'),(18,NULL,1,'system','You logged in successfully.',NULL,0,'2026-06-06 01:15:19'),(19,NULL,1,'system','You logged in successfully.',NULL,0,'2026-06-06 01:23:08'),(20,NULL,NULL,'system','You logged in successfully.',NULL,0,'2026-06-06 01:24:15'),(21,NULL,NULL,'system','Your account permissions have been updated by an administrator. Please re-login to apply the changes.',NULL,0,'2026-06-06 01:25:31'),(22,NULL,NULL,'system','You logged in successfully.',NULL,0,'2026-06-06 01:26:23'),(23,NULL,11,'system','Welcome to BantayPurrPaws! Your email was verified.',NULL,0,'2026-06-06 01:30:28'),(26,NULL,NULL,'system','You logged in successfully.',NULL,0,'2026-06-06 01:55:32'),(27,NULL,NULL,'system','Your account permissions have been updated by an administrator. Please re-login to apply the changes.',NULL,0,'2026-06-06 01:56:11'),(28,NULL,NULL,'system','You logged in successfully.',NULL,0,'2026-06-06 01:57:51'),(29,NULL,NULL,'system','Your account permissions have been updated by an administrator. Please re-login to apply the changes.',NULL,0,'2026-06-06 01:58:38'),(30,NULL,NULL,'system','You logged in successfully.',NULL,0,'2026-06-06 02:00:18'),(31,NULL,12,'system','You logged in successfully.',NULL,0,'2026-06-06 02:27:56'),(32,NULL,12,'system','Your account permissions have been updated by an administrator. Please re-login to apply the changes.',NULL,0,'2026-06-06 02:28:22'),(33,NULL,12,'system','Your account permissions have been updated by an administrator. Please re-login to apply the changes.',NULL,0,'2026-06-06 02:28:47'),(34,NULL,12,'system','Your account permissions have been updated by an administrator. Please re-login to apply the changes.',NULL,0,'2026-06-06 02:28:58'),(35,NULL,11,'announcement','Test Announcement role - Wally B on the house','announcements.php',1,'2026-06-06 02:29:22'),(36,NULL,12,'announcement','Test Announcement role - Wally B on the house','announcements.php',0,'2026-06-06 02:29:23'),(37,NULL,11,'system','You logged in successfully.',NULL,0,'2026-06-06 02:31:08'),(38,NULL,NULL,'report','Daniel Caesar submitted rescue report BPP-61B4656E','admin/reports.php?q=BPP-61B4656E',1,'2026-06-06 03:10:52'),(39,NULL,1,'system','You logged in successfully.',NULL,0,'2026-06-06 03:13:18'),(40,NULL,NULL,'report','Daniel Caesar submitted rescue report BPP-F298788A','admin/reports.php?q=BPP-F298788A',1,'2026-06-06 03:20:35'),(41,NULL,13,'system','You logged in successfully.',NULL,0,'2026-06-07 11:11:00'),(42,NULL,13,'system','You logged in successfully.',NULL,0,'2026-06-07 11:12:14'),(43,NULL,13,'system','You logged in successfully.',NULL,0,'2026-06-07 11:26:27'),(44,NULL,15,'system','Welcome to BantayPurrPaws! Your email was verified.',NULL,0,'2026-06-07 11:30:59'),(45,NULL,NULL,'report','Algie Pawaan submitted rescue report BPP-84BCC7BB','admin/reports.php?q=BPP-84BCC7BB',0,'2026-06-07 11:32:58'),(46,NULL,14,'system','You logged in successfully.',NULL,0,'2026-06-07 11:39:02'),(47,NULL,14,'system','Your account permissions have been updated by an administrator. Please re-login to apply the changes.',NULL,0,'2026-06-07 11:40:42'),(48,NULL,13,'system','You logged in successfully.',NULL,0,'2026-06-07 11:42:26'),(49,NULL,14,'system','Your account permissions have been updated by an administrator. Please re-login to apply the changes.',NULL,0,'2026-06-07 11:46:03'),(50,NULL,14,'system','Your account permissions have been updated by an administrator. Please re-login to apply the changes.',NULL,0,'2026-06-07 11:48:30'),(51,NULL,14,'system','You logged in successfully.',NULL,0,'2026-06-07 11:52:59'),(52,NULL,13,'system','You logged in successfully.',NULL,0,'2026-06-07 11:55:21'),(53,NULL,13,'system','You logged in successfully.',NULL,0,'2026-06-07 12:27:18'),(54,NULL,16,'system','Welcome to BantayPurrPaws! Your email was verified.',NULL,0,'2026-06-07 12:42:10'),(55,NULL,17,'system','Welcome to BantayPurrPaws! Your email was verified.',NULL,0,'2026-06-07 12:42:56'),(56,4,NULL,'adoption','Jeofrey James Colon applied to adopt Pete','admin/application.php?id=4',1,'2026-06-07 12:44:08'),(57,NULL,13,'system','You logged in successfully.',NULL,0,'2026-06-07 12:47:47'),(58,NULL,18,'system','Welcome to BantayPurrPaws! Your email was verified.',NULL,0,'2026-06-07 12:49:16'),(59,NULL,19,'system','Welcome to BantayPurrPaws! Your email was verified.',NULL,0,'2026-06-07 13:04:07');
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `otp_tokens`
--

DROP TABLE IF EXISTS `otp_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `otp_tokens` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(150) NOT NULL,
  `otp_code` char(6) NOT NULL,
  `purpose` varchar(60) NOT NULL DEFAULT 'registration',
  `expires_at` datetime NOT NULL,
  `used` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_otp_email_purpose` (`email`,`purpose`),
  KEY `idx_otp_expires` (`expires_at`)
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `otp_tokens`
--

LOCK TABLES `otp_tokens` WRITE;
/*!40000 ALTER TABLE `otp_tokens` DISABLE KEYS */;
INSERT INTO `otp_tokens` VALUES (1,'test+otp@example.com','973924','registration','2026-06-05 15:51:44',1,'2026-06-05 15:36:44'),(2,'test+otp@example.com','910920','registration','2026-06-05 15:51:58',1,'2026-06-05 15:36:58'),(3,'anthony.domasig@evsu.edu.ph','572603','registration','2026-06-05 15:54:54',1,'2026-06-05 15:39:54'),(4,'anthony.domasig@evsu.edu.ph','071578','registration','2026-06-05 16:04:34',1,'2026-06-05 15:49:34'),(5,'anthony.domasig@evsu.edu.ph','123618','registration','2026-06-05 16:08:16',1,'2026-06-05 15:53:16'),(6,'anthony.domasig@evsu.edu.ph','222324','registration','2026-06-05 16:11:35',1,'2026-06-05 15:56:35'),(7,'anthony.domasig@evsu.edu.ph','278251','registration','2026-06-05 16:17:17',1,'2026-06-05 16:02:17'),(8,'anthony.domasig@evsu.edu.ph','198172','registration','2026-06-05 16:25:31',1,'2026-06-05 16:10:31'),(9,'anthony.domasig@evsu.edu.ph','851636','registration','2026-06-05 16:25:51',1,'2026-06-05 16:10:51'),(10,'anthony.domasig@evsu.edu.ph','240594','registration','2026-06-05 16:29:16',1,'2026-06-05 16:14:16'),(11,'anthony.domasig@evsu.edu.ph','390566','registration','2026-06-05 16:31:46',1,'2026-06-05 16:16:46'),(12,'anthony.domasig@evsu.edu.ph','452817','registration','2026-06-05 16:32:28',1,'2026-06-05 16:17:28'),(13,'anthony.domasig@evsu.edu.ph','964250','registration','2026-06-05 16:34:01',1,'2026-06-05 16:19:01'),(14,'anthony.domasig@evsu.edu.ph','373600','registration','2026-06-05 16:44:09',1,'2026-06-05 16:29:09'),(15,'anthony.domasig@evsu.edu.ph','869074','registration','2026-06-05 16:45:51',1,'2026-06-05 16:30:51'),(16,'anthony.domasig@evsu.edu.ph','689507','registration','2026-06-05 16:47:19',1,'2026-06-05 16:32:19'),(17,'anthony.domasig@evsu.edu.ph','961265','registration','2026-06-05 16:48:58',1,'2026-06-05 16:33:58'),(18,'anthony.domasig@evsu.edu.ph','914570','registration','2026-06-05 16:57:11',1,'2026-06-05 16:42:11'),(19,'anthony.domasig@evsu.edu.ph','025379','registration','2026-06-05 17:11:53',1,'2026-06-05 16:56:53'),(20,'anthony.domasig@evsu.edu.ph','172502','registration','2026-06-05 17:22:54',1,'2026-06-05 17:07:54'),(21,'anthony.domasig@evsu.edu.ph','757074','registration','2026-06-05 17:25:58',1,'2026-06-05 17:10:58'),(22,'anthony.domasig@evsu.edu.ph','038487','registration','2026-06-05 18:08:17',1,'2026-06-05 17:53:17'),(23,'domasiganthony139@gmail.com','835515','registration','2026-06-05 18:40:39',1,'2026-06-05 18:25:39'),(24,'anthony.domasig@evsu.edu.ph','602231','registration','2026-06-05 19:24:03',1,'2026-06-05 19:09:03'),(25,'anthony.domasig@evsu.edu.ph','539145','registration','2026-06-05 19:32:51',1,'2026-06-05 19:17:51'),(26,'domasiganthony139@gmail.com','883029','registration','2026-06-05 19:43:18',1,'2026-06-05 19:28:18'),(27,'domasiganthony139@gmail.com','180597','registration','2026-06-05 19:44:13',1,'2026-06-05 19:29:13'),(28,'anthony.domasig@evsu.edu.ph','100248','registration','2026-06-05 19:46:47',1,'2026-06-05 19:31:47'),(29,'domasiganthony139@gmail.com','460700','registration','2026-06-05 19:59:59',1,'2026-06-05 19:44:59'),(30,'domasiganthony139@gmail.com','982789','profile_update','2026-06-05 20:36:06',1,'2026-06-05 20:21:06'),(31,'anthony.domasig@evsu.edu.ph','500145','registration','2026-06-05 20:38:53',1,'2026-06-05 20:23:53'),(32,'anthony.domasig@evsu.edu.ph','951434','registration','2026-06-05 23:53:26',1,'2026-06-05 23:38:26'),(33,'riccselling05@gmail.com','363594','registration','2026-06-06 00:10:22',1,'2026-06-05 23:55:22'),(34,'riccselling05@gmail.com','367540','registration','2026-06-06 00:11:33',1,'2026-06-05 23:56:33'),(35,'domasiganthony139@gmail.com','654011','registration','2026-06-06 00:37:31',1,'2026-06-06 00:22:31'),(36,'domasiganthony139@gmail.com','916620','registration','2026-06-06 00:40:03',1,'2026-06-06 00:25:03'),(37,'domasiganthony139@gmail.com','584894','profile_update','2026-06-06 00:45:44',1,'2026-06-06 00:30:44'),(38,'anthony.domasig@evsu.edu.ph','885269','registration','2026-06-06 01:28:15',1,'2026-06-06 01:13:15'),(39,'anthony.domasig@evsu.edu.ph','044924','registration','2026-06-06 01:37:48',1,'2026-06-06 01:22:48'),(40,'riccselling05@gmail.com','195350','registration','2026-06-06 01:38:55',1,'2026-06-06 01:23:55'),(41,'riccselling05@gmail.com','242387','registration','2026-06-06 01:40:49',1,'2026-06-06 01:25:49'),(42,'domasiganthony139@gmail.com','902517','registration','2026-06-06 01:44:09',1,'2026-06-06 01:29:09'),(43,'domasiganthony139@gmail.com','401307','profile_update','2026-06-06 01:45:59',1,'2026-06-06 01:30:59'),(44,'riccselling05@gmail.com','198310','registration','2026-06-06 02:07:20',1,'2026-06-06 01:52:20'),(45,'riccselling05@gmail.com','902291','password_reset','2026-06-06 02:07:54',1,'2026-06-06 01:52:54'),(46,'riccselling05@gmail.com','521359','registration','2026-06-06 02:09:28',1,'2026-06-06 01:54:28'),(47,'riccselling05@gmail.com','040493','registration','2026-06-06 02:11:45',1,'2026-06-06 01:56:45'),(48,'riccselling05@gmail.com','874296','registration','2026-06-06 02:12:18',1,'2026-06-06 01:57:18'),(49,'riccselling05@gmail.com','207387','registration','2026-06-06 02:14:56',1,'2026-06-06 01:59:56'),(50,'riccselling05@gmail.com','997437','registration','2026-06-06 02:25:33',1,'2026-06-06 02:10:33'),(51,'riccselling05@gmail.com','265308','password_reset','2026-06-06 02:25:57',1,'2026-06-06 02:10:57'),(52,'riccselling05@gmail.com','387091','registration','2026-06-06 02:26:27',1,'2026-06-06 02:11:27'),(53,'riccselling05@gmail.com','450151','password_reset','2026-06-06 02:30:29',1,'2026-06-06 02:15:29'),(54,'riccselling05@gmail.com','871225','registration','2026-06-06 02:40:30',1,'2026-06-06 02:25:30'),(55,'riccselling05@gmail.com','179512','password_reset','2026-06-06 02:41:25',1,'2026-06-06 02:26:25'),(56,'riccselling05@gmail.com','709045','registration','2026-06-06 02:42:33',1,'2026-06-06 02:27:33'),(57,'domasiganthony139@gmail.com','400654','registration','2026-06-06 02:45:09',1,'2026-06-06 02:30:09'),(58,'domasiganthony139@gmail.com','823425','registration','2026-06-06 02:45:46',1,'2026-06-06 02:30:46'),(59,'anthony.domasig@evsu.edu.ph','620933','registration','2026-06-06 03:26:20',1,'2026-06-06 03:11:20'),(60,'anthony.domasig@evsu.edu.ph','550062','password_reset','2026-06-06 03:26:46',1,'2026-06-06 03:11:46'),(61,'anthony.domasig@evsu.edu.ph','226189','registration','2026-06-06 03:27:53',1,'2026-06-06 03:12:53'),(62,'anthony.domasig@evsu.edu.ph','031960','password_reset','2026-06-07 02:50:13',1,'2026-06-07 02:35:13'),(63,'anthony.domasig@evsu.edu.ph','942071','login','2026-06-07 04:05:46',1,'2026-06-07 03:50:46'),(64,'anthony.domasig@evsu.edu.ph','214162','login','2026-06-07 05:35:27',1,'2026-06-07 05:20:27'),(65,'anthony.domasig@evsu.edu.ph','141056','password_reset','2026-06-07 05:49:14',1,'2026-06-07 05:34:14'),(66,'anthony.domasig@evsu.edu.ph','973139','login','2026-06-07 05:51:02',1,'2026-06-07 05:36:02'),(67,'anthony.domasig@evsu.edu.ph','836551','login','2026-06-07 09:01:05',1,'2026-06-07 08:46:05'),(68,'anthony.domasig@evsu.edu.ph','984499','login','2026-06-07 09:07:05',1,'2026-06-07 08:52:05'),(69,'anthony.domasig@evsu.edu.ph','063163','login','2026-06-07 09:10:47',1,'2026-06-07 08:55:47'),(70,'anthony.domasig@evsu.edu.ph','952025','login','2026-06-07 11:25:38',1,'2026-06-07 11:10:38'),(71,'anthony.domasig@evsu.edu.ph','079715','login','2026-06-07 11:27:02',1,'2026-06-07 11:12:02'),(72,'anthony.domasig@evsu.edu.ph','420655','profile_update','2026-06-07 11:27:27',1,'2026-06-07 11:12:27'),(73,'anthony.domasig@evsu.edu.ph','994928','login','2026-06-07 11:40:45',1,'2026-06-07 11:25:45'),(74,'algiepawaan@gmail.com','850936','registration','2026-06-07 11:45:09',1,'2026-06-07 11:30:09'),(75,'algiepawaan@gmail.com','675835','profile_update','2026-06-07 11:46:17',1,'2026-06-07 11:31:17'),(76,'claudify0@gmail.com','596480','login','2026-06-07 11:53:33',1,'2026-06-07 11:38:33'),(77,'anthony.domasig@evsu.edu.ph','390192','login','2026-06-07 11:57:10',1,'2026-06-07 11:42:10'),(78,'claudify0@gmail.com','054538','profile_update','2026-06-07 11:58:53',0,'2026-06-07 11:43:53'),(79,'claudify0@gmail.com','402852','login','2026-06-07 12:07:25',1,'2026-06-07 11:52:25'),(80,'anthony.domasig@evsu.edu.ph','107710','login','2026-06-07 12:09:52',1,'2026-06-07 11:54:52'),(81,'anthony.domasig@evsu.edu.ph','479317','login','2026-06-07 12:24:27',1,'2026-06-07 12:09:27'),(82,'anthony.domasig@evsu.edu.ph','731782','login','2026-06-07 12:41:56',1,'2026-06-07 12:26:56'),(83,'jeofreyjames.colon@evsu.edu.ph','826992','registration','2026-06-07 12:47:47',1,'2026-06-07 12:32:47'),(84,'jeofreyjamess@gmail.com','714683','registration','2026-06-07 12:56:13',1,'2026-06-07 12:41:13'),(85,'algie.pawaan@evsu.edu.ph','312208','registration','2026-06-07 12:56:18',1,'2026-06-07 12:41:18'),(86,'jeofreyjamess@gmail.com','030783','registration','2026-06-07 12:57:04',1,'2026-06-07 12:42:04'),(87,'jeofreyjamess@gmail.com','871249','profile_update','2026-06-07 12:58:22',1,'2026-06-07 12:43:22'),(88,'anthony.domasig@evsu.edu.ph','465758','login','2026-06-07 13:02:28',1,'2026-06-07 12:47:28'),(89,'riccselling05@gmail.com','542177','registration','2026-06-07 13:03:31',1,'2026-06-07 12:48:31'),(90,'juniferjose05@gmail.com','274330','registration','2026-06-07 13:18:11',1,'2026-06-07 13:03:11'),(91,'juniferjose05@gmail.com','082938','login','2026-06-07 13:24:14',0,'2026-06-07 13:09:14');
/*!40000 ALTER TABLE `otp_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pet_images`
--

DROP TABLE IF EXISTS `pet_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pet_images` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pet_id` int NOT NULL,
  `image_path` varchar(255) NOT NULL,
  `sort_order` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `pet_id` (`pet_id`),
  CONSTRAINT `pet_images_ibfk_1` FOREIGN KEY (`pet_id`) REFERENCES `pets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pet_images`
--

LOCK TABLES `pet_images` WRITE;
/*!40000 ALTER TABLE `pet_images` DISABLE KEYS */;
/*!40000 ALTER TABLE `pet_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pets`
--

DROP TABLE IF EXISTS `pets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `breed` varchar(100) NOT NULL,
  `age` varchar(50) NOT NULL,
  `gender` enum('Male','Female','Unknown') NOT NULL DEFAULT 'Unknown',
  `vaccination_status` varchar(150) DEFAULT NULL,
  `health_condition` text,
  `description` text,
  `adoption_requirements` text,
  `rescue_date` date DEFAULT NULL,
  `status` enum('available','pending_adoption','adopted') NOT NULL DEFAULT 'available',
  `image` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pets`
--

LOCK TABLES `pets` WRITE;
/*!40000 ALTER TABLE `pets` DISABLE KEYS */;
INSERT INTO `pets` VALUES (5,'Pete','Raged Barbarian','3','Male','Anti-venom','Raged','Introvert','','2026-04-29','adopted','uploads/pets/pet_6a2563ffaeb923.81436458.webp','2026-06-07 12:28:47','2026-06-07 12:48:04');
/*!40000 ALTER TABLE `pets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report_logs`
--

DROP TABLE IF EXISTS `report_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `report_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `report_id` int NOT NULL,
  `updated_by` int NOT NULL,
  `old_status` varchar(50) DEFAULT NULL,
  `new_status` varchar(50) DEFAULT NULL,
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `report_id` (`report_id`),
  KEY `updated_by` (`updated_by`),
  CONSTRAINT `report_logs_ibfk_1` FOREIGN KEY (`report_id`) REFERENCES `rescue_reports` (`id`) ON DELETE CASCADE,
  CONSTRAINT `report_logs_ibfk_2` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report_logs`
--

LOCK TABLES `report_logs` WRITE;
/*!40000 ALTER TABLE `report_logs` DISABLE KEYS */;
INSERT INTO `report_logs` VALUES (3,4,11,NULL,'pending','Report submitted by user.','2026-06-06 03:10:51'),(4,5,11,NULL,'pending','Report submitted by user.','2026-06-06 03:20:35'),(5,5,1,'pending','in_progress',NULL,'2026-06-06 03:20:45'),(6,5,1,'in_progress','rescued',NULL,'2026-06-06 03:20:52'),(7,4,1,'pending','failed',NULL,'2026-06-06 03:21:02'),(8,3,1,'pending','in_progress',NULL,'2026-06-06 03:21:12'),(9,3,1,'in_progress','rescued',NULL,'2026-06-06 03:21:16'),(10,2,1,'pending','in_progress',NULL,'2026-06-06 03:21:25'),(11,2,1,'in_progress','rescued',NULL,'2026-06-06 03:21:31'),(12,6,15,NULL,'pending','Report submitted by user.','2026-06-07 11:32:58'),(13,6,13,'pending','in_progress',NULL,'2026-06-07 11:55:28'),(14,6,14,'in_progress','rescued',NULL,'2026-06-07 11:55:39');
/*!40000 ALTER TABLE `report_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rescue_reports`
--

DROP TABLE IF EXISTS `rescue_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rescue_reports` (
  `id` int NOT NULL AUTO_INCREMENT,
  `report_code` varchar(20) NOT NULL,
  `reporter_id` int NOT NULL,
  `reporter_name` varchar(150) NOT NULL,
  `contact_number` varchar(512) NOT NULL,
  `animal_type` varchar(100) DEFAULT NULL,
  `location` text NOT NULL,
  `description` text,
  `photo_path` varchar(255) DEFAULT NULL,
  `status` enum('pending','in_progress','rescued','failed') NOT NULL DEFAULT 'pending',
  `assigned_to` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `report_code` (`report_code`),
  KEY `reporter_id` (`reporter_id`),
  KEY `assigned_to` (`assigned_to`),
  CONSTRAINT `rescue_reports_ibfk_1` FOREIGN KEY (`reporter_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `rescue_reports_ibfk_2` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rescue_reports`
--

LOCK TABLES `rescue_reports` WRITE;
/*!40000 ALTER TABLE `rescue_reports` DISABLE KEYS */;
INSERT INTO `rescue_reports` VALUES (2,'BPP-8B282FA1',11,'Daniel Caesar','enc:v1:c6FUDITzAVZ/UuECuqi3VerF48OkOiGOMGnhgFzQnK4/t7hNAyn4XxgonBHu/jyo74w+',NULL,'California, USA','Pet need help','uploads/reports/report_6a2386d92e0a16.55595438.jpg','rescued',NULL,'2026-06-06 02:32:57','2026-06-06 03:21:31'),(3,'BPP-F2FCF1F9',11,'Daniel Caesar','enc:v1:BsvUFSvWK7/1EO4IgVCumUNePS2DVWqoxZ4zMOS1AUjgjP1Yg0sqgdyDpkX2uedJn0lo',NULL,'California, USA','Test Reporting','uploads/reports/report_6a238b5f9a6959.72346277.jpg','rescued',NULL,'2026-06-06 02:52:15','2026-06-06 03:21:16'),(4,'BPP-61B4656E',11,'Daniel Caesar','enc:v1:+p911TImAOjBS7i/C9yk9MBWUjGrY+g8fK2P4r00YuVC5Lgy2hlAII+a2xGjGpg6sHkD',NULL,'California, USA','Need help','uploads/reports/report_6a238fbbf2a6b9.38846882.webp','failed',NULL,'2026-06-06 03:10:51','2026-06-06 03:21:02'),(5,'BPP-F298788A',11,'Daniel Caesar','enc:v1:rva47LT4U6LgQOihQp2Ji5ZyJ/v2Xo5aUoAf1mbtcUWPS3KNIDg6Mo7j4q9pYFUOwM3t','Cat','California, USA','Mwehehehe','uploads/reports/report_6a239203e7bf09.85140913.jpg','rescued',NULL,'2026-06-06 03:20:35','2026-06-06 03:20:52'),(6,'BPP-84BCC7BB',15,'Algie Pawaan','enc:v1:yT9gnMR3nSuCu0l2jPfMKzp1N87BIQ7/O7jLiEdorhCRBdBxXhTHCW4LnEq6uCkxps9B','Dog','Liloan',NULL,'uploads/reports/report_6a2556eaec7512.39169404.jpg','rescued',NULL,'2026-06-07 11:32:58','2026-06-07 11:55:39');
/*!40000 ALTER TABLE `rescue_reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `security_events`
--

DROP TABLE IF EXISTS `security_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `security_events` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `event_type` varchar(80) NOT NULL,
  `severity` enum('info','warning','critical') NOT NULL DEFAULT 'info',
  `ip_address` varchar(64) DEFAULT NULL,
  `description` text,
  `metadata` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_se_user` (`user_id`),
  KEY `idx_se_type` (`event_type`),
  KEY `idx_se_created` (`created_at`),
  CONSTRAINT `security_events_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `security_events`
--

LOCK TABLES `security_events` WRITE;
/*!40000 ALTER TABLE `security_events` DISABLE KEYS */;
INSERT INTO `security_events` VALUES (1,13,'login_failed','warning','::1','Password mismatch for anthony.domasig@evsu.edu.ph',NULL,'2026-06-07 02:34:52'),(2,13,'login_challenge_sent','info','::1','Challenge email sent for anthony.domasig@evsu.edu.ph',NULL,'2026-06-07 02:36:04'),(3,13,'login_approved_by_owner','info','::1','Owner approved login attempt',NULL,'2026-06-07 02:36:16'),(4,13,'number_match_success','info','::1','Number match passed, OTP sent',NULL,'2026-06-07 02:36:30'),(5,13,'otp_failed','warning','::1','OTP verification failed',NULL,'2026-06-07 02:36:55'),(6,13,'otp_failed','warning','::1','OTP verification failed',NULL,'2026-06-07 02:37:11'),(7,13,'otp_failed','warning','::1','OTP verification failed',NULL,'2026-06-07 02:37:12'),(8,13,'otp_failed','warning','::1','OTP verification failed',NULL,'2026-06-07 02:37:13'),(9,13,'otp_failed','warning','::1','OTP verification failed',NULL,'2026-06-07 02:37:13'),(10,13,'otp_failed','warning','::1','OTP verification failed',NULL,'2026-06-07 02:37:13'),(11,13,'otp_failed','warning','::1','OTP verification failed',NULL,'2026-06-07 02:37:13'),(12,13,'otp_failed','warning','::1','OTP verification failed',NULL,'2026-06-07 02:37:31'),(13,13,'login_challenge_sent','info','::1','Challenge email sent for anthony.domasig@evsu.edu.ph',NULL,'2026-06-07 02:48:50'),(14,13,'login_approved_by_owner','info','::1','Owner approved login attempt',NULL,'2026-06-07 02:48:59'),(15,13,'number_match_success','info','::1','Number match passed, OTP sent',NULL,'2026-06-07 02:49:30'),(16,13,'otp_failed','warning','::1','OTP verification failed',NULL,'2026-06-07 02:49:43'),(17,13,'otp_failed','warning','::1','OTP verification failed',NULL,'2026-06-07 02:51:05'),(18,13,'otp_failed','warning','::1','OTP verification failed',NULL,'2026-06-07 02:51:35'),(19,13,'otp_failed','warning','::1','OTP verification failed',NULL,'2026-06-07 02:52:02'),(20,13,'otp_failed','warning','::1','OTP verification failed',NULL,'2026-06-07 02:54:13'),(21,13,'login_failed','warning','::1','Password mismatch for anthony.domasig@evsu.edu.ph',NULL,'2026-06-07 02:54:21'),(22,13,'login_challenge_sent','info','::1','Challenge email sent for anthony.domasig@evsu.edu.ph',NULL,'2026-06-07 02:54:33'),(23,13,'login_approved_by_owner','info','::1','Owner approved login attempt',NULL,'2026-06-07 02:54:45'),(24,13,'number_match_failed','warning','::1','Number match failed',NULL,'2026-06-07 02:54:55'),(25,13,'login_challenge_sent','info','::1','Challenge email sent for anthony.domasig@evsu.edu.ph',NULL,'2026-06-07 03:50:24'),(26,13,'login_approved_by_owner','info','::1','Owner approved login attempt',NULL,'2026-06-07 03:50:42'),(27,13,'number_match_success','info','::1','Number match passed, OTP sent',NULL,'2026-06-07 03:50:47'),(28,13,'login_challenge_sent','info','::1','Challenge email sent for anthony.domasig@evsu.edu.ph',NULL,'2026-06-07 05:20:13'),(29,13,'login_approved_by_owner','info','::1','Owner approved login attempt',NULL,'2026-06-07 05:20:23'),(30,13,'number_match_success','info','::1','Number match passed, OTP sent',NULL,'2026-06-07 05:20:27'),(31,13,'otp_failed','warning','::1','OTP verification failed',NULL,'2026-06-07 05:21:10'),(32,13,'login_challenge_sent','info','::1','Challenge email sent for anthony.domasig@evsu.edu.ph',NULL,'2026-06-07 05:35:39'),(33,13,'login_approved_by_owner','info','::1','Owner approved login attempt',NULL,'2026-06-07 05:35:55'),(34,13,'number_match_success','info','::1','Number match passed, OTP sent',NULL,'2026-06-07 05:36:02'),(35,13,'login_challenge_sent','info','::1','Challenge email sent for anthony.domasig@evsu.edu.ph',NULL,'2026-06-07 08:45:42'),(36,13,'login_approved_by_owner','info','::1','Owner approved login attempt',NULL,'2026-06-07 08:45:53'),(37,13,'number_match_success','info','::1','Number match passed, OTP sent',NULL,'2026-06-07 08:46:06'),(38,13,'otp_failed','warning','::1','OTP verification failed',NULL,'2026-06-07 08:46:50'),(39,13,'otp_failed','warning','::1','OTP verification failed',NULL,'2026-06-07 08:52:03'),(40,13,'login_challenge_sent','info','::1','Challenge email sent for anthony.domasig@evsu.edu.ph',NULL,'2026-06-07 08:59:23'),(41,13,'login_approved_by_owner','info','::1','Owner approved login attempt',NULL,'2026-06-07 08:59:32'),(42,13,'login_challenge_sent','info','::1','Challenge email sent for anthony.domasig@evsu.edu.ph',NULL,'2026-06-07 09:19:30'),(43,13,'login_approved_by_owner','info','::1','Owner approved login attempt',NULL,'2026-06-07 09:19:44'),(44,13,'login_challenge_sent','info','::1','Challenge email sent for anthony.domasig@evsu.edu.ph',NULL,'2026-06-07 10:52:28'),(45,13,'login_approved_by_owner','info','::1','Owner approved login attempt',NULL,'2026-06-07 10:53:10'),(46,13,'number_match_success','info','::1','Number match passed, OTP sent',NULL,'2026-06-07 11:10:39'),(47,13,'login_success','info','::1','Successful login via enterprise auth',NULL,'2026-06-07 11:11:00'),(48,13,'login_challenge_sent','info','::1','Challenge email sent for anthony.domasig@evsu.edu.ph',NULL,'2026-06-07 11:11:30'),(49,13,'login_approved_by_owner','info','::1','Owner approved login attempt',NULL,'2026-06-07 11:11:41'),(50,13,'number_match_success','info','::1','Number match passed, OTP sent',NULL,'2026-06-07 11:12:02'),(51,13,'login_success','info','::1','Successful login via enterprise auth',NULL,'2026-06-07 11:12:14'),(52,13,'login_challenge_sent','info','2405:8d40:48d2:809:f8d0:15ff:fe1e:fa51','Challenge email sent for anthony.domasig@evsu.edu.ph',NULL,'2026-06-07 11:23:17'),(53,13,'login_approved_by_owner','info','143.44.164.57','Owner approved login attempt',NULL,'2026-06-07 11:24:39'),(54,13,'number_match_success','info','2405:8d40:48d2:809:f8d0:15ff:fe1e:fa51','Number match passed, OTP sent',NULL,'2026-06-07 11:25:45'),(55,13,'login_success','info','2405:8d40:48d2:809:f8d0:15ff:fe1e:fa51','Successful login via enterprise auth',NULL,'2026-06-07 11:26:27'),(56,14,'login_challenge_sent','info','143.44.164.57','Challenge email sent for claudify0@gmail.com',NULL,'2026-06-07 11:30:00'),(57,14,'login_failed','warning','143.44.164.57','Password mismatch for claudify0@gmail.com',NULL,'2026-06-07 11:32:13'),(58,14,'login_challenge_sent','info','143.44.164.57','Challenge email sent for claudify0@gmail.com',NULL,'2026-06-07 11:32:20'),(59,14,'login_challenge_sent','info','2405:8d40:48d2:809:f8d0:15ff:fe1e:fa51','Challenge email sent for claudify0@gmail.com',NULL,'2026-06-07 11:37:22'),(60,14,'login_approved_by_owner','info','143.44.164.57','Owner approved login attempt',NULL,'2026-06-07 11:38:12'),(61,14,'number_match_success','info','2405:8d40:48d2:809:f8d0:15ff:fe1e:fa51','Number match passed, OTP sent',NULL,'2026-06-07 11:38:34'),(62,14,'login_success','info','2405:8d40:48d2:809:f8d0:15ff:fe1e:fa51','Successful login via enterprise auth',NULL,'2026-06-07 11:39:02'),(63,13,'login_challenge_sent','info','143.44.164.57','Challenge email sent for anthony.domasig@evsu.edu.ph',NULL,'2026-06-07 11:39:42'),(64,13,'login_approved_by_owner','info','143.44.164.57','Owner approved login attempt',NULL,'2026-06-07 11:42:03'),(65,13,'number_match_success','info','143.44.164.57','Number match passed, OTP sent',NULL,'2026-06-07 11:42:11'),(66,13,'login_success','info','143.44.164.57','Successful login via enterprise auth',NULL,'2026-06-07 11:42:26'),(67,14,'login_challenge_sent','info','143.44.164.57','Challenge email sent for claudify0@gmail.com',NULL,'2026-06-07 11:51:51'),(68,14,'login_approved_by_owner','info','143.44.164.57','Owner approved login attempt',NULL,'2026-06-07 11:52:11'),(69,14,'number_match_success','info','143.44.164.57','Number match passed, OTP sent',NULL,'2026-06-07 11:52:26'),(70,14,'login_success','info','143.44.164.57','Successful login via enterprise auth',NULL,'2026-06-07 11:52:59'),(71,13,'login_challenge_sent','info','143.44.164.57','Challenge email sent for anthony.domasig@evsu.edu.ph',NULL,'2026-06-07 11:54:29'),(72,13,'login_approved_by_owner','info','143.44.164.57','Owner approved login attempt',NULL,'2026-06-07 11:54:44'),(73,13,'number_match_success','info','143.44.164.57','Number match passed, OTP sent',NULL,'2026-06-07 11:54:53'),(74,15,'login_failed','warning','2405:8d40:48d2:809:f8d0:15ff:fe1e:fa51','Password mismatch for algiepawaan@gmail.com',NULL,'2026-06-07 11:55:11'),(75,13,'login_success','info','143.44.164.57','Successful login via enterprise auth',NULL,'2026-06-07 11:55:21'),(76,15,'login_challenge_sent','info','2405:8d40:48d2:809:f8d0:15ff:fe1e:fa51','Challenge email sent for algiepawaan@gmail.com',NULL,'2026-06-07 11:55:24'),(77,15,'login_denied_by_owner','critical','2405:8d40:48d2:809:f8d0:15ff:fe1e:fa51','Owner denied login attempt via email','{\"ip\": \"2405:8d40:48d2:809:f8d0:15ff:fe1e:fa51\"}','2026-06-07 11:56:22'),(78,13,'login_challenge_sent','info','143.44.164.57','Challenge email sent for anthony.domasig@evsu.edu.ph',NULL,'2026-06-07 12:26:24'),(79,13,'login_approved_by_owner','info','143.44.164.57','Owner approved login attempt',NULL,'2026-06-07 12:26:47'),(80,13,'number_match_success','info','143.44.164.57','Number match passed, OTP sent',NULL,'2026-06-07 12:26:57'),(81,13,'login_success','info','143.44.164.57','Successful login via enterprise auth',NULL,'2026-06-07 12:27:18'),(82,13,'login_challenge_sent','info','143.44.164.57','Challenge email sent for anthony.domasig@evsu.edu.ph',NULL,'2026-06-07 12:47:03'),(83,13,'login_approved_by_owner','info','143.44.164.57','Owner approved login attempt',NULL,'2026-06-07 12:47:15'),(84,13,'number_match_success','info','143.44.164.57','Number match passed, OTP sent',NULL,'2026-06-07 12:47:29'),(85,13,'login_success','info','143.44.164.57','Successful login via enterprise auth',NULL,'2026-06-07 12:47:47'),(86,19,'login_challenge_sent','info','175.176.68.153','Challenge email sent for juniferjose05@gmail.com',NULL,'2026-06-07 13:05:28'),(87,19,'login_challenge_sent','info','175.176.68.153','Challenge email sent for juniferjose05@gmail.com',NULL,'2026-06-07 13:06:57'),(88,19,'login_approved_by_owner','info','175.176.68.153','Owner approved login attempt',NULL,'2026-06-07 13:08:14'),(89,19,'number_match_success','info','175.176.68.153','Number match passed, OTP sent',NULL,'2026-06-07 13:09:15');
/*!40000 ALTER TABLE `security_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_invites`
--

DROP TABLE IF EXISTS `staff_invites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_invites` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(150) NOT NULL,
  `token` varchar(64) NOT NULL,
  `permissions` json DEFAULT NULL,
  `expires_at` datetime NOT NULL,
  `used` tinyint(1) NOT NULL DEFAULT '0',
  `created_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `idx_invite_token` (`token`),
  KEY `idx_invite_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_invites`
--

LOCK TABLES `staff_invites` WRITE;
/*!40000 ALTER TABLE `staff_invites` DISABLE KEYS */;
INSERT INTO `staff_invites` VALUES (1,'riccselling05@gmail.com','4b9f4929e85738214a1c7a06bc180e939986c2cac43e7072bfab38ddf2b8c46e','[\"manage_pets\", \"view_adoptions\"]','2026-06-06 23:53:01',1,4,'2026-06-05 23:53:01'),(2,'riccselling05@gmail.com','b80f7810891aaa4c6a3e9f7dd805eb7fbe2a25bb7c6cffe85c4eee91253e0ca8','[\"manage_pets\", \"post_announcements\"]','2026-06-07 01:19:02',1,1,'2026-06-06 01:19:02'),(3,'riccselling05@gmail.com','c54d35daefcf0ab98ec094110c8ee47be8516e6b794c6a3a9a6174fb444be317','[\"manage_reports\", \"review_adoptions\"]','2026-06-07 01:23:17',1,1,'2026-06-06 01:23:17'),(4,'riccselling05@gmail.com','dd2c08bcf1da83765d2921c087332a597739acef38e4a47b8baa3cc52cf0da02','[]','2026-06-07 02:09:42',1,1,'2026-06-06 02:09:42'),(5,'claudify0@gmail.com','3b5b39ce3d8fd455508244c1fb50a150ba0184e53718768a46cb2108f5684284','[]','2026-06-08 11:28:27',1,13,'2026-06-07 11:28:27');
/*!40000 ALTER TABLE `staff_invites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trusted_devices`
--

DROP TABLE IF EXISTS `trusted_devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trusted_devices` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `device_fingerprint` varchar(128) NOT NULL,
  `device_name` varchar(150) DEFAULT NULL,
  `browser` varchar(100) DEFAULT NULL,
  `os` varchar(100) DEFAULT NULL,
  `ip_address` varchar(64) DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_td_user_fp` (`user_id`,`device_fingerprint`),
  CONSTRAINT `trusted_devices_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trusted_devices`
--

LOCK TABLES `trusted_devices` WRITE;
/*!40000 ALTER TABLE `trusted_devices` DISABLE KEYS */;
INSERT INTO `trusted_devices` VALUES (1,13,'04b9a0a9fbf890252494475e46b6976afe4751e4166d576fc63851f217c18396','Desktop','Chrome 149','Linux','::1','2026-06-07 05:20:45','2026-06-07 03:51:26','2026-07-07 05:20:45'),(3,13,'bb69e4f4b748d0986ba3b86f7ab0b5d674797aeb98766de9f58de16fa078b6ec','Desktop','Chrome 149','Linux','::1','2026-06-07 11:12:14','2026-06-07 05:36:26','2026-07-07 11:12:14'),(9,13,'db00765982c748827b8c84090da1a0c0313594dd87740b9f26cb1e5192d9e6c1','Mobile','Chrome 148','Android 14','2405:8d40:48d2:809:f8d0:15ff:fe1e:fa51','2026-06-07 11:26:27','2026-06-07 11:26:27','2026-07-07 11:26:27'),(10,14,'f3eb192175b04680fb2c6c665a07871fffb8c83f6d6169b964b02e1c5a60d45d','Mobile','Chrome 148','Android 10','2405:8d40:48d2:809:f8d0:15ff:fe1e:fa51','2026-06-07 11:39:02','2026-06-07 11:39:02','2026-07-07 11:39:02'),(11,13,'ad251a742fc3bb838670dfb13b417423cccf48f4013b15bd8796e4e16fb0cdae','Desktop','Chrome 149','Linux','143.44.164.57','2026-06-07 12:47:47','2026-06-07 11:42:26','2026-07-07 12:47:47'),(12,14,'ad251a742fc3bb838670dfb13b417423cccf48f4013b15bd8796e4e16fb0cdae','Desktop','Chrome 149','Linux','143.44.164.57','2026-06-07 11:52:59','2026-06-07 11:52:59','2026-07-07 11:52:59'),(13,13,'dfb6b7cc74213688607143183fe71c6b94611a86a5a81f0d05535b2219453c12','Desktop','Chrome 149','Linux','143.44.164.57','2026-06-07 11:55:21','2026-06-07 11:55:21','2026-07-07 11:55:21');
/*!40000 ALTER TABLE `trusted_devices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_sessions`
--

DROP TABLE IF EXISTS `user_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_sessions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `session_token` varchar(128) NOT NULL,
  `ip_address` varchar(64) DEFAULT NULL,
  `device_fingerprint` varchar(128) DEFAULT NULL,
  `user_agent` text,
  `browser` varchar(100) DEFAULT NULL,
  `os` varchar(100) DEFAULT NULL,
  `last_activity` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` timestamp NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_session_token` (`session_token`),
  KEY `idx_us_user` (`user_id`),
  CONSTRAINT `user_sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_sessions`
--

LOCK TABLES `user_sessions` WRITE;
/*!40000 ALTER TABLE `user_sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(150) NOT NULL,
  `email` varchar(512) NOT NULL,
  `email_hash` varchar(64) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `role` enum('user','staff','admin') NOT NULL DEFAULT 'user',
  `google_id` varchar(128) DEFAULT NULL,
  `avatar_url` varchar(512) DEFAULT NULL,
  `email_verified` tinyint(1) NOT NULL DEFAULT '0',
  `auth_provider` enum('local','google') NOT NULL DEFAULT 'local',
  `username` varchar(50) DEFAULT NULL,
  `phone_number` varchar(512) DEFAULT NULL,
  `profile_picture` varchar(512) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `staff_permissions` longtext,
  `permissions_changed_at` datetime DEFAULT NULL,
  `failed_login_count` int NOT NULL DEFAULT '0',
  `locked_until` timestamp NULL DEFAULT NULL,
  `last_login_at` timestamp NULL DEFAULT NULL,
  `last_login_ip` varchar(64) DEFAULT NULL,
  `risk_score` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_users_email_hash` (`email_hash`),
  UNIQUE KEY `uk_users_username` (`username`),
  UNIQUE KEY `uk_google_id` (`google_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'System Administrator','enc:v1:F/JBu4ljDqrZiAEz8+ce0fFPofsNH+gBu5s+UYonG6nVVN7I74RSkr+iFnrafPjO0JHfmkvLPAiQjuew/T2d2GOBXw==','c3ebf11075da34a687252b6fdaaa71be7a79afe4e37442a4a8e9ed2894fd4166','$2y$10$WRzdb5lztzmoJuE8glPmhedy3lLbUNaq775gjfyL95GHfeku8s9Da','admin',NULL,NULL,1,'local',NULL,NULL,NULL,'2026-06-06 01:12:47','2026-06-06 03:12:39',NULL,NULL,0,NULL,NULL,NULL,0),(11,'Daniel Caesar','enc:v1:TnrJySjBDOzHbBW5pNc3eslyheJqkVMttBCOmFNA9NCC+B66mScOJZWnbLATAObV1Ez9ejotZ3d9eXDbCp2mx0r8qw==','9fac7bca2eb1983976a9a7473833ea90951537925a0259e8529efcc0a76024c2','$2y$10$Bfy4kbuJtGndWIPZ7yRq7eXDElNkm7kLEiJMf3g0YcOFtBApkdtc2','user',NULL,NULL,1,'local',NULL,'enc:v1:f+J56Yj5mRUwtgLtBCX9N8yOQ92pkcAo7Z9cS3AA61Ly8k9/HU6lQV55SHLyM9+5vyes',NULL,'2026-06-06 01:30:28','2026-06-06 01:31:49',NULL,NULL,0,NULL,NULL,NULL,0),(12,'Wally Bayola','enc:v1:6FFRmna/Lc23FbtmEUSp+9THSnfHzsDIHVqi8lcmcs6IOC2iBoQIJYU/JCz4b16dwLpZli6RU39dLBKfv8he','303a551d6dd0fb4411bf3724b9292779b57297f362493fc87bf94079212f8735','$2y$10$0JXqYQUML36o0Y7rSicP8e1TLsL.fRgnRd54futjXXbpiz7c0L0sy','staff',NULL,NULL,1,'local','wallyb',NULL,NULL,'2026-06-06 02:10:26','2026-06-06 02:28:58','[\"manage_reports\",\"post_announcements\"]','2026-06-06 02:28:58',0,NULL,NULL,NULL,0),(13,'System Administrator','enc:v1:m+BYUhK8NiWBYY8reuEGoq3BDwzc//Sk/nyabscChvB//uvQhoIIgjv2w0gZU58VpIEAGZeza1zZZcs+aZHY+NI5ZQ==','c68c4c0127a2a132bc703b5e4d5b78b84c1d0ca4f1543023bccd71a1b379c94c','$2y$10$v1RjpBJ875jkAtrgAkS9Y.7/h2nibY/8e6Y5wEJzUOWHe7G2Lw6Py','admin',NULL,NULL,1,'local','shibal',NULL,NULL,'2026-06-07 02:34:11','2026-06-07 12:47:47',NULL,NULL,0,NULL,'2026-06-07 12:47:47','143.44.164.57',0),(14,'Algie and Colon','enc:v1:PaGzIjZbrE1YHGMATww3yVqKrMgOzIX6K4k5kgJHnsgIiWAIvSfITxR39V3nxA9KS/AjCsCgfDr8jI4=','df76553707cd93221c8dbb9d17eb87b87539fd2f35ee968d43861e4438f7f632','$2y$10$xGlqJiblrCsFbdjic3VAXeKAo1/gbCkP5lz7.jRB5EhTnCN7KFyBC','staff',NULL,NULL,1,'local','danielcaesar',NULL,NULL,'2026-06-07 11:29:45','2026-06-07 11:52:59','[\"manage_reports\",\"manage_pets\",\"review_adoptions\",\"post_announcements\"]','2026-06-07 11:48:30',0,NULL,'2026-06-07 11:52:59','143.44.164.57',0),(15,'Algie Pawaan','enc:v1:mR/glHoq5PbpmkP9j+A+dljK2AJeYqbu6gLzPlsWRtE00q1HIPhd2huhdF4vPXO0izyf+5lu5hleWVHLTw==','f43b73dbeb318002ed928cdfd7e58d29bbeb1644d5143bf7b99755394c4b1f53','$2y$10$ztIjF0np15B8S5VEu4084.URXhVemLz.fXOmnoZ0xgX3bPR7OZRMK','user',NULL,NULL,1,'local','heiskyrie','enc:v1:c7jZOEM86c7dvfBaSDoqYj+HrYVHVuW9iRlWy3MPPhaifOQVMjsU8LWxwXzar+EUqiDp',NULL,'2026-06-07 11:30:59','2026-06-07 11:55:10',NULL,NULL,1,NULL,NULL,NULL,0),(16,'He Chusan','enc:v1:8/6PpCmEM7sK+kmo3CZUvWJxBL5PK9QyZqZdOhydaCiuEgA5eTFRMnIlP/ki33h7mo+nYkZ4THkNmSIWb4x+ag==','0a028938d3c8fb934b17ba75076aeef76640d9713bf6d28ad09d372b0a5d8fa0','$2y$10$HfR51.XoTs2uzHIqS6h4yOrQCUUzDrPjfrmQT910/KQrHolzS7osa','user',NULL,NULL,1,'local',NULL,NULL,NULL,'2026-06-07 12:42:10','2026-06-07 12:42:10',NULL,NULL,0,NULL,NULL,NULL,0),(17,'Jeofrey James Colon','enc:v1:ymsJh3N0uagVEfE/yeQ7zZH0U+jpTD4wJZ76sSI3JG/9hxljfjXj6ozePrat/crDjvwqiuwoR4ousrlM6EHs','36e56cfc5db9820f98c16703c839cf28dc8f9f4a0c26c5a926c91edb99d06463','$2y$10$HOjpm4FtY.CUkWfPFcyi6.eXElYA2gVi.ztCNPhmlT/59EjhM4oze','user',NULL,NULL,1,'local','Jeofrey123','enc:v1:idHCwmc4+Rdllyy+uu1DM5dfjJJotVftFoohRuqZOKlEhv5yXlkNIM5SHRdm9iDAORbo',NULL,'2026-06-07 12:42:56','2026-06-07 12:43:39',NULL,NULL,0,NULL,NULL,NULL,0),(18,'Izumi Miyamura','enc:v1:PsFmJqP4Upn9uRro9oqx7p8fLA8fV41ILC2xStnuQjUbXVd7HWfWOyaPq41nV9uv4m3IqzDokRMu3oAlXFxH','a9c64ba3697d3aafdc37a3270614d4ceb22e1404ff2e30a6f38169a586b75e31','$2y$10$C1Fh26hzWCHSTHjfbTOQW.Fpy.hVKU5oCkwg/6DhfQ.slvRAkKHhe','user',NULL,NULL,1,'local',NULL,NULL,NULL,'2026-06-07 12:49:16','2026-06-07 12:49:16',NULL,NULL,0,NULL,NULL,NULL,0),(19,'Junifer Jose','enc:v1:eV9xUUGYXn+JVUAXvljevfwYrp1HaXWvrl6LWDTbLjmE04OBDtHmiMgG9gWw8oVVBcKsFdul1XQ+/DFR+Fic','0cb45affbb8347529eae95b044f55dafcfb67cf01189dd3b2794f7a594c42e2e','$2y$10$q5MjGd2Oc4mc6FtzX5fB/e52Zoen4VscriD9/vR4ZJUWGpznQOCCS','user',NULL,NULL,1,'local',NULL,NULL,NULL,'2026-06-07 13:04:07','2026-06-07 13:04:07',NULL,NULL,0,NULL,NULL,NULL,0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-07 22:01:21
