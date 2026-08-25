package ar.edu.unpsjb.jbpe.model.entity;

import ar.edu.unpsjb.jbpe.model.enumeration.SectorLevel;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Table;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "sector")

@Getter
@Setter
@NoArgsConstructor

public class Sector {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private SectorLevel sectorLvl;

    // parent_id
    @ManyToOne
    @JoinColumn(name = "id")
    private Sector sectorPadre;

    private String nombre;
}
