-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 12, 2024 at 01:58 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `borrow_movie`
--

-- --------------------------------------------------------

--
-- Table structure for table `asset`
--

CREATE TABLE `asset` (
  `asset_id` int(11) NOT NULL,
  `asset_name` varchar(30) NOT NULL,
  `asset_status` enum('available','pending','borrowed','disabled') NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `categorie` enum('Adventure','Action','Comedy','Fantasy','Horror','Romance','Sci-Fi','Thriller','War','All') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `asset`
--

INSERT INTO `asset` (`asset_id`, `asset_name`, `asset_status`, `file_path`, `categorie`) VALUES
(8, 'Jumanji', 'available', 'Jumanji.jpg', 'Adventure'),
(9, 'Mad Max', 'pending', 'Mad Max.jpg', 'Action'),
(10, 'The Grand Budapest Hotel', 'available', 'The Grand Budapest Hotel.jpg', 'Comedy'),
(11, 'The Lord of the Rings', 'available', 'The Lord of the Rings.jpg', 'Fantasy'),
(12, 'Get Out', 'available', 'Get Out.jpg', 'Horror'),
(13, 'The Notebook', 'available', 'The Notebook.jpg', 'Romance'),
(14, 'Inception', 'available', 'Inception.jpg', 'Sci-Fi'),
(15, 'Se7en', 'available', 'Se7en.jpg', 'Thriller'),
(16, 'Saving Private Ryan', 'available', 'Saving Private Ryan.jpg', 'War');

-- --------------------------------------------------------

--
-- Table structure for table `history`
--

CREATE TABLE `history` (
  `history_id` int(11) NOT NULL,
  `asset_id` int(11) NOT NULL,
  `borrower_id` int(11) NOT NULL,
  `request_id` int(11) NOT NULL,
  `approved_by` int(11) DEFAULT NULL,
  `returned_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `history`
--

INSERT INTO `history` (`history_id`, `asset_id`, `borrower_id`, `request_id`, `approved_by`, `returned_by`) VALUES
(4, 9, 1, 4, 5, 4);

-- --------------------------------------------------------

--
-- Table structure for table `request`
--

CREATE TABLE `request` (
  `request_id` int(11) NOT NULL,
  `asset_id` int(11) NOT NULL,
  `borrower_id` int(11) NOT NULL,
  `borrow_date` date NOT NULL,
  `return_date` date NOT NULL,
  `approve_status` enum('pending','approved','rejected') NOT NULL,
  `approved_by` int(11) DEFAULT NULL,
  `return_status` enum('not_returned','returned') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `request`
--

INSERT INTO `request` (`request_id`, `asset_id`, `borrower_id`, `borrow_date`, `return_date`, `approve_status`, `approved_by`, `return_status`) VALUES
(4, 9, 1, '2024-11-08', '2024-11-15', 'rejected', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `username` varchar(30) NOT NULL,
  `password` varchar(60) NOT NULL,
  `role` enum('student','admin','approver') NOT NULL,
  `user_name` varchar(30) NOT NULL,
  `email` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `username`, `password`, `role`, `user_name`, `email`) VALUES
(1, '1', '$2b$10$tOrCLYrEGyLF74IsEDamo.lxo9OSAAbsHpaXrK.oUZ3XhI.skG.hy', 'student', 'user90', 'r@gmail.com'),
(2, 'user91', '$2b$10$D9fYYpulojIcZOOfPEV.puCVmKMnvcFZ1bayYCmwAUr1CqvxTaUdG', 'student', 'user91', 'r@gmail.com'),
(3, 'user92', '$2b$10$1cpJPlhINPvMyZjtw2iNPO65npgAOYGCaczlfOA88q5FmjlCDw1Nu', 'student', 'user92', 'r@gmail.com'),
(4, 'admin', '$2b$10$WyVQ4BBIm/Ub90.RVm6kAeLv5UO5VdPyP4oIqsiIdVwYooCv5Cp4i', 'admin', 'admin', 'admin@gmail.com'),
(5, 'approver', '$2b$10$2TVHw9/69fe11MIvALIhy.07px7X/38IMgKl3S5Q832v8NCd7q4Te', 'approver', 'approver', 'approver@gmail.com');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `asset`
--
ALTER TABLE `asset`
  ADD PRIMARY KEY (`asset_id`);

--
-- Indexes for table `history`
--
ALTER TABLE `history`
  ADD PRIMARY KEY (`history_id`),
  ADD KEY `asset_id` (`asset_id`),
  ADD KEY `borrower_id` (`borrower_id`),
  ADD KEY `request_id` (`request_id`),
  ADD KEY `approved_by` (`approved_by`),
  ADD KEY `returned_by` (`returned_by`);

--
-- Indexes for table `request`
--
ALTER TABLE `request`
  ADD PRIMARY KEY (`request_id`),
  ADD KEY `asset_id` (`asset_id`),
  ADD KEY `borrower_id` (`borrower_id`),
  ADD KEY `approved_by` (`approved_by`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `asset`
--
ALTER TABLE `asset`
  MODIFY `asset_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `history`
--
ALTER TABLE `history`
  MODIFY `history_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `request`
--
ALTER TABLE `request`
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `history`
--
ALTER TABLE `history`
  ADD CONSTRAINT `history_ibfk_1` FOREIGN KEY (`asset_id`) REFERENCES `asset` (`asset_id`),
  ADD CONSTRAINT `history_ibfk_2` FOREIGN KEY (`borrower_id`) REFERENCES `user` (`user_id`),
  ADD CONSTRAINT `history_ibfk_3` FOREIGN KEY (`request_id`) REFERENCES `request` (`request_id`),
  ADD CONSTRAINT `history_ibfk_4` FOREIGN KEY (`approved_by`) REFERENCES `user` (`user_id`),
  ADD CONSTRAINT `history_ibfk_5` FOREIGN KEY (`returned_by`) REFERENCES `user` (`user_id`);

--
-- Constraints for table `request`
--
ALTER TABLE `request`
  ADD CONSTRAINT `request_ibfk_1` FOREIGN KEY (`asset_id`) REFERENCES `asset` (`asset_id`),
  ADD CONSTRAINT `request_ibfk_2` FOREIGN KEY (`borrower_id`) REFERENCES `user` (`user_id`),
  ADD CONSTRAINT `request_ibfk_3` FOREIGN KEY (`approved_by`) REFERENCES `user` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
