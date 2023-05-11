create database evaluacion_h3_2023;
use evaluacion_h3_2023;



CREATE TABLE estudiantes(
  nombres VARCHAR(50) NOT NULL ,
  apellidos VARCHAR(50) NOT NULL ,
  edad INT NOT NULL ,
  fono INT NOT NULL ,
  email VARCHAR(100) NOT NULL ,
  direccion VARCHAR(100) NOT NULL ,
  sexo VARCHAR(50) NOT NULL ,
  id_est INT PRIMARY KEY AUTO_INCREMENT NOT NULL
);

CREATE TABLE materias(

    nombre_mat VARCHAR(100)NOT NULL ,
    cod_mat VARCHAR(100)NOT NULL ,
    id_mat int PRIMARY KEY AUTO_INCREMENT NOT NULL
);

CREATE TABLE inscripcion(
    semestre VARCHAR(20)NOT NULL ,
    gestion int NOT NULL ,
    id_est int NOT NULL ,
    id_mat int NOT NULL ,
    id_ins INT NOT NULL  PRIMARY KEY AUTO_INCREMENT,
    FOREIGN KEY (id_est) REFERENCES estudiantes(id_est),
    FOREIGN KEY (id_mat) REFERENCES materias(id_mat)
);

INSERT INTO estudiantes(nombres, apellidos, edad, fono, email, direccion, sexo)
VALUES ('Miguel','Gonzales Veliz',20,2832115,'miguel@gmail.com','Av. 6 de Agosto','masculino'),
       ('Sandre','Mavir Uria',22,2832116,'sandra@gmail.com','Av. 6 de Agosto','femenino'),
       ('Joel','Adubiri Mondar',30,2832117,'joel@gmail.com','Av. 6 de Agosto','masculino'),
       ('Andrea','Arias Ballesteros',21,2832118,'andres@gmail.com','Av. 6 de Agosto','femenino'),
       ('Santos','Montes Valenzuela',24,2832119,'santos@gmail.com','Av. 6 de Agosto','masculino');


INSERT INTO materias(nombre_mat, cod_mat)
VALUES ('Introduccion a la Arquitectura','ARQ-101'),
       ('Urbanismo y diseño','ARQ-102'),
       ('Dibujo y pintura Arquitectonico','ARQ-103'),
       ('Matematica Discreta','ARQ-104'),
       ('Fisica basica','ARQ-105');


CREATE OR REPLACE FUNCTION fibonachi(n1 INT)
RETURNS TEXT
BEGIN

    DECLARE n2,n3,n4 INT DEFAULT 1;
    DECLARE resp TEXT DEFAULT '';
    DECLARE cont INT DEFAULT 0;

    WHILE n1 > cont DO
        SET resp = CONCAT(resp,n4,', ');
        SET n4 = n2 + n3;
        SET n2 = n3;
        SET n3 = n4;
        SET cont = cont + 1;
    END WHILE;
    RETURN resp;
END;

SELECT fibonachi(5);


SET @limit = 7;
SELECT @limit;

CREATE OR REPLACE FUNCTION fibonachi_global()
RETURNS TEXT
BEGIN

    DECLARE n2,n3,n4 INT DEFAULT 1;
    DECLARE resp TEXT DEFAULT '';
    DECLARE cont INT DEFAULT 0;

    WHILE @limit > cont DO
        SET resp = CONCAT(resp,n4,', ');
        SET n4 = n2 + n3;
        SET n2 = n3;
        SET n3 = n4;
        SET cont = cont + 1;
    END WHILE;
    RETURN resp;
END;

SELECT fibonachi_global();


CREATE FUNCTION min_edad()
RETURNS INT
BEGIN

    DECLARE n1 INT DEFAULT 0;

    SELECT MIN(est.edad)
        FROM estudiantes est into n1;
        RETURN n1;
    END;

SELECT edad_min();



CREATE OR REPLACE FUNCTION pares_e_Impares()
RETURNS TEXT
BEGIN
    DECLARE n1 INT DEFAULT edad_min();
    DECLARE func_val INT DEFAULT edad_min();
    DECLARE cad_con TEXT DEFAULT '';
    DECLARE cont INT DEFAULT 0;

    REPEAT
        IF n1 % 2 = 0 THEN
            SET cad_con = CONCAT(cad_con,cont,',');
            SET cont = cont + 2;
        ELSE
            SET cad_con = CONCAT(cad_con,func_val,',');
            SET func_val = func_val - 2;
            SET cont = cont + 2;
        END IF;
    UNTIL cont > n1 END REPEAT;
    RETURN cad_con;
END;

SELECT pares_e_Impares();




CREATE OR REPLACE FUNCTION consonanates_vol(cadena TEXT)
RETURNS TEXT
BEGIN

    DECLARE A_,
        E_,
        I_,
        O_,
        U_ INT DEFAULT 0;
    DECLARE b_1 INT DEFAULT 1;
    DECLARE cad, resp TEXT DEFAULT '';

    WHILE b_1 <= char_length(cadena) DO

        SET cad = substring(cadena, b_1, 1);
        IF cad = 'a' THEN
            SET A_ = A_+1;
        end if;
        IF cad = 'e' THEN
            SET E_ = E_+1;
        end if;
        IF cad = 'i' THEN
            SET I_ = I_+1;
        end if;
        IF cad = 'o' THEN
            SET O_ = O_+1;
        end if;
        IF cad = 'u' THEN
            SET U_ = U_+1;
        end if;
        SET b_1 = b_1+1;
    end while;

    set resp = concat('a: ', A_, ', e: ', E_, ', i: ', I_,', o: ', O_, ', u: ', U_);
    return resp;

end;

select consonanates_vol('Bienbenidos al curso de BDA II');




CREATE OR REPLACE FUNCTION when_case(n1 INT)
RETURNS TEXT
BEGIN

    DECLARE resp TEXT DEFAULT '';

    CASE
        WHEN n1 > 50000 THEN
            SET resp = 'USER PLATINIUM';

        WHEN n1 >= 10000 AND n1 <= 50000 THEN
            SET resp =  'USER GOLD';

        WHEN n1 < 10000 THEN
            SET resp = 'USER SILVER';

    END CASE;

    return resp;
end;


SELECT when_case(23145);



CREATE OR REPLACE FUNCTION eliminar_vocales(texto1 TEXT)
RETURNS TEXT
BEGIN
    DECLARE cad TEXT DEFAULT '';
    DECLARE n1 INT DEFAULT 1;
    DECLARE cont CHAR;

    WHILE n1 <= CHAR_LENGTH(texto1) DO
        SET cont = SUBSTR(texto1,n1,1);
        CASE cont
            WHEN 'a' THEN SET cad = cad;
            WHEN 'e' THEN SET cad = cad;
            WHEN 'i' THEN SET cad = cad;
            WHEN 'o' THEN SET cad = cad;
            WHEN 'u' THEN SET cad = cad;
            WHEN ' ' THEN SET  cad = CONCAT(cad,' ');
            ELSE SET  cad = CONCAT(cad,cont);
        END CASE;
        SET n1 = n1 + 1;
        END WHILE;
    RETURN cad;
END;

SELECT eliminar_vocales('Curso BDA II-2023');
