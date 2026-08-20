package ar.edu.unpsjb.jbpe.model.dto;

import ar.edu.unpsjb.jbpe.model.dto.summary.DetalleEspecieSummaryDTO;
import ar.edu.unpsjb.jbpe.model.dto.summary.FamiliaSummaryDTO;
import ar.edu.unpsjb.jbpe.model.dto.summary.GeneroSummaryDTO;
import ar.edu.unpsjb.jbpe.model.dto.summary.OrdenSummaryDTO;
import ar.edu.unpsjb.jbpe.model.enumeration.TipoDeSinonimia;

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

public class NombreEspecieDTO {
    private Long id;

    @NotNull(message = "El nombre de el nombreEspecie es obligatorio")
    @NotBlank(message = "El nombre de el nombreEspecie no puede estar en blanco")
    @Size(max = 200, message = "El nombre no puede superar los 200 caracteres")
    private String nombre;

    @Pattern(
        regexp = "^https?://",
        message = "El enlace de Flora Argentina debe comenzar con http:// o https://"
    )
    private String linkFloraArg;

    private TipoDeSinonimia tipoDeSinonimia;

    private DetalleEspecieSummaryDTO detalleEspecie;

    private GeneroSummaryDTO genero;

    private FamiliaSummaryDTO familia;

    private OrdenSummaryDTO orden;
}
