#!/bin/bash

# ===============================================
# SCRIPT DE MIGRACIÓN PARA PRODUCCIÓN
# ===============================================
# Migra usuarios de energía eléctrica en producción
# usando Docker Compose
# ===============================================

set -e  # Salir si algún comando falla

echo "🚀 INICIANDO MIGRACIÓN EN PRODUCCIÓN"
echo "===================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SQL_FILE="${SCRIPT_DIR}/migrate_usuarios_production.sql"
BACKUP_FILE="${SCRIPT_DIR}/backup_before_migration_$(date +%Y%m%d_%H%M%S).sql"

# Función para logs
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar que existe el script SQL
if [ ! -f "$SQL_FILE" ]; then
    log_error "No se encontró el archivo SQL: $SQL_FILE"
    exit 1
fi

log_info "Script SQL encontrado: $SQL_FILE"

# Verificar que Docker Compose está corriendo
if ! docker compose ps | grep -q "postgres"; then
    log_error "PostgreSQL no está corriendo en Docker Compose"
    log_info "Ejecuta: docker compose up -d"
    exit 1
fi

log_info "PostgreSQL detectado en Docker Compose"

# Obtener el nombre del servicio de PostgreSQL
POSTGRES_SERVICE=$(docker compose ps --services | grep -E "db|postgres" | head -1)

if [ -z "$POSTGRES_SERVICE" ]; then
    log_error "No se pudo detectar el servicio de PostgreSQL"
    exit 1
fi

log_info "Servicio PostgreSQL: $POSTGRES_SERVICE"

# Crear backup antes de la migración
log_warn "Creando backup de seguridad..."
docker compose exec -T "$POSTGRES_SERVICE" pg_dump -U involt_user -d involt_db > "$BACKUP_FILE" 2>/dev/null || {
    log_error "Error creando backup"
    exit 1
}

log_info "Backup creado: $BACKUP_FILE"

# Mostrar estado actual
log_info "Estado actual de la base de datos:"
docker compose exec -T "$POSTGRES_SERVICE" psql -U involt_user -d involt_db -c "
SELECT 
    'Sectors actuales' as tabla, COUNT(*) as registros 
FROM sectors 
UNION ALL 
SELECT 
    'Customers actuales' as tabla, COUNT(*) as registros 
FROM customers 
UNION ALL 
SELECT 
    'Readings actuales' as tabla, COUNT(*) as registros 
FROM readings;
"

# Confirmar ejecución
echo ""
log_warn "⚠️  ATENCIÓN: Esta migración va a:"
echo "   1. Borrar TODOS los readings existentes"
echo "   2. Borrar TODOS los customers existentes"
echo "   3. Borrar TODOS los sectors existentes"
echo "   4. Importar 23 sectores nuevos"
echo "   5. Importar 1,125 customers nuevos"
echo ""
log_warn "💾 Backup guardado en: $BACKUP_FILE"
echo ""

read -p "¿Continuar con la migración? (yes/no): " -r
if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    log_info "Migración cancelada por el usuario"
    exit 0
fi

# Ejecutar migración
log_info "Ejecutando migración..."
echo "======================================"

if docker compose exec -T "$POSTGRES_SERVICE" psql -U involt_user -d involt_db < "$SQL_FILE"; then
    log_info "✅ MIGRACIÓN COMPLETADA EXITOSAMENTE"
    
    # Mostrar estado final
    log_info "Estado final de la base de datos:"
    docker compose exec -T "$POSTGRES_SERVICE" psql -U involt_user -d involt_db -c "
    SELECT 
        'Sectors migrados' as tabla, COUNT(*) as registros 
    FROM sectors 
    UNION ALL 
    SELECT 
        'Customers migrados' as tabla, COUNT(*) as registros 
    FROM customers 
    UNION ALL 
    SELECT 
        'Readings finales' as tabla, COUNT(*) as registros 
    FROM readings;
    "
    
    log_info "Top 5 sectores por cantidad de usuarios:"
    docker compose exec -T "$POSTGRES_SERVICE" psql -U involt_user -d involt_db -c "
    SELECT 
        s.name as sector, 
        COUNT(c.id) as usuarios
    FROM sectors s 
    LEFT JOIN customers c ON s.id = c.sector_id 
    GROUP BY s.id, s.name 
    ORDER BY COUNT(c.id) DESC
    LIMIT 5;
    "
    
else
    log_error "❌ ERROR EN LA MIGRACIÓN"
    log_warn "Para restaurar el backup:"
    log_warn "docker compose exec -T $POSTGRES_SERVICE psql -U involt_user -d involt_db < $BACKUP_FILE"
    exit 1
fi

echo ""
log_info "🎉 MIGRACIÓN COMPLETADA"
log_info "📄 Backup disponible en: $BACKUP_FILE"
log_info "📝 Usuario JAM031 pendiente para actualizar en admin"

