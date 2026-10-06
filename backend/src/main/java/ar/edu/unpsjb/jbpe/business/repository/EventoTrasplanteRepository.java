package ar.edu.unpsjb.jbpe.business.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import ar.edu.unpsjb.jbpe.model.entity.EventoTrasplante;

public interface EventoTrasplanteRepository extends JpaRepository<EventoTrasplante, Integer> {
    // Default JpaRepository methods

}
