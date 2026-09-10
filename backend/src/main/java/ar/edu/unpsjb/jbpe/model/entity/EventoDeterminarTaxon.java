package ar.edu.unpsjb.jbpe.model.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "evento_determinar_taxon")

@Getter
@Setter
@NoArgsConstructor

public class EventoDeterminarTaxon {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @OneToOne
    @JoinColumn(name = "event_id", nullable = false)
    private Evento evento;

    @ManyToOne
    @JoinColumn(name = "taxon_viejo")
    private NombreEspecie taxonViejo;

    @ManyToOne
    @JoinColumn(name = "taxon_nuevo", nullable = false)
    private NombreEspecie taxonNuevo;
}
