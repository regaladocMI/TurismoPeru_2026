USE TURISMOPERU_RARC
GO

CREATE OR ALTER PROCEDURE RARC.sp_ListarPersonas
AS
BEGIN
    Select id_persona, tipo_persona,nombres, apaterno,amaterno, estado
    From RARC.persona
END
GO