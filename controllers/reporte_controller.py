from database.conexion import conectar

def reporte_ingresos_por_periodo(fecha_inicio, fecha_fin):
    conexion = conectar()
    cursor = conexion.cursor()
    try:
        cursor.execute(
            "EXEC rarc.sp_ReporteIngresosPorPeriodo @fecha_inicio=?, @fecha_fin=?",
            (fecha_inicio, fecha_fin)
        )
        resultados = cursor.fetchall()
        return resultados
    finally:
        cursor.close()
        conexion.close()

def top_lugares_turisticos(top_n=5):
    conexion = conectar()
    cursor = conexion.cursor()
    try:
        cursor.execute(
            "EXEC rarc.sp_TopLugaresTuristicos @top_n=?",
            (top_n,)
        )
        resultados = cursor.fetchall()
        return resultados
    finally:
        cursor.close()
        conexion.close()