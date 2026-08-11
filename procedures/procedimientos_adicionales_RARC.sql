USE TURISMOPERU_RARC;
GO



-- 1. sp_RegistrarReserva
CREATE OR ALTER PROCEDURE rarc.sp_RegistrarReserva
    @id_cliente        INT,
    @id_paquete        INT,
    @id_empleado       INT,
    @id_alojamiento    INT,
    @id_habitacion     INT,
    @fecha_inicio      DATE,
    @fecha_fin         DATE,
    @numero_personas   INT,
    @precio_total      DECIMAL(10,2),
    @adelanto          DECIMAL(10,2) = 0,
    @observaciones     VARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @fecha_inicio >= @fecha_fin
        BEGIN
            RAISERROR('La fecha de inicio debe ser anterior a la fecha de fin.', 16, 1);
            RETURN;
        END

        IF EXISTS (
            SELECT 1 FROM rarc.reserva_habitacion rh
            WHERE rh.id_habitacion = @id_habitacion
              AND @fecha_inicio < rh.fecha_checkout
              AND @fecha_fin > rh.fecha_checkin
        )
        BEGIN
            RAISERROR('La habitacion seleccionada no esta disponible en esas fechas.', 16, 1);
            RETURN;
        END

        DECLARE @id_estado_pendiente INT;
        SELECT @id_estado_pendiente = id_estado_reserva
        FROM rarc.estado_reserva WHERE nombre = 'Pendiente';

        IF @id_estado_pendiente IS NULL
        BEGIN
            RAISERROR('No existe un estado "Pendiente" en rarc.estado_reserva. Insertalo primero.', 16, 1);
            RETURN;
        END

        DECLARE @precio_noche DECIMAL(10,2);
        SELECT @precio_noche = precio_noche FROM rarc.habitacion WHERE id_habitacion = @id_habitacion;

        -- Codigo legible: RES-YYYYMMDD-#### (correlativo simple)
        DECLARE @codigo_reserva VARCHAR(20);
        SET @codigo_reserva = 'RES-' + FORMAT(GETDATE(), 'yyyyMMdd') + '-' +
            RIGHT('0000' + CAST((ISNULL((SELECT MAX(id_reserva) FROM rarc.reserva), 0) + 1) AS VARCHAR(4)), 4);

        BEGIN TRANSACTION;

        INSERT INTO rarc.reserva (
            codigo_reserva, id_cliente, id_paquete, id_empleado, id_alojamiento, id_habitacion,
            fecha_inicio, fecha_fin, numero_personas, precio_total, adelanto, saldo_pendiente,
            id_estado_reserva, observaciones
        )
        VALUES (
            @codigo_reserva, @id_cliente, @id_paquete, @id_empleado, @id_alojamiento, @id_habitacion,
            @fecha_inicio, @fecha_fin, @numero_personas, @precio_total, @adelanto, @precio_total - @adelanto,
            @id_estado_pendiente, @observaciones
        );

        DECLARE @id_reserva_nueva INT = SCOPE_IDENTITY();

        INSERT INTO rarc.reserva_habitacion (id_reserva, id_habitacion, fecha_checkin, fecha_checkout, precio_noche)
        VALUES (@id_reserva_nueva, @id_habitacion, @fecha_inicio, @fecha_fin, ISNULL(@precio_noche, 0));

        COMMIT TRANSACTION;

        SELECT @id_reserva_nueva AS id_reserva, @codigo_reserva AS codigo_reserva,
               'Reserva registrada correctamente.' AS mensaje;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
        SELECT ERROR_MESSAGE() AS error;
    END CATCH
END
GO
PRINT 'Procedimiento sp_RegistrarReserva creado';
GO


--2. sp_RegistrarPago
CREATE OR ALTER PROCEDURE rarc.sp_RegistrarPago
    @id_reserva       INT,
    @id_medio_pago    INT,
    @monto            DECIMAL(10,2),
    @numero_operacion VARCHAR(50) = NULL,
    @comprobante      VARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM rarc.reserva WHERE id_reserva = @id_reserva)
        BEGIN
            RAISERROR('La reserva indicada no existe.', 16, 1);
            RETURN;
        END

        IF @monto <= 0
        BEGIN
            RAISERROR('El monto del pago debe ser mayor a cero.', 16, 1);
            RETURN;
        END

        BEGIN TRANSACTION;

        INSERT INTO rarc.pago (id_reserva, id_medio_pago, monto, numero_operacion, comprobante, estado)
        VALUES (@id_reserva, @id_medio_pago, @monto, @numero_operacion, @comprobante, 'Confirmado');

        UPDATE rarc.reserva
        SET adelanto = adelanto + @monto,
            saldo_pendiente = saldo_pendiente - @monto
        WHERE id_reserva = @id_reserva;

        DECLARE @saldo DECIMAL(10,2);
        SELECT @saldo = saldo_pendiente FROM rarc.reserva WHERE id_reserva = @id_reserva;

        IF @saldo <= 0 AND EXISTS (SELECT 1 FROM rarc.estado_reserva WHERE nombre = 'Confirmada')
        BEGIN
            UPDATE rarc.reserva
            SET id_estado_reserva = (SELECT id_estado_reserva FROM rarc.estado_reserva WHERE nombre = 'Confirmada')
            WHERE id_reserva = @id_reserva;
        END

        COMMIT TRANSACTION;

        SELECT @saldo AS saldo_pendiente, 'Pago registrado correctamente.' AS mensaje;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
        SELECT ERROR_MESSAGE() AS error;
    END CATCH
END
GO
PRINT 'Procedimiento sp_RegistrarPago creado';
GO


--3. sp_ReporteIngresosPorPeriodo
CREATE OR ALTER PROCEDURE rarc.sp_ReporteIngresosPorPeriodo
    @fecha_inicio DATE,
    @fecha_fin    DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        tp.nombre                       AS tipo_paquete,
        COUNT(DISTINCT r.id_reserva)    AS total_reservas,
        SUM(p.monto)                    AS total_ingresado,
        AVG(p.monto)                    AS ticket_promedio
    FROM rarc.pago p
    INNER JOIN rarc.reserva r      ON r.id_reserva = p.id_reserva
    INNER JOIN rarc.paquete pa     ON pa.id_paquete = r.id_paquete
    INNER JOIN rarc.tipo_paquete tp ON tp.id_tipo_paquete = pa.id_tipo_paquete
    WHERE p.estado = 'Confirmado'
      AND CAST(p.fecha_pago AS DATE) BETWEEN @fecha_inicio AND @fecha_fin
    GROUP BY tp.nombre
    ORDER BY total_ingresado DESC;
END
GO
PRINT 'Procedimiento sp_ReporteIngresosPorPeriodo creado';
GO


--4. sp_TopLugaresTuristicos
CREATE OR ALTER PROCEDURE rarc.sp_TopLugaresTuristicos
    @top_n INT = 5
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@top_n)
        lt.id_lugarturistico,
        lt.nombre,
        lt.calificacion,
        COUNT(DISTINCT r.id_reserva) AS veces_incluido_en_reservas
    FROM rarc.lugar_turistico lt
    INNER JOIN rarc.paquete_lugar pl ON pl.id_lugarturistico = lt.id_lugarturistico
    INNER JOIN rarc.reserva r        ON r.id_paquete = pl.id_paquete
    GROUP BY lt.id_lugarturistico, lt.nombre, lt.calificacion
    ORDER BY veces_incluido_en_reservas DESC, lt.calificacion DESC;
END
GO
PRINT 'Procedimiento sp_TopLugaresTuristicos creado';
GO




