package ar.edu.unpsjb.jbpe.business.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import ar.edu.unpsjb.jbpe.model.entity.EventoDesaccesion;

@Repository

public interface EventoDesaccesionRepository extends JpaRepository<EventoDesaccesion, Integer> {
    // Default JpaRepository methods

}
