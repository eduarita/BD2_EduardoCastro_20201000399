DECLARE
  CURSOR C1 IS SELECT * FROM REGIONS;
  V1 REGIONS%ROWTYPE;
BEGIN
  OPEN C1;
  FETCH C1 INTO  V1;
  DBMS_OUTPUT.PUT_LINE(V1.REGION_NAME);
  FETCH C1 INTO  V1;
  DBMS_OUTPUT.PUT_LINE(V1.REGION_NAME);
  CLOSE C1;
END; 

--Atributos

DECLARE
  CURSOR C1 IS SELECT * FROM REGIONS;
  V1 REGIONS%ROWTYPE;
BEGIN
  OPEN C1;
  LOOP
      FETCH C1 INTO  V1;
      EXIT WHEN C1%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(V1.REGION_NAME);
  END LOOP;
  CLOSE C1;
  ----------------------
  ---BUCLE FOR
  FOR i IN C1 LOOP
    DBMS_OUTPUT.PUT_LINE(i.REGION_NAME);
  END LOOP;
END;

BEGIN
  FOR i IN (SELECT * FROM REGIONS) LOOP
    DBMS_OUTPUT.PUT_LINE(i.REGION_NAME);
  END LOOP;
END;

/
DECLARE
  CURSOR C1(SAL number) IS SELECT * FROM employees
  where SALARY> SAL;
  empl EMPLOYEES%ROWTYPE;
BEGIN
  FOR i IN C1(10000) LOOP
    DBMS_OUTPUT.PUT_LINE(i.FIRST_NAME || '-' || i.SALARY);
  END LOOP;

END;


DECLARE
 empl employees%rowtype;
  CURSOR cur IS SELECT * FROM employees FOR UPDATE;
BEGIN
  OPEN cur;
  LOOP
    FETCH cur INTO empl;
    EXIT   WHEN cur%notfound;
    IF EMPL.COMMISSION_PCT IS NOT NULL THEN
       UPDATE employees SET SALARY=SALARY*1.10 WHERE CURRENT OF cur;
    ELSE
        UPDATE employees SET SALARY=SALARY*1.15 WHERE CURRENT OF cur;
    END IF;
  END LOOP;
 
  CLOSE cur;
END;




