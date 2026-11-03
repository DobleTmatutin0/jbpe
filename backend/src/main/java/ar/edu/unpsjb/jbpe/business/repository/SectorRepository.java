package ar.edu.unpsjb.jbpe.business.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import ar.edu.unpsjb.jbpe.model.entity.Sector;

public interface SectorRepository extends JpaRepository<Sector, Integer> {
    // default methods form Jparepository

}
