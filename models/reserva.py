class Reserva:
    def __init__(
        self,
        id_cliente,
        id_paquete,
        id_empleado,
        id_alojamiento,
        id_habitacion,
        fecha_inicio,
        fecha_fin,
        numero_personas,
        precio_total,
        adelanto,
        observaciones
    ):
        self.id_cliente = id_cliente
        self.id_paquete = id_paquete
        self.id_empleado = id_empleado
        self.id_alojamiento = id_alojamiento
        self.id_habitacion = id_habitacion
        self.fecha_inicio = fecha_inicio
        self.fecha_fin = fecha_fin
        self.numero_personas = numero_personas
        self.precio_total = precio_total
        self.adelanto = adelanto
        self.observaciones = observaciones