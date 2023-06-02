--****************************************************
-- Bases de datos: Introducci�n a SQL
-- Autor: Daniel Hernandez
-- Tema: Restricci�n de llave for�nea
--****************************************************
DROP TABLE hotel;
DROP TABLE habitacion;

-- Ejercicio 1
-- 1.0 Crear tablas HOTEL y HABITACION, luego definir la llave for�nea que relaciona a ambas tablas
CREATE TABLE HOTEL (
	id INT PRIMARY KEY IDENTITY,
	nombre VARCHAR(50) NOT NULL,
	direccion VARCHAR(100) NULL DEFAULT 'Direcci�n no definida',
	telefono CHAR(12) NOT NULL UNIQUE CHECK (telefono LIKE '+503[2|6|7][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);

CREATE TABLE HABITACION(
	id INT PRIMARY KEY,
	numero INT NOT NULL CHECK (numero > 0),
	precio MONEY NOT NULL,
	id_hotel INT NOT NULL
);
GO

-- 1.0.1 Creando llave for�nea
ALTER TABLE habitacion ADD CONSTRAINT fk_hotel_habitacion
	FOREIGN KEY (id_hotel) REFERENCES HOTEL (id);


-- 1.1 Insertar una habitaci�n en la tabla HABITACION y observar el resultado:
INSERT INTO HABITACION (id, numero, precio, id_hotel)
	VALUES(1, 101, 99.99,1);

-- Esta instrucci�n falla, raz�n: 
-- El campo id_hotel no puede ser NULL; pero el valor no puede contener un valor que no existe en la tabla Hotel

-- 1.2 Insertar datos en la tabla HOTEL, luego intentar insertar en la tabla HABITACION
INSERT INTO HOTEL (nombre, direccion, telefono)
	VALUES ('Real Intercontinental', 'San Salvador', '+50324234992');
INSERT INTO HOTEL (nombre, telefono)
	VALUES ('Crowne Plaza', '+50325008446');
INSERT INTO HOTEL (nombre, telefono)
	VALUES ('Quality Hotel Real Aeropuerto', '+50375008447'); 
SELECT * FROM HOTEL;

-- 1.2.2 Insertando datos en habitaci�n
INSERT INTO HABITACION(id, numero, precio, id_hotel) 
	VALUES (1, 101, 130.99, 1); 
INSERT INTO HABITACION(id, numero, precio, id_hotel) 
	VALUES (2, 102, 159.00, 1); 
INSERT INTO HABITACION(id, numero, precio, id_hotel) 
	VALUES (3, 102, 99.99, 3); 
SELECT * FROM HABITACION;
SELECT * FROM hotel;

-- 1.3 Eliminar el hotel con id = 2, luego, eliminar el hotel con id = 3
DELETE FROM hotel WHERE id = 2;
DELETE FROM hotel WHERE id = 3;
DELETE FROM hotel WHERE id = 1;

-- 1.3.1 Eliminar las habitaci�n con id_hotel = 3;
DELETE FROM HABITACION Where id_hotel = 3;
SELECT * FROM HABITACION;
DELETE FROM hotel WHERE id = 3 ;

-- 1.3.1.2 Opcional: configurando el id_hotel como columna que acepta nulos
ALTER TABLE habitacion ALTER COLUMN id_hotel INT NULL;
DELETE FROM hotel WHERE id = 1;
-- Insertando habitacion con id_hotel = NULL (rompe la consistencia de la base de datos)
INSERT INTO HABITACION(id, numero, precio, id_hotel) 
	VALUES (4, 102, 99.99, NULL); 
SELECT * FROM HABITACION;
DELETE FROM HABITACION WHERE id_hotel IS NULL;

-- 1.3.3 Eliminando tablas HOTEL y HABITACION
-- NOTA: �Ahora el orden de eliminaci�n de las tablas importa!
DROP TABLE HABITACION;
DROP TABLE hotel;


-- 1.4 Crear las tablas HOTEL y HABITACION, y definir la llave for�nea incluyendo la acci�n referencial conveniente
CREATE TABLE HOTEL (
	id INT PRIMARY KEY IDENTITY,
	nombre VARCHAR(50) NOT NULL,
	direccion VARCHAR(100) NULL DEFAULT 'Direcci�n no definida',
	telefono CHAR(12) NOT NULL UNIQUE CHECK (telefono LIKE '+503[2|6|7][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);

CREATE TABLE HABITACION(
	id INT PRIMARY KEY,
	numero INT NOT NULL CHECK (numero > 0),
	precio MONEY NOT NULL,
	id_hotel INT NOT NULL
);
GO

-- 1.4.1 Creando llave for�nea
ALTER TABLE habitacion ADD CONSTRAINT fk_hotel_habitacion
	FOREIGN KEY (id_hotel) REFERENCES HOTEL (id)
	ON DELETE CASCADE
	ON UPDATE CASCADE;


-- 1.4.2 Insertar datos en la tabla HOTEL y HABITACION
INSERT INTO HOTEL (nombre, direccion, telefono)
	VALUES ('Real Intercontinental', 'San Salvador', '+50324234992');
INSERT INTO HOTEL (nombre, telefono)
	VALUES ('Crowne Plaza', '+50325008446');
INSERT INTO HOTEL (nombre, telefono)
	VALUES ('Quality Hotel Real Aeropuerto', '+50375008447'); 
SELECT * FROM HOTEL;

INSERT INTO HABITACION(id, numero, precio, id_hotel) 
	VALUES (1, 101, 130.99, 1); 
INSERT INTO HABITACION(id, numero, precio, id_hotel) 
	VALUES (2, 102, 159.00, 1); 
INSERT INTO HABITACION(id, numero, precio, id_hotel) 
	VALUES (3, 102, 99.99, 3); 

-- 1.4.3 Eliminar el hotel con id = 1 y observar el resultado en las tablas HOTEL Y HABITACION
DELETE FROM HOTEL WHERE id = 1;

-- 1.4.4 Eliminar la tabla HOTEL y observa el resultado
SELECT * FROM HOTEL;
SELECT * FROM HABITACION;

-- NOTA: la accion referencial solo aplica para la eliminaci�n y actualizaci�n de datos no de tablas
-- Para poder eliminar la tabla hotel, es necesario:
-- Opci�n 1: Eliminar la llave for�nea
-- Opci�n 2: Eliminar la tabla HABITACION

ALTER TABLE HABITACION DROP CONSTRAINT fk_hotel_habitacion;
DROP TABLE HOTEL;
DROP TABLE HABITACION;

-- Ejercicio 2:
CREATE TABLE HOTEL (
	id INT PRIMARY KEY IDENTITY,
	nombre VARCHAR(50) NOT NULL,
	direccion VARCHAR(100) NULL DEFAULT 'Direcci�n no definida',
	telefono CHAR(12) NOT NULL UNIQUE CHECK (telefono LIKE '+503[2|6|7][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	id_hotel_representante INT NULL
);

ALTER TABLE HOTEL ADD CONSTRAINT fk_hotel_hotel_representante 
	FOREIGN KEY (id_hotel_representante) REFERENCES HOTEL (id);

CREATE TABLE HABITACION(
	id INT PRIMARY KEY,
	numero INT NOT NULL CHECK (numero > 0),
	precio MONEY NOT NULL,
	id_hotel INT NOT NULL
);

ALTER TABLE HABITACION ADD CONSTRAINT fk_hotel_habitacion
	FOREIGN KEY (id_hotel) REFERENCES HOTEL (id);

CREATE TABLE COMENTARIO(
	id INT PRIMARY KEY,
	id_cliente INT NOT NULL,
	id_hotel INT NOT NULL,
	comentario VARCHAR(128) NULL,
	calificacion INT NOT NULL CHECK (calificacion BETWEEN 1 AND 5)
);

ALTER TABLE COMENTARIO ADD CONSTRAINT fk_hotel_comentario
	FOREIGN KEY (id_hotel) REFERENCES HOTEL (id);
ALTER TABLE COMENTARIO ADD CONSTRAINT fk_cliente_comentario
	FOREIGN KEY (id_cliente) REFERENCES CLIENTE (id);

CREATE TABLE CLIENTE(
	id INT PRIMARY KEY,
	nombre VARCHAR(64) NOT NULL,
	documento VARCHAR(32) NOT NULL
);

CREATE TABLE RESERVA (
	id INT PRIMARY KEY,
	checkin DATETIME NOT NULL,
	checkout DATETIME NOT NULL,
	id_cliente INT NOT NULL,
	id_habitacion INT NOT NULL
);

ALTER TABLE RESERVA ADD CONSTRAINT fk_cliente_reserva
	FOREIGN KEY (id_cliente) REFERENCES CLIENTE (id);
ALTER TABLE RESERVA ADD CONSTRAINT fk_habitacion_reserva
	FOREIGN KEY (id_habitacion) REFERENCES HABITACION (id);


CREATE TABLE EXTRA (
	id_reserva INT NOT NULL,
	id_servicio INT NOT NULL
);
ALTER TABLE EXTRA ADD CONSTRAINT pk_extra PRIMARY KEY(id_reserva, id_servicio);
ALTER TABLE EXTRA ADD CONSTRAINT fk_servicio_extra
	FOREIGN KEY (id_servicio) REFERENCES SERVICIO (id);
ALTER TABLE EXTRA ADD CONSTRAINT fk_reserva_extra
	FOREIGN KEY (id_reserva) REFERENCES RESERVA (id);

CREATE TABLE SERVICIO(
	id INT PRIMARY KEY,
	nombre VARCHAR(64) NOT NULL,
	precio MONEY NOT NULL,
	descripcion VARCHAR(128) NULL 
);

