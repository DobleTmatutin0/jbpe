package ar.edu.unpsjb.jbpe.model.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.persistence.Id;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.EnumType;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

import ar.edu.unpsjb.jbpe.model.enumeration.TipoPersona;

@Entity
@Table(name = "persona")

@Getter
@Setter
@NoArgsConstructor

public class Persona {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@Column(nullable = false)
	private String nombre;

	@Column(nullable = false)
	private String apellido;

	@Enumerated(EnumType.STRING)
	private TipoPersona tipoDePersona;
}
