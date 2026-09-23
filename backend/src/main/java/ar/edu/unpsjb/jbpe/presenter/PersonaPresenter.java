package ar.edu.unpsjb.jbpe.presenter;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import ar.edu.unpsjb.jbpe.Response;
import ar.edu.unpsjb.jbpe.business.service.PersonaService;
import ar.edu.unpsjb.jbpe.model.dto.PersonaDTO;

@RestController
@RequestMapping("persona")

public class PersonaPresenter {
    private final PersonaService personaService;

    public  PersonaPresenter(PersonaService personaService) {
        this.personaService = personaService;
    }

    @GetMapping()
    public ResponseEntity<Object> findAll() {
        return Response.ok(personaService.findAll());
    }

    @GetMapping("/{aPersonaId}")
    public ResponseEntity<Object> findById(@PathVariable("aPersonaId") Integer aPersonaId) {
        return Response.ok(personaService.findById(aPersonaId));
    }

    @PostMapping()
    public ResponseEntity<Object> create(PersonaDTO aPersonaDTO) {
        if(aPersonaDTO.getId() != null) {
            Response.error(aPersonaDTO, "una nueva persona no puede tener id");
        }
        return Response.ok(personaService.save(aPersonaDTO));
    }

}
