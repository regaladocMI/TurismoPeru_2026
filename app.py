from flask import *
# from models.cliente import Cliente
from models.persona import Persona
# from models.viewPersona import viewPersona
# from controllers.cliente_controller import insertar_cliente
from controllers.listar_controller import listarclientes, listarpersonas
from controllers.persona_controller import insertar_persona
#//NUEVOS IMPORTS
from models.reserva import Reserva
from models.pago import Pago
from controllers.reserva_controller import (
    insertar_reserva,
    listar_clientes_select,
    listar_paquetes_select,
    listar_empleados_select,
    listar_alojamientos_select,
    listar_habitaciones_select
)
from controllers.pago_controller import (
    insertar_pago,
    listar_reservas_pendientes_select,
    listar_medios_pago_select
)
from controllers.reporte_controller import (
    reporte_ingresos_por_periodo,
    top_lugares_turisticos
)
from datetime import date

app=Flask(__name__)
@app.route("/")
def inicio():
    personas = listarpersonas()
    return render_template(
        "index.html",
        personas=personas
    )
def inicio():
    clientes = listarclientes()
    return render_template(
        "index.html",
        clientes=clientes
    )
@app.route("/clientes")
def client():
    clientes = listarclientes()
    return render_template(
        "clientes.html",
        clientes=clientes
    )
@app.route("/nuevo")
def nuevo():
    return render_template("insertar.html")
@app.route("/guardar",methods=["POST"])
def guardar():
    persona=Persona(
        request.form.get("tipo_persona"),
        request.form.get("nombres"),
        request.form.get("apaterno"),
        request.form.get("amaterno"),
        request.form.get("razon_social"),
        request.form.get("nombre_comercial"),
        request.form.get("id_tipo_documento"),
        request.form.get("numero_documento"),
        request.form.get("telefono"),
        request.form.get("email"),
        request.form.get("id_nacionalidad"),
        request.form.get("estado")
    )
    insertar_persona(persona)
    return redirect("/")

#NEW
@app.route("/nueva-reserva")
def nueva_reserva():
    clientes = listar_clientes_select()
    paquetes = listar_paquetes_select()
    empleados = listar_empleados_select()
    alojamientos = listar_alojamientos_select()
    habitaciones = listar_habitaciones_select()
    return render_template(
        "registrar_reserva.html",
        clientes=clientes,
        paquetes=paquetes,
        empleados=empleados,
        alojamientos=alojamientos,
        habitaciones=habitaciones
    )

@app.route("/guardar-reserva", methods=["POST"])
def guardar_reserva():
    reserva = Reserva(
        request.form.get("id_cliente"),
        request.form.get("id_paquete"),
        request.form.get("id_empleado"),
        request.form.get("id_alojamiento"),
        request.form.get("id_habitacion"),
        request.form.get("fecha_inicio"),
        request.form.get("fecha_fin"),
        request.form.get("numero_personas"),
        request.form.get("precio_total"),
        request.form.get("adelanto") or 0,
        request.form.get("observaciones")
    )
    resultado = insertar_reserva(reserva)
    return render_template("resultado_reserva.html", resultado=resultado)

@app.route("/nuevo-pago")
def nuevo_pago():
    reservas = listar_reservas_pendientes_select()
    medios_pago = listar_medios_pago_select()
    return render_template(
        "registrar_pago.html",
        reservas=reservas,
        medios_pago=medios_pago
    )

@app.route("/guardar-pago", methods=["POST"])
def guardar_pago():
    pago = Pago(
        request.form.get("id_reserva"),
        request.form.get("id_medio_pago"),
        request.form.get("monto"),
        request.form.get("numero_operacion"),
        request.form.get("comprobante")
    )
    resultado = insertar_pago(pago)
    return render_template("resultado_pago.html", resultado=resultado)

@app.route("/reporte-ingresos", methods=["GET", "POST"])
def reporte_ingresos():
    if request.method == "POST":
        fecha_inicio = request.form.get("fecha_inicio")
        fecha_fin = request.form.get("fecha_fin")
    else:
        fecha_inicio = "2020-01-01"
        fecha_fin = date.today().isoformat()
    datos = reporte_ingresos_por_periodo(fecha_inicio, fecha_fin)
    return render_template(
        "reporte_ingresos.html",
        datos=datos,
        fecha_inicio=fecha_inicio,
        fecha_fin=fecha_fin
    )

@app.route("/top-lugares")
def top_lugares():
    lugares = top_lugares_turisticos(5)
    return render_template("top_lugares.html", lugares=lugares)

app.run(debug=True)
@app.route("/editar/<int:id>")
def editar(id):
    persona = buscar_cliente(id)
    return render_template(
        "editar.html",
        persona=cliente
    )
@app.route(
"/actualizar",
methods=["POST"]
)
def actualizar():
    actualizar_cliente(
        request.form["id"],
        request.form["nombre"],
        request.form["apellido"],
        request.form["documento"]
    )
    return redirect("/")
@app.route("/eliminar/<int:id>")
def eliminar(id):
    eliminar_cliente(id)
    return redirect("/")