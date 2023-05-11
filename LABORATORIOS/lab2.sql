CREATE DATABASE bda_h3_II;
USE bda_h3_II;

SET @usu = 'Admin_12';
SET @int = 12;

SELECT @usu;
SELECT @int;

SET @Hito3 = 'ADMIN';

CREATE OR REPLACE FUNCTION  var_iable()
RETURNS VARCHAR(100)
BEGIN
    DECLARE caso_1 VARCHAR(100);
    IF(@Hito3 = 'ADMIN')THEN
    SET caso_1 = 'el usuario es un ADMIN';
    ELSE
        SET caso_1 = 'usuario invitado';END IF;
    RETURN caso_1;
end;
SELECT var_iable();


CREATE OR REPLACE FUNCTION  var_iable_2()
RETURNS TEXT
BEGIN
    DECLARE resp VARCHAR(100);
        CASE @H3
        WHEN'ADMIN' THEN SET resp = 'usu ADMIN';
        ELSE SET resp = 'usuario invitado';
        END CASE;
    RETURN resp;
end;
SET @H3 = 'ADMIN';
SELECT var_iable_2();



CREATE OR REPLACE FUNCTION numeros_natgurales(limite int)
    RETURNS TEXT
    BEGIN
        DECLARE cont INT DEFAULT 1;
        DECLARE resp TEXT DEFAULT '';
        WHILE cont <= limite DO
            SET resp= CONCAT(resp, cont,' ');
            SET cont = cont+ 1;
        END WHILE;
        RETURN  resp;
    END;
SELECT numeros_natgurales(13);

CREATE FUNCTION numeros_natgurales_V2(limite int)
    RETURNS TEXT
    BEGIN
        DECLARE cont INT DEFAULT 2;
        DECLARE resp TEXT DEFAULT '';
        WHILE cont <= limite DO
            SET resp= CONCAT(resp, cont,' ');
            SET cont = cont+ 2;
        END WHILE;
        RETURN  resp;
    END;
SELECT numeros_natgurales_V2(10);

#2,1,4,3,6,5,8,7
CREATE FUNCTION numeros_natgurales_V3(limite int)
    RETURNS TEXT
    BEGIN
        DECLARE resp TEXT DEFAULT '';
        DECLARE num1 INT;
        num1 = 0;
        WHILE num1 <= limite DO
             SET resp= CONCAT(resp, num1,' ');
             SET num1 = num1 -1;
             SET num1 = num1 + 3;
        end while;
            RETURN resp;
    END;


CREATE OR REPLACE FUNCTION numeros_natgurales(limite int)
    RETURNS TEXT
    BEGIN
        DECLARE cont DOUBLE DEFAULT 0;
        DECLARE resp TEXT DEFAULT '';
        WHILE cont <= limite DO
            SET resp= CONCAT(resp, cont,' ');
            SET cont = cont- 1;
            SET cont = cont+3;
        END WHILE;
        RETURN  resp;
    END;

SELECT numeros_natgurales(8);



CREATE  OR REPLACE FUNCTION bucle_while(x INT)
RETURNS TEXT
BEGIN
    DECLARE str TEXT DEFAULT ' ';
    REPEAT
        SET str = CONCAT(str,x,' ');
        SET x  = x - 1;
    UNTIL x <= 0 END REPEAT;
    RETURN str;
end;

SELECT  bucle_while(20);

CREATE OR REPLACE FUNCTION bucle_y_letra(x int)
RETURNS TEXT
BEGIN
   DECLARE str_1 TEXT DEFAULT '';
   REPEAT
       IF x% 2 = 0 THEN
           SET str_1 = CONCAT(str_1,x,'-AA-');
       ELSE
           SET str_1 = CONCAT(str_1,x,'-BB-');
       END IF;
   SET x = x + 1;
   until x <= 0 end repeat;
   RETURN str_1;
END;

SELECT bucle_y_letra(5);

#LOOP

CREATE OR REPLACE FUNCTION manejo_de_loop(leer_dato INT)
    RETURNS TEXT
BEGIN
    DECLARE str TEXT DEFAULT ' ';
    BDA_II:
    loop
        IF leer_dato >= 0 THEN
            LEAVE BDA_II;
        end if;
        IF leer_dato % 2 = 0 THEN
            SET str = CONCAT(str, leer_dato, '-AA-');
        ELSE
            SET str = CONCAT(str, leer_dato, '-BB-');
        END IF;
        SET leer_dato = leer_dato + 1;
    end loop;
    RETURN str;
END;

SELECT manejo_de_loop(-10);


CREATE FUNCTION ejercicio1(x INT)
RETURNS TEXT
BEGIN
    DECLARE cadena varchar(50);

IF x > 50000 THEN
  SET cadena = 'ES PLATINUM';
END IF;

IF x <= 10000 THEN
  SET CADENA = 'ES SILVER';END IF;

IF x >= 10000 AND x <= 50000 THEN
  SET CADENA = 'ES GOLD';END IF;
RETURN CADENA;
end;

SELECT ejercicio1(1000);


#Uso de charlenght
#el charlenght nos permite saber la cantidad de cuantos caracteres tiene una palabra
#BDAII = 5
#Select char.lenght('BDAII') =>5
SELECT char_length('Hola gente');

CREATE FUNCTION tamaño_name(pass TEXT)
RETURNS TEXT
BEGIN
    DECLARE result TEXT DEFAULT '';
    if char_length(pass) > 7 THEN
        SET result = 'PASSED';
        ELSE
        SET result = 'FAILED';
    end if;
    RETURN result;
END;

SELECT tamaño_name('a');


SELECT strcmp('aa','a');

CREATE FUNCTION cademas_repeat(cad_1 TEXT, cad_2 TEXT)
RETURNS TEXT
BEGIN
    declare a INT;
    SET a = (SELECT strcmp(cad_1, cad_2));
return a;
end;

CREATE FUNCTION cademas_repeatV2(cad_1 TEXT, cad_2 TEXT)
RETURNS TEXT
BEGIN
    declare a TEXT;
    IF strcmp(cad_1, cad_2) = 0 THEN
        SET a = 'Cadenas igaules';
        ELSE
        SET a = 'Cadenas No iguales';
    end if;
return a;
end;

SELECT cademas_repeatV2('a','a');

#En base a las 2 funciones anteriores recibir 2 cadenas


CREATE FUNCTION cademas_repeatV3(cad_1 TEXT, cad_2 TEXT)
RETURNS TEXT
BEGIN
    declare a TEXT;
    IF strcmp(cad_1, cad_2) = 0 AND CHAR_LENGTH(cad_1) AND CHAR_LENGTH(cad_2) = 15 THEN
        SET a = 'Cadenas igaules,y PASSED';
        ELSE
        SET a = 'Cadenas No iguales DENIED';
    end if;
return a;
end;

SELECT cademas_repeatV3('a123a12','a123a12')
