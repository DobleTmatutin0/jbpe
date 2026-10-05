package ar.edu.unpsjb.jbpe.model.dto.ejemplar;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import ar.edu.unpsjb.jbpe.model.dto.GermoplasmaColectadoDTO;
import ar.edu.unpsjb.jbpe.model.enumeration.Procedencia;
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

public class EjemplarCreateDTO {
    @NotNull(message = "El recolector es obligatorio")
    private Integer recolectadoPorId;

    @NotNull(message = "La fecha de recolección es obligatoria")
    private LocalDate fechaDeRecoleccion;

    @NotNull(message = "El sitio de recolección es obligatorio")
    private Integer sitioDeRecoleccionId;

    private Procedencia procedencia;

    @Valid
    private List<GermoplasmaColectadoDTO> germplasmasColectados = new ArrayList<>();

    private String observaciones;

}
