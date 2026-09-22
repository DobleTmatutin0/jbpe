package ar.edu.unpsjb.jbpe.business.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


import ar.edu.unpsjb.jbpe.business.repository.LocacionRepository;
import ar.edu.unpsjb.jbpe.business.repository.SitioDeRecoleccionRepository;
import ar.edu.unpsjb.jbpe.model.dto.SitioDeRecoleccionDTO;
import ar.edu.unpsjb.jbpe.model.entity.Locacion;
import ar.edu.unpsjb.jbpe.model.entity.SitioDeRecoleccion;

@Service

public class SitioDeRecoleccionService {
    private final SitioDeRecoleccionRepository sitioDeRecoleccionRepository;
    private final LocacionRepository locacionRepository;

    public  SitioDeRecoleccionService(
    SitioDeRecoleccionRepository sitioDeRecoleccionRepository,
    LocacionRepository locacionRepository
    ) {
        this.sitioDeRecoleccionRepository = sitioDeRecoleccionRepository;
        this.locacionRepository = locacionRepository;
    }

    public  List<SitioDeRecoleccionDTO> findAllDTO() {
        return this.sitioDeRecoleccionRepository.findAllDTO();
    }

    public SitioDeRecoleccionDTO findDTOById(Integer aSitioDeRecoleccionId) {
        return this.sitioDeRecoleccionRepository.findDTOById(aSitioDeRecoleccionId);
    }

    @Transactional
    public SitioDeRecoleccion save(SitioDeRecoleccionDTO aSitioDeRecoleccionDTO) {
        SitioDeRecoleccion sitioDeRecoleccionToSave = new SitioDeRecoleccion();

        sitioDeRecoleccionToSave.setNombre(aSitioDeRecoleccionDTO.getNombre());
        sitioDeRecoleccionToSave.setLatitud(aSitioDeRecoleccionDTO.getLatitud());
        sitioDeRecoleccionToSave.setLongitud(aSitioDeRecoleccionDTO.getLongitud());
        sitioDeRecoleccionToSave.setAltitud(aSitioDeRecoleccionDTO.getAltitud());
        Locacion locacionDelSitio = this.locacionRepository.getReferenceById(aSitioDeRecoleccionDTO.getLocacionId());
        sitioDeRecoleccionToSave.setLocacion(locacionDelSitio);
        sitioDeRecoleccionToSave.setDescripcion(aSitioDeRecoleccionDTO.getDescripcion());

        return sitioDeRecoleccionRepository.save(sitioDeRecoleccionToSave);
    }
}
