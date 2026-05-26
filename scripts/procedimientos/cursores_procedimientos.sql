-- ============================================================================
-- SCRIPT: PL/SQL - CURSORES Y PROCEDIMIENTOS ALMACENADOS
-- REQUISITO: 3.2.1 (2 Cursores) + 3.2.2 (3 Procedimientos)
-- ============================================================================

PROMPT ============================================================================
PROMPT CURSORES Y PROCEDIMIENTOS ALMACENADOS - QUINDIOFLIX
PROMPT ============================================================================

-- ============================================================================
-- CURSOR 1: USUARIOS CON SUSCRIPCION VENCIDA
-- ============================================================================

PROMPT;
PROMPT === CURSOR 1: USUARIOS CON SUSCRIPCION VENCIDA ===

CREATE OR REPLACE PROCEDURE PROC_SUSCRIP_VENCIDAS
AS
    CURSOR cur_suscrip_vencidas IS
        SELECT 
            u.id_usuario,
            u.nombre as usuario_nombre,
            u.email,
            p.nombre as plan,
            s.fecha_vencimiento,
            TRUNC(SYSDATE - s.fecha_vencimiento) as dias_vencida
        FROM USUARIO u
        INNER JOIN SUSCRIPCION s ON u.id_usuario = s.id_usuario
        INNER JOIN PLAN p ON s.id_plan = p.id_plan
        WHERE s.fecha_vencimiento < TRUNC(SYSDATE)
        AND TRUNC(SYSDATE - s.fecha_vencimiento) > 30
        AND s.estado_suscripcion = 'ACTIVA';
    
    v_contador NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('USUARIOS CON SUSCRIPCION VENCIDA');
    DBMS_OUTPUT.PUT_LINE('========================================');
    
    FOR v_reg IN cur_suscrip_vencidas LOOP
        v_contador := v_contador + 1;
        DBMS_OUTPUT.PUT_LINE('Registro #' || v_contador || ': ' || v_reg.usuario_nombre || ' - Plan: ' || v_reg.plan);
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('TOTAL: ' || v_contador);
    DBMS_OUTPUT.PUT_LINE('========================================');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END PROC_SUSCRIP_VENCIDAS;
/

EXEC PROC_SUSCRIP_VENCIDAS;

-- ============================================================================
-- CURSOR 2: ACTUALIZAR POPULARIDAD DE CONTENIDO
-- ============================================================================

PROMPT;
PROMPT === CURSOR 2: ACTUALIZAR POPULARIDAD DE CONTENIDO ===

BEGIN
    DECLARE
        v_col_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_col_exists
        FROM user_tab_columns
        WHERE table_name = 'CONTENIDO' AND column_name = 'POPULARIDAD_SCORE';
        
        IF v_col_exists = 0 THEN
            EXECUTE IMMEDIATE 'ALTER TABLE CONTENIDO ADD (popularidad_score NUMBER DEFAULT 0, fecha_actualizado_popularidad DATE)';
            DBMS_OUTPUT.PUT_LINE('? Columnas agregadas');
        ELSE
            DBMS_OUTPUT.PUT_LINE('? Columnas ya existen');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN NULL;
    END;
END;
/

CREATE OR REPLACE PROCEDURE PROC_ACTUA_POPULARIDAD
AS
    CURSOR cur_contenido IS SELECT id_contenido, titulo FROM CONTENIDO;
    
    v_repro_completas NUMBER;
    v_repro_totales NUMBER;
    v_score NUMBER;
    v_cont NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('ACTUALIZANDO POPULARIDAD');
    DBMS_OUTPUT.PUT_LINE('========================================');
    
    FOR v_reg IN cur_contenido LOOP
        v_cont := v_cont + 1;
        
        SELECT COUNT(*) INTO v_repro_totales
        FROM REPRODUCCION
        WHERE id_contenido = v_reg.id_contenido;
        
        SELECT COUNT(*) INTO v_repro_completas
        FROM REPRODUCCION
        WHERE id_contenido = v_reg.id_contenido AND porcentaje_avance >= 90;
        
        IF v_repro_totales > 0 THEN
            v_score := ROUND(100 * v_repro_completas / v_repro_totales, 2);
        ELSE
            v_score := 0;
        END IF;
        
        UPDATE CONTENIDO
        SET popularidad_score = v_score, fecha_actualizado_popularidad = SYSDATE
        WHERE id_contenido = v_reg.id_contenido;
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Procesados: ' || v_cont);
    DBMS_OUTPUT.PUT_LINE('? COMMIT completado');
    DBMS_OUTPUT.PUT_LINE('========================================');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END PROC_ACTUA_POPULARIDAD;
/

EXEC PROC_ACTUA_POPULARIDAD;

PROMPT;
PROMPT === VERIFICAR DATOS ACTUALIZADOS ===

SELECT id_contenido, titulo, popularidad_score, fecha_actualizado_popularidad
FROM CONTENIDO
WHERE popularidad_score > 0
ORDER BY popularidad_score DESC;

-- ============================================================================
-- PROCEDIMIENTO 1: REGISTRAR USUARIO
-- ============================================================================

PROMPT;
PROMPT === PROCEDIMIENTO 1: REGISTRAR NUEVO USUARIO ===

CREATE OR REPLACE PROCEDURE SP_REGISTRAR_USUARIO(
    p_nombre IN VARCHAR2,
    p_email IN VARCHAR2,
    p_telefono IN VARCHAR2,
    p_ciudad_id IN NUMBER,
    p_plan_id IN NUMBER,
    p_resultado OUT VARCHAR2
)
AS
    v_id_usuario NUMBER;
    v_id_suscripcion NUMBER;
    v_id_pago NUMBER;
    v_precio_plan NUMBER;
    v_existe NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_existe FROM USUARIO WHERE UPPER(email) = UPPER(p_email);
    IF v_existe > 0 THEN
        p_resultado := 'ERROR: Email duplicado';
        RETURN;
    END IF;
    
    SELECT COUNT(*) INTO v_existe FROM PLAN WHERE id_plan = p_plan_id;
    IF v_existe = 0 THEN
        p_resultado := 'ERROR: Plan inválido';
        RETURN;
    END IF;
    
    SAVEPOINT sp_inicio;
    
    SELECT precio INTO v_precio_plan FROM PLAN WHERE id_plan = p_plan_id;
    SELECT MAX(id_usuario) + 1 INTO v_id_usuario FROM USUARIO;
    SELECT MAX(id_suscripcion) + 1 INTO v_id_suscripcion FROM SUSCRIPCION;
    SELECT MAX(id_pago) + 1 INTO v_id_pago FROM PAGO;
    
    INSERT INTO USUARIO (id_usuario, nombre, email, telefono, id_ciudad, fecha_registro)
    VALUES (v_id_usuario, p_nombre, p_email, p_telefono, p_ciudad_id, SYSDATE);
    
    INSERT INTO SUSCRIPCION (id_suscripcion, id_usuario, id_plan, fecha_vencimiento, estado_suscripcion)
    VALUES (v_id_suscripcion, v_id_usuario, p_plan_id, ADD_MONTHS(SYSDATE, 1), 'ACTIVA');
    
    INSERT INTO PAGO (id_pago, id_suscripcion, monto, metodo_pago, estado, fecha_pago)
    VALUES (v_id_pago, v_id_suscripcion, v_precio_plan, 'Tarjeta Crédito', 'EXITOSO', SYSDATE);
    
    INSERT INTO PERFIL (id_perfil, id_usuario, nombre, tipo_perfil)
    VALUES ((SELECT MAX(id_perfil) + 1 FROM PERFIL), v_id_usuario, p_nombre, 'ADULTO');
    
    COMMIT;
    p_resultado := 'ÉXITO: Usuario ' || p_nombre || ' registrado (ID: ' || v_id_usuario || ')';
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO sp_inicio;
        p_resultado := 'ERROR: ' || SQLERRM;
END SP_REGISTRAR_USUARIO;
/

DECLARE
    v_resultado VARCHAR2(500);
BEGIN
    SP_REGISTRAR_USUARIO('Test User', 'test@email.com', '3001234567', 1, 2, v_resultado);
    DBMS_OUTPUT.PUT_LINE(v_resultado);
END;
/

-- ============================================================================
-- PROCEDIMIENTO 2: CAMBIAR PLAN
-- ============================================================================

PROMPT;
PROMPT === PROCEDIMIENTO 2: CAMBIAR PLAN ===

CREATE OR REPLACE PROCEDURE SP_CAMBIAR_PLAN(
    p_usuario_id IN NUMBER,
    p_nuevo_plan_id IN NUMBER,
    p_resultado OUT VARCHAR2
)
AS
    v_id_suscripcion NUMBER;
    v_id_plan_anterior NUMBER;
    v_precio_plan NUMBER;
    v_id_pago NUMBER;
BEGIN
    SELECT id_suscripcion, id_plan INTO v_id_suscripcion, v_id_plan_anterior
    FROM SUSCRIPCION
    WHERE id_usuario = p_usuario_id AND estado_suscripcion = 'ACTIVA'
    AND ROWNUM = 1;
    
    SELECT precio INTO v_precio_plan FROM PLAN WHERE id_plan = p_nuevo_plan_id;
    
    SAVEPOINT sp_cambio;
    
    UPDATE SUSCRIPCION SET id_plan = p_nuevo_plan_id WHERE id_suscripcion = v_id_suscripcion;
    
    SELECT MAX(id_pago) + 1 INTO v_id_pago FROM PAGO;
    INSERT INTO PAGO (id_pago, id_suscripcion, monto, metodo_pago, estado, fecha_pago)
    VALUES (v_id_pago, v_id_suscripcion, v_precio_plan, 'Tarjeta Crédito', 'EXITOSO', SYSDATE);
    
    INSERT INTO HISTORIAL_PLAN (id_historial, id_usuario, id_plan_anterior, id_plan_nuevo)
    VALUES ((SELECT MAX(id_historial) + 1 FROM HISTORIAL_PLAN), p_usuario_id, v_id_plan_anterior, p_nuevo_plan_id);
    
    COMMIT;
    p_resultado := 'ÉXITO: Plan actualizado';
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_resultado := 'ERROR: Suscripción no encontrada';
    WHEN OTHERS THEN
        ROLLBACK TO sp_cambio;
        p_resultado := 'ERROR: ' || SQLERRM;
END SP_CAMBIAR_PLAN;
/

-- ============================================================================
-- PROCEDIMIENTO 3: REPORTE CONSUMO
-- ============================================================================

PROMPT;
PROMPT === PROCEDIMIENTO 3: REPORTE CONSUMO ===

CREATE OR REPLACE PROCEDURE SP_REPORTE_CONSUMO(
    p_usuario_id IN NUMBER,
    p_fecha_inicio IN DATE,
    p_fecha_fin IN DATE
)
AS
    v_usuario_nombre VARCHAR2(100);
    v_total_repro NUMBER;
    v_promedio NUMBER;
BEGIN
    SELECT nombre INTO v_usuario_nombre FROM USUARIO WHERE id_usuario = p_usuario_id;
    
    SELECT COUNT(*), ROUND(AVG(porcentaje_avance), 2)
    INTO v_total_repro, v_promedio
    FROM REPRODUCCION r
    INNER JOIN PERFIL pf ON r.id_perfil = pf.id_perfil
    WHERE pf.id_usuario = p_usuario_id
    AND r.fecha_hora_inicio BETWEEN p_fecha_inicio AND p_fecha_fin;
    
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('REPORTE: ' || v_usuario_nombre);
    DBMS_OUTPUT.PUT_LINE('Reproducciones: ' || v_total_repro);
    DBMS_OUTPUT.PUT_LINE('Promedio: ' || v_promedio || '%');
    DBMS_OUTPUT.PUT_LINE('========================================');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Usuario no encontrado');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END SP_REPORTE_CONSUMO;
/

EXEC SP_REPORTE_CONSUMO(1, TRUNC(SYSDATE - 30), TRUNC(SYSDATE));

-- ============================================================================
-- RESUMEN
-- ============================================================================

PROMPT;
PROMPT ============================================================================
PROMPT RESUMEN: 2 CURSORES + 3 PROCEDIMIENTOS COMPLETADOS
PROMPT ============================================================================
PROMPT ? CURSOR 1: PROC_SUSCRIP_VENCIDAS
PROMPT ? CURSOR 2: PROC_ACTUA_POPULARIDAD
PROMPT ? PROCEDIMIENTO 1: SP_REGISTRAR_USUARIO
PROMPT ? PROCEDIMIENTO 2: SP_CAMBIAR_PLAN
PROMPT ? PROCEDIMIENTO 3: SP_REPORTE_CONSUMO
PROMPT ============================================================================