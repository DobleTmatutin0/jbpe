package ar.edu.unpsjb.jbpe.model.dto;

import ar.edu.unpsjb.jbpe.model.enumeration.TipoDeGermoplasma;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor

public class GermoplasmaColectadoDTO {

    @NotNull(message = "el tipo de germoplasma es obligatorio (not NULL)")
    private TipoDeGermoplasma tipoDeGermoplasma;

    @NotNull(message = "la cantidad colectada es obligatoria (not NULL)")
    private Integer cantidad;
}
