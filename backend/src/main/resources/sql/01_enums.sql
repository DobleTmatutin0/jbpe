-- ============================================
-- BASE DE DATOS JBPE - VERSIÓN DESARROLLO
-- Descripción: Script completo para pruebas de desarrollo
-- Autor: BRAIAN
-- ============================================
-- IMPORTANTE: Este es un archivo de desarrollo
-- Al finalizar, separar en archivos individuales(es necesario??)
-- ============================================
CREATE TYPE m03.estado_actual AS ENUM (
    'adquisicion',
    'accesionado',
    'desaccesionado',
    'indefinido'
);

COMMENT ON TYPE m03.estado_actual IS 
'Estado actual del ejemplar en su ciclo de vida dentro de la colección';

-- Tipos de eventos en el ciclo de vida del ejemplar
CREATE TYPE m03.tipo_evento AS ENUM (
    'ingreso',
    'inspeccion',
    'germinacion',
    'enraizamiento',
    'trasplante',
    'accesion',
    'chequeo_anual',
    'cambio_ubicacion',
    'tratamiento',
    'redeterminacion_taxonomica',
    'desaccesion'
);

COMMENT ON TYPE m03.tipo_evento IS 
'Tipos de eventos que pueden ocurrir en el ciclo de vida del ejemplar';

-- Tipo de material/germoplasma
CREATE TYPE m03.tipo_germoplasma AS ENUM (
    'semilla',
    'esqueje',
    'propágulo',
    'plantula',
    'planta',
    'bulbo',
    'espora',
    'otro'
);

COMMENT ON TYPE m03.tipo_germoplasma IS 
'Tipo de material vegetal adquirido';

-- Tipo de persona
CREATE TYPE m03.tipo_persona AS ENUM (
    'interno',
    'externo',
    'cientifico'
    -- 'donador',
    -- 'colector',
    -- 'cientifico',
    -- 'cultivador',
    -- 'otro'
);

COMMENT ON TYPE m03.tipo_persona IS 
'Clasificación del tipo de persona según su rol en el JBPE';

-- Estados de salud del ejemplar para chequeo anual
CREATE TYPE m03.estado_salud_enum AS ENUM (
    'excelente',
    'bueno',
    'regular',
    'malo',
    'critico',
    'muerto',
    'infectado',
    'con_plaga',
    'invasor',
    'desacorde',
    'perdido',
    'otro'
);

COMMENT ON TYPE m03.estado_salud_enum IS 
'Estado general de salud/condición del ejemplar';

-- Razones de desaccesión
CREATE TYPE m03.razon_desaccesion_enum AS ENUM (
    'muerto',
    'plaga_intratable',
    'invasor',
    'intercambio',
    'donacion',
    'irrelevante_para_coleccion',
    'error_identificacion',
    'falta_espacio',
    'perdido',
    'otro'
);

COMMENT ON TYPE m03.razon_desaccesion_enum IS 
'Razón por la cual el ejemplar se retira de la colección';

-- Tipo de sinonimia taxonómica
CREATE TYPE m03.tipo_sinonimia_enum AS ENUM (
    'synonym',
    'accepted',
    'deprecated'
);

COMMENT ON TYPE m03.tipo_sinonimia_enum IS 
'Clasificación del estatus del nombre científico: sinónimo, aceptado o deprecado';

-- Nivel de localización geográfica (para Adjacency List)
CREATE TYPE m03.location_level AS ENUM (
    'country',
    'state/province',
    'county',
    'locality'
);

-- Nivel de sectores
CREATE TYPE m03.sector_level AS ENUM (
    'principal',
    'secundario',
    'terciario'
);

COMMENT ON TYPE m03.location_level IS 
'Nivel jerárquico en la estructura de localizaciones (Adjacency List): país → provincia → localidad';

-- Procedencias
CREATE TYPE m03.procedencias AS ENUM (
    'silvestre',
    'cultivada_a_partir_de_material_silvestre'
);

COMMENT ON TYPE m03.procedencias IS 
'Origen del material vegetal: silvestre o cultivado a partir de material silvestre';

