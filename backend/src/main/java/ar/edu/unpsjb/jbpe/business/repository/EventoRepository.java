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
            new ar.edu.unpsjb.jbpe.model.dto.PersonaDTO(
                p.id,
                p.nombre,
                p.apellido,
                p.tipoDePersona
            ),
            e.adquisicionId,
            ev.observaciones
        )
        FROM Evento AS ev
            LEFT JOIN ev.ejemplar AS e
            LEFT JOIN ev.realizadoPor AS p
    """)
    List<EventoDTO> findAllDTO();


}
