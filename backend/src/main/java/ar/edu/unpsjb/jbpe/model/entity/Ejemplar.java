package ar.edu.unpsjb.jbpe.model.entity;

import java.util.List;
import java.time.LocalDate;
import java.time.LocalDateTime;

import ar.edu.unpsjb.jbpe.model.enumeration.EstadoEjemplar;
import ar.edu.unpsjb.jbpe.model.enumeration.Procedencia;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

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

    private LocalDateTime marcaTemporal;

    @ManyToOne
    @JoinColumn(name = "taxon_actual_id")
    private NombreEspecie taxonActual;

    @Column(name = "estado")
    private EstadoEjemplar estadoActual = EstadoEjemplar.INDEFINIDO;

    @OneToMany(mappedBy = "ejemplar")
    private List<GermoplasmaColectado> germoplasmasColectados;

    @OneToMany(mappedBy = "ejemplar")
    private List<Evento> eventos;

    @ManyToOne
    @JoinColumn(name = "recolectado_por", nullable = false)
    private Persona recolectadoPor;

    @Column(nullable = false)
    private LocalDate fechaDeRecoleccion;

    @ManyToOne
    @JoinColumn(name = "sitio_recoleccion_id", nullable = false)
    private SitioDeRecoleccion sitioDeRecoleccion;

    private Procedencia procedencia;
    private String observaciones;

    @ManyToOne
    @JoinColumn(name = "sector_actual_id")
    private Sector sectorActual;

    @Column(name = "accesion_id")
    private Long accesionId;

    private String nombreOriginal;
    private String nombreActual;
    private String nombreVulgar;

    // agregar lista de germoplasmas?
}
