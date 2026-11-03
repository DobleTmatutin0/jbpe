package ar.edu.unpsjb.jbpe.model.dto.evento.create;

import ar.edu.unpsjb.jbpe.model.enumeration.RazonDeDesaccesion;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor

public class EventoDesaccesionCreateDTO extends EventoCreateDTO {
    @NotNull(message = "El motivo de desaccesion es obligatorio (NOT NULL)")
    private RazonDeDesaccesion motivo;

}
