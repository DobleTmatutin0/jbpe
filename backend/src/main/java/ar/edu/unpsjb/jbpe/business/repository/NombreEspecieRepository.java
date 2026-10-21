package ar.edu.unpsjb.jbpe.business.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import ar.edu.unpsjb.jbpe.model.entity.NombreEspecie;

public interface NombreEspecieRepository extends JpaRepository <NombreEspecie, Integer> {
    // Default JpaRepository methods

}
