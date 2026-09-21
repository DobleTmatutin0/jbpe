package ar.edu.unpsjb.jbpe.business.service;

import java.util.List;

import org.springframework.stereotype.Service;

import ar.edu.unpsjb.jbpe.business.repository.EjemplarRepository;
import ar.edu.unpsjb.jbpe.model.dto.EjemplarDTO;
import ar.edu.unpsjb.jbpe.model.dto.EjemplarMinDTO;

@Service

public  class EjemplarService {
    private final EjemplarRepository ejemplarRepository;

    public EjemplarService(EjemplarRepository ejemplarRepository) {
        this.ejemplarRepository = ejemplarRepository;
    }

    public List<EjemplarMinDTO> findAll() {
        List<EjemplarMinDTO> result = ejemplarRepository.getAll();
        return result;
    }

    public EjemplarDTO findByAdquisicionId(String anAdquisicionId) {
        return ejemplarRepository.getEjemplarById(anAdquisicionId);
    }
}
