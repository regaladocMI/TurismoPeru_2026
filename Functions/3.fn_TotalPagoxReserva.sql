USE TURISMOPERU_RARC;
GO

CREATE OR ALTER FUNCTION RARC.fn_PagoTotalReserva(
    @IdReserva INT
)
RETURNS MONEY
AS
BEGIN
    DECLARE @Total MONEY;
    
    SELECT @Total = SUM(monto)
    FROM RARC.pago
    WHERE id_reserva = @IdReserva;

    RETURN ISNULL(@Total, 0);
END;
GO

SELECT 
    RARC.fn_PagoTotalReserva(2) AS MontoPagado, 
    GETDATE() AS Fecha_Consulta;
GO