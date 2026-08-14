USE TURISMOPERU_RARC;
GO
CREATE OR ALTER FUNCTION RARC.fn_CalcularIGVPago(
    @monto MONEY
)
RETURNS MONEY 
AS 
BEGIN
    RETURN @monto * 0.18; 
END;
GO

SELECT 
    RARC.fn_CalcularIGVPago(459) AS IGV,
    GETDATE() AS Fecha_Consulta;
GO

SELECT 
    monto,
    RARC.fn_CalcularIGVPago(monto) AS IGV_Calculado, 
    GETDATE() AS Fecha_Consulta                    
FROM RARC.pago[cite: 1]
WHERE monto >= 0;
GO