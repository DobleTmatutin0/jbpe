package ar.edu.unpsjb.jbpe.model.dto.evento;

import java.time.LocalDate;

import ar.edu.unpsjb.jbpe.model.dto.PersonaDTO;
import ar.edu.unpsjb.jbpe.model.enumeration.TipoDeEvento;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor

public class EventoDTO {
    private Long idBase;

    @NotNull(message = "El tipo de evento es obligatorio (not NULL)")
    private TipoDeEvento tipoDeEvento;

    @NotNull(message = "La fecha del evento es obligatorio (not NULL)")
    private LocalDate fecha;

    @Valid
    @NotNull(message = "El realizador de evento es obligatorio (not NULL)")
    private PersonaDTO realizadoPor;

    // se borro el adquisicion id porq no aporta nada en el get
    private String observaciones;
}
