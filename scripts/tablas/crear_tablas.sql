-- ============================================================================
-- SCRIPT: Crear todas las tablas de QuindioFlix
-- OBJETIVO: 21 tablas normalizadas hasta 3FN
-- AUTOR: Yuri Andrea Ramirez Reyes- Ruben Garrido 
-- ============================================================================
-- TABLA 1: PLAN
-- ===========================================================================

CREATE TABLE PLAN (
    id_plan NUMBER PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL UNIQUE,
    descripcion VARCHAR2(255),
    precio NUMBER(10, 2) NOT NULL,
    pantallas_simultaneas NUMBER NOT NULL,
    calidad_video VARCHAR2(20),
    perfiles_max NUMBER NOT NULL,
    CONSTRAINT ck_plan_precio CHECK (precio > 0),
    CONSTRAINT ck_plan_pantallas CHECK (pantallas_simultaneas > 0),
    CONSTRAINT ck_plan_perfiles CHECK (perfiles_max > 0)
)
TABLESPACE TS_SISTEMA;

COMMENT ON TABLE PLAN IS 'Planes de suscripción: Básico, Estándar, Premium';
COMMENT ON COLUMN PLAN.nombre IS 'Nombre del plan (Básico, Estándar, Premium)';
COMMENT ON COLUMN PLAN.precio IS 'Precio mensual en pesos colombianos';

-- ============================================================================
-- TABLA 2: CIUDAD
-- ============================================================================

CREATE TABLE CIUDAD (
    id_ciudad NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL UNIQUE,
    departamento VARCHAR2(100),
    pais VARCHAR2(100) DEFAULT 'Colombia'
)
TABLESPACE TS_SISTEMA;

COMMENT ON TABLE CIUDAD IS 'Ciudades colombianas donde operan usuarios';

-- ============================================================================
-- TABLA 3: USUARIO
-- ============================================================================

CREATE TABLE USUARIO (
    id_usuario NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) NOT NULL UNIQUE,
    telefono VARCHAR2(20),
    fecha_nacimiento DATE,
    id_ciudad NUMBER NOT NULL,
    fecha_registro DATE DEFAULT SYSDATE,
    fecha_ultimo_pago DATE,
    estado_cuenta VARCHAR2(20) DEFAULT 'ACTIVO',
    CONSTRAINT fk_usuario_ciudad FOREIGN KEY (id_ciudad) REFERENCES CIUDAD(id_ciudad),
    CONSTRAINT ck_usuario_estado CHECK (estado_cuenta IN ('ACTIVO', 'SUSPENDIDO', 'CANCELADO'))
)
TABLESPACE TS_USUARIOS;

COMMENT ON TABLE USUARIO IS 'Usuarios registrados en QuindioFlix';
COMMENT ON COLUMN USUARIO.email IS 'Email único, usado para login';

-- ============================================================================
-- TABLA 4: SUSCRIPCION
-- ============================================================================

CREATE TABLE SUSCRIPCION (
    id_suscripcion NUMBER PRIMARY KEY,
    id_usuario NUMBER NOT NULL,
    id_plan NUMBER NOT NULL,
    fecha_inicio DATE DEFAULT SYSDATE,
    fecha_vencimiento DATE NOT NULL,
    estado_suscripcion VARCHAR2(20) DEFAULT 'ACTIVA',
    CONSTRAINT fk_suscripcion_usuario FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario),
    CONSTRAINT fk_suscripcion_plan FOREIGN KEY (id_plan) REFERENCES PLAN(id_plan),
    CONSTRAINT ck_suscripcion_estado CHECK (estado_suscripcion IN ('ACTIVA', 'VENCIDA', 'CANCELADA')),
    CONSTRAINT ck_suscripcion_fechas CHECK (fecha_vencimiento > fecha_inicio)
)
TABLESPACE TS_USUARIOS;

COMMENT ON TABLE SUSCRIPCION IS 'Suscripciones activas de usuarios (un usuario, una suscripción activa)';

-- ============================================================================
-- TABLA 5: GENERO
-- ============================================================================

CREATE TABLE GENERO (
    id_genero NUMBER PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL UNIQUE
)
TABLESPACE TS_SISTEMA;

COMMENT ON TABLE GENERO IS 'Géneros de contenido: Acción, Comedia, Drama, etc.';

-- ============================================================================
-- TABLA 6: DISPOSITIVO
-- ============================================================================

CREATE TABLE DISPOSITIVO (
    id_dispositivo NUMBER PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL UNIQUE
)
TABLESPACE TS_SISTEMA;

COMMENT ON TABLE DISPOSITIVO IS 'Tipos de dispositivos: Celular, Tablet, TV, Computador';

-- ============================================================================
-- TABLA 7: METODO_PAGO
-- ============================================================================

CREATE TABLE METODO_PAGO (
    id_metodo_pago NUMBER PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL UNIQUE
)
TABLESPACE TS_SISTEMA;

COMMENT ON TABLE METODO_PAGO IS 'Métodos de pago: Tarjeta Crédito, PSE, Nequi, Daviplata';


-- ============================================================================
-- TABLA 8: DEPARTAMENTO
-- ============================================================================

CREATE TABLE DEPARTAMENTO (
    id_departamento NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL UNIQUE
)
TABLESPACE TS_EMPLEADOS;

COMMENT ON TABLE DEPARTAMENTO IS 'Departamentos: Tecnología, Contenido, Marketing, Soporte, Finanzas';


-- ============================================================================
-- TABLA 9: EMPLEADO
-- ============================================================================

CREATE TABLE EMPLEADO (
    id_empleado NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    email_corporativo VARCHAR2(100) UNIQUE,
    telefono VARCHAR2(20),
    cargo VARCHAR2(100),
    id_departamento NUMBER NOT NULL,
    supervisor_id NUMBER,
    fecha_contratacion DATE DEFAULT SYSDATE,
    salario NUMBER(10, 2),
    estado VARCHAR2(20) DEFAULT 'ACTIVO',
    CONSTRAINT fk_empleado_departamento FOREIGN KEY (id_departamento) REFERENCES DEPARTAMENTO(id_departamento),
    CONSTRAINT fk_empleado_supervisor FOREIGN KEY (supervisor_id) REFERENCES EMPLEADO(id_empleado),
    CONSTRAINT ck_empleado_estado CHECK (estado IN ('ACTIVO', 'INACTIVO', 'LICENCIA'))
)
TABLESPACE TS_EMPLEADOS;

COMMENT ON TABLE EMPLEADO IS 'Empleados de QuindioFlix organizados en departamentos';


-- ============================================================================
-- TABLA 10: EMPLEADO_CARGO (Tabla intermedia - N:M entre EMPLEADO y DEPARTAMENTO)
-- ajuste sugerido por el maestro
-- ============================================================================

CREATE TABLE EMPLEADO_CARGO (
    id_empleado_cargo NUMBER PRIMARY KEY,
    id_empleado NUMBER NOT NULL,
    id_departamento NUMBER NOT NULL,
    cargo VARCHAR2(100) NOT NULL,
    fecha_asignacion DATE DEFAULT SYSDATE,
    fecha_fin_cargo DATE,
    estado VARCHAR2(20) DEFAULT 'ACTIVO',
    CONSTRAINT fk_ec_empleado FOREIGN KEY (id_empleado) REFERENCES EMPLEADO(id_empleado) ON DELETE CASCADE,
    CONSTRAINT fk_ec_departamento FOREIGN KEY (id_departamento) REFERENCES DEPARTAMENTO(id_departamento),
    CONSTRAINT ck_fecha_cargo CHECK (fecha_fin_cargo IS NULL OR fecha_fin_cargo > fecha_asignacion)
)
TABLESPACE TS_EMPLEADOS;

COMMENT ON TABLE EMPLEADO_CARGO IS 'Historial de cargos de empleados (permite cambios de cargo y departamento)';

-- ============================================================================
-- TABLA 11: CONTENIDO
-- ============================================================================

CREATE TABLE CONTENIDO (
    id_contenido NUMBER PRIMARY KEY,
    titulo VARCHAR2(200) NOT NULL,
    tipo_contenido VARCHAR2(50) NOT NULL,
    ano_lanzamiento NUMBER,
    duracion_minutos NUMBER,
    sinopsis CLOB,
    clasificacion_edad VARCHAR2(20),
    fecha_agregado DATE DEFAULT SYSDATE,
    es_produccion_original CHAR(1) DEFAULT 'N',
    id_empleado_responsable NUMBER,
    CONSTRAINT fk_contenido_empleado FOREIGN KEY (id_empleado_responsable) REFERENCES EMPLEADO(id_empleado),
    CONSTRAINT ck_contenido_tipo CHECK (tipo_contenido IN ('PELICULA', 'SERIE', 'DOCUMENTAL', 'MUSICA', 'PODCAST')),
    CONSTRAINT ck_contenido_clasificacion CHECK (clasificacion_edad IN ('TP', '+7', '+13', '+16', '+18'))
)
TABLESPACE TS_CONTENIDO;

COMMENT ON TABLE CONTENIDO IS 'Catálogo de contenido (películas, series, documentales, música, podcasts)';

-- ============================================================================
-- TABLA 12: CONTENIDO_GENERO (Tabla N:M)
-- ============================================================================

CREATE TABLE CONTENIDO_GENERO (
    id_contenido NUMBER NOT NULL,
    id_genero NUMBER NOT NULL,
    PRIMARY KEY (id_contenido, id_genero),
    CONSTRAINT fk_cg_contenido FOREIGN KEY (id_contenido) REFERENCES CONTENIDO(id_contenido) ON DELETE CASCADE,
    CONSTRAINT fk_cg_genero FOREIGN KEY (id_genero) REFERENCES GENERO(id_genero)
)
TABLESPACE TS_CONTENIDO;

COMMENT ON TABLE CONTENIDO_GENERO IS 'Relación N:M entre contenido y géneros (un contenido, múltiples géneros)';


-- ============================================================================
-- TABLA 13: CONTENIDO_RELACIONADO (Tabla    N:M)
-- ============================================================================

CREATE TABLE CONTENIDO_RELACIONADO (
    id_contenido_origen NUMBER NOT NULL,
    id_contenido_destino NUMBER NOT NULL,
    tipo_relacion VARCHAR2(50),
    descripcion VARCHAR2(255),
    PRIMARY KEY (id_contenido_origen, id_contenido_destino),
    CONSTRAINT fk_cr_origen FOREIGN KEY (id_contenido_origen) REFERENCES CONTENIDO(id_contenido) ON DELETE CASCADE,
    CONSTRAINT fk_cr_destino FOREIGN KEY (id_contenido_destino) REFERENCES CONTENIDO(id_contenido) ON DELETE CASCADE,
    CONSTRAINT ck_relacion CHECK (tipo_relacion IN ('SECUELA', 'PRECUELA', 'SPIN_OFF', 'REMAKE', 'VERSION_EXTENDIDA'))
)
TABLESPACE TS_CONTENIDO;

COMMENT ON TABLE CONTENIDO_RELACIONADO IS 'Relaciones entre contenidos (secuelas, spin-offs, remakes, etc.)';

-- ============================================================================
-- TABLA 14: TEMPORADA
-- ============================================================================

CREATE TABLE TEMPORADA (
    id_temporada NUMBER PRIMARY KEY,
    id_contenido NUMBER NOT NULL,
    numero_temporada NUMBER NOT NULL,
    fecha_inicio DATE,
    ano_estreno NUMBER,
    descripcion VARCHAR2(255),
    CONSTRAINT fk_temporada_contenido FOREIGN KEY (id_contenido) REFERENCES CONTENIDO(id_contenido) ON DELETE CASCADE,
    CONSTRAINT ck_temporada_numero CHECK (numero_temporada > 0)
)
TABLESPACE TS_CONTENIDO;

COMMENT ON TABLE TEMPORADA IS 'Temporadas de series y podcasts';


-- ============================================================================
-- TABLA 15: EPISODIO
-- ============================================================================

CREATE TABLE EPISODIO (
    id_episodio NUMBER PRIMARY KEY,
    id_temporada NUMBER NOT NULL,
    numero_episodio NUMBER NOT NULL,
    titulo VARCHAR2(200),
    duracion_minutos NUMBER,
    fecha_estreno DATE,
    sinopsis CLOB,
    CONSTRAINT fk_episodio_temporada FOREIGN KEY (id_temporada) REFERENCES TEMPORADA(id_temporada) ON DELETE CASCADE,
    CONSTRAINT ck_episodio_numero CHECK (numero_episodio > 0)
)
TABLESPACE TS_CONTENIDO;

COMMENT ON TABLE EPISODIO IS 'Episodios de series y podcasts';

-- ============================================================================
-- TABLA 16: PERFIL
-- ============================================================================

CREATE TABLE PERFIL (
    id_perfil NUMBER PRIMARY KEY,
    id_usuario NUMBER NOT NULL,
    nombre VARCHAR2(100) NOT NULL,
    tipo_perfil VARCHAR2(20),
    avatar VARCHAR2(255),
    es_moderador CHAR(1) DEFAULT 'N',
    fecha_creacion DATE DEFAULT SYSDATE,
    CONSTRAINT fk_perfil_usuario FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    CONSTRAINT ck_perfil_tipo CHECK (tipo_perfil IN ('ADULTO', 'INFANTIL')),
    CONSTRAINT ck_perfil_moderador CHECK (es_moderador IN ('S', 'N'))
)
TABLESPACE TS_USUARIOS;

COMMENT ON TABLE PERFIL IS 'Perfiles dentro de una cuenta (máximo 2-5 según plan, adulto o infantil)';


-- ============================================================================
-- TABLA 17: REPRODUCCION
-- ============================================================================

CREATE TABLE REPRODUCCION (
    id_reproduccion NUMBER PRIMARY KEY,
    id_perfil NUMBER NOT NULL,
    id_contenido NUMBER NOT NULL,
    id_dispositivo NUMBER NOT NULL,
    fecha_hora_inicio TIMESTAMP DEFAULT SYSTIMESTAMP,
    fecha_hora_fin TIMESTAMP,
    porcentaje_avance NUMBER,
    CONSTRAINT fk_reproduccion_perfil FOREIGN KEY (id_perfil) REFERENCES PERFIL(id_perfil) ON DELETE CASCADE,
    CONSTRAINT fk_reproduccion_contenido FOREIGN KEY (id_contenido) REFERENCES CONTENIDO(id_contenido),
    CONSTRAINT fk_reproduccion_dispositivo FOREIGN KEY (id_dispositivo) REFERENCES DISPOSITIVO(id_dispositivo),
    CONSTRAINT ck_reproduccion_porcentaje CHECK (porcentaje_avance >= 0 AND porcentaje_avance <= 100)
)
TABLESPACE TS_REPRODUCCION;

COMMENT ON TABLE REPRODUCCION IS 'Registro de cada reproducción (más del 50% permite calificar)';


-- ============================================================================
-- TABLA 18: CALIFICACION
-- ============================================================================

CREATE TABLE CALIFICACION (
    id_calificacion NUMBER PRIMARY KEY,
    id_perfil NUMBER NOT NULL,
    id_contenido NUMBER NOT NULL,
    puntuacion NUMBER NOT NULL,
    resena CLOB,
    fecha_calificacion DATE DEFAULT SYSDATE,
    CONSTRAINT fk_calificacion_perfil FOREIGN KEY (id_perfil) REFERENCES PERFIL(id_perfil) ON DELETE CASCADE,
    CONSTRAINT fk_calificacion_contenido FOREIGN KEY (id_contenido) REFERENCES CONTENIDO(id_contenido),
    CONSTRAINT ck_calificacion_puntuacion CHECK (puntuacion >= 1 AND puntuacion <= 5)
)
TABLESPACE TS_TRANSACCIONES;

COMMENT ON TABLE CALIFICACION IS 'Calificaciones (1-5 estrellas) y reseñas de usuarios';


-- ============================================================================
-- TABLA 19: FAVORITO
-- ============================================================================

CREATE TABLE FAVORITO (
    id_perfil NUMBER NOT NULL,
    id_contenido NUMBER NOT NULL,
    fecha_agregado DATE DEFAULT SYSDATE,
    PRIMARY KEY (id_perfil, id_contenido),
    CONSTRAINT fk_favorito_perfil FOREIGN KEY (id_perfil) REFERENCES PERFIL(id_perfil) ON DELETE CASCADE,
    CONSTRAINT fk_favorito_contenido FOREIGN KEY (id_contenido) REFERENCES CONTENIDO(id_contenido)
)
TABLESPACE TS_TRANSACCIONES;

COMMENT ON TABLE FAVORITO IS 'Lista de favoritos de cada perfil (tabla N:M)';

-- ============================================================================
-- TABLA 20: PAGO
-- ============================================================================

CREATE TABLE PAGO (
    id_pago NUMBER PRIMARY KEY,
    id_suscripcion NUMBER NOT NULL,
    monto NUMBER(10, 2) NOT NULL,
    fecha_pago DATE DEFAULT SYSDATE,
    metodo_pago VARCHAR2(50),
    estado VARCHAR2(20) DEFAULT 'PENDIENTE',
    fecha_procesamiento DATE,
    CONSTRAINT fk_pago_suscripcion FOREIGN KEY (id_suscripcion) REFERENCES SUSCRIPCION(id_suscripcion),
    CONSTRAINT ck_pago_estado CHECK (estado IN ('EXITOSO', 'FALLIDO', 'PENDIENTE', 'REEMBOLSADO'))
)
TABLESPACE TS_TRANSACCIONES;

COMMENT ON TABLE PAGO IS 'Historial de pagos mensuales (auditoría financiera)';


-- ============================================================================
-- TABLA 21: REPORTE_CONTENIDO
-- ============================================================================

CREATE TABLE REPORTE_CONTENIDO (
    id_reporte NUMBER PRIMARY KEY,
    id_contenido NUMBER NOT NULL,
    id_usuario_reporta NUMBER NOT NULL,
    fecha_reporte DATE DEFAULT SYSDATE,
    motivo VARCHAR2(255),
    id_empleado_resuelve NUMBER,
    estado VARCHAR2(20) DEFAULT 'PENDIENTE',
    fecha_resolucion DATE,
    CONSTRAINT fk_reporte_contenido FOREIGN KEY (id_contenido) REFERENCES CONTENIDO(id_contenido),
    CONSTRAINT fk_reporte_usuario FOREIGN KEY (id_usuario_reporta) REFERENCES USUARIO(id_usuario),
    CONSTRAINT fk_reporte_empleado FOREIGN KEY (id_empleado_resuelve) REFERENCES EMPLEADO(id_empleado),
    CONSTRAINT ck_reporte_estado CHECK (estado IN ('PENDIENTE', 'EN_REVISION', 'RESUELTA', 'RECHAZADA'))
)
TABLESPACE TS_TRANSACCIONES;

COMMENT ON TABLE REPORTE_CONTENIDO IS 'Reportes de contenido inapropiado (moderación)';

-- ============================================================================
-- TABLA 22: HISTORIAL_PLAN
-- ============================================================================

CREATE TABLE HISTORIAL_PLAN (
    id_historial NUMBER PRIMARY KEY,
    id_usuario NUMBER NOT NULL,
    id_plan_anterior NUMBER,
    id_plan_nuevo NUMBER,
    fecha_cambio DATE DEFAULT SYSDATE,
    CONSTRAINT fk_historial_usuario FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_historial_anterior FOREIGN KEY (id_plan_anterior) REFERENCES PLAN(id_plan),
    CONSTRAINT fk_historial_nuevo FOREIGN KEY (id_plan_nuevo) REFERENCES PLAN(id_plan)
)
TABLESPACE TS_EMPLEADOS;

COMMENT ON TABLE HISTORIAL_PLAN IS 'Auditoría de cambios de plan de usuario';


-- ============================================================================
-- VERIFICACIÓN: Contar tablas creadas
-- ============================================================================

SELECT COUNT(*) as tablas_creadas
FROM user_tables
WHERE table_name LIKE '%';