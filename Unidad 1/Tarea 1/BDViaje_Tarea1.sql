CREATE DATABASE DBVIAJE;

USE DBVIAJE;

CREATE TABLE Hotel(
	Codigo		int,
    Nombre		varchar(50),
    Direccion	varchar(150),
	CONSTRAINT PK_Hotel PRIMARY KEY (Codigo, Nombre)	
);

CREATE TABLE Cliente(
	Identidad	varchar(30),
    Nombre		varchar(50),
    Telefono	varchar(10),
	CONSTRAINT PK_Cliente PRIMARY KEY (Identidad)	
);

CREATE TABLE Reserva(
	Codigo 		int,
    Identidad	varchar(30),
    fechain		date,
    fechaout	date,
    cantidad_personas	int default 0,
	CONSTRAINT PK_Reserva PRIMARY KEY (Codigo,Identidad),
    CONSTRAINT PK_Reserva_Hotel FOREIGN KEY (Codigo) REFERENCES Hotel(Codigo),	
	CONSTRAINT PK_Reserva_Cli FOREIGN KEY (Identidad) REFERENCES Cliente(Identidad)
);

CREATE TABLE Boleto(
	CodigoBoleto	varchar(10),
    Identidad	varchar(30),
    CodigoAerolinea	varchar(10),
   	No_vuelo	varchar(25),
    Fecha		date,
    Destino		varchar(25),
    CONSTRAINT PK_Boleto PRIMARY KEY (CodigoBoleto, No_vuelo),	
	CONSTRAINT CHK_Boleto CHECK (Destino = "México" OR Destino = "Guatemala" OR Destino = "Panamá" )	
);

CREATE TABLE Aerolinea(
	Codigo		varchar(10),
   	Descuento	int,
    
    CONSTRAINT PK_Aerolinea PRIMARY KEY (Codigo),	
	CONSTRAINT CHK_Aerolinea CHECK (Descuento >= 10)	
);

ALTER TABLE Boleto ADD CONSTRAINT PK_Boleto_Aero FOREIGN KEY (CodigoAerolinea) REFERENCES Aerolinea(Codigo);	
ALTER TABLE Boleto ADD CONSTRAINT PK_Boleto_Cli FOREIGN KEY (Identidad) REFERENCES Cliente(Identidad);

INSERT INTO Hotel (Codigo, Nombre, Direccion) VALUES (101,"Live Aqua Urban Resort","Av. Paseo de los Tamarindos No. 98, 05120 Ciudad de México");
INSERT INTO Hotel (Codigo, Nombre, Direccion) VALUES (101,"Meraki Boutique","13 Calle 3-57, Zona 10, Ciudad de Guatemala");

INSERT INTO Cliente (Identidad, Nombre, Telefono) VALUES ("0840556674","Walter Godoy", "88746846");
INSERT INTO Cliente (Identidad, Nombre, Telefono) VALUES ("0886423734","Carlos Flores", "88465461");

INSERT INTO Aerolinea (Codigo, Descuento) VALUES ("AA", 10);
INSERT INTO Aerolinea (Codigo, Descuento) VALUES ("CO", 12);
INSERT INTO Aerolinea (Codigo, Descuento) VALUES ("DL", 15);

INSERT INTO Reserva(Codigo, Identidad, Fechain, Fechaout, Cantidad_personas) VALUES(101,"0840556674","2022-10-19","2022-10-29", 2);
INSERT INTO Reserva(Codigo, Identidad, Fechain, Fechaout, Cantidad_personas) VALUES(101,"0886423734","2022-9-25","2022-9-30", 4);

INSERT INTO Boleto (CodigoBoleto, Identidad, CodigoAerolinea, No_vuelo, Fecha, Destino) 
VALUES ("57E","0840556674", "AA", "MEX012", "2022-10-18","México");
INSERT INTO Boleto (CodigoBoleto, Identidad, CodigoAerolinea, No_vuelo, Fecha, Destino) 
VALUES ("28A","0886423734", "CO", "GUA012", "2022-10-18","Guatemala");

SELECT * FROM Hotel;
SELECT * FROM Boleto;
SELECT * FROM Cliente;
SELECT * FROM Aerolinea;
SELECT * FROM Reserva;
SELECT * FROM Boleto;