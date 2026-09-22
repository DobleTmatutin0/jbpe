package ar.edu.unpsjb.jbpe.business.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ar.edu.unpsjb.jbpe.business.repository.LocacionRepository;
import ar.edu.unpsjb.jbpe.model.dto.LocacionDTO;
import ar.edu.unpsjb.jbpe.model.entity.Locacion;

@Service

public class LocacionService {
    private final LocacionRepository locacionRepository;

    public LocacionService(LocacionRepository locacionRepository) {
        this.locacionRepository = locacionRepository;
    }

    public List<LocacionDTO> findAll() {
        return locacionRepository.findAllDTO();
    }

    public LocacionDTO findDTOById(Integer aLocacionId) {
        return locacionRepository.findDTOById(aLocacionId);
    }

    @Transactional
    public Locacion save(LocacionDTO aLocacionDTO) {
        Locacion locacionToSave = new Locacion();

        locacionToSave.setLocacionLvl(aLocacionDTO.getLocacionLvl());
        locacionToSave.setLocacionPadre(locacionRepository.getReferenceById(aLocacionDTO.getLocacionPadreId()));
        locacionToSave.setNombre(aLocacionDTO.getNombre());

        return locacionRepository.save(locacionToSave);
    }
}
