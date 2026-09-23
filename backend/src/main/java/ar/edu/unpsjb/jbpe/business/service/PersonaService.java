package ar.edu.unpsjb.jbpe.business.service;

import org.springframework.stereotype.Service;

import ar.edu.unpsjb.jbpe.business.repository.PersonaRepository;

@Service

public class PersonaService {
    private final PersonaRepository personaRepository;

    public PersonaService(PersonaRepository personaRepository) {
        this.personaRepository = personaRepository;
    }



}
