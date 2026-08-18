package ar.edu.unpsjb.jbpe.model.dto;

import java.time.LocalDate;

import ar.edu.unpsjb.jbpe.model.entity.NombreEspecie;
import ar.edu.unpsjb.jbpe.model.enumeration.EstadoEjemplar;
import ar.edu.unpsjb.jbpe.model.enumeration.Procedencia;

import jakarta.validation.constraints.NotNull;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor

public class EjemplarDTO {

	private Long id;

	//chequear formato?? A-...
	private String adqusicionId;

	private NombreEspecie taxonActual;

	private EstadoEjemplar estadoActual;

	@NotNull(message = "Especificar el recolector es obligatorio (not NULL)")
	private PersonaDTO recolectadoPor;

	@NotNull(message = "La fecha de recoleccion es obligatoria (not NULL)")
	private LocalDate fechaDeRecoleccion;

	@NotNull(message = "El sitio de recoleccion es obligatorio (not NULL)")
	private SitioDeRecoleccionDTO sitioDeRecoleccion;

	private Procedencia procedencia;

	private String observaciones;

	private SectorDTO sectorActual;

	private Long accesionId;

	private String nombreOriginal;

	private String nombreActual;

	private String nombreVulgar;
}
