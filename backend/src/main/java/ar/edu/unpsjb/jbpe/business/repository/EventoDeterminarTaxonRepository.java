package ar.edu.unpsjb.jbpe.business.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import ar.edu.unpsjb.jbpe.model.entity.EventoDeterminarTaxon;

@Repository

public interface EventoDeterminarTaxonRepository extends JpaRepository<EventoDeterminarTaxon, Integer> {
    // Default JpaRepository methods

}
