-- ================================================
-- BASE DE DATOS JBEP - VERSION DESARROLLO
-- Descripcion:
-- Autor: 
-- ================================================

BEGIN;

-- =================================================
-- TAXON
-- =================================================

CREATE TABLE m03.orden (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(150) UNIQUE NOT NULL,
    link_flora_arg TEXT CHECK(link_flora_arg ~* '^https?://')
);

CREATE TABLE m03.familia (
    id SERIAL PRIMARY KEY,
    orden_id INTEGER NOT NULL,
    nombre VARCHAR(150) UNIQUE NOT NULL,
    link_flora_arg TEXT CHECK(link_flora_arg ~* '^https?://'),
    CONSTRAINT fk_familia_orden
        FOREIGN KEY(orden_id) REFERENCES m03.orden(id)
);

CREATE TABLE m03.genero (
    id SERIAL PRIMARY KEY,
    familia_id INTEGER NOT NULL,
    CONSTRAINT fk_genero_familia
        FOREIGN KEY(familia_id) REFERENCES m03.familia(id),
    nombre VARCHAR(150) UNIQUE NOT NULL,
    link_flora_arg TEXT CHECK(link_flora_arg ~* '^https?://')
);

CREATE TABLE m03.detalle_especie (
    id SERIAL PRIMARY KEY,
    nombre_especie_aceptado VARCHAR(200) UNIQUE NOT NULL,
    genero_id INTEGER NOT NULL,
        CONSTRAINT fk_detalle_especie_a_genero
            FOREIGN KEY(genero_id)
            REFERENCES m03.genero(id),
    link_flora_arg TEXT CHECK(link_flora_arg ~* '^https?://'),
    habito TEXT, --MODIFICAR
    bibliografia TEXT, --MODIFICAR
    descripcion TEXT
);

CREATE TABLE m03.nombre_especie (
    id SERIAL PRIMARY KEY,
    detalle_id INTEGER NOT NULL,
        CONSTRAINT fk_nombre_especie_a_detalle_especie
            FOREIGN KEY(detalle_id)
            REFERENCES m03.detalle_especie(id),
    nombre VARCHAR(200) UNIQUE NOT NULL,
    link_flora_arg TEXT CHECK(link_flora_arg ~* '^https?://'),
    tipo_nombre m03.tipo_sinonimia_enum DEFAULT 'accepted'
);


-- Indices Taxonomia
CREATE INDEX idx_familia_orden ON m03.familia(orden_id);
CREATE INDEX idx_genero_familia ON m03.genero(familia_id);
CREATE INDEX idx_nombre_especie_a_detalle ON m03.nombre_especie(detalle_id);
CREATE INDEX idx_detalle_especie_nombre_aceptado ON m03.detalle_especie(nombre_especie_aceptado);
CREATE INDEX idx_nombre_especie_sinonimia ON m03.nombre_especie(tipo_nombre);

CREATE UNIQUE INDEX unq_accepted_por_detalle
    ON m03.nombre_especie (detalle_id)
    WHERE tipo_nombre = 'accepted';