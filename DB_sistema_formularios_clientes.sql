DROP DATABASE IF EXISTS sistema_evaluaciones;

CREATE DATABASE sistema_evaluaciones;

USE sistema_evaluaciones;


-- =====================================================
-- DEPARTAMENTO
-- =====================================================

CREATE TABLE departamento (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    estado TINYINT DEFAULT 1,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
);


-- =====================================================
-- MUNICIPIO
-- =====================================================

CREATE TABLE municipio (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_departamento BIGINT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    estado TINYINT DEFAULT 1,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_municipio_departamento
        FOREIGN KEY (id_departamento) REFERENCES departamento(id)
);


-- =====================================================
-- INDUSTRIA
-- =====================================================

CREATE TABLE industria (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    correo VARCHAR(150),
    descripcion VARCHAR(255),
    estado TINYINT DEFAULT 1,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
);


-- =====================================================
-- CLIENTE
-- =====================================================

CREATE TABLE cliente (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    telefono VARCHAR(30),
    estado TINYINT DEFAULT 1,
    id_industria BIGINT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_cliente_industria
        FOREIGN KEY (id_industria) REFERENCES industria(id)
);


-- =====================================================
-- SUCURSAL
-- =====================================================

CREATE TABLE sucursal (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    id_cliente BIGINT NOT NULL,
    id_municipio BIGINT NOT NULL,
    estado TINYINT DEFAULT 1,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_sucursal_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente(id),
    CONSTRAINT fk_sucursal_municipio
        FOREIGN KEY (id_municipio) REFERENCES municipio(id)
);


-- =====================================================
-- ROL
-- =====================================================

CREATE TABLE rol (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    estado TINYINT DEFAULT 1,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
);


-- =====================================================
-- USUARIOS
-- =====================================================

CREATE TABLE usuarios (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    correo VARCHAR(150) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    estado TINYINT DEFAULT 1,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
);


-- =====================================================
-- USUARIO ROL
-- =====================================================

CREATE TABLE usuario_rol (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_usuario BIGINT NOT NULL,
    id_rol BIGINT NOT NULL,
    estado TINYINT DEFAULT 1,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE (id_usuario, id_rol),
    CONSTRAINT fk_usuario_rol_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuarios(id),
    CONSTRAINT fk_usuario_rol_rol
        FOREIGN KEY (id_rol) REFERENCES rol(id)
);


-- =====================================================
-- TIPO CAMPO
-- =====================================================

CREATE TABLE tipo_campo (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    estado TINYINT DEFAULT 1,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
);


-- =====================================================
-- DEFINICION CAMPO
-- =====================================================

CREATE TABLE definicion_campo (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(100) NOT NULL UNIQUE,
    nombre VARCHAR(150) NOT NULL,
    id_tipo_campo BIGINT NOT NULL,
    estado TINYINT DEFAULT 1,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_definicion_campo_tipo
        FOREIGN KEY (id_tipo_campo) REFERENCES tipo_campo(id)
);


-- =====================================================
-- PLANTILLA FORMULARIO
-- =====================================================

CREATE TABLE plantilla_formulario (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_industria BIGINT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    estatus VARCHAR(50),
    estado TINYINT DEFAULT 1,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_plantilla_industria
        FOREIGN KEY (id_industria) REFERENCES industria(id)
);


-- =====================================================
-- DOCUMENTO FORMULARIO
-- =====================================================

CREATE TABLE documento_formulario (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_plantilla BIGINT NOT NULL,
    codigo VARCHAR(100) NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    descripcion VARCHAR(255),
    orden_visualizacion INT DEFAULT 1,
    estado TINYINT DEFAULT 1,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_documento_plantilla
        FOREIGN KEY (id_plantilla) REFERENCES plantilla_formulario(id)
);


-- =====================================================
-- SECCION FORMULARIO
-- =====================================================

CREATE TABLE seccion_formulario (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_documento BIGINT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    icono VARCHAR(100),
    numero_columnas INT DEFAULT 1,
    orden_visualizacion INT DEFAULT 1,
    estado TINYINT DEFAULT 1,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_seccion_documento
        FOREIGN KEY (id_documento) REFERENCES documento_formulario(id)
);


-- =====================================================
-- CAMPO FORMULARIO
-- =====================================================

CREATE TABLE campo_formulario (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_seccion BIGINT NOT NULL,
    codigo VARCHAR(100) NOT NULL,
    etiqueta VARCHAR(500) NOT NULL,
    texto_ayuda VARCHAR(500),
    texto_guia VARCHAR(255),
    id_definicion_campo BIGINT NOT NULL,
    requerido TINYINT DEFAULT 0,
    valor_minimo DECIMAL(12,2),
    valor_maximo DECIMAL(12,2),
    orden_visualizacion INT DEFAULT 1,
    estado TINYINT DEFAULT 1,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_campo_seccion
        FOREIGN KEY (id_seccion) REFERENCES seccion_formulario(id),
    CONSTRAINT fk_campo_definicion
        FOREIGN KEY (id_definicion_campo) REFERENCES definicion_campo(id)
);


-- =====================================================
-- OPCION FORMULARIO
-- =====================================================

CREATE TABLE opcion_formulario (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_opcion BIGINT,
    codigo VARCHAR(100) NOT NULL,
    valor VARCHAR(255),
    puntaje DECIMAL(10,2),
    etiqueta VARCHAR(255) NOT NULL,
    orden_visualizacion INT DEFAULT 1,
    estado TINYINT DEFAULT 1,
    id_campo_formulario BIGINT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_opcion_campo
        FOREIGN KEY (id_campo_formulario) REFERENCES campo_formulario(id)
);


-- =====================================================
-- TIPO EVENTO
-- =====================================================

CREATE TABLE tipo_evento (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    estado TINYINT DEFAULT 1,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
);


-- =====================================================
-- TIPO ACCION
-- =====================================================

CREATE TABLE tipo_accion (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    estado TINYINT DEFAULT 1,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
);


-- =====================================================
-- EVENTO CAMPO FORMULARIO
-- =====================================================

CREATE TABLE evento_campo_formulario (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_campo_formulario BIGINT NOT NULL,
    id_tipo_evento BIGINT NOT NULL,
    id_tipo_accion BIGINT NOT NULL,
    configuracion_condicion JSON,
    configuracion_accion JSON,
    orden_visualizacion INT DEFAULT 1,
    estado TINYINT DEFAULT 1,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_evento_campo
        FOREIGN KEY (id_campo_formulario) REFERENCES campo_formulario(id),
    CONSTRAINT fk_evento_tipo
        FOREIGN KEY (id_tipo_evento) REFERENCES tipo_evento(id),
    CONSTRAINT fk_evento_accion
        FOREIGN KEY (id_tipo_accion) REFERENCES tipo_accion(id)
);


-- =====================================================
-- EVALUACION
-- =====================================================

CREATE TABLE evaluacion (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_sucursal BIGINT NOT NULL,
    id_plantilla BIGINT NOT NULL,
    id_evaluador BIGINT NOT NULL,
    estatus VARCHAR(50),
    observaciones TEXT,
    puntaje_total DECIMAL(12,2),
    nivel_riesgo VARCHAR(50),
    estado TINYINT DEFAULT 1,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_evaluacion_sucursal
        FOREIGN KEY (id_sucursal) REFERENCES sucursal(id),
    CONSTRAINT fk_evaluacion_plantilla
        FOREIGN KEY (id_plantilla) REFERENCES plantilla_formulario(id),
    CONSTRAINT fk_evaluacion_evaluador
        FOREIGN KEY (id_evaluador) REFERENCES usuarios(id)
);


-- =====================================================
-- RESPUESTA EVALUACION
-- =====================================================

CREATE TABLE respuesta_evaluacion (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_evaluacion BIGINT NOT NULL,
    id_campo BIGINT NOT NULL,
    id_opcion BIGINT,
    valor_texto TEXT,
    valor_numero DECIMAL(12,2),
    valor_booleano TINYINT,
    valor_fecha DATE,
    puntaje DECIMAL(10,2),
    puntaje_ponderado DECIMAL(12,2),
    observacion TEXT,
    estado TINYINT DEFAULT 1,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_respuesta_evaluacion
        FOREIGN KEY (id_evaluacion) REFERENCES evaluacion(id),
    CONSTRAINT fk_respuesta_campo
        FOREIGN KEY (id_campo) REFERENCES campo_formulario(id),
    CONSTRAINT fk_respuesta_opcion
        FOREIGN KEY (id_opcion) REFERENCES opcion_formulario(id)
);