# 🐳 Build - Contexto de construcción Docker

Esta carpeta contiene todos los archivos necesarios para construir la imagen Docker de la aplicación.

## 📁 Estructura

```
build/
├── Dockerfile          # Definición de la imagen Docker
├── entrypoint.sh       # Script de arranque del contenedor
├── app/                # Código fuente de la aplicación Django
│   ├── manage.py
│   ├── requirements.txt
│   ├── django_tutorial/
│   └── polls/
└── README.md           # Este archivo
```

## 🛠️ Construcción de la imagen

### Desde la raíz del proyecto:

```bash
# Construcción básica
docker build -t f1rul4yx/django_tutorial:v1 build/

# Con variables de construcción
docker build \
  --build-arg PYTHON_VERSION=3.12 \
  -t f1rul4yx/django_tutorial:v1 \
  build/

# Sin caché
docker build --no-cache -t f1rul4yx/django_tutorial:v1 build/
```

### Desde dentro de la carpeta build:

```bash
cd build
docker build -t f1rul4yx/django_tutorial:v1 .
```

## 📝 Notas importantes

- **Contexto de construcción**: El contexto es la carpeta `build/`, no la raíz del proyecto
- **Archivos copiados**: Solo se copia el contenido de `app/` al contenedor
- **entrypoint.sh**: Script que se ejecuta al iniciar el contenedor
- **Dependencias del sistema**: Se instalan gcc, pkg-config y libmysqlclient-dev para mysqlclient

## 🔧 Modificaciones

Si necesitas modificar la imagen:

1. **Cambiar versión de Python**: Edita la línea `FROM python:3.12-slim` en `Dockerfile`
2. **Añadir paquetes del sistema**: Edita la sección `RUN apt-get install` en `Dockerfile`
3. **Modificar el arranque**: Edita `entrypoint.sh`
4. **Añadir dependencias Python**: Edita `app/requirements.txt`

## ✅ Verificación

Después de construir, verifica la imagen:

```bash
# Ver imágenes
docker images | grep django_tutorial

# Inspeccionar la imagen
docker inspect f1rul4yx/django_tutorial:v1

# Probar la imagen
docker run --rm f1rul4yx/django_tutorial:v1 python --version
```

## 📤 Subir a Docker Hub

```bash
# Login
docker login

# Subir
docker push f1rul4yx/django_tutorial:v1

# Subir múltiples tags
docker push f1rul4yx/django_tutorial:v1
docker push f1rul4yx/django_tutorial:v2
docker push f1rul4yx/django_tutorial:latest
```
