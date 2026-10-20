package ar.edu.unpsjb.jbpe.model.dto.evento;

import ar.edu.unpsjb.jbpe.model.dto.PersonaDTO;
import ar.edu.unpsjb.jbpe.model.entity.Evento;
import ar.edu.unpsjb.jbpe.model.entity.Persona;
import ar.edu.unpsjb.jbpe.model.entity.Sector;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor

public class EventoTransplanteDTO extends EventoDTO {
    private Integer id;

    @NotNull(message = "El evento base no puede ser null (NOT NULL)")
    private Evento evento;

    @NotNull(message = "El sector no puede ser nulo (NOT NULL)")
    private Sector sectorInicial;

    @Valid
    @NotNull(message = "Se debe indicar quien realizo el trasplante (NOT NULL)")
    private PersonaDTO trasplantadoPor;

    private String comoFuePlantadoEnPredio;

}
