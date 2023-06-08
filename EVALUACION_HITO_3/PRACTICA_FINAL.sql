-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 08-06-2023 a las 03:29:58
-- Versión del servidor: 10.4.27-MariaDB
-- Versión de PHP: 8.1.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `tarea_hito_4`
--

DELIMITER $$
--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `generar_serie_fibonacci` (`n` INT) RETURNS TEXT CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
    DECLARE fibonacci TEXT DEFAULT '0,1';
    DECLARE a INT DEFAULT 0;
    DECLARE b INT DEFAULT 1;
    DECLARE c INT;
    DECLARE i INT DEFAULT 2;

    WHILE i <= n DO
        SET c = a + b;
        SET fibonacci = CONCAT(fibonacci, ',', CAST(c AS CHAR));
        SET a = b;
        SET b = c;
        SET i = i + 1;
    END WHILE;

    RETURN fibonacci;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `suma_serie_fibonacci` (`fibonacci_str` TEXT) RETURNS INT(11)  BEGIN
    DECLARE sum INT DEFAULT 0;
    DECLARE value CHAR(10);
    DECLARE done INT DEFAULT 0;
    DECLARE fibonacci_cursor CURSOR FOR SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(fibonacci_str, ',', numbers.n), ',', -1)) AS value
        FROM (SELECT 1 + units.i + tens.i * 10 AS n
            FROM (SELECT 0 AS i UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) units
            CROSS JOIN (SELECT 0 AS i UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) tens
            ORDER BY n
        ) numbers
        WHERE numbers.n <= LENGTH(fibonacci_str) - LENGTH(REPLACE(fibonacci_str, ',', '')) + 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN fibonacci_cursor;

    fibonacci_loop: LOOP
        FETCH fibonacci_cursor INTO value;
        IF done = 1 THEN
            LEAVE fibonacci_loop;
        END IF;
        SET sum = sum + CAST(value AS INT);
    END LOOP;

    CLOSE fibonacci_cursor;

    RETURN sum;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `copia_persona`
--

CREATE TABLE `copia_persona` (
  `nombre` varchar(50) DEFAULT NULL,
  `apellidos` varchar(50) DEFAULT NULL,
  `fecha_nac` date DEFAULT NULL,
  `edad` int(11) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `id_dep` int(11) DEFAULT NULL,
  `id_prov` int(11) DEFAULT NULL,
  `sexo` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `departamento`
--

CREATE TABLE `departamento` (
  `id_dep` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `departamento`
--

INSERT INTO `departamento` (`id_dep`, `nombre`) VALUES
(1, 'La Paz'),
(2, 'Santa Cruz'),
(3, 'Chochabamba'),
(4, 'Oruro'),
(7, 'El Alto');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_proyecto`
--

CREATE TABLE `detalle_proyecto` (
  `id_dp` int(11) NOT NULL,
  `id_per` int(11) DEFAULT NULL,
  `id_proy` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detalle_proyecto`
--

INSERT INTO `detalle_proyecto` (`id_dp`, `id_per`, `id_proy`) VALUES
(1, 3, 1),
(2, 1, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `persona`
--

CREATE TABLE `persona` (
  `id_per` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `apellidos` varchar(50) DEFAULT NULL,
  `fecha_nac` date DEFAULT NULL,
  `edad` int(11) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `id_dep` int(11) DEFAULT NULL,
  `id_prov` int(11) DEFAULT NULL,
  `sexo` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `persona`
--

INSERT INTO `persona` (`id_per`, `nombre`, `apellidos`, `fecha_nac`, `edad`, `email`, `id_dep`, `id_prov`, `sexo`) VALUES
(1, 'Froilan ', 'Mamani Nina', '2003-07-12', 21, 'froimamani4@gmail.com', 1, 1, 'M'),
(2, 'Jose Luis ', 'Yanahuaya Mamani', '2004-05-12', 25, 'joseluis56@gmail.com', 3, 3, 'M'),
(3, 'Karen', 'Alizon Chuquimia', '2000-10-10', 64, 'karencita5454@gmail.com', 3, 3, 'F'),
(4, 'Miguel', 'Mamani Caiza', '2005-04-01', 17, 'tiomiguel@gmail.com', 2, 2, 'M');

--
-- Disparadores `persona`
--
DELIMITER $$
CREATE TRIGGER `calculaEdad` BEFORE INSERT ON `persona` FOR EACH ROW BEGIN
    DECLARE fecha_nac DATE;
    DECLARE edad INT;
    
    SET fecha_nac = NEW.fecha_nac;
    SET edad = YEAR(CURRENT_DATE) - YEAR(fecha_nac);
    
    IF DATE_FORMAT(CURRENT_DATE, '%m-%d') < DATE_FORMAT(fecha_nac, '%m-%d') THEN
        SET edad = edad - 1;
    END IF;
    
    SET NEW.edad = edad;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `copia_persona_trigger` BEFORE INSERT ON `persona` FOR EACH ROW BEGIN
  INSERT INTO copia_persona (nombre, apellidos, fecha_nac, edad, email, id_dep, id_prov, sexo)
  VALUES (NEW.nombre, NEW.apellidos, NEW.fecha_nac, NEW.edad, NEW.email, NEW.id_dep, NEW.id_prov, NEW.sexo);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `provincia`
--

CREATE TABLE `provincia` (
  `id_provincia` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `id_dep` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `provincia`
--

INSERT INTO `provincia` (`id_provincia`, `nombre`, `id_dep`) VALUES
(1, 'Murillo', 1),
(2, 'Andres Ibañez', 2),
(3, 'Sajama', 4),
(4, 'Sercado', 3),
(5, 'El Alto', 7);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proyecto`
--

CREATE TABLE `proyecto` (
  `id_proy` int(11) NOT NULL,
  `nombreProy` varchar(50) DEFAULT NULL,
  `tipoProy` varchar(50) DEFAULT NULL,
  `ESTADO` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `proyecto`
--

INSERT INTO `proyecto` (`id_proy`, `nombreProy`, `tipoProy`, `ESTADO`) VALUES
(1, 'A', 'alfa', 'INACTIVO'),
(2, 'B', 'gama', 'INACTIVO');

--
-- Disparadores `proyecto`
--
DELIMITER $$
CREATE TRIGGER `trg_proyecto_insert` BEFORE INSERT ON `proyecto` FOR EACH ROW BEGIN
    IF NEW.tipoProy IN ('EDUCACION', 'FORESTACION', 'CULTURA') THEN
        SET NEW.ESTADO = 'ACTIVO';
    ELSE
        SET NEW.ESTADO = 'INACTIVO';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_proyecto_update` BEFORE UPDATE ON `proyecto` FOR EACH ROW BEGIN
    IF NEW.tipoProy IN ('EDUCACION', 'FORESTACION', 'CULTURA') THEN
        SET NEW.ESTADO = 'ACTIVO';
    ELSE
        SET NEW.ESTADO = 'INACTIVO';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_persona_proyecto`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_persona_proyecto` (
`nombres_apellidos` varchar(101)
,`edad` int(11)
,`fecha_nac` date
,`nombre_proyecto` varchar(50)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_persona_proyecto_departamento`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_persona_proyecto_departamento` (
`nombres_apellidos` varchar(101)
,`edad` int(11)
,`fecha_nac` date
,`nombre_proyecto` varchar(50)
,`nombre_departamento` varchar(50)
,`nombre_provincia` varchar(50)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_persona_proyecto`
--
DROP TABLE IF EXISTS `vista_persona_proyecto`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_persona_proyecto`  AS SELECT concat(`p`.`nombre`,' ',`p`.`apellidos`) AS `nombres_apellidos`, `p`.`edad` AS `edad`, `p`.`fecha_nac` AS `fecha_nac`, `pr`.`nombreProy` AS `nombre_proyecto` FROM ((`persona` `p` join `detalle_proyecto` `dp` on(`dp`.`id_per` = `p`.`id_per`)) join `proyecto` `pr` on(`pr`.`id_proy` = `dp`.`id_proy`))  ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_persona_proyecto_departamento`
--
DROP TABLE IF EXISTS `vista_persona_proyecto_departamento`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_persona_proyecto_departamento`  AS SELECT concat(`p`.`nombre`,' ',`p`.`apellidos`) AS `nombres_apellidos`, `p`.`edad` AS `edad`, `p`.`fecha_nac` AS `fecha_nac`, `pr`.`nombreProy` AS `nombre_proyecto`, `d`.`nombre` AS `nombre_departamento`, `pv`.`nombre` AS `nombre_provincia` FROM ((((`persona` `p` join `detalle_proyecto` `dp` on(`p`.`id_per` = `dp`.`id_per`)) join `proyecto` `pr` on(`dp`.`id_proy` = `pr`.`id_proy`)) join `departamento` `d` on(`p`.`id_dep` = `d`.`id_dep`)) join `provincia` `pv` on(`p`.`id_prov` = `pv`.`id_provincia`))  ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `departamento`
--
ALTER TABLE `departamento`
  ADD PRIMARY KEY (`id_dep`);

--
-- Indices de la tabla `detalle_proyecto`
--
ALTER TABLE `detalle_proyecto`
  ADD PRIMARY KEY (`id_dp`),
  ADD KEY `id_per` (`id_per`),
  ADD KEY `id_proy` (`id_proy`);

--
-- Indices de la tabla `persona`
--
ALTER TABLE `persona`
  ADD PRIMARY KEY (`id_per`),
  ADD KEY `id_dep` (`id_dep`),
  ADD KEY `id_prov` (`id_prov`);

--
-- Indices de la tabla `provincia`
--
ALTER TABLE `provincia`
  ADD PRIMARY KEY (`id_provincia`),
  ADD KEY `id_dep` (`id_dep`);

--
-- Indices de la tabla `proyecto`
--
ALTER TABLE `proyecto`
  ADD PRIMARY KEY (`id_proy`);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `detalle_proyecto`
--
ALTER TABLE `detalle_proyecto`
  ADD CONSTRAINT `detalle_proyecto_ibfk_1` FOREIGN KEY (`id_per`) REFERENCES `persona` (`id_per`),
  ADD CONSTRAINT `detalle_proyecto_ibfk_2` FOREIGN KEY (`id_proy`) REFERENCES `proyecto` (`id_proy`);

--
-- Filtros para la tabla `persona`
--
ALTER TABLE `persona`
  ADD CONSTRAINT `persona_ibfk_1` FOREIGN KEY (`id_dep`) REFERENCES `departamento` (`id_dep`),
  ADD CONSTRAINT `persona_ibfk_2` FOREIGN KEY (`id_prov`) REFERENCES `provincia` (`id_provincia`);

--
-- Filtros para la tabla `provincia`
--
ALTER TABLE `provincia`
  ADD CONSTRAINT `provincia_ibfk_1` FOREIGN KEY (`id_dep`) REFERENCES `departamento` (`id_dep`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
