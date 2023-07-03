-- EJERCICIO 1
SELECT id, nombre, direccion,fecha_nacimiento,
DATEDIFF(YEAR,fecha_nacimiento,GETDATE()) 'edad'
FROM CLIENTE 
WHERE DATEDIFF(YEAR,fecha_nacimiento,GETDATE()) > 22

-- EJERCICIO 2
SELECT P.id, P.titulo, P.duracion, G.titulo
FROM GENERO G, PELICULA P 
    WHERE G.id = P.id_genero
ORDER BY G.titulo ASC, P.titulo ASC

-- EJERCICIO 3
SELECT S.id, S.nombre 'nombre sala', S.ubicacion 'ubicacion sala', CONCAT(A.fila,A.columna) 'asiento'
FROM SALA S, ASIENTO A 
    WHERE S.id = A.id_sala
    AND ubicacion LIKE 'Pasillo 2'

-- EJERCICIO 4
SELECT C.id 'id compra', C.fecha 'fecha compra', C.descuento, C.id_cliente, C.id_empleado, DC.id_combo
FROM COMPRA C
    LEFT JOIN DETALLE_COMBO DC 
    ON C.id = DC.id_compra
WHERE DC.id_combo IS NULL
ORDER BY C.id 

-- EJERCICIO 5 
SELECT C.id 'id combo', C.nombre, C.precio, IC.id_producto, P.nombre 'producto'
FROM COMBO C 
    INNER JOIN ITEM_COMBO IC 
    ON C.id = IC.id_combo
    INNER JOIN PRODUCTO P 
    ON P.id = IC.id_producto
WHERE C.id = 3
ORDER BY P.id ASC

-- EJERCICIO 6 
SELECT C.id, C.fecha 'fecha compra', C.descuento, SUM(COM.precio), SUM(COM.precio) - C.descuento
FROM COMPRA C
    INNER JOIN DETALLE_COMBO DC
    ON C.id = DC.id_compra
    INNER JOIN COMBO COM 
    ON COM.id = DC.id_combo
GROUP BY C.id, C.fecha, C.descuento
ORDER BY C.id ASC
