package ar.edu.unpsjb.jbpe.model.dto;

import ar.edu.unpsjb.jbpe.model.enumeration.LocationLevel;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor

public class LocacionDTO {
    private Long id;

    @NotNull(message = "El nombre es obligatorio (not NULL)")
    @NotBlank(message = "El nombre no puede estar en blanco")
    @Size(max = 100, message = "El nombre no puede superar los 100 caracteres")
    private String nombre;

    @NotNull(message = "El nivel de la locacion es obligatorio")
    private LocationLevel locacionLvl;

    private Long locacionPadreId;

    private String nombreLocacionPadre;


}
