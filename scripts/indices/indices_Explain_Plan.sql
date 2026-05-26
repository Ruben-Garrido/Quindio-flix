-- ============================================================================
-- SCRIPT: ÍNDICES Y EXPLAIN PLAN
-- REQUISITO: 3.4.1 (4 Índices) + 3.4.2 (EXPLAIN PLAN antes/después)
-- PROPÓSITO: Optimizar performance de consultas críticas
-- ============================================================================

PROMPT ============================================================================
PROMPT ÍNDICES Y EXPLAIN PLAN - QUINDIOFLIX
PROMPT ============================================================================

-- ============================================================================
-- ÍNDICE 1: IDX_REPRODUCCION_PERFIL_FECHA
-- Tabla: REPRODUCCION
-- Columnas: id_perfil, fecha_hora_inicio
-- Propósito: Acelerar búsquedas de reproducciones por perfil y fecha
-- ============================================================================

PROMPT;
PROMPT === ÍNDICE 1: REPRODUCCIÓN POR PERFIL Y FECHA ===
PROMPT;

PROMPT Antes de crear índice - EXPLAIN PLAN sin índice:
PROMPT;

EXPLAIN PLAN FOR
SELECT id_reproduccion, id_contenido, porcentaje_avance
FROM REPRODUCCION
WHERE id_perfil = 1
AND fecha_hora_inicio BETWEEN SYSDATE - 30 AND SYSDATE
ORDER BY fecha_hora_inicio DESC;

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

PROMPT;
PROMPT Creando índice IDX_REPRODUCCION_PERFIL_FECHA...
PROMPT;

CREATE INDEX IDX_REPRODUCCION_PERFIL_FECHA
ON REPRODUCCION (id_perfil, fecha_hora_inicio DESC);

PROMPT ? Índice IDX_REPRODUCCION_PERFIL_FECHA creado;

PROMPT;
PROMPT Después de crear índice - EXPLAIN PLAN con índice:
PROMPT;

EXPLAIN PLAN FOR
SELECT id_reproduccion, id_contenido, porcentaje_avance
FROM REPRODUCCION
WHERE id_perfil = 1
AND fecha_hora_inicio BETWEEN SYSDATE - 30 AND SYSDATE
ORDER BY fecha_hora_inicio DESC;

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

-- ============================================================================
-- ÍNDICE 2: IDX_USUARIO_EMAIL
-- Tabla: USUARIO
-- Columna: email
-- Propósito: Acelerar búsquedas por email (validar duplicados, login)
-- ============================================================================

PROMPT;
PROMPT === ÍNDICE 2: USUARIO POR EMAIL ===
PROMPT;

PROMPT Antes de crear índice - EXPLAIN PLAN sin índice:
PROMPT;

EXPLAIN PLAN FOR
SELECT id_usuario, nombre, email
FROM USUARIO
WHERE UPPER(email) = UPPER('juan@email.com');

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

PROMPT;
PROMPT Creando índice IDX_USUARIO_EMAIL...
PROMPT;

CREATE INDEX IDX_USUARIO_EMAIL
ON USUARIO (UPPER(email));

PROMPT ? Índice IDX_USUARIO_EMAIL creado;

PROMPT;
PROMPT Después de crear índice - EXPLAIN PLAN con índice:
PROMPT;

EXPLAIN PLAN FOR
SELECT id_usuario, nombre, email
FROM USUARIO
WHERE UPPER(email) = UPPER('juan@email.com');

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

-- ============================================================================
-- ÍNDICE 3: IDX_CONTENIDO_TIPO_ANNO
-- Tabla: CONTENIDO
-- Columnas: tipo_contenido, ano_lanzamiento
-- Propósito: Acelerar filtros por tipo de contenido y año
-- ============================================================================

PROMPT;
PROMPT === ÍNDICE 3: CONTENIDO POR TIPO Y AÑO ===
PROMPT;

PROMPT Antes de crear índice - EXPLAIN PLAN sin índice:
PROMPT;

EXPLAIN PLAN FOR
SELECT id_contenido, titulo, tipo_contenido, ano_lanzamiento
FROM CONTENIDO
WHERE tipo_contenido = 'PELICULA'
AND ano_lanzamiento >= 2020
ORDER BY ano_lanzamiento DESC;

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

PROMPT;
PROMPT Creando índice IDX_CONTENIDO_TIPO_ANNO...
PROMPT;

CREATE INDEX IDX_CONTENIDO_TIPO_ANNO
ON CONTENIDO (tipo_contenido, ano_lanzamiento DESC);

PROMPT ? Índice IDX_CONTENIDO_TIPO_ANNO creado;

PROMPT;
PROMPT Después de crear índice - EXPLAIN PLAN con índice:
PROMPT;

EXPLAIN PLAN FOR
SELECT id_contenido, titulo, tipo_contenido, ano_lanzamiento
FROM CONTENIDO
WHERE tipo_contenido = 'PELICULA'
AND ano_lanzamiento >= 2020
ORDER BY ano_lanzamiento DESC;

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

-- ============================================================================
-- ÍNDICE 4: IDX_PAGO_SUSCRIPCION_ESTADO
-- Tabla: PAGO
-- Columnas: id_suscripcion, estado
-- Propósito: Acelerar reportes de pagos por suscripción y estado
-- ============================================================================

PROMPT;
PROMPT === ÍNDICE 4: PAGO POR SUSCRIPCIÓN Y ESTADO ===
PROMPT;

PROMPT Antes de crear índice - EXPLAIN PLAN sin índice:
PROMPT;

EXPLAIN PLAN FOR
SELECT id_pago, id_suscripcion, monto, estado, fecha_pago
FROM PAGO
WHERE id_suscripcion = 1
AND estado = 'EXITOSO'
ORDER BY fecha_pago DESC;

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

PROMPT;
PROMPT Creando índice IDX_PAGO_SUSCRIPCION_ESTADO...
PROMPT;

CREATE INDEX IDX_PAGO_SUSCRIPCION_ESTADO
ON PAGO (id_suscripcion, estado, fecha_pago DESC);

PROMPT ? Índice IDX_PAGO_SUSCRIPCION_ESTADO creado;

PROMPT;
PROMPT Después de crear índice - EXPLAIN PLAN con índice:
PROMPT;

EXPLAIN PLAN FOR
SELECT id_pago, id_suscripcion, monto, estado, fecha_pago
FROM PAGO
WHERE id_suscripcion = 1
AND estado = 'EXITOSO'
ORDER BY fecha_pago DESC;

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

-- ============================================================================
-- ANÁLISIS COMPARATIVO: ESTADÍSTICAS DE ÍNDICES
-- ============================================================================

PROMPT;
PROMPT === ANÁLISIS COMPARATIVO DE ÍNDICES ===
PROMPT;

SELECT 
    index_name,
    table_name,
    uniqueness,
    status
FROM user_indexes
WHERE table_name IN ('REPRODUCCION', 'USUARIO', 'CONTENIDO', 'PAGO')
AND index_name LIKE 'IDX_%'
ORDER BY table_name, index_name;

-- ============================================================================
-- ANÁLISIS DE COLUMNAS DE ÍNDICES
-- ============================================================================

PROMPT;
PROMPT === DETALLE DE COLUMNAS DE ÍNDICES ===
PROMPT;

SELECT 
    index_name,
    table_name,
    column_name,
    column_position,
    descend
FROM user_ind_columns
WHERE index_name IN ('IDX_REPRODUCCION_PERFIL_FECHA', 
                     'IDX_USUARIO_EMAIL',
                     'IDX_CONTENIDO_TIPO_ANNO',
                     'IDX_PAGO_SUSCRIPCION_ESTADO')
ORDER BY index_name, column_position;

-- ============================================================================
-- QUERY DE PRUEBA CON CADA ÍNDICE
-- ============================================================================

PROMPT;
PROMPT === PRUEBAS DE PERFORMANCE CON ÍNDICES ===
PROMPT;

-- Prueba 1: Reproducciones por perfil
PROMPT;
PROMPT Consulta 1: Reproducciones de perfil 1 últimos 30 días
DECLARE
    v_contador NUMBER := 0;
BEGIN
    FOR v_reg IN (
        SELECT id_reproduccion
        FROM REPRODUCCION
        WHERE id_perfil = 1
        AND fecha_hora_inicio BETWEEN SYSDATE - 30 AND SYSDATE
    ) LOOP
        v_contador := v_contador + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('? Registros encontrados: ' || v_contador);
END;
/

-- Prueba 2: Búsqueda de usuario por email
PROMPT;
PROMPT Consulta 2: Búsqueda de usuario por email
DECLARE
    v_usuario_id NUMBER;
BEGIN
    SELECT id_usuario INTO v_usuario_id
    FROM USUARIO
    WHERE UPPER(email) = UPPER('juan@email.com')
    AND ROWNUM = 1;
    
    DBMS_OUTPUT.PUT_LINE('? Usuario encontrado: ID ' || v_usuario_id);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('? Usuario no encontrado');
END;
/

-- Prueba 3: Contenido por tipo y año
PROMPT;
PROMPT Consulta 3: Películas lanzadas desde 2020
DECLARE
    v_contador NUMBER := 0;
BEGIN
    FOR v_reg IN (
        SELECT id_contenido
        FROM CONTENIDO
        WHERE tipo_contenido = 'PELICULA'
        AND ano_lanzamiento >= 2020
    ) LOOP
        v_contador := v_contador + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('? Películas encontradas: ' || v_contador);
END;
/

-- Prueba 4: Pagos exitosos por suscripción
PROMPT;
PROMPT Consulta 4: Pagos exitosos de suscripción 1
DECLARE
    v_contador NUMBER := 0;
    v_monto_total NUMBER := 0;
BEGIN
    SELECT COUNT(*), SUM(monto) INTO v_contador, v_monto_total
    FROM PAGO
    WHERE id_suscripcion = 1
    AND estado = 'EXITOSO';
    
    DBMS_OUTPUT.PUT_LINE('? Pagos exitosos: ' || v_contador);
    DBMS_OUTPUT.PUT_LINE('? Monto total: $' || ROUND(NVL(v_monto_total, 0), 2));
END;
/

-- ============================================================================
-- RESUMEN DE ÍNDICES CREADOS
-- ============================================================================

PROMPT;
PROMPT ============================================================================
PROMPT RESUMEN DE ÍNDICES Y EXPLAIN PLAN
PROMPT ============================================================================

DECLARE
    v_idx_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_idx_count
    FROM user_indexes
    WHERE index_name LIKE 'IDX_%'
    AND table_name IN ('REPRODUCCION', 'USUARIO', 'CONTENIDO', 'PAGO');
    
    DBMS_OUTPUT.PUT_LINE('? ÍNDICE 1: IDX_REPRODUCCION_PERFIL_FECHA');
    DBMS_OUTPUT.PUT_LINE('  Columnas: id_perfil, fecha_hora_inicio DESC');
    DBMS_OUTPUT.PUT_LINE('  Propósito: Reproducciones por perfil y rango de fecha');
    DBMS_OUTPUT.PUT_LINE('');
    
    DBMS_OUTPUT.PUT_LINE('? ÍNDICE 2: IDX_USUARIO_EMAIL');
    DBMS_OUTPUT.PUT_LINE('  Columnas: UPPER(email)');
    DBMS_OUTPUT.PUT_LINE('  Propósito: Búsqueda rápida de usuario por email');
    DBMS_OUTPUT.PUT_LINE('');
    
    DBMS_OUTPUT.PUT_LINE('? ÍNDICE 3: IDX_CONTENIDO_TIPO_ANNO');
    DBMS_OUTPUT.PUT_LINE('  Columnas: tipo_contenido, ano_lanzamiento DESC');
    DBMS_OUTPUT.PUT_LINE('  Propósito: Filtros por tipo y año de contenido');
    DBMS_OUTPUT.PUT_LINE('');
    
    DBMS_OUTPUT.PUT_LINE('? ÍNDICE 4: IDX_PAGO_SUSCRIPCION_ESTADO');
    DBMS_OUTPUT.PUT_LINE('  Columnas: id_suscripcion, estado, fecha_pago DESC');
    DBMS_OUTPUT.PUT_LINE('  Propósito: Reportes de pagos por suscripción y estado');
    DBMS_OUTPUT.PUT_LINE('');
    
    DBMS_OUTPUT.PUT_LINE('Total índices creados: ' || v_idx_count);
END;
/

PROMPT ============================================================================
PROMPT REQUISITO 3.4.1: 4 ÍNDICES ?
PROMPT REQUISITO 3.4.2: EXPLAIN PLAN (ANTES/DESPUÉS) ?
PROMPT ============================================================================