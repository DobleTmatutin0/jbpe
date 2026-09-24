package ar.edu.unpsjb.jbpe.model.dto;

import java.time.LocalDate;
import java.util.List;

import ar.edu.unpsjb.jbpe.model.entity.GermoplasmaColectado;
import ar.edu.unpsjb.jbpe.model.entity.Persona;
import ar.edu.unpsjb.jbpe.model.enumeration.EstadoEjemplar;
import ar.edu.unpsjb.jbpe.model.enumeration.Procedencia;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor

public class EjemplarDTO {

	private Integer id;

	//chequear formato?? A-...
	private String adquisicionId;

	private NombreEspecieDTO taxonActual;

	private EstadoEjemplar estadoActual;

	@NotNull(message = "Especificar el recolector es obligatorio (not NULL)")
	private Persona recolectadoPor;

	@NotNull(message = "La fecha de recoleccion es obligatoria (not NULL)")
	private LocalDate fechaDeRecoleccion;

	@NotNull(message = "El sitio de recoleccion es obligatorio (not NULL)")
	private SitioDeRecoleccionDTO sitioDeRecoleccion;

	private Procedencia procedencia;

	//@NotNull(message = "")
	private List<GermoplasmaColectadoDTO> germplasmasColectados;

	private String observaciones;

	private SectorDTO sectorActual;

	private Integer accesionId;

	private String nombreOriginal;

	private String nombreActual;

	private String nombreVulgar;
}
