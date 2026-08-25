package ar.edu.unpsjb.jbpe.model.entity;

import java.math.BigDecimal;

import ar.edu.unpsjb.jbpe.model.enumeration.EstadoDeSaludDelEjemplar;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "evento_chequeo_anual")

@Getter
@Setter
@NoArgsConstructor

public class EventoCheckeoAnual {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "event_id", nullable = false)
    private Evento evento;

    private BigDecimal alturaEnCm;

    private BigDecimal diametroEnCm;

    // enum
    private EstadoDeSaludDelEjemplar estadoDeSalud;

    private boolean florecio;

    private boolean fructifico;
}
