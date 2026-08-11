package ar.edu.unpsjb.jbpe.model.dto;

import java.time.LocalDate;
import java.math.BigDecimal;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import jakarta.validation.constraints.DecimalMax;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

@Getter
@Setter
@NoArgsConstructor

public class SitioDeRecoleccionDTO {

    private Long id;

    @NotNull(message = "El nombre es obligatorio (not NULL)")
    @NotBlank(message = "El nombre no puede estar en blanco")
    @Size(max = 150, message = "El nombre no puede superar los 150 caracteres")
    private String nombre;

    @NotNull(message = "La fecha de recoleccion es obligatoria (not NULL)")
    private LocalDate fechaDeRecoleccion;

    @DecimalMin(value = "-90", message = "La latitud no puede ser menor a -90")
    @DecimalMax(value = "90", message = "La latitud no puede ser mayor a 90")
    private BigDecimal latitud;

    @DecimalMin(value = "-180", message = "La longitud no puede ser menor a -180")
    @DecimalMax(value = "180", message = "La longitud no puede ser mayor a 180")
    private BigDecimal longitud;

    @DecimalMin(value = "-500", message = "La latitud no puede ser menor a -500")
    @DecimalMax(value = "9000", message = "La latitud no puede ser mayor a 9000")
    private BigDecimal altitud;

    @NotNull(message = "locacionId es obligatorio")
    private Long locacionId;

    private String nombreLocacion;

    private String descripcion;
}
