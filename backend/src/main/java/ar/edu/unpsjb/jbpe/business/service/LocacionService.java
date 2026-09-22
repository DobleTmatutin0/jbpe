package ar.edu.unpsjb.jbpe.business.service;

import org.springframework.stereotype.Service;

import ar.edu.unpsjb.jbpe.business.repository.LocacionRepository;
import ar.edu.unpsjb.jbpe.model.dto.LocacionDTO;

@Service

public class LocacionService {
    private final LocacionRepository locacionRepository;

    public LocacionService(LocacionRepository locacionRepository) {
        this.locacionRepository = locacionRepository;
    }

    public LocacionDTO findDTOById(Integer aLocacionId) {
        return locacionRepository.findDTOById(aLocacionId);
    }
}
