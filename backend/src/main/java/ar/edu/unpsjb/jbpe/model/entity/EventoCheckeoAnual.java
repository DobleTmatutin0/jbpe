package ar.edu.unpsjb.jbpe.model.entity;

import java.math.BigDecimal;

import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import ar.edu.unpsjb.jbpe.model.enumeration.EstadoDeSaludDelEjemplar;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
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
    private Integer id;

    @OneToOne
    @JoinColumn(name = "event_id", nullable = false)
    private Evento evento;

    @Column(name = "altura_cm")
    private BigDecimal alturaEnCm;

    @Column(name = "diametro_cm")
    private BigDecimal diametroEnCm;

    // enum
    @Column(name = "estado_de_salud", nullable = false)
    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    private EstadoDeSaludDelEjemplar estadoDeSalud;

    private boolean florecio;

    private boolean fructifico;
}
