-- ============================================================================
-- SCRIPT: Crear Tablespaces para QuindioFlix
-- OBJETIVO: Crear 9 tablespaces estratificados por tipo de datos
-- AUTOR: Yuri Andrea - Ruben Garrido
-- FECHA: 22-05-2026
-- ============================================================================
-- 1. TABLESPACE: TS_SISTEMA (Datos de referencia estáticos)
-- ============================================================================
--'Almacena tablas de referencia estáticas: PLAN, GENERO, DISPOSITIVO, METODO_PAGO, CIUDAD. '
--'Bajo volumen, acceso frecuente. Crecimiento lento.
CREATE TABLESPACE TS_SISTEMA
  DATAFILE 'sistema_01.dbf' SIZE 100M
  AUTOEXTEND ON MAXSIZE 500M;

-- ============================================================================
-- 2. TABLESPACE: TS_USUARIOS (Datos de usuarios)
-- ============================================================================
-- 'Almacena tablas de usuarios: USUARIO, SUSCRIPCION, PERFIL. '
--'Datos transaccionales críticos. Crecimiento moderado.'
CREATE TABLESPACE TS_USUARIOS
  DATAFILE 'usuarios_01.dbf' SIZE 150M
  AUTOEXTEND ON MAXSIZE 1000M;

-- ============================================================================
-- 3. TABLESPACE: TS_CONTENIDO (Catálogo de contenido)
-- ============================================================================
--'Almacena catálogo: CONTENIDO, TEMPORADA, EPISODIO, GENERO, CONTENIDO_GENERO. '
--'Datos de referencia, medianos volúmenes. Crecimiento anual.'
CREATE TABLESPACE TS_CONTENIDO
  DATAFILE 'contenido_01.dbf' SIZE 200M
  AUTOEXTEND ON MAXSIZE 2000M;

-- ============================================================================
-- 4. TABLESPACE: TS_REPRODUCCION (Reproducciones - fragmentado por años)
-- ============================================================================
--'Tablespace DEFAULT para tabla REPRODUCCION. '
--'Alto volumen, crecimiento continuo. Se fragmenta por año en tablespaces adicionales.'
CREATE TABLESPACE TS_REPRODUCCION
  DATAFILE 'reproduccion_01.dbf' SIZE 500M
  AUTOEXTEND ON MAXSIZE 5000M;

-- ============================================================================
-- 5. TABLESPACE: TS_REPRODUCCIONES_2024 (Reproducciones año 2024)
-- ============================================================================
--'Almacena reproducciones de año 2024. Facilita archivado de datos históricos.'
CREATE TABLESPACE TS_REPRODUCCIONES_2024
  DATAFILE 'reproduccion_2024_01.dbf' SIZE 300M
  AUTOEXTEND ON MAXSIZE 2000M;

-- ============================================================================
-- 6. TABLESPACE: TS_REPRODUCCIONES_2025 (Reproducciones año 2025)
-- ============================================================================
--'Almacena reproducciones de año 2025 (datos actuales). Mejor performance.'
CREATE TABLESPACE TS_REPRODUCCIONES_2025
  DATAFILE 'reproduccion_2025_01.dbf' SIZE 400M
  AUTOEXTEND ON MAXSIZE 3000M;

-- ============================================================================
-- 7. TABLESPACE: TS_TRANSACCIONES (Pagos, favoritos, calificaciones)
-- ============================================================================
-- Almacena PAGO, FAVORITO, CALIFICACION, REPORTE_CONTENIDO. '
-- 'Datos transaccionales, acceso moderado.

CREATE TABLESPACE TS_TRANSACCIONES
  DATAFILE 'transacciones_01.dbf' SIZE 250M
  AUTOEXTEND ON MAXSIZE 2000M;

-- ============================================================================
-- 8. TABLESPACE: TS_EMPLEADOS (Estructura organizacional)
-- ============================================================================
--'Almacena EMPLEADO, DEPARTAMENTO, EMPLEADO_CARGO, HISTORIAL_PLAN. '
--'Datos de gestión, bajo volumen, acceso esporádico.'
CREATE TABLESPACE TS_EMPLEADOS
  DATAFILE 'empleados_01.dbf' SIZE 100M
  AUTOEXTEND ON MAXSIZE 500M;

-- ============================================================================
-- 9. TABLESPACE: TS_INDICES (Índices de todas las tablas)
-- ============================================================================
-- 'Almacena índices de todas las tablas. Separación para mejor gestión de I/O.
CREATE TABLESPACE TS_INDICES
  DATAFILE 'indices_01.dbf' SIZE 200M
  AUTOEXTEND ON MAXSIZE 2000M;

-- ============================================================================
-- VERIFICACIÓN: Ver tablespaces creados
-- ============================================================================

SELECT tablespace_name, status, extent_management 
FROM dba_tablespaces
WHERE tablespace_name LIKE 'TS_%'
ORDER BY tablespace_name;

