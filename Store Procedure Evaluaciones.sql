USE sistema_evaluaciones;

-- =====================================================
-- ROLES
-- =====================================================

-- //////////////////////////////////
-- LISTAR ROLES
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_roles;

DELIMITER $$

CREATE PROCEDURE sp_listar_roles()
BEGIN

    SELECT
        id,
        nombre,
        estado,
        fecha_creacion,
        fecha_actualizacion
    FROM rol
    ORDER BY nombre;

END $$

DELIMITER ;
call sp_listar_roles;

-- //////////////////////////////////
-- LISTAR ROLES ACTIVOS
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_roles_activos;

DELIMITER $$
CREATE PROCEDURE sp_listar_roles_activos()
BEGIN

    SELECT
        id,
        nombre,
        estado,
        fecha_creacion,
        fecha_actualizacion
    FROM rol
    WHERE estado = 1
    ORDER BY nombre;

END $$
DELIMITER ;

-- //////////////////////////////////
-- LISTAR ROLES POR ID
-- //////////////////////////////////
USE sistema_evaluaciones;
DROP PROCEDURE IF EXISTS sp_listar_roles_id;

DELIMITER $$

CREATE PROCEDURE sp_listar_roles_id(IN id_rol BIGINT)
BEGIN

    SELECT
        id,
        nombre,
        estado,
        fecha_creacion,
        fecha_actualizacion
    FROM rol
    WHERE id = id_rol
    ORDER BY nombre;

END $$

DELIMITER ;
-- //////////////////////////////////
-- BUSCAR ROL POR NOMBRE
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_buscar_rol_nombre;

DELIMITER $$

CREATE PROCEDURE sp_buscar_rol_nombre(
    IN p_nombre VARCHAR(100)
)
BEGIN

    SELECT
        id,
        nombre,
        estado,
        fecha_creacion,
        fecha_actualizacion
    FROM rol
    WHERE LOWER(nombre) = LOWER(p_nombre)
    LIMIT 1;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CREAR ROL
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_crear_rol;

DELIMITER $$

CREATE PROCEDURE sp_crear_rol(
    IN p_nombre VARCHAR(100)
)
BEGIN

    INSERT INTO rol (
        nombre
    )
    VALUES (
        p_nombre
    );

    SELECT LAST_INSERT_ID() AS id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- ACTUALIZAR ROL
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_actualizar_rol;

DELIMITER $$

CREATE PROCEDURE sp_actualizar_rol(
    IN p_id BIGINT,
    IN p_nombre VARCHAR(100)
)
BEGIN

    UPDATE rol
    SET nombre = p_nombre
    WHERE id = p_id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CAMBIAR ESTADO ROL
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_estado_rol;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_estado_rol(
    IN p_id BIGINT,
    IN p_estado TINYINT
)
BEGIN

    UPDATE rol
    SET estado = p_estado
    WHERE id = p_id;

END $$

DELIMITER ;
-- =====================================================
-- USUARIOS
-- =====================================================


-- //////////////////////////////////
-- BUSCAR USUARIO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_buscar_usuario_correo;

DELIMITER $$

CREATE PROCEDURE sp_buscar_usuario_correo(
    IN p_correo VARCHAR(150)
)
BEGIN

    SELECT
        id,
        nombre,
        correo,
        contrasena,
        estado
    FROM usuarios
    WHERE correo = p_correo
    AND estado = 1;


    SELECT
        r.id,
        r.nombre
    FROM usuarios u

    INNER JOIN usuario_rol ur
        ON ur.id_usuario = u.id

    INNER JOIN rol r
        ON r.id = ur.id_rol

    WHERE u.correo = p_correo
    AND ur.estado = 1
    AND r.estado = 1;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CREAR USUARIO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_crear_usuario;

DELIMITER $$

CREATE PROCEDURE sp_crear_usuario(
    IN p_nombre VARCHAR(150),
    IN p_correo VARCHAR(150),
    IN p_contrasena VARCHAR(255)
)
BEGIN

    INSERT INTO usuarios (
        nombre,
        correo,
        contrasena
    )
    VALUES (
        p_nombre,
        p_correo,
        p_contrasena
    );

    SELECT LAST_INSERT_ID() AS id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- LISTAR USUARIOS
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_usuarios;

DELIMITER $$

CREATE PROCEDURE sp_listar_usuarios()
BEGIN

    SELECT
        u.id,
        u.nombre,
        u.correo,
        u.estado,

        GROUP_CONCAT(
            r.nombre
            ORDER BY r.nombre
            SEPARATOR ', '
        ) AS roles

    FROM usuarios u

    LEFT JOIN usuario_rol ur
        ON ur.id_usuario = u.id
        AND ur.estado = 1

    LEFT JOIN rol r
        ON r.id = ur.id_rol
        AND r.estado = 1

    GROUP BY
        u.id,
        u.nombre,
        u.correo,
        u.estado

    ORDER BY u.nombre;

END $$

DELIMITER ;
-- //////////////////////////////////
-- OBTENER USUARIO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_obtener_usuario;

DELIMITER $$

CREATE PROCEDURE sp_obtener_usuario(
    IN p_id_usuario BIGINT
)
BEGIN

    SELECT
        id,
        nombre,
        correo,
        estado,
        fecha_creacion
    FROM usuarios
    WHERE id = p_id_usuario;


    SELECT
        r.id,
        r.nombre
    FROM usuario_rol ur

    INNER JOIN rol r
        ON r.id = ur.id_rol

    WHERE ur.id_usuario = p_id_usuario
    AND ur.estado = 1
    AND r.estado = 1

    ORDER BY r.nombre;

END $$

DELIMITER ;
-- //////////////////////////////////
-- ACTUALIZAR USUARIO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_actualizar_usuario;

DELIMITER $$

CREATE PROCEDURE sp_actualizar_usuario(
    IN p_id BIGINT,
    IN p_nombre VARCHAR(150),
    IN p_correo VARCHAR(150)
)
BEGIN

    UPDATE usuarios
    SET
        nombre = p_nombre,
        correo = p_correo
    WHERE id = p_id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- ACTUALIZAR CONTRASEÑA
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_actualizar_contrasena;

DELIMITER $$

CREATE PROCEDURE sp_actualizar_contrasena(
    IN p_id_usuario BIGINT,
    IN p_contrasena VARCHAR(255)
)
BEGIN

    UPDATE usuarios
    SET contrasena = p_contrasena
    WHERE id = p_id_usuario;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CAMBIAR ESTADO USUARIO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_estado_usuario;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_estado_usuario(
    IN p_id BIGINT,
    IN p_estado TINYINT
)
BEGIN

    UPDATE usuarios
    SET estado = p_estado
    WHERE id = p_id;

END $$

DELIMITER ;
CALL sp_cambiar_estado_usuario(1, 1);

-- //////////////////////////////////
-- ASIGNAR ROL A USUARIO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_asignar_rol_usuario;

DELIMITER $$

CREATE PROCEDURE sp_asignar_rol_usuario(
    IN p_id_usuario BIGINT,
    IN p_id_rol BIGINT
)
BEGIN

    INSERT INTO usuario_rol (
        id_usuario,
        id_rol
    )
    VALUES (
        p_id_usuario,
        p_id_rol
    )
    ON DUPLICATE KEY UPDATE
        estado = 1;

END $$

DELIMITER ;
-- //////////////////////////////////
-- QUITAR ROL A USUARIO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_quitar_rol_usuario;

DELIMITER $$

CREATE PROCEDURE sp_quitar_rol_usuario(
    IN p_id_usuario BIGINT,
    IN p_id_rol BIGINT
)
BEGIN

    UPDATE usuario_rol
    SET estado = 0
    WHERE id_usuario = p_id_usuario
    AND id_rol = p_id_rol;

END $$

DELIMITER ;
-- //////////////////////////////////
-- LISTAR ROLES DE USUARIO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_roles_usuario;

DELIMITER $$

CREATE PROCEDURE sp_listar_roles_usuario(
    IN p_id_usuario BIGINT
)
BEGIN

    SELECT
        r.id,
        r.nombre
    FROM usuario_rol ur

    INNER JOIN rol r
        ON r.id = ur.id_rol

    WHERE ur.id_usuario = p_id_usuario
    AND ur.estado = 1
    AND r.estado = 1

    ORDER BY r.nombre;

END $$

DELIMITER ;
CALL sp_listar_roles_usuario(1);

-- =====================================================
-- DEPARTAMENTOS
-- =====================================================

-- //////////////////////////////////
-- LISTAR DEPARTAMENTOS
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_departamentos;
DELIMITER $$
CREATE PROCEDURE sp_listar_departamentos()
BEGIN

    SELECT
        id,
        nombre,
        estado,
        fecha_creacion,
        fecha_actualizacion
    FROM departamento
    ORDER BY nombre;

END $$
DELIMITER ;

-- //////////////////////////////////
-- LISTAR DEPARTAMENTOS ACTIVOS
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_departamentos_activos;

DELIMITER $$

CREATE PROCEDURE sp_listar_departamentos_activos()
BEGIN

    SELECT
        id,
        nombre,
        estado,
        fecha_creacion,
        fecha_actualizacion
    FROM departamento
    WHERE estado = 1
    ORDER BY nombre;

END $$

DELIMITER ;

-- //////////////////////////////////
-- LISTAR DEPARTAMENTO POR ID
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_departamentos_id;

DELIMITER $$

CREATE PROCEDURE sp_listar_departamentos_id(
    IN id_departamento BIGINT
)
BEGIN

    SELECT
        id,
        nombre,
        estado,
        fecha_creacion,
        fecha_actualizacion
    FROM departamento
    WHERE id = id_departamento
    LIMIT 1;

END $$

DELIMITER ;

-- //////////////////////////////////
-- BUSCAR DEPARTAMENTO POR NOMBRE
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_buscar_departamento_nombre;

DELIMITER $$

CREATE PROCEDURE sp_buscar_departamento_nombre(
    IN p_nombre VARCHAR(150)
)
BEGIN

    SELECT
        id,
        nombre,
        estado,
        fecha_creacion,
        fecha_actualizacion
    FROM departamento
    WHERE LOWER(nombre) = LOWER(p_nombre)
    LIMIT 1;

END $$

DELIMITER ;

-- //////////////////////////////////
-- CREAR DEPARTAMENTO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_crear_departamento;

DELIMITER $$

CREATE PROCEDURE sp_crear_departamento(
    IN p_nombre VARCHAR(150)
)
BEGIN

    INSERT INTO departamento (
        nombre
    )
    VALUES (
        p_nombre
    );

    SELECT LAST_INSERT_ID() AS id;

END $$

DELIMITER ;

-- //////////////////////////////////
-- ACTUALIZAR DEPARTAMENTO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_actualizar_departamento;

DELIMITER $$

CREATE PROCEDURE sp_actualizar_departamento(
    IN p_id BIGINT,
    IN p_nombre VARCHAR(150)
)
BEGIN

    UPDATE departamento
    SET nombre = p_nombre
    WHERE id = p_id;

END $$

DELIMITER ;

-- //////////////////////////////////
-- CAMBIAR ESTADO DEPARTAMENTO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_estado_departamento;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_estado_departamento(
    IN p_id BIGINT,
    IN p_estado TINYINT
)
BEGIN

    UPDATE departamento
    SET estado = p_estado
    WHERE id = p_id;

END $$

DELIMITER ;
-- =====================================================
-- MUNICIPIOS
-- =====================================================


-- //////////////////////////////////
-- LISTAR MUNICIPIOS
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_municipios;

DELIMITER $$

CREATE PROCEDURE sp_listar_municipios()
BEGIN

    SELECT
        m.id,
        m.nombre,
        m.id_departamento,
        d.nombre AS departamento,
        m.estado
    FROM municipio m

    INNER JOIN departamento d
        ON d.id = m.id_departamento

    WHERE m.estado = 1

    ORDER BY
        d.nombre,
        m.nombre;

END $$

DELIMITER ;
-- //////////////////////////////////
-- LISTAR MUNICIPIOS POR DEPARTAMENTO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_municipios_departamento;

DELIMITER $$

CREATE PROCEDURE sp_listar_municipios_departamento(
    IN p_id_departamento BIGINT
)
BEGIN

    SELECT
        id,
        nombre,
        id_departamento
    FROM municipio
    WHERE id_departamento = p_id_departamento
    AND estado = 1
    ORDER BY nombre;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CREAR MUNICIPIO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_crear_municipio;

DELIMITER $$

CREATE PROCEDURE sp_crear_municipio(
    IN p_id_departamento BIGINT,
    IN p_nombre VARCHAR(150)
)
BEGIN

    INSERT INTO municipio (
        id_departamento,
        nombre
    )
    VALUES (
        p_id_departamento,
        p_nombre
    );

    SELECT LAST_INSERT_ID() AS id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- ACTUALIZAR MUNICIPIO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_actualizar_municipio;

DELIMITER $$

CREATE PROCEDURE sp_actualizar_municipio(
    IN p_id BIGINT,
    IN p_id_departamento BIGINT,
    IN p_nombre VARCHAR(150)
)
BEGIN

    UPDATE municipio
    SET
        id_departamento = p_id_departamento,
        nombre = p_nombre
    WHERE id = p_id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CAMBIAR ESTADO MUNICIPIO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_estado_municipio;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_estado_municipio(
    IN p_id BIGINT,
    IN p_estado TINYINT
)
BEGIN

    UPDATE municipio
    SET estado = p_estado
    WHERE id = p_id;

END $$

DELIMITER ;
-- =====================================================
-- INDUSTRIAS
-- =====================================================


-- //////////////////////////////////
-- LISTAR INDUSTRIAS
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_industrias;

DELIMITER $$

CREATE PROCEDURE sp_listar_industrias()
BEGIN

    SELECT
        id,
        nombre,
        correo,
        descripcion,
        estado
    FROM industria
    WHERE estado = 1
    ORDER BY nombre;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CREAR INDUSTRIA
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_crear_industria;

DELIMITER $$

CREATE PROCEDURE sp_crear_industria(
    IN p_nombre VARCHAR(150),
    IN p_correo VARCHAR(150),
    IN p_descripcion VARCHAR(255)
)
BEGIN

    INSERT INTO industria (
        nombre,
        correo,
        descripcion
    )
    VALUES (
        p_nombre,
        p_correo,
        p_descripcion
    );

    SELECT LAST_INSERT_ID() AS id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- ACTUALIZAR INDUSTRIA
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_actualizar_industria;

DELIMITER $$

CREATE PROCEDURE sp_actualizar_industria(
    IN p_id BIGINT,
    IN p_nombre VARCHAR(150),
    IN p_correo VARCHAR(150),
    IN p_descripcion VARCHAR(255)
)
BEGIN

    UPDATE industria
    SET
        nombre = p_nombre,
        correo = p_correo,
        descripcion = p_descripcion
    WHERE id = p_id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CAMBIAR ESTADO INDUSTRIA
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_estado_industria;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_estado_industria(
    IN p_id BIGINT,
    IN p_estado TINYINT
)
BEGIN

    UPDATE industria
    SET estado = p_estado
    WHERE id = p_id;

END $$

DELIMITER ;
-- =====================================================
-- CLIENTES
-- =====================================================


-- //////////////////////////////////
-- LISTAR CLIENTES
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_clientes;

DELIMITER $$

CREATE PROCEDURE sp_listar_clientes()
BEGIN

    SELECT
        c.id,
        c.nombre,
        c.telefono,
        c.id_industria,
        i.nombre AS industria,
        c.estado
    FROM cliente c

    INNER JOIN industria i
        ON i.id = c.id_industria

    WHERE c.estado = 1

    ORDER BY c.nombre;

END $$

DELIMITER ;
-- //////////////////////////////////
-- LISTAR CLIENTES POR INDUSTRIA
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_clientes_industria;

DELIMITER $$

CREATE PROCEDURE sp_listar_clientes_industria(
    IN p_id_industria BIGINT
)
BEGIN

    SELECT
        id,
        nombre,
        telefono,
        id_industria
    FROM cliente
    WHERE id_industria = p_id_industria
    AND estado = 1
    ORDER BY nombre;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CREAR CLIENTE
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_crear_cliente;

DELIMITER $$

CREATE PROCEDURE sp_crear_cliente(
    IN p_nombre VARCHAR(150),
    IN p_telefono VARCHAR(30),
    IN p_id_industria BIGINT
)
BEGIN

    INSERT INTO cliente (
        nombre,
        telefono,
        id_industria
    )
    VALUES (
        p_nombre,
        p_telefono,
        p_id_industria
    );

    SELECT LAST_INSERT_ID() AS id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- ACTUALIZAR CLIENTE
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_actualizar_cliente;

DELIMITER $$

CREATE PROCEDURE sp_actualizar_cliente(
    IN p_id BIGINT,
    IN p_nombre VARCHAR(150),
    IN p_telefono VARCHAR(30),
    IN p_id_industria BIGINT
)
BEGIN

    UPDATE cliente
    SET
        nombre = p_nombre,
        telefono = p_telefono,
        id_industria = p_id_industria
    WHERE id = p_id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CAMBIAR ESTADO CLIENTE
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_estado_cliente;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_estado_cliente(
    IN p_id BIGINT,
    IN p_estado TINYINT
)
BEGIN

    UPDATE cliente
    SET estado = p_estado
    WHERE id = p_id;

END $$

DELIMITER ;
-- =====================================================
-- SUCURSALES
-- =====================================================


-- //////////////////////////////////
-- LISTAR SUCURSALES
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_sucursales;

DELIMITER $$

CREATE PROCEDURE sp_listar_sucursales()
BEGIN

    SELECT
        s.id,
        s.nombre,
        s.id_cliente,
        c.nombre AS cliente,
        s.id_municipio,
        m.nombre AS municipio,
        d.id AS id_departamento,
        d.nombre AS departamento,
        s.estado

    FROM sucursal s

    INNER JOIN cliente c
        ON c.id = s.id_cliente

    INNER JOIN municipio m
        ON m.id = s.id_municipio

    INNER JOIN departamento d
        ON d.id = m.id_departamento

    WHERE s.estado = 1

    ORDER BY s.nombre;

END $$

DELIMITER ;
-- //////////////////////////////////
-- LISTAR SUCURSALES POR CLIENTE
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_sucursales_cliente;

DELIMITER $$

CREATE PROCEDURE sp_listar_sucursales_cliente(
    IN p_id_cliente BIGINT
)
BEGIN

    SELECT
        s.id,
        s.nombre,
        s.id_cliente,
        s.id_municipio,
        m.nombre AS municipio,
        d.id AS id_departamento,
        d.nombre AS departamento

    FROM sucursal s

    INNER JOIN municipio m
        ON m.id = s.id_municipio

    INNER JOIN departamento d
        ON d.id = m.id_departamento

    WHERE s.id_cliente = p_id_cliente
    AND s.estado = 1

    ORDER BY s.nombre;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CREAR SUCURSAL
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_crear_sucursal;

DELIMITER $$

CREATE PROCEDURE sp_crear_sucursal(
    IN p_nombre VARCHAR(150),
    IN p_id_cliente BIGINT,
    IN p_id_municipio BIGINT
)
BEGIN

    INSERT INTO sucursal (
        nombre,
        id_cliente,
        id_municipio
    )
    VALUES (
        p_nombre,
        p_id_cliente,
        p_id_municipio
    );

    SELECT LAST_INSERT_ID() AS id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- ACTUALIZAR SUCURSAL
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_actualizar_sucursal;

DELIMITER $$

CREATE PROCEDURE sp_actualizar_sucursal(
    IN p_id BIGINT,
    IN p_nombre VARCHAR(150),
    IN p_id_cliente BIGINT,
    IN p_id_municipio BIGINT
)
BEGIN

    UPDATE sucursal
    SET
        nombre = p_nombre,
        id_cliente = p_id_cliente,
        id_municipio = p_id_municipio
    WHERE id = p_id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CAMBIAR ESTADO SUCURSAL
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_estado_sucursal;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_estado_sucursal(
    IN p_id BIGINT,
    IN p_estado TINYINT
)
BEGIN

    UPDATE sucursal
    SET estado = p_estado
    WHERE id = p_id;

END $$

DELIMITER ;
-- =====================================================
-- TIPO CAMPO
-- =====================================================


-- //////////////////////////////////
-- LISTAR TIPOS DE CAMPO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_tipos_campo;

DELIMITER $$

CREATE PROCEDURE sp_listar_tipos_campo()
BEGIN

    SELECT
        id,
        nombre
    FROM tipo_campo
    WHERE estado = 1
    ORDER BY nombre;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CREAR TIPO CAMPO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_crear_tipo_campo;

DELIMITER $$

CREATE PROCEDURE sp_crear_tipo_campo(
    IN p_nombre VARCHAR(100)
)
BEGIN

    INSERT INTO tipo_campo (
        nombre
    )
    VALUES (
        p_nombre
    );

    SELECT LAST_INSERT_ID() AS id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- ACTUALIZAR TIPO CAMPO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_actualizar_tipo_campo;

DELIMITER $$

CREATE PROCEDURE sp_actualizar_tipo_campo(
    IN p_id BIGINT,
    IN p_nombre VARCHAR(100)
)
BEGIN

    UPDATE tipo_campo
    SET nombre = p_nombre
    WHERE id = p_id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CAMBIAR ESTADO TIPO CAMPO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_estado_tipo_campo;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_estado_tipo_campo(
    IN p_id BIGINT,
    IN p_estado TINYINT
)
BEGIN

    UPDATE tipo_campo
    SET estado = p_estado
    WHERE id = p_id;

END $$

DELIMITER ;
-- =====================================================
-- DEFINICION CAMPO
-- =====================================================


-- //////////////////////////////////
-- LISTAR DEFINICIONES DE CAMPO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_definiciones_campo;

DELIMITER $$

CREATE PROCEDURE sp_listar_definiciones_campo()
BEGIN

    SELECT
        dc.id,
        dc.codigo,
        dc.nombre,
        dc.id_tipo_campo,
        tc.nombre AS tipo_campo,
        dc.estado

    FROM definicion_campo dc

    INNER JOIN tipo_campo tc
        ON tc.id = dc.id_tipo_campo

    WHERE dc.estado = 1

    ORDER BY dc.nombre;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CREAR DEFINICION DE CAMPO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_crear_definicion_campo;

DELIMITER $$

CREATE PROCEDURE sp_crear_definicion_campo(
    IN p_codigo VARCHAR(100),
    IN p_nombre VARCHAR(150),
    IN p_id_tipo_campo BIGINT
)
BEGIN

    INSERT INTO definicion_campo (
        codigo,
        nombre,
        id_tipo_campo
    )
    VALUES (
        p_codigo,
        p_nombre,
        p_id_tipo_campo
    );

    SELECT LAST_INSERT_ID() AS id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- ACTUALIZAR DEFINICION DE CAMPO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_actualizar_definicion_campo;

DELIMITER $$

CREATE PROCEDURE sp_actualizar_definicion_campo(
    IN p_id BIGINT,
    IN p_codigo VARCHAR(100),
    IN p_nombre VARCHAR(150),
    IN p_id_tipo_campo BIGINT
)
BEGIN

    UPDATE definicion_campo
    SET
        codigo = p_codigo,
        nombre = p_nombre,
        id_tipo_campo = p_id_tipo_campo
    WHERE id = p_id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CAMBIAR ESTADO DEFINICION CAMPO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_estado_definicion_campo;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_estado_definicion_campo(
    IN p_id BIGINT,
    IN p_estado TINYINT
)
BEGIN

    UPDATE definicion_campo
    SET estado = p_estado
    WHERE id = p_id;

END $$

DELIMITER ;
-- =====================================================
-- PLANTILLAS
-- =====================================================


-- //////////////////////////////////
-- LISTAR PLANTILLAS
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_plantillas;

DELIMITER $$

CREATE PROCEDURE sp_listar_plantillas()
BEGIN

    SELECT
        pf.id,
        pf.nombre,
        pf.estatus,
        pf.id_industria,
        i.nombre AS industria,
        pf.estado

    FROM plantilla_formulario pf

    INNER JOIN industria i
        ON i.id = pf.id_industria

    WHERE pf.estado = 1

    ORDER BY pf.nombre;

END $$

DELIMITER ;
-- //////////////////////////////////
-- LISTAR PLANTILLAS POR INDUSTRIA
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_plantillas_industria;

DELIMITER $$

CREATE PROCEDURE sp_listar_plantillas_industria(
    IN p_id_industria BIGINT
)
BEGIN

    SELECT
        id,
        nombre,
        estatus
    FROM plantilla_formulario
    WHERE id_industria = p_id_industria
    AND estado = 1
    ORDER BY nombre;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CREAR PLANTILLA
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_crear_plantilla;

DELIMITER $$

CREATE PROCEDURE sp_crear_plantilla(
    IN p_id_industria BIGINT,
    IN p_nombre VARCHAR(150),
    IN p_estatus VARCHAR(50)
)
BEGIN

    INSERT INTO plantilla_formulario (
        id_industria,
        nombre,
        estatus
    )
    VALUES (
        p_id_industria,
        p_nombre,
        p_estatus
    );

    SELECT LAST_INSERT_ID() AS id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- ACTUALIZAR PLANTILLA
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_actualizar_plantilla;

DELIMITER $$

CREATE PROCEDURE sp_actualizar_plantilla(
    IN p_id BIGINT,
    IN p_id_industria BIGINT,
    IN p_nombre VARCHAR(150),
    IN p_estatus VARCHAR(50)
)
BEGIN

    UPDATE plantilla_formulario
    SET
        id_industria = p_id_industria,
        nombre = p_nombre,
        estatus = p_estatus
    WHERE id = p_id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CAMBIAR ESTADO PLANTILLA
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_estado_plantilla;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_estado_plantilla(
    IN p_id BIGINT,
    IN p_estado TINYINT
)
BEGIN

    UPDATE plantilla_formulario
    SET estado = p_estado
    WHERE id = p_id;

END $$

DELIMITER ;
-- =====================================================
-- DOCUMENTOS
-- =====================================================


-- //////////////////////////////////
-- LISTAR DOCUMENTOS DE PLANTILLA
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_documentos_plantilla;

DELIMITER $$

CREATE PROCEDURE sp_listar_documentos_plantilla(
    IN p_id_plantilla BIGINT
)
BEGIN

    SELECT
        id,
        id_plantilla,
        codigo,
        nombre,
        descripcion,
        orden_visualizacion
    FROM documento_formulario
    WHERE id_plantilla = p_id_plantilla
    AND estado = 1
    ORDER BY orden_visualizacion;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CREAR DOCUMENTO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_crear_documento;

DELIMITER $$

CREATE PROCEDURE sp_crear_documento(
    IN p_id_plantilla BIGINT,
    IN p_codigo VARCHAR(100),
    IN p_nombre VARCHAR(150),
    IN p_descripcion VARCHAR(255),
    IN p_orden_visualizacion INT
)
BEGIN

    INSERT INTO documento_formulario (
        id_plantilla,
        codigo,
        nombre,
        descripcion,
        orden_visualizacion
    )
    VALUES (
        p_id_plantilla,
        p_codigo,
        p_nombre,
        p_descripcion,
        p_orden_visualizacion
    );

    SELECT LAST_INSERT_ID() AS id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- ACTUALIZAR DOCUMENTO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_actualizar_documento;

DELIMITER $$

CREATE PROCEDURE sp_actualizar_documento(
    IN p_id BIGINT,
    IN p_codigo VARCHAR(100),
    IN p_nombre VARCHAR(150),
    IN p_descripcion VARCHAR(255),
    IN p_orden_visualizacion INT
)
BEGIN

    UPDATE documento_formulario
    SET
        codigo = p_codigo,
        nombre = p_nombre,
        descripcion = p_descripcion,
        orden_visualizacion = p_orden_visualizacion
    WHERE id = p_id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CAMBIAR ESTADO DOCUMENTO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_estado_documento;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_estado_documento(
    IN p_id BIGINT,
    IN p_estado TINYINT
)
BEGIN

    UPDATE documento_formulario
    SET estado = p_estado
    WHERE id = p_id;

END $$

DELIMITER ;
-- =====================================================
-- SECCIONES
-- =====================================================

-- //////////////////////////////////
-- LISTAR SECCIONES DE DOCUMENTO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_secciones_documento;

DELIMITER $$

CREATE PROCEDURE sp_listar_secciones_documento(
    IN p_id_documento BIGINT
)
BEGIN

    SELECT
        id,
        id_documento,
        nombre,
        icono,
        numero_columnas,
        orden_visualizacion
    FROM seccion_formulario
    WHERE id_documento = p_id_documento
    AND estado = 1
    ORDER BY orden_visualizacion;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CREAR SECCION
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_crear_seccion;

DELIMITER $$

CREATE PROCEDURE sp_crear_seccion(
    IN p_id_documento BIGINT,
    IN p_nombre VARCHAR(150),
    IN p_icono VARCHAR(100),
    IN p_numero_columnas INT,
    IN p_orden_visualizacion INT
)
BEGIN

    INSERT INTO seccion_formulario (
        id_documento,
        nombre,
        icono,
        numero_columnas,
        orden_visualizacion
    )
    VALUES (
        p_id_documento,
        p_nombre,
        p_icono,
        p_numero_columnas,
        p_orden_visualizacion
    );

    SELECT LAST_INSERT_ID() AS id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- ACTUALIZAR SECCION
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_actualizar_seccion;

DELIMITER $$

CREATE PROCEDURE sp_actualizar_seccion(
    IN p_id BIGINT,
    IN p_nombre VARCHAR(150),
    IN p_icono VARCHAR(100),
    IN p_numero_columnas INT,
    IN p_orden_visualizacion INT
)
BEGIN

    UPDATE seccion_formulario
    SET
        nombre = p_nombre,
        icono = p_icono,
        numero_columnas = p_numero_columnas,
        orden_visualizacion = p_orden_visualizacion
    WHERE id = p_id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CAMBIAR ESTADO SECCION
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_estado_seccion;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_estado_seccion(
    IN p_id BIGINT,
    IN p_estado TINYINT
)
BEGIN

    UPDATE seccion_formulario
    SET estado = p_estado
    WHERE id = p_id;

END $$

DELIMITER ;
-- =====================================================
-- CAMPOS
-- =====================================================


-- //////////////////////////////////
-- LISTAR CAMPOS DE SECCION
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_campos_seccion;

DELIMITER $$

CREATE PROCEDURE sp_listar_campos_seccion(
    IN p_id_seccion BIGINT
)
BEGIN

    SELECT
        cf.id,
        cf.id_seccion,
        cf.codigo,
        cf.etiqueta,
        cf.texto_ayuda,
        cf.texto_guia,
        cf.id_definicion_campo,
        dc.nombre AS definicion_campo,
        tc.id AS id_tipo_campo,
        tc.nombre AS tipo_campo,
        cf.requerido,
        cf.valor_minimo,
        cf.valor_maximo,
        cf.orden_visualizacion

    FROM campo_formulario cf

    INNER JOIN definicion_campo dc
        ON dc.id = cf.id_definicion_campo

    INNER JOIN tipo_campo tc
        ON tc.id = dc.id_tipo_campo

    WHERE cf.id_seccion = p_id_seccion
    AND cf.estado = 1

    ORDER BY cf.orden_visualizacion;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CREAR CAMPO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_crear_campo;

DELIMITER $$

CREATE PROCEDURE sp_crear_campo(
    IN p_id_seccion BIGINT,
    IN p_codigo VARCHAR(100),
    IN p_etiqueta VARCHAR(500),
    IN p_texto_ayuda VARCHAR(500),
    IN p_texto_guia VARCHAR(255),
    IN p_id_definicion_campo BIGINT,
    IN p_requerido TINYINT,
    IN p_valor_minimo DECIMAL(12,2),
    IN p_valor_maximo DECIMAL(12,2),
    IN p_orden_visualizacion INT
)
BEGIN

    INSERT INTO campo_formulario (
        id_seccion,
        codigo,
        etiqueta,
        texto_ayuda,
        texto_guia,
        id_definicion_campo,
        requerido,
        valor_minimo,
        valor_maximo,
        orden_visualizacion
    )
    VALUES (
        p_id_seccion,
        p_codigo,
        p_etiqueta,
        p_texto_ayuda,
        p_texto_guia,
        p_id_definicion_campo,
        p_requerido,
        p_valor_minimo,
        p_valor_maximo,
        p_orden_visualizacion
    );

    SELECT LAST_INSERT_ID() AS id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- ACTUALIZAR CAMPO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_actualizar_campo;

DELIMITER $$

CREATE PROCEDURE sp_actualizar_campo(
    IN p_id BIGINT,
    IN p_codigo VARCHAR(100),
    IN p_etiqueta VARCHAR(500),
    IN p_texto_ayuda VARCHAR(500),
    IN p_texto_guia VARCHAR(255),
    IN p_id_definicion_campo BIGINT,
    IN p_requerido TINYINT,
    IN p_valor_minimo DECIMAL(12,2),
    IN p_valor_maximo DECIMAL(12,2),
    IN p_orden_visualizacion INT
)
BEGIN

    UPDATE campo_formulario
    SET
        codigo = p_codigo,
        etiqueta = p_etiqueta,
        texto_ayuda = p_texto_ayuda,
        texto_guia = p_texto_guia,
        id_definicion_campo = p_id_definicion_campo,
        requerido = p_requerido,
        valor_minimo = p_valor_minimo,
        valor_maximo = p_valor_maximo,
        orden_visualizacion = p_orden_visualizacion
    WHERE id = p_id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CAMBIAR ESTADO CAMPO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_estado_campo;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_estado_campo(
    IN p_id BIGINT,
    IN p_estado TINYINT
)
BEGIN

    UPDATE campo_formulario
    SET estado = p_estado
    WHERE id = p_id;

END $$

DELIMITER ;
-- =====================================================
-- OPCIONES DE CAMPO
-- =====================================================


-- //////////////////////////////////
-- LISTAR OPCIONES DE CAMPO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_opciones_campo;

DELIMITER $$

CREATE PROCEDURE sp_listar_opciones_campo(
    IN p_id_campo BIGINT
)
BEGIN

    SELECT
        id,
        id_opcion,
        codigo,
        valor,
        puntaje,
        etiqueta,
        orden_visualizacion
    FROM opcion_formulario
    WHERE id_campo_formulario = p_id_campo
    AND estado = 1
    ORDER BY orden_visualizacion;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CREAR OPCION DE CAMPO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_crear_opcion_campo;

DELIMITER $$

CREATE PROCEDURE sp_crear_opcion_campo(
    IN p_id_campo_formulario BIGINT,
    IN p_id_opcion BIGINT,
    IN p_codigo VARCHAR(100),
    IN p_valor VARCHAR(255),
    IN p_puntaje DECIMAL(10,2),
    IN p_etiqueta VARCHAR(255),
    IN p_orden_visualizacion INT
)
BEGIN

    INSERT INTO opcion_formulario (
        id_opcion,
        codigo,
        valor,
        puntaje,
        etiqueta,
        orden_visualizacion,
        id_campo_formulario
    )
    VALUES (
        p_id_opcion,
        p_codigo,
        p_valor,
        p_puntaje,
        p_etiqueta,
        p_orden_visualizacion,
        p_id_campo_formulario
    );

    SELECT LAST_INSERT_ID() AS id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- ACTUALIZAR OPCION
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_actualizar_opcion_campo;

DELIMITER $$

CREATE PROCEDURE sp_actualizar_opcion_campo(
    IN p_id BIGINT,
    IN p_id_opcion BIGINT,
    IN p_codigo VARCHAR(100),
    IN p_valor VARCHAR(255),
    IN p_puntaje DECIMAL(10,2),
    IN p_etiqueta VARCHAR(255),
    IN p_orden_visualizacion INT
)
BEGIN

    UPDATE opcion_formulario
    SET
        id_opcion = p_id_opcion,
        codigo = p_codigo,
        valor = p_valor,
        puntaje = p_puntaje,
        etiqueta = p_etiqueta,
        orden_visualizacion = p_orden_visualizacion
    WHERE id = p_id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CAMBIAR ESTADO OPCION
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_estado_opcion;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_estado_opcion(
    IN p_id BIGINT,
    IN p_estado TINYINT
)
BEGIN

    UPDATE opcion_formulario
    SET estado = p_estado
    WHERE id = p_id;

END $$

DELIMITER ;
-- =====================================================
-- TIPOS DE EVENTO
-- =====================================================


-- //////////////////////////////////
-- LISTAR TIPOS DE EVENTO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_tipos_evento;

DELIMITER $$

CREATE PROCEDURE sp_listar_tipos_evento()
BEGIN

    SELECT
        id,
        nombre
    FROM tipo_evento
    WHERE estado = 1
    ORDER BY nombre;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CREAR TIPO EVENTO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_crear_tipo_evento;

DELIMITER $$

CREATE PROCEDURE sp_crear_tipo_evento(
    IN p_nombre VARCHAR(100)
)
BEGIN

    INSERT INTO tipo_evento (
        nombre
    )
    VALUES (
        p_nombre
    );

    SELECT LAST_INSERT_ID() AS id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- ACTUALIZAR TIPO EVENTO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_actualizar_tipo_evento;

DELIMITER $$

CREATE PROCEDURE sp_actualizar_tipo_evento(
    IN p_id BIGINT,
    IN p_nombre VARCHAR(100)
)
BEGIN

    UPDATE tipo_evento
    SET nombre = p_nombre
    WHERE id = p_id;

END $$

DELIMITER ;
-- =====================================================
-- TIPOS DE ACCION
-- =====================================================


-- //////////////////////////////////
-- LISTAR TIPOS DE ACCION
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_tipos_accion;

DELIMITER $$

CREATE PROCEDURE sp_listar_tipos_accion()
BEGIN

    SELECT
        id,
        nombre
    FROM tipo_accion
    WHERE estado = 1
    ORDER BY nombre;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CREAR TIPO ACCION
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_crear_tipo_accion;

DELIMITER $$

CREATE PROCEDURE sp_crear_tipo_accion(
    IN p_nombre VARCHAR(100)
)
BEGIN

    INSERT INTO tipo_accion (
        nombre
    )
    VALUES (
        p_nombre
    );

    SELECT LAST_INSERT_ID() AS id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- ACTUALIZAR TIPO ACCION
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_actualizar_tipo_accion;

DELIMITER $$

CREATE PROCEDURE sp_actualizar_tipo_accion(
    IN p_id BIGINT,
    IN p_nombre VARCHAR(100)
)
BEGIN

    UPDATE tipo_accion
    SET nombre = p_nombre
    WHERE id = p_id;

END $$

DELIMITER ;
-- =====================================================
-- EVENTOS DE CAMPOS
-- =====================================================


-- //////////////////////////////////
-- LISTAR EVENTOS DE CAMPO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_eventos_campo;

DELIMITER $$

CREATE PROCEDURE sp_listar_eventos_campo(
    IN p_id_campo BIGINT
)
BEGIN

    SELECT
        ecf.id,
        ecf.id_campo_formulario,
        ecf.id_tipo_evento,
        te.nombre AS tipo_evento,
        ecf.id_tipo_accion,
        ta.nombre AS tipo_accion,
        ecf.configuracion_condicion,
        ecf.configuracion_accion,
        ecf.orden_visualizacion

    FROM evento_campo_formulario ecf

    INNER JOIN tipo_evento te
        ON te.id = ecf.id_tipo_evento

    INNER JOIN tipo_accion ta
        ON ta.id = ecf.id_tipo_accion

    WHERE ecf.id_campo_formulario = p_id_campo
    AND ecf.estado = 1

    ORDER BY ecf.orden_visualizacion;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CREAR EVENTO DE CAMPO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_crear_evento_campo;

DELIMITER $$

CREATE PROCEDURE sp_crear_evento_campo(
    IN p_id_campo_formulario BIGINT,
    IN p_id_tipo_evento BIGINT,
    IN p_id_tipo_accion BIGINT,
    IN p_configuracion_condicion JSON,
    IN p_configuracion_accion JSON,
    IN p_orden_visualizacion INT
)
BEGIN

    INSERT INTO evento_campo_formulario (
        id_campo_formulario,
        id_tipo_evento,
        id_tipo_accion,
        configuracion_condicion,
        configuracion_accion,
        orden_visualizacion
    )
    VALUES (
        p_id_campo_formulario,
        p_id_tipo_evento,
        p_id_tipo_accion,
        p_configuracion_condicion,
        p_configuracion_accion,
        p_orden_visualizacion
    );

    SELECT LAST_INSERT_ID() AS id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- ACTUALIZAR EVENTO DE CAMPO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_actualizar_evento_campo;

DELIMITER $$

CREATE PROCEDURE sp_actualizar_evento_campo(
    IN p_id BIGINT,
    IN p_id_tipo_evento BIGINT,
    IN p_id_tipo_accion BIGINT,
    IN p_configuracion_condicion JSON,
    IN p_configuracion_accion JSON,
    IN p_orden_visualizacion INT
)
BEGIN

    UPDATE evento_campo_formulario
    SET
        id_tipo_evento = p_id_tipo_evento,
        id_tipo_accion = p_id_tipo_accion,
        configuracion_condicion = p_configuracion_condicion,
        configuracion_accion = p_configuracion_accion,
        orden_visualizacion = p_orden_visualizacion
    WHERE id = p_id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CAMBIAR ESTADO EVENTO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_estado_evento;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_estado_evento(
    IN p_id BIGINT,
    IN p_estado TINYINT
)
BEGIN

    UPDATE evento_campo_formulario
    SET estado = p_estado
    WHERE id = p_id;

END $$

DELIMITER ;
-- =====================================================
-- FORMULARIO COMPLETO
-- =====================================================


-- //////////////////////////////////
-- OBTENER FORMULARIO COMPLETO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_obtener_formulario;

DELIMITER $$

CREATE PROCEDURE sp_obtener_formulario(
    IN p_id_plantilla BIGINT
)
BEGIN

    -- PLANTILLA
    SELECT
        pf.id,
        pf.nombre,
        pf.estatus,
        pf.id_industria,
        i.nombre AS industria

    FROM plantilla_formulario pf

    INNER JOIN industria i
        ON i.id = pf.id_industria

    WHERE pf.id = p_id_plantilla;


    -- DOCUMENTOS
    SELECT
        id,
        id_plantilla,
        codigo,
        nombre,
        descripcion,
        orden_visualizacion

    FROM documento_formulario

    WHERE id_plantilla = p_id_plantilla
    AND estado = 1

    ORDER BY orden_visualizacion;


    -- SECCIONES
    SELECT
        s.id,
        s.id_documento,
        s.nombre,
        s.icono,
        s.numero_columnas,
        s.orden_visualizacion

    FROM seccion_formulario s

    INNER JOIN documento_formulario d
        ON d.id = s.id_documento

    WHERE d.id_plantilla = p_id_plantilla
    AND s.estado = 1

    ORDER BY
        d.orden_visualizacion,
        s.orden_visualizacion;


    -- CAMPOS
    SELECT
        cf.id,
        cf.id_seccion,
        cf.codigo,
        cf.etiqueta,
        cf.texto_ayuda,
        cf.texto_guia,
        cf.requerido,
        cf.valor_minimo,
        cf.valor_maximo,
        cf.orden_visualizacion,

        dc.id AS id_definicion_campo,
        dc.nombre AS definicion_campo,

        tc.id AS id_tipo_campo,
        tc.nombre AS tipo_campo

    FROM campo_formulario cf

    INNER JOIN seccion_formulario s
        ON s.id = cf.id_seccion

    INNER JOIN documento_formulario d
        ON d.id = s.id_documento

    INNER JOIN definicion_campo dc
        ON dc.id = cf.id_definicion_campo

    INNER JOIN tipo_campo tc
        ON tc.id = dc.id_tipo_campo

    WHERE d.id_plantilla = p_id_plantilla
    AND cf.estado = 1

    ORDER BY
        d.orden_visualizacion,
        s.orden_visualizacion,
        cf.orden_visualizacion;


    -- OPCIONES
    SELECT
        o.id,
        o.id_opcion,
        o.id_campo_formulario,
        o.codigo,
        o.valor,
        o.puntaje,
        o.etiqueta,
        o.orden_visualizacion

    FROM opcion_formulario o

    INNER JOIN campo_formulario cf
        ON cf.id = o.id_campo_formulario

    INNER JOIN seccion_formulario s
        ON s.id = cf.id_seccion

    INNER JOIN documento_formulario d
        ON d.id = s.id_documento

    WHERE d.id_plantilla = p_id_plantilla
    AND o.estado = 1

    ORDER BY
        o.id_campo_formulario,
        o.orden_visualizacion;


    -- EVENTOS
    SELECT
        ecf.id,
        ecf.id_campo_formulario,
        ecf.id_tipo_evento,
        te.nombre AS tipo_evento,
        ecf.id_tipo_accion,
        ta.nombre AS tipo_accion,
        ecf.configuracion_condicion,
        ecf.configuracion_accion,
        ecf.orden_visualizacion

    FROM evento_campo_formulario ecf

    INNER JOIN campo_formulario cf
        ON cf.id = ecf.id_campo_formulario

    INNER JOIN seccion_formulario s
        ON s.id = cf.id_seccion

    INNER JOIN documento_formulario d
        ON d.id = s.id_documento

    INNER JOIN tipo_evento te
        ON te.id = ecf.id_tipo_evento

    INNER JOIN tipo_accion ta
        ON ta.id = ecf.id_tipo_accion

    WHERE d.id_plantilla = p_id_plantilla
    AND ecf.estado = 1

    ORDER BY
        ecf.id_campo_formulario,
        ecf.orden_visualizacion;

END $$

DELIMITER ;
-- =====================================================
-- EVALUACIONES
-- =====================================================


-- //////////////////////////////////
-- CREAR EVALUACION
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_crear_evaluacion;

DELIMITER $$

CREATE PROCEDURE sp_crear_evaluacion(
    IN p_id_sucursal BIGINT,
    IN p_id_plantilla BIGINT,
    IN p_id_evaluador BIGINT
)
BEGIN

    INSERT INTO evaluacion (
        id_sucursal,
        id_plantilla,
        id_evaluador,
        estatus
    )
    VALUES (
        p_id_sucursal,
        p_id_plantilla,
        p_id_evaluador,
        'EN_PROCESO'
    );

    SELECT LAST_INSERT_ID() AS id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- LISTAR EVALUACIONES
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_evaluaciones;

DELIMITER $$

CREATE PROCEDURE sp_listar_evaluaciones()
BEGIN

    SELECT
        e.id,

        i.id AS id_industria,
        i.nombre AS industria,

        c.id AS id_cliente,
        c.nombre AS cliente,

        s.id AS id_sucursal,
        s.nombre AS sucursal,

        u.id AS id_evaluador,
        u.nombre AS evaluador,

        pf.id AS id_plantilla,
        pf.nombre AS plantilla,

        e.estatus,
        e.puntaje_total,
        e.nivel_riesgo,
        e.fecha_creacion

    FROM evaluacion e

    INNER JOIN sucursal s
        ON s.id = e.id_sucursal

    INNER JOIN cliente c
        ON c.id = s.id_cliente

    INNER JOIN industria i
        ON i.id = c.id_industria

    INNER JOIN usuarios u
        ON u.id = e.id_evaluador

    INNER JOIN plantilla_formulario pf
        ON pf.id = e.id_plantilla

    WHERE e.estado = 1

    ORDER BY e.fecha_creacion DESC;

END $$

DELIMITER ;
-- //////////////////////////////////
-- OBTENER EVALUACION
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_obtener_evaluacion;

DELIMITER $$

CREATE PROCEDURE sp_obtener_evaluacion(
    IN p_id_evaluacion BIGINT
)
BEGIN

    SELECT
        e.id,
        e.estatus,
        e.observaciones,
        e.puntaje_total,
        e.nivel_riesgo,

        s.id AS id_sucursal,
        s.nombre AS sucursal,

        c.id AS id_cliente,
        c.nombre AS cliente,

        i.id AS id_industria,
        i.nombre AS industria,

        pf.id AS id_plantilla,
        pf.nombre AS plantilla,

        u.id AS id_evaluador,
        u.nombre AS evaluador,

        e.fecha_creacion

    FROM evaluacion e

    INNER JOIN sucursal s
        ON s.id = e.id_sucursal

    INNER JOIN cliente c
        ON c.id = s.id_cliente

    INNER JOIN industria i
        ON i.id = c.id_industria

    INNER JOIN plantilla_formulario pf
        ON pf.id = e.id_plantilla

    INNER JOIN usuarios u
        ON u.id = e.id_evaluador

    WHERE e.id = p_id_evaluacion;


    SELECT
        re.id,
        re.id_campo,

        cf.codigo,
        cf.etiqueta,

        tc.nombre AS tipo_campo,

        re.id_opcion,
        op.etiqueta AS opcion,
        op.valor AS valor_opcion,

        re.valor_texto,
        re.valor_numero,
        re.valor_booleano,
        re.valor_fecha,

        re.puntaje,
        re.puntaje_ponderado,
        re.observacion

    FROM respuesta_evaluacion re

    INNER JOIN campo_formulario cf
        ON cf.id = re.id_campo

    INNER JOIN definicion_campo dc
        ON dc.id = cf.id_definicion_campo

    INNER JOIN tipo_campo tc
        ON tc.id = dc.id_tipo_campo

    LEFT JOIN opcion_formulario op
        ON op.id = re.id_opcion

    WHERE re.id_evaluacion = p_id_evaluacion
    AND re.estado = 1

    ORDER BY re.id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- ACTUALIZAR EVALUACION
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_actualizar_evaluacion;

DELIMITER $$

CREATE PROCEDURE sp_actualizar_evaluacion(
    IN p_id BIGINT,
    IN p_observaciones TEXT,
    IN p_nivel_riesgo VARCHAR(50),
    IN p_estatus VARCHAR(50)
)
BEGIN

    UPDATE evaluacion
    SET
        observaciones = p_observaciones,
        nivel_riesgo = p_nivel_riesgo,
        estatus = p_estatus
    WHERE id = p_id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CAMBIAR ESTADO EVALUACION
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_estado_evaluacion;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_estado_evaluacion(
    IN p_id BIGINT,
    IN p_estado TINYINT
)
BEGIN

    UPDATE evaluacion
    SET estado = p_estado
    WHERE id = p_id;

END $$

DELIMITER ;
-- =====================================================
-- RESPUESTAS DE EVALUACION
-- =====================================================


-- //////////////////////////////////
-- GUARDAR RESPUESTA
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_guardar_respuesta;

DELIMITER $$

CREATE PROCEDURE sp_guardar_respuesta(
    IN p_id_evaluacion BIGINT,
    IN p_id_campo BIGINT,
    IN p_id_opcion BIGINT,
    IN p_valor_texto TEXT,
    IN p_valor_numero DECIMAL(12,2),
    IN p_valor_booleano TINYINT,
    IN p_valor_fecha DATE,
    IN p_puntaje DECIMAL(10,2),
    IN p_puntaje_ponderado DECIMAL(12,2),
    IN p_observacion TEXT
)
BEGIN

    INSERT INTO respuesta_evaluacion (
        id_evaluacion,
        id_campo,
        id_opcion,
        valor_texto,
        valor_numero,
        valor_booleano,
        valor_fecha,
        puntaje,
        puntaje_ponderado,
        observacion
    )
    VALUES (
        p_id_evaluacion,
        p_id_campo,
        p_id_opcion,
        p_valor_texto,
        p_valor_numero,
        p_valor_booleano,
        p_valor_fecha,
        p_puntaje,
        p_puntaje_ponderado,
        p_observacion
    );

    SELECT LAST_INSERT_ID() AS id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- ACTUALIZAR RESPUESTA
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_actualizar_respuesta;

DELIMITER $$

CREATE PROCEDURE sp_actualizar_respuesta(
    IN p_id BIGINT,
    IN p_id_opcion BIGINT,
    IN p_valor_texto TEXT,
    IN p_valor_numero DECIMAL(12,2),
    IN p_valor_booleano TINYINT,
    IN p_valor_fecha DATE,
    IN p_puntaje DECIMAL(10,2),
    IN p_puntaje_ponderado DECIMAL(12,2),
    IN p_observacion TEXT
)
BEGIN

    UPDATE respuesta_evaluacion
    SET
        id_opcion = p_id_opcion,
        valor_texto = p_valor_texto,
        valor_numero = p_valor_numero,
        valor_booleano = p_valor_booleano,
        valor_fecha = p_valor_fecha,
        puntaje = p_puntaje,
        puntaje_ponderado = p_puntaje_ponderado,
        observacion = p_observacion
    WHERE id = p_id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- LISTAR RESPUESTAS DE EVALUACION
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_respuestas_evaluacion;

DELIMITER $$

CREATE PROCEDURE sp_listar_respuestas_evaluacion(
    IN p_id_evaluacion BIGINT
)
BEGIN

    SELECT
        re.id,
        re.id_evaluacion,
        re.id_campo,

        cf.codigo,
        cf.etiqueta,

        re.id_opcion,
        op.etiqueta AS opcion,

        re.valor_texto,
        re.valor_numero,
        re.valor_booleano,
        re.valor_fecha,

        re.puntaje,
        re.puntaje_ponderado,
        re.observacion

    FROM respuesta_evaluacion re

    INNER JOIN campo_formulario cf
        ON cf.id = re.id_campo

    LEFT JOIN opcion_formulario op
        ON op.id = re.id_opcion

    WHERE re.id_evaluacion = p_id_evaluacion
    AND re.estado = 1

    ORDER BY re.id;

END $$

DELIMITER ;
-- //////////////////////////////////
-- ELIMINAR RESPUESTAS DE CAMPO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_eliminar_respuestas_campo;

DELIMITER $$

CREATE PROCEDURE sp_eliminar_respuestas_campo(
    IN p_id_evaluacion BIGINT,
    IN p_id_campo BIGINT
)
BEGIN

    DELETE FROM respuesta_evaluacion

    WHERE id_evaluacion = p_id_evaluacion
    AND id_campo = p_id_campo;

END $$

DELIMITER ;
-- //////////////////////////////////
-- CAMBIAR ESTADO RESPUESTA
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_estado_respuesta;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_estado_respuesta(
    IN p_id BIGINT,
    IN p_estado TINYINT
)
BEGIN

    UPDATE respuesta_evaluacion
    SET estado = p_estado
    WHERE id = p_id;

END $$

DELIMITER ;
-- =====================================================
-- FINALIZAR EVALUACION
-- =====================================================


-- //////////////////////////////////
-- FINALIZAR EVALUACION
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_finalizar_evaluacion;

DELIMITER $$

CREATE PROCEDURE sp_finalizar_evaluacion(
    IN p_id_evaluacion BIGINT,
    IN p_nivel_riesgo VARCHAR(50),
    IN p_observaciones TEXT
)
BEGIN

    DECLARE v_puntaje_total DECIMAL(12,2);


    SELECT
        COALESCE(
            SUM(
                COALESCE(
                    puntaje_ponderado,
                    puntaje,
                    0
                )
            ),
            0
        )
    INTO v_puntaje_total

    FROM respuesta_evaluacion

    WHERE id_evaluacion = p_id_evaluacion
    AND estado = 1;


    UPDATE evaluacion
    SET
        puntaje_total = v_puntaje_total,
        nivel_riesgo = p_nivel_riesgo,
        observaciones = p_observaciones,
        estatus = 'FINALIZADA'

    WHERE id = p_id_evaluacion;


    SELECT
        id,
        puntaje_total,
        nivel_riesgo,
        estatus

    FROM evaluacion

    WHERE id = p_id_evaluacion;

END $$

DELIMITER ;
-- =====================================================
-- RESULTADOS
-- =====================================================


-- //////////////////////////////////
-- RESULTADO POR SECCION
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_resultado_por_seccion;

DELIMITER $$

CREATE PROCEDURE sp_resultado_por_seccion(
    IN p_id_evaluacion BIGINT
)
BEGIN

    SELECT
        sf.id AS id_seccion,
        sf.nombre AS seccion,

        COUNT(re.id) AS cantidad_respuestas,

        COALESCE(
            SUM(
                COALESCE(
                    re.puntaje_ponderado,
                    re.puntaje,
                    0
                )
            ),
            0
        ) AS puntaje_total

    FROM seccion_formulario sf

    INNER JOIN campo_formulario cf
        ON cf.id_seccion = sf.id

    LEFT JOIN respuesta_evaluacion re
        ON re.id_campo = cf.id
        AND re.id_evaluacion = p_id_evaluacion
        AND re.estado = 1

    INNER JOIN documento_formulario df
        ON df.id = sf.id_documento

    INNER JOIN evaluacion e
        ON e.id_plantilla = df.id_plantilla

    WHERE e.id = p_id_evaluacion

    GROUP BY
        sf.id,
        sf.nombre,
        sf.orden_visualizacion

    ORDER BY sf.orden_visualizacion;

END $$

DELIMITER ;
-- //////////////////////////////////
-- RESUMEN EVALUACION
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_resumen_evaluacion;

DELIMITER $$

CREATE PROCEDURE sp_resumen_evaluacion(
    IN p_id_evaluacion BIGINT
)
BEGIN

    SELECT
        e.id,

        i.nombre AS industria,
        c.nombre AS cliente,
        s.nombre AS sucursal,

        pf.nombre AS plantilla,

        u.nombre AS evaluador,

        e.estatus,
        e.puntaje_total,
        e.nivel_riesgo,
        e.observaciones,

        COUNT(re.id) AS cantidad_respuestas,

        e.fecha_creacion

    FROM evaluacion e

    INNER JOIN sucursal s
        ON s.id = e.id_sucursal

    INNER JOIN cliente c
        ON c.id = s.id_cliente

    INNER JOIN industria i
        ON i.id = c.id_industria

    INNER JOIN plantilla_formulario pf
        ON pf.id = e.id_plantilla

    INNER JOIN usuarios u
        ON u.id = e.id_evaluador

    LEFT JOIN respuesta_evaluacion re
        ON re.id_evaluacion = e.id
        AND re.estado = 1

    WHERE e.id = p_id_evaluacion

    GROUP BY
        e.id,
        i.nombre,
        c.nombre,
        s.nombre,
        pf.nombre,
        u.nombre,
        e.estatus,
        e.puntaje_total,
        e.nivel_riesgo,
        e.observaciones,
        e.fecha_creacion;

END $$

DELIMITER ;