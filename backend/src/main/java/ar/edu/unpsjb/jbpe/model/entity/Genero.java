package ar.edu.unpsjb.jbpe.model.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Column;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "genero")

@Getter
@Setter
@NoArgsConstructor

public class Genero {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private long id;

	@ManyToOne
	@JoinColumn(name = "familia_id", nullable = false)
	private Familia familia;

	@Column(unique = true, nullable = false)
	private String nombre;

	private String linkFloraArg;
}
