USE TURISMOPERU_RARC
GO

CREATE OR ALTER PROCEDURE RARC.sp_ListarClientes
AS
BEGIN
    Select p.id_persona, p.tipo_persona,nombres, apaterno,amaterno, estado
    From RARC.persona p
    inner join RARC.cliente c
    on p.id_persona = c.id_persona
END
GO