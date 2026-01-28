#!/bin/bash

# Script para gestionar la aplicación Django en Kubernetes
# Uso: ./k8s.sh [deploy|delete]

set -e

function show_usage() {
    echo "Uso: $0 [deploy|delete]"
    echo ""
    echo "Comandos:"
    echo "  deploy  - Despliega la aplicación Django en Kubernetes"
    echo "  delete  - Elimina la aplicación Django de Kubernetes"
    exit 1
}

function deploy() {
    echo "🚀 Desplegando aplicación Django en Kubernetes..."
    echo ""

    echo "📦 Creando namespace..."
    kubectl apply -f k8s/01-namespace.yaml

    echo "🔐 Creando secrets..."
    kubectl apply -f k8s/02-secrets.yaml

    echo "⚙️  Creando configmap..."
    kubectl apply -f k8s/03-configmap.yaml

    echo "💾 Creando PersistentVolumeClaim para MariaDB..."
    kubectl apply -f k8s/04-mariadb-pvc.yaml

    echo "🗄️  Desplegando MariaDB..."
    kubectl apply -f k8s/05-mariadb-deployment.yaml

    echo "🌐 Creando servicio de MariaDB..."
    kubectl apply -f k8s/06-mariadb-service.yaml

    echo "⏳ Esperando a que MariaDB esté listo..."
    kubectl wait --for=condition=ready pod -l app=mariadb -n django-app --timeout=120s

    echo "🐍 Desplegando Django..."
    kubectl apply -f k8s/07-django-deployment.yaml

    echo "🌐 Creando servicio de Django..."
    kubectl apply -f k8s/08-django-service.yaml

    echo "🔀 Configurando Ingress..."
    kubectl apply -f k8s/09-ingress.yaml

    echo ""
    echo "✅ Despliegue completado!"
    echo ""
    echo "📊 Estado de los pods:"
    kubectl get pods -n django-app
    echo ""
    echo "🌐 Servicios:"
    kubectl get services -n django-app
    echo ""
    echo "🔀 Ingress:"
    kubectl get ingress -n django-app
}

function delete() {
    echo "🗑️  Eliminando aplicación Django de Kubernetes..."
    echo ""

    echo "🔀 Eliminando Ingress..."
    kubectl delete -f k8s/09-ingress.yaml --ignore-not-found=true

    echo "🌐 Eliminando servicio de Django..."
    kubectl delete -f k8s/08-django-service.yaml --ignore-not-found=true

    echo "🐍 Eliminando deployment de Django..."
    kubectl delete -f k8s/07-django-deployment.yaml --ignore-not-found=true

    echo "🌐 Eliminando servicio de MariaDB..."
    kubectl delete -f k8s/06-mariadb-service.yaml --ignore-not-found=true

    echo "🗄️  Eliminando deployment de MariaDB..."
    kubectl delete -f k8s/05-mariadb-deployment.yaml --ignore-not-found=true

    echo "💾 Eliminando PersistentVolumeClaim..."
    kubectl delete -f k8s/04-mariadb-pvc.yaml --ignore-not-found=true

    echo "⚙️  Eliminando configmap..."
    kubectl delete -f k8s/03-configmap.yaml --ignore-not-found=true

    echo "🔐 Eliminando secrets..."
    kubectl delete -f k8s/02-secrets.yaml --ignore-not-found=true

    echo "📦 Eliminando namespace..."
    kubectl delete -f k8s/01-namespace.yaml --ignore-not-found=true

    echo ""
    echo "✅ Eliminación completada!"
    echo ""
    echo "Verificando que no queden recursos:"
    kubectl get all -n django-app 2>/dev/null || echo "✓ Namespace eliminado correctamente"
}

# Verificar argumentos
if [ $# -eq 0 ]; then
    show_usage
fi

# Procesar comando
case "$1" in
    deploy)
        deploy
        ;;
    delete)
        delete
        ;;
    *)
        echo "❌ Error: Comando desconocido '$1'"
        echo ""
        show_usage
        ;;
esac
