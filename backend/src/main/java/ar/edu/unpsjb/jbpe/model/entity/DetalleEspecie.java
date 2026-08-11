package ar.edu.unpsjb.jbpe.model.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.persistence.Id;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Column;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.JoinColumn;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "detalle_especie")

@Getter
@Setter
@NoArgsConstructor

public class DetalleEspecie {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private long id;

	@ManyToOne
	@JoinColumn(name = "genero_id", nullable = false)
	private Genero genero;

	@Column(unique = true, nullable = false)
	private String nobreAceptado;

	private String linkFloraArg;

	// private String habito;
	// private String bibliografia;
	// private String descripcion
}
