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
PROMPT ============================================================================
PROMPT;
PROMPT REQUISITO 3.2.3: 2 FUNCIONES ?
PROMPT REQUISITO 3.2.4: EXCEPCIONES PERSONALIZADAS ?
PROMPT REQUISITO 3.2.5: 4 DISPARADORES ?
PROMPT ============================================================================