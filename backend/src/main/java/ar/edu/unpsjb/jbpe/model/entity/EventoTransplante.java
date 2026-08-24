package ar.edu.unpsjb.jbpe.model.entity;

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
@Table(name = "evento_transplante")

@Getter
@Setter
@NoArgsConstructor

public class EventoTransplante {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "event_id", nullable = false)
    private Evento evento;

    @ManyToOne
    @JoinColumn(name = "sector_inicial", nullable = false)
    private Sector sectorInicial;

    @ManyToOne
    @JoinColumn(name = "transplantado_por_id", nullable = false)
    private Persona transplantadoPor;

    @Column(name = "transplantador_por_id")
    private String ComoFuePlantadoEnPredio;

}
