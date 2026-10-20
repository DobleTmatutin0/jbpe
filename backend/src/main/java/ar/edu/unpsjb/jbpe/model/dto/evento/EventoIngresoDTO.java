package ar.edu.unpsjb.jbpe.model.dto.evento;

import java.time.LocalDate;

import ar.edu.unpsjb.jbpe.model.dto.PersonaDTO;

import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor

public class EventoIngresoDTO extends EventoDTO {
    private Integer id;

    private LocalDate fechaDeDonacion;

    @Valid
    private PersonaDTO donadoPor;
}
