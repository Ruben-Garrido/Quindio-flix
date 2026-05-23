-- ============================================================================
-- SCRIPT: 3 Consultas Parametrizadas (VERSIÓN FINAL CORREGIDA)
-- REQUISITO: 3.1.1 Consultas parametrizadas (minimo 3)
-- ============================================================================

PROMPT ============================================================================
PROMPT CONSULTAS PARAMETRIZADAS - QUINDIOFLIX
PROMPT ============================================================================

-- ============================================================================
-- CONSULTA PARAMETRIZADA 1: TOP 10 CONTENIDO MÁS REPRODUCIDO POR CIUDAD
-- ============================================================================

PROMPT;
PROMPT === CONSULTA 1: TOP 10 CONTENIDO MÁS REPRODUCIDO POR CIUDAD ===
PROMPT Ingrese ciudad (Armenia, Bogotá, Medellín, Cali, Barranquilla):

SELECT 
    ciu.nombre as ciudad,
    cont.titulo as contenido,
    cont.tipo_contenido,
    COUNT(r.id_reproduccion) as total_reproducciones,
    COUNT(DISTINCT r.id_perfil) as perfiles_unicos,
    ROUND(AVG(r.porcentaje_avance), 2) as porcentaje_visto
FROM REPRODUCCION r
INNER JOIN PERFIL pf ON r.id_perfil = pf.id_perfil
INNER JOIN USUARIO u ON pf.id_usuario = u.id_usuario
INNER JOIN CIUDAD ciu ON u.id_ciudad = ciu.id_ciudad
INNER JOIN CONTENIDO cont ON r.id_contenido = cont.id_contenido
WHERE UPPER(ciu.nombre) = UPPER('&ciudad1')
GROUP BY ciu.id_ciudad, ciu.nombre, cont.id_contenido, cont.titulo, cont.tipo_contenido
ORDER BY total_reproducciones DESC
FETCH FIRST 10 ROWS ONLY;

-- ============================================================================
-- CONSULTA PARAMETRIZADA 2: INGRESOS POR PLAN EN MES/AÑO
-- ============================================================================

PROMPT;
PROMPT === CONSULTA 2: INGRESOS POR PLAN EN UN MES/AÑO ESPECÍFICO ===
PROMPT Ingrese el AÑO (2024 o 2025):

PROMPT Ingrese el MES (01-12):

SELECT 
    pl.nombre as plan,
    pl.precio as valor_plan,
    COUNT(DISTINCT p.id_pago) as cantidad_pagos,
    SUM(p.monto) as ingresos_totales,
    ROUND(AVG(p.monto), 2) as ingreso_promedio,
    COUNT(CASE WHEN p.estado = 'EXITOSO' THEN 1 END) as pagos_exitosos,
    COUNT(CASE WHEN p.estado = 'FALLIDO' THEN 1 END) as pagos_fallidos
FROM PAGO p
INNER JOIN SUSCRIPCION s ON p.id_suscripcion = s.id_suscripcion
INNER JOIN PLAN pl ON s.id_plan = pl.id_plan
WHERE EXTRACT(YEAR FROM p.fecha_pago) = &ano
  AND EXTRACT(MONTH FROM p.fecha_pago) = &mes
GROUP BY pl.id_plan, pl.nombre, pl.precio
ORDER BY ingresos_totales DESC;

-- ============================================================================
-- CONSULTA PARAMETRIZADA 3: CALIFICACIÓN PROMEDIO POR GÉNERO
-- ============================================================================

PROMPT;
PROMPT === CONSULTA 3: ESTADÍSTICAS DE CALIFICACIÓN POR GÉNERO ===
PROMPT Ingrese el género (Acción, Drama, Ciencia Ficción, Comedia, Suspenso, Terror, Romance, Infantil):

SELECT 
    g.nombre as genero,
    COUNT(DISTINCT cont.id_contenido) as cantidad_contenidos,
    COUNT(DISTINCT r.id_reproduccion) as total_reproducciones,
    COUNT(DISTINCT cal.id_calificacion) as total_calificaciones,
    ROUND(AVG(cal.puntuacion), 2) as calificacion_promedio,
    MIN(cal.puntuacion) as minima,
    MAX(cal.puntuacion) as maxima
FROM GENERO g
LEFT JOIN CONTENIDO_GENERO cg ON g.id_genero = cg.id_genero
LEFT JOIN CONTENIDO cont ON cg.id_contenido = cont.id_contenido
LEFT JOIN REPRODUCCION r ON cont.id_contenido = r.id_contenido
LEFT JOIN CALIFICACION cal ON cont.id_contenido = cal.id_contenido
WHERE UPPER(g.nombre) = UPPER('&genero')
GROUP BY g.id_genero, g.nombre;

PROMPT;
PROMPT ============================================================================
PROMPT 3 CONSULTAS PARAMETRIZADAS EJECUTADAS
PROMPT ============================================================================