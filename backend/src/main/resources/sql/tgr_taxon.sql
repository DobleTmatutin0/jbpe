-- ================================================================================
-- TAXON
-- ================================================================================

--*********************************************************************************
-- Trigger para crear una entrada en nombre especie con el nombre aceptado 
--*********************************************************************************
CREATE OR REPLACE FUNCTION m03.fn_crear_nombre_aceptado_de_un_detalle()
RETURNS TRIGGER AS $$
BEGIN

    INSERT INTO m03.nombre_especie (
        detalle_id,
        nombre
    )
    VALUES (
        NEW.id,
        NEW.nombre_especie_aceptado
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tgr_crear_nombre_aceptado_de_un_detalle
AFTER INSERT ON m03.detalle_especie
FOR EACH ROW
EXECUTE FUNCTION m03.fn_crear_nombre_aceptado_de_un_detalle();


--*********************************************************************************
-- Trigger para crear un nuevo nombre aceptado y cambiar el anterior a sinonimo
--*********************************************************************************
CREATE OR REPLACE FUNCTION m03.fn_actualizar_nombre_aceptado_de_un_detalle()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.nombre_especie_aceptado IS DISTINCT FROM OLD.nombre_especie_aceptado THEN

        -- 1. El Accepted actual pasa a ser tipo_nombre
        UPDATE m03.nombre_especie
        SET tipo_nombre = 'synonym'
        WHERE detalle_id = NEW.id
            AND tipo_nombre = 'accepted';

        -- 2. Insertar nuevo nombre aceptado
        INSERT INTO m03.nombre_especie (
            detalle_id,
            nombre
        )
        VALUES (
            NEW.id,
            NEW.nombre_especie_aceptado
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tgr_actualizar_nombre_aceptado_de_un_detalle
AFTER UPDATE ON m03.detalle_especie
FOR EACH ROW
EXECUTE FUNCTION m03.fn_actualizar_nombre_aceptado_de_un_detalle();




-- ================================================================================
-- EVENTOS
-- ================================================================================

--*********************************************************************************
-- trigger para checkear que el tipo de evento del padre sea el correcto
--*********************************************************************************
CREATE OR REPLACE FUNCTION m03.fn_checkear_tipo_evento_base()
RETURNS TRIGGER AS $$
DECLARE
    tipo_real m03.tipo_evento;
    tipo_requerido m03.tipo_evento;
BEGIN

    -- el tipo evento requerido viene como argumento del trigger
    tipo_requerido := TG_ARGV[0]::m03.tipo_evento;

    SELECT tipo_evento
    INTO tipo_real
    FROM m03.evento
    WHERE id = NEW.event_id;

    IF tipo_real IS NULL THEN
        RAISE EXCEPTION 'El evento % no existe', NEW.event_id;
    END IF;

    IF tipo_real <> tipo_requerido THEN
        RAISE EXCEPTION 'El evento % es de tipo %, pero se esperaba %',
        NEW.event_id, tipo_real, tipo_requerido;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tgr_validar_tipo_evento_ingreso
BEFORE INSERT ON m03.evento_ingreso
FOR EACH ROW
EXECUTE FUNCTION m03.fn_checkear_tipo_evento_base('ingreso');

CREATE TRIGGER tgr_validar_tipo_evento_transplante
BEFORE INSERT ON m03.evento_transplante
FOR EACH ROW
EXECUTE FUNCTION m03.fn_checkear_tipo_evento_base('trasplante');

CREATE TRIGGER tgr_validar_tipo_evento_desaccesion
BEFORE INSERT ON m03.evento_desaccesion
FOR EACH ROW
EXECUTE FUNCTION m03.fn_checkear_tipo_evento_base('desaccesion');

CREATE TRIGGER tgr_validar_tipo_evento_determinar_taxon
BEFORE INSERT ON m03.evento_determinar_taxon
FOR EACH ROW
EXECUTE FUNCTION m03.fn_checkear_tipo_evento_base('redeterminacion_taxonomica');

CREATE TRIGGER tgr_validar_tipo_evento_checkeo_anual
BEFORE INSERT ON m03.evento_chequeo_anual
FOR EACH ROW
EXECUTE FUNCTION m03.fn_checkear_tipo_evento_base('chequeo_anual');



--*********************************************************************************
-- trigger para actualizar ejemplar post sub eventos

-- como leer este formato:
-- UPDATE tabla_que_se_modifica
-- SET ...
-- FROM tablas_que_uso_para_filtrar
-- WHERE condiciones
--*********************************************************************************
CREATE OR REPLACE FUNCTION m03.fn_actualizar_ejemplar_post_evento_ingreso()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE m03.ejemplar AS ej
    SET estado = 'adquisicion',
        adquisicion_id = 'A-' || nextval('m03.adquisicion_seq')
    FROM m03.evento AS ev
    WHERE ev.id = NEW.event_id
    AND ej.id = ev.ejemplar_id
    AND estado = 'indefinido';

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER tgr_post_evento_ingreso
AFTER INSERT ON m03.evento_ingreso
FOR EACH ROW
EXECUTE FUNCTION m03.fn_actualizar_ejemplar_post_evento_ingreso();




CREATE OR REPLACE FUNCTION m03.fn_actualizar_ejemplar_post_evento_trasplante()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE m03.ejemplar
    SET sector_actual_id = NEW.sector_inicial
    WHERE id = (
        SELECT ejemplar_id
        FROM m03.evento
        WHERE id = NEW.event_id
    )
    AND estado = 'adquisicion';

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tgr_post_evento_transplante
AFTER INSERT ON m03.evento_transplante
FOR EACH ROW
EXECUTE FUNCTION m03.fn_actualizar_ejemplar_post_evento_trasplante();




CREATE OR REPLACE FUNCTION m03.fn_actualizar_ejemplar_post_evento_desaccesion()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE m03.ejemplar
    SET estado = 'desaccesionado'
    WHERE id = (
        SELECT ejemplar_id
        FROM m03.evento
        WHERE evento.id = NEW.event_id
    )
    AND estado = 'accesionado'; -- ver (capaz q puede pasar de adquisicion a desaccesion)

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tgr_post_evento_desaccesion
AFTER INSERT ON m03.evento_desaccesion
FOR EACH ROW
EXECUTE FUNCTION m03.fn_actualizar_ejemplar_post_evento_desaccesion();



CREATE OR REPLACE FUNCTION m03.fn_actualizar_ejemplar_post_evento_determinar_taxon()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE m03.ejemplar
    SET taxon_actual_id = NEW.taxon_nuevo
    WHERE id = (
        SELECT ejemplar_id
        FROM m03.evento
        WHERE evento.id = NEW.event_id
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tgr_post_evento_determinar_taxon
AFTER INSERT ON m03.evento_determinar_taxon
FOR EACH ROW
EXECUTE FUNCTION m03.fn_actualizar_ejemplar_post_evento_determinar_taxon();


-- separar en 2 triggers las validaciones???
CREATE OR REPLACE FUNCTION m03.fn_validar_taxon_para_accesion()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM m03.ejemplar
        WHERE id = NEW.ejemplar_id
        AND taxon_actual_id IS NOT NULL
        AND estado = 'adquisicion'
    ) THEN
        RAISE EXCEPTION
            'No se puede accesionar el ejemplar %, no tiene taxon determinado o ya esta accecionado',
            NEW.ejemplar_id;
    END IF;  

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tgr_fn_validar_taxon_para_accesion
BEFORE INSERT ON m03.evento
FOR EACH ROW
WHEN (NEW.tipo_evento = 'accesion')
EXECUTE FUNCTION m03.fn_validar_taxon_para_accesion();




CREATE OR REPLACE FUNCTION m03.fn_actualizar_ejemplar_post_evento_base_tipo_accesion()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE m03.ejemplar
    SET estado = 'accesionado',
        accesion_id = nextval('m03.accesion_seq')
    WHERE id = NEW.ejemplar_id
    AND estado = 'adquisicion'
    AND accesion_id IS NULL;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tgr_post_evento_base_tipo_accesion
AFTER INSERT ON m03.evento
FOR EACH ROW
WHEN (NEW.tipo_evento = 'accesion')
EXECUTE FUNCTION m03.fn_actualizar_ejemplar_post_evento_base_tipo_accesion();



-- Agregar validacion q evite acceder a un ejemplar sin estar transplantado
-- agregar validacion de checkeo anual?
--  y de tiempo para verificar q realmente paso un anio?