-- ============================================================================
-- SCRIPT: 3 CONSULTAS PARAMETRIZADAS CON VARIABLES DE SUSTITUCIÓN
-- REQUISITO: 3.1.1 Consultas parametrizadas (mínimo 3)
-- COMPATIBLE: Oracle XE
-- NOTA: Usando && para pedir parámetros UNA SOLA VEZ
-- ============================================================================

PROMPT ============================================================================
PROMPT CONSULTAS PARAMETRIZADAS - QUINDIOFLIX
PROMPT ============================================================================

-- ============================================================================
-- SOLICITAR PARÁMETROS AL INICIO (SOLO UNA VEZ)
-- ============================================================================

PROMPT;
PROMPT === INGRESE LOS PARÁMETROS REQUERIDOS ===
ACCEPT ciudad PROMPT 'Ingrese la CIUDAD (Armenia, Bogotá, Medellín, Cali, Barranquilla): '
ACCEPT ano PROMPT 'Ingrese el AÑO (2024 o 2025): '
ACCEPT mes PROMPT 'Ingrese el MES (01-12): '
ACCEPT genero PROMPT 'Ingrese el GÉNERO (Acción, Drama, Comedia, etc.): '

-- ============================================================================
-- CONSULTA 1: TOP CONTENIDO MÁS REPRODUCIDO POR CIUDAD
-- ============================================================================

PROMPT;
PROMPT ============================================================================
PROMPT CONSULTA 1: TOP CONTENIDO MÁS REPRODUCIDO POR CIUDAD
PROMPT ============================================================================

SELECT 
    ciu.nombre as ciudad,
    c.titulo as contenido,
    c.tipo_contenido,
    COUNT(r.id_reproduccion) as total_reproducciones,
    COUNT(DISTINCT pf.id_perfil) as perfiles_unicos,
    ROUND(AVG(r.porcentaje_avance), 2) as porcentaje_promedio
FROM CIUDAD ciu
INNER JOIN USUARIO u ON ciu.id_ciudad = u.id_ciudad
INNER JOIN PERFIL pf ON u.id_usuario = pf.id_usuario
INNER JOIN REPRODUCCION r ON pf.id_perfil = r.id_perfil
INNER JOIN CONTENIDO c ON r.id_contenido = c.id_contenido
WHERE UPPER(ciu.nombre) = UPPER('&&ciudad')
GROUP BY ciu.nombre, c.id_contenido, c.titulo, c.tipo_contenido
HAVING COUNT(r.id_reproduccion) > 0
ORDER BY total_reproducciones DESC;

-- ============================================================================
-- CONSULTA 2: INGRESOS POR PLAN EN UN MES/AÑO ESPECÍFICO
-- ============================================================================

PROMPT;
PROMPT ============================================================================
PROMPT CONSULTA 2: INGRESOS POR PLAN EN UN MES/AÑO ESPECÍFICO
PROMPT ============================================================================

SELECT 
    pl.nombre as plan,
    pl.precio as valor_plan,
    COUNT(DISTINCT p.id_pago) as cantidad_pagos,
    SUM(p.monto) as ingresos_totales,
    ROUND(AVG(p.monto), 2) as ingreso_promedio,
    COUNT(CASE WHEN p.estado = 'EXITOSO' THEN 1 END) as pagos_exitosos,
    COUNT(CASE WHEN p.estado = 'FALLIDO' THEN 1 END) as pagos_fallidos,
    ROUND(100 * COUNT(CASE WHEN p.estado = 'EXITOSO' THEN 1 END) / 
          NULLIF(COUNT(p.id_pago), 0), 2) as tasa_exito_pct
FROM PAGO p
INNER JOIN SUSCRIPCION s ON p.id_suscripcion = s.id_suscripcion
INNER JOIN PLAN pl ON s.id_plan = pl.id_plan
WHERE EXTRACT(YEAR FROM p.fecha_pago) = &&ano
  AND EXTRACT(MONTH FROM p.fecha_pago) = &&mes
GROUP BY pl.id_plan, pl.nombre, pl.precio
ORDER BY ingresos_totales DESC;

-- ============================================================================
-- CONSULTA 3: ESTADÍSTICAS DE CALIFICACIÓN POR GÉNERO
-- ============================================================================

PROMPT;
PROMPT ============================================================================
PROMPT CONSULTA 3: ESTADÍSTICAS DE CALIFICACIÓN POR GÉNERO
PROMPT ============================================================================

SELECT 
    g.nombre as genero,
    COUNT(DISTINCT c.id_contenido) as cantidad_contenidos,
    COUNT(DISTINCT r.id_reproduccion) as total_reproducciones,
    COUNT(DISTINCT cal.id_calificacion) as total_calificaciones,
    ROUND(AVG(cal.puntuacion), 2) as calificacion_promedio,
    ROUND(MIN(cal.puntuacion), 2) as calificacion_minima,
    ROUND(MAX(cal.puntuacion), 2) as calificacion_maxima,
    ROUND(STDDEV(cal.puntuacion), 2) as desviacion_estandar
FROM GENERO g
LEFT JOIN CONTENIDO_GENERO cg ON g.id_genero = cg.id_genero
LEFT JOIN CONTENIDO c ON cg.id_contenido = c.id_contenido
LEFT JOIN REPRODUCCION r ON c.id_contenido = r.id_contenido
LEFT JOIN CALIFICACION cal ON c.id_contenido = cal.id_contenido
WHERE UPPER(g.nombre) = UPPER('&&genero')
GROUP BY g.id_genero, g.nombre
ORDER BY calificacion_promedio DESC;

-- ============================================================================
-- RESUMEN FINAL
-- ============================================================================

PROMPT;
PROMPT ============================================================================
PROMPT RESUMEN: 3 CONSULTAS PARAMETRIZADAS EJECUTADAS
PROMPT ============================================================================
PROMPT;
PROMPT REQUISITO 3.1.1: 3 CONSULTAS PARAMETRIZADAS ?
PROMPT - Consulta 1: TOP Contenido por Ciudad (parámetro: &&ciudad)
PROMPT - Consulta 2: Ingresos por Plan/Mes/Año (parámetros: &&ano, &&mes)
PROMPT - Consulta 3: Estadísticas por Género (parámetro: &&genero)
PROMPT;
PROMPT NOTA: Las variables se piden UNA SOLA VEZ al inicio
PROMPT ============================================================================