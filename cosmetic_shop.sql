CREATE DATABASE  IF NOT EXISTS `glowcart` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `glowcart`;
-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: glowcart
-- ------------------------------------------------------
-- Server version	8.0.45

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
-- Table structure for table `admins`
--

DROP TABLE IF EXISTS `admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admins` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admins`
--

LOCK TABLES `admins` WRITE;
/*!40000 ALTER TABLE `admins` DISABLE KEYS */;
INSERT INTO `admins` VALUES (1,'admin@gmail.com','admin123');
/*!40000 ALTER TABLE `admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'shalini07','shalini77@gmail.com','1007',NULL),(2,'Zach','Zach88@gmail.com','0708',NULL),(3,'vinod','vinod080701@gmail.com','shalini',NULL),(4,'Jennifer S','sam410701@gmail.com','14101502',NULL),(5,'jeevika V','jeevika@gmail.com','jeevika',NULL),(7,'anumitha S','anumithaj@12gmail.com','anumitha',NULL),(9,'Zach','Zach89@gmail.com','Zach89@gmail.com',NULL),(10,'Sharly','sharlymartini1@gmail.com','Vinod08@07','9876543210'),(12,'sharon xavier','sharon@gmail.com','Shar@xav123','1234567890'),(13,'Jennifer','jennifersam@email.com','Jennifer@10','8792264722'),(14,'Jenny','jennysam2002@gmail.com','Jenni@2002','8792264722'),(15,'Shalini','shaliniani07@gmail.com','Shalini@77','8792264139'),(16,'Shalini','shalini0807@gmail.com','Shalini@08','8792264139'),(17,'Shalini','shaliniani0708@gmail.com','Vinod@0708','8792264139'),(18,'poongkulali','poongkulalir454@gmail.com','Poong@21','8147681003'),(19,'sabarish','sabarish@gmail.com','Sabarish@2001','8892289926');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback`
--

DROP TABLE IF EXISTS `feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feedback` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int DEFAULT NULL,
  `order_id` int DEFAULT NULL,
  `rating` int DEFAULT NULL,
  `comment` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedback`
--

LOCK TABLES `feedback` WRITE;
/*!40000 ALTER TABLE `feedback` DISABLE KEYS */;
INSERT INTO `feedback` VALUES (1,NULL,NULL,5,'good','2026-03-25 10:20:27',NULL),(2,NULL,NULL,5,'good','2026-03-25 10:20:55',NULL),(3,NULL,39,5,'goood\r\n','2026-03-25 10:53:14',1),(4,NULL,40,5,'amazing\r\n','2026-03-25 10:54:19',13),(5,NULL,41,5,'excellent ','2026-03-25 17:08:07',13),(6,NULL,46,5,'nothing','2026-03-27 10:33:43',19);
/*!40000 ALTER TABLE `feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (1,1,1,5,499.00),(2,1,2,2,899.00),(3,2,1,1,499.00),(4,3,1,1,499.00),(5,3,3,1,650.00),(6,3,4,1,1200.00),(7,4,1,1,499.00),(8,4,2,1,899.00);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int DEFAULT NULL,
  `customer_name` varchar(100) DEFAULT NULL,
  `address` text,
  `payment_mode` varchar(50) DEFAULT NULL,
  `total_amount` decimal(10,2) DEFAULT NULL,
  `order_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(50) DEFAULT 'Placed',
  `phone` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,1,'shalini ','banglore','Cash On Delivery',4293.00,'2026-02-17 15:11:50','Delivered',NULL),(2,1,'shalini ','banglore','Cash On Delivery',499.00,'2026-02-17 15:14:05','Delivered',NULL),(3,1,'shalini s','753 shammana road banglore','Cash on Delivery',2349.00,'2026-02-17 15:17:31','Cancelled',NULL),(4,1,'shalini s','banglore','Cash on Delivery',1398.00,'2026-02-17 15:22:30','Cancelled',NULL),(5,1,'shalini s','banglore','Cash on Delivery',1398.00,'2026-02-17 15:26:35','Placed',NULL),(6,1,'shalini s','xyz','Cash on Delivery',3948.00,'2026-02-20 11:56:22','Delivered',NULL),(7,1,'shalini s','xyz','Cash on Delivery',2098.00,'2026-02-20 12:03:15','Delivered',NULL),(8,1,'shalini s','hvhgfd','Cash on Delivery',2399.00,'2026-02-20 12:04:34','Placed',NULL),(9,1,'shalini ','nnbhih','Cash on Delivery',399.00,'2026-02-20 12:13:55','Delivered',NULL),(10,1,'shalini ','sdmmovf','Cash on Delivery',2849.00,'2026-02-20 12:19:20','Shipped',NULL),(11,1,'shalini ',' mmkmkp;k','Cash on Delivery',899.00,'2026-02-20 12:26:27','Delivered',NULL),(12,1,'shalini s','guufiftydryd','UPI',1298.00,'2026-02-20 15:39:06','Shipped',NULL),(13,4,'Jennifer','#753 shammana road r s palya kammanahalli main road banglore 560033','Cash on Delivery',1948.00,'2026-02-20 16:59:32','Delivered',NULL),(14,3,'vinod subhu','lingarajapuram,banglore','UPI',8497.00,'2026-02-20 17:07:53','Delivered',NULL),(15,1,'shalini ','scclskndlnl','Cash on Delivery',899.00,'2026-02-23 10:02:00','Delivered',NULL),(16,1,'alina s rose mary','kothanur bangluru karnataka','Cash on Delivery',2498.00,'2026-02-23 10:13:31','Cancelled',NULL),(17,1,'shalini ','kghghcghcy','Cash on Delivery',3996.00,'2026-02-23 18:12:23','Delivered',NULL),(18,1,'shalini ','hdsfsfgb','Cash on Delivery',2099.00,'2026-02-25 07:17:25','Cancelled',NULL),(19,1,'shalini ','hmjk,h','Cash on Delivery',1798.00,'2026-02-25 07:40:06','Delivered',NULL),(20,7,'anumitha','kamanahalli','Cash on Delivery',3098.00,'2026-03-06 11:42:53','Delivered',NULL),(21,7,'anumitha','thzdhbte','Cash on Delivery',2099.00,'2026-03-12 08:08:37','Placed',NULL),(22,1,'shalini ','aaggffdgga','Cash on Delivery',2749.00,'2026-03-13 09:40:06','Delivered',NULL),(23,12,'sharon xavier','vsjnzsdkbvj','Cash on Delivery',1850.00,'2026-03-16 11:48:38','Shipped',NULL),(24,12,'sharon xavier',' a k k dk cd','Cash on Delivery',4250.00,'2026-03-17 09:30:01','Delivered',NULL),(25,13,'jennifer','hggggiu','Cash on Delivery',1549.00,'2026-03-23 06:25:43','Delivered',NULL),(26,13,'jennifer','mdmcmd','Cash on Delivery',4647.00,'2026-03-23 07:59:24','Shipped',NULL),(27,14,'jennifer','753 shamman road r s palya main road kammanahalli Bengaluru 560033','Cash on Delivery',1298.00,'2026-03-23 14:11:54','Placed',NULL),(28,13,'jennifer','ljhuguguyg','UPI',3399.00,'2026-03-23 14:14:10','Delivered',NULL),(29,13,'Shalini S','kammanahalli bengaluru','Cash on Delivery',1549.00,'2026-03-23 16:11:11','Placed',NULL),(30,13,'shal','753 shamman road r s palya main road kammanahalli Bengaluru 560033','Cash on Delivery',1549.00,'2026-03-23 16:25:46','Placed','8792264139'),(31,1,'shal','753 shamman road r s palya main road kammanahalli Bengaluru 560033','Cash on Delivery',2749.00,'2026-03-25 09:19:06','Placed','8792264139'),(32,1,'shal','753 shamman road r s palya main road kammanahalli Bengaluru 560033','Cash on Delivery',1549.00,'2026-03-25 09:25:05','Placed','8792264139'),(33,1,'jennifer','753 shamman road r s palya main road kammanahalli Bengaluru 560033','Cash on Delivery',899.00,'2026-03-25 09:28:44','Placed','8792264139'),(34,1,'jennifer','753 shamman road r s palya main road kammanahalli Bengaluru 560033','Cash on Delivery',899.00,'2026-03-25 09:29:06','Placed','8792264139'),(35,1,'Shalini S','753 shamman road r s palya main road kammanahalli Bengaluru 560033','Cash on Delivery',650.00,'2026-03-25 10:07:39','Placed','08792264139'),(36,1,'Shalini S','kammanahalli bengaluru','Cash on Delivery',650.00,'2026-03-25 10:16:44','Placed','8792264139'),(37,1,'Shalini S','kammanahalli bengaluru','Cash on Delivery',899.00,'2026-03-25 10:20:43','Placed','8792264139'),(38,1,'Shalini S','kammanahalli bengaluru','Cash on Delivery',1049.00,'2026-03-25 10:26:33','Placed','8792264139'),(39,1,'Shalini S','753 shamman road r s palya main road kammanahalli Bengaluru 560033','Cash on Delivery',1950.00,'2026-03-25 10:53:01','Placed','08792264139'),(40,13,'jennifer','kammanahalli bengaluru','Cash on Delivery',5399.00,'2026-03-25 10:53:59','Placed','08792264139'),(41,13,'Shalini S','753 shamman road r s palya main road kammanahalli Bengaluru 560033','Cash on Delivery',2749.00,'2026-03-25 17:07:33','Placed','08792264139'),(42,15,'Shalini S','753 shamman road r s palya main road kammanahalli Bengaluru 560033','Cash on Delivery',5048.00,'2026-03-26 18:55:27','Placed','08792264139'),(43,15,'Shalini S','753 shamman road r s palya main road kammanahalli Bengaluru 560033','UPI',1449.00,'2026-03-27 04:40:48','Placed','08792264139'),(44,15,'Shalini S','753 shamman road r s palya main road kammanahalli Bengaluru 560033','Cash on Delivery',4547.00,'2026-03-27 04:57:35','Placed','08792264139'),(45,18,'poongkulali','#101, 11th cross ashrafiya masjid ,shampur main road ,banglore -560045','Cash on Delivery',5149.00,'2026-03-27 06:42:38','Delivered','8147681003'),(46,19,'sabarish','kammanahalli bengaluru','Debit Card',2849.00,'2026-03-27 10:33:26','Shipped','08792264139'),(47,15,'sabarish','kammanahalli bengaluru','Cash on Delivery',650.00,'2026-04-01 08:33:14','Placed','08792264139'),(48,15,'sabarish','#101, 11th cross ashrafiya masjid ,shampur main road ,banglore -560045','Debit Card',350.00,'2026-04-01 10:09:31','Placed','08792264139'),(49,15,'Shalini S','kammanahalli bengaluru','Cash on Delivery',2749.00,'2026-04-09 08:04:05','Delivered','08792264139');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `description` text,
  `stock` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (2,'Glow Face Serum',899.00,'serum.jpg','Brightening serum',4),(3,'Hydrating Cleanser',650.00,'cleanser.jpg','Deep pore cleanser',3),(4,'Silk Foundation',1200.00,'foundation.jpg','Full coverage foundation',5),(5,'Peach Blush ',799.00,'blush.jpg','Soft natural blush tones',12),(6,'Velvet Lip Gloss',399.00,'lipgloss.jpg','High shine glossy finish',11),(7,'Dior Perfume',1500.00,'perfume.jpg','long lasting with pleasant fragrance',11),(8,'Red Mac lipstick',800.00,'lipstick.jpg','suits all type skin tone makes you look elegant',14),(9,'Deconstruct Sunscreen',499.00,'sunscreen.jpg','',15),(10,'Maybelline Eyeliner',350.00,'eyeliner.jpg','',9),(12,'Foxtale Body Wash',1000.00,'body-wash.jpg','',20);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-12 22:14:17
