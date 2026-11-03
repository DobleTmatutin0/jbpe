package ar.edu.unpsjb.jbpe.model.dto.evento.create;

import java.math.BigDecimal;

import ar.edu.unpsjb.jbpe.model.enumeration.EstadoDeSaludDelEjemplar;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor

public class EventoCheckeoAnualCreateDTO extends EventoCreateDTO {
    @Digits(
        integer = 3,
        fraction = 3,
        message = "La altura debe tener como máximo 3 enteros y 3 decimales"
    )
    @DecimalMin(
        value = "0.000",
        message = "La altura no puede ser negativa"
    )
    private BigDecimal alturaEnCm;

    @Digits(
        integer = 3,
        fraction = 3,
        message = "El diámetro debe tener como máximo 3 enteros y 3 decimales"
    )
    @DecimalMin(
        value = "0.000",
        message = "El diámetro no puede ser negativo"
    )
    private BigDecimal diametroEnCm;

    @NotNull(message = "El estado de salud del ejemplar es obligatorio (NOT NULL)")
    private EstadoDeSaludDelEjemplar estadoDeSalud;

    private boolean florecio;

    private boolean fructifico;

}
