package ar.edu.unpsjb.jbpe.business.service;

import java.util.List;

import org.springframework.stereotype.Service;

import ar.edu.unpsjb.jbpe.business.repository.EjemplarRepository;
import ar.edu.unpsjb.jbpe.model.dto.EjemplarDTO;
import ar.edu.unpsjb.jbpe.model.entity.Ejemplar;

@Service

public  class EjemplarService {
    private final EjemplarRepository ejemplarRepository;

    public EjemplarService(EjemplarRepository ejemplarRepository) {
        this.ejemplarRepository = ejemplarRepository;
    }

    public List<EjemplarDTO> findAll() {
        List<EjemplarDTO> result = ejemplarRepository.getAll();
        return result;
    }

    public List<Ejemplar> findAllEntities() {
        return ejemplarRepository.findAll();
    }
}
