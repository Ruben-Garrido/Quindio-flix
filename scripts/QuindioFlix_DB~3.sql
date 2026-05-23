-- ============================================================================
-- SCRIPT: Consultar Ciudades con Reproducciones
-- PROPÓSITO: Ver qué ciudades tienen datos de reproducciones
-- ============================================================================

PROMPT ============================================================================
PROMPT ANÁLISIS DE CIUDADES CON REPRODUCCIONES
PROMPT ============================================================================

-- ============================================================================
-- 1. CIUDADES CON REPRODUCCIONES (cantidad)
-- ============================================================================

PROMPT;
PROMPT === CIUDADES CON REPRODUCCIONES - RESUMEN ===

SELECT 
    ciu.id_ciudad,
    ciu.nombre as ciudad,
    ciu.departamento,
    COUNT(DISTINCT u.id_usuario) as usuarios_activos,
    COUNT(DISTINCT pf.id_perfil) as perfiles_activos,
    COUNT(DISTINCT r.id_reproduccion) as total_reproducciones,
    ROUND(AVG(r.porcentaje_avance), 2) as porcentaje_promedio_visto
FROM CIUDAD ciu
LEFT JOIN USUARIO u ON ciu.id_ciudad = u.id_ciudad
LEFT JOIN PERFIL pf ON u.id_usuario = pf.id_usuario
LEFT JOIN REPRODUCCION r ON pf.id_perfil = r.id_perfil
GROUP BY ciu.id_ciudad, ciu.nombre, ciu.departamento
ORDER BY total_reproducciones DESC;

-- ============================================================================
-- 2. DETALLE: CONTENIDO MÁS VISTO POR CIUDAD
-- ============================================================================

PROMPT;
PROMPT === TOP 5 CONTENIDO MÁS VISTO POR CIUDAD ===

SELECT 
    ciu.nombre as ciudad,
    cont.titulo as contenido,
    cont.tipo_contenido,
    COUNT(r.id_reproduccion) as reproducciones
FROM REPRODUCCION r
INNER JOIN PERFIL pf ON r.id_perfil = pf.id_perfil
INNER JOIN USUARIO u ON pf.id_usuario = u.id_usuario
INNER JOIN CIUDAD ciu ON u.id_ciudad = ciu.id_ciudad
INNER JOIN CONTENIDO cont ON r.id_contenido = cont.id_contenido
GROUP BY ciu.nombre, cont.id_contenido, cont.titulo, cont.tipo_contenido
ORDER BY ciu.nombre, reproducciones DESC;

-- ============================================================================
-- 3. USUARIOS POR CIUDAD (para verificar qué ciudades tienen usuarios)
-- ============================================================================

PROMPT;
PROMPT === USUARIOS REGISTRADOS POR CIUDAD ===

SELECT 
    ciu.nombre as ciudad,
    COUNT(u.id_usuario) as total_usuarios,
    COUNT(DISTINCT s.id_suscripcion) as suscripciones_activas,
    COUNT(DISTINCT pf.id_perfil) as total_perfiles
FROM CIUDAD ciu
LEFT JOIN USUARIO u ON ciu.id_ciudad = u.id_ciudad
LEFT JOIN SUSCRIPCION s ON u.id_usuario = s.id_usuario
LEFT JOIN PERFIL pf ON u.id_usuario = pf.id_usuario
GROUP BY ciu.id_ciudad, ciu.nombre
ORDER BY total_usuarios DESC;

-- ============================================================================
-- 4. LISTAR TODAS LAS CIUDADES DISPONIBLES
-- ============================================================================

PROMPT;
PROMPT === TODAS LAS CIUDADES DISPONIBLES EN LA BD ===

SELECT 
    id_ciudad,
    nombre,
    departamento
FROM CIUDAD
ORDER BY nombre;

PROMPT;
PROMPT ============================================================================
PROMPT ANÁLISIS COMPLETADO
PROMPT ============================================================================