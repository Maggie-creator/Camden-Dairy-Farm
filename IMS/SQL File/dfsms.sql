-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 19, 2023 at 05:42 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.0.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dfsms`
--
use dfsms;

-- --------------------------------------------------------

DROP PROCEDURE IF EXISTS spDROP_FOREIGN_KEY;
DELIMITER $$
CREATE PROCEDURE spDROP_FOREIGN_KEY(IN tableName VARCHAR(64), IN constraintName VARCHAR(64))
BEGIN
	IF EXISTS(
		SELECT * FROM information_schema.table_constraints
		WHERE 
			table_schema    = DATABASE()     AND
			table_name      = tableName      AND
			constraint_name = constraintName AND
			constraint_type = 'FOREIGN KEY')
	THEN
		SET @query = CONCAT('ALTER TABLE ', tableName, ' DROP FOREIGN KEY ', constraintName, ';');
		PREPARE stmt FROM @query; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
	END IF; 
END$$
DELIMITER ;

call spDROP_FOREIGN_KEY( 'tblInvoice', 'tblInvoice_User_FK' );
call spDROP_FOREIGN_KEY( 'tblPayments', 'tblPayments_User_FK' );
call spDROP_FOREIGN_KEY( 'tblPayments', 'tblPayments_Invoice_FK' );
call spDROP_FOREIGN_KEY( 'tblOrders', 'tblOrders_Invoice_FK' );
call spDROP_FOREIGN_KEY( 'tblOrders', 'tblOrders_Product_FK' );
call spDROP_FOREIGN_KEY( 'tblInventory', 'tblInventory_Product_FK' );
  

--
-- Table structure for table `tbladmin`
--
DROP TABLE if exists tblUsers;

CREATE TABLE `tblUsers` (
  `ID` int NOT NULL,
  `UserRole` varchar(45) DEFAULT NULL,
  `UserName` char(45) DEFAULT NULL,
  `MobileNumber` varchar(64) DEFAULT NULL,
  `Email` varchar(120) DEFAULT NULL,
  `Password` varchar(120) DEFAULT NULL,
  `DepositPct` decimal(10,2) default 0 comment 'Default percentage of invoice total required for initial deposit',				-- 
  `AccountBalance` decimal(10,2) default 0 comment 'Customer account balance available for ordering',
  `CreateDate` timestamp NULL DEFAULT current_timestamp(),
  `UpdateDate` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tblUsers`
--

INSERT INTO `tblUsers` (`ID`, `UserRole`, `UserName`, `MobileNumber`, `Email`, `Password`, `DepositPct`, `AccountBalance`, `Createdate`, `UpdateDate`) VALUES
(1, 'Admin', 'admin', 1234567899, 'admin@test.com', 'f925916e2754e5e03f75dd58a5733251', 0, 0, '2023-02-27 18:30:00', NULL),
(2, 'Customer', 'Bluey', 1234567899, 'bluey@test.com', 'f925916e2754e5e03f75dd58a5733251', 5, 1500, '2023-02-27 18:30:00', NULL),
(3, 'Customer', 'Curly', 1234567899, 'curly@test.com', 'f925916e2754e5e03f75dd58a5733251', 10, 2000, '2023-02-27 18:30:00', NULL),
(4, 'Visitor', 'guest', 1234567899, 'guest@test.com', 'f925916e2754e5e03f75dd58a5733251', 0, 0, '2023-02-27 18:30:00', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tblcategory`
--
DROP TABLE if exists tblcategory;

CREATE TABLE `tblcategory` (
  `id` int NOT NULL,
  `CategoryName` varchar(200) DEFAULT NULL,
  `CategoryCode` varchar(50) DEFAULT NULL,
  `PostingDate` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tblcategory`
--

INSERT INTO `tblcategory` (`id`, `CategoryName`, `CategoryCode`, `PostingDate`) VALUES
(1, 'Milk', 'MILK', '2023-03-10 16:27:43'),
(2, 'Butter', 'BUTTER', '2023-03-09 18:30:00'),
(4, 'Cheese', 'CHEESE', '2023-03-09 18:30:00'),
(5, 'Soya', 'SOYA', '2023-03-09 18:30:00'),
(7, 'Cream', 'CREAM', '2023-03-09 18:30:00'),
(8, 'Yoghurt', 'YOG', '2023-03-19 15:47:58');

-- --------------------------------------------------------

--
-- Table structure for table `tblcompany`
--
DROP TABLE if exists tblSupplier;

CREATE TABLE `tblSupplier` (
  `id` int NOT NULL,
  `SupplierName` varchar(150) DEFAULT NULL,
  `RentalFee` decimal(10,2),
  `CreateDate` timestamp NULL DEFAULT current_timestamp(),
  `UpdateDate` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tblSupplier`
--

INSERT INTO `tblSupplier` (`id`, `SupplierName`, `RentalFee`, `CreateDate`, `UpdateDate`) VALUES
(1, 'Rental Property 1', 110, '2023-03-14 03:30:51', '2023-03-14 03:30:51'),
(2, 'Rental Property 2', 120, '2023-03-14 03:30:51', '2023-03-14 03:30:51'),
(3, 'Rental Property 3', 130, '2023-03-14 03:30:51', '2023-03-14 03:30:51'),
(4, 'Rental Property 4', 140, '2023-03-14 03:30:51', '2023-03-14 03:30:51'),
(10, 'Rental Property 5', 150, '2023-03-14 03:30:51', '2023-03-14 03:30:51'),
(11, 'Rental Property 6', 160, '2023-03-19 15:48:27', '2023-03-19 15:48:27'),
(12, 'Rental Property 7', 170, '2023-03-19 15:48:33', '2023-03-19 15:48:33');

-- --------------------------------------------------------

--
-- Table structure for table `tblInvoice`
--
DROP TABLE if exists tblInvoice;

CREATE TABLE `tblInvoice` (
  `id` int NOT NULL,
  `InvoiceNumber` int DEFAULT NULL,
  `CustomerID` int not NULL,
  `ContactNum` text,
  `AmountPayable` decimal(10,2) default 0,
  `Deposit` decimal(10,2) default 0,
  `Discount` decimal(10,2) default 0,
  `PaymentMode` varchar(100) DEFAULT NULL,
  `InvoiceStatus` varchar(64) default 'open',
  `InvoiceGenDate` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
--
-- Dumping data for table `tblInvoice`
--

INSERT INTO `tblInvoice` (`id`, `InvoiceNumber`, `CustomerID`, `ContactNum`, `AmountPayable`, `Deposit`, `Discount`, `PaymentMode`, `InvoiceStatus`, `InvoiceGenDate`) VALUES
(1, 270491112, 2, '0412-222-222', 15, 0, 0, 'cash', 'partpaid', '2023-03-19 15:47:14'),
(2, 464760346, 3, '0411-111-111', 0, 0, 0, 'cash', 'paid', '2023-03-19 15:49:47');

--
-- Table structure for table `tblorders`
--
DROP TABLE if exists tblorders;

CREATE TABLE `tblorders` (
  `id` int NOT NULL,
  `ProductId` int DEFAULT NULL,
  `Quantity` int DEFAULT NULL,
  `InvoiceNumber` int DEFAULT NULL,
  `OrderStatus` varchar(64) default 'open',
  `CreateDate`  timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tblorders`
--

INSERT INTO `tblorders` (`id`, `ProductId`, `Quantity`, `InvoiceNumber`, `CreateDate`) VALUES
(1, 1, 1, 270491112, '2023-03-19 15:47:14'),
(2, 5, 1, 270491112, '2023-03-19 15:47:14'),
(3, 7, 1, 464760346, '2023-03-19 15:49:47'),
(4, 8, 1, 464760346, '2023-03-19 15:49:47');

-- --------------------------------------------------------

--
-- Table structure for table `tblproducts`
--
DROP TABLE if exists tblproducts;

CREATE TABLE `tblproducts` (
  `id` int NOT NULL,
  `CategoryName` varchar(150) DEFAULT NULL,
  `SupplierName` varchar(150) DEFAULT NULL,
  `ProductName` varchar(150) DEFAULT NULL,
  `ProductPrice` decimal(10,2) DEFAULT 0,
  `UnitOfMeasure` varchar(64) default 'litre',
  `WeightVol` decimal(10,2) default 0,					-- Weight or Volume
  `ExpiryDays` int default 10,							-- Days to expiry after manufacture
  `ProductionCost` decimal(10,2) default 0,				-- Production cost per unit
  `PostingDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `UpdateDate` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tblproducts`
--

INSERT INTO `tblproducts` (`id`, `CategoryName`, `SupplierName`, `ProductName`, `UnitOfMeasure`, `WeightVol`, `ProductPrice`, `ExpiryDays`, `ProductionCost`, `PostingDate`, `UpdateDate`) VALUES
(1, 'Milk', 'Rental Property 1', 'Skim milk 500ml', 'litre', 0.5, 2.70, 14, 2.00, '2023-03-19 15:46:13', NULL),
(2, 'Milk', 'Rental Property 1', 'Skim milk 1ltr', 'litre', 1, 4.50, 14, 4.00, '2023-03-19 15:46:13', '2023-03-19 15:46:31'),
(3, 'Milk', 'Rental Property 2', 'Full Cream Milk 500ml', 'litre', 0.5, 2.60, 14, 2.00, '2023-03-19 15:46:21', NULL),
(4, 'Milk', 'Rental Property 3', 'Full Cream Milk 1ltr', 'litre', 1, 5.00, 14, 4.50, '2023-03-19 15:46:21', NULL),
(5, 'Butter', 'Rental Property 4', 'Butter 500mg', 'kg', 0.5, 5.50, 28, 5.00, '2023-03-19 15:46:21', NULL),
(6, 'Cream', 'Rental Property 6', 'Thickened cream 500mg', 'kg', 0.5, 2.90, 21, 2.50, '2023-03-19 15:46:21', NULL),
(7, 'Cream', 'Rental Property 6', 'Pouring cream 500mg', 'kg', 0.5, 3.50, 14, 3.00, '2023-03-19 15:46:21', NULL),
(8, 'Cheese', 'Rental Property 7', 'Cheddar 250gm', 'kg', 0.25, 3.45, 60, 3.00, '2023-03-19 15:49:21', NULL);


DROP TABLE if exists tblDiscountRates;

CREATE TABLE `tblDiscountRates` (
  `id` int NOT NULL,
  `RateCode` varchar(64) DEFAULT NULL,
  `WeightVolumeFrom` decimal(10,2) DEFAULT 0,
  `WeightVolumeTo` decimal(10,2) DEFAULT 0,
  `DiscountPct` decimal(10,2) DEFAULT 0,
  `InsertDate` timestamp NOT NULL DEFAULT current_timestamp(),
  `UpdateDate` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tblDiscountRates`
--

INSERT INTO `tblDiscountRates` (`id`, `RateCode`, `WeightVolumeFrom`, `WeightVolumeTo`, `DiscountPct`, `InsertDate`, `UpdateDate`) VALUES
(1, 'X', 0, 9.99, 0.0, '2023-03-19 15:46:13', NULL),
(2, 'A', 10, 49.99, 1.0, '2023-03-19 15:46:13', NULL),
(3, 'B', 50, 99.99, 5.0, '2023-03-19 15:46:13', '2023-03-19 15:46:31'),
(4, 'C', 100, 499.99, 10.0, '2023-03-19 15:46:21', NULL),
(5, 'D', 500, 999.99, 20.0, '2023-03-19 15:46:21', NULL),
(6, 'E', 1000, 9999999.99, 30.0, '2023-03-19 15:46:21', NULL);



DROP TABLE if exists tblInventory;

CREATE TABLE `tblInventory` (
  `id` int NOT NULL,
  `ProductID` int not null,
  `Quantity` decimal(10,0) DEFAULT 0,
  `Location` varchar(255),
  `AsAtDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `UpdateDate` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

INSERT INTO `tblInventory` (`id`, `ProductID`, `Quantity`, `Location`, `AsAtDate`, `UpdateDate`) VALUES
(1, 1, 9100, 'Central', '2023-03-19 15:46:13', NULL),
(2, 2, 9200, 'Central', '2023-03-19 15:46:13', '2023-03-19 15:46:31'),
(3, 3, 9300, 'Central', '2023-03-19 15:46:21', NULL),
(4, 4, 9400, 'Central', '2023-03-19 15:46:21', NULL),
(5, 5, 9500, 'Central', '2023-03-19 15:46:21', NULL),
(6, 6, 9600, 'Central', '2023-03-19 15:46:13', '2023-03-19 15:46:36'),
(7, 7, 9700, 'Central', '2023-03-19 15:46:21', NULL),
(8, 8, 9800, 'Central', '2023-03-19 15:49:21', NULL);


DROP TABLE if exists tblpayments;


CREATE TABLE `tblPayments` (
  `id` int NOT NULL,
  `CustomerID` int NOT NULL,
  `InvoiceNumber` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `currency` varchar(25) NOT NULL default 'AUD',
  `payment_type` varchar(25) NOT NULL default 'Card',
  `payment_status` varchar(25),
  `PaymentDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

ALTER TABLE `tblUsers`
  ADD PRIMARY KEY (`ID`);

ALTER TABLE `tblCategory`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `tblSupplier`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `tblorders`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `tblInvoice`
  ADD PRIMARY KEY (`id`);
  
ALTER TABLE `tblInvoice`
  ADD CONSTRAINT tblInvoice_UQ UNIQUE INDEX (`InvoiceNumber`);

ALTER TABLE `tblproducts`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `tblDiscountRates`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `tblInventory`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `tblPayments`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--
ALTER TABLE `tblUsers`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

ALTER TABLE `tblcategory`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

ALTER TABLE `tblSupplier`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

ALTER TABLE `tblorders`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

ALTER TABLE `tblInvoice`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

ALTER TABLE `tblproducts`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
  
ALTER TABLE `tblDiscountRates`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;
  
ALTER TABLE `tblInventory`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;
  
ALTER TABLE `tblPayments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- Foreign keys
--

ALTER TABLE `tblInvoice`
  ADD CONSTRAINT tblInvoice_User_FK FOREIGN KEY (`CustomerID`) REFERENCES tblUsers( ID );
  
ALTER TABLE `tblPayments`
  ADD CONSTRAINT tblPayments_User_FK FOREIGN KEY (`CustomerID`) REFERENCES tblUsers( ID );
  
ALTER TABLE `tblPayments`
  ADD CONSTRAINT tblPayments_Invoice_FK FOREIGN KEY (`InvoiceNumber`) REFERENCES tblInvoice( InvoiceNumber );
  
ALTER TABLE `tblOrders`
  ADD CONSTRAINT tblOrders_Invoice_FK FOREIGN KEY (`InvoiceNumber`) REFERENCES tblInvoice( InvoiceNumber );
  
ALTER TABLE `tblOrders`
  ADD CONSTRAINT tblOrders_Product_FK FOREIGN KEY (`ProductID`) REFERENCES tblProducts( ID );
  
ALTER TABLE `tblInventory`
  ADD CONSTRAINT tblInventory_Product_FK FOREIGN KEY (`ProductID`) REFERENCES tblProducts( ID );
  

  
  
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
