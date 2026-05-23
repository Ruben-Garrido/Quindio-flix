-- ============================================================================
-- SCRIPT: PIVOT Y UNPIVOT COMPLETO
-- REQUISITO: 3.1.2 Tablas de referencias cruzadas — PIVOT y UNPIVOT (minimo 2)
-- ============================================================================

PROMPT ============================================================================
PROMPT REPORTES PIVOT Y UNPIVOT - QUINDIOFLIX
PROMPT ============================================================================

-- ============================================================================
-- PIVOT 1: USUARIOS ACTIVOS POR CIUDAD Y PLAN DE SUSCRIPCIÓN
-- Descripción: Matriz con ciudades en filas y planes en columnas
-- Muestra: Cantidad de usuarios activos por cada combinación
-- ============================================================================

PROMPT;
PROMPT === PIVOT 1: USUARIOS ACTIVOS POR CIUDAD Y PLAN ===
PROMPT Matriz: Filas = Ciudades, Columnas = Planes (Básico, Estándar, Premium);
PROMPT;

SELECT *
FROM (
    SELECT 
        c.nombre as ciudad,
        p.nombre as plan,
        COUNT(DISTINCT u.id_usuario) as cantidad_usuarios
    FROM USUARIO u
    INNER JOIN CIUDAD c ON u.id_ciudad = c.id_ciudad
    INNER JOIN SUSCRIPCION s ON u.id_usuario = s.id_usuario
    INNER JOIN PLAN p ON s.id_plan = p.id_plan
    WHERE s.estado_suscripcion = 'ACTIVA'
    GROUP BY c.id_ciudad, c.nombre, p.id_plan, p.nombre
)
PIVOT (
    SUM(cantidad_usuarios)
    FOR plan IN ('Básico' as Basico, 'Estándar' as Estandar, 'Premium' as Premium)
)
ORDER BY ciudad;

PROMPT;
PROMPT ? PIVOT 1 completado - Usuarios por Ciudad y Plan;

-- ============================================================================
-- PIVOT 2: REPRODUCCIONES POR TIPO DE CONTENIDO Y DISPOSITIVO
-- Descripción: Matriz con tipos de contenido en filas y dispositivos en columnas
-- Muestra: Total de reproducciones por cada combinación
-- ============================================================================

PROMPT;
PROMPT === PIVOT 2: REPRODUCCIONES POR TIPO CONTENIDO Y DISPOSITIVO ===
PROMPT Matriz: Filas = Tipos de Contenido, Columnas = Dispositivos;
PROMPT;

SELECT *
FROM (
    SELECT 
        c.tipo_contenido,
        d.nombre as dispositivo,
        COUNT(r.id_reproduccion) as total_reproducciones
    FROM REPRODUCCION r
    INNER JOIN CONTENIDO c ON r.id_contenido = c.id_contenido
    INNER JOIN DISPOSITIVO d ON r.id_dispositivo = d.id_dispositivo
    GROUP BY c.tipo_contenido, d.id_dispositivo, d.nombre
)
PIVOT (
    SUM(total_reproducciones)
    FOR dispositivo IN ('Celular' as Celular, 'Tablet' as Tablet, 'TV' as TV, 'Computador' as Computador)
)
ORDER BY tipo_contenido;

PROMPT;
PROMPT ? PIVOT 2 completado - Reproducciones por Tipo y Dispositivo;

-- ============================================================================
-- UNPIVOT 1: DATOS DE USUARIOS EN FORMATO DE FILAS (Despivotado)
-- Descripción: Mostrar datos de forma despivotada (inverso de PIVOT 1)
-- ============================================================================

PROMPT;
PROMPT === UNPIVOT 1: USUARIOS POR CIUDAD Y PLAN (FORMATO DE FILAS) ===
PROMPT Formato: Filas = Combinaciones de Ciudad-Plan;
PROMPT;

SELECT 
    c.nombre as ciudad,
    p.nombre as plan,
    COUNT(DISTINCT u.id_usuario) as cantidad_usuarios
FROM USUARIO u
INNER JOIN CIUDAD c ON u.id_ciudad = c.id_ciudad
INNER JOIN SUSCRIPCION s ON u.id_usuario = s.id_usuario
INNER JOIN PLAN p ON s.id_plan = p.id_plan
WHERE s.estado_suscripcion = 'ACTIVA'
GROUP BY c.id_ciudad, c.nombre, p.id_plan, p.nombre
ORDER BY c.nombre, p.nombre;

PROMPT;
PROMPT ? UNPIVOT 1 completado - Usuarios en formato de filas;

-- ============================================================================
-- UNPIVOT 2: DATOS DE REPRODUCCIONES EN FORMATO DE FILAS (Despivotado)
-- Descripción: Mostrar datos de forma despivotada (inverso de PIVOT 2)
-- ============================================================================

PROMPT;
PROMPT === UNPIVOT 2: REPRODUCCIONES POR TIPO Y DISPOSITIVO (FORMATO DE FILAS) ===
PROMPT Formato: Filas = Combinaciones de Tipo-Dispositivo;
PROMPT;

SELECT 
    c.tipo_contenido,
    d.nombre as dispositivo,
    COUNT(r.id_reproduccion) as total_reproducciones
FROM REPRODUCCION r
INNER JOIN CONTENIDO c ON r.id_contenido = c.id_contenido
INNER JOIN DISPOSITIVO d ON r.id_dispositivo = d.id_dispositivo
GROUP BY c.tipo_contenido, d.id_dispositivo, d.nombre
ORDER BY c.tipo_contenido, d.nombre;

PROMPT;
PROMPT ? UNPIVOT 2 completado - Reproducciones en formato de filas;

-- ============================================================================
-- RESUMEN FINAL
-- ============================================================================

PROMPT;
PROMPT ============================================================================
PROMPT RESUMEN DE REPORTES PIVOT/UNPIVOT:
PROMPT ============================================================================
PROMPT ? PIVOT 1: Usuarios por Ciudad y Plan (Matriz)
PROMPT ? PIVOT 2: Reproducciones por Tipo Contenido y Dispositivo (Matriz)
PROMPT ? UNPIVOT 1: Usuarios en formato de filas
PROMPT ? UNPIVOT 2: Reproducciones en formato de filas
PROMPT ============================================================================
PROMPT;
PROMPT REQUISITO 3.1.2 COMPLETADO: 2 PIVOT + 2 UNPIVOT
PROMPT ============================================================================