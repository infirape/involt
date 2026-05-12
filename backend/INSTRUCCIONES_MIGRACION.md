# 🚀 INSTRUCCIONES DE MIGRACIÓN EN PRODUCCIÓN

## 📋 Resumen
Este proceso migra **1,125 usuarios de energía eléctrica** desde el Excel procesado hacia la base de datos de producción, reemplazando los datos corruptos existentes.

## 📦 Archivos Necesarios
```
├── migrate_production.sh           # Script ejecutable principal
├── migrate_usuarios_production.sql # Script SQL con datos limpios
└── INSTRUCCIONES_MIGRACION.md     # Este archivo
```

## ⚠️ IMPORTANTE - LEE ANTES DE EJECUTAR

### 🔒 Qué va a pasar:
1. **Se borrará TODA la información actual** de usuarios de energía
2. Se importarán **23 caseríos** nuevos (vs 19 corruptos actuales)
3. Se importarán **1,125 usuarios** nuevos (vs 1,057 corruptos actuales)
4. Se creará un **backup automático** antes de proceder

### 📊 Datos a migrar:
- **23 caseríos** completos (incluyendo HUAYLLAPAMPA que faltaba)
- **1,112 usuarios residenciales**
- **13 usuarios comerciales**
- **1 usuario pendiente** (JAM031 - para actualizar en admin después)

## 🚀 PASOS DE EJECUCIÓN

### 1. Preparación
```bash
# Subir archivos al servidor de producción
scp migrate_production.sh migrate_usuarios_production.sql servidor_produccion:/ruta/del/proyecto/

# Conectarse al servidor
ssh servidor_produccion
cd /ruta/del/proyecto/
```

### 2. Verificar Docker Compose
```bash
# Verificar que PostgreSQL esté corriendo
docker compose ps

# Si no está corriendo:
docker compose up -d
```

### 3. Ejecutar Migración
```bash
# Dar permisos de ejecución
chmod +x migrate_production.sh

# Ejecutar migración
./migrate_production.sh
```

### 4. Confirmación
El script te pedirá confirmación:
```
⚠️ ATENCIÓN: Esta migración va a:
   1. Borrar TODOS los readings existentes
   2. Borrar TODOS los customers existentes  
   3. Borrar TODOS los sectors existentes
   4. Importar 23 sectores nuevos
   5. Importar 1,125 customers nuevos

💾 Backup guardado en: backup_before_migration_20250511_123456.sql

¿Continuar con la migración? (yes/no):
```

Responde: **`yes`**

## ✅ Verificación Post-Migración

### El script mostrará automáticamente:
```sql
-- Estado final esperado:
Sectors migrados: 23
Customers migrados: 1125  
Readings finales: 0

-- Top sectores:
CERCADO CHETILLA: 181 usuarios
MANZANO: 118 usuarios
MAHUAYPAMPA: 88 usuarios
```

### Verificación manual adicional:
```bash
# Conectarse a la base de datos
docker compose exec postgres psql -U involt_user -d involt_db

# Verificar usuario pendiente
SELECT code, name FROM customers WHERE code = 'JAM031';
-- Debe mostrar: JAM031 | [PENDIENTE]

# Verificar distribución
SELECT connection_type, COUNT(*) FROM customers GROUP BY connection_type;
-- Debe mostrar: residential: 1112, commercial: 13
```

## 🔧 En caso de problemas

### Si la migración falla:
```bash
# Restaurar desde backup
docker compose exec -T postgres psql -U involt_user -d involt_db < backup_before_migration_FECHA.sql
```

### Si necesitas re-ejecutar:
```bash
# El script es seguro para ejecutar múltiples veces
./migrate_production.sh
```

## 📝 Tareas Post-Migración

### En el Admin Panel:
1. Buscar usuario con código **JAM031**
2. Cambiar nombre de **`[PENDIENTE]`** por el nombre real
3. Verificar que todos los caseríos aparezcan correctamente

### Verificación de funcionalidad:
1. Crear algunas lecturas de prueba
2. Verificar reportes por caserío
3. Confirmar que todos los usuarios aparecen en sus respectivos sectores

## 📞 Soporte
Si tienes problemas durante la migración:
1. **NO REINICIES** los contenedores hasta resolver
2. Guarda el log completo del error
3. El backup automático permite rollback completo

---

## 📊 Detalles Técnicos

### Mapeo de Caseríos:
```
SEC-001: ALTO CHETILLA (63 usuarios)
SEC-002: CADENA (78 usuarios)
SEC-003: CASADENCITO (64 usuarios)
SEC-004: CERCADO CHETILLA (181 usuarios)
...
SEC-023: UÑIGAN (24 usuarios)
```

### Campos por defecto:
- **tariff**: 0.50 (todos los usuarios)
- **meter_number**: METER-{código}
- **latitude/longitude**: 0.0 (por actualizar después)
- **address**: "Dirección en {caserío}"

---

**🎯 Objetivo**: Reemplazar datos corruptos por datos limpios del Excel procesado.
**⏱️ Tiempo estimado**: 2-5 minutos dependiendo del servidor.
**🔄 Rollback**: Disponible mediante backup automático.
