SET SERVEROUTPUT ON
-- Ejercicio 1
CREATE OR REPLACE TRIGGER TR_Employees
BEFORE DELETE ON EMPLOYEES
FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN  
    IF :OLD.JOB_ID LIKE '%CLERK%' THEN
        raise_application_error(-20001,'No se puede eliminar dicho registro');
    ELSE
        dbms_output.put_line( 'Se eliminaron los registros con exito');
    END IF;
END;

DELETE FROM EMPLOYEES WHERE JOB_ID = 'ST_CLERK';

-- Ejercicio 2
CREATE OR REPLACE TRIGGER TR_Departments
BEFORE INSERT ON DEPARTMENTS
FOR EACH ROW
BEGIN
    IF :NEW.DEPARTMENT_ID = :OLD.DEPARTMENT_ID  THEN
        raise_application_error(-20005,'El codigo del departamento ya existe');
    END IF;
    IF :NEW.LOCATION_ID IS NULL THEN
        :NEW.LOCATION_ID:= 1700;
    END IF;
    IF :NEW.MANAGER_ID IS NULL THEN
        :NEW.MANAGER_ID:= 200;
    END IF;
END;

INSERT INTO DEPARTMENTS VALUES(1,'Telecomunicaciones',NULL,NULL);

/* Ejercicio 3
    Predicado Condicionales y Trigger */
CREATE TABLE EMPLEADOS
(
    CODIGO INT NOT NULL PRIMARY KEY,
    NOMBRE VARCHAR2(20),
    SALARIO DECIMAL(10,2)
);

CREATE TABLE LOG_SALARIO
(
    codigo INT,
    salario_anterior DECIMAL(10,2),
    salario_actual DECIMAL(10,2),
    fecha DATE,
    usuario VARCHAR2(20),
    operacion varchar2(20)
);

CREATE OR REPLACE TRIGGER TR_EMPLEADOS
BEFORE INSERT OR UPDATE OR DELETE ON EMPLEADOS
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO LOG_SALARIO(salario_anterior,salario_actual,operacion) VALUES(1, :NEW.SALARIO, 'Insercion');
    END IF;
    IF UPDATING THEN
        INSERT INTO LOG_SALARIO(salario_anterior,salario_actual,operacion) VALUES(:OLD.SALARIO, :NEW.SALARIO, 'Actualizacion');
    END IF;
     IF DELETING THEN
        INSERT INTO LOG_SALARIO(salario_anterior,salario_actual,operacion) VALUES(:OLD.SALARIO, 1, 'Eliminacion');
    END IF;
END;

INSERT INTO empleados VALUES(1,'Roberto',200);
UPDATE empleados SET salario = 400 WHERE codigo = 1;
DELETE empleados WHERE codigo = 1;