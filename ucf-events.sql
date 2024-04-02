-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Apr 02, 2024 at 10:40 AM
-- Server version: 8.2.0
-- PHP Version: 8.2.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ucf-events`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
CREATE TABLE IF NOT EXISTS `admin` (
  `UID` int NOT NULL,
  `Admins_ID` int NOT NULL,
  `Admins_name` text,
  PRIMARY KEY (`UID`),
  KEY `Admins_ID` (`Admins_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`UID`, `Admins_ID`, `Admins_name`) VALUES
(2, 0, 'default_admin');

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
CREATE TABLE IF NOT EXISTS `events` (
  `Events_ID` int NOT NULL AUTO_INCREMENT,
  `Time` datetime NOT NULL,
  `Lname` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Event_Name` text NOT NULL,
  `Description` text,
  PRIMARY KEY (`Events_ID`),
  UNIQUE KEY `Lname` (`Lname`),
  UNIQUE KEY `Lname_2` (`Lname`),
  KEY `Lname_3` (`Lname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `location`
--

DROP TABLE IF EXISTS `location`;
CREATE TABLE IF NOT EXISTS `location` (
  `Lname` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Address` text NOT NULL,
  `Longitude` float DEFAULT NULL,
  `Latitude` float DEFAULT NULL,
  PRIMARY KEY (`Lname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `private_creates`
--

DROP TABLE IF EXISTS `private_creates`;
CREATE TABLE IF NOT EXISTS `private_creates` (
  `Events_ID` int NOT NULL,
  `Admins_ID` int NOT NULL,
  `SuperAdmins_ID` int NOT NULL,
  KEY `priv_admin_creates` (`Admins_ID`),
  KEY `priv_sadmin_creates` (`SuperAdmins_ID`),
  KEY `priv_makes_event` (`Events_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `private_events`
--

DROP TABLE IF EXISTS `private_events`;
CREATE TABLE IF NOT EXISTS `private_events` (
  `Events_ID` int NOT NULL,
  `Admins_ID` int NOT NULL,
  `SuperAdmins_ID` int NOT NULL,
  PRIMARY KEY (`Events_ID`),
  UNIQUE KEY `Admins_ID_2` (`Admins_ID`,`SuperAdmins_ID`),
  KEY `Admins_ID` (`Admins_ID`,`SuperAdmins_ID`),
  KEY `super_admin_creates` (`SuperAdmins_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `public_creates`
--

DROP TABLE IF EXISTS `public_creates`;
CREATE TABLE IF NOT EXISTS `public_creates` (
  `Events_ID` int NOT NULL,
  `Admins_ID` int NOT NULL,
  `SuperAdmins_ID` int NOT NULL,
  PRIMARY KEY (`Events_ID`,`Admins_ID`,`SuperAdmins_ID`),
  KEY `pub_made_by_admin` (`Admins_ID`),
  KEY `pub_made_by_sadmin` (`SuperAdmins_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `public_events`
--

DROP TABLE IF EXISTS `public_events`;
CREATE TABLE IF NOT EXISTS `public_events` (
  `Events_ID` int NOT NULL,
  `Admins_ID` int NOT NULL,
  `SuperAdmins_ID` int NOT NULL,
  PRIMARY KEY (`Events_ID`),
  UNIQUE KEY `Admins_ID` (`Admins_ID`,`SuperAdmins_ID`),
  KEY `sadmin_creates_pubE` (`SuperAdmins_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `rso`
--

DROP TABLE IF EXISTS `rso`;
CREATE TABLE IF NOT EXISTS `rso` (
  `RSO_ID` int NOT NULL AUTO_INCREMENT,
  `RSO_name` int NOT NULL,
  `Admin_ID` int NOT NULL,
  PRIMARY KEY (`RSO_ID`),
  KEY `Admin_ID` (`Admin_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `super_admin`
--

DROP TABLE IF EXISTS `super_admin`;
CREATE TABLE IF NOT EXISTS `super_admin` (
  `UID` int NOT NULL,
  `SuperAdmins_ID` int NOT NULL,
  `Admins_ID` int DEFAULT NULL,
  `SuperAdmins_name` text,
  PRIMARY KEY (`SuperAdmins_ID`),
  UNIQUE KEY `UID` (`UID`),
  KEY `Admins_ID` (`Admins_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `UID` int NOT NULL AUTO_INCREMENT,
  `pass` text,
  `name` text,
  `RSO_ID` int DEFAULT NULL COMMENT 'ID of the RSO this user has joined',
  PRIMARY KEY (`UID`),
  KEY `RSO_ID` (`RSO_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`UID`, `pass`, `name`, `RSO_ID`) VALUES
(2, 'password', 'default_user', NULL),
(3, 'password', 'default_user2', NULL),
(4, 'password', 'default_user3', NULL);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admin`
--
ALTER TABLE `admin`
  ADD CONSTRAINT `admin_isa_user` FOREIGN KEY (`UID`) REFERENCES `users` (`UID`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `events`
--
ALTER TABLE `events`
  ADD CONSTRAINT `events_ibfk_1` FOREIGN KEY (`Events_ID`) REFERENCES `private_events` (`Events_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `location`
--
ALTER TABLE `location`
  ADD CONSTRAINT `location_ibfk_1` FOREIGN KEY (`Lname`) REFERENCES `events` (`Lname`);

--
-- Constraints for table `private_creates`
--
ALTER TABLE `private_creates`
  ADD CONSTRAINT `priv_admin_creates` FOREIGN KEY (`Admins_ID`) REFERENCES `admin` (`Admins_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `priv_makes_event` FOREIGN KEY (`Events_ID`) REFERENCES `private_events` (`Events_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `priv_sadmin_creates` FOREIGN KEY (`SuperAdmins_ID`) REFERENCES `super_admin` (`SuperAdmins_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `private_events`
--
ALTER TABLE `private_events`
  ADD CONSTRAINT `priv_isa_event` FOREIGN KEY (`Events_ID`) REFERENCES `events` (`Events_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `public_creates`
--
ALTER TABLE `public_creates`
  ADD CONSTRAINT `pub_made_by_admin` FOREIGN KEY (`Admins_ID`) REFERENCES `admin` (`Admins_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `pub_made_by_sadmin` FOREIGN KEY (`SuperAdmins_ID`) REFERENCES `super_admin` (`SuperAdmins_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `pub_makes_event` FOREIGN KEY (`Events_ID`) REFERENCES `public_events` (`Events_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `public_events`
--
ALTER TABLE `public_events`
  ADD CONSTRAINT `pub_isa_event` FOREIGN KEY (`Events_ID`) REFERENCES `events` (`Events_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `rso`
--
ALTER TABLE `rso`
  ADD CONSTRAINT `RSO_created_by` FOREIGN KEY (`Admin_ID`) REFERENCES `admin` (`Admins_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `super_admin`
--
ALTER TABLE `super_admin`
  ADD CONSTRAINT `sadmin_isa_admin` FOREIGN KEY (`Admins_ID`) REFERENCES `admin` (`Admins_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `sadmin_isa_user` FOREIGN KEY (`UID`) REFERENCES `users` (`UID`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`RSO_ID`) REFERENCES `rso` (`RSO_ID`) ON DELETE SET NULL ON UPDATE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
