-- ========================================================
-- migracion de ordenes
-- ========================================================
SELECT DISTINCT TRIM(LOWER(ff.orden))
FROM jbpe.flora_familias as ff
where ff.orden is not null
ORDER BY 1;


insert into m03.orden as o (nombre)
SELECT DISTINCT TRIM(LOWER(ff.orden))
FROM jbpe.flora_familias as ff
where ff.orden is not null
ORDER BY 1;



-- ========================================================
-- migracion de familias
-- ========================================================
SELECT orden, COUNT(familia)
FROM jbpe.flora_familias
GROUP BY orden


SELECT 
	o.nombre,
	o.id,
	TRIM(LOWER(ff.familia)),
    'https://buscador.floraargentina.edu.ar' || ff.link_familia
FROM jbpe.flora_familias ff
JOIN m03.orden o
ON TRIM(LOWER(ff.orden)) = o.nombre
ORDER BY o.nombre;


INSERT INTO m03.familia (nombre, link_flora_arg, orden_id)
SELECT 
	TRIM(LOWER(ff.familia)),
    'https://buscador.floraargentina.edu.ar' || ff.link_familia,
	o.id
FROM jbpe.flora_familias ff
JOIN m03.orden o
ON TRIM(LOWER(ff.orden)) = o.nombre;



-- ========================================================
-- migracion de generos
-- ========================================================
SELECT DISTINCT
    TRIM(LOWER(fe.familia)) AS familia,
    TRIM(LOWER(fe.genero)) AS genero
FROM jbpe.flora_especies fe
WHERE fe.genero IS NOT NULL
ORDER BY 1, 2;


INSERT INTO m03.genero (nombre, familia_id, link_flora_arg)
SELECT DISTINCT ON (TRIM(LOWER(fe.genero)), f.id)
    TRIM(LOWER(fe.genero)) AS nombre,
    f.id AS familia_id,
    'https://buscador.floraargentina.edu.ar' || TRIM(fe.link_genero) AS link_flora_arg
FROM jbpe.flora_especies fe
JOIN m03.familia f
    ON f.nombre = TRIM(LOWER(fe.familia))
WHERE fe.genero IS NOT NULL
ORDER BY
    TRIM(LOWER(fe.genero)),
    f.id,
    CASE WHEN TRIM(fe.link_genero) = '' THEN 1 ELSE 0 END;



-- ========================================================
-- migracion de especies
-- ========================================================
select * from jbpe.flora_especies fe

SELECT
    TRIM(LOWER(fe.especie)) AS especie,
    COUNT(*)
FROM jbpe.flora_especies fe
WHERE fe.especie IS NOT NULL
GROUP BY 1
ORDER BY COUNT(*) DESC;

SELECT
    TRIM(LOWER(fe.especie)),
    COUNT(DISTINCT TRIM(LOWER(fe.genero)))
FROM jbpe.flora_especies fe
GROUP BY 1
HAVING COUNT(DISTINCT TRIM(LOWER(fe.genero))) > 1;

SELECT
    fe.genero,
    fe.especie,
    fe.link_especie
FROM jbpe.flora_especies fe
WHERE TRIM(LOWER(fe.especie)) IN (
    SELECT TRIM(LOWER(fe.especie))
    FROM jbpe.flora_especies
    GROUP BY 1
    HAVING COUNT(DISTINCT TRIM(LOWER(genero))) > 1
)
ORDER BY fe.especie;

-- fallo porq hay especies que tiene el mosmo nombre como sinonimo y como aceptado
INSERT INTO m03.nombre_especie (nombre, detalle_id, tipo_nombre, link_flora_arg)
SELECT DISTINCT ON (TRIM(LOWER(fe.especie)))
    TRIM(LOWER(fe.especie)) AS nombre,
    de.id AS detalle_id,
    'synonym' AS tipo_nombre,
    'https://buscador.floraargentina.edu.ar' || TRIM(fe.link_especie) AS link_flora_arg
FROM jbpe.flora_especies fe
JOIN m03.detalle_especie de
    ON de.link_flora_arg = 'https://buscador.floraargentina.edu.ar' || TRIM(fe.link_detalle)
WHERE fe.especie IS NOT NULL
  AND TRIM(fe.especie) <> ''
  AND LOWER(TRIM(fe.especie)) <> 'error'
  AND fe.link_especie IS NOT NULL
  AND TRIM(fe.link_especie) <> ''
  AND fe.link_detalle IS NOT NULL
  AND TRIM(fe.link_detalle) <> ''
  AND fe.link_especie LIKE '%/synonyms/%'
ORDER BY
    TRIM(LOWER(fe.especie)),
    CASE WHEN TRIM(fe.link_especie) = '' THEN 1 ELSE 0 END;

-- permite ver los nombres de las especies y la cantidad de sinonimos y aceptados que tiene 
SELECT
    TRIM(LOWER(fe.especie)) AS especie,
    COUNT(*) AS total_filas,
    COUNT(*) FILTER (
        WHERE fe.link_especie NOT LIKE '%/synonyms/%'
    ) AS cant_aceptados,
    COUNT(*) FILTER (
        WHERE fe.link_especie LIKE '%/synonyms/%'
    ) AS cant_sinonimos
FROM jbpe.flora_especies fe
WHERE fe.especie IS NOT NULL
  AND TRIM(fe.especie) <> ''
  AND LOWER(TRIM(fe.especie)) <> 'error'
GROUP BY 1
HAVING COUNT(*) FILTER (
           WHERE fe.link_especie NOT LIKE '%/synonyms/%'
       ) > 0
   AND COUNT(*) FILTER (
           WHERE fe.link_especie LIKE '%/synonyms/%'
       ) > 0
ORDER BY 1;


-- permite ver los detalles de las especies que repiten su nombre como sinonimo y aceptado
SELECT
    fe.*
FROM jbpe.flora_especies fe
WHERE TRIM(LOWER(fe.especie)) IN (
    SELECT TRIM(LOWER(fe2.especie))
    FROM jbpe.flora_especies fe2
    WHERE fe2.especie IS NOT NULL
      AND TRIM(fe2.especie) <> ''
      AND LOWER(TRIM(fe2.especie)) <> 'error'
    GROUP BY 1
    HAVING COUNT(*) FILTER (
               WHERE fe2.link_especie NOT LIKE '%/synonyms/%'
           ) > 0
       AND COUNT(*) FILTER (
               WHERE fe2.link_especie LIKE '%/synonyms/%'
           ) > 0
)
ORDER BY TRIM(LOWER(fe.especie)), fe.link_especie;



-- cuenta cuantas filas quedan sacando los sinonimos con el nombre mal puesto
SELECT COUNT(*)
FROM (
    SELECT DISTINCT ON (TRIM(LOWER(fe.especie)))
        TRIM(LOWER(fe.especie)) AS nombre,
        de.id AS detalle_id,
        'synonym' AS tipo_nombre,
        'https://buscador.floraargentina.edu.ar' || TRIM(fe.link_especie) AS link_flora_arg
    FROM jbpe.flora_especies fe
    JOIN m03.detalle_especie de
        ON de.link_flora_arg = 'https://buscador.floraargentina.edu.ar' || TRIM(fe.link_detalle)
    WHERE fe.especie IS NOT NULL
      AND TRIM(fe.especie) <> ''
      AND LOWER(TRIM(fe.especie)) <> 'error'
      AND fe.link_especie IS NOT NULL
      AND TRIM(fe.link_especie) <> ''
      AND fe.link_detalle IS NOT NULL
      AND TRIM(fe.link_detalle) <> ''
      AND fe.link_especie LIKE '%/synonyms/%'
      AND TRIM(LOWER(fe.especie)) NOT IN (
          SELECT TRIM(LOWER(fe2.especie))
          FROM jbpe.flora_especies fe2
          WHERE fe2.especie IS NOT NULL
            AND TRIM(fe2.especie) <> ''
            AND LOWER(TRIM(fe2.especie)) <> 'error'
          GROUP BY 1
          HAVING COUNT(*) FILTER (
                     WHERE fe2.link_especie NOT LIKE '%/synonyms/%'
                 ) > 0
             AND COUNT(*) FILTER (
                     WHERE fe2.link_especie LIKE '%/synonyms/%'
                 ) > 0
      )
    ORDER BY
        TRIM(LOWER(fe.especie)),
        'https://buscador.floraargentina.edu.ar' || TRIM(fe.link_especie)
) t;



-- migra los sinonimos que no tienen nombre especie repetido
INSERT INTO m03.nombre_especie (nombre, detalle_id, tipo_nombre, link_flora_arg)
SELECT DISTINCT ON (TRIM(LOWER(fe.especie)))
    TRIM(LOWER(fe.especie)) AS nombre,
    de.id AS detalle_id,
    'synonym' AS tipo_nombre,
    'https://buscador.floraargentina.edu.ar' || TRIM(fe.link_especie) AS link_flora_arg
FROM jbpe.flora_especies fe
JOIN m03.detalle_especie de
    ON de.link_flora_arg = 'https://buscador.floraargentina.edu.ar' || TRIM(fe.link_detalle)
WHERE fe.especie IS NOT NULL
  AND TRIM(fe.especie) <> ''
  AND LOWER(TRIM(fe.especie)) <> 'error'
  AND fe.link_especie IS NOT NULL
  AND TRIM(fe.link_especie) <> ''
  AND fe.link_detalle IS NOT NULL
  AND TRIM(fe.link_detalle) <> ''
  AND fe.link_especie LIKE '%/synonyms/%'
  AND TRIM(LOWER(fe.especie)) NOT IN (
      SELECT TRIM(LOWER(fe2.especie))
      FROM jbpe.flora_especies fe2
      WHERE fe2.especie IS NOT NULL
        AND TRIM(fe2.especie) <> ''
        AND LOWER(TRIM(fe2.especie)) <> 'error'
      GROUP BY 1
      HAVING COUNT(*) FILTER (
                 WHERE fe2.link_especie NOT LIKE '%/synonyms/%'
             ) > 0
         AND COUNT(*) FILTER (
                 WHERE fe2.link_especie LIKE '%/synonyms/%'
             ) > 0
  )
ORDER BY
    TRIM(LOWER(fe.especie)),
    'https://buscador.floraargentina.edu.ar' || TRIM(fe.link_especie);