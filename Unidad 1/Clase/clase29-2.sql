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

 /* Crear una función que tenga como parámetro un número de
departamento y que devuelve la suma de los salarios de dicho
departamento. La imprimimos por pantalla.

Si el departamento no existe debemos generar una excepción
con dicho mensaje
Si el departamento existe, pero no hay empleados dentro,
también debemos generar una excepción para indicarlo */


CREATE OR REPLACE FUNCTION salarios_dept (
    dep NUMBER
) RETURN NUMBER IS
    salary    NUMBER;
    depart    departments.department_id%TYPE;
    num_emple NUMBER;
BEGIN
    SELECT
        department_id
    INTO depart
    FROM
        departments
    WHERE
        department_id = dep;

    SELECT
        COUNT(*)
    INTO num_emple
    FROM
        employees
    WHERE
        department_id = dep;

    IF dep > 0 THEN
        SELECT
            SUM(salary)
        INTO salary
        FROM
            employees
        WHERE
            department_id = dep
        GROUP BY
            department_id;

    ELSE
        raise_application_error(-20730, 'El departamento existe, pero no hay empleados ' || dep);
    END IF;

    RETURN salary;
EXCEPTION
    WHEN no_data_found THEN
        raise_application_error(-20730, 'No existe el departamento ' || dep);
END;




SET SERVEROUTPUT ON
DECLARE
    sal  NUMBER;
    dept NUMBER := 20;
BEGIN
    sal := salarios_dept(dept);
    dbms_output.put_line('El salario total del departamento '
                         || dept
                         || ' es: '
                         || sal);
END;



/* PAQUETES */
-- Crear un encabezado de paquete

CREATE OR REPLACE PACKAGE PACK1
IS
  V1 NUMBER:=100;
  V2 VARCHAR2(100);
END;
/


BEGIN
  PACK1.V1:=PACK1.V1+10;
  DBMS_OUTPUT.PUT_LINE(PACK1.V1);
END;


/*CREAR BODY PAQUETE*/



CREATE OR REPLACE PACKAGE PACK1
IS
  PROCEDURE CONVERTIR_CADENA (NAME VARCHAR2, tipo_conversion CHAR);
END;
/


CREATE OR REPLACE PACKAGE BODY PACK1
IS
FUNCTION UP(NAME VARCHAR2)
RETURN VARCHAR2 
IS
BEGIN
    RETURN UPPER(NAME);
END UP;

FUNCTION DO(NAME VARCHAR2)
RETURN VARCHAR2 
IS
BEGIN
    RETURN LOWER(NAME);
END DO;

PROCEDURE CONVERTIR_CADENA (NAME VARCHAR2, tipo_conversion CHAR)
 IS
 BEGIN
    IF tipo_conversion='MAY' THEN
       DBMS_OUTPUT.PUT_LINE(UP(NAME));
    ELSIF tipo_conversion='MIN' THEN
       DBMS_OUTPUT.PUT_LINE(DO(NAME));
    ELSE
       DBMS_OUTPUT.PUT_LINE('EL PARAMETRO DEBE SER MAY o MIN');
   END IF;
END CONVERTIR_CADENA;

END PACK1;



SET SERVEROUTPUT ON
BEGIN
 PACK1.CONVERTIR_CADENA('AAAAA','MIN');
 
END;


/*Agregar Funcion**/


CREATE OR REPLACE PACKAGE PACK1
IS
  PROCEDURE CONVERTIR_CADENA (NAME VARCHAR2, tipo_conversion CHAR);
  FUNCTION FN_CONVERTIR (NAME VARCHAR2, tipo_conversion CHAR) RETURN VARCHAR2 ;
END;
/


CREATE OR REPLACE PACKAGE BODY PACK1
IS
FUNCTION UP(NAME VARCHAR2)
RETURN VARCHAR2 
IS
BEGIN
    RETURN UPPER(NAME);
END UP;

FUNCTION DO(NAME VARCHAR2)
RETURN VARCHAR2 
IS
BEGIN
    RETURN LOWER(NAME);
END DO;

PROCEDURE CONVERTIR_CADENA (NAME VARCHAR2, tipo_conversion CHAR)
 IS
 BEGIN
    IF tipo_conversion='MAY' THEN
       DBMS_OUTPUT.PUT_LINE(UP(NAME));
    ELSIF tipo_conversion='MIN' THEN
       DBMS_OUTPUT.PUT_LINE(DO(NAME));
    ELSE
       DBMS_OUTPUT.PUT_LINE('EL PARAMETRO DEBE SER MAY o MIN');
   END IF;
END CONVERTIR_CADENA;

FUNCTION FN_CONVERTIR (NAME VARCHAR2, tipo_conversion CHAR) return VARCHAR2
 IS
 BEGIN
    IF tipo_conversion='MAY' THEN
       return(UP(NAME));
    ELSIF tipo_conversion='MIN' THEN
       return(DO(NAME));
    ELSE
       DBMS_OUTPUT.PUT_LINE('EL PARAMETRO DEBE SER MAY o MIN');
   END IF;
END FN_CONVERTIR;


END PACK1;


SET SERVEROUTPUT ON
DECLARE
  V1 VARCHAR2(100);
BEGIN
 V1:=PACK1.FN_CONVERTIR('AAAAA','MIN');
 DBMS_OUTPUT.PUT_LINE(V1);
END;



SELECT
    first_name,PACK1.FN_CONVERTIR(FIRST_NAME,'MIN'),PACK1.FN_CONVERTIR(LAST_NAME,'MIN')
FROM
    employees;


/* Sobrecarga */

CREATE OR REPLACE 
PACKAGE PACK2 AS 

  
  FUNCTION COUNT_EMPLOYEES(ID NUMBER) RETURN NUMBER;
  FUNCTION COUNT_EMPLOYEES(ID VARCHAR2) RETURN NUMBER;
END PACK2;
/
CREATE OR REPLACE
PACKAGE BODY PACK2 AS

  FUNCTION COUNT_EMPLOYEES(ID NUMBER) RETURN NUMBER AS
  X NUMBER;
  BEGIN
    SELECT COUNT(*) INTO X FROM EMPLOYEES WHERE DEPARTMENT_ID=ID;
    RETURN X;
  END COUNT_EMPLOYEES;

  FUNCTION COUNT_EMPLOYEES(ID VARCHAR2) RETURN NUMBER AS
  X NUMBER;
  BEGIN
    SELECT COUNT(*) INTO X FROM EMPLOYEES A, DEPARTMENTS B
         WHERE DEPARTMENT_NAME=ID
         AND A.DEPARTMENT_ID=B.DEPARTMENT_ID;
       
    RETURN X;
  END COUNT_EMPLOYEES;

END PACK2;



BEGIN
  DBMS_OUTPUT.PUT_LINE(PACK2.COUNT_EMPLOYEES('Marketing'));
END;
