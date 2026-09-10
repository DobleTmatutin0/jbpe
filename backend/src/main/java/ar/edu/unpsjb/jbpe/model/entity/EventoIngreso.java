package ar.edu.unpsjb.jbpe.model.entity;

import java.time.LocalDate;

import jakarta.persistence.Column;
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
@Table(name = "evento_ingreso")

@Getter
@Setter
@NoArgsConstructor

public class EventoIngreso {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @OneToOne
    @JoinColumn(name = "event_id", nullable = false)
    private Evento evento;

    @Column(name = "fecha_donacion")
    private LocalDate fechaDeDonacion;

    @ManyToOne
    @JoinColumn(name = "donado_por")
    private Persona donadoPor;

}
