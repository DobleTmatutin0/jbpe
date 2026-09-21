package ar.edu.unpsjb.jbpe.model.dto;

import ar.edu.unpsjb.jbpe.model.dto.summary.NombreEspecieSummaryDTO;
import ar.edu.unpsjb.jbpe.model.enumeration.EstadoEjemplar;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor

public class EjemplarMinDTO {
    private Integer id;
    private String adquisicionId;
    private NombreEspecieSummaryDTO taxonActual;
    private EstadoEjemplar estadoActual;
}
