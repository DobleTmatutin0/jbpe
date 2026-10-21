package ar.edu.unpsjb.jbpe.model.dto.evento.create;

import java.time.LocalDate;

import ar.edu.unpsjb.jbpe.model.enumeration.TipoDeEvento;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor

public class EventoCreateDTO {

    @NotNull(message = "El tipo de evento es obligatorio (not NULL)")
    private TipoDeEvento tipoDeEvento;

    @NotNull(message = "La fecha del evento es obligatorio (not NULL)")
    private LocalDate fecha;

    @NotNull(message = "El realizador de evento es obligatorio (not NULL)")
    private Integer realizadoPorId;

    @NotNull(message = "La adquisicion sobre la cual se efectua el evento es obligatoria (not NULL)")
    private Integer ejemplarId;

    private String observaciones;


}
