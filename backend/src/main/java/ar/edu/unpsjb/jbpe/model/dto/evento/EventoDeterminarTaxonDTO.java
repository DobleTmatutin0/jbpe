package ar.edu.unpsjb.jbpe.model.dto.evento;

import ar.edu.unpsjb.jbpe.model.entity.Evento;
import ar.edu.unpsjb.jbpe.model.entity.NombreEspecie;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor

public class EventoDeterminarTaxonDTO extends EventoDTO {
    private Integer id;

    @NotNull(message = "el evento base no puede ser null (NOT NULL)")
    private Evento evento;

    private NombreEspecie taxonViejo;

    @NotNull(message = "el taxon nuevo no puede ser null (NOT NULL)")
    private NombreEspecie taxonNuevo;

}
