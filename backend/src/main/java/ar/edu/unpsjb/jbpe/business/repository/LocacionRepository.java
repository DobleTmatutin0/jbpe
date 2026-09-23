package ar.edu.unpsjb.jbpe.business.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import ar.edu.unpsjb.jbpe.model.dto.LocacionDTO;
import ar.edu.unpsjb.jbpe.model.entity.Locacion;

@Repository

public interface LocacionRepository extends JpaRepository<Locacion, Integer> {
    // Default JpaRepository methods

    // agregar busqueda de lista
    @Query("""
        SELECT new ar.edu.unpsjb.jbpe.model.dto.LocacionDTO(
            l.id,
            l.nombre,
            l.locacionLvl,
            lp.id,
            lp.nombre
        )
        FROM Locacion AS l
            LEFT JOIN l.locacionPadre AS lp
    """)
    List<LocacionDTO> findAllDTO();

    // agregar busqueda por termino (typeahead)
    @Query("""
        SELECT new ar.edu.unpsjb.jbpe.model.dto.LocacionDTO(
            l.id,
            l.nombre,
            l.locacionLvl,
            lp.id,
            lp.nombre
        )
        FROM Locacion AS l
            LEFT JOIN l.locacionPadre AS lp
        WHERE l.id = :aLocacionId
    """)
    LocacionDTO findDTOById(@Param("aLocacionId") Integer aLocacionId);
}
