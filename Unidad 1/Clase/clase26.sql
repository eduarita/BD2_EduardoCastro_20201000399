SET SERVEROUTPUT ON

DECLARE
    empl   employees%rowtype;
BEGIN
    SELECT
        *
    INTO
        empl
    FROM
        employees
    WHERE
        employee_id > 1;

    dbms_output.put_line(empl.first_name);
EXCEPTION
    WHEN ex1 THEN
        NULL;
    WHEN ex2 THEN
        NULL;
    WHEN OTHERS THEN
        NULL;
END;
/

--Excepciones predefinidas

SET SERVEROUTPUT ON

DECLARE
    empl employees%rowtype;
BEGIN
    SELECT
        *
    INTO empl
    FROM
        employees
    WHERE
        employee_id > 1;

    dbms_output.put_line(empl.first_name);
EXCEPTION
-- NO_DATA_FOUND   ORA-01403
-- TOO_MANY_ROWS
-- ZERO_DIVIDE
-- DUP_VAL_ON_INDEX
    WHEN no_data_found THEN
        dbms_output.put_line('ERROR, EMPLEADO INEXISTENTE');
    WHEN too_many_rows THEN
        dbms_output.put_line('ERROR, DEMASIADOS EMPLEADO');
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR INDEFINIDO');
END;
/


SET SERVEROUTPUT ON
DECLARE
   MI_EXCEP EXCEPTION;
   PRAGMA EXCEPTION_INIT(MI_EXCEP,-937);
   V1 NUMBER;
   V2 NUMBER;
BEGIN
    SELECT EMPLOYEE_ID,SUM(SALARY) INTO V1,V2 FROM EMPLOYEES; 
    DBMS_OUTPUT.PUT_LINE(V1);
EXCEPTION
   WHEN MI_EXCEP THEN 
       DBMS_OUTPUT.PUT_LINE('FUNCION DE GRUPO INCORRECTA');
   WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR INDEFINIDO');
END;


CREATE TABLE ERRORS  
    ( codigo      NUMBER   
                     CONSTRAINT errors_code_nn NOT NULL 
    
    , mensaje    VARCHAR2(256)   
    )



SET SERVEROUTPUT ON
DECLARE
   EMPL EMPLOYEES%ROWTYPE;
   CODE NUMBER;
   MESSAGE VARCHAR2(100);
BEGIN
   SELECT * INTO EMPL FROM EMPLOYEES;
    DBMS_OUTPUT.PUT_LINE(EMPL.SALARY);
EXCEPTION   
   WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLCODE);
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        CODE:=SQLCODE;
        MESSAGE:=SQLERRM;
        INSERT INTO ERRORS VALUES (CODE,MESSAGE);
        COMMIT;
END;

SELECT * FROM ERRORS;


/

SET SERVEROUTPUT ON
DECLARE
  REG REGIONS%ROWTYPE;
  REG_CONTROL REGIONS.REGION_ID%TYPE;
BEGIN
   REG.REGION_ID:=5;
   REG.REGION_NAME:='Africa';
   SELECT REGION_ID INTO REG_CONTROL FROM REGIONS
   WHERE REGION_ID=REG.REGION_ID;
   DBMS_OUTPUT.PUT_LINE('LA REGION YA EXISTE');
EXCEPTION   
   WHEN NO_DATA_FOUND  THEN
        INSERT INTO REGIONS VALUES (REG.REGION_ID,REG.REGION_NAME);
        COMMIT;
END;

/

DECLARE
   reg_max EXCEPTION;
   regn NUMBER;
   regt varchar2(200);
BEGIN
   regn:=101;
   regt:='ASIA';
   IF regn > 100 THEN
         RAISE reg_max;  
    ELSE
       insert into regions values (regn,regt);
       commit;
      END IF;
EXCEPTION
  WHEN reg_max THEN  
    DBMS_OUTPUT.PUT_LINE('La region no puede ser mayor de 100.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error indefinido');
END;
/

DECLARE   
   regn NUMBER;
   regt varchar2(200);
BEGIN
   regn:=101;
   regt:='ASIA';
   iF regn > 100 THEN
       -- EL CODIGO DEBE ESTAR ENTRE -20000 Y -20999
       RAISE_APPLICATION_ERROR(-20001,'LA ID NO PUEDE SER MAYOR DE 100');  
    ELSE
       insert into regions values (regn,regt);
       commit;
    END IF;
END;

