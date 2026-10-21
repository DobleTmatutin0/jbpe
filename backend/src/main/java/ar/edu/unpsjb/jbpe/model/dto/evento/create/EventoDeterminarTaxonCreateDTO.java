package ar.edu.unpsjb.jbpe.model.dto.evento.create;

import jakarta.validation.constraints.NotNull;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor

public class EventoDeterminarTaxonCreateDTO extends EventoCreateDTO {
    private Integer taxonViejo;

    @NotNull(message = "el taxon nuevo no puede ser null (NOT NULL)")
    private Integer taxonNuevo;

}
