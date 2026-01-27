#!/bin/bash
set -e

echo "======================================"
echo "Iniciando Django Tutorial"
echo "======================================"
echo "DB_HOST=${DB_HOST}"
echo "DB_NAME=${DB_NAME}"
echo "DB_USER=${DB_USER}"
echo "======================================"

# Esperar a que la base de datos esté lista
echo "Esperando a que inicie la base de datos..."
while ! python3 -c "import MySQLdb; MySQLdb.connect(host='${DB_HOST}', user='${DB_USER}', passwd='${DB_PASSWORD}', db='${DB_NAME}')" 2>/dev/null; do
    echo "La base de datos no está disponible - esperando"
    sleep 2
done
echo "La base de datos está lista!"

# Aplicar migraciones
echo "Aplicando las migraciones a la base de datos..."
python3 manage.py migrate --noinput

# Crear superusuario si no existe
echo "Creando el superusuario..."
python3 manage.py createsuperuser --noinput || true

echo "======================================"
echo "Iniciando Django server..."
echo "======================================"

# Arrancar el servidor Django
exec python3 manage.py runserver 0.0.0.0:8000
