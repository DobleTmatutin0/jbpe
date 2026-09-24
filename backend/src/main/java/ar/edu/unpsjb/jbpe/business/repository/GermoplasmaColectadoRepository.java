package ar.edu.unpsjb.jbpe.business.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import ar.edu.unpsjb.jbpe.model.entity.GermoplasmaColectado;

@Repository

public interface GermoplasmaColectadoRepository extends JpaRepository<GermoplasmaColectado, Integer> {
    // Default JpaRepository methods

}
