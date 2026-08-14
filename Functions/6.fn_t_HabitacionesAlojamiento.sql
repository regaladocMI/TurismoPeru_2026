USE TURISMOPERU_RARC;
GO

CREATE OR ALTER FUNCTION RARC.fn_HabitacionesAlojamiento(
    @IdAlojamiento INT
)
RETURNS TABLE 
AS
RETURN (
    SELECT
        H.id_alojamiento,
        H.numero_habitacion,
        TH.nombrehabitacion,
        TH.capacidad_personas,
        H.precio_noche,
        H.estado,
        H.descripcion
    FROM RARC.habitacion H 
    INNER JOIN RARC.tipo_habitacion TH ON H.id_tipo_habitacion = TH.id_tipo_habitacion
    WHERE H.id_alojamiento = @IdAlojamiento -- Corregido: usa el parámetro, no un valor fijo
);
GO

--Ejecutar
SELECT 
    *,
    GETDATE() AS FechaConsulta,
    RARC.fn_NombreCompletoPersona(104) AS Estudiante
FROM RARC.fn_HabitacionesAlojamiento(2); -- Pasamos el parámetro 2
GO