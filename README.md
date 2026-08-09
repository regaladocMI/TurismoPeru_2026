## 🏦 Proyecto Base de Datos 
## 📘 Descripción General
Proyecto "Turismo Perú 2026": aplicación web desarrollada con Python (Flask) 
conectada a una base de datos SQL Server, orientada a la gestión de personas 
y clientes dentro de un sistema de turismo. El proyecto integra el uso de 
procedimientos almacenados, control de versiones con Git/GitHub, y 
documentación técnica del desarrollo.

## 🚀 Fases del Proyecto
1. Preparación del entorno (Git, entorno virtual, estructura de carpetas)
2. Instalación de librerías (Flask, pyodbc, python-dotenv)
3. Configuración de credenciales de conexión a la base de datos
4. Configuración de archivos a no sincronizar (.gitignore)
5. Configuración de la conexión a la base de datos
6. Creación de procedimientos almacenados en SQL Server
7. Configuración de modelos (models)
8. Configuración de controladores (controllers)
9. Configuración del archivo principal (app.py)
10. Configuración de las vistas HTML (templates)
11. Ejecución de la aplicación
12. Documentación del proyecto (README.md)
13. Versionamiento con Git y publicación en GitHub

## 🧠 Competencias a Desarrollar
- Maneja entornos de desarrollo con Visual Studio Code y entornos virtuales.
- Utiliza Git Bash para versionar proyectos y gestionar ramas.
- Aplica estructuras básicas y avanzadas de Python en el tratamiento de datos.
- Publica y documenta un proyecto en GitHub.

## 🗂️ Estructura del Proyecto
```bash
TurismoPeru_2026/
│
├── controllers/
│   └── listar_controller.py
│   └── persona_controller.py
│
├── database/
│   └── conexion.py
│
├── models/
│   └── cliente.py
│   └── persona.py
│
├── procedures/
│
├── scripts/
│   └── create_files.py
│
├── static/
│
├── templates/
│   └── index.html
│   └── insertar.html
│   └── clientes.html
│
├── .env
├── .gitignore
├── app.py
├── config.py
├── requirements.txt
├── README.md
```

## 🧰 Requisitos

flask
pyodbc
python-dotenv


## 👨‍🏫 Autor
Regalado Cabrera Reiner Alexander
Fecha: 08.08.2026 (actualizado)