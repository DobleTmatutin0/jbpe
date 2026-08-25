package ar.edu.unpsjb.jbpe.model.entity;

import ar.edu.unpsjb.jbpe.model.enumeration.TipoDeGermoplasma;
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
@Table(name = "germoplasma_colectado")

@Getter
@Setter
@NoArgsConstructor

public class GermoplasmaColectado {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "adquisicion_id", nullable = false)
    private Ejemplar ejemplar;

    @Column(name = "tipo_germoplasma", nullable = false)
    private TipoDeGermoplasma tipoDeGermoplasma;
}
