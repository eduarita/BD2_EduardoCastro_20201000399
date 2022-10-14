SET SERVEROUTPUT ON;
--Ejercicio #1
-- INCISO A
DECLARE
    CURSOR NS IS SELECT * FROM EMPLOYEES;
    EMP EMPLOYEES%ROWTYPE;
    EmpNom varchar2(100);
BEGIN
    OPEN NS;
    LOOP
        FETCH NS INTO EMP;
        EXIT WHEN NS%NOTFOUND;
        EmpNom:= EMP.FIRST_NAME || ' ' || EMP.LAST_NAME;
        If EmpNom='Peter Tucker' THEN
        RAISE_APPLICATION_ERROR(-20001,'No se puede ver el sueldo del jefe');
        Else 
        DBMS_OUTPUT.PUT_LINE('NOMBRE: '|| EmpNom || ' SUELDO: '|| EMP.SALARY);   
        END IF;
    END LOOP;
    CLOSE NS;
END;

-- INCISO B
SET SERVEROUTPUT ON;
DECLARE
    CURSOR C1 (Depid EMPLOYEES.DEPARTMENT_ID%TYPE) IS SELECT * FROM EMPLOYEES WHERE Depid = EMPLOYEES.DEPARTMENT_ID;
    NumEmp number:=0;
BEGIN
    FOR i in C1(100) LOOP
    NumEmp := NumEmp + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Numero de empleados: '|| NumEmp);   
END;

-- INCISO C
SET SERVEROUTPUT ON;
DECLARE
    CURSOR C1 IS SELECT * FROM EMPLOYEES;
    emp EMPLOYEES%ROWTYPE;
    Nsalario number;
BEGIN
    FOR emp in C1 LOOP
    IF emp.salary > 8000  THEN
        Nsalario:= emp.Salary +(emp.Salary*0.02);
    ELSIF emp.salary < 8000 THEN
        Nsalario:= emp.Salary +(emp.Salary*0.03);
    END IF;
        DBMS_OUTPUT.PUT_LINE('Nombre: '|| emp.FIRST_NAME||' '|| emp.LAST_NAME ||' Salario Actual: '|| emp.Salary || ' Nuevo Salario: '|| Nsalario);   
    END LOOP;
END;

-- Ejercicio #2
CREATE OR REPLACE FUNCTION CREAR_REGION(Nombre IN REGIONS.REGION_NAME%TYPE) RETURN number
IS
    Cod REGIONS.REGION_ID%TYPE:=0;
BEGIN
    SELECT MAX(REGION_ID) INTO Cod FROM REGIONS;
    Cod:=Cod + 1;
    --Cod:=SELECT MAX(REGION_ID) FROM REGION;
    INSERT INTO REGIONS(REGION_ID,REGION_NAME)VALUES(Cod,Nombre);
    RETURN Cod;
END;

SET SERVEROUTPUT ON;
DECLARE 
    A varchar2(100):='Oceania';
    B number;
BEGIN
    B:=CREAR_REGION(A);
    DBMS_OUTPUT.PUT_LINE('Codigo: ' || B);
END;

-- Ejercicio #3
--INCISO A
CREATE OR REPLACE PROCEDURE Calculadora 
(num1 IN number, num2 IN number, ope IN varchar2, res OUT number) 
IS
    DIV_ZERO EXCEPTION;
BEGIN
	CASE ope
		WHEN 'SUMA' THEN 
            res:= num1+num2;
            DBMS_OUTPUT.PUT_LINE(num1||' + '||num2||' = '||res);
		WHEN 'RESTA' THEN 
            res:= num1-num2;
            DBMS_OUTPUT.PUT_LINE(num1||' - '||num2||' = '||res);
        WHEN 'MULTIPLICACION' THEN 
            res:= num1*num2;
            DBMS_OUTPUT.PUT_LINE(num1||' * '||num2||' = '||res);
        WHEN 'DIVISION' THEN 
        IF num2 = 0 THEN
            RAISE DIV_ZERO;
        ELSE
            res:= num1/num2;
            DBMS_OUTPUT.PUT_LINE(num1||' / '||num2||' = '||res);
        END IF;
        
		ELSE DBMS_OUTPUT.PUT_LINE('Inserte una operacion valida o verifique si esta bien escrito');
	END CASE;
    EXCEPTION
        WHEN DIV_ZERO THEN
        DBMS_OUTPUT.PUT_LINE('No se puede dividir entre 0');
END;

SET SERVEROUTPUT ON;
DECLARE
    A number:=2;
    B number:=2;
    C varchar(20):='DIVISION';
    D number:=0;
BEGIN
    Calculadora(A,B,C,D);
END;

-- INCISO B
CREATE TABLE EMPLOYEES_COPIA
(   EMPLOYEE_ID NUMBER (6,0) PRIMARY KEY,
    FIRST_NAME VARCHAR2(20 BYTE),
    LAST_NAME VARCHAR2(25 BYTE),
    EMAIL VARCHAR2(25 BYTE),
    PHONE_NUMBER VARCHAR2(20 BYTE),
    HIRE_DATE DATE,
    JOB_ID VARCHAR2(10 BYTE),
    SALARY NUMBER(8,2),
    COMMISSION_PCT NUMBER(2,2),
    MANAGER_ID NUMBER(6,0),
    DEPARTMENT_ID NUMBER(4,0)
);

CREATE OR REPLACE PROCEDURE RELLENAR
IS
    CURSOR C1 IS SELECT * FROM EMPLOYEES;
BEGIN
    for i IN C1 LOOP 
    INSERT INTO EMPLOYEES_COPIA(EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
    VALUES (i.EMPLOYEE_ID, i.FIRST_NAME, i.LAST_NAME, i.EMAIL, i.PHONE_NUMBER, i.HIRE_DATE, i.JOB_ID, i.SALARY, i.COMMISSION_PCT, i.MANAGER_ID, i.DEPARTMENT_ID);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('CARGA FINALIZADA');
END;

EXECUTE RELLENAR;