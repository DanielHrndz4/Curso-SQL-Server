--EJERCICIO 1
--Crear una función que reciba como parámetro el id de una factura la función retornará el subtotal 
--calculado a partir de los platillos consumidos en el servicio. El tipo de dato que retornará la 
--función será DECIMAL.
CREATE OR ALTER FUNCTION SUBTOTAL_PLATO (@id_factura INT)
RETURNS DECIMAL(10,2)
AS BEGIN
	--DECLARACION DE VARIABLES
	DECLARE @subtotal_plato DECIMAL(10,2);
	--CONSULTA
	SELECT @subtotal_plato = SUM(P.precio)
	FROM FACTURA F
		LEFT JOIN DETALLE_PLATO DP
			ON F.id = DP.id_factura
		LEFT JOIN PLATO P
			ON P.id = DP.id_plato
	--CONDICION !IMPORTANTE
	WHERE F.id = @id_factura
	GROUP BY F.id, F.fecha, F.id_cliente, F.id_restaurante;
	--LO QUE DEVOLVERA LA FUNCION
	RETURN @subtotal_plato;
END; 

SELECT dbo.SUBTOTAL_PLATO(4) 'Subtotal plato';

--Crear una función que reciba como parámetro el id de una factura la función retornará el subtotal 
--calculado a partir de los postres consumidos en el servicio. El tipo de dato que retornará la función 
--será DECIMAL.
CREATE OR ALTER FUNCTION SUBTOTAL_POSTRE (@id_factura INT)
RETURNS DECIMAL(10,2)
AS BEGIN
	--DECLARACION DE VARIABLES
	DECLARE @subtotal_postre DECIMAL(10,2);
	--CONSULTA
	SELECT @subtotal_postre = SUM(P.precio)
	FROM FACTURA F
		LEFT JOIN DETALLE_POSTRE DP
			ON F.id = DP.id_factura
		LEFT JOIN POSTRE P
			ON P.id = DP.id_postre
	--CONDICION !IMPORTANTE
	WHERE F.id = @id_factura
	GROUP BY F.id, F.fecha, F.id_cliente, F.id_restaurante;
	--LO QUE DEVOLVERA LA FUNCION
	RETURN @subtotal_postre;
END; 

SELECT dbo.SUBTOTAL_POSTRE(4) 'Subtotal postre';

--EJERCICIO 2
--Crear una función que reciba como parámetros valores que representan dos fechas, el tipo de dato 
--debe ser DATE. La función retornará la lista de facturas registradas en la base de datos en el rango 
--de fechas definidos como parámetros. El resultado debe incluir el subtotal de platos, el subtotal 
--de postres y el total (suma del subtotal de platos + subtotal de postres). Para calcular los 
--subtotales, la función debe hacer uso de las dos funciones creadas en el ejercicio 1.
CREATE OR ALTER FUNCTION total_entre (@FROM DATE, @TO DATE) 
--DEVOLVERA UNA TABLA
RETURNS TABLE 
AS
	RETURN(
        --CONSULTA A LA TABLA FACTURA
		SELECT F.id, F.fecha, F.id_cliente, F.id_restaurante, 
				dbo.SUBTOTAL_PLATO (F.id) 'subtotal_plato',  dbo.SUBTOTAL_POSTRE(F.id) 'subtotal_postre',
				dbo.SUBTOTAL_PLATO (F.id) + dbo.SUBTOTAL_POSTRE(F.id) 'total'
		FROM FACTURA F
        --CONDICION DE FECHA
		WHERE F.fecha BETWEEN @FROM AND @TO 
	);

SELECT * FROM dbo.total_entre (CONVERT(DATE, '2022-01-03'), CONVERT(DATE, '2022-01-30'));

--EJERCICIO 3
--Crear un procedimiento almacenado que reciba como parámetros el id de un restaurante (INT), y 
--dos fechas (VARCHAR). El procedimiento deberá hacer uso de la función creada en el ejercicio 
--2 para poder obtener las ganancias de un restaurante específico en un rango de fechas, luego, se 
--deberá recorrer el resultado de la consulta con un cursor para imprimir su contenido en consola. 
--El procedimiento deberá hacer uso correcto de cursores y bloques TRY/CATCH para realizar el 
--procesamiento de datos.
CREATE OR ALTER PROCEDURE print_total_entre (@id_restaurante INT, @FROM VARCHAR(16), @TO VARCHAR(16))
AS BEGIN
    --DECLARACION DEL CURSOR
	DECLARE cursor_total_entre CURSOR STATIC FOR
        --CONSULTA A LA TABLA QUE QUEREMOS IMPRIMIR
		SELECT id, fecha, total FROM dbo.total_entre (CONVERT(DATE, @FROM, 103), CONVERT(DATE, @TO, 103))
		WHERE id_restaurante = @id_restaurante;
    --DECLARACION DE VARIABLES
	DECLARE @condicion_parada INT;
	DECLARE @id INT, @fecha DATE, @total DECIMAL (10,2)
	DECLARE @nombre_restaurante VARCHAR(32);
    --CONSULTA PARA OBTENER NOMBRE DEL RESTAURANTE
	SELECT @nombre_restaurante = nombre FROM RESTAURANTE WHERE id = @id_restaurante;
    --INICIO DEL TRY CATCH
	BEGIN TRY
        --INICIAMOS EL CURSOR
		OPEN cursor_total_entre;
        --CONDICION PARADA SERA IGUAL AL TOTAL DE FILAS DE LA TABLA
		SET @condicion_parada = @@Cursor_Rows;
		PRINT 'Las facturas registradas del restaurante "'+@nombre_restaurante+'" son:'
		PRINT '---------------------------------------------------'
        --INICIO DEL CICLO WHILE
		WHILE @condicion_parada > 0
		BEGIN
            --BUSCAQUEDA PARA ASIGNAR LOS VALORES A LAS VARIABLES
			FETCH cursor_total_entre INTO @id, @fecha, @total;
			PRINT 'id factura: ' + CAST (@id AS VARCHAR(2)) + ', fecha: ' + CAST (@fecha AS VARCHAR(12)) + ', TOTAL: $'+ CAST(@total AS VARCHAR(12));
			SET @condicion_parada = @condicion_parada - 1;
		END;
		PRINT '---------------------------------------------------'
        --CERRAR EL CURSOR
		CLOSE cursor_total_entre;
		DEALLOCATE cursor_total_entre;
	END TRY
	BEGIN CATCH
        --DECLARACION DE ERROR
		DECLARE @ERROR_MESSAGE VARCHAR(100);
		SELECT @ERROR_MESSAGE=ERROR_MESSAGE();
		PRINT 'ERROR: ' + @ERROR_MESSAGE;
	END CATCH
END; 

EXEC print_total_entre 2,'01/01/2022','30/06/2022';

--EJERCICIO 4
--Crear un TRIGGER que permita cumplir con la siguiente disposición de la cadena de restaurantes: 
--cada cliente solo puede generar 5 facturas en un día específico. Si un cliente desea generar una 
--sexta factura en un mismo día la instrucción fallará.
CREATE OR ALTER TRIGGER CHECK_FACTURA
--ASIGNAMOS EL DISPARADOR A LA TABLA
ON FACTURA
AFTER INSERT
AS BEGIN
		--DECLARACION DE VARIABLES
		DECLARE @id_cliente INT;
		DECLARE @id_fecha DATE;
		DECLARE @cantidad_facturas INT;
		--OBTENEMOS LOS DATOS DE LA TABLA INSERTED
		SELECT @id_fecha = fecha, @id_cliente = id_cliente FROM INSERTED I;
		SELECT @cantidad_facturas = COUNT(*) FROM FACTURA;
    --CONDICION, SI LA CANTIDAD DE FACTURAS DE ESE CLIENTE ES MAYOR A 5, YA NO SE PODRAR REGISTRAR EN ESE MISMO DIA
	IF @cantidad_facturas > 5
	BEGIN 
		RAISERROR ('ERROR: Consulta invalida, el cliente ha generado sus 5 facturas del d�a...' ,11,1)
		ROLLBACK TRANSACTION
	END;
END;

--COMPROBACION
INSERT INTO FACTURA VALUES(31, CONVERT(DATE,'05/07/2022',103), 10, 1);
INSERT INTO FACTURA VALUES(32, CONVERT(DATE,'05/07/2022',103), 10, 2);
INSERT INTO FACTURA VALUES(33, CONVERT(DATE,'05/07/2022',103), 10, 5);
INSERT INTO FACTURA VALUES(34, CONVERT(DATE,'05/07/2022',103), 10, 4);
INSERT INTO FACTURA VALUES(35, CONVERT(DATE,'05/07/2022',103), 10, 2);
INSERT INTO FACTURA VALUES(36, CONVERT(DATE,'05/07/2022',103), 10, 1);


--EJERCICIO 5
--Crear un TRIGGER que verifique si la estación de un plato que se desea asignar a una factura 
--corresponde con la fecha de la factura. Cada plato tiene asignado un menú, este a su vez 
--corresponde con una estación (es posible verificar esto en la tabla MENU).
--“verano” Del 22 de junio al 23 de septiembre
CREATE OR ALTER TRIGGER VerificarEstacionPlato
ON DETALLE_PLATO
FOR INSERT
AS
BEGIN
  DECLARE @FacturaFecha DATE;
  DECLARE @MenuEstacion VARCHAR(20);

  -- Obtener la fecha de la factura a través del detalle de plato recién insertado
  SELECT @FacturaFecha = F.fecha
  FROM FACTURA F
  WHERE F.id IN (SELECT id FROM inserted);

  -- Obtener la estación del menú correspondiente a la fecha de la factura
  SELECT @MenuEstacion = M.estacion
  FROM MENU M
  WHERE @FacturaFecha BETWEEN '2022-05-22' AND '2022-09-23';

  -- Verificar si la estación del plato corresponde a la estación del menú
  IF EXISTS (
    SELECT *
    FROM DETALLE_PLATO DP
    INNER JOIN MENU M ON DP.id_plato = M.id
    INNER JOIN FACTURA F ON DP.id_factura = F.id
    WHERE DP.id_factura IN (SELECT id_factura FROM inserted)
    AND M.estacion <> @MenuEstacion
  )
  BEGIN
    -- Si la estación no corresponde, se lanza un error
	PRINT 'Temporada de la factura: verano';
	PRINT 'Temporada del plato: '+ @MenuEstacion;
    RAISERROR('ERROR: La estación del plato y la temporada no coinciden...', 16, 1);
    ROLLBACK TRANSACTION; -- Opcionalmente, se puede hacer un rollback de la transacción
  END
END;

INSERT INTO FACTURA VALUES (47, CONVERT(DATE, '05/07/2022', 103), 6, 3);
INSERT INTO DETALLE_PLATO VALUES (47, 4);
