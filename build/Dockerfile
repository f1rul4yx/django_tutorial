# syntax=docker/dockerfile:1
FROM python:3.12-slim

# Instalar dependencias del sistema necesarias para mysqlclient
RUN apt-get update && apt-get install -y \
    gcc \
    pkg-config \
    default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

# Establecer directorio de trabajo
WORKDIR /app

# Copiar el script de arranque
COPY entrypoint.sh /app/

# Dar permisos de ejecución al script de arranque
RUN chmod +x /app/entrypoint.sh

# Copiar archivos de la aplicación
COPY app/ /app/

# Instalar dependencias Python
RUN pip install --no-cache-dir -r requirements.txt

# Exponer el puerto 8000
EXPOSE 8000

# Ejecutar el script de arranque
CMD ["./entrypoint.sh"]
