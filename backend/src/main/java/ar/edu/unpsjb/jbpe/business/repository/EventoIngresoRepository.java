package ar.edu.unpsjb.jbpe.business.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import ar.edu.unpsjb.jbpe.model.entity.EventoIngreso;

@Repository

public interface EventoIngresoRepository extends JpaRepository<EventoIngreso, Integer> {
    // Default JpaRepository methods

}
