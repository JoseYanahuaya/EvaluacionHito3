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
