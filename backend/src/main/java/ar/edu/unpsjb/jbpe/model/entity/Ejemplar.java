package ar.edu.unpsjb.jbpe.model.entity;

import java.time.LocalDate;

import org.hibernate.annotations.Audited.Table;

import ar.edu.unpsjb.jbpe.model.enumeration.EstadoEjemplar;
import ar.edu.unpsjb.jbpe.model.enumeration.Procedencia;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "ejemplar")

@Getter
@Setter
@NoArgsConstructor

public class Ejemplar {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(name = "adquisicion_id")
    private String adquisicionId;

    private LocalDate marcaTemporal;

    @Column(name = "taxon_actual_id")
    private NombreEspecie taxonActual;

    @Column(name = "estado")
    private EstadoEjemplar estadoActual = EstadoEjemplar.INDEFINIDO;

    @Column(nullable = false)
    private Persona recolectadoPor;

    @Column(nullable = false)
    private LocalDate fechaDeRecoleccion;

    @Column(nullable = false)
    private SitioDeRecoleccion sitioDeRecoleccion;

    private Procedencia procedencia;
    private String observaciones;

    @Column(name = "estado_actual")
    private Sector sectorActual;

    @Column(name = "accesion_id")
    private Long accesionId;

    private String nombreOriginal;
    private String nombreActual;
    private String nombreVulgar;

    // agregar lista de germoplasmas?
}
