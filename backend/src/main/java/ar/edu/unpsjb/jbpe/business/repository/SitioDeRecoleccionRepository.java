package ar.edu.unpsjb.jbpe.business.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import ar.edu.unpsjb.jbpe.model.dto.SitioDeRecoleccionDTO;
import ar.edu.unpsjb.jbpe.model.entity.SitioDeRecoleccion;

@Repository

public interface SitioDeRecoleccionRepository extends JpaRepository<SitioDeRecoleccion, Integer> {
    // Default JpaRepository methods

    // agregar busqueda de lista
    @Query("""
        SELECT new ar.edu.unpsjb.jbpe.model.dto.SitioDeRecoleccionDTO(
            sdr.id,
            sdr.nombre,
            sdr.latitud,
            sdr.longitud,
            sdr.altitud,
            l.id,
            l.nombre,
            sdr.descripcion
        )
        FROM SitioDeRecoleccion AS sdr
            LEFT JOIN sdr.locacion AS l
    """)
    List<SitioDeRecoleccionDTO> findAllDTO();

    // agregar busqueda por termino

    @Query("""
        SELECT new ar.edu.unpsjb.jbpe.model.dto.SitioDeRecoleccionDTO(
            sdr.id,
            sdr.nombre,
            sdr.latitud,
            sdr.longitud,
            sdr.altitud,
            l.id,
            l.nombre,
            sdr.descripcion
        )
        FROM SitioDeRecoleccion AS sdr
            LEFT JOIN sdr.locacion AS l
        WHERE sdr.id = :aSitioDeRecoleccionId
    """)
    SitioDeRecoleccionDTO findDTOById(@Param("aSitioDeRecoleccionId") Integer aSitioDeRecoleccionId);
}
