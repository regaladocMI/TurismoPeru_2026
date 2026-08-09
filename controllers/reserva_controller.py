from database.conexion import conectar

def insertar_reserva(reserva):
    conexion = conectar()
    cursor = conexion.cursor()
    sql = "{CALL rarc.sp_RegistrarReserva (?,?,?,?,?,?,?,?,?,?,?)}"
    parametros = (
        reserva.id_cliente,
        reserva.id_paquete,
        reserva.id_empleado,
        reserva.id_alojamiento,
        reserva.id_habitacion,
        reserva.fecha_inicio,
        reserva.fecha_fin,
        reserva.numero_personas,
        reserva.precio_total,
        reserva.adelanto,
        reserva.observaciones
    )
    try:
        cursor.execute(sql, parametros)
        resultado = cursor.fetchone()
        conexion.commit()
        return resultado
    except Exception as e:
        print("Error al registrar la reserva:", e)
        return None
    finally:
        cursor.close()
        conexion.close()

def listar_clientes_select():
    conexion = conectar()
    cursor = conexion.cursor()
    cursor.execute("""
        SELECT p.id_persona, p.nombres, p.apaterno, p.amaterno
        FROM rarc.persona p
        INNER JOIN rarc.cliente c ON p.id_persona = c.id_persona
        WHERE p.estado = 'Activo'
    """)
    clientes = cursor.fetchall()
    cursor.close()
    conexion.close()
    return clientes

def listar_paquetes_select():
    conexion = conectar()
    cursor = conexion.cursor()
    cursor.execute("SELECT id_paquete, nombre FROM rarc.paquete")
    paquetes = cursor.fetchall()
    cursor.close()
    conexion.close()
    return paquetes

def listar_empleados_select():
    conexion = conectar()
    cursor = conexion.cursor()
    cursor.execute("""
        SELECT p.id_persona, p.nombres, p.apaterno, p.amaterno
        FROM rarc.persona p
        INNER JOIN rarc.empleado e ON p.id_persona = e.id_persona
        WHERE p.estado = 'Activo'
    """)
    empleados = cursor.fetchall()
    cursor.close()
    conexion.close()
    return empleados

def listar_alojamientos_select():
    conexion = conectar()
    cursor = conexion.cursor()
    cursor.execute("SELECT id_alojamiento, nombre FROM rarc.alojamiento")
    alojamientos = cursor.fetchall()
    cursor.close()
    conexion.close()
    return alojamientos

def listar_habitaciones_select():
    conexion = conectar()
    cursor = conexion.cursor()
    cursor.execute("SELECT id_habitacion, id_alojamiento, precio_noche FROM rarc.habitacion")
    habitaciones = cursor.fetchall()
    cursor.close()
    conexion.close()
    return habitaciones