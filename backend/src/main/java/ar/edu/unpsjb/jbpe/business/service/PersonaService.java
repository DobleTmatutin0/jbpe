package ar.edu.unpsjb.jbpe.business.service;

import java.util.List;

import org.springframework.stereotype.Service;

import ar.edu.unpsjb.jbpe.business.repository.PersonaRepository;
import ar.edu.unpsjb.jbpe.model.dto.PersonaDTO;
import ar.edu.unpsjb.jbpe.model.entity.Persona;

@Service

public class PersonaService {
    private final PersonaRepository personaRepository;

    public PersonaService(PersonaRepository personaRepository) {
        this.personaRepository = personaRepository;
    }

    public List<Persona> findAll() {
        return personaRepository.findAll();
    }

    public  Persona findById(Integer aPersonaId) {
        return personaRepository.findById(aPersonaId).orElse(null);
    }

    public Persona save(PersonaDTO aPersonaDTO) {
        Persona personaToSave = new Persona();

        personaToSave.setNombre(aPersonaDTO.getNombre());
        personaToSave.setApellido(aPersonaDTO.getApellido());
        personaToSave.setTipoDePersona(aPersonaDTO.getTipoDePersona());

        return personaRepository.save(personaToSave);
    }

}
