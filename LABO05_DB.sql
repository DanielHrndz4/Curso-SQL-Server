-- JONATHAN DANIEL HERNANDEZ   00015322
-- EJERCICIO 1
CREATE OR ALTER FUNCTION FUNCION_FECHAS (@inicio VARCHAR(30), @fin VARCHAR(30))
RETURNS TABLE
AS RETURN(
    SELECT PM.nombre 'Puerto origen', PM2.nombre 'Puerto destino', V.fecha_salida 'Fecha salida', V.fecha_llegada 'Fecha llegada', 
    B.matricula 'Matricula' , C.nombre 'Capitan'
    FROM BARCO B 
        INNER JOIN VIAJE V 
        ON B.id = V.id_barco
        INNER JOIN CAPITAN C 
        ON C.id = V.id_capitan
        INNER JOIN PUERTO_MARITIMO PM 
        ON PM.id = V.id_puerto_maritimo_origen
        INNER JOIN PUERTO_MARITIMO PM2
        ON PM2.id = V.id_puerto_maritimo_destino
    WHERE v.fecha_salida BETWEEN CONVERT(DATE, @inicio , 103) AND CONVERT(DATE , @fin , 103)
);

SELECT * FROM dbo.FUNCION_FECHAS( '08/06/2023', '11/06/2023');

-- EJERCICIO 2
ALTER TABLE PASAJERO
ADD vip INT NOT NULL DEFAULT 0;

CREATE OR ALTER PROCEDURE CALCULAR_VIP_PASAJEROS
AS
BEGIN
    DECLARE @id INT, @nombre VARCHAR(100), @promedioVIP DECIMAL(10, 2), @vip INT;

    DECLARE curVIP CURSOR FOR
    SELECT id, nombre, promedio_reservas
    FROM (
        SELECT p.id, p.nombre, AVG(r.precio + COALESCE(s.total_servicios, 0)) AS promedio_reservas
        FROM PASAJERO p
        JOIN RESERVA r ON p.id = r.id_pasajero
        LEFT JOIN (
            SELECT sr.id_reserva, SUM(s.precio) AS total_servicios
            FROM SERVICIOXRESERVA sr
            JOIN SERVICIO s ON sr.id_servicio = s.id
            GROUP BY sr.id_reserva
        ) s ON r.id = s.id_reserva
        GROUP BY p.id, p.nombre
        HAVING AVG(r.precio + COALESCE(s.total_servicios, 0)) > 1650.00
    ) AS VIP;

    OPEN curVIP;
    FETCH NEXT FROM curVIP INTO @id, @nombre, @promedioVIP;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF (@promedioVIP > 1650.00)
            SET @vip = 1;
        ELSE
            SET @vip = 0;

        UPDATE PASAJERO
        SET VIP = @vip
        WHERE id = @id;

        FETCH NEXT FROM curVIP INTO @id, @nombre, @promedioVIP;
    END;

    CLOSE curVIP;
    DEALLOCATE curVIP;
END;

EXEC CALCULAR_VIP_PASAJEROS;

SELECT * FROM PASAJERO 