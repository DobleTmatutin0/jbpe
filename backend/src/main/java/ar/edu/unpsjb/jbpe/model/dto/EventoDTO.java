package ar.edu.unpsjb.jbpe.model.dto;

import java.time.LocalDate;

import ar.edu.unpsjb.jbpe.model.enumeration.TipoDeEvento;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor

public class EventoDTO {
    private Long id;

    @NotNull(message = "El tipo de evento es obligatorio (not NULL)")
    private TipoDeEvento tipoDeEvento;

    @NotNull(message = "La fecha del evento es obligatorio (not NULL)")
    private LocalDate fecha;

    @Valid
    @NotNull(message = "El realizador de evento es obligatorio (not NULL)")
    private PersonaDTO realizadoPor;

    @NotNull(message = "La adquisicion sobre la cual se efectua el evento es obligatoria (not NULL)")
    private String adquisicionId;

    private String observaciones;
}
