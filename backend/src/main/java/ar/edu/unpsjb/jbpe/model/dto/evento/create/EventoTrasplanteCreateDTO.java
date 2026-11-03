package ar.edu.unpsjb.jbpe.model.dto.evento.create;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor

public class EventoTrasplanteCreateDTO extends EventoCreateDTO {

    @NotNull(message = "El sector no puede ser nulo (NOT NULL)")
    private Integer sectorInicialId;

    @NotNull(message = "Se debe indicar quien realizo el trasplante (NOT NULL)")
    private Integer trasplantadoPorId;

    private String comoFuePlantadoEnPredio;
}
