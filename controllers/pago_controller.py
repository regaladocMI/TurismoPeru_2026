from database.conexion import conectar

def insertar_pago(pago):
    conexion = conectar()
    cursor = conexion.cursor()
    sql = "{CALL rarc.sp_RegistrarPago (?,?,?,?,?)}"
    parametros = (
        pago.id_reserva,
        pago.id_medio_pago,
        pago.monto,
        pago.numero_operacion,
        pago.comprobante
    )
    try:
        cursor.execute(sql, parametros)
        resultado = cursor.fetchone()
        conexion.commit()
        return resultado
    except Exception as e:
        print("Error al registrar el pago:", e)
        return None
    finally:
        cursor.close()
        conexion.close()

def listar_reservas_pendientes_select():
    conexion = conectar()
    cursor = conexion.cursor()
    cursor.execute("""
        SELECT id_reserva, codigo_reserva, saldo_pendiente
        FROM rarc.reserva
        WHERE saldo_pendiente > 0
    """)
    reservas = cursor.fetchall()
    cursor.close()
    conexion.close()
    return reservas

def listar_medios_pago_select():
    conexion = conectar()
    cursor = conexion.cursor()
    cursor.execute("SELECT id_medio_pago, nombre FROM rarc.medio_pago")
    medios = cursor.fetchall()
    cursor.close()
    conexion.close()
    return medios