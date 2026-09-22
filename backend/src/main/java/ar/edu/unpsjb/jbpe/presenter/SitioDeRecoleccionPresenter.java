package ar.edu.unpsjb.jbpe.presenter;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import ar.edu.unpsjb.jbpe.Response;
import ar.edu.unpsjb.jbpe.business.service.SitioDeRecoleccionService;
import ar.edu.unpsjb.jbpe.model.dto.SitioDeRecoleccionDTO;

@RestController
@RequestMapping("sitioDeRecoleccion")

public class SitioDeRecoleccionPresenter {
    private final SitioDeRecoleccionService sitioDeRecoleccionService;

    public SitioDeRecoleccionPresenter(SitioDeRecoleccionService sitioDeRecoleccionService) {
        this.sitioDeRecoleccionService = sitioDeRecoleccionService;
    }

    @GetMapping()
    public ResponseEntity<Object> findAll() {
        return Response.ok(sitioDeRecoleccionService.findAllDTO());
    }

    @GetMapping("/{sitioDeRecoleccionID}")
    public ResponseEntity<Object> findById(@PathVariable("sitioDeRecoleccionID") Integer aSitioDeRecoleccionId) {
        return Response.ok(sitioDeRecoleccionService.findDTOById(aSitioDeRecoleccionId));
    }

    @PostMapping()
    public ResponseEntity<Object> create(SitioDeRecoleccionDTO aSitioDeRecoleccionDTO) {
        if(aSitioDeRecoleccionDTO.getId() != null) {
            return Response.error(aSitioDeRecoleccionDTO, "un nuevo sitio de recoleccion no puede tener id");
        }
        return Response.ok(sitioDeRecoleccionService.save(aSitioDeRecoleccionDTO));
    }
}
