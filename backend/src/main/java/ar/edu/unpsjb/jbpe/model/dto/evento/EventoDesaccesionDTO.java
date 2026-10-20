package ar.edu.unpsjb.jbpe.model.dto.evento;

import ar.edu.unpsjb.jbpe.model.entity.Evento;
import ar.edu.unpsjb.jbpe.model.enumeration.RazonDeDesaccesion;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor

public class EventoDesaccesionDTO extends EventoDTO {
    private Integer id;

    @NotNull(message = "El el evento base es obligatorio (NOT NULL)")
    private Evento evento;

    @NotNull(message = "El motivo de desaccesion es obligatorio (NOT NULL)")
    private RazonDeDesaccesion motivo;

}
