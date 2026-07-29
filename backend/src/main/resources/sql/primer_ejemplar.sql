-- ==================================
-- Inicio Adquisicion
-- ==================================
select * from m03.nombre_especie ne where ne.nombre Like  '%caldenia%'

insert into m03.ejemplar (procedencia, observaciones)
values ('cultivada_a_partir_de_material_silvestre', '...')

select * from m03.ejemplar e

insert into m03.germoplasma_colectado (adquisicion_id, tipo_germoplasma)
values (1, 'semilla'),
	(1, 'propágulo')

insert into m03.locacion (locacion_lvl, parent_id, nombre)
values ('country', null, 'Argentina'),
	('stateprovince', 1, 'La Pampa'),
	('locality', 2, 'Perú')

select * from m03.locacion l 

insert into m03.sitio_recoleccion (nombre, fecha_recoleccion, locacion_id, descripcion)
values ('Camino a Santa Rosa de La Pampa (sobre Ruta 35), pasando Río Colorado y próximo a Perú', '21/12/2018', 3, 'Caldenal en los bordes de la ruta') -- las fechas estan en formato arg

select * from m03.sitio_recoleccion 


insert into m03.persona (tipo_persona, nombre, apellido)
values ('donador', 'Ana M.', 'Cenzano'),
	('otro', 'seba', 'ortega')
	
select * from m03.persona p 
		
insert into m03.evento (tipo_evento, fecha, realizado_por, ejemplar_id)
values ('ingreso', '24/3/2026', 2, 1) -- las fechas estan en formato arg

insert into m03.evento_ingreso (event_id, sitio_recoleccion_id, fecha_donacion)
values (1, 1, '10/4/2025') -- las fechas estan en formato arg

select * from m03.evento_ingreso ei

insert into m03.evento (tipo_evento, fecha, realizado_por, ejemplar_id)
values ('redeterminacion_taxonomica', '25/3/2026', 1, 1)

select * from m03.evento e 

insert into m03.evento_determinar_taxon (event_id, taxon_nuevo)
values (2, 12667)

-- ==================================
-- Fin Adquisicion
-- ==================================