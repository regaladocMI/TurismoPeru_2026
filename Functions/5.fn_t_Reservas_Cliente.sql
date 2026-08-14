USE TURISMOPERU_RARC;
GO

CREATE OR ALTER FUNCTION RARC.fn_ReservaCliente(
    @IdCliente INT
)
RETURNS TABLE 
AS
RETURN (
    SELECT 
        R.id_reserva,
        R.fecha_reserva,
        ER.nombre AS [Estado Reserva] -- Corregido: 'nombre' según tu DDL
    FROM RARC.reserva R 
    INNER JOIN RARC.estado_reserva ER ON ER.id_estado_reserva = R.id_estado_reserva
    WHERE R.id_cliente = @IdCliente
);
GO


--Ejecución
SELECT 
    *,
    GETDATE() AS Fecha_Consulta,
    RARC.fn_NombreCompletoPersona(104) AS Estudiante
FROM RARC.fn_ReservaCliente(2); -- Se invoca la función pasando el parámetro del cliente
GO