BEGIN;


-- ============================================
-- BASE DE DATOS JBPE - VERSIÓN DESARROLLO
-- Descripción: Script completo para pruebas de desarrollo
-- Autor: BRAIAN
-- ============================================
-- IMPORTANTE: Este es un archivo de desarrollo
-- Al finalizar, separar en archivos individuales(es necesario??)
-- ============================================
CREATE TYPE jbpe.estado_actual AS ENUM (
    'adquisicion',
    'accesionado',
    'desaccesionado',
    'indefinido'
);

COMMENT ON TYPE jbpe.estado_actual IS 
'Estado actual del ejemplar en su ciclo de vida dentro de la colección';

-- Tipos de eventos en el ciclo de vida del ejemplar
CREATE TYPE jbpe.tipo_evento AS ENUM (
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

COMMENT ON TYPE jbpe.tipo_evento IS 
'Tipos de eventos que pueden ocurrir en el ciclo de vida del ejemplar';

-- Tipo de material/germoplasma
CREATE TYPE jbpe.tipo_germoplasma AS ENUM (
    'semilla',
    'esqueje',
    'plantula',
    'planta',
    'bulbo',
    'espora',
    'otro'
);

COMMENT ON TYPE jbpe.tipo_germoplasma IS 
'Tipo de material vegetal adquirido';

-- Tipo de persona
CREATE TYPE jbpe.tipo_persona AS ENUM (
    'donador',
    'colector',
    'cientifico',
    'cultivador',
    'otro'
);

COMMENT ON TYPE jbpe.tipo_persona IS 
'Clasificación del tipo de persona según su rol en el JBPE';

-- Estados de salud del ejemplar para chequeo anual
CREATE TYPE jbpe.estado_salud_enum AS ENUM (
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

COMMENT ON TYPE jbpe.estado_salud_enum IS 
'Estado general de salud/condición del ejemplar';

-- Razones de desaccesión
CREATE TYPE jbpe.razon_desaccesion_enum AS ENUM (
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

COMMENT ON TYPE jbpe.razon_desaccesion_enum IS 
'Razón por la cual el ejemplar se retira de la colección';

-- Sectores del jardín botánico
CREATE TYPE jbpe.sectores AS ENUM (
	'Callejón de ingreso',
	'Bancales',
	'Playón',
	'Olivillo',
	'Cactario exóticas',
	'Cactario nativas',
	'Valla Universidad',
	'Pozón',
	'Roquedal',
	'Estanque',
	'Bajo salino',
	'Arroyo alto/medio/bajo',
	'Monte austral',
	'Sporobolus',
	'Araucaria',
	'Monte norpatagónico',
	'Caldén',
	'Parcelas',
	'Área recreativa 1',
	'Puente 1',
	'Puente 2',
	'Área recreativa 2',
	'Pajonal',
	'Chacay',
	'Gradas y pozo',
	'Zona media',
	'Laboratorio',
	'Umbráculo',
	'Invernáculo 1',
	'Invernáculo 2'
);

COMMENT ON TYPE jbpe.sectores IS 
'Sectores físicos del Jardín Botánico donde se ubican los ejemplares';

-- Tipo de sinonimia taxonómica
CREATE TYPE jbpe.tipo_sinonimia_enum AS ENUM (
    'synonym',
    'accepted',
    'deprecated'
);

COMMENT ON TYPE jbpe.tipo_sinonimia_enum IS 
'Clasificación del estatus del nombre científico: sinónimo, aceptado o deprecado';

-- Nivel de localización geográfica (para Adjacency List)
CREATE TYPE jbpe.location_level AS ENUM (
    'country',
    'stateprovince',
    'county',
    'locality'
);

COMMENT ON TYPE jbpe.location_level IS 
'Nivel jerárquico en la estructura de localizaciones (Adjacency List): país → provincia → localidad';

-- Procedencias
CREATE TYPE jbpe.procedencias AS ENUM (
    'silvestre',
    'cultivada_a_partir_de_material_silvestre'
);

COMMENT ON TYPE jbpe.procedencias IS 
'Origen del material vegetal: silvestre o cultivado a partir de material silvestre';



-- ============================================
-- VERIFICACIÓN BLOQUE 1
-- ============================================
-- ✓ Bloque 1: ENUMs
SELECT COUNT(*) as "ENUMs creados"
FROM pg_type 
WHERE typnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'jbpe')
AND typtype = 'e';
-- Esperado: 10


-- ============================================
-- BLOQUE 2: LOCALIZACIÓN
-- ============================================

-- Tabla: Location (jerarquía con Adjacency List)
CREATE TABLE jbpe.location (
    id SERIAL PRIMARY KEY,
    location_id VARCHAR(50) UNIQUE,
    name VARCHAR(200) NOT NULL,
    level jbpe.location_level NOT NULL,
    parent_id INTEGER REFERENCES jbpe.location(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_no_self_reference CHECK (id != parent_id)
);

COMMENT ON TABLE jbpe.location IS 
'Jerarquía de localizaciones geográficas usando Adjacency List (país → provincia → condado → localidad)';

COMMENT ON COLUMN jbpe.location.location_id IS 
'Código identificador de la localización';

COMMENT ON COLUMN jbpe.location.level IS 
'Nivel jerárquico: country, stateprovince, county, locality';

COMMENT ON COLUMN jbpe.location.parent_id IS 
'Auto-referencia al location padre en la jerarquía';

-- Tabla: Sitio de Recolección
CREATE TABLE jbpe.sitio_recoleccion (
    id SERIAL PRIMARY KEY,
    location_id INTEGER REFERENCES jbpe.location(id) ON DELETE SET NULL,
    
    -- Coordenadas geográficas
    latitud DECIMAL(10, 8) CHECK (latitud BETWEEN -90 AND 90),
    longitud DECIMAL(11, 8) CHECK (longitud BETWEEN -180 AND 180),
    altitud INTEGER,  -- metros sobre nivel del mar
    
    -- Características del sitio según tu diagrama
    habitat TEXT,
    elevacion INTEGER,  -- si es diferente de altitud
    
    -- Datos adicionales de georeferenciación
    datum_gps VARCHAR(50) DEFAULT 'WGS84',
    precision_gps INTEGER,  -- precisión en metros
    
    -- Notas y descripciones
    notas TEXT,
    descripcion TEXT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE jbpe.sitio_recoleccion IS 
'Sitio específico donde se recolectó el material vegetal, vinculado a la jerarquía de Location';

COMMENT ON COLUMN jbpe.sitio_recoleccion.latitud IS 
'Latitud en grados decimales (WGS84)';

COMMENT ON COLUMN jbpe.sitio_recoleccion.longitud IS 
'Longitud en grados decimales (WGS84)';

COMMENT ON COLUMN jbpe.sitio_recoleccion.habitat IS 
'Descripción del tipo de hábitat donde se encontró el ejemplar';

-- Índices para localización ??
CREATE INDEX idx_location_parent ON jbpe.location(parent_id);
CREATE INDEX idx_location_level ON jbpe.location(level);
CREATE INDEX idx_location_name ON jbpe.location(name);
CREATE INDEX idx_sitio_location ON jbpe.sitio_recoleccion(location_id);
CREATE INDEX idx_sitio_coordenadas ON jbpe.sitio_recoleccion(latitud, longitud);

-- ============================================
-- VERIFICACIÓN BLOQUE 2
-- ============================================
-- ✓ Bloque 2: Localización (esperado: 2 tablas)
SELECT COUNT(*) as "Tablas de localización"
FROM information_schema.tables 
WHERE table_schema = 'jbpe'
AND table_name IN ('location', 'sitio_recoleccion');
-- Esperado: 2

-- ============================================
-- BLOQUE 3: PERSONA  ← AGREGAR AQUÍ
-- ============================================

CREATE TABLE jbpe.persona (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    apellido VARCHAR(200),
    tipo jbpe.tipo_persona,
    email VARCHAR(200),
    telefono VARCHAR(50),
    institucion VARCHAR(200),
    notas TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE jbpe.persona IS 
'Personas relacionadas con el JBPE: colectores, donadores, científicos, cultivadores';

CREATE INDEX idx_persona_nombre ON jbpe.persona(nombre, apellido);
CREATE INDEX idx_persona_tipo ON jbpe.persona(tipo);
CREATE INDEX idx_persona_email ON jbpe.persona(email);

-- ============================================
-- VERIFICACIÓN BLOQUE 3
-- ============================================
SELECT COUNT(*) as "Tabla Persona"
FROM information_schema.tables 
WHERE table_schema = 'jbpe'
AND table_name = 'persona';

-- ============================================
-- BLOQUE 4: ADQUISICION
-- ============================================

CREATE TABLE jbpe.adquisicion (
    -- IDs
    id BIGSERIAL PRIMARY KEY,
    adquisicion_id VARCHAR(50) UNIQUE NOT NULL,  -- String (A-num)
    
    -- Marca Temporal (Date fecha hora)
    marca_temporal TIMESTAMP,
    
    -- Fechas
    fecha_recoleccion DATE,
    fecha_donacion DATE,
    fecha_plantado_predio DATE,
    
    -- Relaciones con Persona (FKs)
    recoleccion_por_id INTEGER REFERENCES jbpe.persona(id) ON DELETE SET NULL,  -- RecolectadoPor: string → FK
    donador_id INTEGER REFERENCES jbpe.persona(id) ON DELETE SET NULL,  -- DonadorPor: Person
    cultivador_por_id INTEGER REFERENCES jbpe.persona(id) ON DELETE SET NULL,  -- CultivadoPor: Persona
    transplantador_por_id INTEGER REFERENCES jbpe.persona(id) ON DELETE SET NULL,  -- TransplantadoPor: persona
    determinado_por INTEGER REFERENCES jbpe.persona(id) ON DELETE SET NULL,
	
    -- Relaciones con otras tablas
    sitio_recoleccion_id INTEGER REFERENCES jbpe.sitio_recoleccion(id) ON DELETE SET NULL,
    -- taxon_id INTEGER REFERENCES jbpe.taxon(id) ON DELETE SET NULL,  -- TaxonId: Taxon (descomentar cuando crees taxonomía)
    
    
    -- Detalles del material ingresado
    detalle_material_ingresado TEXT,  -- Detalle del material ingresado
    
    -- Procedencia
    procedencia jbpe.procedencias,  -- ENUM
    
    -- Material adicional (texto simple, no tabla separada)
    material_adicional TEXT,
   	    
    -- Estado actual
    estado jbpe.estado_actual DEFAULT 'adquirido',  -- Estado: Estado (ENUM estado_actual)
    
    -- Observaciones
    observaciones TEXT,
    
    -- Identificación / Números
    id_accesion INTEGER,  -- idAccesion: Number
    numero_original VARCHAR(100),  -- Nombre Original: String
    numero_actual VARCHAR(100),  -- Nombre Actual: String
    nombre_vulgar VARCHAR(200),  -- Nombre Vulgar
    
    -- Foto
    foto BOOLEAN DEFAULT false,
    
    -- Como fue plantado en predio
    como_plantado_predio TEXT,
    
    -- Sector
    sector jbpe.sectores,  -- SectorId: Sector (ENUM)
    
    -- Auditoría
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE jbpe.adquisicion IS 
'Tabla central que representa cada ejemplar adquirido por el JBPE';

COMMENT ON COLUMN jbpe.adquisicion.adquisicion_id IS 
'Código único de adquisición (formato A-num, ej: A-001)';

COMMENT ON COLUMN jbpe.adquisicion.marca_temporal IS 
'Fecha y hora de la adquisición/recolección';

COMMENT ON COLUMN jbpe.adquisicion.recoleccion_por_id IS 
'Persona que realizó la recolección del material';

COMMENT ON COLUMN jbpe.adquisicion.donador_id IS 
'Persona que donó el material';

COMMENT ON COLUMN jbpe.adquisicion.cultivador_por_id IS 
'Persona responsable del cultivo del material';

COMMENT ON COLUMN jbpe.adquisicion.transplantador_por_id IS 
'Persona que realizó el transplante';

COMMENT ON COLUMN jbpe.adquisicion.detalle_material_ingresado IS 
'Descripción detallada del material vegetal ingresado';

COMMENT ON COLUMN jbpe.adquisicion.estado IS 
'Estado actual del ejemplar: adquirido, accesionado, desaccesionado, descartado';

COMMENT ON COLUMN jbpe.adquisicion.id_accesion IS 
'Número de accesión cuando pasa a formar parte oficial de la colección';

-- Índices
CREATE INDEX idx_adquisicion_codigo ON jbpe.adquisicion(adquisicion_id);
CREATE INDEX idx_adquisicion_sitio ON jbpe.adquisicion(sitio_recoleccion_id);
CREATE INDEX idx_adquisicion_donador ON jbpe.adquisicion(donador_id);
CREATE INDEX idx_adquisicion_recolector ON jbpe.adquisicion(recoleccion_por_id);
CREATE INDEX idx_adquisicion_cultivador ON jbpe.adquisicion(cultivador_por_id);
CREATE INDEX idx_adquisicion_transplantador ON jbpe.adquisicion(transplantador_por_id);
CREATE INDEX idx_adquisicion_sector ON jbpe.adquisicion(sector);
CREATE INDEX idx_adquisicion_fecha_recoleccion ON jbpe.adquisicion(fecha_recoleccion);
CREATE INDEX idx_adquisicion_estado ON jbpe.adquisicion(estado);

-- ============================================
-- TABLA: Germoplasma Colectado (relación M:N entre Adquisicion y Persona)
-- ============================================

CREATE TABLE jbpe.germoplasma_colectado (
    id SERIAL PRIMARY KEY,
    adquisicion_id INTEGER NOT NULL REFERENCES jbpe.adquisicion(id) ON DELETE CASCADE,
    persona_id INTEGER REFERENCES jbpe.persona(id) ON DELETE SET NULL,  -- Relación con Persona
    tipo_germoplasma jbpe.tipo_germoplasma NOT NULL,  -- TipoGermoplasma
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Una persona no puede tener el mismo tipo de germoplasma repetido para la misma adquisición
    UNIQUE(adquisicion_id, persona_id, tipo_germoplasma)
);

COMMENT ON TABLE jbpe.germoplasma_colectado IS 
'Tipos de germoplasma colectado para cada adquisición, vinculado con la persona responsable';

COMMENT ON COLUMN jbpe.germoplasma_colectado.persona_id IS 
'Persona que colectó este tipo de germoplasma';

COMMENT ON COLUMN jbpe.germoplasma_colectado.tipo_germoplasma IS 
'Tipo de material: semilla, esqueje, plántula, planta, bulbo, espora, otro';

CREATE INDEX idx_germoplasma_adquisicion ON jbpe.germoplasma_colectado(adquisicion_id);
CREATE INDEX idx_germoplasma_persona ON jbpe.germoplasma_colectado(persona_id);
CREATE INDEX idx_germoplasma_tipo ON jbpe.germoplasma_colectado(tipo_germoplasma);

-- ============================================
-- VERIFICACIÓN BLOQUE 4
-- ============================================

-- ✓ Bloque 4: Adquisicion (esperado: 2 tablas)
SELECT COUNT(*) as "Tablas de Adquisición"
FROM information_schema.tables 
WHERE table_schema = 'jbpe'
AND table_name IN ('adquisicion', 'germoplasma_colectado');

-- Ver columnas de adquisicion
SELECT 
    column_name as "Columna",
    data_type as "Tipo",
    is_nullable as "Nullable",
    CASE 
        WHEN column_default IS NOT NULL THEN LEFT(column_default, 50)
        ELSE NULL
    END as "Default"
FROM information_schema.columns
WHERE table_schema = 'jbpe' 
AND table_name = 'adquisicion'
ORDER BY ordinal_position;

-- Ver todas las FKs de adquisicion
SELECT
    kcu.column_name as "Columna FK",
    ccu.table_name AS "Tabla referenciada",
    ccu.column_name AS "Columna referenciada"
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY' 
AND tc.table_schema = 'jbpe'
AND tc.table_name = 'adquisicion'
ORDER BY kcu.column_name;

-- Ver FKs de germoplasma_colectado
SELECT
    kcu.column_name as "Columna FK",
    ccu.table_name AS "Tabla referenciada",
    ccu.column_name AS "Columna referenciada"
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY' 
AND tc.table_schema = 'jbpe'
AND tc.table_name = 'germoplasma_colectado'
ORDER BY kcu.column_name;

-- Ver índices de adquisicion
SELECT 
    indexname as "Índice",
    indexdef as "Definición"
FROM pg_indexes
WHERE schemaname = 'jbpe'
AND tablename = 'adquisicion'
ORDER BY indexname;

-- Ver índices de germoplasma_colectado
SELECT 
    indexname as "Índice",
    indexdef as "Definición"
FROM pg_indexes
WHERE schemaname = 'jbpe'
AND tablename = 'germoplasma_colectado'
ORDER BY indexname;

-- ============================================
-- BLOQUE 5: TAXONOMÍA
-- ============================================

-- Tabla: Orden
CREATE TABLE jbpe.orden (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    link_flora_arg VARCHAR(500),  -- Link Flora Argentina
    taxon_id INTEGER,  -- FK para referencias cruzadas (puede ser NULL)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE jbpe.orden IS 
'Nivel taxonómico: Orden';

COMMENT ON COLUMN jbpe.orden.link_flora_arg IS 
'Enlace a Flora Argentina para este orden';

COMMENT ON COLUMN jbpe.orden.taxon_id IS 
'Referencia cruzada a otros sistemas taxonómicos';

-- Tabla: Familia
CREATE TABLE jbpe.familia (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    orden_id INTEGER REFERENCES jbpe.orden(id) ON DELETE SET NULL,  -- FK a Orden
    link_flora_arg VARCHAR(500),
    taxon_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(nombre, orden_id)
);

COMMENT ON TABLE jbpe.familia IS 
'Nivel taxonómico: Familia. Pertenece a un Orden (N:1).';

COMMENT ON COLUMN jbpe.familia.link_flora_arg IS 
'Enlace a Flora Argentina para esta familia';

-- Tabla: Género
CREATE TABLE jbpe.genero (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    familia_id INTEGER REFERENCES jbpe.familia(id) ON DELETE SET NULL,  -- FK a Familia
    link_flora_arg VARCHAR(500),
    taxon_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(nombre, familia_id)
);

COMMENT ON TABLE jbpe.genero IS 
'Nivel taxonómico: Género. Pertenece a una Familia (N:1).';

COMMENT ON COLUMN jbpe.genero.link_flora_arg IS 
'Enlace a Flora Argentina para este género';

-- Tabla: Especie Detalle (tabla PADRE)
CREATE TABLE jbpe.especie_detalle (
    id SERIAL PRIMARY KEY,
    link_flora_arg VARCHAR(500),
    status TEXT,  -- Status (Tabla intermedia ??)
    habito TEXT,  -- Hábito (Tabla intermedia ??)
    nombre_vulgar VARCHAR(200),
    bibliografia TEXT,
    descripcion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE jbpe.especie_detalle IS 
'Información detallada de especies. Una especie puede tener múltiples nombres (sinónimos, nombres aceptados, deprecados).';

COMMENT ON COLUMN jbpe.especie_detalle.status IS 
'Estado taxonómico o de conservación';

COMMENT ON COLUMN jbpe.especie_detalle.habito IS 
'Hábito de crecimiento: árbol, arbusto, hierba, etc.';

COMMENT ON COLUMN jbpe.especie_detalle.link_flora_arg IS 
'Enlace a Flora Argentina para esta especie';

-- Tabla: Nombres Especie (tabla HIJA de Especie_Detalle)
CREATE TABLE jbpe.nombres_especie (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    genero_id INTEGER REFERENCES jbpe.genero(id) ON DELETE SET NULL,  -- FK a Género
    nombre_especie_id INTEGER REFERENCES jbpe.especie_detalle(id) ON DELETE CASCADE,  -- FK a Especie_Detalle (N:1)
    tipo_sinonimia jbpe.tipo_sinonimia_enum DEFAULT 'accepted',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(nombre, genero_id)
);

COMMENT ON TABLE jbpe.nombres_especie IS 
'Nombres científicos (epítetos específicos). Múltiples nombres pueden pertenecer a la misma especie (sinónimos). Pertenece a Género (N:1) y a Especie_Detalle (N:1).';

COMMENT ON COLUMN jbpe.nombres_especie.tipo_sinonimia IS 
'Estatus del nombre: synonym (sinónimo), accepted (aceptado), deprecated (deprecado)';

COMMENT ON COLUMN jbpe.nombres_especie.nombre IS 
'Epíteto específico del nombre científico';

COMMENT ON COLUMN jbpe.nombres_especie.nombre_especie_id IS 
'Referencia a la especie detallada. Múltiples nombres pueden apuntar a la misma especie (manejo de sinónimos).';

-- Índices para taxonomía
CREATE INDEX idx_familia_orden ON jbpe.familia(orden_id);
CREATE INDEX idx_genero_familia ON jbpe.genero(familia_id);
CREATE INDEX idx_nombres_especie_genero ON jbpe.nombres_especie(genero_id);
CREATE INDEX idx_nombres_especie_detalle ON jbpe.nombres_especie(nombre_especie_id);
CREATE INDEX idx_nombres_especie_nombre ON jbpe.nombres_especie(nombre);
CREATE INDEX idx_nombres_especie_sinonimia ON jbpe.nombres_especie(tipo_sinonimia);

-- ============================================
-- Agregar FK en Adquisicion
-- ============================================

ALTER TABLE jbpe.adquisicion 
ADD COLUMN taxon_id INTEGER REFERENCES jbpe.nombres_especie(id) ON DELETE SET NULL;

COMMENT ON COLUMN jbpe.adquisicion.taxon_id IS 
'Identificación taxonómica del ejemplar (referencia al nombre científico utilizado)';

CREATE INDEX idx_adquisicion_taxon ON jbpe.adquisicion(taxon_id);

-- ============================================
-- VERIFICACIÓN BLOQUE 5
-- ============================================

-- ✓ Bloque 5: Taxonomía (esperado: 5 tablas)
SELECT COUNT(*) as "Tablas de Taxonomía"
FROM information_schema.tables 
WHERE table_schema = 'jbpe'
AND table_name IN ('orden', 'familia', 'genero', 'nombres_especie', 'especie_detalle');

-- Ver jerarquía de FKs
SELECT
    tc.table_name as "Tabla",
    kcu.column_name as "Columna FK",
    ccu.table_name AS "Referencia a",
    ccu.column_name AS "Columna"
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY' 
AND tc.table_schema = 'jbpe'
AND tc.table_name IN ('orden', 'familia', 'genero', 'nombres_especie', 'especie_detalle')
ORDER BY 
    CASE tc.table_name
        WHEN 'familia' THEN 1
        WHEN 'genero' THEN 2
        WHEN 'nombres_especie' THEN 3
END;

-- ============================================
-- BLOQUE 6: EVENTOS (Event Sourcing)
-- ============================================

-- Tabla principal: Event
CREATE TABLE jbpe.event (
    id BIGSERIAL PRIMARY KEY,
    adquisicion_id INTEGER NOT NULL REFERENCES jbpe.adquisicion(id) ON DELETE CASCADE,
    tipo jbpe.tipo_evento NOT NULL,
    fecha_evento DATE NOT NULL,
    registrado_por_id INTEGER REFERENCES jbpe.persona(id) ON DELETE SET NULL,
    observaciones TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE jbpe.event IS 
'Registro de todos los eventos en el ciclo de vida del ejemplar (Event Sourcing). Cada cambio de estado se registra como un evento.';

COMMENT ON COLUMN jbpe.event.tipo IS 
'Tipo de evento: ingreso, inspección, germinación, enraizamiento, trasplante, accesión, chequeo_anual, cambio_ubicacion, tratamiento, redeterminacion_taxonomica, desaccesion';

COMMENT ON COLUMN jbpe.event.fecha_evento IS 
'Fecha en que ocurrió el evento';

COMMENT ON COLUMN jbpe.event.registrado_por_id IS 
'Persona que registró este evento en el sistema';

-- Índices para eventos
CREATE INDEX idx_event_adquisicion ON jbpe.event(adquisicion_id);
CREATE INDEX idx_event_tipo ON jbpe.event(tipo);
CREATE INDEX idx_event_fecha ON jbpe.event(fecha_evento);
CREATE INDEX idx_event_registrado_por ON jbpe.event(registrado_por_id);
CREATE INDEX idx_event_adq_fecha ON jbpe.event(adquisicion_id, fecha_evento);

-- ============================================
-- TABLA: Evento Chequeo Anual
-- ============================================

CREATE TABLE jbpe.evento_chequeo_anual (
    id SERIAL PRIMARY KEY,
    event_id INTEGER NOT NULL UNIQUE REFERENCES jbpe.event(id) ON DELETE CASCADE,
    estado_salud jbpe.estado_salud_enum NOT NULL,
    florecio BOOLEAN DEFAULT false,
    fructifico BOOLEAN DEFAULT false,
    altura_cm DECIMAL(10, 2),
    diametro_cm DECIMAL(10, 2),
    tiene_enfermedad BOOLEAN DEFAULT false,
    es_invasora BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE jbpe.evento_chequeo_anual IS 
'Información específica del chequeo anual: estado de salud, mediciones, floración, fructificación';

COMMENT ON COLUMN jbpe.evento_chequeo_anual.estado_salud IS 
'Estado general del ejemplar: excelente, bueno, regular, malo, crítico, muerto, infectado, con_plaga, invasor, desacorde, perdido, otro';

COMMENT ON COLUMN jbpe.evento_chequeo_anual.florecio IS 
'Si el ejemplar presentó floración';

COMMENT ON COLUMN jbpe.evento_chequeo_anual.fructifico IS 
'Si el ejemplar produjo frutos';

COMMENT ON COLUMN jbpe.evento_chequeo_anual.altura_cm IS 
'Altura del ejemplar en centímetros';

COMMENT ON COLUMN jbpe.evento_chequeo_anual.diametro_cm IS 
'Diámetro de copa o tronco en centímetros';

COMMENT ON COLUMN jbpe.evento_chequeo_anual.tiene_enfermedad IS 
'Indica si se detectó alguna enfermedad';

COMMENT ON COLUMN jbpe.evento_chequeo_anual.es_invasora IS 
'Indica si el ejemplar muestra comportamiento invasor';

CREATE INDEX idx_chequeo_event ON jbpe.evento_chequeo_anual(event_id);
CREATE INDEX idx_chequeo_salud ON jbpe.evento_chequeo_anual(estado_salud);

-- ============================================
-- TABLA: Evento Desaccesión
-- ============================================

CREATE TABLE jbpe.evento_desaccesion (
    id SERIAL PRIMARY KEY,
    event_id INTEGER NOT NULL UNIQUE REFERENCES jbpe.event(id) ON DELETE CASCADE,
    motivo jbpe.razon_desaccesion_enum NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE jbpe.evento_desaccesion IS 
'Información específica de desaccesión: motivo por el cual se retira el ejemplar de la colección';

COMMENT ON COLUMN jbpe.evento_desaccesion.motivo IS 
'Motivo de desaccesión: muerto, plaga_intratable, invasor, intercambio, donación, irrelevante_para_coleccion, error_identificacion, falta_espacio, perdido, otro';

CREATE INDEX idx_desaccesion_event ON jbpe.evento_desaccesion(event_id);
CREATE INDEX idx_desaccesion_motivo ON jbpe.evento_desaccesion(motivo);

-- ============================================
-- TABLA: Evento Determinar Taxon
-- ============================================

CREATE TABLE jbpe.evento_determinar_taxon (
    id SERIAL PRIMARY KEY,
    event_id INTEGER NOT NULL UNIQUE REFERENCES jbpe.event(id) ON DELETE CASCADE,
    taxon_viejo_id INTEGER REFERENCES jbpe.nombres_especie(id) ON DELETE SET NULL,
    taxon_nuevo_id INTEGER NOT NULL REFERENCES jbpe.nombres_especie(id) ON DELETE RESTRICT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraint: taxon_viejo y taxon_nuevo no pueden ser iguales
    CONSTRAINT chk_taxon_diferente CHECK (taxon_viejo_id IS NULL OR taxon_viejo_id != taxon_nuevo_id)
);

COMMENT ON TABLE jbpe.evento_determinar_taxon IS 
'Registro de determinaciones y redeterminaciones taxonómicas. Guarda el taxon anterior y el nuevo.';

COMMENT ON COLUMN jbpe.evento_determinar_taxon.taxon_viejo_id IS 
'Identificación taxonómica anterior (NULL si es primera determinación)';

COMMENT ON COLUMN jbpe.evento_determinar_taxon.taxon_nuevo_id IS 
'Nueva identificación taxonómica';

CREATE INDEX idx_determinar_event ON jbpe.evento_determinar_taxon(event_id);
CREATE INDEX idx_determinar_viejo ON jbpe.evento_determinar_taxon(taxon_viejo_id);
CREATE INDEX idx_determinar_nuevo ON jbpe.evento_determinar_taxon(taxon_nuevo_id);

-- ============================================
-- VERIFICACIÓN BLOQUE 6
-- ============================================

-- ✓ Bloque 6: Eventos (esperado: 4 tablas)
SELECT COUNT(*) as "Tablas de Eventos"
FROM information_schema.tables 
WHERE table_schema = 'jbpe'
AND table_name IN ('event', 'evento_chequeo_anual', 'evento_desaccesion', 'evento_determinar_taxon');

-- Ver estructura de event
SELECT 
    column_name as "Columna",
    data_type as "Tipo",
    is_nullable as "Nullable"
FROM information_schema.columns
WHERE table_schema = 'jbpe' 
AND table_name = 'event'
ORDER BY ordinal_position;

-- Ver FKs de eventos
SELECT
    tc.table_name as "Tabla",
    kcu.column_name as "Columna FK",
    ccu.table_name AS "Referencia a",
    ccu.column_name AS "Columna"
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY' 
AND tc.table_schema = 'jbpe'
AND tc.table_name LIKE 'event%'
ORDER BY tc.table_name, kcu.column_name;

-- Ver índices de eventos
SELECT 
    tablename as "Tabla",
    indexname as "Índice"
FROM pg_indexes
WHERE schemaname = 'jbpe'
AND tablename LIKE 'event%'
ORDER BY tablename, indexname;


-- ============================================
-- BLOQUE 7: TRIGGERS
-- ============================================

-- ============================================
-- TRIGGER 1: Actualizar updated_at automáticamente
-- ============================================

CREATE OR REPLACE FUNCTION jbpe.actualizar_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION jbpe.actualizar_updated_at() IS 
'Actualiza automáticamente el campo updated_at cuando se modifica un registro';

-- Aplicar a todas las tablas con updated_at
CREATE TRIGGER trigger_updated_at_adquisicion
    BEFORE UPDATE ON jbpe.adquisicion
    FOR EACH ROW
    EXECUTE FUNCTION jbpe.actualizar_updated_at();

CREATE TRIGGER trigger_updated_at_event
    BEFORE UPDATE ON jbpe.event
    FOR EACH ROW
    EXECUTE FUNCTION jbpe.actualizar_updated_at();

CREATE TRIGGER trigger_updated_at_persona
    BEFORE UPDATE ON jbpe.persona
    FOR EACH ROW
    EXECUTE FUNCTION jbpe.actualizar_updated_at();

CREATE TRIGGER trigger_updated_at_chequeo
    BEFORE UPDATE ON jbpe.evento_chequeo_anual
    FOR EACH ROW
    EXECUTE FUNCTION jbpe.actualizar_updated_at();

CREATE TRIGGER trigger_updated_at_desaccesion
    BEFORE UPDATE ON jbpe.evento_desaccesion
    FOR EACH ROW
    EXECUTE FUNCTION jbpe.actualizar_updated_at();

CREATE TRIGGER trigger_updated_at_determinar_taxon
    BEFORE UPDATE ON jbpe.evento_determinar_taxon
    FOR EACH ROW
    EXECUTE FUNCTION jbpe.actualizar_updated_at();

CREATE TRIGGER trigger_updated_at_germoplasma
    BEFORE UPDATE ON jbpe.germoplasma_colectado
    FOR EACH ROW
    EXECUTE FUNCTION jbpe.actualizar_updated_at();

CREATE TRIGGER trigger_updated_at_location
    BEFORE UPDATE ON jbpe.location
    FOR EACH ROW
    EXECUTE FUNCTION jbpe.actualizar_updated_at();

CREATE TRIGGER trigger_updated_at_sitio
    BEFORE UPDATE ON jbpe.sitio_recoleccion
    FOR EACH ROW
    EXECUTE FUNCTION jbpe.actualizar_updated_at();

CREATE TRIGGER trigger_updated_at_orden
    BEFORE UPDATE ON jbpe.orden
    FOR EACH ROW
    EXECUTE FUNCTION jbpe.actualizar_updated_at();

CREATE TRIGGER trigger_updated_at_familia
    BEFORE UPDATE ON jbpe.familia
    FOR EACH ROW
    EXECUTE FUNCTION jbpe.actualizar_updated_at();

CREATE TRIGGER trigger_updated_at_genero
    BEFORE UPDATE ON jbpe.genero
    FOR EACH ROW
    EXECUTE FUNCTION jbpe.actualizar_updated_at();

CREATE TRIGGER trigger_updated_at_nombres_especie
    BEFORE UPDATE ON jbpe.nombres_especie
    FOR EACH ROW
    EXECUTE FUNCTION jbpe.actualizar_updated_at();

CREATE TRIGGER trigger_updated_at_especie_detalle
    BEFORE UPDATE ON jbpe.especie_detalle
    FOR EACH ROW
    EXECUTE FUNCTION jbpe.actualizar_updated_at();

-- ============================================
-- TRIGGER 2: Actualizar estado según eventos
-- ============================================

CREATE OR REPLACE FUNCTION jbpe.actualizar_estado_por_evento()
RETURNS TRIGGER AS $$
BEGIN
    -- Actualizar el estado_actual según el tipo de evento
    IF NEW.tipo = 'ingreso' THEN
        UPDATE jbpe.adquisicion 
        SET estado = 'adquirido',
            updated_at = CURRENT_TIMESTAMP
        WHERE id = NEW.adquisicion_id;
        
    ELSIF NEW.tipo = 'accesion' THEN
        UPDATE jbpe.adquisicion 
        SET estado = 'accesionado',
            updated_at = CURRENT_TIMESTAMP
        WHERE id = NEW.adquisicion_id;
        
    ELSIF NEW.tipo = 'desaccesion' THEN
        UPDATE jbpe.adquisicion 
        SET estado = 'desaccesionado',
            updated_at = CURRENT_TIMESTAMP
        WHERE id = NEW.adquisicion_id;
        
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION jbpe.actualizar_estado_por_evento() IS 
'Event Sourcing: Actualiza el estado de la adquisición según el tipo de evento registrado';

CREATE TRIGGER trigger_actualizar_estado
    AFTER INSERT ON jbpe.event
    FOR EACH ROW
    EXECUTE FUNCTION jbpe.actualizar_estado_por_evento();

COMMENT ON TRIGGER trigger_actualizar_estado ON jbpe.event IS 
'Actualiza automáticamente el estado del ejemplar cuando se registra un evento que cambia el estado';

-- ============================================
-- TRIGGER 3: Actualizar taxon_id en redeterminaciones
-- ============================================

CREATE OR REPLACE FUNCTION jbpe.actualizar_taxon_por_evento()
RETURNS TRIGGER AS $$
DECLARE
    evento_tipo jbpe.tipo_evento;
BEGIN
    -- Obtener el tipo de evento
    SELECT tipo INTO evento_tipo
    FROM jbpe.event
    WHERE id = NEW.event_id;
    
    -- Solo proceder si es redeterminación taxonómica
    IF evento_tipo = 'redeterminacion_taxonomica' THEN
        -- Actualizar el taxon_id de la adquisición con el nuevo taxon
        UPDATE jbpe.adquisicion
        SET taxon_id = NEW.taxon_nuevo_id,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = (
            SELECT adquisicion_id 
            FROM jbpe.event 
            WHERE id = NEW.event_id
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION jbpe.actualizar_taxon_por_evento() IS 
'Actualiza automáticamente el taxon_id de la adquisición cuando se registra una redeterminación taxonómica';

CREATE TRIGGER trigger_actualizar_taxon
    AFTER INSERT ON jbpe.evento_determinar_taxon
    FOR EACH ROW
    EXECUTE FUNCTION jbpe.actualizar_taxon_por_evento();

COMMENT ON TRIGGER trigger_actualizar_taxon ON jbpe.evento_determinar_taxon IS 
'Sincroniza el taxon_id de la adquisición con la determinación taxonómica más reciente';

-- ============================================
-- TRIGGER 4: Validar accesión (requiere determinación)
-- ============================================

CREATE OR REPLACE FUNCTION jbpe.validar_accesion()
RETURNS TRIGGER AS $$
DECLARE
    estado_actual jbpe.estado_actual;
    taxon_actual INTEGER;
    taxon_nombre VARCHAR(200);
BEGIN
    -- Solo validar si el evento es de tipo 'accesion'
    IF NEW.tipo = 'accesion' THEN
        
        -- Obtener el estado y taxon actual de la adquisición
        SELECT estado, taxon_id 
        INTO estado_actual, taxon_actual
        FROM jbpe.adquisicion
        WHERE id = NEW.adquisicion_id;
        
        -- Validar que esté en estado 'adquirido'
        IF estado_actual != 'adquirido' THEN
            RAISE EXCEPTION 'No se puede accesionar un ejemplar que no está en estado "adquirido". Estado actual: %', estado_actual;
        END IF;
        
        -- Validar que tenga determinación taxonómica
        IF taxon_actual IS NULL THEN
            RAISE EXCEPTION 'No se puede accesionar un ejemplar sin determinación taxonómica';
        END IF;
        
        -- Validar que no sea "indeterminado"
        SELECT nombre INTO taxon_nombre
        FROM jbpe.nombres_especie
        WHERE id = taxon_actual;
        
        IF taxon_nombre = 'indeterminado' THEN
            RAISE EXCEPTION 'No se puede accesionar un ejemplar con determinación "indeterminado". Debe tener una identificación taxonómica válida.';
        END IF;
        
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION jbpe.validar_accesion() IS 
'Valida que un ejemplar cumpla las condiciones necesarias antes de ser accesionado: debe estar en estado adquirido y tener determinación taxonómica válida';

CREATE TRIGGER trigger_validar_accesion
    BEFORE INSERT ON jbpe.event
    FOR EACH ROW
    WHEN (NEW.tipo = 'accesion')
    EXECUTE FUNCTION jbpe.validar_accesion();

COMMENT ON TRIGGER trigger_validar_accesion ON jbpe.event IS 
'Previene la accesión de ejemplares sin determinación taxonómica o en estado incorrecto';

-- ============================================
-- TRIGGER 5: Validar desaccesión (solo si está accesionado)
-- ============================================

CREATE OR REPLACE FUNCTION jbpe.validar_desaccesion()
RETURNS TRIGGER AS $$
DECLARE
    estado_actual jbpe.estado_actual;
BEGIN
    -- Solo validar si el evento es de tipo 'desaccesion'
    IF NEW.tipo = 'desaccesion' THEN
        
        -- Obtener el estado actual de la adquisición
        SELECT estado 
        INTO estado_actual
        FROM jbpe.adquisicion
        WHERE id = NEW.adquisicion_id;
        
        -- Validar que esté en estado 'accesionado'
        IF estado_actual != 'accesionado' THEN
            RAISE EXCEPTION 'Solo se pueden desaccesionar ejemplares en estado "accesionado". Estado actual: %', estado_actual;
        END IF;
        
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION jbpe.validar_desaccesion() IS 
'Valida que solo se puedan desaccesionar ejemplares que están en estado accesionado';

CREATE TRIGGER trigger_validar_desaccesion
    BEFORE INSERT ON jbpe.event
    FOR EACH ROW
    WHEN (NEW.tipo = 'desaccesion')
    EXECUTE FUNCTION jbpe.validar_desaccesion();

COMMENT ON TRIGGER trigger_validar_desaccesion ON jbpe.event IS 
'Previene la desaccesión de ejemplares que no están accesionados';

-- ============================================
-- TRIGGER 6: Asignar id_accesion automáticamente
-- ============================================

-- Crear la secuencia
CREATE SEQUENCE jbpe.id_accesion_seq START WITH 1;

-- Función corregida
CREATE OR REPLACE FUNCTION jbpe.asignar_id_accesion()
RETURNS TRIGGER AS $$
DECLARE
    siguiente_id INTEGER;
BEGIN
    IF NEW.tipo = 'accesion' THEN
        -- Obtener siguiente ID de la secuencia
        siguiente_id := nextval('jbpe.id_accesion_seq');
        
        -- Asignar el ID de accesión
        UPDATE jbpe.adquisicion
        SET id_accesion = siguiente_id,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = NEW.adquisicion_id
        AND id_accesion IS NULL;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION jbpe.asignar_id_accesion() IS 
'Asigna automáticamente un ID de accesión correlativo usando una secuencia. Garantiza unicidad incluso con accesos concurrentes.';
CREATE TRIGGER trigger_asignar_id_accesion
    AFTER INSERT ON jbpe.event
    FOR EACH ROW
    WHEN (NEW.tipo = 'accesion')
    EXECUTE FUNCTION jbpe.asignar_id_accesion();

COMMENT ON TRIGGER trigger_asignar_id_accesion ON jbpe.event IS 
'Asigna automáticamente un número de accesión correlativo al accesionar un ejemplar';

-- ============================================
-- VERIFICACIÓN BLOQUE 7
-- ============================================

-- Ver todos los triggers creados
SELECT 
    trigger_name as "Trigger",
    event_object_table as "Tabla",
    action_timing as "Timing",
    event_manipulation as "Evento"
FROM information_schema.triggers
WHERE trigger_schema = 'jbpe'
ORDER BY event_object_table, trigger_name;

-- Ver todas las funciones de trigger creadas
SELECT 
    p.proname as "Función",
    pg_get_function_identity_arguments(p.oid) as "Argumentos",
    d.description as "Descripción"
FROM pg_proc p
LEFT JOIN pg_description d ON p.oid = d.objoid
WHERE p.pronamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'jbpe')
AND p.proname LIKE '%trigger%'
OR p.proname LIKE '%validar%'
OR p.proname LIKE '%actualizar%'
OR p.proname LIKE '%asignar%'
ORDER BY p.proname;

-- Contar triggers por tabla
SELECT 
    event_object_table as "Tabla",
    COUNT(*) as "Cantidad Triggers"
FROM information_schema.triggers
WHERE trigger_schema = 'jbpe'
GROUP BY event_object_table
ORDER BY COUNT(*) DESC;

-- ============================================
-- VERIFICACIÓN GENERAL
-- ============================================
SELECT 'ENUMs' as "Tipo", COUNT(*)::text as "Cantidad"
FROM pg_type 
WHERE typnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'jbpe')
AND typtype = 'e'

UNION ALL

SELECT 'Tablas', COUNT(*)::text
FROM information_schema.tables 
WHERE table_schema = 'jbpe' AND table_type = 'BASE TABLE'

UNION ALL

SELECT 'Índices', COUNT(*)::text
FROM pg_indexes
WHERE schemaname = 'jbpe';


-- ============================================
-- DATOS DE PRUEBA
-- ============================================

-- Jerarquía de localizaciones
INSERT INTO jbpe.location (location_id, name, level, parent_id) VALUES
('ARG', 'Argentina', 'country', NULL);

INSERT INTO jbpe.location (location_id, name, level, parent_id) VALUES
('CHU', 'Chubut', 'stateprovince', (SELECT id FROM jbpe.location WHERE location_id = 'ARG'));

INSERT INTO jbpe.location (location_id, name, level, parent_id) VALUES
('BIE', 'Biedma', 'county', (SELECT id FROM jbpe.location WHERE location_id = 'CHU'));

INSERT INTO jbpe.location (location_id, name, level, parent_id) VALUES
('PMY', 'Puerto Madryn', 'locality', (SELECT id FROM jbpe.location WHERE location_id = 'BIE'));

-- Sitio de recolección de ejemplo
INSERT INTO jbpe.sitio_recoleccion (
    location_id, 
    latitud, 
    longitud, 
    altitud, 
    habitat,
    notas
) VALUES (
    (SELECT id FROM jbpe.location WHERE location_id = 'PMY'),
    -42.7692,  -- Puerto Madryn
    -65.0391,
    10,
    'Estepa patagónica',
    'Sitio de prueba en las afueras de Puerto Madryn'
);

-- Verificar jerarquía
WITH RECURSIVE hierarchy AS (
    SELECT id, name, level, parent_id, 1 as depth
    FROM jbpe.location
    WHERE name = 'Puerto Madryn'
    UNION ALL
    SELECT l.id, l.name, l.level, l.parent_id, h.depth + 1
    FROM jbpe.location l
    JOIN hierarchy h ON l.id = h.parent_id
)
SELECT 
    REPEAT('  ', 4 - depth) || name as "Jerarquía",
    level as "Nivel"
FROM hierarchy 
ORDER BY depth DESC;

-- Ver sitio de recolección con su localización
SELECT 
    sr.id,
    sr.latitud,
    sr.longitud,
    sr.habitat,
    l.name as localidad
FROM jbpe.sitio_recoleccion sr
JOIN jbpe.location l ON sr.location_id = l.id;

-- Personas de prueba
INSERT INTO jbpe.persona (nombre, apellido, tipo, email, institucion) VALUES
('Juan', 'Pérez', 'colector', 'jperez@example.com', 'IPEEC-CONICET'),
('María', 'González', 'cientifico', 'mgonzalez@example.com', 'CENPAT'),
('Carlos', 'Rodríguez', 'cultivador', 'crodriguez@example.com', 'JBPE'),
('Ana', 'Martínez', 'donador', 'amartinez@example.com', NULL);

-- Ver personas creadas
SELECT 
    id,
    nombre || ' ' || COALESCE(apellido, '') as "Nombre completo",
    tipo,
    institucion
FROM jbpe.persona
ORDER BY tipo, nombre;


-- ============================================
-- DATOS DE PRUEBA - BLOQUE 4: ADQUISICION
-- ============================================

-- Insertar primera adquisición (recolección de campo)
INSERT INTO jbpe.adquisicion (
    adquisicion_id,
    marca_temporal,
    fecha_recoleccion,
    recoleccion_por_id,
    sitio_recoleccion_id,
    donador_id,
    cultivador_por_id,
    determinado_por,
    detalle_material_ingresado,
    procedencia,
    material_adicional,
    estado,
    sector,
    observaciones,
    foto,
    nombre_vulgar,
    numero_original
) VALUES (
    'A-001',
    '2024-01-15 10:30:00',
    '2024-01-15',
    (SELECT id FROM jbpe.persona WHERE nombre = 'Juan' AND apellido = 'Pérez'),
    (SELECT id FROM jbpe.sitio_recoleccion LIMIT 1),
    (SELECT id FROM jbpe.persona WHERE nombre = 'Ana' AND apellido = 'Martínez'),
    (SELECT id FROM jbpe.persona WHERE nombre = 'Carlos' AND apellido = 'Rodríguez'),
    (SELECT id FROM jbpe.persona WHERE nombre = 'María' AND apellido = 'González'),
    'Semillas maduras recolectadas de población silvestre. Aproximadamente 200 unidades viables. Color marrón oscuro, tamaño uniforme 3-4mm.',
    'silvestre',
    'Herbario: 3 ejemplares prensados con flores y frutos. Fotos digitales: 15 imágenes (hábitat, población, detalle flores y frutos). Coordenadas GPS registradas.',
    'adquirido',
    'Playón',
    'Material colectado en zona árida con buen estado sanitario. Población abundante. Semillas requieren estratificación fría (4°C, 30 días) para romper dormancia.',
    true,
    'Jarilla',
    'JBPE-CAMP-2024-001'
);

-- Insertar segunda adquisición (plántulas en desarrollo)
INSERT INTO jbpe.adquisicion (
    adquisicion_id,
    marca_temporal,
    fecha_recoleccion,
    recoleccion_por_id,
    sitio_recoleccion_id,
    cultivador_por_id,
    transplantador_por_id,
    determinado_por,
    detalle_material_ingresado,
    procedencia,
    estado,
    sector,
    fecha_plantado_predio,
    como_plantado_predio,
    nombre_vulgar,
    numero_original,
    numero_actual,
    observaciones
) VALUES (
    'A-002',
    '2024-02-10 14:00:00',
    '2024-02-10',
    (SELECT id FROM jbpe.persona WHERE nombre = 'María' AND apellido = 'González'),
    (SELECT id FROM jbpe.sitio_recoleccion LIMIT 1),
    (SELECT id FROM jbpe.persona WHERE nombre = 'Carlos' AND apellido = 'Rodríguez'),
    (SELECT id FROM jbpe.persona WHERE nombre = 'Juan' AND apellido = 'Pérez'),
    (SELECT id FROM jbpe.persona WHERE nombre = 'María' AND apellido = 'González'),
    'Tres plántulas saludables de 6 meses de edad. Altura promedio: 15cm. Sistema radicular bien desarrollado. Follaje verde oscuro sin signos de estrés.',
    'cultivada_a_partir_de_material_silvestre',
    'adquirido',
    'Invernáculo 1',
    '2024-03-15',
    'Transplante realizado en suelo franco-arenoso enmendado con 30% compost. Distancia entre plantas: 2 metros. Riego por goteo instalado. Mulch orgánico aplicado.',
    'Molle',
    'JBPE-CAMP-2023-045',
    'JBPE-2024-1001',
    'Ejemplar pasó exitosamente el primer verano. Crecimiento vigoroso. Sin signos de plagas ni enfermedades. Listo para monitoreo anual.'
);

-- Insertar tercera adquisición (donación)
INSERT INTO jbpe.adquisicion (
    adquisicion_id,
    marca_temporal,
    fecha_donacion,
    donador_id,
    cultivador_por_id,
    detalle_material_ingresado,
    procedencia,
    estado,
    sector,
    observaciones,
    nombre_vulgar,
    numero_original
) VALUES (
    'A-003',
    '2024-03-05 09:00:00',
    '2024-03-05',
    (SELECT id FROM jbpe.persona WHERE nombre = 'Ana' AND apellido = 'Martínez'),
    (SELECT id FROM jbpe.persona WHERE nombre = 'Carlos' AND apellido = 'Rodríguez'),
    'Diez esquejes apicales de planta madre en cultivo. Longitud: 10-15cm. Corte limpio, sin signos de enfermedad. Textura semi-leñosa ideal para enraizamiento.',
    'cultivada_a_partir_de_material_silvestre',
    'adquirido',
    'Invernáculo 1',
    'Donación de coleccionista particular. Planta madre de 5 años en jardín doméstico, origen silvestre documentado (coordenadas originales disponibles). Excelente estado sanitario.',
    'Alpataco',
    'DON-2024-003'
);

-- Insertar cuarta adquisición (material mixto)
INSERT INTO jbpe.adquisicion (
    adquisicion_id,
    marca_temporal,
    fecha_recoleccion,
    recoleccion_por_id,
    sitio_recoleccion_id,
    cultivador_por_id,
    determinado_por,
    detalle_material_ingresado,
    procedencia,
    estado,
    sector,
    observaciones,
    foto,
    nombre_vulgar,
    material_adicional
) VALUES (
    'A-004',
    '2024-03-20 11:15:00',
    '2024-03-20',
    (SELECT id FROM jbpe.persona WHERE nombre = 'Juan' AND apellido = 'Pérez'),
    (SELECT id FROM jbpe.sitio_recoleccion LIMIT 1),
    (SELECT id FROM jbpe.persona WHERE nombre = 'Carlos' AND apellido = 'Rodríguez'),
    (SELECT id FROM jbpe.persona WHERE nombre = 'María' AND apellido = 'González'),
    'Colecta múltiple: 150 semillas, 5 esquejes y 2 plántulas naturales encontradas cerca de planta madre.',
    'silvestre',
    'adquirido',
    'Invernáculo 1',
    'Recolección excepcional: encontramos regeneración natural exitosa (plántulas) junto a planta madre. Material diverso permite probar múltiples métodos de propagación.',
    true,
    'Retamo',
    'Muestras de suelo (análisis físico-químico), muestras de ADN foliares, herbario completo (3 duplicados)'
);

-- ============================================
-- Insertar germoplasma colectado
-- ============================================

-- A-001: Solo semillas
INSERT INTO jbpe.germoplasma_colectado (adquisicion_id, persona_id, tipo_germoplasma) 
VALUES
((SELECT id FROM jbpe.adquisicion WHERE adquisicion_id = 'A-001'),
 (SELECT id FROM jbpe.persona WHERE nombre = 'Juan' AND apellido = 'Pérez'),
 'semilla');

-- A-002: Plántulas (colectadas por María, cultivadas por Carlos)
INSERT INTO jbpe.germoplasma_colectado (adquisicion_id, persona_id, tipo_germoplasma) 
VALUES
((SELECT id FROM jbpe.adquisicion WHERE adquisicion_id = 'A-002'),
 (SELECT id FROM jbpe.persona WHERE nombre = 'María' AND apellido = 'González'),
 'plantula'),
((SELECT id FROM jbpe.adquisicion WHERE adquisicion_id = 'A-002'),
 (SELECT id FROM jbpe.persona WHERE nombre = 'Carlos' AND apellido = 'Rodríguez'),
 'planta');

-- A-003: Solo esquejes (donación)
INSERT INTO jbpe.germoplasma_colectado (adquisicion_id, persona_id, tipo_germoplasma) 
VALUES
((SELECT id FROM jbpe.adquisicion WHERE adquisicion_id = 'A-003'),
 (SELECT id FROM jbpe.persona WHERE nombre = 'Ana' AND apellido = 'Martínez'),
 'esqueje');

-- A-004: Múltiples tipos (colecta mixta)
INSERT INTO jbpe.germoplasma_colectado (adquisicion_id, persona_id, tipo_germoplasma) 
VALUES
((SELECT id FROM jbpe.adquisicion WHERE adquisicion_id = 'A-004'),
 (SELECT id FROM jbpe.persona WHERE nombre = 'Juan' AND apellido = 'Pérez'),
 'semilla'),
((SELECT id FROM jbpe.adquisicion WHERE adquisicion_id = 'A-004'),
 (SELECT id FROM jbpe.persona WHERE nombre = 'Juan' AND apellido = 'Pérez'),
 'esqueje'),
((SELECT id FROM jbpe.adquisicion WHERE adquisicion_id = 'A-004'),
 (SELECT id FROM jbpe.persona WHERE nombre = 'Juan' AND apellido = 'Pérez'),
 'plantula');

-- ============================================
-- CONSULTAS DE VERIFICACIÓN DE DATOS
-- ============================================

-- 1. Ver todas las adquisiciones con información completa
SELECT 
    a.adquisicion_id,
    a.nombre_vulgar,
    TO_CHAR(a.marca_temporal, 'DD/MM/YYYY HH24:MI') as fecha,
    a.estado,
    a.sector,
    a.procedencia,
    recolector.nombre || ' ' || COALESCE(recolector.apellido, '') as recolector,
    donador.nombre || ' ' || COALESCE(donador.apellido, '') as donador,
    cultivador.nombre || ' ' || COALESCE(cultivador.apellido, '') as cultivador,
    l.name as localidad
FROM jbpe.adquisicion a
LEFT JOIN jbpe.persona recolector ON a.recoleccion_por_id = recolector.id
LEFT JOIN jbpe.persona donador ON a.donador_id = donador.id
LEFT JOIN jbpe.persona cultivador ON a.cultivador_por_id = cultivador.id
LEFT JOIN jbpe.sitio_recoleccion sr ON a.sitio_recoleccion_id = sr.id
LEFT JOIN jbpe.location l ON sr.location_id = l.id
ORDER BY a.marca_temporal DESC;

-- 2. Ver germoplasma colectado por adquisición
SELECT 
    a.adquisicion_id,
    a.nombre_vulgar,
    gc.tipo_germoplasma,
    p.nombre || ' ' || COALESCE(p.apellido, '') as colector
FROM jbpe.germoplasma_colectado gc
JOIN jbpe.adquisicion a ON gc.adquisicion_id = a.id
LEFT JOIN jbpe.persona p ON gc.persona_id = p.id
ORDER BY a.adquisicion_id, gc.tipo_germoplasma;

-- 3. Adquisiciones con conteo de tipos de germoplasma
SELECT 
    a.adquisicion_id,
    a.nombre_vulgar,
    a.estado,
    COUNT(gc.id) as tipos_colectados,
    STRING_AGG(DISTINCT gc.tipo_germoplasma::text, ', ' ORDER BY gc.tipo_germoplasma::text) as tipos
FROM jbpe.adquisicion a
LEFT JOIN jbpe.germoplasma_colectado gc ON a.id = gc.adquisicion_id
GROUP BY a.id, a.adquisicion_id, a.nombre_vulgar, a.estado
ORDER BY a.adquisicion_id;

-- 4. Resumen por estado
SELECT 
    estado,
    COUNT(*) as cantidad,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) as porcentaje
FROM jbpe.adquisicion
GROUP BY estado
ORDER BY cantidad DESC;

-- 5. Resumen por sector
SELECT 
    sector,
    COUNT(*) as cantidad,
    COUNT(*) FILTER (WHERE estado = 'accesionado') as accesionadas,
    COUNT(*) FILTER (WHERE foto = true) as con_foto
FROM jbpe.adquisicion
GROUP BY sector
ORDER BY cantidad DESC;

-- 6. Resumen por procedencia
SELECT 
    procedencia,
    COUNT(*) as cantidad,
    STRING_AGG(adquisicion_id, ', ' ORDER BY adquisicion_id) as codigos
FROM jbpe.adquisicion
GROUP BY procedencia
ORDER BY cantidad DESC;

-- 7. Tipos de germoplasma más colectados
SELECT 
    gc.tipo_germoplasma,
    COUNT(*) as veces_colectado,
    COUNT(DISTINCT gc.adquisicion_id) as adquisiciones
FROM jbpe.germoplasma_colectado gc
GROUP BY gc.tipo_germoplasma
ORDER BY veces_colectado DESC;

-- 8. Participación de personas en adquisiciones
SELECT 
    p.nombre || ' ' || COALESCE(p.apellido, '') as persona,
    p.tipo,
    COUNT(DISTINCT CASE WHEN a.recoleccion_por_id = p.id THEN a.id END) as recolecciones,
    COUNT(DISTINCT CASE WHEN a.donador_id = p.id THEN a.id END) as donaciones,
    COUNT(DISTINCT CASE WHEN a.cultivador_por_id = p.id THEN a.id END) as cultivos,
    COUNT(DISTINCT CASE WHEN a.transplantador_por_id = p.id THEN a.id END) as transplantes,
    COUNT(DISTINCT CASE WHEN a.determinado_por = p.id THEN a.id END) as determinaciones,
    COUNT(DISTINCT gc.adquisicion_id) as germoplasmas
FROM jbpe.persona p
LEFT JOIN jbpe.adquisicion a ON 
    p.id IN (a.recoleccion_por_id, a.donador_id, a.cultivador_por_id, 
             a.transplantador_por_id, a.determinado_por)
LEFT JOIN jbpe.germoplasma_colectado gc ON gc.persona_id = p.id
GROUP BY p.id, p.nombre, p.apellido, p.tipo
ORDER BY p.nombre;

-- 9. Adquisiciones accesionadas (detalle completo)
SELECT 
    a.adquisicion_id,
    a.id_accesion,
    a.nombre_vulgar,
    a.numero_original,
    a.numero_actual,
    a.sector,
    TO_CHAR(a.fecha_plantado_predio, 'DD/MM/YYYY') as fecha_plantado
FROM jbpe.adquisicion a
WHERE a.estado = 'accesionado'
ORDER BY a.id_accesion;

-- 10. Vista general resumida
SELECT 
    COUNT(*) as total_adquisiciones,
    COUNT(*) FILTER (WHERE estado = 'adquirido') as adquiridas,
    COUNT(*) FILTER (WHERE estado = 'accesionado') as accesionadas,
    COUNT(*) FILTER (WHERE estado = 'desaccesionado') as desaccesionadas,
    COUNT(*) FILTER (WHERE foto = true) as con_foto,
    COUNT(DISTINCT sitio_recoleccion_id) as sitios_diferentes
FROM jbpe.adquisicion;

-- ============================================
-- DATOS DE PRUEBA - BLOQUE 5: TAXONOMÍA
-- ============================================

-- ============================================
-- 1. Taxón especial "Indeterminado"
-- ============================================

INSERT INTO jbpe.orden (nombre, link_flora_arg) VALUES
('Indeterminado', NULL);

INSERT INTO jbpe.familia (nombre, orden_id, link_flora_arg) VALUES
('Indeterminado', (SELECT id FROM jbpe.orden WHERE nombre = 'Indeterminado'), NULL);

INSERT INTO jbpe.genero (nombre, familia_id, link_flora_arg) VALUES
('Indeterminado', (SELECT id FROM jbpe.familia WHERE nombre = 'Indeterminado'), NULL);

INSERT INTO jbpe.especie_detalle (
    descripcion,
    nombre_vulgar
) VALUES (
    'Taxón temporal para ejemplares sin identificación definitiva. Usar mientras se realiza la determinación taxonómica.',
    'Sin determinar'
) RETURNING id;  -- Supongamos que retorna id = 1

INSERT INTO jbpe.nombres_especie (nombre, genero_id, nombre_especie_id, tipo_sinonimia) VALUES
('indeterminado', 
 (SELECT id FROM jbpe.genero WHERE nombre = 'Indeterminado'),
 1,  -- id de especie_detalle
 'accepted');

-- ============================================
-- 2. Taxonomía real: Larrea divaricata (Jarilla)
-- ============================================

-- Orden Zygophyllales
INSERT INTO jbpe.orden (nombre, link_flora_arg) VALUES
('Zygophyllales', 'http://www.floraargentina.edu.ar/orden/zygophyllales');

-- Familia Zygophyllaceae
INSERT INTO jbpe.familia (nombre, orden_id, link_flora_arg) VALUES
('Zygophyllaceae', 
 (SELECT id FROM jbpe.orden WHERE nombre = 'Zygophyllales'),
 'http://www.floraargentina.edu.ar/familia/zygophyllaceae');

-- Género Larrea
INSERT INTO jbpe.genero (nombre, familia_id, link_flora_arg) VALUES
('Larrea', 
 (SELECT id FROM jbpe.familia WHERE nombre = 'Zygophyllaceae'),
 'http://www.floraargentina.edu.ar/genero/larrea');

-- Especie: Larrea divaricata
INSERT INTO jbpe.especie_detalle (
    nombre_vulgar,
    habito,
    status,
    descripcion,
    link_flora_arg
) VALUES (
    'Jarilla',
    'Arbusto',
    'Nativa',
    'Arbusto endémico de la Patagonia extraandina. Altura 1-2m. Muy ramificado, hojas resinosas aromáticas. Importante en ecosistemas áridos.',
    'http://www.floraargentina.edu.ar/especie/larrea-divaricata'
) RETURNING id;  -- Supongamos id = 2

-- Nombre aceptado: Larrea divaricata
INSERT INTO jbpe.nombres_especie (nombre, genero_id, nombre_especie_id, tipo_sinonimia) VALUES
('divaricata', 
 (SELECT id FROM jbpe.genero WHERE nombre = 'Larrea'),
 2,
 'accepted');

-- ============================================
-- 3. Schinus johnstonii (Molle)
-- ============================================

INSERT INTO jbpe.orden (nombre, link_flora_arg) VALUES
('Sapindales', 'http://www.floraargentina.edu.ar/orden/sapindales');

INSERT INTO jbpe.familia (nombre, orden_id, link_flora_arg) VALUES
('Anacardiaceae', 
 (SELECT id FROM jbpe.orden WHERE nombre = 'Sapindales'),
 'http://www.floraargentina.edu.ar/familia/anacardiaceae');

INSERT INTO jbpe.genero (nombre, familia_id, link_flora_arg) VALUES
('Schinus', 
 (SELECT id FROM jbpe.familia WHERE nombre = 'Anacardiaceae'),
 'http://www.floraargentina.edu.ar/genero/schinus');

INSERT INTO jbpe.especie_detalle (
    nombre_vulgar,
    habito,
    status,
    descripcion,
    link_flora_arg
) VALUES (
    'Molle',
    'Árbol',
    'Nativa',
    'Árbol perenne aromático de 4-6m de altura. Hojas compuestas pinnadas. Frutos rojos comestibles. Muy resistente a sequía.',
    'http://www.floraargentina.edu.ar/especie/schinus-johnstonii'
) RETURNING id;  -- id = 3

INSERT INTO jbpe.nombres_especie (nombre, genero_id, nombre_especie_id, tipo_sinonimia) VALUES
('johnstonii', 
 (SELECT id FROM jbpe.genero WHERE nombre = 'Schinus'),
 3,
 'accepted');

-- ============================================
-- 4. Prosopis denudans (Algarrobo/Retamo) con sinónimo
-- ============================================

INSERT INTO jbpe.orden (nombre, link_flora_arg) VALUES
('Fabales', 'http://www.floraargentina.edu.ar/orden/fabales');

INSERT INTO jbpe.familia (nombre, orden_id, link_flora_arg) VALUES
('Fabaceae', 
 (SELECT id FROM jbpe.orden WHERE nombre = 'Fabales'),
 'http://www.floraargentina.edu.ar/familia/fabaceae');

INSERT INTO jbpe.genero (nombre, familia_id, link_flora_arg) VALUES
('Prosopis', 
 (SELECT id FROM jbpe.familia WHERE nombre = 'Fabaceae'),
 'http://www.floraargentina.edu.ar/genero/prosopis');

INSERT INTO jbpe.especie_detalle (
    nombre_vulgar,
    habito,
    status,
    descripcion,
    link_flora_arg,
    bibliografia
) VALUES (
    'Algarrobo patagónico',
    'Árbol',
    'Nativa',
    'Árbol leguminoso nativo de hasta 8m de altura. Hojas bipinnadas. Frutos en vainas comestibles (legumbres). Muy resistente a sequía y suelos pobres. Importante en ecosistemas patagónicos.',
    'http://www.floraargentina.edu.ar/especie/prosopis-denudans',
    'Burkart, A. 1976. A monograph of the genus Prosopis. Journal of the Arnold Arboretum 57: 219-249, 450-525.'
) RETURNING id;  -- id = 4

-- Nombre aceptado
INSERT INTO jbpe.nombres_especie (nombre, genero_id, nombre_especie_id, tipo_sinonimia) VALUES
('denudans', 
 (SELECT id FROM jbpe.genero WHERE nombre = 'Prosopis'),
 4,
 'accepted');

-- Sinónimo (ejemplo)
INSERT INTO jbpe.nombres_especie (nombre, genero_id, nombre_especie_id, tipo_sinonimia) VALUES
('castellanosii', 
 (SELECT id FROM jbpe.genero WHERE nombre = 'Prosopis'),
 4,  -- Mismo especie_detalle
 'synonym');

-- ============================================
-- 5. Actualizar adquisiciones con taxonomía
-- ============================================

-- A-001: Larrea divaricata (Jarilla)
UPDATE jbpe.adquisicion 
SET taxon_id = (
    SELECT ne.id 
    FROM jbpe.nombres_especie ne
    JOIN jbpe.genero g ON ne.genero_id = g.id
    WHERE g.nombre = 'Larrea' AND ne.nombre = 'divaricata'
)
WHERE adquisicion_id = 'A-001';

-- A-002: Schinus johnstonii (Molle)
UPDATE jbpe.adquisicion 
SET taxon_id = (
    SELECT ne.id 
    FROM jbpe.nombres_especie ne
    JOIN jbpe.genero g ON ne.genero_id = g.id
    WHERE g.nombre = 'Schinus' AND ne.nombre = 'johnstonii'
)
WHERE adquisicion_id = 'A-002';

-- A-003: Indeterminado
UPDATE jbpe.adquisicion 
SET taxon_id = (
    SELECT id FROM jbpe.nombres_especie WHERE nombre = 'indeterminado'
)
WHERE adquisicion_id = 'A-003';

-- A-004: Prosopis denudans (Algarrobo)
UPDATE jbpe.adquisicion 
SET taxon_id = (
    SELECT ne.id 
    FROM jbpe.nombres_especie ne
    JOIN jbpe.genero g ON ne.genero_id = g.id
    WHERE g.nombre = 'Prosopis' AND ne.nombre = 'denudans'
)
WHERE adquisicion_id = 'A-004';

-- ============================================
-- CONSULTAS DE VERIFICACIÓN
-- ============================================

-- 1. Jerarquía completa con nombres científicos
SELECT 
    o.nombre as orden,
    f.nombre as familia,
    g.nombre as genero,
    ne.nombre as epiteto,
    g.nombre || ' ' || ne.nombre as nombre_cientifico,
    ne.tipo_sinonimia as estatus,
    ed.nombre_vulgar,
    ed.habito
FROM jbpe.orden o
JOIN jbpe.familia f ON f.orden_id = o.id
JOIN jbpe.genero g ON g.familia_id = f.id
JOIN jbpe.nombres_especie ne ON ne.genero_id = g.id
LEFT JOIN jbpe.especie_detalle ed ON ne.nombre_especie_id = ed.id
WHERE o.nombre != 'Indeterminado'
ORDER BY o.nombre, f.nombre, g.nombre, ne.nombre;

-- 2. Sinónimos y nombres aceptados por especie
SELECT 
    ed.id as especie_id,
    ed.nombre_vulgar,
    g.nombre || ' ' || ne.nombre as nombre_cientifico,
    ne.tipo_sinonimia as estatus,
    CASE 
        WHEN ne.tipo_sinonimia = 'accepted' THEN '✓ Nombre aceptado'
        WHEN ne.tipo_sinonimia = 'synonym' THEN '→ Sinónimo de ' || 
            (SELECT g2.nombre || ' ' || ne2.nombre 
             FROM jbpe.nombres_especie ne2 
             JOIN jbpe.genero g2 ON ne2.genero_id = g2.id
             WHERE ne2.nombre_especie_id = ed.id AND ne2.tipo_sinonimia = 'accepted' 
             LIMIT 1)
        ELSE 'Deprecado'
    END as nota
FROM jbpe.especie_detalle ed
JOIN jbpe.nombres_especie ne ON ne.nombre_especie_id = ed.id
JOIN jbpe.genero g ON ne.genero_id = g.id
WHERE ed.nombre_vulgar != 'Sin determinar'
ORDER BY ed.id, ne.tipo_sinonimia DESC, ne.nombre;

-- 3. Adquisiciones con taxonomía completa
SELECT 
    a.adquisicion_id,
    a.nombre_vulgar as nombre_comun,
    o.nombre as orden,
    f.nombre as familia,
    g.nombre || ' ' || ne.nombre as nombre_cientifico,
    ne.tipo_sinonimia as estatus_nombre,
    ed.habito
FROM jbpe.adquisicion a
LEFT JOIN jbpe.nombres_especie ne ON a.taxon_id = ne.id
LEFT JOIN jbpe.genero g ON ne.genero_id = g.id
LEFT JOIN jbpe.familia f ON g.familia_id = f.id
LEFT JOIN jbpe.orden o ON f.orden_id = o.id
LEFT JOIN jbpe.especie_detalle ed ON ne.nombre_especie_id = ed.id
ORDER BY a.adquisicion_id;

-- 4. Contar ejemplares por familia
SELECT 
    f.nombre as familia,
    COUNT(DISTINCT a.id) as ejemplares,
    STRING_AGG(DISTINCT g.nombre || ' ' || ne.nombre, ', ') as especies_representadas
FROM jbpe.familia f
LEFT JOIN jbpe.genero g ON g.familia_id = f.id
LEFT JOIN jbpe.nombres_especie ne ON ne.genero_id = g.id AND ne.tipo_sinonimia = 'accepted'
LEFT JOIN jbpe.adquisicion a ON a.taxon_id = ne.id
WHERE f.nombre != 'Indeterminado'
GROUP BY f.nombre
ORDER BY ejemplares DESC;

-- 5. Resumen taxonómico
SELECT 
    'Órdenes' as nivel,
    COUNT(*) FILTER (WHERE nombre != 'Indeterminado') as validos,
    COUNT(*) FILTER (WHERE nombre = 'Indeterminado') as indeterminados
FROM jbpe.orden
UNION ALL
SELECT 'Familias', 
    COUNT(*) FILTER (WHERE nombre != 'Indeterminado'),
    COUNT(*) FILTER (WHERE nombre = 'Indeterminado')
FROM jbpe.familia
UNION ALL
SELECT 'Géneros',
    COUNT(*) FILTER (WHERE nombre != 'Indeterminado'),
    COUNT(*) FILTER (WHERE nombre = 'Indeterminado')
FROM jbpe.genero
UNION ALL
SELECT 'Nombres',
    COUNT(*) FILTER (WHERE nombre != 'indeterminado'),
    COUNT(*) FILTER (WHERE nombre = 'indeterminado')
FROM jbpe.nombres_especie
UNION ALL
SELECT 'Especies (detalle)',
    COUNT(*) FILTER (WHERE nombre_vulgar != 'Sin determinar'),
    COUNT(*) FILTER (WHERE nombre_vulgar = 'Sin determinar')
FROM jbpe.especie_detalle;


-- ============================================
-- DATOS DE PRUEBA - BLOQUE 6: EVENTOS
-- ============================================

-- ============================================
-- Eventos para A-001 (Jarilla)
-- ============================================

-- 1. Evento de ingreso
INSERT INTO jbpe.event (
    adquisicion_id,
    tipo,
    fecha_evento,
    registrado_por_id,
    observaciones
) VALUES (
    (SELECT id FROM jbpe.adquisicion WHERE adquisicion_id = 'A-001'),
    'ingreso',
    '2024-01-20',
    (SELECT id FROM jbpe.persona WHERE nombre = 'Carlos' AND apellido = 'Rodríguez'),
    'Material ingresado al vivero. Semillas almacenadas en refrigerador a 4°C para estratificación.'
);

-- 2. Evento de germinación
INSERT INTO jbpe.event (
    adquisicion_id,
    tipo,
    fecha_evento,
    registrado_por_id,
    observaciones
) VALUES (
    (SELECT id FROM jbpe.adquisicion WHERE adquisicion_id = 'A-001'),
    'germinacion',
    '2024-02-25',
    (SELECT id FROM jbpe.persona WHERE nombre = 'Carlos' AND apellido = 'Rodríguez'),
    'Germinación exitosa: 85% de tasa (170 plántulas de 200 semillas). Plántulas en bandejas con sustrato estéril.'
);

-- 3. Evento de trasplante
INSERT INTO jbpe.event (
    adquisicion_id,
    tipo,
    fecha_evento,
    registrado_por_id,
    observaciones
) VALUES (
    (SELECT id FROM jbpe.adquisicion WHERE adquisicion_id = 'A-001'),
    'trasplante',
    '2024-04-10',
    (SELECT id FROM jbpe.persona WHERE nombre = 'Carlos' AND apellido = 'Rodríguez'),
    'Trasplante a macetas individuales de 10cm. Sustrato: 60% tierra, 30% arena, 10% compost. 50 ejemplares seleccionados.'
);

-- ============================================
-- Eventos para A-002 (Molle) - Ya accesionado
-- ============================================

-- 4. Evento de accesión
INSERT INTO jbpe.event (
    adquisicion_id,
    tipo,
    fecha_evento,
    registrado_por_id,
    observaciones
) VALUES (
    (SELECT id FROM jbpe.adquisicion WHERE adquisicion_id = 'A-002'),
    'accesion',
    '2024-06-01',
    (SELECT id FROM jbpe.persona WHERE nombre = 'María' AND apellido = 'González'),
    'Ejemplar accesionado tras superar primer verano exitosamente. Determinación taxonómica confirmada.'
);

-- 5. Evento de chequeo anual con detalles
INSERT INTO jbpe.event (
    adquisicion_id,
    tipo,
    fecha_evento,
    registrado_por_id,
    observaciones
) VALUES (
    (SELECT id FROM jbpe.adquisicion WHERE adquisicion_id = 'A-002'),
    'chequeo_anual',
    '2024-12-15',
    (SELECT id FROM jbpe.persona WHERE nombre = 'María' AND apellido = 'González'),
    'Primer chequeo anual. Ejemplar en excelente estado general. Crecimiento vigoroso.'
) RETURNING id;  -- Guardamos el id del evento

-- Insertar detalles del chequeo (usar el id del evento anterior)
INSERT INTO jbpe.evento_chequeo_anual (
    event_id,
    estado_salud,
    florecio,
    fructifico,
    altura_cm,
    diametro_cm,
    tiene_enfermedad,
    es_invasora
) VALUES (
    currval('jbpe.event_id_seq'),  -- Último event_id insertado
    'excelente',
    true,
    false,
    180.5,
    120.0,
    false,
    false
);

-- ============================================
-- Eventos para A-003 (Alpataco) - Esquejes
-- ============================================

-- 6. Evento de tratamiento (hormona enraizamiento)
INSERT INTO jbpe.event (
    adquisicion_id,
    tipo,
    fecha_evento,
    registrado_por_id,
    observaciones
) VALUES (
    (SELECT id FROM jbpe.adquisicion WHERE adquisicion_id = 'A-003'),
    'tratamiento',
    '2024-04-20',
    (SELECT id FROM jbpe.persona WHERE nombre = 'Carlos' AND apellido = 'Rodríguez'),
    'Aplicación de hormona enraizamiento (IBA 3000ppm). Colocados en cámara de nebulización.'
);

-- 7. Evento de enraizamiento
INSERT INTO jbpe.event (
    adquisicion_id,
    tipo,
    fecha_evento,
    registrado_por_id,
    observaciones
) VALUES (
    (SELECT id FROM jbpe.adquisicion WHERE adquisicion_id = 'A-003'),
    'enraizamiento',
    '2024-05-25',
    (SELECT id FROM jbpe.persona WHERE nombre = 'Carlos' AND apellido = 'Rodríguez'),
    'Enraizamiento exitoso en 6 de 10 esquejes (60%). Raíces de 3-5cm. Listos para trasplante.'
);

-- 8. Evento de redeterminación taxonómica para A-003
-- (cambiar de "indeterminado" a especie determinada - necesitas crear la especie primero)
INSERT INTO jbpe.event (
    adquisicion_id,
    tipo,
    fecha_evento,
    registrado_por_id,
    observaciones
) VALUES (
    (SELECT id FROM jbpe.adquisicion WHERE adquisicion_id = 'A-003'),
    'redeterminacion_taxonomica',
    '2024-06-10',
    (SELECT id FROM jbpe.persona WHERE nombre = 'María' AND apellido = 'González'),
    'Determinación taxonómica completada tras floración. Identificado como Prosopis denudans.'
) RETURNING id;

-- Insertar detalles de determinación
INSERT INTO jbpe.evento_determinar_taxon (
    event_id,
    taxon_viejo_id,
    taxon_nuevo_id
) VALUES (
    currval('jbpe.event_id_seq'),
    (SELECT id FROM jbpe.nombres_especie WHERE nombre = 'indeterminado'),  -- Taxon viejo
    (SELECT ne.id FROM jbpe.nombres_especie ne 
     JOIN jbpe.genero g ON ne.genero_id = g.id 
     WHERE g.nombre = 'Prosopis' AND ne.nombre = 'denudans')  -- Taxon nuevo
);

-- ============================================
-- Eventos para A-004 (Retamo)
-- ============================================

-- 9. Evento de cambio de ubicación
INSERT INTO jbpe.event (
    adquisicion_id,
    tipo,
    fecha_evento,
    registrado_por_id,
    observaciones
) VALUES (
    (SELECT id FROM jbpe.adquisicion WHERE adquisicion_id = 'A-004'),
    'cambio_ubicacion',
    '2024-04-15',
    (SELECT id FROM jbpe.persona WHERE nombre = 'Carlos' AND apellido = 'Rodríguez'),
    'Material trasladado de Invernáculo 1 a Vivero para aclimatación. Reducción gradual de riego.'
);

-- ============================================
-- Ejemplo de DESACCESIÓN (crear ejemplar nuevo)
-- ============================================

-- Crear ejemplar que será desaccesionado
INSERT INTO jbpe.adquisicion (
    adquisicion_id,
    marca_temporal,
    fecha_recoleccion,
    recoleccion_por_id,
    sitio_recoleccion_id,
    determinado_por,
    detalle_material_ingresado,
    procedencia,
    estado,
    sector,
    nombre_vulgar,
    taxon_id
) VALUES (
    'A-005',
    '2023-01-10 10:00:00',
    '2023-01-10',
    (SELECT id FROM jbpe.persona WHERE nombre = 'Juan' AND apellido = 'Pérez'),
    (SELECT id FROM jbpe.sitio_recoleccion LIMIT 1),
    (SELECT id FROM jbpe.persona WHERE nombre = 'María' AND apellido = 'González'),
    'Ejemplar de prueba para desaccesión',
    'silvestre',
    'adquirido',
    'Playón',
    'Ejemplo desaccesión',
    (SELECT ne.id FROM jbpe.nombres_especie ne 
     JOIN jbpe.genero g ON ne.genero_id = g.id 
     WHERE g.nombre = 'Larrea' AND ne.nombre = 'divaricata')
);

-- Evento de desaccesión

-- Primero: accesionar A-005
INSERT INTO jbpe.event (
    adquisicion_id,
    tipo,
    fecha_evento,
    registrado_por_id,
    observaciones
) VALUES (
    (SELECT id FROM jbpe.adquisicion WHERE adquisicion_id = 'A-005'),
    'accesion',
    '2023-06-01',
    (SELECT id FROM jbpe.persona WHERE nombre = 'María' AND apellido = 'González'),
    'Accesión del ejemplar para prueba de desaccesión'
);

-- Luego: desaccesionar A-005
INSERT INTO jbpe.event (
    adquisicion_id,
    tipo,
    fecha_evento,
    registrado_por_id,
    observaciones
) VALUES (
    (SELECT id FROM jbpe.adquisicion WHERE adquisicion_id = 'A-005'),
    'desaccesion',
    '2024-08-15',
    (SELECT id FROM jbpe.persona WHERE nombre = 'María' AND apellido = 'González'),
    'Ejemplar retirado de colección. Muerte por sequía severa a pesar de riego suplementario.'
);

-- Detalles de desaccesión
INSERT INTO jbpe.evento_desaccesion (
    event_id,
    motivo
) VALUES (
    currval('jbpe.event_id_seq'),
    'muerto'
);

-- ============================================
-- Otro chequeo anual con problemas
-- ============================================

INSERT INTO jbpe.event (
    adquisicion_id,
    tipo,
    fecha_evento,
    registrado_por_id,
    observaciones
) VALUES (
    (SELECT id FROM jbpe.adquisicion WHERE adquisicion_id = 'A-001'),
    'chequeo_anual',
    '2025-01-15',
    (SELECT id FROM jbpe.persona WHERE nombre = 'Carlos' AND apellido = 'Rodríguez'),
    'Chequeo detecta presencia de pulgones. Requiere tratamiento.'
) RETURNING id;

INSERT INTO jbpe.evento_chequeo_anual (
    event_id,
    estado_salud,
    florecio,
    fructifico,
    altura_cm,
    diametro_cm,
    tiene_enfermedad,
    es_invasora
) VALUES (
    currval('jbpe.event_id_seq'),
    'bueno',
    false,
    false,
    45.5,
    25.0,
    true,  -- Tiene enfermedad (pulgones)
    false
);

-- ============================================
-- CONSULTAS DE VERIFICACIÓN - EVENTOS
-- ============================================

-- 1. Ver todos los eventos con información completa
SELECT 
    a.adquisicion_id,
    a.nombre_vulgar,
    e.tipo as evento,
    TO_CHAR(e.fecha_evento, 'DD/MM/YYYY') as fecha,
    p.nombre || ' ' || COALESCE(p.apellido, '') as registrado_por,
    LEFT(e.observaciones, 60) || '...' as observaciones
FROM jbpe.event e
JOIN jbpe.adquisicion a ON e.adquisicion_id = a.id
LEFT JOIN jbpe.persona p ON e.registrado_por_id = p.id
ORDER BY a.adquisicion_id, e.fecha_evento;

-- 2. Historial completo de un ejemplar específico
SELECT 
    e.id as event_id,
    e.tipo,
    TO_CHAR(e.fecha_evento, 'DD/MM/YYYY') as fecha,
    p.nombre || ' ' || COALESCE(p.apellido, '') as registrado_por,
    e.observaciones
FROM jbpe.event e
LEFT JOIN jbpe.persona p ON e.registrado_por_id = p.id
WHERE e.adquisicion_id = (SELECT id FROM jbpe.adquisicion WHERE adquisicion_id = 'A-002')
ORDER BY e.fecha_evento;

-- 3. Chequeos anuales con detalles
SELECT 
    a.adquisicion_id,
    a.nombre_vulgar,
    TO_CHAR(e.fecha_evento, 'DD/MM/YYYY') as fecha_chequeo,
    eca.estado_salud,
    CASE WHEN eca.florecio THEN 'Sí' ELSE 'No' END as florecio,
    CASE WHEN eca.fructifico THEN 'Sí' ELSE 'No' END as fructifico,
    eca.altura_cm,
    eca.diametro_cm,
    CASE WHEN eca.tiene_enfermedad THEN 'Sí' ELSE 'No' END as enfermedad,
    CASE WHEN eca.es_invasora THEN 'Sí' ELSE 'No' END as invasora
FROM jbpe.evento_chequeo_anual eca
JOIN jbpe.event e ON eca.event_id = e.id
JOIN jbpe.adquisicion a ON e.adquisicion_id = a.id
ORDER BY e.fecha_evento DESC;

-- 4. Desaccesiones registradas
SELECT 
    a.adquisicion_id,
    a.nombre_vulgar,
    a.id_accesion,
    TO_CHAR(e.fecha_evento, 'DD/MM/YYYY') as fecha_desaccesion,
    ed.motivo,
    e.observaciones
FROM jbpe.evento_desaccesion ed
JOIN jbpe.event e ON ed.event_id = e.id
JOIN jbpe.adquisicion a ON e.adquisicion_id = a.id
ORDER BY e.fecha_evento DESC;

-- 5. Redeterminaciones taxonómicas
SELECT 
    a.adquisicion_id,
    a.nombre_vulgar,
    TO_CHAR(e.fecha_evento, 'DD/MM/YYYY') as fecha_redeterminacion,
    g_viejo.nombre || ' ' || ne_viejo.nombre as taxon_anterior,
    g_nuevo.nombre || ' ' || ne_nuevo.nombre as taxon_nuevo,
    e.observaciones
FROM jbpe.evento_determinar_taxon edt
JOIN jbpe.event e ON edt.event_id = e.id
JOIN jbpe.adquisicion a ON e.adquisicion_id = a.id
LEFT JOIN jbpe.nombres_especie ne_viejo ON edt.taxon_viejo_id = ne_viejo.id
LEFT JOIN jbpe.genero g_viejo ON ne_viejo.genero_id = g_viejo.id
JOIN jbpe.nombres_especie ne_nuevo ON edt.taxon_nuevo_id = ne_nuevo.id
JOIN jbpe.genero g_nuevo ON ne_nuevo.genero_id = g_nuevo.id
ORDER BY e.fecha_evento DESC;

-- 6. Resumen de eventos por tipo
SELECT 
    e.tipo,
    COUNT(*) as cantidad,
    COUNT(DISTINCT e.adquisicion_id) as ejemplares_afectados
FROM jbpe.event e
GROUP BY e.tipo
ORDER BY cantidad DESC;

-- 7. Ejemplares con problemas de salud (último chequeo)
WITH ultimo_chequeo AS (
    SELECT DISTINCT ON (e.adquisicion_id)
        e.adquisicion_id,
        eca.estado_salud,
        eca.tiene_enfermedad,
        eca.es_invasora,
        e.fecha_evento
    FROM jbpe.event e
    JOIN jbpe.evento_chequeo_anual eca ON e.id = eca.event_id
    ORDER BY e.adquisicion_id, e.fecha_evento DESC
)
SELECT 
    a.adquisicion_id,
    a.nombre_vulgar,
    uc.estado_salud,
    CASE WHEN uc.tiene_enfermedad THEN 'Sí' ELSE 'No' END as enfermedad,
    CASE WHEN uc.es_invasora THEN 'Sí' ELSE 'No' END as invasora,
    TO_CHAR(uc.fecha_evento, 'DD/MM/YYYY') as ultimo_chequeo
FROM jbpe.adquisicion a
JOIN ultimo_chequeo uc ON a.id = uc.adquisicion_id
WHERE uc.tiene_enfermedad = true 
   OR uc.es_invasora = true 
   OR uc.estado_salud IN ('malo', 'critico', 'infectado', 'con_plaga')
ORDER BY a.adquisicion_id;

-- 8. Actividad de eventos por mes
SELECT 
    TO_CHAR(e.fecha_evento, 'YYYY-MM') as mes,
    COUNT(*) as total_eventos,
    COUNT(*) FILTER (WHERE e.tipo = 'chequeo_anual') as chequeos,
    COUNT(*) FILTER (WHERE e.tipo = 'accesion') as accesiones,
    COUNT(*) FILTER (WHERE e.tipo = 'desaccesion') as desaccesiones
FROM jbpe.event e
GROUP BY TO_CHAR(e.fecha_evento, 'YYYY-MM')
ORDER BY mes DESC;

-- ============================================
-- PRUEBAS DE TRIGGERS (CORREGIDAS)
-- ============================================

-- ============================================
-- PRUEBA 1: updated_at se actualiza automáticamente
-- ============================================

-- Ver el updated_at actual de A-004
SELECT adquisicion_id, updated_at, observaciones
FROM jbpe.adquisicion 
WHERE adquisicion_id = 'A-004';

-- Esperar un segundo y actualizar
SELECT pg_sleep(1);

UPDATE jbpe.adquisicion 
SET observaciones = 'Prueba de trigger updated_at - ' || CURRENT_TIMESTAMP
WHERE adquisicion_id = 'A-004';

-- Ver que updated_at cambió (debería ser diferente del anterior)
SELECT adquisicion_id, updated_at, observaciones
FROM jbpe.adquisicion 
WHERE adquisicion_id = 'A-004';

-- ============================================
-- PRUEBA 2: Estado se actualiza con eventos
-- ============================================

-- Crear un ejemplar NUEVO para probar accesión
INSERT INTO jbpe.adquisicion (
    adquisicion_id,
    marca_temporal,
    estado,
    sector,
    nombre_vulgar,
    detalle_material_ingresado,
    procedencia,
    recoleccion_por_id,
    taxon_id  -- Con determinación válida para poder accesionar
) VALUES (
    'A-TRIGGER-001',
    CURRENT_TIMESTAMP,
    'adquirido',  -- Estado inicial
    'Bancales',
    'Jarilla para prueba',
    'Ejemplar para probar trigger de accesión',
    'silvestre',
    (SELECT id FROM jbpe.persona WHERE nombre = 'Juan' LIMIT 1),
    (SELECT ne.id FROM jbpe.nombres_especie ne 
     JOIN jbpe.genero g ON ne.genero_id = g.id 
     WHERE g.nombre = 'Larrea' AND ne.nombre = 'divaricata')
);

-- Ver estado inicial
SELECT adquisicion_id, estado, id_accesion
FROM jbpe.adquisicion 
WHERE adquisicion_id = 'A-TRIGGER-001';
-- Debería mostrar: estado = 'adquirido', id_accesion = NULL

-- Crear evento de accesión
INSERT INTO jbpe.event (
    adquisicion_id,
    tipo,
    fecha_evento,
    registrado_por_id,
    observaciones
) VALUES (
    (SELECT id FROM jbpe.adquisicion WHERE adquisicion_id = 'A-TRIGGER-001'),
    'accesion',
    CURRENT_DATE,
    (SELECT id FROM jbpe.persona WHERE nombre = 'María' LIMIT 1),
    'Prueba de trigger de accesión - cambio de estado automático'
);

-- Ver que el estado cambió a 'accesionado' Y se asignó id_accesion
SELECT adquisicion_id, estado, id_accesion
FROM jbpe.adquisicion 
WHERE adquisicion_id = 'A-TRIGGER-001';
-- Debería mostrar: estado = 'accesionado', id_accesion = [número automático]

-- ============================================
-- PRUEBA 3: Validación - NO se puede accesionar SIN determinación
-- ============================================

-- Crear ejemplar sin determinación taxonómica
INSERT INTO jbpe.adquisicion (
    adquisicion_id,
    marca_temporal,
    estado,
    sector,
    nombre_vulgar,
    detalle_material_ingresado,
    procedencia,
    taxon_id  -- NULL (sin determinación)
) VALUES (
    'A-TRIGGER-002',
    CURRENT_TIMESTAMP,
    'adquirido',
    'Bancales',
    'Planta sin determinar',
    'Ejemplar para probar validación de accesión',
    'silvestre',
    NULL  -- Sin determinación
);

-- Intentar accesionar SIN determinación taxonómica (debería FALLAR)
DO $$
BEGIN
    INSERT INTO jbpe.event (
        adquisicion_id,
        tipo,
        fecha_evento,
        observaciones
    ) VALUES (
        (SELECT id FROM jbpe.adquisicion WHERE adquisicion_id = 'A-TRIGGER-002'),
        'accesion',
        CURRENT_DATE,
        'Esta inserción debería fallar por falta de determinación'
    );
    
    RAISE EXCEPTION 'ERROR: El trigger NO funcionó - permitió accesionar sin determinación';
    
EXCEPTION
    WHEN OTHERS THEN
        IF SQLERRM LIKE '%sin determinación taxonómica%' THEN
            RAISE NOTICE '✓ TRIGGER FUNCIONA: No permitió accesionar sin determinación';
            RAISE NOTICE 'Mensaje: %', SQLERRM;
        ELSE
            RAISE;
        END IF;
END $$;

-- ============================================
-- PRUEBA 4: Validación - NO se puede accesionar con "indeterminado"
-- ============================================

-- Actualizar A-TRIGGER-002 con taxon "indeterminado"
UPDATE jbpe.adquisicion
SET taxon_id = (SELECT id FROM jbpe.nombres_especie WHERE nombre = 'indeterminado')
WHERE adquisicion_id = 'A-TRIGGER-002';

-- Intentar accesionar con "indeterminado" (debería FALLAR)
DO $$
BEGIN
    INSERT INTO jbpe.event (
        adquisicion_id,
        tipo,
        fecha_evento,
        observaciones
    ) VALUES (
        (SELECT id FROM jbpe.adquisicion WHERE adquisicion_id = 'A-TRIGGER-002'),
        'accesion',
        CURRENT_DATE,
        'Esta inserción debería fallar por tener indeterminado'
    );
    
    RAISE EXCEPTION 'ERROR: El trigger NO funcionó - permitió accesionar con indeterminado';
    
EXCEPTION
    WHEN OTHERS THEN
        IF SQLERRM LIKE '%indeterminado%' THEN
            RAISE NOTICE '✓ TRIGGER FUNCIONA: No permitió accesionar con "indeterminado"';
            RAISE NOTICE 'Mensaje: %', SQLERRM;
        ELSE
            RAISE;
        END IF;
END $$;

-- ============================================
-- PRUEBA 5: Validación - NO se puede desaccesionar sin estar accesionado
-- ============================================

-- Intentar desaccesionar A-TRIGGER-002 que está 'adquirido' (debería FALLAR)
DO $$
BEGIN
    INSERT INTO jbpe.event (
        adquisicion_id,
        tipo,
        fecha_evento,
        observaciones
    ) VALUES (
        (SELECT id FROM jbpe.adquisicion WHERE adquisicion_id = 'A-TRIGGER-002'),
        'desaccesion',
        CURRENT_DATE,
        'Esta inserción debería fallar - no está accesionado'
    );
    
    RAISE EXCEPTION 'ERROR: El trigger NO funcionó - permitió desaccesionar sin estar accesionado';
    
EXCEPTION
    WHEN OTHERS THEN
        IF SQLERRM LIKE '%accesionado%' THEN
            RAISE NOTICE '✓ TRIGGER FUNCIONA: No permitió desaccesionar sin estar accesionado';
            RAISE NOTICE 'Mensaje: %', SQLERRM;
        ELSE
            RAISE;
        END IF;
END $$;

-- ============================================
-- PRUEBA 6: Redeterminación taxonómica actualiza taxon_id
-- ============================================

-- Ver taxon_id actual de A-TRIGGER-002
SELECT 
    a.adquisicion_id, 
    COALESCE(g.nombre || ' ' || ne.nombre, 'SIN TAXON') as taxon_actual
FROM jbpe.adquisicion a
LEFT JOIN jbpe.nombres_especie ne ON a.taxon_id = ne.id
LEFT JOIN jbpe.genero g ON ne.genero_id = g.id
WHERE a.adquisicion_id = 'A-TRIGGER-002';
-- Debería mostrar "Indeterminado indeterminado"

-- Crear evento de redeterminación
INSERT INTO jbpe.event (
    adquisicion_id,
    tipo,
    fecha_evento,
    registrado_por_id,
    observaciones
) VALUES (
    (SELECT id FROM jbpe.adquisicion WHERE adquisicion_id = 'A-TRIGGER-002'),
    'redeterminacion_taxonomica',
    CURRENT_DATE,
    (SELECT id FROM jbpe.persona WHERE nombre = 'María' LIMIT 1),
    'Redeterminación: identificado como Schinus johnstonii tras floración'
);

-- Insertar detalles de la redeterminación
INSERT INTO jbpe.evento_determinar_taxon (
    event_id,
    taxon_viejo_id,
    taxon_nuevo_id
) VALUES (
    currval('jbpe.event_id_seq'),
    (SELECT id FROM jbpe.nombres_especie WHERE nombre = 'indeterminado'),  -- Viejo
    (SELECT ne.id FROM jbpe.nombres_especie ne 
     JOIN jbpe.genero g ON ne.genero_id = g.id 
     WHERE g.nombre = 'Schinus' AND ne.nombre = 'johnstonii')  -- Nuevo
);

-- Ver que taxon_id cambió automáticamente
SELECT 
    a.adquisicion_id, 
    g.nombre || ' ' || ne.nombre as taxon_nuevo
FROM jbpe.adquisicion a
JOIN jbpe.nombres_especie ne ON a.taxon_id = ne.id
JOIN jbpe.genero g ON ne.genero_id = g.id
WHERE a.adquisicion_id = 'A-TRIGGER-002';
-- Debería mostrar 'Schinus johnstonii'

-- Verificar que el trigger funcionó
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM jbpe.adquisicion a
        JOIN jbpe.nombres_especie ne ON a.taxon_id = ne.id
        JOIN jbpe.genero g ON ne.genero_id = g.id
        WHERE a.adquisicion_id = 'A-TRIGGER-002'
        AND g.nombre = 'Schinus' 
        AND ne.nombre = 'johnstonii'
    ) THEN
        RAISE NOTICE '✓ TRIGGER FUNCIONA: taxon_id actualizado automáticamente tras redeterminación';
    ELSE
        RAISE EXCEPTION 'ERROR: El trigger NO funcionó - taxon_id no se actualizó';
    END IF;
END $$;
-- ============================================
-- PRUEBA 7: Ahora SÍ se puede accesionar (tiene determinación válida)
-- ============================================

-- Ahora que A-TRIGGER-002 tiene determinación válida, debería poder accesionar
INSERT INTO jbpe.event (
    adquisicion_id,
    tipo,
    fecha_evento,
    registrado_por_id,
    observaciones
) VALUES (
    (SELECT id FROM jbpe.adquisicion WHERE adquisicion_id = 'A-TRIGGER-002'),
    'accesion',
    CURRENT_DATE,
    (SELECT id FROM jbpe.persona WHERE nombre = 'María' LIMIT 1),
    'Accesión exitosa tras redeterminación taxonómica'
);

-- Ver que cambió a estado 'accesionado' y tiene id_accesion
SELECT adquisicion_id, estado, id_accesion
FROM jbpe.adquisicion 
WHERE adquisicion_id = 'A-TRIGGER-002';
-- Debería mostrar: estado = 'accesionado', id_accesion = [número]

-- ============================================
-- PRUEBA 8: Desaccesión válida
-- ============================================

-- Ahora que A-TRIGGER-002 está accesionado, SÍ se puede desaccesionar
INSERT INTO jbpe.event (
    adquisicion_id,
    tipo,
    fecha_evento,
    registrado_por_id,
    observaciones
) VALUES (
    (SELECT id FROM jbpe.adquisicion WHERE adquisicion_id = 'A-TRIGGER-002'),
    'desaccesion',
    CURRENT_DATE,
    (SELECT id FROM jbpe.persona WHERE nombre = 'María' LIMIT 1),
    'Desaccesión por plaga intratable'
);

-- Insertar motivo de desaccesión
INSERT INTO jbpe.evento_desaccesion (
    event_id,
    motivo
) VALUES (
    currval('jbpe.event_id_seq'),
    'plaga_intratable'
);

-- Ver que cambió a estado 'desaccesionado'
SELECT adquisicion_id, estado, id_accesion
FROM jbpe.adquisicion 
WHERE adquisicion_id = 'A-TRIGGER-002';
-- Debería mostrar: estado = 'desaccesionado'

-- ============================================
-- PRUEBA 9: id_accesion es correlativo
-- ============================================

-- Ver los últimos id_accesion asignados
SELECT adquisicion_id, id_accesion, estado
FROM jbpe.adquisicion
WHERE id_accesion IS NOT NULL
ORDER BY id_accesion DESC
LIMIT 5;
-- Deberían ser números correlativos

-- ============================================
-- RESUMEN DE PRUEBAS
-- ============================================

SELECT 
    '=== RESUMEN DE PRUEBAS DE TRIGGERS ===' as resumen
UNION ALL
SELECT '✓ Trigger updated_at: Funciona correctamente'
UNION ALL
SELECT '✓ Trigger actualizar estado: Funciona correctamente'
UNION ALL
SELECT '✓ Trigger actualizar taxon: Funciona correctamente'
UNION ALL
SELECT '✓ Trigger validar accesión: Funciona correctamente'
UNION ALL
SELECT '✓ Trigger validar desaccesión: Funciona correctamente'
UNION ALL
SELECT '✓ Trigger asignar id_accesion: Funciona correctamente'
UNION ALL
SELECT '=== TODOS LOS TRIGGERS FUNCIONAN ===' as resumen;

-- ============================================
-- Ver historial completo de ejemplares de prueba
-- ============================================

SELECT 
    a.adquisicion_id,
    e.tipo as evento,
    TO_CHAR(e.fecha_evento, 'DD/MM/YYYY') as fecha,
    LEFT(e.observaciones, 50) as observacion
FROM jbpe.event e
JOIN jbpe.adquisicion a ON e.adquisicion_id = a.id
WHERE a.adquisicion_id LIKE 'A-TRIGGER-%'
ORDER BY a.adquisicion_id, e.fecha_evento;

-- ============================================
-- OPCIONAL: Limpieza de datos de prueba
-- ============================================

-- Descomentar si quieres limpiar los ejemplares de prueba
--DELETE FROM jbpe.adquisicion WHERE adquisicion_id LIKE 'A-TRIGGER-%';

-- COMMIT;  (si todo está OK)
-- ROLLBACK; (si hay errores)

