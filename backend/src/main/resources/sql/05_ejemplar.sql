-- =================================================
-- SECUENCIA
-- =================================================
CREATE SEQUENCE m03.adquisicion_seq;

CREATE SEQUENCE m03.accesion_seq;

-- =================================================
-- EJEMPLAR
-- =================================================
CREATE TABLE m03.ejemplar (
    id BIGSERIAL PRIMARY KEY,
    adquisicion_id TEXT UNIQUE
        CONSTRAINT adquisicion_id_formato_check
            CHECK(adquisicion_id ~ '^A-[0-9]+$'),
    marca_temporal TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    taxon_actual_id INTEGER,
        CONSTRAINT fk_ejemplar_taxon_id
            FOREIGN KEY(taxon_actual_id)
            REFERENCES m03.nombre_especie(id),
    recolectado_por INTEGER NOT  NULL
        CONSTRAINT fk_ejemplar_recolectado_por
        FOREIGN KEY(recolectado_por)
        REFERENCES m03.persona(id),
    fecha_recoleccion DATE NOT  NULL,
    sitio_recoleccion_id INTEGER NOT NULL
        CONSTRAINT fk_ejemplar_a_sitio_recoleccion
        FOREIGN KEY(sitio_recoleccion_id)
        REFERENCES m03.sitio_recoleccion(id),
 --   detalle_material_ingresado TEXT,
    procedencia m03.procedencias,
 --   material_adicional TEXT, -- VER
    estado m03.estado_actual DEFAULT 'indefinido',
    observaciones TEXT,

    sector_actual_id INTEGER,
        CONSTRAINT fk_ejemplar_sector
            FOREIGN KEY(sector_actual_id)
            REFERENCES m03.sector(id),

    accesion_id INTEGER,
    nombre_original TEXT,
    nombre_actual TEXT,
    nombre_vulgar TEXT
);

-- =================================================
-- GERMOPLASMA COLECTADO
-- =================================================
CREATE TABLE m03.germoplasma_colectado (
    id BIGSERIAL PRIMARY KEY,
    adquisicion_id BIGSERIAL NOT NULL,
        CONSTRAINT fk_germoplasma_a_ejemplar
        FOREIGN KEY (adquisicion_id)
        REFERENCES m03.ejemplar(id),
    tipo_germoplasma m03.tipo_germoplasma NOT NULL
);

-- =================================================
-- INDICES
-- =================================================
