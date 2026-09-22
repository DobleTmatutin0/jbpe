package ar.edu.unpsjb.jbpe.business.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ar.edu.unpsjb.jbpe.business.repository.EjemplarRepository;
import ar.edu.unpsjb.jbpe.business.repository.SitioDeRecoleccionRepository;
import ar.edu.unpsjb.jbpe.model.dto.EjemplarDTO;
import ar.edu.unpsjb.jbpe.model.dto.EjemplarMinDTO;
import ar.edu.unpsjb.jbpe.model.entity.Ejemplar;

@Service

public  class EjemplarService {
    private final EjemplarRepository ejemplarRepository;
    private final SitioDeRecoleccionRepository sitioDeRecoleccionRepository;

    public EjemplarService(
        EjemplarRepository ejemplarRepository,
        SitioDeRecoleccionRepository sitioDeRecoleccionRepository
    ) {
        this.ejemplarRepository = ejemplarRepository;
        this.sitioDeRecoleccionRepository = sitioDeRecoleccionRepository;
    }

    public List<EjemplarMinDTO> findAll() {
        List<EjemplarMinDTO> result = ejemplarRepository.getAllDTO();
        return result;
    }

    public EjemplarDTO findByAdquisicionId(String anAdquisicionId) {
        return ejemplarRepository.findDTOById(anAdquisicionId);
    }

    @Transactional
    public Ejemplar save(EjemplarDTO anEjemplarDTO) {
        Ejemplar ejemplarToSave = new Ejemplar();

        ejemplarToSave.setRecolectadoPor(anEjemplarDTO.getRecolectadoPor());
        ejemplarToSave.setFechaDeRecoleccion(anEjemplarDTO.getFechaDeRecoleccion());
        ejemplarToSave.setSitioDeRecoleccion(sitioDeRecoleccionRepository.getReferenceById(anEjemplarDTO.getSitioDeRecoleccion().getId()));
        ejemplarToSave.setProcedencia(anEjemplarDTO.getProcedencia());
        ejemplarToSave.setObservaciones(anEjemplarDTO.getObservaciones());

        return ejemplarRepository.save(ejemplarToSave);
    }
}
