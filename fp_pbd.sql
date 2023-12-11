-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 22, 2023 at 01:56 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fp_pbd`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_process_tamu` ()   BEGIN

    DECLARE tamu_id_val INT;
    DECLARE nama_tamu_val VARCHAR(100);
    DECLARE email_val VARCHAR(100);
    DECLARE telepon_val VARCHAR(15);
    DECLARE cur_finished INT DEFAULT 0;
    
    DECLARE cur_tamu CURSOR FOR
        SELECT tamu_id, nama_tamu, email, telepon FROM tamu;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET cur_finished = 1;
    
    -- Inisialisasi
    SET cur_finished = 0;
    
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_tamu_processed (
        `tamu_id` INT,
        `info_tamu` VARCHAR(255)
    );
    
    OPEN cur_tamu;
    
    tamu_loop: LOOP
        FETCH cur_tamu INTO tamu_id_val, nama_tamu_val, email_val, telepon_val;
        
        IF cur_finished = 1 THEN
            LEAVE tamu_loop;
        END IF;
        
        INSERT INTO temp_tamu_processed (`tamu_id`, `info_tamu`)
        VALUES (tamu_id_val, CONCAT('Nama Tamu: ', nama_tamu_val, ', Email: ', email_val, ', Telepon: ', telepon_val));
        
    END LOOP tamu_loop;
    
    CLOSE cur_tamu;
    
    SELECT * FROM temp_tamu_processed;
    
    DROP TEMPORARY TABLE IF EXISTS temp_tamu_processed;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `fasilitas`
--

CREATE TABLE `fasilitas` (
  `fasilitas_id` int(11) NOT NULL,
  `fasilitas` varchar(100) DEFAULT NULL,
  `hotel_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fasilitas`
--

INSERT INTO `fasilitas` (`fasilitas_id`, `fasilitas`, `hotel_id`) VALUES
(1, 'Kolam Renang', 1),
(2, 'Gym', 1),
(3, 'Spa', 2),
(4, 'Restoran', 3),
(5, 'Kolam Renang', 2);

-- --------------------------------------------------------

--
-- Table structure for table `hotel`
--

CREATE TABLE `hotel` (
  `hotel_id` int(11) NOT NULL,
  `nama_hotel` varchar(100) DEFAULT NULL,
  `alamat` varchar(200) DEFAULT NULL,
  `bintang` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hotel`
--

INSERT INTO `hotel` (`hotel_id`, `nama_hotel`, `alamat`, `bintang`) VALUES
(1, 'Grand Riviera Hotel', 'Jl. Pantai Barat No. 123, Kota Wisata Bahagia, Jawa Barat', 4),
(2, 'Hotel Royal Palace Resort', 'Jl. Megah Indah No. 456, Kota Megah Raya, Jawa Timur', 3),
(3, 'Hotel Serene Garden Inn', 'Jl. Damai Sejati No. 789, Kota Harmoni Indah, Jawa Tengah', 5),
(4, 'Paradise Island Hotel', 'Jl. Pulau Indah No. 101, Kota Pesona Laut, Bali', 5),
(5, 'Hotel Harmony Plaza Suites', 'Jl. Damai Harmoni No. 222, Kota Nyaman Sejati, Sumatera Utara', 4);

-- --------------------------------------------------------

--
-- Table structure for table `hotel_fasilitas`
--

CREATE TABLE `hotel_fasilitas` (
  `hotel_id` int(11) NOT NULL,
  `fasilitas_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hotel_fasilitas`
--

INSERT INTO `hotel_fasilitas` (`hotel_id`, `fasilitas_id`) VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 3),
(3, 4);

-- --------------------------------------------------------

--
-- Table structure for table `kamar`
--

CREATE TABLE `kamar` (
  `kamar_id` int(11) NOT NULL,
  `hotel_id` int(11) DEFAULT NULL,
  `tipe_kamar` varchar(50) DEFAULT NULL,
  `harga_per_malam` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kamar`
--

INSERT INTO `kamar` (`kamar_id`, `hotel_id`, `tipe_kamar`, `harga_per_malam`) VALUES
(101, 1, 'Single', 500000),
(102, 1, 'Double', 750000),
(105, 3, 'Single', 650000),
(201, 2, 'Single', 400000),
(202, 2, 'Double', 650000);

-- --------------------------------------------------------

--
-- Table structure for table `reservasi`
--

CREATE TABLE `reservasi` (
  `reservasi_id` int(11) NOT NULL,
  `tamu_id` int(11) DEFAULT NULL,
  `kamar_id` int(11) DEFAULT NULL,
  `check_in` date DEFAULT NULL,
  `check_out` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reservasi`
--

INSERT INTO `reservasi` (`reservasi_id`, `tamu_id`, `kamar_id`, `check_in`, `check_out`) VALUES
(1001, 1, 101, '2023-07-25', '2023-07-28'),
(1002, 2, 201, '2023-08-10', '2023-08-15'),
(1003, 2, 201, '2023-08-10', '2023-08-15'),
(1004, 1, 102, '2023-09-05', '2023-09-10'),
(1005, 2, 202, '2023-09-15', '2023-09-20');

-- --------------------------------------------------------

--
-- Table structure for table `tamu`
--

CREATE TABLE `tamu` (
  `tamu_id` int(11) NOT NULL,
  `nama_tamu` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `telepon` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tamu`
--

INSERT INTO `tamu` (`tamu_id`, `nama_tamu`, `email`, `telepon`) VALUES
(1, 'Hanun Salsabila', 'hanunsalsabila@gmail.com', '1234567890'),
(2, 'Janus Ezra Santosa', 'janusezrasantosa@gmail.com', '9876543210'),
(3, 'Hafid Afnan Wijaya', 'hafidafnanwijaya@gmail.com', '01234554345'),
(4, 'Alfaso', 'alfaso@gmail.com', '883452341298'),
(5, 'Yoga Ari', 'yogaari@gmail.com', '73829031987');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `fasilitas`
--
ALTER TABLE `fasilitas`
  ADD PRIMARY KEY (`fasilitas_id`),
  ADD KEY `hotel_id` (`hotel_id`);

--
-- Indexes for table `hotel`
--
ALTER TABLE `hotel`
  ADD PRIMARY KEY (`hotel_id`);

--
-- Indexes for table `hotel_fasilitas`
--
ALTER TABLE `hotel_fasilitas`
  ADD PRIMARY KEY (`hotel_id`,`fasilitas_id`),
  ADD KEY `fasilitas_id` (`fasilitas_id`);

--
-- Indexes for table `kamar`
--
ALTER TABLE `kamar`
  ADD PRIMARY KEY (`kamar_id`),
  ADD KEY `hotel_id` (`hotel_id`);

--
-- Indexes for table `reservasi`
--
ALTER TABLE `reservasi`
  ADD PRIMARY KEY (`reservasi_id`),
  ADD KEY `tamu_id` (`tamu_id`),
  ADD KEY `kamar_id` (`kamar_id`);

--
-- Indexes for table `tamu`
--
ALTER TABLE `tamu`
  ADD PRIMARY KEY (`tamu_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `fasilitas`
--
ALTER TABLE `fasilitas`
  ADD CONSTRAINT `fasilitas_ibfk_1` FOREIGN KEY (`hotel_id`) REFERENCES `hotel` (`hotel_id`);

--
-- Constraints for table `hotel_fasilitas`
--
ALTER TABLE `hotel_fasilitas`
  ADD CONSTRAINT `hotel_fasilitas_ibfk_1` FOREIGN KEY (`hotel_id`) REFERENCES `hotel` (`hotel_id`),
  ADD CONSTRAINT `hotel_fasilitas_ibfk_2` FOREIGN KEY (`fasilitas_id`) REFERENCES `fasilitas` (`fasilitas_id`);

--
-- Constraints for table `kamar`
--
ALTER TABLE `kamar`
  ADD CONSTRAINT `kamar_ibfk_1` FOREIGN KEY (`hotel_id`) REFERENCES `hotel` (`hotel_id`);

--
-- Constraints for table `reservasi`
--
ALTER TABLE `reservasi`
  ADD CONSTRAINT `reservasi_ibfk_1` FOREIGN KEY (`tamu_id`) REFERENCES `tamu` (`tamu_id`),
  ADD CONSTRAINT `reservasi_ibfk_2` FOREIGN KEY (`kamar_id`) REFERENCES `kamar` (`kamar_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
