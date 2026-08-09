class Pago:
    def __init__(
        self,
        id_reserva,
        id_medio_pago,
        monto,
        numero_operacion,
        comprobante
    ):
        self.id_reserva = id_reserva
        self.id_medio_pago = id_medio_pago
        self.monto = monto
        self.numero_operacion = numero_operacion
        self.comprobante = comprobante