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
        activo,
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
        activo,
        fecha_creacion,
        fecha_actualizacion
    FROM rol
    WHERE activo = 1
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
        activo,
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
        activo,
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
-- CAMBIAR activo ROL
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_activo_rol;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_activo_rol(
    IN p_id BIGINT,
    IN p_activo TINYINT
)
BEGIN

    UPDATE rol
    SET activo = p_activo
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
        activo
    FROM usuarios
    WHERE correo = p_correo
    AND activo = 1;


    SELECT
        r.id,
        r.nombre
    FROM usuarios u

    INNER JOIN usuario_rol ur
        ON ur.id_usuario = u.id

    INNER JOIN rol r
        ON r.id = ur.id_rol

    WHERE u.correo = p_correo
    AND ur.activo = 1
    AND r.activo = 1;

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
        u.activo,

        GROUP_CONCAT(
            r.nombre
            ORDER BY r.nombre
            SEPARATOR ', '
        ) AS roles

    FROM usuarios u

    LEFT JOIN usuario_rol ur
        ON ur.id_usuario = u.id
        AND ur.activo = 1

    LEFT JOIN rol r
        ON r.id = ur.id_rol
        AND r.activo = 1

    GROUP BY
        u.id,
        u.nombre,
        u.correo,
        u.activo

    ORDER BY u.nombre;

END $$

DELIMITER ;

CALL sp_listar_usuarios();

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
        activo,
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
    AND ur.activo = 1
    AND r.activo = 1

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
-- CAMBIAR activo USUARIO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_activo_usuario;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_activo_usuario(
    IN p_id BIGINT,
    IN p_activo TINYINT
)
BEGIN

    UPDATE usuarios
    SET activo = p_activo
    WHERE id = p_id;

END $$

DELIMITER ;
CALL sp_cambiar_activo_usuario(1, 1);

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
        activo = 1;

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
    SET activo = 0
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
    AND ur.activo = 1
    AND r.activo = 1

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
        activo,
        fecha_creacion,
        fecha_actualizacion
    FROM departamento
    ORDER BY nombre;

END $$
DELIMITER ;

CALL sp_listar_departamentos();


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
        activo,
        fecha_creacion,
        fecha_actualizacion
    FROM departamento
    WHERE activo = 1
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
        activo,
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
        activo,
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

CALL sp_crear_departamento('Guatemala');

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
-- CAMBIAR activo DEPARTAMENTO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_activo_departamento;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_activo_departamento(
    IN p_id BIGINT,
    IN p_activo TINYINT
)
BEGIN

    UPDATE departamento
    SET activo = p_activo
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
        m.activo
    FROM municipio m

    INNER JOIN departamento d
        ON d.id = m.id_departamento

    ORDER BY
        d.nombre,
        m.nombre;

END $$

DELIMITER ;

-- //////////////////////////////////
-- LISTAR MUNICIPIOS ACTIVOS
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_municipios_activos;

DELIMITER $$

CREATE PROCEDURE sp_listar_municipios_activos()
BEGIN

    SELECT
        m.id,
        m.nombre,
        m.id_departamento,
        d.nombre AS departamento,
        m.activo
    FROM municipio m

    INNER JOIN departamento d
        ON d.id = m.id_departamento

    WHERE m.activo = 1

    ORDER BY
        d.nombre,
        m.nombre;

END $$

DELIMITER ;

CALL sp_listar_municipios_activos();

-- //////////////////////////////////
-- LISTAR MUNICIPIOS POR ID
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_municipios_id;

DELIMITER $$

CREATE PROCEDURE sp_listar_municipios_id(
    IN id_municipio BIGINT
)
BEGIN

    SELECT
        m.id,
        m.nombre,
        m.id_departamento,
        d.nombre AS departamento,
        m.activo

    FROM municipio m

    INNER JOIN departamento d
        ON d.id = m.id_departamento

    WHERE m.id = id_municipio
    AND m.activo = 1
    AND d.activo = 1

    LIMIT 1;

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
    AND activo = 1
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

CALL sp_crear_municipio(1, 'Villa Canales');

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
-- CAMBIAR activo MUNICIPIO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_activo_municipio;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_activo_municipio(
    IN p_id BIGINT,
    IN p_activo TINYINT
)
BEGIN

    UPDATE municipio
    SET activo = p_activo
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
        activo,
        fecha_creacion,
        fecha_actualizacion
    FROM industria
    ORDER BY nombre;

END $$

DELIMITER ;


-- //////////////////////////////////
-- LISTAR INDUSTRIAS ACTIVAS
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_industrias_activas;

DELIMITER $$

CREATE PROCEDURE sp_listar_industrias_activas()
BEGIN

    SELECT
        id,
        nombre,
        correo,
        descripcion,
        activo,
        fecha_creacion,
        fecha_actualizacion
    FROM industria
    WHERE activo = 1
    ORDER BY nombre;

END $$

DELIMITER ;


-- //////////////////////////////////
-- LISTAR INDUSTRIA POR ID
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_industrias_id;

DELIMITER $$

CREATE PROCEDURE sp_listar_industrias_id(
    IN id_industria BIGINT
)
BEGIN

    SELECT
        id,
        nombre,
        correo,
        descripcion,
        activo,
        fecha_creacion,
        fecha_actualizacion
    FROM industria
    WHERE id = id_industria
    LIMIT 1;

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

CALL sp_crear_industria('prueba 1','','pruebas de industrias');

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
-- CAMBIAR activo INDUSTRIA
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_activo_industria;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_activo_industria(
    IN p_id BIGINT,
    IN p_activo TINYINT
)
BEGIN

    UPDATE industria
    SET activo = p_activo
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
        c.activo,
        c.fecha_creacion,
        c.fecha_actualizacion
    FROM cliente c

    INNER JOIN industria i
        ON i.id = c.id_industria

    ORDER BY c.nombre;

END $$

DELIMITER ;


-- //////////////////////////////////
-- LISTAR CLIENTES ACTIVOS
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_clientes_activos;

DELIMITER $$

CREATE PROCEDURE sp_listar_clientes_activos()
BEGIN

    SELECT
        c.id,
        c.nombre,
        c.telefono,
        c.id_industria,
        i.nombre AS industria,
        c.activo,
        c.fecha_creacion,
        c.fecha_actualizacion
    FROM cliente c

    INNER JOIN industria i
        ON i.id = c.id_industria

    WHERE c.activo = 1
    AND i.activo = 1

    ORDER BY c.nombre;

END $$

DELIMITER ;


-- //////////////////////////////////
-- LISTAR CLIENTE POR ID
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_clientes_id;

DELIMITER $$

CREATE PROCEDURE sp_listar_clientes_id(
    IN id_cliente BIGINT
)
BEGIN

    SELECT
        c.id,
        c.nombre,
        c.telefono,
        c.id_industria,
        i.nombre AS industria,
        c.activo,
        c.fecha_creacion,
        c.fecha_actualizacion
    FROM cliente c

    INNER JOIN industria i
        ON i.id = c.id_industria

    WHERE c.id = id_cliente

    LIMIT 1;

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
        c.id,
        c.nombre,
        c.telefono,
        c.id_industria,
        i.nombre AS industria,
        c.activo
    FROM cliente c

    INNER JOIN industria i
        ON i.id = c.id_industria

    WHERE c.id_industria = p_id_industria
    AND c.activo = 1
    AND i.activo = 1

    ORDER BY c.nombre;

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
-- CAMBIAR activo CLIENTE
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_activo_cliente;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_activo_cliente(
    IN p_id BIGINT,
    IN p_activo TINYINT
)
BEGIN

    UPDATE cliente
    SET activo = p_activo
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

        c.id_industria,
        i.nombre AS industria,

        s.id_municipio,
        m.nombre AS municipio,

        d.id AS id_departamento,
        d.nombre AS departamento,

        s.activo,
        s.fecha_creacion,
        s.fecha_actualizacion

    FROM sucursal s

    INNER JOIN cliente c
        ON c.id = s.id_cliente

    INNER JOIN industria i
        ON i.id = c.id_industria

    INNER JOIN municipio m
        ON m.id = s.id_municipio

    INNER JOIN departamento d
        ON d.id = m.id_departamento

    ORDER BY s.nombre;

END $$

DELIMITER ;


-- //////////////////////////////////
-- LISTAR SUCURSALES ACTIVAS
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_sucursales_activas;

DELIMITER $$

CREATE PROCEDURE sp_listar_sucursales_activas()
BEGIN

    SELECT
        s.id,
        s.nombre,

        s.id_cliente,
        c.nombre AS cliente,

        c.id_industria,
        i.nombre AS industria,

        s.id_municipio,
        m.nombre AS municipio,

        d.id AS id_departamento,
        d.nombre AS departamento,

        s.activo,
        s.fecha_creacion,
        s.fecha_actualizacion

    FROM sucursal s

    INNER JOIN cliente c
        ON c.id = s.id_cliente

    INNER JOIN industria i
        ON i.id = c.id_industria

    INNER JOIN municipio m
        ON m.id = s.id_municipio

    INNER JOIN departamento d
        ON d.id = m.id_departamento

    WHERE s.activo = 1
    AND c.activo = 1
    AND i.activo = 1
    AND m.activo = 1
    AND d.activo = 1

    ORDER BY s.nombre;

END $$

DELIMITER ;


-- //////////////////////////////////
-- LISTAR SUCURSAL POR ID
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_sucursales_id;

DELIMITER $$

CREATE PROCEDURE sp_listar_sucursales_id(
    IN id_sucursal BIGINT
)
BEGIN

    SELECT
        s.id,
        s.nombre,

        s.id_cliente,
        c.nombre AS cliente,

        c.id_industria,
        i.nombre AS industria,

        s.id_municipio,
        m.nombre AS municipio,

        d.id AS id_departamento,
        d.nombre AS departamento,

        s.activo,
        s.fecha_creacion,
        s.fecha_actualizacion

    FROM sucursal s

    INNER JOIN cliente c
        ON c.id = s.id_cliente

    INNER JOIN industria i
        ON i.id = c.id_industria

    INNER JOIN municipio m
        ON m.id = s.id_municipio

    INNER JOIN departamento d
        ON d.id = m.id_departamento

    WHERE s.id = id_sucursal

    LIMIT 1;

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
        c.nombre AS cliente,

        s.id_municipio,
        m.nombre AS municipio,

        d.id AS id_departamento,
        d.nombre AS departamento,

        s.activo

    FROM sucursal s

    INNER JOIN cliente c
        ON c.id = s.id_cliente

    INNER JOIN municipio m
        ON m.id = s.id_municipio

    INNER JOIN departamento d
        ON d.id = m.id_departamento

    WHERE s.id_cliente = p_id_cliente
    AND s.activo = 1
    AND c.activo = 1
    AND m.activo = 1
    AND d.activo = 1

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
-- CAMBIAR activo SUCURSAL
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_activo_sucursal;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_activo_sucursal(
    IN p_id BIGINT,
    IN p_activo TINYINT
)
BEGIN

    UPDATE sucursal
    SET activo = p_activo
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
    WHERE activo = 1
    ORDER BY nombre;

END $$

DELIMITER ;

-- //////////////////////////////////
-- LISTAR TIPO CAMPO POR ID
-- //////////////////////////////////

DROP PROCEDURE IF EXISTS sp_listar_tipo_campo_id;

DELIMITER $$

CREATE PROCEDURE sp_listar_tipo_campo_id(
    IN p_id BIGINT
)
BEGIN

    SELECT
        id,
        nombre,
        activo

    FROM tipo_campo

    WHERE id = p_id

    LIMIT 1;

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

CALL sp_crear_tipo_campo('Text');
CALL sp_crear_tipo_campo('Textarea');
CALL sp_crear_tipo_campo('Number');
CALL sp_crear_tipo_campo('Decimal');
CALL sp_crear_tipo_campo('Date');
CALL sp_crear_tipo_campo('Time');
CALL sp_crear_tipo_campo('Select');
CALL sp_crear_tipo_campo('Radio');
CALL sp_crear_tipo_campo('Checkbox');
CALL sp_crear_tipo_campo('Multi Select');
CALL sp_crear_tipo_campo('Yes or No');

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
-- CAMBIAR activo TIPO CAMPO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_activo_tipo_campo;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_activo_tipo_campo(
    IN p_id BIGINT,
    IN p_activo TINYINT
)
BEGIN

    UPDATE tipo_campo
    SET activo = p_activo
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

        cf.id_tipo_campo,
        tc.nombre AS tipo_campo,

        cf.requerido,
        cf.valor_minimo,
        cf.valor_maximo,
        cf.orden_visualizacion,
        cf.activo

    FROM campo_formulario cf

    INNER JOIN tipo_campo tc
        ON tc.id = cf.id_tipo_campo

    WHERE cf.id_seccion = p_id_seccion
    AND cf.activo = 1

    ORDER BY cf.orden_visualizacion;

END $$

DELIMITER ;

CALL sp_listar_campos_seccion(7);

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
    IN p_id_tipo_campo BIGINT,
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
        id_tipo_campo,
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
        p_id_tipo_campo,
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
    IN p_id_tipo_campo BIGINT,
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
        id_tipo_campo = p_id_tipo_campo,
        requerido = p_requerido,
        valor_minimo = p_valor_minimo,
        valor_maximo = p_valor_maximo,
        orden_visualizacion = p_orden_visualizacion

    WHERE id = p_id;

END $$

DELIMITER ;


-- //////////////////////////////////
-- CAMBIAR ACTIVO CAMPO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_activo_campo;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_activo_campo(
    IN p_id BIGINT,
    IN p_activo TINYINT
)
BEGIN

    UPDATE campo_formulario

    SET activo = p_activo

    WHERE id = p_id;

END $$

DELIMITER ;

-- =====================================================
-- PLANTILLAS
-- =====================================================

-- //////////////////////////////////
-- LISTAR PLANTILLA POR ID
-- //////////////////////////////////

DROP PROCEDURE IF EXISTS sp_listar_plantilla_id;

DELIMITER $$

CREATE PROCEDURE sp_listar_plantilla_id(
    IN p_id BIGINT
)
BEGIN

    SELECT
        pf.id,
        pf.nombre,
        pf.id_industria,
        i.nombre AS industria,
        pf.activo

    FROM plantilla_formulario pf

    INNER JOIN industria i
        ON i.id = pf.id_industria

    WHERE pf.id = p_id

    LIMIT 1;

END $$

DELIMITER ;

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
        pf.id_industria,
        i.nombre AS industria,
        pf.activo

    FROM plantilla_formulario pf

    INNER JOIN industria i
        ON i.id = pf.id_industria

    WHERE pf.activo = 1

    ORDER BY pf.nombre;

END $$

DELIMITER ;

CALL sp_listar_plantillas();

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
        id_industria

    FROM plantilla_formulario

    WHERE id_industria = p_id_industria
    AND activo = 1

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
    IN p_nombre VARCHAR(150)
)
BEGIN

    INSERT INTO plantilla_formulario (
        id_industria,
        nombre
    )
    VALUES (
        p_id_industria,
        p_nombre
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
    IN p_nombre VARCHAR(150)
)

BEGIN

    UPDATE plantilla_formulario

    SET
        id_industria = p_id_industria,
        nombre = p_nombre

    WHERE id = p_id;

END $$

DELIMITER ;

CALL sp_actualizar_plantilla(1, 4, 'Evaluación de Seguridad Bancaria');

-- //////////////////////////////////
-- CAMBIAR ACTIVO PLANTILLA
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_activo_plantilla;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_activo_plantilla(IN p_id BIGINT, IN p_activo TINYINT)
    
BEGIN

    UPDATE plantilla_formulario

    SET activo = p_activo

    WHERE id = p_id;

END $$

DELIMITER ;

CALL sp_cambiar_activo_plantilla(2,0);
-- =====================================================
-- DOCUMENTOS
-- =====================================================

-- //////////////////////////////////
-- LISTAR DOCUMENTOS DE PLANTILLA
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_documentos_plantilla;

DELIMITER $$

CREATE PROCEDURE sp_listar_documentos_plantilla(IN p_id_plantilla BIGINT)

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
    AND activo = 1
    ORDER BY orden_visualizacion;

END $$

DELIMITER ;

-- //////////////////////////////////
-- LISTAR DOCUMENTO POR ID
-- //////////////////////////////////

DROP PROCEDURE IF EXISTS sp_listar_documento_id;

DELIMITER $$

CREATE PROCEDURE sp_listar_documento_id(IN p_id BIGINT)

BEGIN

    SELECT
        d.id,
        d.id_plantilla,
        pf.nombre AS plantilla,
        d.codigo,
        d.nombre,
        d.descripcion,
        d.orden_visualizacion,
        d.activo

    FROM documento_formulario d

    INNER JOIN plantilla_formulario pf
        ON pf.id = d.id_plantilla

    WHERE d.id = p_id

    LIMIT 1;

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

CREATE PROCEDURE sp_actualizar_documento(IN p_id BIGINT, IN p_codigo VARCHAR(100), IN p_nombre VARCHAR(150), IN p_descripcion VARCHAR(255), IN p_orden_visualizacion INT)

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
-- CAMBIAR activo DOCUMENTO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_activo_documento;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_activo_documento(
    IN p_id BIGINT,
    IN p_activo TINYINT
)
BEGIN

    UPDATE documento_formulario
    SET activo = p_activo
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

CREATE PROCEDURE sp_listar_secciones_documento(IN p_id_documento BIGINT)
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
    AND activo = 1
    ORDER BY orden_visualizacion;

END $$

DELIMITER ;

CALL sp_listar_secciones_documento(6);
-- //////////////////////////////////
-- LISTAR SECCION POR ID
-- //////////////////////////////////

DROP PROCEDURE IF EXISTS sp_listar_seccion_id;

DELIMITER $$

CREATE PROCEDURE sp_listar_seccion_id(IN p_id BIGINT)
BEGIN

    SELECT
        s.id,
        s.id_documento,
        d.nombre AS documento,
        s.nombre,
        s.icono,
        s.numero_columnas,
        s.orden_visualizacion,
        s.activo

    FROM seccion_formulario s

    INNER JOIN documento_formulario d
        ON d.id = s.id_documento

    WHERE s.id = p_id

    LIMIT 1;

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
-- CAMBIAR activo SECCION
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_activo_seccion;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_activo_seccion(IN p_id BIGINT, IN p_activo TINYINT)
BEGIN

    UPDATE seccion_formulario
    SET activo = p_activo
    WHERE id = p_id;

END $$

DELIMITER ;

-- =====================================================
-- CAMPOS
-- =====================================================

-- //////////////////////////////////
-- LISTAR CAMPO POR ID
-- //////////////////////////////////

DROP PROCEDURE IF EXISTS sp_listar_campo_id;

DELIMITER $$

CREATE PROCEDURE sp_listar_campo_id(
    IN p_id BIGINT
)
BEGIN

    SELECT
        cf.id,
        cf.id_seccion,
        s.nombre AS seccion,

        cf.codigo,
        cf.etiqueta,
        cf.texto_ayuda,
        cf.texto_guia,

        cf.id_tipo_campo,
        tc.nombre AS tipo_campo,

        cf.requerido,
        cf.valor_minimo,
        cf.valor_maximo,
        cf.orden_visualizacion,
        cf.activo

    FROM campo_formulario cf

    INNER JOIN seccion_formulario s
        ON s.id = cf.id_seccion

    INNER JOIN tipo_campo tc
        ON tc.id = cf.id_tipo_campo

    WHERE cf.id = p_id

    LIMIT 1;

END $$

DELIMITER ;


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

        cf.id_tipo_campo,
        tc.nombre AS tipo_campo,

        cf.requerido,
        cf.valor_minimo,
        cf.valor_maximo,
        cf.orden_visualizacion,
        cf.activo

    FROM campo_formulario cf

    INNER JOIN tipo_campo tc
        ON tc.id = cf.id_tipo_campo

    WHERE cf.id_seccion = p_id_seccion
    AND cf.activo = 1

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
    IN p_id_tipo_campo BIGINT,
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
        id_tipo_campo,
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
        p_id_tipo_campo,
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
    IN p_id_tipo_campo BIGINT,
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
        id_tipo_campo = p_id_tipo_campo,
        requerido = p_requerido,
        valor_minimo = p_valor_minimo,
        valor_maximo = p_valor_maximo,
        orden_visualizacion = p_orden_visualizacion

    WHERE id = p_id;

END $$

DELIMITER ;


-- //////////////////////////////////
-- CAMBIAR ACTIVO CAMPO
-- //////////////////////////////////

DROP PROCEDURE IF EXISTS sp_cambiar_activo_campo;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_activo_campo(
    IN p_id BIGINT,
    IN p_activo TINYINT
)
BEGIN

    UPDATE campo_formulario

    SET
        activo = p_activo

    WHERE id = p_id;

END $$

DELIMITER ;

-- =====================================================
-- OPCIONES DE CAMPO
-- =====================================================

-- //////////////////////////////////
-- LISTAR OPCIONES DE CAMPO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_opcion_id;

DELIMITER $$

CREATE PROCEDURE sp_listar_opcion_id(IN p_id BIGINT)
BEGIN
    SELECT
        o.id,
        o.id_campo_formulario,
        cf.etiqueta AS campo,
        o.codigo,
        o.valor,
        o.puntaje,
        o.etiqueta,
        o.orden_visualizacion,
        o.activo
    FROM opcion_formulario o
    INNER JOIN campo_formulario cf ON cf.id = o.id_campo_formulario
    WHERE o.id = p_id
    LIMIT 1;
END $$

DELIMITER ;

-- //////////////////////////////////
-- LISTAR OPCION DE CAMPO POR ID
-- //////////////////////////////////

DROP PROCEDURE IF EXISTS sp_listar_opciones_campo;

DELIMITER $$

CREATE PROCEDURE sp_listar_opciones_campo(IN p_id_campo BIGINT)
BEGIN
    SELECT
        id,
        id_campo_formulario,
        codigo,
        valor,
        puntaje,
        etiqueta,
        orden_visualizacion,
        activo
    FROM opcion_formulario
    WHERE id_campo_formulario = p_id_campo
    AND activo = 1
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
    IN p_codigo VARCHAR(100),
    IN p_valor VARCHAR(255),
    IN p_puntaje DECIMAL(10,2),
    IN p_etiqueta VARCHAR(255),
    IN p_orden_visualizacion INT
)
BEGIN
    INSERT INTO opcion_formulario (
        id_campo_formulario,
        codigo,
        valor,
        puntaje,
        etiqueta,
        orden_visualizacion
    )
    VALUES (
        p_id_campo_formulario,
        p_codigo,
        p_valor,
        p_puntaje,
        p_etiqueta,
        p_orden_visualizacion
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
    IN p_codigo VARCHAR(100),
    IN p_valor VARCHAR(255),
    IN p_puntaje DECIMAL(10,2),
    IN p_etiqueta VARCHAR(255),
    IN p_orden_visualizacion INT
)
BEGIN
    UPDATE opcion_formulario
    SET
        codigo = p_codigo,
        valor = p_valor,
        puntaje = p_puntaje,
        etiqueta = p_etiqueta,
        orden_visualizacion = p_orden_visualizacion
    WHERE id = p_id;
END $$

DELIMITER ;

-- //////////////////////////////////
-- CAMBIAR activo OPCION
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_activo_opcion;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_activo_opcion(IN p_id BIGINT, IN p_activo TINYINT)
BEGIN
    UPDATE opcion_formulario
    SET activo = p_activo
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
    WHERE activo = 1
    ORDER BY nombre;

END $$

DELIMITER ;
-- //////////////////////////////////
-- LISTAR TIPO EVENTO POR ID
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_tipo_evento_id;

DELIMITER $$

CREATE PROCEDURE sp_listar_tipo_evento_id(IN p_id BIGINT)
BEGIN
    SELECT id, nombre, activo
    FROM tipo_evento
    WHERE id = p_id
    LIMIT 1;
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
    WHERE activo = 1
    ORDER BY nombre;

END $$

DELIMITER ;
-- //////////////////////////////////
-- LISTAR TIPO ACCION POR ID
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_tipo_accion_id;

DELIMITER $$

CREATE PROCEDURE sp_listar_tipo_accion_id(IN p_id BIGINT)
BEGIN
    SELECT id, nombre, activo
    FROM tipo_accion
    WHERE id = p_id
    LIMIT 1;
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
        ecf.orden_visualizacion,
        ecf.activo

    FROM evento_campo_formulario ecf

    INNER JOIN tipo_evento te
        ON te.id = ecf.id_tipo_evento

    INNER JOIN tipo_accion ta
        ON ta.id = ecf.id_tipo_accion

    WHERE ecf.id_campo_formulario = p_id_campo
    AND ecf.activo = 1

    ORDER BY ecf.orden_visualizacion;

END $$

DELIMITER ;


-- //////////////////////////////////
-- LISTAR EVENTO DE CAMPO POR ID
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_listar_evento_campo_id;

DELIMITER $$

CREATE PROCEDURE sp_listar_evento_campo_id(
    IN p_id BIGINT
)
BEGIN

    SELECT
        ecf.id,
        ecf.id_campo_formulario,
        cf.etiqueta AS campo,
        ecf.id_tipo_evento,
        te.nombre AS tipo_evento,
        ecf.id_tipo_accion,
        ta.nombre AS tipo_accion,
        ecf.configuracion_condicion,
        ecf.configuracion_accion,
        ecf.orden_visualizacion,
        ecf.activo

    FROM evento_campo_formulario ecf

    INNER JOIN campo_formulario cf
        ON cf.id = ecf.id_campo_formulario

    INNER JOIN tipo_evento te
        ON te.id = ecf.id_tipo_evento

    INNER JOIN tipo_accion ta
        ON ta.id = ecf.id_tipo_accion

    WHERE ecf.id = p_id

    LIMIT 1;

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
-- CAMBIAR ACTIVO EVENTO
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_activo_evento;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_activo_evento(
    IN p_id BIGINT,
    IN p_activo TINYINT
)
BEGIN

    UPDATE evento_campo_formulario
    SET activo = p_activo
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
        pf.id_industria,
        i.nombre AS industria,
        pf.activo
    FROM plantilla_formulario pf
    INNER JOIN industria i
        ON i.id = pf.id_industria
    WHERE pf.id = p_id_plantilla;


    -- DOCUMENTOS
    SELECT
        d.id,
        d.id_plantilla,
        d.codigo,
        d.nombre,
        d.descripcion,
        d.orden_visualizacion,
        d.activo
    FROM documento_formulario d
    WHERE d.id_plantilla = p_id_plantilla
    AND d.activo = 1
    ORDER BY d.orden_visualizacion;


    -- SECCIONES
    SELECT
        s.id,
        s.id_documento,
        s.nombre,
        s.icono,
        s.numero_columnas,
        s.orden_visualizacion,
        s.activo
    FROM seccion_formulario s
    INNER JOIN documento_formulario d
        ON d.id = s.id_documento
    WHERE d.id_plantilla = p_id_plantilla
    AND d.activo = 1
    AND s.activo = 1
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
        cf.id_tipo_campo,
        tc.nombre AS tipo_campo,
        cf.requerido,
        cf.valor_minimo,
        cf.valor_maximo,
        cf.orden_visualizacion,
        cf.activo
    FROM campo_formulario cf
    INNER JOIN seccion_formulario s
        ON s.id = cf.id_seccion
    INNER JOIN documento_formulario d
        ON d.id = s.id_documento
    INNER JOIN tipo_campo tc
        ON tc.id = cf.id_tipo_campo
    WHERE d.id_plantilla = p_id_plantilla
    AND d.activo = 1
    AND s.activo = 1
    AND cf.activo = 1
    AND tc.activo = 1
    ORDER BY
        d.orden_visualizacion,
        s.orden_visualizacion,
        cf.orden_visualizacion;


    -- OPCIONES
    SELECT
        o.id,
        o.id_campo_formulario,
        o.codigo,
        o.valor,
        o.puntaje,
        o.etiqueta,
        o.orden_visualizacion,
        o.activo
    FROM opcion_formulario o
    INNER JOIN campo_formulario cf
        ON cf.id = o.id_campo_formulario
    INNER JOIN seccion_formulario s
        ON s.id = cf.id_seccion
    INNER JOIN documento_formulario d
        ON d.id = s.id_documento
    WHERE d.id_plantilla = p_id_plantilla
    AND d.activo = 1
    AND s.activo = 1
    AND cf.activo = 1
    AND o.activo = 1
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
        ecf.orden_visualizacion,
        ecf.activo
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
    AND d.activo = 1
    AND s.activo = 1
    AND cf.activo = 1
    AND ecf.activo = 1
    AND te.activo = 1
    AND ta.activo = 1
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

    WHERE e.activo = 1

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
        e.activo,
        e.id_sucursal,
        s.nombre AS sucursal,
        c.id AS id_cliente,
        c.nombre AS cliente,
        i.id AS id_industria,
        i.nombre AS industria,
        e.id_plantilla,
        pf.nombre AS plantilla,
        e.id_evaluador,
        u.nombre AS evaluador,
        e.fecha_creacion

    FROM evaluacion e

    LEFT JOIN sucursal s ON s.id = e.id_sucursal
    LEFT JOIN cliente c ON c.id = s.id_cliente
    LEFT JOIN industria i ON i.id = c.id_industria
    LEFT JOIN plantilla_formulario pf ON pf.id = e.id_plantilla
    LEFT JOIN usuarios u ON u.id = e.id_evaluador

    WHERE e.id = p_id_evaluacion;


    -- ==========================================
    -- RESPUESTAS
    -- ==========================================
    SELECT
        re.id,
        re.id_campo,
        cf.codigo,
        cf.etiqueta,
        cf.id_tipo_campo,
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

    LEFT JOIN campo_formulario cf ON cf.id = re.id_campo
    LEFT JOIN tipo_campo tc ON tc.id = cf.id_tipo_campo
    LEFT JOIN opcion_formulario op ON op.id = re.id_opcion
    WHERE re.id_evaluacion = p_id_evaluacion AND re.activo = 1

    ORDER BY re.id;

END $$

DELIMITER ;

CALL sp_obtener_evaluacion(5);

-- //////////////////////////////////
-- OBTENER EVALUACION POR ID
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_obtener_evaluacion_id;

DELIMITER $$

CREATE PROCEDURE sp_obtener_evaluacion_id(
    IN p_id_evaluacion BIGINT
)
BEGIN

    SELECT
        e.id,
        e.estatus,
        e.observaciones,
        e.puntaje_total,
        e.nivel_riesgo,
        e.activo,
        e.id_sucursal,
        s.nombre AS sucursal,
        c.id AS id_cliente,
        c.nombre AS cliente,
        i.id AS id_industria,
        i.nombre AS industria,
        e.id_plantilla,
        pf.nombre AS plantilla,
        e.id_evaluador,
        u.nombre AS evaluador,
        e.fecha_creacion

    FROM evaluacion e

    LEFT JOIN sucursal s ON s.id = e.id_sucursal
    LEFT JOIN cliente c ON c.id = s.id_cliente
    LEFT JOIN industria i ON i.id = c.id_industria
    LEFT JOIN plantilla_formulario pf ON pf.id = e.id_plantilla
    LEFT JOIN usuarios u ON u.id = e.id_evaluador

    WHERE e.id = p_id_evaluacion;

END $$

DELIMITER ;

CALL sp_obtener_evaluacion_id(5);

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
-- CAMBIAR activo EVALUACION
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_activo_evaluacion;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_activo_evaluacion(
    IN p_id BIGINT,
    IN p_activo TINYINT
)
BEGIN

    UPDATE evaluacion
    SET activo = p_activo
    WHERE id = p_id;

END $$

DELIMITER ;

CALL sp_cambiar_activo_evaluacion(2, 0);
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
    AND re.activo = 1

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
-- CAMBIAR activo RESPUESTA
-- //////////////////////////////////
DROP PROCEDURE IF EXISTS sp_cambiar_activo_respuesta;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_activo_respuesta(
    IN p_id BIGINT,
    IN p_activo TINYINT
)
BEGIN

    UPDATE respuesta_evaluacion
    SET activo = p_activo
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
    AND activo = 1;


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
        AND re.activo = 1

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
        AND re.activo = 1

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