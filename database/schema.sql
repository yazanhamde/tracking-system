-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `your_database`
--

-- --------------------------------------------------------

--
-- Table structure for table `alerts`
--

CREATE TABLE `alerts` (
  `id` int(11) NOT NULL,
  `type` enum('vehicle_outside_hours','late_arrival','absent','overtime_request','maintenance_due','geofence_exit','low_fuel','task_overdue') NOT NULL,
  `vehicle_id` int(11) DEFAULT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `dismissed_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `alerts`
--


-- --------------------------------------------------------

--
-- Table structure for table `attendance`
--

CREATE TABLE `attendance` (
  `id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `check_in` datetime DEFAULT NULL,
  `check_out` datetime DEFAULT NULL,
  `check_in_lat` decimal(10,8) DEFAULT NULL,
  `check_in_lng` decimal(11,8) DEFAULT NULL,
  `check_in_address` varchar(300) DEFAULT NULL,
  `check_out_lat` decimal(10,8) DEFAULT NULL,
  `check_out_lng` decimal(11,8) DEFAULT NULL,
  `check_out_address` varchar(300) DEFAULT NULL,
  `date` date NOT NULL,
  `status` enum('on_time','late','early_leave') DEFAULT 'on_time',
  `late_minutes` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `attendance`
--


-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `manager_id` int(11) DEFAULT NULL COMMENT 'مدير القسم — يشير لـ employees.id',
  `parent_id` int(11) DEFAULT NULL COMMENT 'للتسلسل الهرمي: قسم فرعي ضمن قسم رئيسي',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='الأقسام والهيكل التنظيمي';

-- --------------------------------------------------------

--
-- Table structure for table `driver_tasks`
--

CREATE TABLE `driver_tasks` (
  `id` int(11) NOT NULL,
  `driver_id` int(11) NOT NULL,
  `vehicle_id` int(11) DEFAULT NULL,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `destination` varchar(255) DEFAULT NULL,
  `dest_lat` decimal(10,8) DEFAULT NULL,
  `dest_lng` decimal(11,8) DEFAULT NULL,
  `priority` enum('low','normal','high','urgent') DEFAULT 'normal',
  `status` enum('pending','accepted','in_progress','completed','cancelled') DEFAULT 'pending',
  `due_date` date DEFAULT NULL,
  `due_time` time DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `driver_note` text DEFAULT NULL,
  `assigned_by` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','hr','employee','driver') DEFAULT 'employee',
  `can_view_reports` tinyint(1) NOT NULL DEFAULT 0,
  `department_id` int(11) DEFAULT NULL COMMENT 'القسم الذي ينتمي إليه الموظف',
  `phone` varchar(20) DEFAULT NULL,
  `work_start` time DEFAULT '08:00:00',
  `work_end` time DEFAULT '17:00:00',
  `hire_date` date DEFAULT NULL,
  `national_id` varchar(20) DEFAULT NULL,
  `job_title` varchar(80) DEFAULT NULL,
  `salary` decimal(10,2) DEFAULT NULL,
  `fcm_token` text DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employees`
--


-- --------------------------------------------------------

--
-- Table structure for table `employee_locations`
--

CREATE TABLE `employee_locations` (
  `id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `lat` decimal(10,8) NOT NULL,
  `lng` decimal(11,8) NOT NULL,
  `accuracy` float DEFAULT NULL,
  `recorded_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee_locations`
--


-- --------------------------------------------------------

--
-- Table structure for table `employee_notes`
--

CREATE TABLE `employee_notes` (
  `id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `note` text NOT NULL,
  `lat` decimal(10,8) DEFAULT NULL,
  `lng` decimal(11,8) DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee_notes`
--


-- --------------------------------------------------------

--
-- Table structure for table `employee_shifts`
--

CREATE TABLE `employee_shifts` (
  `id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `shift_id` int(11) NOT NULL,
  `shift_date` date NOT NULL,
  `note` varchar(200) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `geofence_alerts`
--

CREATE TABLE `geofence_alerts` (
  `id` int(11) NOT NULL,
  `vehicle_id` int(11) NOT NULL,
  `driver_id` int(11) DEFAULT NULL,
  `alert_type` enum('exit','entry') NOT NULL DEFAULT 'exit',
  `lat` decimal(10,8) DEFAULT NULL,
  `lng` decimal(11,8) DEFAULT NULL,
  `distance_m` int(11) DEFAULT NULL COMMENT 'المسافة عن مركز الجيوفنس',
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `holidays`
--

CREATE TABLE `holidays` (
  `id` int(11) NOT NULL,
  `date` date NOT NULL,
  `name` varchar(100) NOT NULL,
  `is_recurring` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'لو 1: العطلة تتكرر كل سنة (مثل أعياد ثابتة)',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='جدول العطل الرسمية — يمنع تصنيف الغياب فيها كتغيب';

--
-- Dumping data for table `holidays`
--


-- --------------------------------------------------------

--
-- Table structure for table `internal_messages`
--

CREATE TABLE `internal_messages` (
  `id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `subject` varchar(200) DEFAULT NULL,
  `body` text NOT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `read_at` datetime DEFAULT NULL,
  `deleted_by_sender` tinyint(1) DEFAULT 0,
  `deleted_by_receiver` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `internal_messages`
--


-- --------------------------------------------------------

--
-- Table structure for table `inventory_log`
--

CREATE TABLE `inventory_log` (
  `id` int(11) NOT NULL,
  `part_id` int(11) NOT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `action` varchar(50) NOT NULL COMMENT 'add / sell / edit / delete',
  `qty_before` int(11) NOT NULL DEFAULT 0,
  `qty_after` int(11) NOT NULL DEFAULT 0,
  `note` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='سجل حركات المخزون (وارد/صادر/تعديل)';

--
-- Dumping data for table `inventory_log`
--


-- --------------------------------------------------------

--
-- Table structure for table `leave_balances`
--

CREATE TABLE `leave_balances` (
  `id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `leave_type_id` int(11) NOT NULL,
  `year` year(4) NOT NULL DEFAULT year(curdate()),
  `total_days` decimal(5,1) NOT NULL DEFAULT 0.0,
  `used_days` decimal(5,1) NOT NULL DEFAULT 0.0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `leave_balances`
--


-- --------------------------------------------------------

--
-- Table structure for table `leave_requests`
--

CREATE TABLE `leave_requests` (
  `id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `leave_type_id` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `days_count` decimal(4,1) NOT NULL DEFAULT 1.0,
  `reason` text DEFAULT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `admin_note` varchar(255) DEFAULT NULL,
  `reviewed_by` int(11) DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `leave_types`
--

CREATE TABLE `leave_types` (
  `id` int(11) NOT NULL,
  `name` varchar(60) NOT NULL,
  `default_balance` decimal(5,1) NOT NULL DEFAULT 0.0,
  `is_paid` tinyint(1) NOT NULL DEFAULT 1,
  `color` varchar(20) DEFAULT '#4f8ef7',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `leave_types`
--

INSERT INTO `leave_types` (`id`, `name`, `default_balance`, `is_paid`, `color`, `created_at`) VALUES
(1, 'إجازة سنوية', 14.0, 1, '#3ecf8e', '2026-09-21 22:54:00'),
(2, 'إجازة مرضية', 7.0, 1, '#e25b5b', '2026-09-21 22:54:00'),
(3, 'إذن / مهمة', 0.0, 1, '#4f8ef7', '2026-09-21 22:54:00'),
(4, 'إجازة طارئة', 3.0, 1, '#f5a623', '2026-09-21 22:54:00');

-- --------------------------------------------------------

--
-- Table structure for table `login_attempts`
--

CREATE TABLE `login_attempts` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `ip` varchar(45) NOT NULL,
  `success` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='سجل محاولات الدخول للمراقبة الأمنية';

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `type` varchar(40) NOT NULL,
  `title` varchar(150) NOT NULL,
  `body` text DEFAULT NULL,
  `ref_id` int(11) DEFAULT NULL,
  `ref_type` varchar(40) DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--


-- --------------------------------------------------------

--
-- Table structure for table `overtime_requests`
--

CREATE TABLE `overtime_requests` (
  `id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `request_date` date NOT NULL,
  `requested_at` datetime DEFAULT current_timestamp(),
  `status` enum('pending','approved','rejected','completed') DEFAULT 'pending',
  `admin_note` varchar(255) DEFAULT NULL,
  `responded_at` datetime DEFAULT NULL,
  `ot_check_in` datetime DEFAULT NULL,
  `ot_check_out` datetime DEFAULT NULL,
  `ot_check_out_lat` decimal(10,8) DEFAULT NULL,
  `ot_check_out_lng` decimal(11,8) DEFAULT NULL,
  `ot_check_out_address` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `overtime_requests`
--


-- --------------------------------------------------------

--
-- Table structure for table `parts`
--

CREATE TABLE `parts` (
  `id` int(11) NOT NULL,
  `part_code` varchar(20) NOT NULL,
  `name` varchar(200) NOT NULL,
  `device` varchar(200) NOT NULL,
  `section_id` int(11) NOT NULL,
  `qty` int(11) NOT NULL DEFAULT 0,
  `min_qty` int(11) NOT NULL DEFAULT 5 COMMENT 'الكمية الدنيا — تُظهر تحذيراً أصفر عند الوصول إليها',
  `cost_price` decimal(10,2) DEFAULT NULL COMMENT 'سعر الشراء',
  `sell_price` decimal(10,2) DEFAULT NULL COMMENT 'سعر البيع',
  `supplier_id` int(11) DEFAULT NULL COMMENT 'مورد القطعة',
  `barcode` varchar(100) DEFAULT NULL COMMENT 'باركود القطعة',
  `note` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `parts`
--


-- --------------------------------------------------------

--
-- Table structure for table `parts_sales`
--

CREATE TABLE `parts_sales` (
  `id` int(11) NOT NULL,
  `part_id` int(11) NOT NULL,
  `employee_id` int(11) DEFAULT NULL COMMENT 'من أجرى البيع',
  `qty` int(11) NOT NULL DEFAULT 1,
  `sell_price` decimal(10,2) DEFAULT NULL COMMENT 'سعر البيع وقت العملية',
  `cost_price` decimal(10,2) DEFAULT NULL COMMENT 'سعر الشراء وقت العملية',
  `note` text DEFAULT NULL,
  `sold_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='سجل مبيعات قطع الغيار';

-- --------------------------------------------------------

--
-- Table structure for table `performance_reviews`
--

CREATE TABLE `performance_reviews` (
  `id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `reviewer_id` int(11) NOT NULL,
  `review_year` smallint(4) NOT NULL,
  `review_month` tinyint(2) NOT NULL,
  `score_attendance` tinyint(1) DEFAULT NULL,
  `score_performance` tinyint(1) DEFAULT NULL,
  `score_behavior` tinyint(1) DEFAULT NULL,
  `score_commitment` tinyint(1) DEFAULT NULL,
  `score_total` decimal(4,2) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `status` enum('draft','final') DEFAULT 'final',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sections`
--

CREATE TABLE `sections` (
  `id` int(11) NOT NULL,
  `letter` char(1) NOT NULL,
  `number` tinyint(4) NOT NULL,
  `label` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sections`
--

INSERT INTO `sections` (`id`, `letter`, `number`, `label`) VALUES
(1, 'A', 1, 'A1'),
(2, 'A', 2, 'A2'),
(3, 'A', 3, 'A3'),
(4, 'A', 4, 'A4'),
(5, 'A', 5, 'A5'),
(6, 'A', 6, 'A6'),
(7, 'A', 7, 'A7'),
(8, 'A', 8, 'A8'),
(9, 'A', 9, 'A9'),
(10, 'A', 10, 'A10'),
(11, 'B', 1, 'B1'),
(12, 'B', 2, 'B2'),
(13, 'B', 3, 'B3'),
(14, 'B', 4, 'B4'),
(15, 'B', 5, 'B5'),
(16, 'B', 6, 'B6'),
(17, 'B', 7, 'B7'),
(18, 'B', 8, 'B8'),
(19, 'B', 9, 'B9'),
(20, 'B', 10, 'B10'),
(21, 'C', 1, 'C1'),
(22, 'C', 2, 'C2'),
(23, 'C', 3, 'C3'),
(24, 'C', 4, 'C4'),
(25, 'C', 5, 'C5'),
(26, 'C', 6, 'C6'),
(27, 'C', 7, 'C7'),
(28, 'C', 8, 'C8'),
(29, 'C', 9, 'C9'),
(30, 'C', 10, 'C10'),
(31, 'D', 1, 'D1'),
(32, 'D', 2, 'D2'),
(33, 'D', 3, 'D3'),
(34, 'D', 4, 'D4'),
(35, 'D', 5, 'D5'),
(36, 'D', 6, 'D6'),
(37, 'D', 7, 'D7'),
(38, 'D', 8, 'D8'),
(39, 'D', 9, 'D9'),
(40, 'D', 10, 'D10'),
(41, 'E', 1, 'E1'),
(42, 'E', 2, 'E2'),
(43, 'E', 3, 'E3'),
(44, 'E', 4, 'E4'),
(45, 'E', 5, 'E5'),
(46, 'E', 6, 'E6'),
(47, 'E', 7, 'E7'),
(48, 'E', 8, 'E8'),
(49, 'E', 9, 'E9'),
(50, 'E', 10, 'E10'),
(51, 'F', 1, 'F1'),
(52, 'F', 2, 'F2'),
(53, 'F', 3, 'F3'),
(54, 'F', 4, 'F4'),
(55, 'F', 5, 'F5'),
(56, 'F', 6, 'F6'),
(57, 'F', 7, 'F7'),
(58, 'F', 8, 'F8'),
(59, 'F', 9, 'F9'),
(60, 'F', 10, 'F10'),
(61, 'G', 1, 'G1'),
(62, 'G', 2, 'G2'),
(63, 'G', 3, 'G3'),
(64, 'G', 4, 'G4'),
(65, 'G', 5, 'G5'),
(66, 'G', 6, 'G6'),
(67, 'G', 7, 'G7'),
(68, 'G', 8, 'G8'),
(69, 'G', 9, 'G9'),
(70, 'G', 10, 'G10'),
(71, 'H', 1, 'H1'),
(72, 'H', 2, 'H2'),
(73, 'H', 3, 'H3'),
(74, 'H', 4, 'H4'),
(75, 'H', 5, 'H5'),
(76, 'H', 6, 'H6'),
(77, 'H', 7, 'H7'),
(78, 'H', 8, 'H8'),
(79, 'H', 9, 'H9'),
(80, 'H', 10, 'H10'),
(81, 'I', 1, 'I1'),
(82, 'I', 2, 'I2'),
(83, 'I', 3, 'I3'),
(84, 'I', 4, 'I4'),
(85, 'I', 5, 'I5'),
(86, 'I', 6, 'I6'),
(87, 'I', 7, 'I7'),
(88, 'I', 8, 'I8'),
(89, 'I', 9, 'I9'),
(90, 'I', 10, 'I10'),
(91, 'J', 1, 'J1'),
(92, 'J', 2, 'J2'),
(93, 'J', 3, 'J3'),
(94, 'J', 4, 'J4'),
(95, 'J', 5, 'J5'),
(96, 'J', 6, 'J6'),
(97, 'J', 7, 'J7'),
(98, 'J', 8, 'J8'),
(99, 'J', 9, 'J9'),
(100, 'J', 10, 'J10'),
(101, 'K', 1, 'K1'),
(102, 'K', 2, 'K2'),
(103, 'K', 3, 'K3'),
(104, 'K', 4, 'K4'),
(105, 'K', 5, 'K5'),
(106, 'K', 6, 'K6'),
(107, 'K', 7, 'K7'),
(108, 'K', 8, 'K8'),
(109, 'K', 9, 'K9'),
(110, 'K', 10, 'K10'),
(111, 'L', 1, 'L1'),
(112, 'L', 2, 'L2'),
(113, 'L', 3, 'L3'),
(114, 'L', 4, 'L4'),
(115, 'L', 5, 'L5'),
(116, 'L', 6, 'L6'),
(117, 'L', 7, 'L7'),
(118, 'L', 8, 'L8'),
(119, 'L', 9, 'L9'),
(120, 'L', 10, 'L10'),
(121, 'M', 1, 'M1'),
(122, 'M', 2, 'M2'),
(123, 'M', 3, 'M3'),
(124, 'M', 4, 'M4'),
(125, 'M', 5, 'M5'),
(126, 'M', 6, 'M6'),
(127, 'M', 7, 'M7'),
(128, 'M', 8, 'M8'),
(129, 'M', 9, 'M9'),
(130, 'M', 10, 'M10'),
(131, 'N', 1, 'N1'),
(132, 'N', 2, 'N2'),
(133, 'N', 3, 'N3'),
(134, 'N', 4, 'N4'),
(135, 'N', 5, 'N5'),
(136, 'N', 6, 'N6'),
(137, 'N', 7, 'N7'),
(138, 'N', 8, 'N8'),
(139, 'N', 9, 'N9'),
(140, 'N', 10, 'N10'),
(141, 'O', 1, 'O1'),
(142, 'O', 2, 'O2'),
(143, 'O', 3, 'O3'),
(144, 'O', 4, 'O4'),
(145, 'O', 5, 'O5'),
(146, 'O', 6, 'O6'),
(147, 'O', 7, 'O7'),
(148, 'O', 8, 'O8'),
(149, 'O', 9, 'O9'),
(150, 'O', 10, 'O10'),
(151, 'P', 1, 'P1'),
(152, 'P', 2, 'P2'),
(153, 'P', 3, 'P3'),
(154, 'P', 4, 'P4'),
(155, 'P', 5, 'P5'),
(156, 'P', 6, 'P6'),
(157, 'P', 7, 'P7'),
(158, 'P', 8, 'P8'),
(159, 'P', 9, 'P9'),
(160, 'P', 10, 'P10'),
(161, 'Q', 1, 'Q1'),
(162, 'Q', 2, 'Q2'),
(163, 'Q', 3, 'Q3'),
(164, 'Q', 4, 'Q4'),
(165, 'Q', 5, 'Q5'),
(166, 'Q', 6, 'Q6'),
(167, 'Q', 7, 'Q7'),
(168, 'Q', 8, 'Q8'),
(169, 'Q', 9, 'Q9'),
(170, 'Q', 10, 'Q10'),
(171, 'R', 1, 'R1'),
(172, 'R', 2, 'R2'),
(173, 'R', 3, 'R3'),
(174, 'R', 4, 'R4'),
(175, 'R', 5, 'R5'),
(176, 'R', 6, 'R6'),
(177, 'R', 7, 'R7'),
(178, 'R', 8, 'R8'),
(179, 'R', 9, 'R9'),
(180, 'R', 10, 'R10'),
(181, 'S', 1, 'S1'),
(182, 'S', 2, 'S2'),
(183, 'S', 3, 'S3'),
(184, 'S', 4, 'S4'),
(185, 'S', 5, 'S5'),
(186, 'S', 6, 'S6'),
(187, 'S', 7, 'S7'),
(188, 'S', 8, 'S8'),
(189, 'S', 9, 'S9'),
(190, 'S', 10, 'S10'),
(191, 'T', 1, 'T1'),
(192, 'T', 2, 'T2'),
(193, 'T', 3, 'T3'),
(194, 'T', 4, 'T4'),
(195, 'T', 5, 'T5'),
(196, 'T', 6, 'T6'),
(197, 'T', 7, 'T7'),
(198, 'T', 8, 'T8'),
(199, 'T', 9, 'T9'),
(200, 'T', 10, 'T10'),
(201, 'U', 1, 'U1'),
(202, 'U', 2, 'U2'),
(203, 'U', 3, 'U3'),
(204, 'U', 4, 'U4'),
(205, 'U', 5, 'U5'),
(206, 'U', 6, 'U6'),
(207, 'U', 7, 'U7'),
(208, 'U', 8, 'U8'),
(209, 'U', 9, 'U9'),
(210, 'U', 10, 'U10'),
(211, 'V', 1, 'V1'),
(212, 'V', 2, 'V2'),
(213, 'V', 3, 'V3'),
(214, 'V', 4, 'V4'),
(215, 'V', 5, 'V5'),
(216, 'V', 6, 'V6'),
(217, 'V', 7, 'V7'),
(218, 'V', 8, 'V8'),
(219, 'V', 9, 'V9'),
(220, 'V', 10, 'V10'),
(221, 'W', 1, 'W1'),
(222, 'W', 2, 'W2'),
(223, 'W', 3, 'W3'),
(224, 'W', 4, 'W4'),
(225, 'W', 5, 'W5'),
(226, 'W', 6, 'W6'),
(227, 'W', 7, 'W7'),
(228, 'W', 8, 'W8'),
(229, 'W', 9, 'W9'),
(230, 'W', 10, 'W10'),
(231, 'X', 1, 'X1'),
(232, 'X', 2, 'X2'),
(233, 'X', 3, 'X3'),
(234, 'X', 4, 'X4'),
(235, 'X', 5, 'X5'),
(236, 'X', 6, 'X6'),
(237, 'X', 7, 'X7'),
(238, 'X', 8, 'X8'),
(239, 'X', 9, 'X9'),
(240, 'X', 10, 'X10'),
(241, 'Y', 1, 'Y1'),
(242, 'Y', 2, 'Y2'),
(243, 'Y', 3, 'Y3'),
(244, 'Y', 4, 'Y4'),
(245, 'Y', 5, 'Y5'),
(246, 'Y', 6, 'Y6'),
(247, 'Y', 7, 'Y7'),
(248, 'Y', 8, 'Y8'),
(249, 'Y', 9, 'Y9'),
(250, 'Y', 10, 'Y10'),
(251, 'Z', 1, 'Z1'),
(252, 'Z', 2, 'Z2'),
(253, 'Z', 3, 'Z3'),
(254, 'Z', 4, 'Z4'),
(255, 'Z', 5, 'Z5'),
(256, 'Z', 6, 'Z6'),
(257, 'Z', 7, 'Z7'),
(258, 'Z', 8, 'Z8'),
(259, 'Z', 9, 'Z9'),
(260, 'Z', 10, 'Z10');

-- --------------------------------------------------------

--
-- Table structure for table `shifts`
--

CREATE TABLE `shifts` (
  `id` int(11) NOT NULL,
  `name` varchar(60) NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `color` varchar(20) DEFAULT '#4f8ef7',
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `shifts`
--


-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL COMMENT 'اسم المورد',
  `phone` varchar(30) DEFAULT NULL COMMENT 'رقم الهاتف',
  `email` varchar(120) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='موردو القطع';

--
-- Dumping data for table `suppliers`
--


-- --------------------------------------------------------

--
-- Table structure for table `trips`
--

CREATE TABLE `trips` (
  `id` int(11) NOT NULL,
  `trip_uid` varchar(50) NOT NULL,
  `vehicle_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime DEFAULT NULL,
  `start_lat` decimal(10,8) DEFAULT NULL,
  `start_lng` decimal(11,8) DEFAULT NULL,
  `end_lat` decimal(10,8) DEFAULT NULL,
  `end_lng` decimal(11,8) DEFAULT NULL,
  `distance_km` decimal(8,2) DEFAULT 0.00,
  `km_inside` decimal(8,3) DEFAULT 0.000,
  `km_outside` decimal(8,3) DEFAULT 0.000,
  `purpose` varchar(255) DEFAULT NULL,
  `status` enum('active','completed') DEFAULT 'active',
  `outside_hours` tinyint(1) DEFAULT 0,
  `driver_note` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `trips`
--


-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE `vehicles` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `plate_number` varchar(20) DEFAULT NULL,
  `model` varchar(100) DEFAULT NULL,
  `year` year(4) DEFAULT NULL,
  `color` varchar(50) DEFAULT NULL,
  `fuel_type` enum('petrol','diesel','electric','hybrid') DEFAULT 'petrol',
  `tank_capacity_l` decimal(6,1) DEFAULT NULL,
  `fuel_efficiency_km_l` decimal(5,2) DEFAULT NULL,
  `odometer_km` int(11) NOT NULL DEFAULT 0,
  `next_service_km` int(11) DEFAULT NULL,
  `next_service_date` date DEFAULT NULL,
  `geofence_lat` decimal(10,8) DEFAULT NULL,
  `geofence_lng` decimal(11,8) DEFAULT NULL,
  `geofence_radius_m` int(11) DEFAULT NULL COMMENT 'نصف قطر الجيوفنس بالمتر',
  `geofence_active` tinyint(1) DEFAULT 0,
  `insurance_expiry` date DEFAULT NULL,
  `license_expiry` date DEFAULT NULL,
  `purchase_date` date DEFAULT NULL,
  `assigned_to` int(11) DEFAULT NULL,
  `status` enum('active','idle','alert') DEFAULT 'idle'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vehicles`
--


-- --------------------------------------------------------

--
-- Table structure for table `vehicle_expenses`
--

CREATE TABLE `vehicle_expenses` (
  `id` int(11) NOT NULL,
  `vehicle_id` int(11) NOT NULL,
  `expense_type` enum('fuel','maintenance','insurance','license','fine','parking','wash','other') NOT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `description` varchar(255) DEFAULT NULL,
  `expense_date` date NOT NULL DEFAULT curdate(),
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `vehicle_fuel_log`
--

CREATE TABLE `vehicle_fuel_log` (
  `id` int(11) NOT NULL,
  `vehicle_id` int(11) NOT NULL,
  `driver_id` int(11) DEFAULT NULL,
  `fuel_liters` decimal(7,2) DEFAULT NULL,
  `fuel_cost` decimal(10,2) NOT NULL DEFAULT 0.00,
  `odometer_km` int(11) DEFAULT NULL,
  `station_name` varchar(100) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `log_date` date NOT NULL DEFAULT curdate(),
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `vehicle_maintenance`
--

CREATE TABLE `vehicle_maintenance` (
  `id` int(11) NOT NULL,
  `vehicle_id` int(11) NOT NULL,
  `maintenance_type` enum('oil_change','tire','brake','filter','battery','inspection','other') NOT NULL DEFAULT 'other',
  `description` text DEFAULT NULL,
  `cost` decimal(10,2) DEFAULT 0.00,
  `odometer_km` int(11) DEFAULT NULL COMMENT 'عداد الكيلومترات وقت الصيانة',
  `next_service_km` int(11) DEFAULT NULL,
  `next_service_date` date DEFAULT NULL,
  `performed_by` varchar(100) DEFAULT NULL COMMENT 'الورشة / الميكانيكي',
  `performed_at` date NOT NULL DEFAULT curdate(),
  `notes` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL COMMENT 'employee_id للمشرف',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `vehicle_tracking`
--

CREATE TABLE `vehicle_tracking` (
  `id` int(11) NOT NULL,
  `vehicle_id` int(11) NOT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `lat` decimal(10,8) NOT NULL,
  `lng` decimal(11,8) NOT NULL,
  `speed` float DEFAULT 0,
  `trip_id` varchar(50) DEFAULT NULL,
  `recorded_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vehicle_tracking`
--


--
-- Indexes for dumped tables
--

--
-- Indexes for table `alerts`
--
ALTER TABLE `alerts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `vehicle_id` (`vehicle_id`),
  ADD KEY `employee_id` (`employee_id`);

--
-- Indexes for table `attendance`
--
ALTER TABLE `attendance`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_date` (`date`),
  ADD KEY `idx_employee` (`employee_id`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_dept_manager` (`manager_id`),
  ADD KEY `fk_dept_parent` (`parent_id`);

--
-- Indexes for table `driver_tasks`
--
ALTER TABLE `driver_tasks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_driver` (`driver_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_due` (`due_date`),
  ADD KEY `fk_dt_vehicle` (`vehicle_id`),
  ADD KEY `fk_dt_assigned` (`assigned_by`);

--
-- Indexes for table `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `employee_locations`
--
ALTER TABLE `employee_locations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_employee_time` (`employee_id`,`recorded_at`);

--
-- Indexes for table `employee_notes`
--
ALTER TABLE `employee_notes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `employee_id` (`employee_id`);

--
-- Indexes for table `employee_shifts`
--
ALTER TABLE `employee_shifts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_emp_date` (`employee_id`,`shift_date`),
  ADD KEY `fk_es_emp` (`employee_id`),
  ADD KEY `fk_es_shift` (`shift_id`),
  ADD KEY `idx_es_date` (`shift_date`);

--
-- Indexes for table `geofence_alerts`
--
ALTER TABLE `geofence_alerts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_vehicle` (`vehicle_id`);

--
-- Indexes for table `holidays`
--
ALTER TABLE `holidays`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_holiday_date` (`date`);

--
-- Indexes for table `internal_messages`
--
ALTER TABLE `internal_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_msg_receiver` (`receiver_id`,`is_read`),
  ADD KEY `idx_msg_sender` (`sender_id`);

--
-- Indexes for table `inventory_log`
--
ALTER TABLE `inventory_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `part_id` (`part_id`),
  ADD KEY `created_at` (`created_at`);

--
-- Indexes for table `leave_balances`
--
ALTER TABLE `leave_balances`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_emp_type_year` (`employee_id`,`leave_type_id`,`year`),
  ADD KEY `fk_lb_emp` (`employee_id`),
  ADD KEY `fk_lb_type` (`leave_type_id`);

--
-- Indexes for table `leave_requests`
--
ALTER TABLE `leave_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_lr_emp` (`employee_id`),
  ADD KEY `fk_lr_type` (`leave_type_id`),
  ADD KEY `idx_lr_status` (`status`),
  ADD KEY `idx_lr_dates` (`start_date`,`end_date`);

--
-- Indexes for table `leave_types`
--
ALTER TABLE `leave_types`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `login_attempts`
--
ALTER TABLE `login_attempts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_username_time` (`username`,`created_at`),
  ADD KEY `idx_ip_time` (`ip`,`created_at`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_notif_emp` (`employee_id`,`is_read`),
  ADD KEY `idx_notif_time` (`created_at`);

--
-- Indexes for table `overtime_requests`
--
ALTER TABLE `overtime_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_emp_date` (`employee_id`,`request_date`);

--
-- Indexes for table `parts`
--
ALTER TABLE `parts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `part_code` (`part_code`),
  ADD KEY `section_id` (`section_id`);

--
-- Indexes for table `parts_sales`
--
ALTER TABLE `parts_sales`
  ADD PRIMARY KEY (`id`),
  ADD KEY `part_id` (`part_id`),
  ADD KEY `employee_id` (`employee_id`),
  ADD KEY `sold_at` (`sold_at`);

--
-- Indexes for table `performance_reviews`
--
ALTER TABLE `performance_reviews`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_perf_emp_month` (`employee_id`,`review_year`,`review_month`),
  ADD KEY `fk_perf_emp` (`employee_id`),
  ADD KEY `fk_perf_reviewer` (`reviewer_id`);

--
-- Indexes for table `sections`
--
ALTER TABLE `sections`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_label` (`label`);

--
-- Indexes for table `shifts`
--
ALTER TABLE `shifts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trips`
--
ALTER TABLE `trips`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `trip_uid` (`trip_uid`),
  ADD KEY `vehicle_id` (`vehicle_id`),
  ADD KEY `employee_id` (`employee_id`);

--
-- Indexes for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `assigned_to` (`assigned_to`);

--
-- Indexes for table `vehicle_expenses`
--
ALTER TABLE `vehicle_expenses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_vehicle` (`vehicle_id`);

--
-- Indexes for table `vehicle_fuel_log`
--
ALTER TABLE `vehicle_fuel_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_vehicle` (`vehicle_id`),
  ADD KEY `idx_driver` (`driver_id`),
  ADD KEY `idx_date` (`log_date`);

--
-- Indexes for table `vehicle_maintenance`
--
ALTER TABLE `vehicle_maintenance`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_vehicle` (`vehicle_id`),
  ADD KEY `idx_date` (`performed_at`),
  ADD KEY `fk_vm_creator` (`created_by`);

--
-- Indexes for table `vehicle_tracking`
--
ALTER TABLE `vehicle_tracking`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_vehicle_time` (`vehicle_id`,`recorded_at`),
  ADD KEY `idx_trip` (`trip_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `alerts`
--
ALTER TABLE `alerts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,;

--
-- AUTO_INCREMENT for table `attendance`
--
ALTER TABLE `attendance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `driver_tasks`
--
ALTER TABLE `driver_tasks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `employees`
--
ALTER TABLE `employees`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,;

--
-- AUTO_INCREMENT for table `employee_locations`
--
ALTER TABLE `employee_locations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,;

--
-- AUTO_INCREMENT for table `employee_notes`
--
ALTER TABLE `employee_notes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,;

--
-- AUTO_INCREMENT for table `employee_shifts`
--
ALTER TABLE `employee_shifts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `geofence_alerts`
--
ALTER TABLE `geofence_alerts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `holidays`
--
ALTER TABLE `holidays`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,;

--
-- AUTO_INCREMENT for table `internal_messages`
--
ALTER TABLE `internal_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,;

--
-- AUTO_INCREMENT for table `inventory_log`
--
ALTER TABLE `inventory_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,;

--
-- AUTO_INCREMENT for table `leave_balances`
--
ALTER TABLE `leave_balances`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,;

--
-- AUTO_INCREMENT for table `leave_requests`
--
ALTER TABLE `leave_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `leave_types`
--
ALTER TABLE `leave_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,;

--
-- AUTO_INCREMENT for table `login_attempts`
--
ALTER TABLE `login_attempts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,;

--
-- AUTO_INCREMENT for table `overtime_requests`
--
ALTER TABLE `overtime_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,;

--
-- AUTO_INCREMENT for table `parts`
--
ALTER TABLE `parts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,;

--
-- AUTO_INCREMENT for table `parts_sales`
--
ALTER TABLE `parts_sales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `performance_reviews`
--
ALTER TABLE `performance_reviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sections`
--
ALTER TABLE `sections`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,;

--
-- AUTO_INCREMENT for table `shifts`
--
ALTER TABLE `shifts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,;

--
-- AUTO_INCREMENT for table `trips`
--
ALTER TABLE `trips`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,;

--
-- AUTO_INCREMENT for table `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,;

--
-- AUTO_INCREMENT for table `vehicle_expenses`
--
ALTER TABLE `vehicle_expenses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `vehicle_fuel_log`
--
ALTER TABLE `vehicle_fuel_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `vehicle_maintenance`
--
ALTER TABLE `vehicle_maintenance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `vehicle_tracking`
--
ALTER TABLE `vehicle_tracking`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `alerts`
--
ALTER TABLE `alerts`
  ADD CONSTRAINT `alerts_ibfk_1` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`),
  ADD CONSTRAINT `alerts_ibfk_2` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`);

--
-- Constraints for table `attendance`
--
ALTER TABLE `attendance`
  ADD CONSTRAINT `attendance_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`);

--
-- Constraints for table `driver_tasks`
--
ALTER TABLE `driver_tasks`
  ADD CONSTRAINT `fk_dt_assigned` FOREIGN KEY (`assigned_by`) REFERENCES `employees` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_dt_driver` FOREIGN KEY (`driver_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_dt_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `employee_locations`
--
ALTER TABLE `employee_locations`
  ADD CONSTRAINT `employee_locations_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`);

--
-- Constraints for table `employee_notes`
--
ALTER TABLE `employee_notes`
  ADD CONSTRAINT `employee_notes_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`);

--
-- Constraints for table `geofence_alerts`
--
ALTER TABLE `geofence_alerts`
  ADD CONSTRAINT `fk_ga_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `overtime_requests`
--
ALTER TABLE `overtime_requests`
  ADD CONSTRAINT `overtime_requests_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`);

--
-- Constraints for table `trips`
--
ALTER TABLE `trips`
  ADD CONSTRAINT `trips_ibfk_1` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`),
  ADD CONSTRAINT `trips_ibfk_2` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`);

--
-- Constraints for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD CONSTRAINT `vehicles_ibfk_1` FOREIGN KEY (`assigned_to`) REFERENCES `employees` (`id`);

--
-- Constraints for table `vehicle_expenses`
--
ALTER TABLE `vehicle_expenses`
  ADD CONSTRAINT `fk_ve_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `vehicle_fuel_log`
--
ALTER TABLE `vehicle_fuel_log`
  ADD CONSTRAINT `fk_vfl_driver` FOREIGN KEY (`driver_id`) REFERENCES `employees` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_vfl_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `vehicle_maintenance`
--
ALTER TABLE `vehicle_maintenance`
  ADD CONSTRAINT `fk_vm_creator` FOREIGN KEY (`created_by`) REFERENCES `employees` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_vm_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `vehicle_tracking`
--
ALTER TABLE `vehicle_tracking`
  ADD CONSTRAINT `vehicle_tracking_ibfk_1` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
