--****************************************************
-- Bases de datos: Triggers
-- Autor: Erick Varela
-- Correspondencia: evarela@uca.edu.sv
-- Version: 1.0
--****************************************************

-- Sintaxis básica de un trigger
/*
	CREATE OR ALTER TRIGGER trigger_name
	ON TABLA
	AFTER [INSERT|DELETE|UPDATE]
	AS BEGIN
		-- Cuerpo del trigger
	END;
*/

CREATE OR ALTER TRIGGER trigger_ejemplo
ON CLIENTE
AFTER INSERT 
AS BEGIN	
	PRINT 'Se ha insertado un nuevo cliente';
END;

SELECT * FROM CLIENTE;
INSERT INTO CLIENTE VALUES(51, 'Daniel', 'U26375757', 12, 3, 0)

/* 1. Crear un trigger que permita verificar que cada vez
que se incluya una reserva, se evalue el estado VIP
del cliente que ha reservado. Puede suceder alguno de los
siguientes casos:
	- Clientes regulares:
		- Que el cliente mantega el estado de cliente regular
		- Que el cliente obtenga el estado VIP
	- Clientes VIP:
		- Que el cliente mantenga su estado VIP
		- Que el cliente pierda su estado VIP

Utilizar como base la siguiente consulta:*/
SELECT CASE 
	WHEN EXISTS (
		SELECT CLIENTE_TOTAL_RESERVA.id, CLIENTE_TOTAL_RESERVA.nombre, ROUND(AVG(CLIENTE_TOTAL_RESERVA.Reserva),2) 'promedio'
		FROM (
			SELECT C.id, C.nombre, 
					H.precio * DATEDIFF (DAY,R.checkin,R.checkout) + 
					ISNULL(SUM(S.precio),0)*DATEDIFF (DAY,R.checkin,R.checkout) 'Reserva'
			FROM HABITACION H
				INNER JOIN RESERVA R
					ON H.id = R.id_habitacion
				INNER JOIN CLIENTE C
					ON C.id = R.id_cliente_reserva
				LEFT JOIN EXTRA X 
					ON R.id = X.id_reserva
				LEFT JOIN SERVICIO S
					ON S.id = X.id_servicio
			GROUP BY R.id, R.checkin, R.checkout, H.precio, C.id, C.nombre, 
					DATEDIFF (DAY,R.checkin,R.checkout),
						H.precio * DATEDIFF (DAY,R.checkin,R.checkout)
		) CLIENTE_TOTAL_RESERVA
		WHERE CLIENTE_TOTAL_RESERVA.id = 2
		GROUP BY CLIENTE_TOTAL_RESERVA.id, CLIENTE_TOTAL_RESERVA.nombre
		HAVING AVG(CLIENTE_TOTAL_RESERVA.Reserva) >= 550.00
	) THEN
		1
	ELSE 
		0
	END;

/*==================================================================================*/

DROP FUNCTION IS_VIP;
CREATE OR ALTER FUNCTION IS_VIP (@id_cliente INT)
RETURNS BIT
AS BEGIN
	DECLARE @vip BIT;
	SET @vip = 0;
	SELECT @vip = CASE 
			WHEN EXISTS (
					SELECT CLIENTE_TOTAL_RESERVA.id
						FROM (
							SELECT C.id, C.nombre, 
									H.precio * DATEDIFF (DAY,R.checkin,R.checkout) + 
									ISNULL(SUM(S.precio),0)*DATEDIFF (DAY,R.checkin,R.checkout) 'Reserva'
							FROM HABITACION H
								INNER JOIN RESERVA R
									ON H.id = R.id_habitacion
								INNER JOIN CLIENTE C
									ON C.id = R.id_cliente_reserva
								LEFT JOIN EXTRA X 
									ON R.id = X.id_reserva
								LEFT JOIN SERVICIO S
									ON S.id = X.id_servicio
							GROUP BY R.id, R.checkin, R.checkout, H.precio, C.id, C.nombre, 
									DATEDIFF (DAY,R.checkin,R.checkout),
										H.precio * DATEDIFF (DAY,R.checkin,R.checkout)
						) CLIENTE_TOTAL_RESERVA
						WHERE CLIENTE_TOTAL_RESERVA.id = @id_cliente
						GROUP BY CLIENTE_TOTAL_RESERVA.id, CLIENTE_TOTAL_RESERVA.nombre
						HAVING AVG(CLIENTE_TOTAL_RESERVA.Reserva) >= 550.00		
				) THEN
					CAST(1 AS bit)
				ELSE 
					CAST(0 AS bit)
				END;
	RETURN @vip;
END;

SELECT dbo.IS_VIP(2);
SELECT dbo.IS_VIP(3);

/*==================================================================================*/
--INSERTED ==> GUARDA DATOS INSETADOS, GUARDA DATOS DESPUES DE ACTUALIZAR
--DELETED ==> GUARDA DATOS ELIMINADOS, GUARDA DATOS ANTES DE ACTUALIZAR

CREATE OR ALTER TRIGGER CHECK_VIP_DEL
ON RESERVA
AFTER INSERT
AS BEGIN
	DECLARE @vip BIT;
	DECLARE @id_cliente INT; 

	SELECT @id_cliente = id_cliente_reserva FROM inserted; 

	SELECT @vip = dbo.IS_VIP(@id_cliente);
	IF @vip = 0 
		UPDATE CLIENTE SET vip = 0 WHERE id = @id_cliente;
	ELSE
		UPDATE CLIENTE SET vip = 1 WHERE id = @id_cliente;
END;

DROP TRIGGER CHECK_VIP;

DELETE FROM RESERVA WHERE id > 200;

SELECT * FROM RESERVA;

INSERT INTO RESERVA 
	VALUES(201, CONVERT (DATETIME, '01-05-2023 15:00:00', 103), 
	CONVERT (DATETIME, '02-05-2023 15:00:00', 103), 1, 23, 24);

SELECT * FROM CLIENTE WHERE id = 5;


-- 2.	Crear un procedimiento almacenado que permita registrar nuevas reservas
--		Como argumentos se reciben: el la fecha de checkin y checkout, el id del cliente
--		y el id de la habitacion.
--		NOTA: Validar que la nueva reserva no se solape con otras reservas

CREATE OR ALTER PROCEDURE BOOKING 
	@id INT,
	@checkin VARCHAR(12),
	@checkout VARCHAR(12),
	@id_metodo_pago INT,
	@id_cliente INT,
	@id_habitacion INT
AS
BEGIN
	BEGIN TRY
		INSERT INTO RESERVA VALUES(@id,CONVERT(DATE, @checkin, 103),CONVERT(DATE, @checkout, 103),@id_metodo_pago,@id_cliente,@id_habitacion);		
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE();
	END CATCH;
END;

-- INSERTANDO RESERVA QUE SE SOLAPE CON LA RESERVA 69
SELECT * FROM RESERVA
INSERT INTO RESERVA 
	VALUES(201, CONVERT (DATETIME, '19-05-2023 15:00:00', 103), 
	CONVERT (DATETIME, '22-05-2023 15:00:00', 103), 1, 23, 24);

CREATE OR ALTER TRIGGER CHECK_BOOKING
ON RESERVA
AFTER INSERT
AS BEGIN
		--declarando variables
		DECLARE @checkin DATETIME;
		DECLARE @checkout DATETIME;
		DECLARE @id_habitacion INT;
		DECLARE @resultado INT;
		--obteniendo datos desde tabla inserted
		SELECT @id_habitacion=i.id_habitacion, @checkin=i.checkin, @checkout=i.checkout FROM inserted i;
		SELECT @resultado = COUNT(*) FROM RESERVA 
		WHERE 
			((@checkin < checkin AND (@checkout BETWEEN checkin AND checkout)) OR
			((@checkin BETWEEN checkin AND checkout) AND @checkout > checkout) OR
			(@checkin >= checkin AND @checkout <= checkout) OR
			(checkin >= @checkin AND checkout <= @checkout)) AND
			id_habitacion = @id_habitacion;
	IF @resultado > 1
	BEGIN 
		RAISERROR ('ERROR: Consulta invalida, la habitacion ya ha sido reservada en la fecha establecida...' ,11,1)
		ROLLBACK TRANSACTION -- ELIMINA EL ULTIMO CAMBIO ATOMICO QUE SE A REALIZADO
	END;
END;

-- Ejecutando procedimiento almacenado


-- 1.2.	Crear una tabla llamada "REGISTRO_PUNTOS_S#", el objetivo de esta tabla será funcionar
--		como registro de los intercambios de puntos de cliente frecuente que realizan los
--		clientes. La tabla debe almacenar: la fecha y hora de la transaccion, el id y nombre del
--		usuario involucrado, la cantidad de puntos antes y despues de la transacción y una 
--		descriptión breve del proceso realizado.


CREATE TABLE REGISTRO_PUNTOS(
	id INT PRIMARY KEY IDENTITY,
	fecha DATETIME,
	id_cliente INT,
	nombre_cliente VARCHAR(50),
	puntos_ini INT,
	puntos_fin INT,
	descripcion VARCHAR(100)
);

CREATE OR ALTER PROCEDURE TRANSFERIR_PUNTOS
    @id_emisor INT,
    @id_receptor INT,
    @puntos INT
AS BEGIN
    -- Validando si los puntos del cliente emisor son suficiente para realizar la transfencia
    DECLARE @puntos_cliente_emisor INT;
    SELECT @puntos_cliente_emisor = puntos FROM CLIENTE WHERE id = @id_emisor;
    IF @puntos_cliente_emisor < @puntos 
        BEGIN
            PRINT 'ERROR: El cliente no tiene suficientes puntos para ser transferidos :(';
        END
    ELSE   
        BEGIN
            BEGIN TRY 
                BEGIN TRANSACTION TRANSFERENCIA_DE_PUNTOS
                -- Restando puntos al emisor
                UPDATE CLIENTE SET puntos = puntos - @puntos 
                    WHERE id = @id_emisor;
                -- Sumando puntos al receptor
                UPDATE CLIENTE SET puntos = puntos + @puntos 
                    WHERE id = @id_receptor;
                COMMIT TRANSACTION TRANSFERENCIA_DE_PUNTOS
            END TRY
            BEGIN CATCH
                DECLARE @ERROR_MESSAGE VARCHAR(100);
                SELECT @ERROR_MESSAGE = ERROR_MESSAGE();
                PRINT 'ERROR OCURRIDO: '+ @ERROR_MESSAGE;
                ROLLBACK TRANSACTION TRANSFERENCIA_DE_PUNTOS
            END CATCH; 
        END; 
END;


CREATE OR ALTER TRIGGER CHECK_POINTS
ON CLIENTE
AFTER UPDATE
AS BEGIN
	-- Seccion de declaracion de variables
	DECLARE @fecha DATETIME;
	DECLARE @id_cliente INT;
	DECLARE @nombre_cliente VARCHAR(50);
	DECLARE @puntos_ini INT;
	DECLARE @puntos_fin INT;
	DECLARE @descripcion VARCHAR (100);
	-- Sección de procesamiento de datos
	-- obteniendo fecha
	SELECT @fecha = GETDATE();
	SELECT @id_cliente = id, @nombre_cliente = nombre, @puntos_fin = puntos FROM INSERTED;
	SELECT @puntos_ini = puntos FROM DELETED;
	IF @puntos_ini > @puntos_fin 
		SET @descripcion = 'Cliente ha gastado o regalado puntos';
	ELSE
		SET @descripcion = 'Cliente ha recibido puntos';
	INSERT INTO REGISTRO_PUNTOS (fecha, id_cliente, nombre_cliente, puntos_ini, puntos_fin, descripcion)
		VALUES(@fecha, @id_cliente, @nombre_cliente, @puntos_ini, @puntos_fin, @descripcion);
END;

-- Verificando datos
SELECT * FROM CLIENTE WHERE id = 1 OR id = 2;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2310 WHERE id=1;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4744 WHERE id=2;
EXEC TRANSFERIR_PUNTOS 1, 2, 2000;
-- Verificando contenido de la tabla REGISTRO_PUNTOS
SELECT * FROM REGISTRO_PUNTOS;


