package ar.edu.unpsjb.jbpe.model.entity;

import java.time.LocalDate;

import ar.edu.unpsjb.jbpe.model.enumeration.TipoDeEvento;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "evento")

@Getter
@Setter
@NoArgsConstructor

public class Evento {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "tipo_evento", nullable = false)
    private TipoDeEvento tipoDeEvento;

    @Column(nullable = false)
    private LocalDate fecha;

    @ManyToOne
    @JoinColumn(name = "realizado_por", nullable = false)
    private Persona realizadoPor;

    @ManyToOne
    @JoinColumn(name = "ejemplar_id", nullable = false)
    private Ejemplar ejemplar;

    private String observaciones;
}
