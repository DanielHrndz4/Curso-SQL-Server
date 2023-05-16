CREATE DATABASE TALLER02;
GO

CREATE TABLE PROYECTO (
    codigo INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    presupuesto MONEY NOT NULL DEFAULT '0',
    id_coordinador INT NOT NULL,
    PRIMARY KEY (codigo)
);
GO

CREATE TABLE EJECUCION (
    id INT NOT NULL,
    codigo_proyecto INT NOT NULL,
    id_municipio INT NOT NULL CHECK (id_municipio >=1 AND id_municipio <= 262),
    fecha_inicio DATE NOT NULL CHECK (fecha_inicio > CONVERT(DATE,'16/05/2023',103)),
    fecha_fin DATE NOT NULL,
    PRIMARY KEY (id)
);
GO

CREATE TABLE EMPLEADO (
    codigo INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    correo_electronico VARCHAR(80) NOT NULL UNIQUE,
    numero_isss CHAR(7) NULL CHECK (numero_isss LIKE '[1-9][1-9][0-9][0-9][0-9][0-9][0-9]'),
    id_categoria INT NOT NULL,
    PRIMARY KEY (codigo)
);
GO

CREATE TABLE OBJETIVO (
    id INT NOT NULL,
    titulo VARCHAR(100) NOT NULL,
    descripcion VARCHAR(100) NULL,
    id_proyecto INT NOT NULL,
    PRIMARY KEY (id)
);
GO

CREATE TABLE METRICA (
    id INT NOT NULL,
    titulo VARCHAR(100) NOT NULL,
    tipo_metrica BIT NOT NULL,
    fecha_cumplimiento DATE NULL,
    id_objetivo INT NOT NULL,
    id_empleado INT NULL,
    PRIMARY KEY (id)
);
GO

CREATE TABLE ASIGNACION (
    id_codigo_empleado INT NOT NULL,
    id_codigo_proyecto INT NOT NULL
);
GO

CREATE TABLE TELEFONO (
    id INT NOT NULL,
    numero INT NOT NULL,
    codigo_empleado INT NOT NULL,
    PRIMARY KEY (id)
);
GO

CREATE TABLE MUNICIPIO (
    id INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
);
GO

CREATE TABLE CATEGORIA (
    id INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
);
GO

ALTER TABLE PROYECTO ADD CONSTRAINT fk_codigo FOREIGN KEY (id_coordinador) REFERENCES EMPLEADO (codigo);
ALTER TABLE EJECUCION ADD CONSTRAINT fk_id_municipio FOREIGN KEY (id_municipio) REFERENCES MUNICIPIO (id);
ALTER TABLE EJECUCION ADD CONSTRAINT fk_codigo_proyecto FOREIGN KEY (codigo_proyecto) REFERENCES PROYECTO (codigo);
ALTER TABLE OBJETIVO ADD CONSTRAINT fk_id_proyecto FOREIGN KEY (id_proyecto) REFERENCES PROYECTO (codigo);
ALTER TABLE TELEFONO ADD CONSTRAINT fk_codigo_empleado FOREIGN KEY (codigo_empleado) REFERENCES EMPLEADO (codigo);
ALTER TABLE EMPLEADO ADD CONSTRAINT fk_id_categoria FOREIGN KEY (id_categoria) REFERENCES CATEGORIA (id);
ALTER TABLE METRICA ADD CONSTRAINT fk_id_objetivo FOREIGN KEY (id_objetivo) REFERENCES OBJETIVO (id);
ALTER TABLE METRICA ADD CONSTRAINT fk_id_empleado FOREIGN KEY (id_empleado) REFERENCES EMPLEADO (codigo);
ALTER TABLE ASIGNACION ADD CONSTRAINT pk_asignacion PRIMARY KEY (id_codigo_empleado,id_codigo_proyecto);
ALTER TABLE ASIGNACION ADD CONSTRAINT fk_id_codigo_empleado FOREIGN KEY (id_codigo_empleado) REFERENCES EMPLEADO (codigo);
ALTER TABLE ASIGNACION ADD CONSTRAINT fk_id_codigo_proyecto FOREIGN KEY (id_codigo_proyecto) REFERENCES PROYECTO (codigo);

INSERT INTO CATEGORIA (id,nombre,descripcion)
    VALUES (1,'JUNIOR','JUNIOR');
INSERT INTO EMPLEADO (codigo,nombre,correo_electronico,numero_isss,id_categoria)
    VALUES (1234,'DAVID','alguien@alguien.com',1267543,1);
INSERT INTO TELEFONO (id,numero,codigo_empleado)
    VALUES (1,12345678,1234);
INSERT INTO PROYECTO (codigo,nombre,presupuesto,id_coordinador) 
    VALUES (1,'DANIEL HERNANDEZ',100,1234);
INSERT INTO ASIGNACION (id_codigo_empleado,id_codigo_proyecto)
    VALUES (1234,1);
INSERT INTO MUNICIPIO (id,nombre)
    VALUES (1,'ANT CUSCATRLAN'),(2,'NUEVO CUSCATLAN'),(3,'LOURDES');
INSERT INTO EJECUCION (id,codigo_proyecto,id_municipio,fecha_inicio,fecha_fin)
    VALUES (1,1,3,CONVERT(DATE, '17/05/2023', 103),CONVERT(DATE, '16/06/2023', 103));
INSERT INTO OBJETIVO (id,titulo,descripcion,id_proyecto)
    VALUES (1,'BASE DE DATOS','TALLER BASE DE DATOS',1);
INSERT INTO METRICA (id,titulo,tipo_metrica,fecha_cumplimiento,id_objetivo,id_empleado)
    VALUES (1,'METRICA',1,CONVERT(DATE, '16/06/2023',103),1,1234);
