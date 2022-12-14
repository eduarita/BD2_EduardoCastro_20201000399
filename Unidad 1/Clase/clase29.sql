  CREATE OR REPLACE PROCEDURE PR1
IS 
   X NUMBER:=10;
BEGIN
   DBMS_OUTPUT.PUT_LINE(X);
END;


SET SERVEROUTPUT ON
BEGIN
   PR1;
END;

EXECUTE PR1;




--USER_OBJECTS
SELECT * FROM USER_OBJECTS 
WHERE OBJECT_TYPE='PROCEDURE';

SELECT OBJECT_TYPE,COUNT(*) FROM USER_OBJECTS
GROUP BY OBJECT_TYPE;

SELECT * FROM USER_SOURCE
WHERE NAME='PR1';

SELECT TEXT FROM USER_SOURCE
WHERE NAME='PR1';
 




/*Las variables se pasan por lectura y no se pueden modificar */
CREATE OR REPLACE PROCEDURE CALC_TAX 
(EMPL IN EMPLOYEES.EMPLOYEE_ID%TYPE,
    T1 IN NUMBER)
IS
  TAX NUMBER:=0;
  SAL NUMBER:=0;
BEGIN
   IF T1 <0 OR T1 > 60 THEN 
      RAISE_APPLICATION_ERROR(-20000,'EL PORCENTAJE DEBE ESTAR ENTRE 0 Y 60');
    END IF;
   SELECT SALARY INTO SAL FROM EMPLOYEES    WHERE EMPLOYEE_ID=EMPL;
   TAX:=SAL*T1/100;
   DBMS_OUTPUT.PUT_line('SALARY:'||SAL);
   DBMS_OUTPUT.PUT_line('TAX:'||TAX);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_line('NO EXISTE EL EMPLEADO');
END;
/

set serveroutput on
DECLARE
  A NUMBER;
  B NUMBER;
begin
  A:=120;
  B:=5;
  calc_tax(A,B);
end;
/

CREATE OR REPLACE PROCEDURE CALC_TAX_OUT 
(EMPL IN EMPLOYEES.EMPLOYEE_ID%TYPE,
    T1 IN NUMBER,
    R1 OUT NUMBER)
IS
  SAL NUMBER:=0;
BEGIN
   IF T1 <0 OR T1 > 60 THEN 
      RAISE_APPLICATION_ERROR(-20000,'EL PORCENTAJE DEBE ESTAR ENTRE 0 Y 60');
    END IF;
   SELECT SALARY INTO SAL FROM EMPLOYEES    WHERE EMPLOYEE_ID=EMPL;
   R1:=SAL*T1/100;
   DBMS_OUTPUT.PUT_line('SALARY:'||SAL);
   DBMS_OUTPUT.PUT_line('TAX:'||R1);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_line('NO EXISTE EL EMPLEADO');
END;
/



set serveroutput on
DECLARE
  A NUMBER;
  B NUMBER;
  R NUMBER;
begin
  A:=120;
  B:=10;
  R:=0;
  DBMS_OUTPUT.PUT_LINE('R1='||R);
 CALC_TAX_OUT(A,B,R);
 DBMS_OUTPUT.PUT_LINE('R2='||R);
end;
/

CREATE OR REPLACE PROCEDURE CALC_TAX_OUT_IN 
(EMPL IN EMPLOYEES.EMPLOYEE_ID%TYPE,
    T1 IN OUT NUMBER)
IS
  SAL NUMBER:=0;
BEGIN
   IF T1 <0 OR T1 > 60 THEN 
      RAISE_APPLICATION_ERROR(-20000,'EL PORCENTAJE DEBE ESTAR ENTRE 0 Y 60');
    END IF;
   SELECT SALARY INTO SAL FROM EMPLOYEES    WHERE EMPLOYEE_ID=EMPL;

   DBMS_OUTPUT.PUT_line('t1:'||T1);

   T1:=SAL*T1/100;
   DBMS_OUTPUT.PUT_line('SALARY:'||T1);
   
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_line('NO EXISTE EL EMPLEADO');
END;
/




set serveroutput on
DECLARE
  A NUMBER;
  B NUMBER;
  R NUMBER;
begin
  A:=120;
  B:=10;
  CALC_TAX_OUT_IN(A,B);
 DBMS_OUTPUT.PUT_LINE('B='||B);
end;
/




-- Crear un procedimiento que visualice el nombre y salario de los empleados 


CREATE OR REPLACE PROCEDURE visualizar IS
CURSOR C1 IS SELECT first_name,salary FROM EMPLOYEES;
v_nombre employees.first_name%TYPE;
v_salario employees.salary%TYPE;
BEGIN
FOR i IN C1 LOOP
DBMS_OUTPUT.PUT_LINE(i.first_name || ' ' || i.salary);
END LOOP;
END;
/
EXECUTE visualizar;








CREATE OR REPLACE FUNCTION CALC_TAX_F
    (EMPL IN EMPLOYEES.EMPLOYEE_ID%TYPE,
      T1 IN NUMBER)
RETURN NUMBER
IS
  TAX NUMBER:=0;
  SAL NUMBER:=0;
BEGIN
   IF T1 <0 OR T1 > 60 THEN 
      RAISE_APPLICATION_ERROR(-20000,'EL PORCENTAJE DEBE ESTAR ENTRE 0 Y 60');
    END IF;
   SELECT SALARY INTO SAL FROM EMPLOYEES WHERE EMPLOYEE_ID=EMPL;
   TAX:=SAL*T1/100;
   RETURN TAX;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
       DBMS_OUTPUT.PUT_line('NO EXISTE EL EMPLEADO');
END;


set serveroutput on
DECLARE
  A NUMBER;
  B NUMBER;
  R NUMBER;
begin
  A:=120;
  B:=10;
  R:=CALC_TAX_F(A,B);
 DBMS_OUTPUT.PUT_LINE('R='||R);
end;
