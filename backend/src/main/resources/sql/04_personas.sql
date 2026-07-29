-- =================================================
-- PERSONA
-- =================================================
CREATE TABLE m03.persona (
    id SERIAL PRIMARY KEY,
    tipo_persona m03.tipo_persona,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL
);