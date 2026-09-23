package ar.edu.unpsjb.jbpe.business.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import ar.edu.unpsjb.jbpe.model.entity.Persona;

@Repository

public interface PersonaRepository extends JpaRepository<Persona, Integer> {
    // Default methods from JpaRepository

}
