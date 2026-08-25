-- =================================================
-- EVENTO
-- =================================================
CREATE TABLE m03.evento (
    id BIGSERIAL PRIMARY KEY,
    tipo_evento m03.tipo_evento NOT NULL,
    fecha date NOT NULL,
    realizado_por INTEGER NOT NULL,
        CONSTRAINT fk_realizado_por_persona
            FOREIGN KEY(realizado_por)
            REFERENCES m03.persona(id),
    ejemplar_id INTEGER NOT NULL,
        CONSTRAINT fk_ejemplar_asociada_al_evento
            FOREIGN KEY(ejemplar_id)
            REFERENCES m03.ejemplar(id),
    observaciones TEXT
);

CREATE TABLE m03.evento_ingreso (
    id SERIAL PRIMARY KEY,
    event_id INTEGER UNIQUE NOT NULL,
        CONSTRAINT fk_evento_base_transplante
            FOREIGN KEY(event_id)
            REFERENCES m03.evento(id),
    fecha_donacion date,
    donado_por INTEGER,
        CONSTRAINT fk_evento_ingreso_donador_adquisicion
            FOREIGN KEY(donado_por)
            REFERENCES m03.persona(id)
);

CREATE TABLE m03.evento_transplante (
    id SERIAL PRIMARY KEY,
    event_id INTEGER UNIQUE NOT NULL,
        CONSTRAINT fk_evento_base_transplante
            FOREIGN KEY(event_id)
            REFERENCES m03.evento(id),
    sector_inicial INTEGER NOT NULL,
        CONSTRAINT fk_sector_primer_transplante
            FOREIGN KEY(sector_inicial)
            REFERENCES m03.sector(id),
    transplantador_por_id INTEGER NOT NULL,
        CONSTRAINT fk_persona_transplante
            FOREIGN KEY(transplantador_por_id)
            REFERENCES m03.persona(id),
    como_fue_plantado_en_predio TEXT -- CAMBIAR
);

-- VA O NO VA?
/*
CREATE TABLE m03.accesion (
    id SERIAL PRIMARY KEY,
    event_id INTEGER NOT NULL
        CONSTRAINT fk_evento_base_accecion
            FOREIGN KEY(event_id)
            REFERENCES m03.evento(id)
);
*/

CREATE TABLE m03.evento_desaccesion (
    id SERIAL PRIMARY KEY,
    event_id INTEGER UNIQUE NOT NULL,
        CONSTRAINT fk_evento_base_desaccesion
            FOREIGN KEY(event_id)
            REFERENCES m03.evento(id),
    motivo m03.razon_desaccesion_enum NOT NULL
);


CREATE TABLE m03.evento_chequeo_anual (
    id SERIAL PRIMARY KEY,
    event_id INTEGER UNIQUE NOT NULL,
        CONSTRAINT fk_evento_base_chequeo_anual
            FOREIGN KEY(event_id)
            REFERENCES m03.evento(id),
    altura_cm NUMERIC(6,3),
    diametro_cm NUMERIC(6,3),
    estado_de_salud m03.estado_salud_enum,
    florecio boolean,
    fructifico boolean
);

COMMENT ON COLUMN m03.evento_chequeo_anual.altura_cm
IS 'Altura de la planta medida en centímetros (valor max 999.999 cm)';



CREATE TABLE m03.evento_determinar_taxon (
    id SERIAL PRIMARY KEY,
    event_id INTEGER UNIQUE NOT NULL,
        CONSTRAINT fk_evento_base_determinar_taxon
            FOREIGN KEY(event_id)
            REFERENCES m03.evento(id),
    taxon_viejo INTEGER,
        CONSTRAINT fk_taxon_viejo
            FOREIGN KEY(taxon_viejo)
            REFERENCES m03.nombre_especie(id),
    taxon_nuevo INTEGER NOT NULL,
        CONSTRAINT fk_taxon_nuevo
            FOREIGN KEY(taxon_nuevo)
            REFERENCES m03.nombre_especie(id)
);



--*************************************************************************
-- unicidad por indices (partinal index)
--*************************************************************************

CREATE UNIQUE INDEX unq_evento_ingreso_por_ejemplar
ON m03.evento (ejemplar_id)
WHERE tipo_evento = 'ingreso';

CREATE UNIQUE INDEX unq_evento_trasplante_por_ejemplar
ON m03.evento (ejemplar_id)
WHERE tipo_evento = 'trasplante';

CREATE UNIQUE INDEX unq_evento_accesion_por_ejemplar
ON m03.evento (ejemplar_id)
WHERE tipo_evento = 'accesion';
