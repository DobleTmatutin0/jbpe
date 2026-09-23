package ar.edu.unpsjb.jbpe.presenter;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import ar.edu.unpsjb.jbpe.business.service.PersonaService;

@RestController
@RequestMapping("persona")

public class PersonaPresenter {
    private final PersonaService personaService;

    public  PersonaPresenter(PersonaService personaService) {
        this.personaService = personaService;
    }



}
