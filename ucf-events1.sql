-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Apr 17, 2024 at 10:01 PM
-- Server version: 8.2.0
-- PHP Version: 8.2.13

SET FOREIGN_KEY_CHECKS=0;
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
  PRIMARY KEY (`UID`,`Admins_ID`),
  KEY `Admins_ID` (`Admins_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`UID`, `Admins_ID`) VALUES
(2, 0),
(27, 1),
(28, 2),
(31, 3);

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
CREATE TABLE IF NOT EXISTS `comments` (
  `Events_ID` int NOT NULL COMMENT 'Event that the comment is for',
  `UID` int NOT NULL COMMENT 'User who posted the comment',
  `text` text NOT NULL COMMENT 'Comment body',
  `rating` int NOT NULL COMMENT 'rating, 0-5 stars',
  `timestamp` timestamp NOT NULL COMMENT 'timestamp for when comment was posted/edited',
  PRIMARY KEY (`Events_ID`,`UID`),
  KEY `posted_by` (`UID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`Events_ID`, `UID`, `text`, `rating`, `timestamp`) VALUES
(3, 28, 'The free coffee was a nice treat. Great study session.', 4, '2024-04-17 21:27:44'),
(3, 31, 'Coffee was cold. No creamer. Lame.', 1, '2024-04-17 21:28:07'),
(8, 27, 'Wow! The staff were super friendly and everything was very professional. 10/10, would bleed again.', 5, '2024-04-17 21:27:10');

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
  KEY `Lname` (`Lname`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `events`
--

INSERT INTO `events` (`Events_ID`, `Time`, `Lname`, `Event_Name`, `Description`) VALUES
(2, '2024-04-17 00:00:00', 'RWC', 'Open Water Scuba Certification', 'Outdoor Adventure is proud to partner with Ranger Rick\'s SCUBA Adventure, one of the most experienced scuba dive outfitters, for our entry-level NAUI SCUBA certification course. This course is available for students who are currently enrolled and taking classes at UCF'),
(3, '2024-04-15 10:00:00', 'Wesley', 'Student Lounge at Wesley at UCF', 'Join us for a free place to study, work and hangout! We also have free coffee and tea. Open Monday through Thursday from 10 a.m. to 4 p.m.\r\nClosed during Spring Break (March 18-21).'),
(6, '2024-04-17 21:18:54', 'RWC', 'Adult First Aid/CPR/AED Class', 'The RWC offers American Red Cross Adult CPR/AED, First Aid Blended Learning classes. The Blended Learning class includes an online portion (approx. 2-3 hours long) and an instructor-led class skills session (approx. 2 hours long). The online portion must be completed prior to attending the in-class skills session. To register for this class please call 407-823-2408, or walk in to the RWC administrative office between 8 a.m.-5 p.m., Monday through Friday, and someone will assist you! '),
(7, '2024-04-17 10:00:00', 'CB1', 'Gearing Up: Guide to FMC\'s Checkout Inventory', 'Join us for a showcase of the Faculty Multimedia Center\'s equipment available for checkout. This gear can be used at no cost by faculty during research or course related activities, including visiting historic landmarks, capturing live experiments, creating virtual tours of locations — otherwise inaccessibile to a class — and much more.'),
(8, '2024-04-22 11:00:00', 'Memory Mall', 'Big Red Bus - Donate Blood Today!', 'Help us maintain a safe and ready blood supply for cancer patients, trauma patients, or when unexpected tragedies occur. The OneBlood bus will park on Memory Mall near the Veterans Memorial.\r\nWalk-ups are welcomed, and appointments are appreciated!'),
(9, '2024-04-17 21:28:32', 'CB1', 'Society of Generic Students hangout', 'RSO Event test for generic RSO');

-- --------------------------------------------------------

--
-- Table structure for table `location`
--

DROP TABLE IF EXISTS `location`;
CREATE TABLE IF NOT EXISTS `location` (
  `Lname` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Address` text NOT NULL,
  `Latitude` float DEFAULT NULL,
  `Longitude` float DEFAULT NULL,
  PRIMARY KEY (`Lname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `location`
--

INSERT INTO `location` (`Lname`, `Address`, `Latitude`, `Longitude`) VALUES
('CB1', '12601 Aquarius Agora Dr, Orlando, FL 32816', 28.6037, -81.2005),
('Memory Mall', 'Mercury Cir, Orlando, FL 32816', 28.6047, -81.1988),
('RWC', '4000 Central Florida Blvd\r\nOrlando, FL 32816', 28.5959, -81.1996),
('Wesley', '4217 E Plaza Dr', 28.6069, -81.1967);

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
  KEY `priv_made_by_sadmin` (`SuperAdmins_ID`)
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
  KEY `pub_made_by_sadmin` (`SuperAdmins_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `rso`
--

DROP TABLE IF EXISTS `rso`;
CREATE TABLE IF NOT EXISTS `rso` (
  `RSO_ID` int NOT NULL AUTO_INCREMENT,
  `RSO_name` text NOT NULL,
  `Admin_ID` int NOT NULL,
  PRIMARY KEY (`RSO_ID`),
  KEY `Admin_ID` (`Admin_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `rso`
--

INSERT INTO `rso` (`RSO_ID`, `RSO_name`, `Admin_ID`) VALUES
(1, 'Society of Generic Students', 1),
(2, 'Society of Superb Students', 2),
(3, 'Society of Special Students', 3);

-- --------------------------------------------------------

--
-- Table structure for table `rso_events`
--

DROP TABLE IF EXISTS `rso_events`;
CREATE TABLE IF NOT EXISTS `rso_events` (
  `RSO_ID` int NOT NULL,
  `Events_ID` int NOT NULL,
  PRIMARY KEY (`Events_ID`),
  KEY `RSO_ID` (`RSO_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `rso_events`
--

INSERT INTO `rso_events` (`RSO_ID`, `Events_ID`) VALUES
(1, 9);

-- --------------------------------------------------------

--
-- Table structure for table `super_admin`
--

DROP TABLE IF EXISTS `super_admin`;
CREATE TABLE IF NOT EXISTS `super_admin` (
  `UID` int NOT NULL,
  `SuperAdmins_ID` int NOT NULL,
  PRIMARY KEY (`SuperAdmins_ID`),
  UNIQUE KEY `UID` (`UID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `super_admin`
--

INSERT INTO `super_admin` (`UID`, `SuperAdmins_ID`) VALUES
(27, 0),
(28, 2),
(31, 1);

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
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`UID`, `pass`, `name`, `RSO_ID`) VALUES
(2, 'password', 'default_user', NULL),
(3, 'password', 'default_user2', NULL),
(4, 'password', 'default_user3', NULL),
(27, '123', 'Joshua Bartz', NULL),
(28, '123', 'Damian Lucarelli', NULL),
(31, '123', 'Evan Wrote', NULL),
(32, '123', 'Student1', 1),
(33, '123', 'Student2', 2),
(34, '123', 'Student3', 3),
(35, '123', 'Student4', 3);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admin`
--
ALTER TABLE `admin`
  ADD CONSTRAINT `admin_isa_user` FOREIGN KEY (`UID`) REFERENCES `users` (`UID`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comment_event` FOREIGN KEY (`Events_ID`) REFERENCES `events` (`Events_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `posted_by` FOREIGN KEY (`UID`) REFERENCES `users` (`UID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `events`
--
ALTER TABLE `events`
  ADD CONSTRAINT `has_location` FOREIGN KEY (`Lname`) REFERENCES `location` (`Lname`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `private_events`
--
ALTER TABLE `private_events`
  ADD CONSTRAINT `priv_isa_event` FOREIGN KEY (`Events_ID`) REFERENCES `events` (`Events_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `priv_made_by_admin` FOREIGN KEY (`Admins_ID`) REFERENCES `admin` (`Admins_ID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `priv_made_by_sadmin` FOREIGN KEY (`SuperAdmins_ID`) REFERENCES `super_admin` (`SuperAdmins_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `public_events`
--
ALTER TABLE `public_events`
  ADD CONSTRAINT `pub_isa_event` FOREIGN KEY (`Events_ID`) REFERENCES `events` (`Events_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `rso`
--
ALTER TABLE `rso`
  ADD CONSTRAINT `RSO_created_by` FOREIGN KEY (`Admin_ID`) REFERENCES `admin` (`Admins_ID`) ON UPDATE CASCADE;

--
-- Constraints for table `rso_events`
--
ALTER TABLE `rso_events`
  ADD CONSTRAINT `rso_event_owned_by` FOREIGN KEY (`RSO_ID`) REFERENCES `rso` (`RSO_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `rsoevent_isa_event` FOREIGN KEY (`Events_ID`) REFERENCES `events` (`Events_ID`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `super_admin`
--
ALTER TABLE `super_admin`
  ADD CONSTRAINT `sadmin_isa_user` FOREIGN KEY (`UID`) REFERENCES `users` (`UID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`RSO_ID`) REFERENCES `rso` (`RSO_ID`) ON DELETE SET NULL ON UPDATE SET NULL;
SET FOREIGN_KEY_CHECKS=1;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
