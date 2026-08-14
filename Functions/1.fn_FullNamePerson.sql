USE TURISMOPERU_RARC;
GO

CREATE OR ALTER FUNCTION RARC.fn_NombreCompletoPersona(
    @IdPersona INT
)
RETURNS VARCHAR(200)
AS 
BEGIN
    DECLARE @nombrecompleto VARCHAR(200);

    SELECT @nombrecompleto = nombres + ' ' + apaterno + ' ' + amaterno
    FROM RARC.persona
    WHERE id_persona = @IdPersona;

    RETURN @nombrecompleto;
END
GO

-- EJECUCIÓN DE PRUEBA
SELECT RARC.fn_NombreCompletoPersona(105) 
AS Persona,GETDATE() as FechaConsulta;
GO