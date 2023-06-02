-- ORDER BY
SELECT R.id, R.checkin, R.checkout, C.nombre, HO.nombre, H.numero
FROM CLIENTE C, RESERVA R, HABITACION H, HOTEL HO
WHERE C.id = R.id_cliente_reserva
    AND H.id = R.id_habitacion
    AND HO.id = H.id_hotel
ORDER BY C.nombre DESC, R.checkin ASC

-- GROUP BY
-- CUANTOS CLIENTES HAY POR CADA PAIS?
-- ORDENE LA LISTA EN ORDEN DESCENDENTE
SELECT TOP 5 P.pais, COUNT(C.nombre) total
FROM PAIS P
    LEFT JOIN CLIENTE C
        ON P.id = C.id_pais
GROUP BY P.pais
ORDER BY COUNT(C.nombre) DESC

-- CUAL ES LA HABITACION MAS CARA Y MAS BARADA DE CADA HOTEL?
SELECT HO.id, HO.nombre, MAX(H.precio) 'mas cara', MIN(H.precio) 'mas barata'
FROM HOTEL HO, HABITACION H
    WHERE HO.id = H.id_hotel
GROUP BY HO.id, HO.nombre
ORDER BY HO.id ASC

-- MOSTRAR EL DETALLE DE CADA RESERVA CON RESPECTO A LOS PRECIOS.
-- INCLUIR EL PRECIO DE LA HABITACION Y EL TOTAL DE LOS SERVICIOS
-- NOTA 1: SE ASUME QUE EL PRECIO DE LA HABITACION ES POR NOCHE
-- NOTA 2: SE ASUME QUE EL PRECIO DE LOS SERVICIOS ES POR NOCHE
-- TOTAL = (PRECIO HABITACION * DIAS RESERVADOS) + (SUMA PRECIO SERVICIO EXTRA + DIAS RESERVADOS)
SELECT R.id, R.checkin, R.checkout, H.precio, 
    DATEDIFF(DAY, R.checkin, R.checkout) 'dias reservados',
    H.precio * DATEDIFF(DAY, R.checkin, R.checkout) 'subtotal habitacion',
    ISNULL(SUM(S.precio),0) 'suma servicios',
    ISNULL(SUM(S.precio),0) * DATEDIFF(DAY, R.checkin, R.checkout) 'subtotal servicios',
    (H.precio * DATEDIFF(DAY, R.checkin, R.checkout)) + (ISNULL(SUM(S.precio),0) * DATEDIFF(DAY, R.checkin, R.checkout)) 'total'
FROM HABITACION H
    INNER JOIN RESERVA R 
        ON H.id = R.id_habitacion
    LEFT JOIN EXTRA X 
        ON R.id = X.id_reserva
    LEFT JOIN SERVICIO S 
        ON S.id = X.id_servicio
GROUP BY R.id, R.checkin, R.checkout, H.precio, 
    DATEDIFF(DAY, R.checkin, R.checkout),
    H.precio * DATEDIFF(DAY, R.checkin, R.checkout)

-- MOSTRAR LAS HABITACIONES QUE HAYAN SIDO RESERVADAS DURANTE AL MENOS 10 DIAS
-- DURANTE JUNIO DE 2023
SELECT H.id, H.numero,
    SUM(DATEDIFF(DAY,R.checkin,R.checkout)) 'dias reservados'
FROM HABITACION H, RESERVA R 
WHERE H.id = R.id_habitacion
    AND MONTH(R.checkin) = 6
    AND YEAR(R.checkin) = 2023
GROUP BY H.id, H.numero
HAVING SUM(DATEDIFF(DAY,R.checkin,R.checkout)) >= 10
ORDER BY H.id ASC;

-- MOSTRAR LA LISTA DE CLIENTES VIP, UN CLIENTE ADQUIERE EL ESTADO VIP
-- SI TIENE AL MENOS UNA ESTANCIA CON VALOR IGUAL O MAYOR A $999.99
SELECT C.id, C.nombre, R.id, R.checkin, R.checkout, H.precio, 
    DATEDIFF(DAY, R.checkin, R.checkout) 'dias reservados',
    H.precio * DATEDIFF(DAY, R.checkin, R.checkout) 'subtotal habitacion',
    ISNULL(SUM(S.precio),0) 'suma servicios',
    ISNULL(SUM(S.precio),0) * DATEDIFF(DAY, R.checkin, R.checkout) 'subtotal servicios',
    (H.precio * DATEDIFF(DAY, R.checkin, R.checkout)) + (ISNULL(SUM(S.precio),0) * DATEDIFF(DAY, R.checkin, R.checkout)) 'total'
FROM HABITACION H
    INNER JOIN RESERVA R 
        ON H.id = R.id_habitacion
    INNER JOIN CLIENTE C 
        ON C.id = R.id_cliente_reserva
    LEFT JOIN EXTRA X 
        ON R.id = X.id_reserva
    LEFT JOIN SERVICIO S 
        ON S.id = X.id_servicio
GROUP BY C.id, C.nombre, R.id, R.checkin, R.checkout, H.precio, 
    DATEDIFF(DAY, R.checkin, R.checkout),
    H.precio * DATEDIFF(DAY, R.checkin, R.checkout)
HAVING (H.precio * DATEDIFF(DAY, R.checkin, R.checkout)) + (ISNULL(SUM(S.precio),0) * DATEDIFF(DAY, R.checkin, R.checkout)) > 999.99

-- MOSTRAR LA CATEGORIA DE HABITACION DE CADA HOTEL QUE HAYA OBTENIDO UNA GANANCIA MAYOR A $2000,
-- TOMAR EN CUENTA SOLO EL "SUBTOTAL HABITACION" PARA REALIZAR EL CALCULO
SELECT HO.id, HO.nombre, TH.tipo,
    SUM(H.precio * DATEDIFF(DAY, R.checkin, R.checkout)) 'subtotal habitacion'
FROM HOTEL HO, HABITACION H, TIPO_HABITACION TH, RESERVA R 
WHERE H.id_hotel = HO.id
    AND H.id = R.id_habitacion
    AND TH.id = H.id_tipo_habitacion
GROUP BY HO.id, HO.nombre, TH.tipo
HAVING SUM(H.precio * DATEDIFF(DAY, R.checkin, R.checkout)) > 2000 
ORDER BY HO.id ASC