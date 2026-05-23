-- ============================================================================
-- SCRIPT: GROUP BY AVANZADO - ROLLUP, CUBE, GROUPING SETS
-- REQUISITO: 3.1.3 Funciones avanzadas del GROUP BY (minimo 3)
-- ============================================================================

PROMPT ============================================================================
PROMPT GROUP BY AVANZADO - QUINDIOFLIX
PROMPT ============================================================================

-- ============================================================================
-- ROLLUP 1: INGRESOS POR CIUDAD Y PLAN CON SUBTOTALES
-- Descripción: Reporte jerárquico de ingresos con subtotales por ciudad 
--              y gran total general
-- Propósito: Análisis financiero por región y tipo de suscripción
-- ============================================================================

PROMPT;
PROMPT === ROLLUP: INGRESOS POR CIUDAD Y PLAN CON SUBTOTALES ===
PROMPT Jerárquico: Total General > Subtotales por Ciudad > Detalles por Plan;
PROMPT;

SELECT 
    CASE 
        WHEN GROUPING(c.nombre) = 1 THEN 'TOTAL GENERAL'
        WHEN GROUPING(p.nombre) = 1 THEN '  Subtotal: ' || c.nombre
        ELSE c.nombre
    END as ciudad,
    CASE 
        WHEN GROUPING(p.nombre) = 1 THEN '(Todos los planes)'
        ELSE p.nombre
    END as plan,
    COUNT(DISTINCT u.id_usuario) as usuarios,
    COUNT(DISTINCT p2.id_pago) as cantidad_pagos,
    SUM(p2.monto) as ingresos_totales,
    ROUND(AVG(p2.monto), 2) as ingreso_promedio
FROM PAGO p2
INNER JOIN SUSCRIPCION s ON p2.id_suscripcion = s.id_suscripcion
INNER JOIN USUARIO u ON s.id_usuario = u.id_usuario
INNER JOIN CIUDAD c ON u.id_ciudad = c.id_ciudad
INNER JOIN PLAN p ON s.id_plan = p.id_plan
WHERE p2.estado = 'EXITOSO'
GROUP BY ROLLUP(c.nombre, p.nombre)
ORDER BY c.nombre, p.nombre;

PROMPT;
PROMPT ? ROLLUP completado - Ingresos con subtotales jerárquicos;

-- ============================================================================
-- CUBE 1: REPRODUCCIONES POR TIPO CONTENIDO Y DISPOSITIVO (TODAS LAS COMBINACIONES)
-- Descripción: Reporte N-dimensional con TODAS las combinaciones posibles
-- Propósito: Análisis cruzado completo de reproducciones
-- ============================================================================

PROMPT;
PROMPT === CUBE: REPRODUCCIONES POR TIPO CONTENIDO Y DISPOSITIVO ===
PROMPT N-Dimensional: Todas las combinaciones posibles de Tipo x Dispositivo;
PROMPT;

SELECT 
    CASE 
        WHEN GROUPING(c.tipo_contenido) = 1 THEN 'TOTAL GENERAL'
        ELSE c.tipo_contenido
    END as tipo_contenido,
    CASE 
        WHEN GROUPING(d.nombre) = 1 THEN '(Todos los dispositivos)'
        ELSE d.nombre
    END as dispositivo,
    COUNT(r.id_reproduccion) as total_reproducciones,
    COUNT(DISTINCT r.id_perfil) as perfiles_unicos,
    ROUND(AVG(r.porcentaje_avance), 2) as porcentaje_promedio
FROM REPRODUCCION r
INNER JOIN CONTENIDO c ON r.id_contenido = c.id_contenido
INNER JOIN DISPOSITIVO d ON r.id_dispositivo = d.id_dispositivo
GROUP BY CUBE(c.tipo_contenido, d.nombre)
ORDER BY 
    CASE WHEN GROUPING(c.tipo_contenido) = 1 THEN 1 ELSE 0 END DESC,
    c.tipo_contenido,
    CASE WHEN GROUPING(d.nombre) = 1 THEN 1 ELSE 0 END DESC,
    d.nombre;

PROMPT;
PROMPT ? CUBE completado - Reproducciones en todas las combinaciones;

-- ============================================================================
-- GROUPING SETS 1: TOTALES POR CATEGORÍA Y POR CIUDAD (SIN CRUCE)
-- Descripción: Mostrar SOLO los totales por categoría y SOLO por ciudad
--              SIN las combinaciones cruzadas
-- Propósito: Análisis selectivo de totales independientes
-- ============================================================================

PROMPT;
PROMPT === GROUPING SETS: TOTALES POR CATEGORÍA Y CIUDAD (INDEPENDIENTES) ===
PROMPT Selectivo: Solo totales por Tipo de Contenido OU totales por Ciudad;
PROMPT;

SELECT 
    CASE 
        WHEN GROUPING(c.tipo_contenido) = 0 THEN 'Por Tipo: ' || c.tipo_contenido
        WHEN GROUPING(ci.nombre) = 0 THEN 'Por Ciudad: ' || ci.nombre
    END as agrupacion,
    COUNT(DISTINCT r.id_reproduccion) as total_reproducciones,
    COUNT(DISTINCT u.id_usuario) as usuarios_unicos,
    ROUND(AVG(r.porcentaje_avance), 2) as porcentaje_promedio
FROM REPRODUCCION r
INNER JOIN PERFIL pf ON r.id_perfil = pf.id_perfil
INNER JOIN USUARIO u ON pf.id_usuario = u.id_usuario
INNER JOIN CIUDAD ci ON u.id_ciudad = ci.id_ciudad
INNER JOIN CONTENIDO c ON r.id_contenido = c.id_contenido
GROUP BY GROUPING SETS(c.tipo_contenido, ci.nombre)
ORDER BY agrupacion;

PROMPT;
PROMPT ? GROUPING SETS completado - Totales independientes;

-- ============================================================================
-- COMPARACIÓN: ROLLUP vs CUBE vs GROUPING SETS
-- ============================================================================

PROMPT;
PROMPT === COMPARACIÓN DE RESULTADOS ===
PROMPT;
PROMPT ROLLUP: Genera N+1 grupos (jerárquico, de arriba hacia abajo);
PROMPT         Ejemplo: (Ciudad, Plan) ? Total General, Subtotales Ciudad, Detalles Plan;
PROMPT;
PROMPT CUBE: Genera 2^N grupos (TODAS las combinaciones);
PROMPT       Ejemplo: (Tipo, Dispositivo) ? Totales Tipo, Totales Dispositivo, Total General;
PROMPT;
PROMPT GROUPING SETS: Genera exactamente lo que especifiques;
PROMPT              Ejemplo: Solo Totales Tipo OU Solo Totales Ciudad;
PROMPT;

-- ============================================================================
-- RESUMEN FINAL
-- ============================================================================

PROMPT;
PROMPT ============================================================================
PROMPT RESUMEN DE GROUP BY AVANZADO:
PROMPT ============================================================================
PROMPT ? ROLLUP (1): Ingresos con subtotales jerárquicos
PROMPT ? CUBE (1): Reproducciones en todas las combinaciones
PROMPT ? GROUPING SETS (1): Totales independientes por categoría y ciudad
PROMPT ============================================================================
PROMPT;
PROMPT REQUISITO 3.1.3 COMPLETADO: ROLLUP + CUBE + GROUPING SETS
PROMPT ============================================================================