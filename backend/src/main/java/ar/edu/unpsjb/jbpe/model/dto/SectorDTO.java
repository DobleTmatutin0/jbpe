package ar.edu.unpsjb.jbpe.model.dto;

import ar.edu.unpsjb.jbpe.model.enumeration.SectorLevel;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor

public class SectorDTO {

	private Integer id;

	@NotNull(message = "El nombre es obligatorio (not NULL)")
	@NotBlank(message = "El nombre no puede estar en blanco")
	@Size(max = 150, message = "El nombre no puede superar los 150 caracteres")
	private String nombre;

	@NotNull(message = "El nivel del sector es obligatorio")
	private SectorLevel sectorLvl;

	private Integer sectorPadreId;

	private String nombreSectorPadre;
}
