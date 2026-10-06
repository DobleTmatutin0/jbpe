package ar.edu.unpsjb.jbpe.business.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import ar.edu.unpsjb.jbpe.model.entity.EventoCheckeoAnual;

@Repository

public interface EventoCheckeoAnualRepository extends JpaRepository<EventoCheckeoAnual, Integer> {
    // Default JpaRepository methods

}
