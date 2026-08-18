package ar.edu.unpsjb.jbpe.model.dto;

import ar.edu.unpsjb.jbpe.model.enumeration.TipoPersona;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor

public class PersonaDTO {
    private Long id;

    @NotNull(message = "El nombre no puede ser NULL")
    @NotBlank(message = "El nombre no puede estar en blanco")
    @Size(max = 80, message = "El nombre no puede superar los 80 caracteres")
    private String nombre;

    @NotNull(message = "El apellido no puede ser NULL")
    @NotBlank(message = "El apellido no puede estar en blanco")
    @Size(max = 80, message = "El apellido no puede superar los 80 caracteres")
    private String apellido;

    @NotNull(message = "El TipoDePersona es obligatorio")
    private TipoPersona tipoDePersona;
}
