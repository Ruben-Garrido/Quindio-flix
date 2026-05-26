-- ============================================================================
-- SCRIPT: TRANSACCIONES CON COMMIT, ROLLBACK, SAVEPOINT
-- REQUISITO: 3.3.1 (3 Transacciones) + 3.3.2 (Concurrencia SELECT FOR UPDATE)
-- PROPÓSITO: Garantizar integridad transaccional en operaciones críticas
-- ============================================================================

PROMPT ============================================================================
PROMPT TRANSACCIONES Y CONCURRENCIA - QUINDIOFLIX
PROMPT ============================================================================

-- ============================================================================
-- TRANSACCIÓN 1: REGISTRO DE USUARIO CON SAVEPOINT
-- Descripción: Registra usuario con suscripción, perfil y pago inicial
-- Características: SAVEPOINT para rollback parcial si falla pago
-- ============================================================================

PROMPT;
PROMPT === TRANSACCIÓN 1: REGISTRO USUARIO CON SAVEPOINT ===
PROMPT;

DECLARE
    v_id_usuario NUMBER;
    v_id_suscripcion NUMBER;
    v_id_perfil NUMBER;
    v_id_pago NUMBER;
    v_precio NUMBER;
    v_error VARCHAR2(500);
BEGIN
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('TRANSACCIÓN 1: REGISTRO USUARIO');
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Obtener IDs
    SELECT MAX(id_usuario) + 1 INTO v_id_usuario FROM USUARIO;
    SELECT MAX(id_suscripcion) + 1 INTO v_id_suscripcion FROM SUSCRIPCION;
    SELECT MAX(id_perfil) + 1 INTO v_id_perfil FROM PERFIL;
    SELECT MAX(id_pago) + 1 INTO v_id_pago FROM PAGO;
    SELECT precio INTO v_precio FROM PLAN WHERE id_plan = 2;
    
    SAVEPOINT sp_inicio;
    DBMS_OUTPUT.PUT_LINE('? SAVEPOINT sp_inicio creado');
    
    -- PASO 1: Insertar usuario
    BEGIN
        INSERT INTO USUARIO (id_usuario, nombre, email, telefono, id_ciudad, fecha_registro)
        VALUES (v_id_usuario, 'Trans1 Usuario', 'trans1@email.com', '3001111111', 1, SYSDATE);
        DBMS_OUTPUT.PUT_LINE('? PASO 1: Usuario insertado (ID: ' || v_id_usuario || ')');
    EXCEPTION
        WHEN OTHERS THEN
            v_error := SQLERRM;
            ROLLBACK TO sp_inicio;
            DBMS_OUTPUT.PUT_LINE('? ERROR PASO 1: ' || v_error);
            RAISE;
    END;
    
    SAVEPOINT sp_usuario_creado;
    DBMS_OUTPUT.PUT_LINE('? SAVEPOINT sp_usuario_creado');
    
    -- PASO 2: Crear suscripción
    BEGIN
        INSERT INTO SUSCRIPCION (id_suscripcion, id_usuario, id_plan, fecha_vencimiento, estado_suscripcion)
        VALUES (v_id_suscripcion, v_id_usuario, 2, ADD_MONTHS(SYSDATE, 1), 'ACTIVA');
        DBMS_OUTPUT.PUT_LINE('? PASO 2: Suscripción creada (ID: ' || v_id_suscripcion || ')');
    EXCEPTION
        WHEN OTHERS THEN
            v_error := SQLERRM;
            ROLLBACK TO sp_usuario_creado;
            DBMS_OUTPUT.PUT_LINE('? ERROR PASO 2: ' || v_error);
            RAISE;
    END;
    
    SAVEPOINT sp_suscripcion_creada;
    DBMS_OUTPUT.PUT_LINE('? SAVEPOINT sp_suscripcion_creada');
    
    -- PASO 3: Crear perfil
    BEGIN
        INSERT INTO PERFIL (id_perfil, id_usuario, nombre, tipo_perfil)
        VALUES (v_id_perfil, v_id_usuario, 'Perfil Principal', 'ADULTO');
        DBMS_OUTPUT.PUT_LINE('? PASO 3: Perfil creado (ID: ' || v_id_perfil || ')');
    EXCEPTION
        WHEN OTHERS THEN
            v_error := SQLERRM;
            ROLLBACK TO sp_suscripcion_creada;
            DBMS_OUTPUT.PUT_LINE('? ERROR PASO 3: ' || v_error);
            RAISE;
    END;
    
    SAVEPOINT sp_perfil_creado;
    DBMS_OUTPUT.PUT_LINE('? SAVEPOINT sp_perfil_creado');
    
    -- PASO 4: Registrar pago inicial
    BEGIN
        INSERT INTO PAGO (id_pago, id_suscripcion, monto, metodo_pago, estado, fecha_pago)
        VALUES (v_id_pago, v_id_suscripcion, v_precio, 'Tarjeta Crédito', 'EXITOSO', SYSDATE);
        DBMS_OUTPUT.PUT_LINE('? PASO 4: Pago registrado (ID: ' || v_id_pago || ', Monto: $' || v_precio || ')');
    EXCEPTION
        WHEN OTHERS THEN
            v_error := SQLERRM;
            ROLLBACK TO sp_perfil_creado;
            DBMS_OUTPUT.PUT_LINE('? ERROR PASO 4 (ROLLBACK PARCIAL): ' || v_error);
            DBMS_OUTPUT.PUT_LINE('? Usuario, suscripción y perfil se mantienen');
            DBMS_OUTPUT.PUT_LINE('? Pago NO se registró');
            RAISE;
    END;
    
    -- COMMIT si todo fue bien
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('? COMMIT: Transacción completada correctamente');
    DBMS_OUTPUT.PUT_LINE('========================================');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('? ROLLBACK COMPLETO: Transacción cancelada');
        DBMS_OUTPUT.PUT_LINE('========================================');
        ROLLBACK;
END;
/

-- ============================================================================
-- TRANSACCIÓN 2: RENOVACIÓN MASIVA DE SUSCRIPCIONES
-- Descripción: Renueva suscripciones activas con SAVEPOINT por usuario
-- Características: Si un usuario falla, no afecta a los otros
-- ============================================================================

PROMPT;
PROMPT === TRANSACCIÓN 2: RENOVACIÓN MASIVA DE SUSCRIPCIONES ===
PROMPT;

DECLARE
    CURSOR cur_usuarios_activos IS
        SELECT s.id_usuario, s.id_suscripcion, u.nombre
        FROM SUSCRIPCION s
        INNER JOIN USUARIO u ON s.id_usuario = u.id_usuario
        WHERE s.estado_suscripcion = 'ACTIVA'
        AND ROWNUM <= 5;
    
    v_contador_renovados NUMBER := 0;
    v_contador_fallidos NUMBER := 0;
    v_id_pago NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('RENOVACIÓN MASIVA DE SUSCRIPCIONES');
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('');
    
    FOR v_reg IN cur_usuarios_activos LOOP
        SAVEPOINT sp_usuario_individual;
        
        BEGIN
            -- Obtener ID de pago
            SELECT MAX(id_pago) + 1 INTO v_id_pago FROM PAGO;
            
            -- Renovar suscripción (extender vencimiento 1 mes)
            UPDATE SUSCRIPCION
            SET fecha_vencimiento = ADD_MONTHS(SYSDATE, 1)
            WHERE id_suscripcion = v_reg.id_suscripcion;
            
            -- Registrar pago
            INSERT INTO PAGO (id_pago, id_suscripcion, monto, metodo_pago, estado, fecha_pago)
            VALUES (v_id_pago, v_reg.id_suscripcion, 24900, 'Automatizado', 'EXITOSO', SYSDATE);
            
            v_contador_renovados := v_contador_renovados + 1;
            DBMS_OUTPUT.PUT_LINE('? Renovado: ' || v_reg.nombre || ' (Usuario ID: ' || v_reg.id_usuario || ')');
            
        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK TO sp_usuario_individual;
                v_contador_fallidos := v_contador_fallidos + 1;
                DBMS_OUTPUT.PUT_LINE('? Error renovando ' || v_reg.nombre || ': ' || SQLERRM);
        END;
    END LOOP;
    
    -- COMMIT de todas las renovaciones exitosas
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('RESUMEN:');
    DBMS_OUTPUT.PUT_LINE('  Renovadas exitosamente: ' || v_contador_renovados);
    DBMS_OUTPUT.PUT_LINE('  Fallidas: ' || v_contador_fallidos);
    DBMS_OUTPUT.PUT_LINE('? COMMIT: Cambios permanentes');
    DBMS_OUTPUT.PUT_LINE('========================================');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('? ERROR CRÍTICO: ' || SQLERRM);
        ROLLBACK;
END;
/

-- ============================================================================
-- TRANSACCIÓN 3: CAMBIO DE PLAN CON VALIDACIONES
-- Descripción: Cambia plan de usuario con validaciones
-- Características: ROLLBACK si algo falla, mantiene consistencia
-- ============================================================================

PROMPT;
PROMPT === TRANSACCIÓN 3: CAMBIO DE PLAN CON VALIDACIONES ===
PROMPT;

DECLARE
    v_usuario_id NUMBER := 1;
    v_nuevo_plan_id NUMBER := 3;
    v_id_suscripcion NUMBER;
    v_precio_nuevo NUMBER;
    v_precio_viejo NUMBER;
    v_diferencia NUMBER;
    v_id_pago NUMBER;
    v_id_historial NUMBER;
    v_plan_anterior NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('CAMBIO DE PLAN DE SUSCRIPCIÓN');
    DBMS_OUTPUT.PUT_LINE('Usuario ID: ' || v_usuario_id);
    DBMS_OUTPUT.PUT_LINE('Nuevo Plan ID: ' || v_nuevo_plan_id);
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('');
    
    SAVEPOINT sp_inicio_cambio;
    
    BEGIN
        -- Validar usuario existe
        DECLARE
            v_user_count NUMBER;
        BEGIN
            SELECT COUNT(*) INTO v_user_count FROM USUARIO WHERE id_usuario = v_usuario_id;
            IF v_user_count = 0 THEN
                RAISE_APPLICATION_ERROR(-20003, 'Usuario no existe');
            END IF;
        END;
        DBMS_OUTPUT.PUT_LINE('? Usuario válido');
        
        -- Validar plan existe
        DECLARE
            v_plan_count NUMBER;
        BEGIN
            SELECT COUNT(*) INTO v_plan_count FROM PLAN WHERE id_plan = v_nuevo_plan_id;
            IF v_plan_count = 0 THEN
                RAISE_APPLICATION_ERROR(-20002, 'Plan no existe');
            END IF;
        END;
        DBMS_OUTPUT.PUT_LINE('? Plan válido');
        
        SAVEPOINT sp_validaciones;
        
        -- Obtener datos
        SELECT s.id_suscripcion, p.precio, s.id_plan
        INTO v_id_suscripcion, v_precio_viejo, v_plan_anterior
        FROM SUSCRIPCION s
        INNER JOIN PLAN p ON s.id_plan = p.id_plan
        WHERE s.id_usuario = v_usuario_id AND s.estado_suscripcion = 'ACTIVA'
        AND ROWNUM = 1;
        
        SELECT precio INTO v_precio_nuevo FROM PLAN WHERE id_plan = v_nuevo_plan_id;
        v_diferencia := v_precio_nuevo - v_precio_viejo;
        
        DBMS_OUTPUT.PUT_LINE('? Plan anterior: $' || v_precio_viejo);
        DBMS_OUTPUT.PUT_LINE('? Plan nuevo: $' || v_precio_nuevo);
        DBMS_OUTPUT.PUT_LINE('? Diferencia: $' || v_diferencia);
        DBMS_OUTPUT.PUT_LINE('');
        
        SAVEPOINT sp_datos_obtenidos;
        
        -- Actualizar plan
        UPDATE SUSCRIPCION
        SET id_plan = v_nuevo_plan_id
        WHERE id_suscripcion = v_id_suscripcion;
        DBMS_OUTPUT.PUT_LINE('? Plan actualizado');
        
        -- Registrar pago de la diferencia
        SELECT MAX(id_pago) + 1 INTO v_id_pago FROM PAGO;
        INSERT INTO PAGO (id_pago, id_suscripcion, monto, metodo_pago, estado, fecha_pago)
        VALUES (v_id_pago, v_id_suscripcion, ABS(v_diferencia), 'Tarjeta Crédito', 'EXITOSO', SYSDATE);
        DBMS_OUTPUT.PUT_LINE('? Pago registrado (ID: ' || v_id_pago || ')');
        
        -- Registrar en historial
        SELECT MAX(id_historial) + 1 INTO v_id_historial FROM HISTORIAL_PLAN;
        INSERT INTO HISTORIAL_PLAN (id_historial, id_usuario, id_plan_anterior, id_plan_nuevo)
        VALUES (v_id_historial, v_usuario_id, v_plan_anterior, v_nuevo_plan_id);
        DBMS_OUTPUT.PUT_LINE('? Historial registrado');
        
        -- COMMIT
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('? COMMIT: Cambio de plan completado');
        DBMS_OUTPUT.PUT_LINE('========================================');
        
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK TO sp_inicio_cambio;
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('? ROLLBACK: Cambio de plan cancelado');
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            DBMS_OUTPUT.PUT_LINE('========================================');
    END;

END;
/

-- ============================================================================
-- ESCENARIO DE CONCURRENCIA: SELECT FOR UPDATE
-- Descripción: Simula bloqueo optimista con SELECT FOR UPDATE
-- ============================================================================

PROMPT;
PROMPT === ESCENARIO DE CONCURRENCIA: SELECT FOR UPDATE ===
PROMPT;

DECLARE
    v_id_suscripcion NUMBER := 1;
    v_nueva_fecha DATE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('SIMULACIÓN: SELECT FOR UPDATE');
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('SESIÓN 1: Obtener registro con bloqueo...');
    
    -- Seleccionar el registro y bloquearlo
    SELECT id_suscripcion INTO v_id_suscripcion
    FROM SUSCRIPCION
    WHERE id_suscripcion = 1
    FOR UPDATE;
    
    DBMS_OUTPUT.PUT_LINE('? Suscripción 1 bloqueada (SELECT FOR UPDATE)');
    DBMS_OUTPUT.PUT_LINE('? Otra sesión esperaría aquí...');
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Simular procesamiento
    DBMS_OUTPUT.PUT_LINE('Procesando...');
    SYS.DBMS_LOCK.SLEEP(1);
    DBMS_OUTPUT.PUT_LINE('? Procesamiento completado');
    
    -- Hacer cambios
    v_nueva_fecha := ADD_MONTHS(SYSDATE, 1);
    UPDATE SUSCRIPCION
    SET fecha_vencimiento = v_nueva_fecha
    WHERE id_suscripcion = v_id_suscripcion;
    
    DBMS_OUTPUT.PUT_LINE('? Suscripción actualizada');
    DBMS_OUTPUT.PUT_LINE('');
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('? COMMIT: Bloqueo liberado');
    DBMS_OUTPUT.PUT_LINE('? Ahora otra sesión puede acceder');
    DBMS_OUTPUT.PUT_LINE('========================================');
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END;
/

-- ============================================================================
-- RESUMEN FINAL
-- ============================================================================

PROMPT;
PROMPT ============================================================================
PROMPT RESUMEN DE TRANSACCIONES Y CONCURRENCIA:
PROMPT ============================================================================
PROMPT ? TRANSACCIÓN 1: Registro usuario con SAVEPOINT (rollback parcial)
PROMPT ? TRANSACCIÓN 2: Renovación masiva (SAVEPOINT por usuario)
PROMPT ? TRANSACCIÓN 3: Cambio de plan (validaciones + historial)
PROMPT ? ESCENARIO CONCURRENCIA: SELECT FOR UPDATE (bloqueo exclusivo)
PROMPT ============================================================================
PROMPT;
PROMPT REQUISITO 3.3.1: 3 TRANSACCIONES ?
PROMPT REQUISITO 3.3.2: CONCURRENCIA (SELECT FOR UPDATE) ?
PROMPT ============================================================================