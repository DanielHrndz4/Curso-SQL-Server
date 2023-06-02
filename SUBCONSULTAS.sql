-- CUAL ES EL PORCENTAJE DE CLIENTES QUE VIENEN DE CADA PAIS?
-- LA CONCULTA DEBE RESPONDER A LOS CAMBIOS DE LA BASE DE DATOS
SELECT P.id, P.pais, CONCAT(CAST(COUNT(C.id) AS FLOAT)/(SELECT COUNT(*) FROM CLIENTE)*100, '%') 'porcentajes clientes'
FROM CLIENTE C, PAIS P
    WHERE P.id = C.id_pais
GROUP BY P.id, P.pais
ORDER BY P.id ASC;

-- MOSTRAR LA LISTA DE CLIENTES VIP, NUESTRO CRITERIO CAMBIA: UN CLIENTE ADQUIERE
-- EL ESTADO VIP SI EL PROMEDIO DE SUS ESTACIAS ES IGUAL O MAYOR A $550.00
-- ES NECESARIO RETIRAR EL ORDER BY EN LAS SUBCONSULTAS
-- SE LE DEBE COLOCAR UN ALIAS A LAS SUBCONSULTAS
SELECT CLIENTE_TOTAL_RESERVA.id, CLIENTE_TOTAL_RESERVA.nombre, AVG(CLIENTE_TOTAL_RESERVA.TOTAL_RESERVA)
FROM (
SELECT C.id, C.nombre,
    H.precio * DATEDIFF(DAY,R.checkin,R.checkout) +
    ISNULL(SUM(S.precio),0) * DATEDIFF(DAY, R.checkin, R.checkout) 'TOTAL_RESERVA'
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
    DATEDIFF(DAY, R.checkin, R.checkout),
    H.precio * DATEDIFF(DAY, R.checkin, R.checkout)
) CLIENTE_TOTAL_RESERVA
GROUP BY CLIENTE_TOTAL_RESERVA.id, CLIENTE_TOTAL_RESERVA.nombre
HAVING AVG(CLIENTE_TOTAL_RESERVA.TOTAL_RESERVA) >= 550.00
ORDER BY CLIENTE_TOTAL_RESERVA.id;

ALTER TABLE CLIENTE ADD vip TINYINT NULL;
UPDATE CLIENTE SET vip = 0;

-- ACTUALIZANDO CLIENTES VIP
UPDATE CLIENTE SET vip = 1 
WHERE id IN(
    SELECT CLIENTE_TOTAL_RESERVA.id
FROM (
SELECT C.id, C.nombre,
    H.precio * DATEDIFF(DAY,R.checkin,R.checkout) +
    ISNULL(SUM(S.precio),0) * DATEDIFF(DAY, R.checkin, R.checkout) 'TOTAL_RESERVA'
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
    DATEDIFF(DAY, R.checkin, R.checkout),
    H.precio * DATEDIFF(DAY, R.checkin, R.checkout)
) CLIENTE_TOTAL_RESERVA
GROUP BY CLIENTE_TOTAL_RESERVA.id, CLIENTE_TOTAL_RESERVA.nombre
HAVING AVG(CLIENTE_TOTAL_RESERVA.TOTAL_RESERVA) >= 550.00
)

SELECT * FROM CLIENTE 

-- MOSTRAR EN UNA VISTA LOS 2 SERVICIOS QUE MAS INGRESOS TIENEN Y LOS 2 QUE MENOS
-- INGRESOS TIENEN 
SELECT TOP 2 S.id, S.nombre, S.precio,
    SUM(DATEDIFF(DAY, R.checkin, R.checkout)*S.precio) 'ganancias'
FROM RESERVA R, SERVICIO S, EXTRA E
WHERE R.id = E.id_reserva
    AND S.id = E.id_servicio
GROUP BY S.id, S.nombre, S.precio
ORDER BY (SUM(DATEDIFF(DAY, R.checkin, R.checkout)*S.precio)) DESC

SELECT TOP 2 S.id, S.nombre, S.precio,
    SUM(DATEDIFF(DAY, R.checkin, R.checkout)*S.precio) 'ganancias'
FROM RESERVA R, SERVICIO S, EXTRA E
WHERE R.id = E.id_reserva
    AND S.id = E.id_servicio
GROUP BY S.id, S.nombre, S.precio
ORDER BY (SUM(DATEDIFF(DAY, R.checkin, R.checkout)*S.precio)) ASC

SELECT TOP 2 S.id
FROM RESERVA R, SERVICIO S, EXTRA E
WHERE R.id = E.id_reserva
    AND S.id = E.id_servicio
    AND (S.id IN (2,4) OR S.id IN (1,7))
GROUP BY S.id, S.nombre, S.precio
ORDER BY (SUM(DATEDIFF(DAY, R.checkin, R.checkout)*S.precio)) ASC