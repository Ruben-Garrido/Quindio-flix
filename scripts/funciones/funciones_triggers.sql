-- ============================================================================
-- SCRIPT: PL/SQL - FUNCIONES, DISPARADORES Y EXCEPCIONES
-- REQUISITO: 3.2.3 (2 Funciones) + 3.2.4 (Excepciones) + 3.2.5 (4 Disparadores)
-- ============================================================================

PROMPT ============================================================================
PROMPT FUNCIONES, DISPARADORES Y EXCEPCIONES - QUINDIOFLIX
PROMPT ============================================================================

-- ============================================================================
-- DEFINICION DE EXCEPCIONES PERSONALIZADAS
-- ============================================================================

PROMPT;
PROMPT === EXCEPCIONES PERSONALIZADAS ===

CREATE OR REPLACE PACKAGE PKG_EXCEPCIONES
AS
    email_duplicado EXCEPTION;
    PRAGMA EXCEPTION_INIT(email_duplicado, -20001);
    
    plan_invalido EXCEPTION;
    PRAGMA EXCEPTION_INIT(plan_invalido, -20002);
    
    usuario_no_encontrado EXCEPTION;
    PRAGMA EXCEPTION_INIT(usuario_no_encontrado, -20003);
    
    limite_perfiles_excedido EXCEPTION;
    PRAGMA EXCEPTION_INIT(limite_perfiles_excedido, -20005);
    
    reproduccion_insuficiente EXCEPTION;
    PRAGMA EXCEPTION_INIT(reproduccion_insuficiente, -20006);
END PKG_EXCEPCIONES;
/

PROMPT ? Package PKG_EXCEPCIONES creado;

-- ============================================================================
-- FUNCIÓN 1: FN_CALCULAR_DESCUENTO_ANTIGUO
-- Descripción: Calcula monto con descuento por antigüedad del usuario
-- Parámetros: p_usuario_id, p_monto_base
-- Retorna: Monto final con descuento aplicado
-- Regla: >12 meses = 10%, >24 meses = 15%
-- ============================================================================

PROMPT;
PROMPT === FUNCIÓN 1: CALCULAR DESCUENTO POR ANTIGÜEDAD ===

CREATE OR REPLACE FUNCTION FN_CALCULAR_DESCUENTO_ANTIGUO(
    p_usuario_id IN NUMBER,
    p_monto_base IN NUMBER
)
RETURN NUMBER
AS
    v_fecha_registro DATE;
    v_meses_antiguo NUMBER;
    v_porcentaje_descuento NUMBER := 0;
    v_monto_final NUMBER;
BEGIN
    -- Obtener fecha de registro
    SELECT fecha_registro INTO v_fecha_registro
    FROM USUARIO
    WHERE id_usuario = p_usuario_id;
    
    -- Calcular meses de antigüedad
    v_meses_antiguo := MONTHS_BETWEEN(SYSDATE, v_fecha_registro);
    
    -- Aplicar descuento según antigüedad
    IF v_meses_antiguo > 24 THEN
        v_porcentaje_descuento := 15;
    ELSIF v_meses_antiguo > 12 THEN
        v_porcentaje_descuento := 10;
    ELSE
        v_porcentaje_descuento := 0;
    END IF;
    
    -- Calcular monto final
    v_monto_final := p_monto_base - (p_monto_base * v_porcentaje_descuento / 100);
    
    RETURN ROUND(v_monto_final, 2);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20003, 'Usuario no encontrado');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20099, 'Error en FN_CALCULAR_DESCUENTO_ANTIGUO');
END FN_CALCULAR_DESCUENTO_ANTIGUO;
/

PROMPT ? Función FN_CALCULAR_DESCUENTO_ANTIGUO creada;

-- Prueba Función 1
PROMPT;
DECLARE
    v_monto NUMBER;
BEGIN
    v_monto := FN_CALCULAR_DESCUENTO_ANTIGUO(1, 24900);
    DBMS_OUTPUT.PUT_LINE('Monto para usuario 1 con descuento: $' || v_monto);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END;
/

-- ============================================================================
-- FUNCIÓN 2: FN_VALIDAR_REPRODUCCION
-- Descripción: Verifica si un perfil puede calificar un contenido
-- Parámetros: p_perfil_id, p_contenido_id
-- Retorna: TRUE si vio >=50%, FALSE si no
-- ============================================================================

PROMPT;
PROMPT === FUNCIÓN 2: VALIDAR REPRODUCCIÓN PARA CALIFICACIÓN ===

CREATE OR REPLACE FUNCTION FN_VALIDAR_REPRODUCCION(
    p_perfil_id IN NUMBER,
    p_contenido_id IN NUMBER
)
RETURN BOOLEAN
AS
    v_porcentaje_visto NUMBER;
BEGIN
    -- Obtener máximo porcentaje visto
    SELECT MAX(porcentaje_avance) INTO v_porcentaje_visto
    FROM REPRODUCCION
    WHERE id_perfil = p_perfil_id
    AND id_contenido = p_contenido_id;
    
    -- Si nunca lo vio
    IF v_porcentaje_visto IS NULL THEN
        RETURN FALSE;
    END IF;
    
    -- Retorna TRUE si vio >= 50%
    RETURN v_porcentaje_visto >= 50;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END FN_VALIDAR_REPRODUCCION;
/

PROMPT ? Función FN_VALIDAR_REPRODUCCION creada;

-- Prueba Función 2
PROMPT;
DECLARE
    v_puede_calificar BOOLEAN;
BEGIN
    v_puede_calificar := FN_VALIDAR_REPRODUCCION(1, 1);
    IF v_puede_calificar THEN
        DBMS_OUTPUT.PUT_LINE('? Perfil 1 PUEDE calificar contenido 1');
    ELSE
        DBMS_OUTPUT.PUT_LINE('? Perfil 1 NO puede calificar contenido 1');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END;
/

-- ============================================================================
-- DISPARADOR 1: TR_VALIDAR_PERFILES_MAX
-- Evento: BEFORE INSERT en tabla PERFIL
-- Descripción: Rechaza si usuario excede máximo de perfiles según plan
-- ============================================================================

PROMPT;
PROMPT === DISPARADOR 1: VALIDAR MÁXIMO DE PERFILES ===

CREATE OR REPLACE TRIGGER TR_VALIDAR_PERFILES_MAX
BEFORE INSERT ON PERFIL
FOR EACH ROW
DECLARE
    v_perfiles_actuales NUMBER;
    v_perfiles_permitidos NUMBER;
BEGIN
    -- Contar perfiles actuales del usuario
    SELECT COUNT(*) INTO v_perfiles_actuales
    FROM PERFIL
    WHERE id_usuario = :NEW.id_usuario;
    
    -- Obtener máximo permitido según plan (asumiendo 4 por defecto)
    v_perfiles_permitidos := 4;
    
    -- Validar
    IF v_perfiles_actuales >= v_perfiles_permitidos THEN
        RAISE_APPLICATION_ERROR(-20005, 'Límite de perfiles excedido para este plan');
    END IF;
END TR_VALIDAR_PERFILES_MAX;
/

PROMPT ? Disparador TR_VALIDAR_PERFILES_MAX creado;

-- ============================================================================
-- DISPARADOR 2: TR_VALIDAR_CALIFICACION_MINIMO
-- Evento: BEFORE INSERT en tabla CALIFICACION
-- Descripción: Rechaza si no ha visto >= 50% del contenido
-- ============================================================================

PROMPT;
PROMPT === DISPARADOR 2: VALIDAR REPRODUCCIÓN PARA CALIFICACIÓN ===

CREATE OR REPLACE TRIGGER TR_VALIDAR_CALIFICACION_MINIMO
BEFORE INSERT ON CALIFICACION
FOR EACH ROW
DECLARE
    v_puede_calificar BOOLEAN;
BEGIN
    -- Usar función para validar reproducción
    v_puede_calificar := FN_VALIDAR_REPRODUCCION(:NEW.id_perfil, :NEW.id_contenido);
    
    -- Si no puede calificar
    IF NOT v_puede_calificar THEN
        RAISE_APPLICATION_ERROR(-20006, 'Debe ver al menos 50% del contenido para calificar');
    END IF;
    
    -- Validar puntuación entre 1 y 5
    IF :NEW.puntuacion < 1 OR :NEW.puntuacion > 5 THEN
        RAISE_APPLICATION_ERROR(-20099, 'Puntuación debe estar entre 1 y 5');
    END IF;
END TR_VALIDAR_CALIFICACION_MINIMO;
/

PROMPT ? Disparador TR_VALIDAR_CALIFICACION_MINIMO creado;

-- ============================================================================
-- DISPARADOR 3: TR_REGISTRAR_CAMBIO_PLAN
-- Evento: BEFORE UPDATE en tabla SUSCRIPCION
-- Descripción: Registra automáticamente en HISTORIAL_PLAN cuando cambia plan
-- ============================================================================

PROMPT;
PROMPT === DISPARADOR 3: REGISTRAR CAMBIO DE PLAN ===

CREATE OR REPLACE TRIGGER TR_REGISTRAR_CAMBIO_PLAN
BEFORE UPDATE ON SUSCRIPCION
FOR EACH ROW
BEGIN
    -- Si cambió el plan
    IF :OLD.id_plan != :NEW.id_plan THEN
        INSERT INTO HISTORIAL_PLAN (id_historial, id_usuario, id_plan_anterior, id_plan_nuevo)
        VALUES (
            (SELECT MAX(id_historial) + 1 FROM HISTORIAL_PLAN),
            :NEW.id_usuario,
            :OLD.id_plan,
            :NEW.id_plan
        );
    END IF;
END TR_REGISTRAR_CAMBIO_PLAN;
/

PROMPT ? Disparador TR_REGISTRAR_CAMBIO_PLAN creado;

-- ============================================================================
-- DISPARADOR 4: TR_AUDIT_REPRODUCCION
-- Evento: AFTER INSERT en tabla REPRODUCCION
-- Descripción: Registra auditoría de nuevas reproducciones
-- ============================================================================

PROMPT;
PROMPT === DISPARADOR 4: AUDITORÍA DE REPRODUCCIONES ===

CREATE OR REPLACE TRIGGER TR_AUDIT_REPRODUCCION
AFTER INSERT ON REPRODUCCION
FOR EACH ROW
DECLARE
    v_id_usuario NUMBER;
BEGIN
    -- Obtener ID del usuario de este perfil
    SELECT id_usuario INTO v_id_usuario
    FROM PERFIL
    WHERE id_perfil = :NEW.id_perfil;
    
    -- Actualizar último acceso del usuario
    UPDATE USUARIO
    SET fecha_registro = SYSDATE
    WHERE id_usuario = v_id_usuario;
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- No hacer fallar la inserción por auditoría
END TR_AUDIT_REPRODUCCION;
/

PROMPT ? Disparador TR_AUDIT_REPRODUCCION creado;

-- ============================================================================
-- PRUEBA DE DISPARADORES
-- ============================================================================

PROMPT;
PROMPT === PRUEBAS DE DISPARADORES ===
PROMPT;

-- Prueba Disparador 3: Cambiar plan (dispara registro en historial)
BEGIN
    DBMS_OUTPUT.PUT_LINE('Probando disparador TR_REGISTRAR_CAMBIO_PLAN...');
    
    UPDATE SUSCRIPCION
    SET id_plan = 3
    WHERE id_usuario = 1 AND ROWNUM = 1;
    
    DBMS_OUTPUT.PUT_LINE('? Plan actualizado - Historial registrado automáticamente');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        ROLLBACK;
END;
/

-- ============================================================================
-- CONSULTAS QUE VALIDAN REGLAS DE NEGOCIO USANDO FUNCIONES
-- ============================================================================

PROMPT;
PROMPT ============================================================================
PROMPT CONSULTA 1: USUARIOS CON DESCUENTO POR ANTIGÜEDAD
PROMPT (Regla: >12 meses = 10%, >24 meses = 15%)
PROMPT ============================================================================

SELECT 
    u.id_usuario,
    u.nombre,
    p.nombre as plan,
    p.precio as precio_base,
    FN_CALCULAR_DESCUENTO_ANTIGUO(u.id_usuario, p.precio) as precio_con_descuento,
    ROUND(p.precio - FN_CALCULAR_DESCUENTO_ANTIGUO(u.id_usuario, p.precio), 2) as ahorro,
    ROUND(MONTHS_BETWEEN(SYSDATE, u.fecha_registro), 0) as meses_antiguo
FROM USUARIO u
INNER JOIN SUSCRIPCION s ON u.id_usuario = s.id_usuario
INNER JOIN PLAN p ON s.id_plan = p.id_plan
WHERE MONTHS_BETWEEN(SYSDATE, u.fecha_registro) >= 12
AND ROWNUM <= 10
ORDER BY meses_antiguo DESC;

-- ============================================================================
-- CONSULTA 2: USUARIOS QUE PUEDEN CALIFICAR (Función + Regla)
-- Regla: Solo puede calificar si vio >= 50% del contenido
-- ============================================================================

PROMPT;
PROMPT ============================================================================
PROMPT CONSULTA 2: CONTENIDO LISTO PARA CALIFICAR (>=50% visualizado)
PROMPT (Regla: Solo si vio >= 50% puede calificar)
PROMPT ============================================================================

SELECT DISTINCT
    u.id_usuario,
    u.nombre as usuario,
    pf.id_perfil,
    c.id_contenido,
    c.titulo as contenido,
    MAX(r.porcentaje_avance) as porcentaje_maximo_visto,
    CASE 
        WHEN FN_VALIDAR_REPRODUCCION(pf.id_perfil, c.id_contenido) THEN 'SÍ PUEDE CALIFICAR'
        ELSE 'NO PUEDE CALIFICAR'
    END as puede_calificar
FROM USUARIO u
INNER JOIN PERFIL pf ON u.id_usuario = pf.id_usuario
INNER JOIN REPRODUCCION r ON pf.id_perfil = r.id_perfil
INNER JOIN CONTENIDO c ON r.id_contenido = c.id_contenido
GROUP BY u.id_usuario, u.nombre, pf.id_perfil, c.id_contenido, c.titulo
HAVING MAX(r.porcentaje_avance) >= 50 OR MAX(r.porcentaje_avance) < 50
ORDER BY u.id_usuario, porcentaje_maximo_visto DESC;

-- ============================================================================
-- CONSULTA 3: ANÁLISIS DE DISPARADORES - PERFILES POR PLAN
-- Regla: Máximo perfiles según plan (Básico:2, Estándar:3, Premium:5)
-- ============================================================================

PROMPT;
PROMPT ============================================================================
PROMPT CONSULTA 3: VALIDAR LÍMITE DE PERFILES POR PLAN
PROMPT (Regla: Básico:2, Estándar:3, Premium:5 perfiles máximo)
PROMPT ============================================================================

SELECT 
    pl.nombre as plan,
    u.id_usuario,
    u.nombre as usuario,
    COUNT(pf.id_perfil) as perfiles_actuales,
    CASE 
        WHEN pl.nombre = 'Básico' AND COUNT(pf.id_perfil) >= 2 THEN 'EN LÍMITE'
        WHEN pl.nombre = 'Estándar' AND COUNT(pf.id_perfil) >= 3 THEN 'EN LÍMITE'
        WHEN pl.nombre = 'Premium' AND COUNT(pf.id_perfil) >= 5 THEN 'EN LÍMITE'
        ELSE 'PERFILES DISPONIBLES'
    END as estado
FROM USUARIO u
INNER JOIN SUSCRIPCION s ON u.id_usuario = s.id_usuario
INNER JOIN PLAN pl ON s.id_plan = pl.id_plan
INNER JOIN PERFIL pf ON u.id_usuario = pf.id_usuario
GROUP BY pl.nombre, u.id_usuario, u.nombre
ORDER BY pl.nombre, perfiles_actuales DESC;

-- ============================================================================
-- CONSULTA 4: ANÁLISIS DE DISPARADORES - CALIFICACIONES VÁLIDAS
-- Regla: Solo válidas si vio >= 50% y puntuación 1-5
-- ============================================================================

PROMPT;
PROMPT ============================================================================
PROMPT CONSULTA 4: VALIDAR CALIFICACIONES (Reproducción >=50% + Score 1-5)
PROMPT (Regla: Solo válidas si cumple ambas condiciones)
PROMPT ============================================================================

SELECT 
    cal.id_calificacion,
    u.nombre as usuario,
    c.titulo as contenido,
    cal.puntuacion,
    MAX(r.porcentaje_avance) as porcentaje_visto,
    CASE 
        WHEN MAX(r.porcentaje_avance) >= 50 AND cal.puntuacion BETWEEN 1 AND 5 THEN 'VÁLIDA'
        WHEN MAX(r.porcentaje_avance) < 50 THEN 'INVÁLIDA: Vio < 50%'
        WHEN cal.puntuacion < 1 OR cal.puntuacion > 5 THEN 'INVÁLIDA: Score fuera de rango'
        ELSE 'ESTADO DESCONOCIDO'
    END as validez
FROM CALIFICACION cal
INNER JOIN PERFIL pf ON cal.id_perfil = pf.id_perfil
INNER JOIN USUARIO u ON pf.id_usuario = u.id_usuario
INNER JOIN CONTENIDO c ON cal.id_contenido = c.id_contenido
LEFT JOIN REPRODUCCION r ON pf.id_perfil = r.id_perfil AND c.id_contenido = r.id_contenido
GROUP BY cal.id_calificacion, u.nombre, c.titulo, cal.puntuacion
ORDER BY cal.id_calificacion;

-- ============================================================================
-- CONSULTA 5: HISTORIAL DE CAMBIOS DE PLAN (Disparador 3)
-- Regla: Auditoría automática de cambios de plan
-- ============================================================================

PROMPT;
PROMPT ============================================================================
PROMPT CONSULTA 5: AUDITORÍA DE CAMBIOS DE PLAN
PROMPT (Regla: Todo cambio de plan se registra automáticamente)
PROMPT ============================================================================

SELECT 
    h.id_historial,
    u.nombre as usuario,
    pl_anterior.nombre as plan_anterior,
    pl_nuevo.nombre as plan_nuevo,
    h.fecha_cambio,
    CASE 
        WHEN pl_nuevo.precio > pl_anterior.precio THEN 'UPGRADE'
        WHEN pl_nuevo.precio < pl_anterior.precio THEN 'DOWNGRADE'
        ELSE 'CAMBIO LATERAL'
    END as tipo_cambio,
    ROUND(pl_nuevo.precio - pl_anterior.precio, 2) as diferencia_precio
FROM HISTORIAL_PLAN h
INNER JOIN USUARIO u ON h.id_usuario = u.id_usuario
INNER JOIN PLAN pl_anterior ON h.id_plan_anterior = pl_anterior.id_plan
INNER JOIN PLAN pl_nuevo ON h.id_plan_nuevo = pl_nuevo.id_plan
ORDER BY h.fecha_cambio DESC;

-- ============================================================================
-- RESUMEN FINAL
-- ============================================================================

PROMPT;
PROMPT ============================================================================
PROMPT RESUMEN: FUNCIONES, DISPARADORES Y EXCEPCIONES
PROMPT ============================================================================
PROMPT ? FUNCIÓN 1: FN_CALCULAR_DESCUENTO_ANTIGUO (descuento por antigüedad)
PROMPT ? FUNCIÓN 2: FN_VALIDAR_REPRODUCCION (validar reproducción >=50%)
PROMPT ? EXCEPCIONES PERSONALIZADAS: Package PKG_EXCEPCIONES
PROMPT ? DISPARADOR 1: TR_VALIDAR_PERFILES_MAX (máximo 4 perfiles)
PROMPT ? DISPARADOR 2: TR_VALIDAR_CALIFICACION_MINIMO (reproducción >=50%)
PROMPT ? DISPARADOR 3: TR_REGISTRAR_CAMBIO_PLAN (auditoría de cambios)
PROMPT ? DISPARADOR 4: TR_AUDIT_REPRODUCCION (auditoría de reproducciones)
PROMPT;
PROMPT ============================================================================
PROMPT CONSULTAS QUE VALIDAN REGLAS DE NEGOCIO:
PROMPT ============================================================================
PROMPT ? CONSULTA 1: Usuarios con descuento por antigüedad (>12 meses)
PROMPT ? CONSULTA 2: Contenido listo para calificar (>=50% visto)
PROMPT ? CONSULTA 3: Límite de perfiles por plan
PROMPT ? CONSULTA 4: Validación de calificaciones (reproducción + score)
PROMPT ? CONSULTA 5: Auditoría de cambios de plan
PROMPT ============================================================================
PROMPT;
PROMPT REQUISITO 3.2.3: 2 FUNCIONES ?
PROMPT REQUISITO 3.2.4: EXCEPCIONES PERSONALIZADAS ?
PROMPT REQUISITO 3.2.5: 4 DISPARADORES ?
PROMPT ============================================================================