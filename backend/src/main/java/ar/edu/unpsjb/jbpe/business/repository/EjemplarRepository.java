package ar.edu.unpsjb.jbpe.business.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import ar.edu.unpsjb.jbpe.model.dto.EjemplarDTO;
import ar.edu.unpsjb.jbpe.model.entity.Ejemplar;

public interface EjemplarRepository extends  JpaRepository<Ejemplar, Integer>{
    // Default JpaRepository methods


    @Query("""
        SELECT new ar.edu.unpsjb.jbpe.model.dto.EjemplarDTO(
            e.id,
            e.adquisicionId,
            new ar.edu.unpsjb.jbpe.model.dto.NombreEspecieDTO(
                ne.id,
                ne.nombre,
                ne.linkFloraArg,
                ne.tipoDeSinonimia,
                new ar.edu.unpsjb.jbpe.model.dto.DetalleEspecieSummaryDTO(
                    de.id,
                    de.nombre
                ),
                new ar.edu.unpsjb.jbpe.model.dto.GeneroSummaryDTO(
                    g.id,
                    g.nombre
                ),
                new ar.edu.unpsjb.jbpe.model.dto.FamiliaSummaryDTO(
                    f.id,
                    f.nombre
                ),
                new ar.edu.unpsjb.jbpe.model.dto.OrdenSummaryDTO(
                    o.id,
                    o.nombre
                )
            ),
            e.estadoActual,
            e.recolectadoPor,
            e.fechaDeRecoleccion,
            new ar.edu.unpsjb.jbpe.model.dto.SitioDeRecoleccionDTO(
                sdr.id,
                sdr.nombre,
                sdr.latitud,
                sdr.longitud,
                sdr.altitud,
                sdr.locacionId,
                sdr.nombreLocacion,
                sdr.descripcion
            ),
            e.procedencia,
            e.observaciones,
            new ar.edu.unpsjb.jbpe.model.dto.SectorDTO(
                s.id,
                s.nombre,
                s.sectorLvl,
                s.sectorPadre.id,
                s.sectorPadre.nombre
            ),
            e.accesionId,
            e.nombreOriginal,
            e.nombreActual,
            e.nombreVulgar
        )
        FROM Ejemplar AS e
        LEFT JOIN e.taxonActual AS ne
        LEFT JOIN ne.detalleEspecie AS de
        LEFT JOIN de.genero AS g
        LEFT JOIN g.familia AS f
        LEFT JOIN f.orden AS o
        LEFT JOIN e.sitioDeRecoleccion AS sdr
        LEFT JOIN e.sectorActual AS s
        """)
    List<EjemplarDTO> getAll();

}
