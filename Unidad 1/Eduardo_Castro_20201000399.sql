--Ejercicio 1
SET SERVEROUTPUT ON;
DECLARE
    CURSOR C1(sMenor number, sMayor number) IS SELECT * FROM PRODUCTOS WHERE ;
BEGIN
    FOR i in C1() LOOP
      DBMS_OUTPUT.PUT_LINE('Codigo: '|| i.COD_PRODUCTO || 'Producto: ' || i.NOMBRE_PRODUCTO || 'PVP: ' || i.PVP);   
    END LOOP;
    
END;

--Ejercicio 2

CREATE OR REPLACE PACKAGE UTILS
IS
	PROCEDURE ACTUALIZAR_PRODUCTO(Codigo PRODUCTOS.COD_PRODUCTO%TYPE, Nombre PRODUCTOS.NOMBRE_PRODUCTO%TYPE);
	FUNCTION NUM_PRODUCTO (Criterio number) RETURN number;
  FUNCTION CALCULAR_IMPUESTO(Codigo FACTURAS.COD_FACTURA%TYPE) RETURN NUMBER;

END;

CREATE OR REPLACE PACKAGE BODY UTILS
IS 
-- FUNCION PRiVADA
FUNCTION VALIDAR_NOMBRE(Nombre PRODUCTOS.NOMBRE_PRODUCTO%TYPE)
RETURN BOOLEAN
IS
  CURSOR C1 IS SELECT * FROM PRODUCTOS;
  VN boolean;
BEGIN
  FOR i in C1 LOOP
    IF i.NOMBRE_PRODUCTO = Nombre THEN
      VN:=TRUE;
    ELSE
      VN:=FALSE;
    END IF;
  END LOOP;
  RETURN VN;
END VALIDAR_NOMBRE;
---- FUNCION
FUNCTION NUM_PRODUCTO(Criterio number)
RETURN number
IS
  P_PVP number:=0;
BEGIN
  SELECT COUNT(PVP) INTO P_PVP FROM PRODUCTOS WHERE PVP <= Criterio;
	RETURN P_PVP;
END NUM_PRODUCTO;
---- PROCEDIMIENTO ALMACENADO

PROCEDURE ACTUALIZAR_PRODUCTO (Codigo PRODUCTOS.COD_PRODUCTO%TYPE, Nombre PRODUCTOS.NOMBRE_PRODUCTO%TYPE)
IS
BEGIN
   VALIDAR_NOMBRE(Nombre);
  IF VALIDAR_NOMBRE(Nombre) = true THEN
    DBMS_OUTPUT.PUT_LINE('No fue posible actualizar el registro');
  ELSE
      UPDATE PRODUCTOS SET NOMBRE_PRODUCTO = Nombre WHERE COD_PRODUCTO=Codigo;
  END IF;
END ACTUALIZAR_PRODUCTO;

---- FUNCION
FUNCTION CALCULAR_IMPUESTO(Codigo FACTURAS.COD_FACTURA%TYPE)
RETURN number
IS
  CURSOR C1 IS SELECT * FROM LINEAS_FACTURA WHERE COD_FACTURA = Codigo;
  TotalImp number:=0;
  --ImpProd number:=0;
BEGIN
    FOR i in C1 LOOP
      TotalImp:=TotalImp + (i.PVP*i.UNIDADES*0.15);
    /*  ImpProd:=i.PVP*i.UNIDADES*0.15;
      DBMS_OUTPUT.PUT_LINE('Impuesto Producto: '|| ImpProd);   */
    END LOOP;
    RETURN TotalImp;
END CALCULAR_IMPUESTO;

END UTILS;

-- BLOQUE ANONIMO
SET SERVOUTPUT ON
DECLARE
	V1 number;
  V2 number;
BEGIN
/*Llama a la funcion del paquete*/
	V1:= UTILS.NUM_PRODUCTO(5);
	DBMS_OUTPUT.PUT_LINE('Numero de Productos: ' || V1);
  V2:= UTILS.CALCULAR_IMPUESTO(1);
  DBMS_OUTPUT.PUT_LINE('Total De Impuestos: ' || V2);
END;

--EJERCICIO 3
SET SERVEROUTPUT ON;
DECLARE
    CURSOR C1 IS SELECT * FROM PRODUCTOS;
BEGIN
    FOR i in C1
    LOOP
      IF i.PVP > 20 THEN
        DBMS_OUTPUT.PUT_LINE('Producto: '|| i.NOMBRE_PRODUCTO || ' INVENTARIO SUFICIENTE');
      ELSIF i.PVP > 6 THEN
        DBMS_OUTPUT.PUT_LINE('Producto: '|| i.NOMBRE_PRODUCTO || ' INVENTARIO BAJO');
      ELSIF i.PVP >= 4 AND  i.PVP <= 5 THEN
        DBMS_OUTPUT.PUT_LINE('Producto: '|| i.NOMBRE_PRODUCTO || ' INVENTARIO DEBE SER REABASTECIDO');
      ELSIF i.PVP <= 3 THEN
        DBMS_OUTPUT.PUT_LINE('Producto: '|| i.NOMBRE_PRODUCTO || ' INVENTARIO INSUFICIENTE');
    END IF;
    END LOOP;
END;

--Ejercicio 4
SET SERVEROUTPUT ON;
DECLARE
    CURSOR C1 IS SELECT * FROM FACTURAS;
BEGIN
  FOR i in C1 LOOP
    IF i.FECHA = '08-OCT-22' THEN
    INSERT INTO CONTROL_LOG
    (COD_EMPLEADO,FECHA,TABLA,COD_OPERACION)
    VALUES 
    (USER,SYSDATE,'FACTURAS','INSERT');
    DBMS_OUTPUT.PUT_LINE('REGISTRO INSERTADO');
    END IF;
  END LOOP;
END;