-- EJERCICIO 1
SELECT * FROM CLIENTE
ORDER BY id DESC

-- EJERCICIO 2
SELECT * FROM CLIENTE
    WHERE correo LIKE '%.edu%'
ORDER BY id DESC

-- EJERCICIO 3
SELECT P.nombre, P.precio, M.nombre, M.estacion 
FROM MENU M, PLATO P
    WHERE M.id = P.id_menu
    AND M.estacion LIKE 'otoño'

-- EJERCICIO 4
SELECT P.nombre, P.precio, I.id, I.nombre
FROM PLATO P
    INNER JOIN PLATOXINGREDIENTE PXI 
    ON P.id = PXI.id_plato
    INNER JOIN INGREDIENTE I 
    ON I.id = PXI.id_ingrediente
WHERE P.id LIKE 9

-- EJERCICIO 5
SELECT P.id, P.nombre, P.precio, COUNT(DP.id_plato) 'ventas realizadas'
FROM FACTURA F
    INNER JOIN DETALLE_PLATO DP
    ON F.id = DP.id_factura
    INNER JOIN PLATO P 
    ON P.id = DP.id_plato
GROUP BY P.id, P.nombre, P.precio
ORDER BY COUNT(DP.id_plato) DESC

-- EJERCICIO 6
SELECT C.id, C.nombre, (COUNT(F.id_cliente) / 30.0) * 100 'Porcentaje compra'
FROM CLIENTE C 
    RIGHT JOIN FACTURA F 
    ON C.id = F.id_cliente
GROUP BY C.id, C.nombre
ORDER BY (COUNT(F.id_cliente) / 30.0) * 100 DESC;

-- EJERCICIO 7
SELECT F.id, F.fecha, R.nombre, SUM(P.precio) 'subtotal plato'
FROM FACTURA F 
    INNER JOIN DETALLE_PLATO DP 
    ON F.id = DP.id_factura
    INNER JOIN PLATO P 
    ON P.id = DP.id_plato
    INNER JOIN RESTAURANTE R 
    ON R.id = F.id_restaurante
GROUP BY F.id, F.fecha, R.nombre
ORDER BY F.id ASC;