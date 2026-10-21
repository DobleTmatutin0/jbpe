package ar.edu.unpsjb.jbpe.presenter;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import ar.edu.unpsjb.jbpe.Response;
import ar.edu.unpsjb.jbpe.business.service.EventoService;
import ar.edu.unpsjb.jbpe.model.dto.evento.create.EventoDeterminarTaxonCreateDTO;
import ar.edu.unpsjb.jbpe.model.dto.evento.create.EventoIngresoCreateDTO;
import jakarta.validation.Valid;

@RestController
@RequestMapping("evento")

public class EventoPresenter {
    private final EventoService eventoService;

    public EventoPresenter(EventoService eventoService) {
        this.eventoService = eventoService;
    }

    @GetMapping()
    public ResponseEntity<Object> findAll() {
        return Response.ok(eventoService.findAll());
    }

    @PostMapping("/evento-ingreso")
    public ResponseEntity<Object> createEventoIngreso(@Valid @RequestBody EventoIngresoCreateDTO aEventoIngresoCreateDTO) {
        return Response.ok(eventoService.saveEventoIngreso(aEventoIngresoCreateDTO));
    }

    @PostMapping("/evento-determinar-taxon")
    public ResponseEntity<Object> createEventoDeterminarTaxon(@Valid @RequestBody EventoDeterminarTaxonCreateDTO aEventoDeterminarTaxonCreateDTO) {
        return Response.ok(eventoService.saveEventoDeterminarTaxon(aEventoDeterminarTaxonCreateDTO));
    }

}
