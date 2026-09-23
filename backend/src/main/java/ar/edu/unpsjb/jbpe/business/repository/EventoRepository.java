package ar.edu.unpsjb.jbpe.business.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import ar.edu.unpsjb.jbpe.model.dto.EventoDTO;
import ar.edu.unpsjb.jbpe.model.entity.Evento;

@Repository

public interface EventoRepository extends JpaRepository<Evento, Integer> {
    // Default JpaRepository methods

    @Query("""
        SELECT new ar.edu.unpsjb.jbpe.model.dto.EventoDTO(
            ev.id,
            ev.tipoDeEvento,
            ev.fecha,
            ev.realizadoPor,
            e.adquisicionId,
            ev.observaciones
        )
        FROM Evento AS ev
            LEFT JOIN ev.ejemplar AS e
    """)
    List<EventoDTO> findAllDTO();


}
