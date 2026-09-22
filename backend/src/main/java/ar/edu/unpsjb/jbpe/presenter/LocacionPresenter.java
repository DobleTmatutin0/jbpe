package ar.edu.unpsjb.jbpe.presenter;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import ar.edu.unpsjb.jbpe.Response;
import ar.edu.unpsjb.jbpe.business.service.LocacionService;
import ar.edu.unpsjb.jbpe.model.dto.LocacionDTO;

@RestController
@RequestMapping("locacion")

public class LocacionPresenter {
    private final LocacionService locacionService;

    public LocacionPresenter(LocacionService locacionService) {
        this.locacionService = locacionService;
    }

    @GetMapping()
    public ResponseEntity<Object> findAll() {
        return Response.ok(locacionService.findAll());
    }

    @GetMapping("/{locacionId}")
    public ResponseEntity<Object> findById(@RequestParam("locacionId") Integer aLocacionId) {
        return Response.ok(locacionService.findDTOById(aLocacionId));
    }

    @PostMapping()
    public ResponseEntity<Object> create(LocacionDTO aLocacionDTO) {
        if (aLocacionDTO.getId() != null) {
            return Response.error(aLocacionDTO, "una nueva locacion no puede tener id");
        }
        return Response.ok(locacionService.save(aLocacionDTO));
    }

}
