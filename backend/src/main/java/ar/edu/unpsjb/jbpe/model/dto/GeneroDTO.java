package ar.edu.unpsjb.jbpe.model.dto;

import ar.edu.unpsjb.jbpe.model.dto.summary.FamiliaSummaryDTO;
import ar.edu.unpsjb.jbpe.model.dto.summary.OrdenSummaryDTO;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor

public class GeneroDTO {
    private Long id;

    @NotNull(message = "El nombre del genero es obligatorio")
    @NotBlank(message = "El nombre del genero no puede estar en blanco")
    @Size(max = 150, message = "El nombre no puede superar los 150 caracteres")
    private String nombre;

    @Pattern(
        regexp = "^https?://",
        message = "El enlace de Flora Argentina debe comenzar con http:// o https://"
    )
    private String linkFloraArg;

    private FamiliaSummaryDTO familia;

    private OrdenSummaryDTO orden;

}
