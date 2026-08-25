package ar.edu.unpsjb.jbpe.model.entity;

import java.time.LocalDate;
import java.math.BigDecimal;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.persistence.Id;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.JoinColumn;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "sitio_recoleccion")

@Getter
@Setter
@NoArgsConstructor

public class SitioDeRecoleccion {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String nombre;

    @Column(name = "fecha_recoleccion", nullable = false)
    private LocalDate fechaDeRecoleccion;

    private BigDecimal latitud;

    private BigDecimal longitud;

    private BigDecimal altitud;

    @ManyToOne
    @JoinColumn(name = "locacion_id", nullable = false)
    private Locacion locacion;

    private String descripcion;
}
