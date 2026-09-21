package ar.edu.unpsjb.jbpe.presenter;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import ar.edu.unpsjb.jbpe.Response;
import ar.edu.unpsjb.jbpe.business.service.EjemplarService;

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

    @GetMapping("/test")
    public ResponseEntity<Object> test() {
        return Response.ok(ejemplarService.findAllEntities());
    }

}
