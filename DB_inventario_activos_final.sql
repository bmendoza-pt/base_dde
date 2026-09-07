drop database if exists inventario_activos;

CREATE DATABASE inventario_activos;

USE inventario_activos;

CREATE TABLE empresa (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    prefijo VARCHAR(150) NOT NULL,
    descripcion VARCHAR(255),
    activo TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
);

SELECT id, nombre FROM empresa;

INSERT INTO empresa (nombre, prefijo, descripcion)
VALUES
('GEOTOTAL', 'GEO', 'Empresa GEOTOTAL'),
('PROTECCION TOTAL', 'PT', 'Empresa PROTECCION TOTAL');

CREATE TABLE area_empresa (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
	id_empresa BIGINT NULL,
    nombre VARCHAR(150) NOT NULL,
    descripcion VARCHAR(255),
    activo TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_area_empresa_empresa 
    FOREIGN KEY (id_empresa) REFERENCES empresa(id)
);

INSERT INTO area_empresa (id_empresa, nombre)
VALUES
(1,'COMPRAS'),
(1, 'IT'),
(2, 'ADMINISTRACION');

SELECT * FROM area_empresa;

CREATE TABLE rol (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    activo TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO rol (nombre) VALUES
('ADMINISTRADOR'),
('USUARIO');

CREATE TABLE users
(
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(250) NOT NULL,
    email VARCHAR(250) NOT NULL UNIQUE,
    password VARCHAR(250) NOT NULL,
    id_rol BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    id_usuario_crea BIGINT NULL,
    id_usuario_modifica BIGINT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_users_rol FOREIGN KEY (id_rol) 
		REFERENCES rol(id)
);

SELECT * FROM users;

INSERT INTO users (nombre,email,password,id_rol,activo,id_usuario_crea)
VALUES ('Administrador','admin@protecciontotal.gt','$2b$10$1sfBsH7IwnenIlPQ/9zZ6.qyKK.fm3ngayJnb8mXmxZT.RjQK0SKy',1,1,NULL);

CREATE TABLE usuario_area_permiso (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_usuario BIGINT NOT NULL,
    id_area BIGINT NOT NULL,
    activo TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_usuario_area_permiso_usuario
        FOREIGN KEY (id_usuario) REFERENCES users(id),
    CONSTRAINT fk_usuario_area_permiso_area
        FOREIGN KEY (id_area) REFERENCES area_empresa(id),
    UNIQUE (id_usuario, id_area)
);

SELECT * FROM usuario_area_permiso;

CREATE TABLE categoria_activo (
	id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    activo TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO categoria_activo (nombre) VALUES
('Equipo principal'),
('Periférico'),
('Componente interno'),
('Cable'),
('Adaptador'),
('Red'),
('Energía'),
('CCTV'),
('Consumible'),
('Licencia'),
('Herramienta');

CREATE TABLE tipo_activo (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_categoria_activo BIGINT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    prefijo VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    maneja_serie TINYINT DEFAULT 1,
    activo TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_tipo_activo_categoria FOREIGN KEY (id_categoria_activo)
        REFERENCES categoria_activo (id)
);

INSERT INTO tipo_activo (
    id_categoria_activo,
    nombre,
    prefijo,
    descripcion,
    maneja_serie
)
VALUES (
    (SELECT id FROM categoria_activo WHERE nombre = 'Equipo principal' LIMIT 1),'Laptop','lap','Computadora portátil asignable a empleados',1);

CREATE TABLE marca (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    activo TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO marca (
    nombre
)
VALUES ('Dell'),('HP'),('Lenovo'),('Apple'),('Samsung'),('Asus'),('Acer');

CREATE TABLE estado_activo (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    activo TINYINT DEFAULT 1
);

INSERT INTO estado_activo (
    nombre,
    descripcion
)
VALUES
    ('Disponible', 'Activo disponible para asignación'),
    ('Asignado', 'Activo asignado a un empleado'),
    ('En reparación', 'Activo enviado a reparación o mantenimiento'),
    ('Dañado', 'Activo que presenta daños'),
    ('De baja', 'Activo retirado del inventario'),
    ('En mantenimiento', 'Activo enviado a mantenimiento'),
    ('Upgrade', 'Se Actualizan los componentes de un activo');

SELECT * FROM estado_activo;

CREATE TABLE condicion_activo (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    activo TINYINT DEFAULT 1
);

INSERT INTO condicion_activo (
    nombre,
    descripcion
)
VALUES
    ('Nuevo', 'Activo nuevo sin uso previo'),
    ('Buen estado', 'Activo usado en buenas condiciones'),
    ('Estado regular', 'Activo funcional con señales de uso'),
    ('Mal estado', 'Activo con daños o desgaste considerable');

SELECT * FROM condicion_activo;

CREATE TABLE activos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    codigo_activo VARCHAR(50) NOT NULL UNIQUE,
    codigo_barra VARCHAR(255) UNIQUE,
    id_tipo_activo BIGINT NOT NULL,
    id_marca BIGINT NULL,
    id_estado_activo BIGINT NOT NULL,
    id_condicion_activo BIGINT NULL,
    modelo VARCHAR(150),
    serie VARCHAR(150),
    color VARCHAR(80),
    descripcion TEXT,
    fecha_ingreso DATE,
    fecha_compra DATE,
    garantia_inicio DATE,
    garantia_fin DATE,
    observaciones TEXT,
    codigo_empleado_actual INT NULL,
    id_empresa_propietaria BIGINT NULL,
    id_area_responsable BIGINT NULL,
    activo TINYINT DEFAULT 1,
    id_usuario_crea BIGINT NULL,
    id_usuario_modifica BIGINT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_activos_tipo_activo
        FOREIGN KEY (id_tipo_activo) REFERENCES tipo_activo(id),
    CONSTRAINT fk_activos_marca
        FOREIGN KEY (id_marca) REFERENCES marca(id),
    CONSTRAINT fk_activos_estado
        FOREIGN KEY (id_estado_activo) REFERENCES estado_activo(id),
    CONSTRAINT fk_activos_condicion
        FOREIGN KEY (id_condicion_activo) REFERENCES condicion_activo(id),
    CONSTRAINT fk_activos_empresa
        FOREIGN KEY (id_empresa_propietaria) REFERENCES empresa(id),
    CONSTRAINT fk_activos_area
        FOREIGN KEY (id_area_responsable) REFERENCES area_empresa(id),
    CONSTRAINT fk_activos_usuario_crea
        FOREIGN KEY (id_usuario_crea) REFERENCES users(id),
    CONSTRAINT fk_activos_usuario_modifica
        FOREIGN KEY (id_usuario_modifica) REFERENCES users(id)
);

SELECT * FROM estado_activo;

CREATE TABLE activo_atributo (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_tipo_activo BIGINT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    tipo_dato ENUM('texto', 'numero', 'decimal', 'fecha', 'booleano') DEFAULT 'texto',
    clave VARCHAR(100) NOT NULL,
    unidad VARCHAR(50),
    requerido TINYINT DEFAULT 0,
    orden INT DEFAULT 1,
    activo TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_activo_atributo_tipo_activo
        FOREIGN KEY (id_tipo_activo) REFERENCES tipo_activo(id)
);

SELECT * FROM activo_atributo;

CREATE TABLE activo_atributo_valor (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_activo BIGINT NOT NULL,
    id_atributo BIGINT NOT NULL,
    valor_texto TEXT,
    valor_numero INT,
    valor_decimal DECIMAL(10,2),
    valor_fecha DATE,
    valor_booleano TINYINT,
    activo TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_activo_atributo_valor_activo
        FOREIGN KEY (id_activo) REFERENCES activos(id),
    CONSTRAINT fk_activo_atributo_valor_atributo
        FOREIGN KEY (id_atributo) REFERENCES activo_atributo(id)
);

CREATE TABLE tipo_movimiento (
	id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    activo TINYINT DEFAULT 1
);

CREATE TABLE tipo_documento_activo (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    activo TINYINT DEFAULT 1,
    UNIQUE KEY uk_tipo_documento_activo_nombre (nombre)
);

INSERT INTO tipo_documento_activo (nombre, descripcion)
VALUES ('Factura', 'factura de respaldo del equipo');
	
SELECT * FROM tipo_documento_activo;

CREATE TABLE activo_documento (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_activo BIGINT NOT NULL,
    id_tipo_documento BIGINT NOT NULL,
    nombre_archivo VARCHAR(150) NOT NULL,
    nombre_original VARCHAR(255),
    ruta_archivo VARCHAR(255) NOT NULL,
    observaciones TEXT,
    activo TINYINT DEFAULT 1,
    CONSTRAINT fk_activo_documento_activo
        FOREIGN KEY (id_activo) REFERENCES activos(id),
    CONSTRAINT fk_activo_documento_tipo
        FOREIGN KEY (id_tipo_documento) REFERENCES tipo_documento_activo(id)
);

SELECT * FROM activo_documento;

CREATE TABLE activo_asignacion (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_activo BIGINT NOT NULL,
    codigo_empleado BIGINT NOT NULL,
    fecha_asignacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_desasignacion DATETIME NULL,
    condicion_entrega VARCHAR(100),
    condicion_devolucion VARCHAR(100),
    observaciones_asignacion TEXT,
    observaciones_desasignacion TEXT,
    asignacion_activa TINYINT NOT NULL DEFAULT 1,
    id_usuario_asigna BIGINT NULL,
    id_usuario_desasigna BIGINT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_activo_asignacion_activo
        FOREIGN KEY (id_activo) REFERENCES activos(id),
    CONSTRAINT fk_activo_asignacion_usuario_asigna
        FOREIGN KEY (id_usuario_asigna) REFERENCES users(id),
    CONSTRAINT fk_activo_asignacion_usuario_desasigna
        FOREIGN KEY (id_usuario_desasigna) REFERENCES users(id)
);

CREATE TABLE activo_asignacion_foto (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_asignacion BIGINT NOT NULL,
    ruta_archivo VARCHAR(255) NOT NULL,
    activo TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_activo_asignacion_foto
        FOREIGN KEY (id_asignacion) REFERENCES activo_asignacion(id)
);

CREATE TABLE activo_mantenimiento (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_activo BIGINT NOT NULL,
    tipo_mantenimiento  ENUM('PREVENTIVO','CORRECTIVO', 'REPARACION') NOT NULL,
    fecha_mantenimiento DATE NOT NULL,
    descripcion TEXT,
    diagnostico TEXT,
    solucion TEXT,
    costo DECIMAL(10,2),
    proximo_mantenimiento DATE,
    id_usuario_registra BIGINT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_activo_mantenimiento_activo
        FOREIGN KEY (id_activo) REFERENCES activos(id),
    CONSTRAINT fk_activo_mantenimiento_usuario
        FOREIGN KEY (id_usuario_registra) REFERENCES users(id)
);

CREATE TABLE activo_mantenimiento_foto (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_mantenimiento BIGINT NOT NULL,
    ruta_archivo VARCHAR(255) NOT NULL,
    activo TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_activo_mantenimiento_foto
        FOREIGN KEY (id_mantenimiento) REFERENCES activo_mantenimiento(id)
);

CREATE TABLE activo_baja (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_activo BIGINT NOT NULL,
    fecha_baja DATE NOT NULL,
    motivo_baja VARCHAR(150) NOT NULL,
    descripcion TEXT,
    autorizado_por BIGINT,
    archivo_soporte VARCHAR(255),
    id_usuario_registra BIGINT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_activo_baja_activo
        FOREIGN KEY (id_activo) REFERENCES activos(id),
    CONSTRAINT fk_activo_baja_usuario
        FOREIGN KEY (id_usuario_registra) REFERENCES users(id)
);

CREATE TABLE activo_baja_foto (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_baja BIGINT NOT NULL,
    ruta_archivo VARCHAR(255) NOT NULL,
    activo TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_activo_baja_foto
        FOREIGN KEY (id_baja) REFERENCES activo_baja(id)
);