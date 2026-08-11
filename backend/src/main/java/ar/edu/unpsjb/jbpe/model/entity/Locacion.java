package ar.edu.unpsjb.jbpe.model.entity;

import ar.edu.unpsjb.jbpe.model.enumeration.LocationLevel;
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
@Table(name = "locacion")

@Getter
@Setter
@NoArgsConstructor

public class Locacion {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Enumerated(EnumType.STRING)
    private LocationLevel locacionLvl;

    @ManyToOne
    @JoinColumn(name = "id")
    private Locacion locacionPadre;

    private String nombre;
}
