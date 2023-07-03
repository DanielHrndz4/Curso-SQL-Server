SELECT P.id, P.nombre, AVG(R.precio) + AVG(S.precio)
FROM PASAJERO P     
    INNER JOIN RESERVA R
    ON P.id = R.id_pasajero
    INNER JOIN SERVICIOXRESERVA SXR 
    ON R.id = SXR.id_reserva
    INNER JOIN SERVICIO S 
    ON S.id = SXR.id_servicio
GROUP BY P.id, P.nombre
ORDER BY P.nombre

-- EJERCICIO 2
SELECT
    CONVERT(VARCHAR(2), DATEPART(MONTH, r.fecha)) + ' ' + DATENAME(MONTH, r.fecha) + ' ' + CONVERT(VARCHAR(4), DATEPART(YEAR, r.fecha)) AS Fecha,
    SUM(r.precio + COALESCE(s.total_servicios, 0)) AS 'Ganancias'
FROM RESERVA r
LEFT JOIN (
    SELECT sr.id_reserva, SUM(s.precio) AS total_servicios
    FROM SERVICIOXRESERVA sr
    JOIN SERVICIO s ON sr.id_servicio = s.id
    GROUP BY sr.id_reserva
) s ON r.id = s.id_reserva
WHERE r.fecha >= '2023-04-01' AND r.fecha < '2023-05-01'
GROUP BY DATEPART(DAY, r.fecha),
    CONVERT(VARCHAR(2), DATEPART(MONTH, r.fecha)) + ' ' +
        DATENAME(MONTH, r.fecha) + ' ' +
        CONVERT(VARCHAR(4), DATEPART(YEAR, r.fecha))
ORDER BY DATEPART(DAY, r.fecha);

