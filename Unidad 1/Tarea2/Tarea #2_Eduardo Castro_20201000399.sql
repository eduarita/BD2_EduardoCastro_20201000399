/*  Tarea 2
    Eduardo Josué Castro Arita - 20201000399
    
    - Ejecutar individualmente los ejercicios
*/


SET SERVEROUTPUT ON;

--Ejercicio 1
DECLARE
    name varchar2(50);
    lastname1 varchar2(50);
    lastname2 varchar2(50);
    res varchar2(150);
    
BEGIN
    name:='alberto';
    lastname1:='pérez';
    lastname2:='García';
    
    name:=SUBSTR(UPPER(name),0,1);
    lastname1:=SUBSTR(UPPER(lastname1),0,1);
    lastname2:=SUBSTR(UPPER(lastname2),0,1);
    
    res:=(name || '.' || lastname1 || '.' || lastname2);
    DBMS_OUTPUT.put_line (res);
END;

--Ejercicio 2
DECLARE
    Numero number;
    resultado number;
BEGIN
    Numero:=12;
    resultado:= MOD(Numero,2);
    
    IF resultado = 0 THEN
       DBMS_OUTPUT.put_line ('PAR');
    ELSE
        DBMS_OUTPUT.put_line ('IMPAR');
    END IF;
    
END;

--Ejercicio 3
DECLARE
    
    IdDep DEPARTMENTS.DEPARTMENT_ID%TYPE:= 100;
    salario_maximo number;
BEGIN
    SELECT MAX(MAX_SALARY) INTO salario_maximo FROM JOBS 
    INNER JOIN EMPLOYEES ON EMPLOYEES.JOB_ID = JOBS.JOB_ID
    WHERE EMPLOYEES.DEPARTMENT_ID = IdDep;
    DBMS_OUTPUT.put_line('Salario maximo del Departamento: ' || salario_maximo);
END;

--Ejercicio 4
DECLARE 
   NombreDep DEPARTMENTS.DEPARTMENT_NAME%TYPE;
   IdDep DEPARTMENTS.DEPARTMENT_ID%TYPE:= 10;
   Numempleado number;

BEGIN
    SELECT DEPARTMENT_NAME INTO NombreDep FROM DEPARTMENTS WHERE DEPARTMENT_ID = IdDep;
    SELECT COUNT(*) INTO Numempleado FROM EMPLOYEES WHERE DEPARTMENT_ID = IdDep ;
    DBMS_OUTPUT.put_line('Nombre del Departamento: ' || NombreDep);
    DBMS_OUTPUT.put_line('Numero de Empleados: ' || NumEmpleado);
END;

--Ejercicio 5
DECLARE 
    Salario_max number;
    Salario_min number;
BEGIN
    SELECT MAX(MAX_SALARY) INTO Salario_max FROM JOBS;
    SELECT MIN(MIN_SALARY) INTO Salario_min FROM JOBS;
    DBMS_OUTPUT.put_line('El salario maximo de la empresa es: ' || Salario_max);
    DBMS_OUTPUT.put_line('El salario minimo de la empresa es: ' || Salario_min);
    DBMS_OUTPUT.put_line('La diferencia es de: ' || (Salario_max - Salario_min));
END;
