package ar.edu.unpsjb.jbpe.presenter;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import ar.edu.unpsjb.jbpe.Response;
import ar.edu.unpsjb.jbpe.business.service.EventoService;
import ar.edu.unpsjb.jbpe.model.dto.evento.create.EventoCheckeoAnualCreateDTO;
import ar.edu.unpsjb.jbpe.model.dto.evento.create.EventoCreateDTO;
import ar.edu.unpsjb.jbpe.model.dto.evento.create.EventoDesaccesionCreateDTO;
import ar.edu.unpsjb.jbpe.model.dto.evento.create.EventoDeterminarTaxonCreateDTO;
import ar.edu.unpsjb.jbpe.model.dto.evento.create.EventoIngresoCreateDTO;
import ar.edu.unpsjb.jbpe.model.dto.evento.create.EventoTrasplanteCreateDTO;
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

    @PostMapping("/ingreso")
    public ResponseEntity<Object> createEventoIngreso(@Valid @RequestBody EventoIngresoCreateDTO aEventoIngresoCreateDTO) {
        return Response.ok(eventoService.saveEventoIngreso(aEventoIngresoCreateDTO));
    }

    @PostMapping("/accesion")
    public ResponseEntity<Object> createEventoAccesion(@Valid @RequestBody EventoCreateDTO aEventoAccecionCreateDTO) {
        return Response.ok(eventoService.saveEventoAccecion(aEventoAccecionCreateDTO));
    }

    @PostMapping("/determinar-taxon")
    public ResponseEntity<Object> createEventoDeterminarTaxon(@Valid @RequestBody EventoDeterminarTaxonCreateDTO aEventoDeterminarTaxonCreateDTO) {
        return Response.ok(eventoService.saveEventoDeterminarTaxon(aEventoDeterminarTaxonCreateDTO));
    }

    @PostMapping("/trasplante")
    public ResponseEntity<Object> createEventoTrasplante(@Valid @RequestBody EventoTrasplanteCreateDTO aEventoTrasplanteCreateDTO) {
        return Response.ok(eventoService.saveEventoTrasplante(aEventoTrasplanteCreateDTO));
    }

    @PostMapping("/checkeo-anual")
    public  ResponseEntity<Object> create (@Valid @RequestBody EventoCheckeoAnualCreateDTO aEventoCheckeoAnualCreateDTO) {
        return Response.ok(eventoService.saveEventoCheckeoAnual(aEventoCheckeoAnualCreateDTO));
    }

    @PostMapping("/desaccesion")
    public  ResponseEntity<Object> create (@Valid @RequestBody EventoDesaccesionCreateDTO aEventoDesaccesionCreateDTO) {
        return Response.ok(eventoService.saveEventoDesaccesion(aEventoDesaccesionCreateDTO));
    }
}
