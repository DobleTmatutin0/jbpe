package ar.edu.unpsjb.jbpe.presenter;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import ar.edu.unpsjb.jbpe.Response;
import ar.edu.unpsjb.jbpe.business.service.EjemplarService;
import ar.edu.unpsjb.jbpe.model.dto.EjemplarDTO;
import jakarta.validation.Valid;

@RestController
@RequestMapping("ejemplar")

public class EjemplarPresenter {
    private final EjemplarService ejemplarService;

    public EjemplarPresenter(EjemplarService ejemplarService) {
        this.ejemplarService = ejemplarService;
    }

    @GetMapping()
    public ResponseEntity<Object> findAll() {
        return Response.ok(ejemplarService.findAll());
    }

    @GetMapping("/{adquisicionId}")
    public ResponseEntity<Object> findByAdquisicionId(@PathVariable("adquisicionId") String anAdquisicionId) {
        return Response.ok(ejemplarService.findByAdquisicionId(anAdquisicionId));
    }

    @PostMapping()
    public ResponseEntity<Object> create(@Valid @RequestParam EjemplarDTO anEjemplarDTO) {
        if (anEjemplarDTO.getId() != null) {
            return Response.error(anEjemplarDTO, "un nuevo ejemplar no puede tener id");
        }
        return Response.ok(ejemplarService.save(anEjemplarDTO));
    }
}
