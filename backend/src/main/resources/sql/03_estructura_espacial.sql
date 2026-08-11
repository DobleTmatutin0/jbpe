-- =================================================
-- SECTOR
-- =================================================
CREATE TABLE m03.sector (
    id SERIAL PRIMARY KEY,
    lvl_sector m03.sector_level,
    parent_id INTEGER,
        CONSTRAINT fk_sector_padre
            FOREIGN KEY(parent_id)
            REFERENCES m03.sector(id),
    nombre VARCHAR(150),

    CONSTRAINT chk_no_self_reference CHECK (id != parent_id)
);

-- =================================================
-- LOCACION
-- =================================================
CREATE TABLE m03.locacion (
    id SERIAL PRIMARY KEY,
    locacion_lvl m03.location_level,
    parent_id INTEGER,
        CONSTRAINT fk_locacion_padre
            FOREIGN KEY (parent_id)
            REFERENCES m03.locacion(id),
    nombre VARCHAR(100),

    CONSTRAINT chk_no_self_reference CHECK (id != parent_id)
);

-- =================================================
-- SITIO RECOLECCION
-- =================================================
CREATE TABLE m03.sitio_recoleccion (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    fecha_recoleccion date NOT NULL,

    latitud NUMERIC(9,6) CHECK (latitud BETWEEN -90 AND 90),
    longitud NUMERIC(9,6) CHECK (longitud BETWEEN -180 AND 180),
    altitud NUMERIC(6,2) CHECK (altitud BETWEEN -500 AND 9000),

    locacion_id INTEGER NOT NULL,
        CONSTRAINT fk_sitio_recoleccion_a_locacion
            FOREIGN KEY(locacion_id)
            REFERENCES m03.locacion(id),
    descripcion TEXT
);
