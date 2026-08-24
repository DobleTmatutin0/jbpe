package ar.edu.unpsjb.jbpe.model.entity;

import org.hibernate.annotations.Audited.Table;

import ar.edu.unpsjb.jbpe.model.enumeration.RazonDeDesaccesion;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "evento_desaccesion")

@Getter
@Setter
@NoArgsConstructor

public class EventoDesaccesion {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "event_id", nullable = false)
    private Evento evento;

    @Column(name = "motivo", nullable = false)
    private RazonDeDesaccesion motivo;

}
