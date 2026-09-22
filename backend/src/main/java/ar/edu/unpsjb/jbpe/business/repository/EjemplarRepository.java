package ar.edu.unpsjb.jbpe.business.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import ar.edu.unpsjb.jbpe.model.dto.EjemplarDTO;
import ar.edu.unpsjb.jbpe.model.dto.EjemplarMinDTO;
import ar.edu.unpsjb.jbpe.model.entity.Ejemplar;

@Repository

public interface EjemplarRepository extends JpaRepository<Ejemplar, Integer> {
    // Default JpaRepository methods

    @Query("""
        SELECT new ar.edu.unpsjb.jbpe.model.dto.EjemplarMinDTO(
            e.id,
            e.adquisicionId,
            new ar.edu.unpsjb.jbpe.model.dto.summary.NombreEspecieSummaryDTO(
                ne.id,
                ne.nombre
            ),
            e.estadoActual
        )
        FROM  Ejemplar As e
            LEFT JOIN e.taxonActual as ne
    """)
    List<EjemplarMinDTO> getAllDTO();

    @Query("""
        SELECT new ar.edu.unpsjb.jbpe.model.dto.EjemplarDTO(
            e.id,
            e.adquisicionId,
            new ar.edu.unpsjb.jbpe.model.dto.NombreEspecieDTO(
                ne.id,
                ne.nombre,
                ne.linkFloraArg,
                ne.tipoDeSinonimia,
                new ar.edu.unpsjb.jbpe.model.dto.summary.DetalleEspecieSummaryDTO(
                    de.id,
                    de.nombreAceptado
                ),
                new ar.edu.unpsjb.jbpe.model.dto.summary.GeneroSummaryDTO(
                    g.id,
                    g.nombre
                ),
                new ar.edu.unpsjb.jbpe.model.dto.summary.FamiliaSummaryDTO(
                    f.id,
                    f.nombre
                ),
                new ar.edu.unpsjb.jbpe.model.dto.summary.OrdenSummaryDTO(
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
                l.id,
                l.nombre,
                sdr.descripcion
            ),
            e.procedencia,
            e.observaciones,
            new ar.edu.unpsjb.jbpe.model.dto.SectorDTO(
                s.id,
                s.nombre,
                s.sectorLvl,
                sp.id,
                sp.nombre
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
            LEFT JOIN sdr.locacion AS l
            LEFT JOIN e.sectorActual AS s
            LEFT JOIN s.sectorPadre AS sp
        WHERE e.adquisicionId = :anAdquisicionId
        """)
    EjemplarDTO findDTOById(@Param("anAdquisicionId") String anAdquisicionId);

}
