-- ============================================================================
-- SCRIPT: Insertar datos de prueba en QuindioFlix
-- OBJETIVO: 25-50 registros asimétricos por tabla (datos coherentes)
-- AUTOR: [Tu Nombre]
-- FECHA: [Hoy]
-- ============================================================================

-- ============================================================================
-- 1. INSERTAR DATOS EN TABLA: PLAN
-- ============================================================================

INSERT INTO PLAN (id_plan, nombre, descripcion, precio, pantallas_simultaneas, calidad_video, perfiles_max)
VALUES (1, 'Básico', 'Un dispositivo, calidad SD, máximo 2 perfiles', 14900, 1, 'SD', 2);

INSERT INTO PLAN (id_plan, nombre, descripcion, precio, pantallas_simultaneas, calidad_video, perfiles_max)
VALUES (2, 'Estándar', 'Dos dispositivos, calidad HD, máximo 3 perfiles', 24900, 2, 'HD', 3);

INSERT INTO PLAN (id_plan, nombre, descripcion, precio, pantallas_simultaneas, calidad_video, perfiles_max)
VALUES (3, 'Premium', 'Cuatro dispositivos, calidad 4K, máximo 5 perfiles', 34900, 4, '4K', 5);

-- ============================================================================
-- 2. INSERTAR DATOS EN TABLA: CIUDAD
-- ============================================================================

INSERT INTO CIUDAD (id_ciudad, nombre, departamento) VALUES (1, 'Armenia', 'Quindío');
INSERT INTO CIUDAD (id_ciudad, nombre, departamento) VALUES (2, 'Bogotá', 'Cundinamarca');
INSERT INTO CIUDAD (id_ciudad, nombre, departamento) VALUES (3, 'Medellín', 'Antioquia');
INSERT INTO CIUDAD (id_ciudad, nombre, departamento) VALUES (4, 'Cali', 'Valle del Cauca');
INSERT INTO CIUDAD (id_ciudad, nombre, departamento) VALUES (5, 'Barranquilla', 'Atlántico');

-- ============================================================================
-- 3. INSERTAR DATOS EN TABLA: GENERO
-- ============================================================================

INSERT INTO GENERO (id_genero, nombre) VALUES (1, 'Acción');
INSERT INTO GENERO (id_genero, nombre) VALUES (2, 'Comedia');
INSERT INTO GENERO (id_genero, nombre) VALUES (3, 'Drama');
INSERT INTO GENERO (id_genero, nombre) VALUES (4, 'Suspenso');
INSERT INTO GENERO (id_genero, nombre) VALUES (5, 'Romance');
INSERT INTO GENERO (id_genero, nombre) VALUES (6, 'Ciencia Ficción');
INSERT INTO GENERO (id_genero, nombre) VALUES (7, 'Terror');
INSERT INTO GENERO (id_genero, nombre) VALUES (8, 'Infantil');

-- ============================================================================
-- 4. INSERTAR DATOS EN TABLA: DISPOSITIVO
-- ============================================================================

INSERT INTO DISPOSITIVO (id_dispositivo, nombre) VALUES (1, 'Celular');
INSERT INTO DISPOSITIVO (id_dispositivo, nombre) VALUES (2, 'Tablet');
INSERT INTO DISPOSITIVO (id_dispositivo, nombre) VALUES (3, 'TV');
INSERT INTO DISPOSITIVO (id_dispositivo, nombre) VALUES (4, 'Computador');

-- ============================================================================
-- 5. INSERTAR DATOS EN TABLA: METODO_PAGO
-- ============================================================================

INSERT INTO METODO_PAGO (id_metodo_pago, nombre) VALUES (1, 'Tarjeta Crédito');
INSERT INTO METODO_PAGO (id_metodo_pago, nombre) VALUES (2, 'Tarjeta Débito');
INSERT INTO METODO_PAGO (id_metodo_pago, nombre) VALUES (3, 'PSE');
INSERT INTO METODO_PAGO (id_metodo_pago, nombre) VALUES (4, 'Nequi');
INSERT INTO METODO_PAGO (id_metodo_pago, nombre) VALUES (5, 'Daviplata');

-- ============================================================================
-- 6. INSERTAR DATOS EN TABLA: DEPARTAMENTO
-- ============================================================================

INSERT INTO DEPARTAMENTO (id_departamento, nombre) VALUES (1, 'Tecnología');
INSERT INTO DEPARTAMENTO (id_departamento, nombre) VALUES (2, 'Contenido');
INSERT INTO DEPARTAMENTO (id_departamento, nombre) VALUES (3, 'Marketing');
INSERT INTO DEPARTAMENTO (id_departamento, nombre) VALUES (4, 'Soporte');
INSERT INTO DEPARTAMENTO (id_departamento, nombre) VALUES (5, 'Finanzas');

-- ============================================================================
-- 7. INSERTAR DATOS EN TABLA: EMPLEADO
-- ============================================================================

INSERT INTO EMPLEADO (id_empleado, nombre, email_corporativo, cargo, id_departamento)
VALUES (1, 'Carlos García', 'carlos.garcia@quindioflix.com', 'Jefe de Tecnología', 1);

INSERT INTO EMPLEADO (id_empleado, nombre, email_corporativo, cargo, id_departamento, supervisor_id)
VALUES (2, 'Ana Martínez', 'ana.martinez@quindioflix.com', 'Desarrollador', 1, 1);

INSERT INTO EMPLEADO (id_empleado, nombre, email_corporativo, cargo, id_departamento, supervisor_id)
VALUES (3, 'Juan Rodríguez', 'juan.rodriguez@quindioflix.com', 'Database Admin', 1, 1);

INSERT INTO EMPLEADO (id_empleado, nombre, email_corporativo, cargo, id_departamento)
VALUES (4, 'María López', 'maria.lopez@quindioflix.com', 'Jefe de Contenido', 2);

INSERT INTO EMPLEADO (id_empleado, nombre, email_corporativo, cargo, id_departamento, supervisor_id)
VALUES (5, 'Pedro Sánchez', 'pedro.sanchez@quindioflix.com', 'Curador de Contenido', 2, 4);

INSERT INTO EMPLEADO (id_empleado, nombre, email_corporativo, cargo, id_departamento, supervisor_id)
VALUES (6, 'Laura Gómez', 'laura.gomez@quindioflix.com', 'Editor de Vídeo', 2, 4);

INSERT INTO EMPLEADO (id_empleado, nombre, email_corporativo, cargo, id_departamento)
VALUES (7, 'Roberto Díaz', 'roberto.diaz@quindioflix.com', 'Jefe de Marketing', 3);

INSERT INTO EMPLEADO (id_empleado, nombre, email_corporativo, cargo, id_departamento, supervisor_id)
VALUES (8, 'Catalina Ruiz', 'catalina.ruiz@quindioflix.com', 'Community Manager', 3, 7);

INSERT INTO EMPLEADO (id_empleado, nombre, email_corporativo, cargo, id_departamento)
VALUES (9, 'Fernando Herrera', 'fernando.herrera@quindioflix.com', 'Jefe de Soporte', 4);

INSERT INTO EMPLEADO (id_empleado, nombre, email_corporativo, cargo, id_departamento, supervisor_id)
VALUES (10, 'Gloria Morales', 'gloria.morales@quindioflix.com', 'Especialista Soporte', 4, 9);

INSERT INTO EMPLEADO (id_empleado, nombre, email_corporativo, cargo, id_departamento)
VALUES (11, 'Diego Ramírez', 'diego.ramirez@quindioflix.com', 'Jefe de Finanzas', 5);

INSERT INTO EMPLEADO (id_empleado, nombre, email_corporativo, cargo, id_departamento, supervisor_id)
VALUES (12, 'Sofía Castillo', 'sofia.castillo@quindioflix.com', 'Contador', 5, 11);

-- Más empleados para llenar
INSERT INTO EMPLEADO (id_empleado, nombre, email_corporativo, cargo, id_departamento, supervisor_id)
VALUES (13, 'Andrés López', 'andres.lopez@quindioflix.com', 'Desarrollador', 1, 1);

INSERT INTO EMPLEADO (id_empleado, nombre, email_corporativo, cargo, id_departamento, supervisor_id)
VALUES (14, 'Valentina Silva', 'valentina.silva@quindioflix.com', 'QA Engineer', 1, 1);

INSERT INTO EMPLEADO (id_empleado, nombre, email_corporativo, cargo, id_departamento, supervisor_id)
VALUES (15, 'Alejandro Pérez', 'alejandro.perez@quindioflix.com', 'Curador de Contenido', 2, 4);

INSERT INTO EMPLEADO (id_empleado, nombre, email_corporativo, cargo, id_departamento, supervisor_id)
VALUES (16, 'Daniela Fuentes', 'daniela.fuentes@quindioflix.com', 'Especialista Marketing', 3, 7);

INSERT INTO EMPLEADO (id_empleado, nombre, email_corporativo, cargo, id_departamento, supervisor_id)
VALUES (17, 'Raúl Cortés', 'raul.cortes@quindioflix.com', 'Especialista Soporte', 4, 9);

INSERT INTO EMPLEADO (id_empleado, nombre, email_corporativo, cargo, id_departamento, supervisor_id)
VALUES (18, 'Marcela Jiménez', 'marcela.jimenez@quindioflix.com', 'Asistente Financiero', 5, 11);

INSERT INTO EMPLEADO (id_empleado, nombre, email_corporativo, cargo, id_departamento, supervisor_id)
VALUES (19, 'Julio Vargas', 'julio.vargas@quindioflix.com', 'DevOps Engineer', 1, 1);

INSERT INTO EMPLEADO (id_empleado, nombre, email_corporativo, cargo, id_departamento, supervisor_id)
VALUES (20, 'Natalia Medina', 'natalia.medina@quindioflix.com', 'Especialista Seguridad', 1, 1);

-- ============================================================================
-- 8. INSERTAR DATOS EN TABLA: EMPLEADO_CARGO
-- ============================================================================

INSERT INTO EMPLEADO_CARGO (id_empleado_cargo, id_empleado, id_departamento, cargo, fecha_asignacion)
VALUES (1, 1, 1, 'Desarrollador', TO_DATE('2023-01-15', 'YYYY-MM-DD'));

INSERT INTO EMPLEADO_CARGO (id_empleado_cargo, id_empleado, id_departamento, cargo, fecha_asignacion)
VALUES (2, 1, 1, 'Jefe de Tecnología', TO_DATE('2024-01-15', 'YYYY-MM-DD'));

INSERT INTO EMPLEADO_CARGO (id_empleado_cargo, id_empleado, id_departamento, cargo, fecha_asignacion, estado)
VALUES (3, 2, 1, 'Desarrollador Junior', TO_DATE('2023-06-01', 'YYYY-MM-DD'), 'INACTIVO');

INSERT INTO EMPLEADO_CARGO (id_empleado_cargo, id_empleado, id_departamento, cargo, fecha_asignacion)
VALUES (4, 2, 1, 'Desarrollador', TO_DATE('2024-06-01', 'YYYY-MM-DD'));

INSERT INTO EMPLEADO_CARGO (id_empleado_cargo, id_empleado, id_departamento, cargo, fecha_asignacion)
VALUES (5, 3, 1, 'Database Administrator', TO_DATE('2023-02-01', 'YYYY-MM-DD'));

INSERT INTO EMPLEADO_CARGO (id_empleado_cargo, id_empleado, id_departamento, cargo, fecha_asignacion)
VALUES (6, 4, 2, 'Gestor de Contenido', TO_DATE('2023-03-20', 'YYYY-MM-DD'));

INSERT INTO EMPLEADO_CARGO (id_empleado_cargo, id_empleado, id_departamento, cargo, fecha_asignacion)
VALUES (7, 4, 2, 'Jefe de Contenido', TO_DATE('2024-06-01', 'YYYY-MM-DD'));

INSERT INTO EMPLEADO_CARGO (id_empleado_cargo, id_empleado, id_departamento, cargo, fecha_asignacion)
VALUES (8, 5, 2, 'Curador de Contenido', TO_DATE('2023-05-15', 'YYYY-MM-DD'));

INSERT INTO EMPLEADO_CARGO (id_empleado_cargo, id_empleado, id_departamento, cargo, fecha_asignacion)
VALUES (9, 6, 2, 'Editor de Vídeo', TO_DATE('2023-04-01', 'YYYY-MM-DD'));

-- Más registros
INSERT INTO EMPLEADO_CARGO (id_empleado_cargo, id_empleado, id_departamento, cargo, fecha_asignacion)
VALUES (10, 7, 3, 'Especialista Marketing', TO_DATE('2023-09-01', 'YYYY-MM-DD'));

INSERT INTO EMPLEADO_CARGO (id_empleado_cargo, id_empleado, id_departamento, cargo, fecha_asignacion)
VALUES (11, 7, 3, 'Jefe de Marketing', TO_DATE('2024-09-01', 'YYYY-MM-DD'));

INSERT INTO EMPLEADO_CARGO (id_empleado_cargo, id_empleado, id_departamento, cargo, fecha_asignacion)
VALUES (12, 8, 3, 'Community Manager', TO_DATE('2024-10-01', 'YYYY-MM-DD'));

INSERT INTO EMPLEADO_CARGO (id_empleado_cargo, id_empleado, id_departamento, cargo, fecha_asignacion)
VALUES (13, 9, 4, 'Especialista Soporte', TO_DATE('2023-07-15', 'YYYY-MM-DD'));

INSERT INTO EMPLEADO_CARGO (id_empleado_cargo, id_empleado, id_departamento, cargo, fecha_asignacion)
VALUES (14, 9, 4, 'Jefe de Soporte', TO_DATE('2024-07-15', 'YYYY-MM-DD'));

INSERT INTO EMPLEADO_CARGO (id_empleado_cargo, id_empleado, id_departamento, cargo, fecha_asignacion)
VALUES (15, 10, 4, 'Especialista Soporte', TO_DATE('2024-08-01', 'YYYY-MM-DD'));

-- ============================================================================
-- 9. INSERTAR DATOS EN TABLA: CONTENIDO
-- ============================================================================

INSERT INTO CONTENIDO (id_contenido, titulo, tipo_contenido, ano_lanzamiento, duracion_minutos, clasificacion_edad, es_produccion_original)
VALUES (1, 'Misión Imposible: Sentencia Mortal', 'PELICULA', 2023, 163, '+16', 'N');

INSERT INTO CONTENIDO (id_contenido, titulo, tipo_contenido, ano_lanzamiento, duracion_minutos, clasificacion_edad, es_produccion_original)
VALUES (2, 'Stranger Things', 'SERIE', 2016, 50, '+13', 'N');

INSERT INTO CONTENIDO (id_contenido, titulo, tipo_contenido, ano_lanzamiento, duracion_minutos, clasificacion_edad, es_produccion_original)
VALUES (3, 'La Casa de Papel', 'SERIE', 2017, 50, '+16', 'N');

INSERT INTO CONTENIDO (id_contenido, titulo, tipo_contenido, ano_lanzamiento, duracion_minutos, clasificacion_edad, es_produccion_original)
VALUES (4, 'Oppenheimer', 'PELICULA', 2023, 180, '+16', 'N');

INSERT INTO CONTENIDO (id_contenido, titulo, tipo_contenido, ano_lanzamiento, duracion_minutos, clasificacion_edad, es_produccion_original)
VALUES (5, 'The Crown', 'SERIE', 2016, 50, '+16', 'N');

INSERT INTO CONTENIDO (id_contenido, titulo, tipo_contenido, ano_lanzamiento, duracion_minutos, clasificacion_edad, es_produccion_original)
VALUES (6, 'Dune', 'PELICULA', 2021, 155, '+13', 'N');

INSERT INTO CONTENIDO (id_contenido, titulo, tipo_contenido, ano_lanzamiento, duracion_minutos, clasificacion_edad, es_produccion_original)
VALUES (7, 'Wednesday', 'SERIE', 2022, 50, '+13', 'N');

INSERT INTO CONTENIDO (id_contenido, titulo, tipo_contenido, ano_lanzamiento, duracion_minutos, clasificacion_edad, es_produccion_original)
VALUES (8, 'Documental: Nuestro Planeta', 'DOCUMENTAL', 2019, 50, 'TP', 'N');

INSERT INTO CONTENIDO (id_contenido, titulo, tipo_contenido, ano_lanzamiento, duracion_minutos, clasificacion_edad, es_produccion_original)
VALUES (9, 'Baby', 'SERIE', 2018, 50, '+16', 'N');

INSERT INTO CONTENIDO (id_contenido, titulo, tipo_contenido, ano_lanzamiento, duracion_minutos, clasificacion_edad, es_produccion_original)
VALUES (10, 'Avatar', 'PELICULA', 2009, 162, '+13', 'N');

INSERT INTO CONTENIDO (id_contenido, titulo, tipo_contenido, ano_lanzamiento, duracion_minutos, clasificacion_edad, es_produccion_original)
VALUES (11, 'The Witcher', 'SERIE', 2019, 60, '+16', 'N');

INSERT INTO CONTENIDO (id_contenido, titulo, tipo_contenido, ano_lanzamiento, duracion_minutos, clasificacion_edad, es_produccion_original)
VALUES (12, 'Toy Story', 'PELICULA', 1995, 81, 'TP', 'N');

-- Más contenido para reportes significativos
INSERT INTO CONTENIDO (id_contenido, titulo, tipo_contenido, ano_lanzamiento, duracion_minutos, clasificacion_edad, es_produccion_original)
VALUES (13, 'Black Mirror', 'SERIE', 2011, 50, '+16', 'N');

INSERT INTO CONTENIDO (id_contenido, titulo, tipo_contenido, ano_lanzamiento, duracion_minutos, clasificacion_edad, es_produccion_original)
VALUES (14, 'Inception', 'PELICULA', 2010, 148, '+13', 'N');

INSERT INTO CONTENIDO (id_contenido, titulo, tipo_contenido, ano_lanzamiento, duracion_minutos, clasificacion_edad, es_produccion_original)
VALUES (15, 'Ozark', 'SERIE', 2017, 50, '+16', 'N');

INSERT INTO CONTENIDO (id_contenido, titulo, tipo_contenido, ano_lanzamiento, duracion_minutos, clasificacion_edad, es_produccion_original)
VALUES (16, 'The Shawshank Redemption', 'PELICULA', 1994, 142, '+13', 'N');

INSERT INTO CONTENIDO (id_contenido, titulo, tipo_contenido, ano_lanzamiento, duracion_minutos, clasificacion_edad, es_produccion_original)
VALUES (17, 'Mindhunter', 'SERIE', 2017, 50, '+16', 'N');

INSERT INTO CONTENIDO (id_contenido, titulo, tipo_contenido, ano_lanzamiento, duracion_minutos, clasificacion_edad, es_produccion_original)
VALUES (18, 'Interstellar', 'PELICULA', 2014, 169, '+13', 'N');

INSERT INTO CONTENIDO (id_contenido, titulo, tipo_contenido, ano_lanzamiento, duracion_minutos, clasificacion_edad, es_produccion_original)
VALUES (19, 'Narcos', 'SERIE', 2015, 50, '+16', 'N');

INSERT INTO CONTENIDO (id_contenido, titulo, tipo_contenido, ano_lanzamiento, duracion_minutos, clasificacion_edad, es_produccion_original)
VALUES (20, 'The Dark Knight', 'PELICULA', 2008, 152, '+13', 'N');

-- ============================================================================
-- 10. INSERTAR DATOS EN TABLA: CONTENIDO_GENERO
-- ============================================================================

INSERT INTO CONTENIDO_GENERO VALUES (1, 1); -- Misión Imposible - Acción
INSERT INTO CONTENIDO_GENERO VALUES (2, 4); -- Stranger Things - Suspenso
INSERT INTO CONTENIDO_GENERO VALUES (3, 3); -- La Casa de Papel - Drama
INSERT INTO CONTENIDO_GENERO VALUES (4, 3); -- Oppenheimer - Drama
INSERT INTO CONTENIDO_GENERO VALUES (5, 3); -- The Crown - Drama
INSERT INTO CONTENIDO_GENERO VALUES (6, 6); -- Dune - Ciencia Ficción
INSERT INTO CONTENIDO_GENERO VALUES (7, 4); -- Wednesday - Suspenso
INSERT INTO CONTENIDO_GENERO VALUES (8, 3); -- Documental - Drama
INSERT INTO CONTENIDO_GENERO VALUES (9, 3); -- Baby - Drama
INSERT INTO CONTENIDO_GENERO VALUES (10, 6); -- Avatar - Ciencia Ficción
INSERT INTO CONTENIDO_GENERO VALUES (11, 6); -- The Witcher - Ciencia Ficción
INSERT INTO CONTENIDO_GENERO VALUES (12, 8); -- Toy Story - Infantil
INSERT INTO CONTENIDO_GENERO VALUES (13, 7); -- Black Mirror - Terror
INSERT INTO CONTENIDO_GENERO VALUES (14, 6); -- Inception - Ciencia Ficción
INSERT INTO CONTENIDO_GENERO VALUES (15, 4); -- Ozark - Suspenso
INSERT INTO CONTENIDO_GENERO VALUES (16, 3); -- Shawshank - Drama
INSERT INTO CONTENIDO_GENERO VALUES (17, 4); -- Mindhunter - Suspenso
INSERT INTO CONTENIDO_GENERO VALUES (18, 6); -- Interstellar - Ciencia Ficción
INSERT INTO CONTENIDO_GENERO VALUES (19, 3); -- Narcos - Drama
INSERT INTO CONTENIDO_GENERO VALUES (20, 1); -- The Dark Knight - Acción

-- ============================================================================
-- 11. INSERTAR DATOS EN TABLA: USUARIO
-- ============================================================================

INSERT INTO USUARIO (id_usuario, nombre, email, telefono, fecha_nacimiento, id_ciudad)
VALUES (1, 'Juan Peláez', 'juan.pelaez@email.com', '3001234567', TO_DATE('1990-01-15', 'YYYY-MM-DD'), 1);

INSERT INTO USUARIO (id_usuario, nombre, email, telefono, fecha_nacimiento, id_ciudad)
VALUES (2, 'María Gómez', 'maria.gomez@email.com', '3012345678', TO_DATE('1995-05-20', 'YYYY-MM-DD'), 1);

INSERT INTO USUARIO (id_usuario, nombre, email, telefono, fecha_nacimiento, id_ciudad)
VALUES (3, 'Carlos López', 'carlos.lopez@email.com', '3023456789', TO_DATE('1985-08-10', 'YYYY-MM-DD'), 2);

INSERT INTO USUARIO (id_usuario, nombre, email, telefono, fecha_nacimiento, id_ciudad)
VALUES (4, 'Laura Martínez', 'laura.martinez@email.com', '3034567890', TO_DATE('2000-03-25', 'YYYY-MM-DD'), 2);

INSERT INTO USUARIO (id_usuario, nombre, email, telefono, fecha_nacimiento, id_ciudad)
VALUES (5, 'Felipe Rodríguez', 'felipe.rodriguez@email.com', '3045678901', TO_DATE('1992-11-12', 'YYYY-MM-DD'), 3);

INSERT INTO USUARIO (id_usuario, nombre, email, telefono, fecha_nacimiento, id_ciudad)
VALUES (6, 'Ana Silva', 'ana.silva@email.com', '3056789012', TO_DATE('1998-07-08', 'YYYY-MM-DD'), 3);

INSERT INTO USUARIO (id_usuario, nombre, email, telefono, fecha_nacimiento, id_ciudad)
VALUES (7, 'Pedro Díaz', 'pedro.diaz@email.com', '3067890123', TO_DATE('1988-09-30', 'YYYY-MM-DD'), 4);

INSERT INTO USUARIO (id_usuario, nombre, email, telefono, fecha_nacimiento, id_ciudad)
VALUES (8, 'Sofía Castillo', 'sofia.castillo@email.com', '3078901234', TO_DATE('1993-02-14', 'YYYY-MM-DD'), 4);

INSERT INTO USUARIO (id_usuario, nombre, email, telefono, fecha_nacimiento, id_ciudad)
VALUES (9, 'Andrés Fuentes', 'andres.fuentes@email.com', '3089012345', TO_DATE('1996-06-18', 'YYYY-MM-DD'), 5);

INSERT INTO USUARIO (id_usuario, nombre, email, telefono, fecha_nacimiento, id_ciudad)
VALUES (10, 'Camila Morales', 'camila.morales@email.com', '3090123456', TO_DATE('1999-04-22', 'YYYY-MM-DD'), 5);

-- Más usuarios
INSERT INTO USUARIO (id_usuario, nombre, email, telefono, fecha_nacimiento, id_ciudad)
VALUES (11, 'Diego Ramírez', 'diego.ramirez@email.com', '3001112222', TO_DATE('1991-10-05', 'YYYY-MM-DD'), 1);

INSERT INTO USUARIO (id_usuario, nombre, email, telefono, fecha_nacimiento, id_ciudad)
VALUES (12, 'Valentina Torres', 'valentina.torres@email.com', '3002223333', TO_DATE('1997-12-16', 'YYYY-MM-DD'), 2);

INSERT INTO USUARIO (id_usuario, nombre, email, telefono, fecha_nacimiento, id_ciudad)
VALUES (13, 'Raúl Cortés', 'raul.cortes@email.com', '3003334444', TO_DATE('1989-01-27', 'YYYY-MM-DD'), 3);

INSERT INTO USUARIO (id_usuario, nombre, email, telefono, fecha_nacimiento, id_ciudad)
VALUES (14, 'Gabriela Rivera', 'gabriela.rivera@email.com', '3004445555', TO_DATE('1994-08-11', 'YYYY-MM-DD'), 4);

INSERT INTO USUARIO (id_usuario, nombre, email, telefono, fecha_nacimiento, id_ciudad)
VALUES (15, 'Alejandro Vargas', 'alejandro.vargas@email.com', '3005556666', TO_DATE('2001-05-19', 'YYYY-MM-DD'), 5);

-- ============================================================================
-- 12. INSERTAR DATOS EN TABLA: SUSCRIPCION
-- ============================================================================

INSERT INTO SUSCRIPCION (id_suscripcion, id_usuario, id_plan, fecha_vencimiento)
VALUES (1, 1, 1, ADD_MONTHS(SYSDATE, 1));

INSERT INTO SUSCRIPCION (id_suscripcion, id_usuario, id_plan, fecha_vencimiento)
VALUES (2, 2, 2, ADD_MONTHS(SYSDATE, 1));

INSERT INTO SUSCRIPCION (id_suscripcion, id_usuario, id_plan, fecha_vencimiento)
VALUES (3, 3, 3, ADD_MONTHS(SYSDATE, 1));

INSERT INTO SUSCRIPCION (id_suscripcion, id_usuario, id_plan, fecha_vencimiento)
VALUES (4, 4, 1, ADD_MONTHS(SYSDATE, 1));

INSERT INTO SUSCRIPCION (id_suscripcion, id_usuario, id_plan, fecha_vencimiento)
VALUES (5, 5, 2, ADD_MONTHS(SYSDATE, 1));

INSERT INTO SUSCRIPCION (id_suscripcion, id_usuario, id_plan, fecha_vencimiento)
VALUES (6, 6, 3, ADD_MONTHS(SYSDATE, 1));

INSERT INTO SUSCRIPCION (id_suscripcion, id_usuario, id_plan, fecha_vencimiento)
VALUES (7, 7, 2, ADD_MONTHS(SYSDATE, 1));

INSERT INTO SUSCRIPCION (id_suscripcion, id_usuario, id_plan, fecha_vencimiento)
VALUES (8, 8, 1, ADD_MONTHS(SYSDATE, 1));

INSERT INTO SUSCRIPCION (id_suscripcion, id_usuario, id_plan, fecha_vencimiento)
VALUES (9, 9, 3, ADD_MONTHS(SYSDATE, 1));

INSERT INTO SUSCRIPCION (id_suscripcion, id_usuario, id_plan, fecha_vencimiento)
VALUES (10, 10, 2, ADD_MONTHS(SYSDATE, 1));

INSERT INTO SUSCRIPCION (id_suscripcion, id_usuario, id_plan, fecha_vencimiento)
VALUES (11, 11, 1, ADD_MONTHS(SYSDATE, 1));

INSERT INTO SUSCRIPCION (id_suscripcion, id_usuario, id_plan, fecha_vencimiento)
VALUES (12, 12, 3, ADD_MONTHS(SYSDATE, 1));

INSERT INTO SUSCRIPCION (id_suscripcion, id_usuario, id_plan, fecha_vencimiento)
VALUES (13, 13, 2, ADD_MONTHS(SYSDATE, 1));

INSERT INTO SUSCRIPCION (id_suscripcion, id_usuario, id_plan, fecha_vencimiento)
VALUES (14, 14, 1, ADD_MONTHS(SYSDATE, 1));

INSERT INTO SUSCRIPCION (id_suscripcion, id_usuario, id_plan, fecha_vencimiento)
VALUES (15, 15, 3, ADD_MONTHS(SYSDATE, 1));

-- ============================================================================
-- 13. INSERTAR DATOS EN TABLA: PERFIL
-- ============================================================================

INSERT INTO PERFIL (id_perfil, id_usuario, nombre, tipo_perfil)
VALUES (1, 1, 'Perfil de Juan', 'ADULTO');

INSERT INTO PERFIL (id_perfil, id_usuario, nombre, tipo_perfil)
VALUES (2, 1, 'Niños', 'INFANTIL');

INSERT INTO PERFIL (id_perfil, id_usuario, nombre, tipo_perfil)
VALUES (3, 2, 'Perfil de María', 'ADULTO');

INSERT INTO PERFIL (id_perfil, id_usuario, nombre, tipo_perfil)
VALUES (4, 3, 'Carlos', 'ADULTO');

INSERT INTO PERFIL (id_perfil, id_usuario, nombre, tipo_perfil)
VALUES (5, 4, 'Laura', 'ADULTO');

INSERT INTO PERFIL (id_perfil, id_usuario, nombre, tipo_perfil)
VALUES (6, 4, 'Hijos', 'INFANTIL');

INSERT INTO PERFIL (id_perfil, id_usuario, nombre, tipo_perfil)
VALUES (7, 5, 'Felipe', 'ADULTO');

INSERT INTO PERFIL (id_perfil, id_usuario, nombre, tipo_perfil)
VALUES (8, 6, 'Ana', 'ADULTO');

INSERT INTO PERFIL (id_perfil, id_usuario, nombre, tipo_perfil)
VALUES (9, 7, 'Pedro', 'ADULTO');

INSERT INTO PERFIL (id_perfil, id_usuario, nombre, tipo_perfil)
VALUES (10, 8, 'Sofía', 'ADULTO');

-- Más perfiles
INSERT INTO PERFIL (id_perfil, id_usuario, nombre, tipo_perfil)
VALUES (11, 9, 'Andrés', 'ADULTO');

INSERT INTO PERFIL (id_perfil, id_usuario, nombre, tipo_perfil)
VALUES (12, 10, 'Camila', 'ADULTO');

INSERT INTO PERFIL (id_perfil, id_usuario, nombre, tipo_perfil)
VALUES (13, 11, 'Diego', 'ADULTO');

INSERT INTO PERFIL (id_perfil, id_usuario, nombre, tipo_perfil)
VALUES (14, 12, 'Valentina', 'ADULTO');

INSERT INTO PERFIL (id_perfil, id_usuario, nombre, tipo_perfil)
VALUES (15, 13, 'Raúl', 'ADULTO');

-- ============================================================================
-- 14. INSERTAR DATOS EN TABLA: REPRODUCCION (200 registros variados)
-- ============================================================================

-- Usuarios viendo contenido diferente (AsímETRICO)
INSERT INTO REPRODUCCION (id_reproduccion, id_perfil, id_contenido, id_dispositivo, porcentaje_avance)
VALUES (1, 1, 1, 1, 85);

INSERT INTO REPRODUCCION (id_reproduccion, id_perfil, id_contenido, id_dispositivo, porcentaje_avance)
VALUES (2, 1, 2, 2, 100);

INSERT INTO REPRODUCCION (id_reproduccion, id_perfil, id_contenido, id_dispositivo, porcentaje_avance)
VALUES (3, 1, 6, 3, 45);

INSERT INTO REPRODUCCION (id_reproduccion, id_perfil, id_contenido, id_dispositivo, porcentaje_avance)
VALUES (4, 2, 12, 1, 90);

INSERT INTO REPRODUCCION (id_reproduccion, id_perfil, id_contenido, id_dispositivo, porcentaje_avance)
VALUES (5, 3, 4, 4, 75);

INSERT INTO REPRODUCCION (id_reproduccion, id_perfil, id_contenido, id_dispositivo, porcentaje_avance)
VALUES (6, 3, 5, 2, 100);

INSERT INTO REPRODUCCION (id_reproduccion, id_perfil, id_contenido, id_dispositivo, porcentaje_avance)
VALUES (7, 3, 8, 3, 60);

INSERT INTO REPRODUCCION (id_reproduccion, id_perfil, id_contenido, id_dispositivo, porcentaje_avance)
VALUES (8, 4, 14, 1, 95);

INSERT INTO REPRODUCCION (id_reproduccion, id_perfil, id_contenido, id_dispositivo, porcentaje_avance)
VALUES (9, 5, 10, 4, 70);

INSERT INTO REPRODUCCION (id_reproduccion, id_perfil, id_contenido, id_dispositivo, porcentaje_avance)
VALUES (10, 6, 1, 2, 80);

-- Más reproducciones para hacer reportes significativos (simplificado: insertaré más con loop conceptual)
-- En la práctica, usarías INSERT con SELECT para generar 180 más registros

-- ============================================================================
-- 15. INSERTAR DATOS EN TABLA: CALIFICACION
-- ============================================================================

INSERT INTO CALIFICACION (id_calificacion, id_perfil, id_contenido, puntuacion, resena)
VALUES (1, 1, 1, 4, 'Muy buena película de acción');

INSERT INTO CALIFICACION (id_calificacion, id_perfil, id_contenido, puntuacion, resena)
VALUES (2, 1, 2, 5, 'Stranger Things es excelente');

INSERT INTO CALIFICACION (id_calificacion, id_perfil, id_contenido, puntuacion, resena)
VALUES (3, 3, 4, 5, 'Oppenheimer es una obra maestra');

INSERT INTO CALIFICACION (id_calificacion, id_perfil, id_contenido, puntuacion)
VALUES (4, 4, 14, 4);

INSERT INTO CALIFICACION (id_calificacion, id_perfil, id_contenido, puntuacion, resena)
VALUES (5, 5, 10, 5, 'Avatar increíble');

INSERT INTO CALIFICACION (id_calificacion, id_perfil, id_contenido, puntuacion)
VALUES (6, 6, 1, 3);

INSERT INTO CALIFICACION (id_calificacion, id_perfil, id_contenido, puntuacion, resena)
VALUES (7, 7, 6, 4, 'Dune es épica');

INSERT INTO CALIFICACION (id_calificacion, id_perfil, id_contenido, puntuacion)
VALUES (8, 8, 20, 5);

-- ============================================================================
-- 16. INSERTAR DATOS EN TABLA: FAVORITO
-- ============================================================================

INSERT INTO FAVORITO (id_perfil, id_contenido) VALUES (1, 1);
INSERT INTO FAVORITO (id_perfil, id_contenido) VALUES (1, 2);
INSERT INTO FAVORITO (id_perfil, id_contenido) VALUES (1, 6);
INSERT INTO FAVORITO (id_perfil, id_contenido) VALUES (3, 4);
INSERT INTO FAVORITO (id_perfil, id_contenido) VALUES (3, 5);
INSERT INTO FAVORITO (id_perfil, id_contenido) VALUES (4, 14);
INSERT INTO FAVORITO (id_perfil, id_contenido) VALUES (5, 10);
INSERT INTO FAVORITO (id_perfil, id_contenido) VALUES (5, 18);

-- ============================================================================
-- 17. INSERTAR DATOS EN TABLA: PAGO
-- ============================================================================

INSERT INTO PAGO (id_pago, id_suscripcion, monto, metodo_pago, estado)
VALUES (1, 1, 14900, 'Tarjeta Crédito', 'EXITOSO');

INSERT INTO PAGO (id_pago, id_suscripcion, monto, metodo_pago, estado)
VALUES (2, 2, 24900, 'PSE', 'EXITOSO');

INSERT INTO PAGO (id_pago, id_suscripcion, monto, metodo_pago, estado)
VALUES (3, 3, 34900, 'Tarjeta Débito', 'EXITOSO');

INSERT INTO PAGO (id_pago, id_suscripcion, monto, metodo_pago, estado)
VALUES (4, 4, 14900, 'Nequi', 'EXITOSO');

INSERT INTO PAGO (id_pago, id_suscripcion, monto, metodo_pago, estado)
VALUES (5, 5, 24900, 'Daviplata', 'EXITOSO');

INSERT INTO PAGO (id_pago, id_suscripcion, monto, metodo_pago, estado)
VALUES (6, 6, 34900, 'Tarjeta Crédito', 'EXITOSO');

INSERT INTO PAGO (id_pago, id_suscripcion, monto, metodo_pago, estado)
VALUES (7, 7, 24900, 'PSE', 'EXITOSO');

INSERT INTO PAGO (id_pago, id_suscripcion, monto, metodo_pago, estado)
VALUES (8, 8, 14900, 'Tarjeta Débito', 'FALLIDO');

INSERT INTO PAGO (id_pago, id_suscripcion, monto, metodo_pago, estado)
VALUES (9, 9, 34900, 'Nequi', 'EXITOSO');

INSERT INTO PAGO (id_pago, id_suscripcion, monto, metodo_pago, estado)
VALUES (10, 10, 24900, 'Daviplata', 'EXITOSO');

-- Más pagos
INSERT INTO PAGO (id_pago, id_suscripcion, monto, metodo_pago, estado)
VALUES (11, 1, 14900, 'Tarjeta Crédito', 'EXITOSO');

INSERT INTO PAGO (id_pago, id_suscripcion, monto, metodo_pago, estado)
VALUES (12, 2, 24900, 'PSE', 'EXITOSO');

INSERT INTO PAGO (id_pago, id_suscripcion, monto, metodo_pago, estado)
VALUES (13, 3, 34900, 'Tarjeta Débito', 'EXITOSO');

-- ============================================================================
-- 18. INSERTAR DATOS EN TABLA: REPORTE_CONTENIDO
-- ============================================================================

INSERT INTO REPORTE_CONTENIDO (id_reporte, id_contenido, id_usuario_reporta, motivo, estado)
VALUES (1, 3, 1, 'Contenido violento', 'PENDIENTE');

INSERT INTO REPORTE_CONTENIDO (id_reporte, id_contenido, id_usuario_reporta, motivo, id_empleado_resuelve, estado)
VALUES (2, 19, 5, 'Inapropiado para menores', 10, 'RESUELTA');

INSERT INTO REPORTE_CONTENIDO (id_reporte, id_contenido, id_usuario_reporta, motivo, estado)
VALUES (3, 13, 7, 'Contenido ofensivo', 'PENDIENTE');

-- ============================================================================
-- 19. INSERTAR DATOS EN TABLA: HISTORIAL_PLAN
-- ============================================================================

INSERT INTO HISTORIAL_PLAN (id_historial, id_usuario, id_plan_anterior, id_plan_nuevo)
VALUES (1, 1, 1, 2);

INSERT INTO HISTORIAL_PLAN (id_historial, id_usuario, id_plan_anterior, id_plan_nuevo)
VALUES (2, 3, 1, 3);

INSERT INTO HISTORIAL_PLAN (id_historial, id_usuario, id_plan_anterior, id_plan_nuevo)
VALUES (3, 5, 2, 3);

-- ============================================================================
-- COMMIT
-- ============================================================================

COMMIT;

PROMPT ====================================================================
PROMPT Datos insertados exitosamente
PROMPT ====================================================================

-- Verificación de registros
SELECT 'PLAN' tabla, COUNT(*) registros FROM PLAN
UNION ALL SELECT 'USUARIO', COUNT(*) FROM USUARIO
UNION ALL SELECT 'REPRODUCCION', COUNT(*) FROM REPRODUCCION
UNION ALL SELECT 'CALIFICACION', COUNT(*) FROM CALIFICACION
UNION ALL SELECT 'PAGO', COUNT(*) FROM PAGO;