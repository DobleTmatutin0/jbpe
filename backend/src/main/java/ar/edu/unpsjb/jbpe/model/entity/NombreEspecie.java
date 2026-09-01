package ar.edu.unpsjb.jbpe.model.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Table;
import jakarta.persistence.Id;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Column;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.Enumerated;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import ar.edu.unpsjb.jbpe.model.enumeration.TipoDeSinonimia;

@Entity
@Table(name = "nombre_especie")

@Getter
@Setter
@NoArgsConstructor

public class NombreEspecie {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @ManyToOne
    @JoinColumn(name = "detalle_id", nullable = false)
    private DetalleEspecie detalleEspecie;

    @Column(unique = true, nullable = false)
    private String nombre;

    private String linkFloraArg;

    @Column(name = "tipo_nombre", nullable = false)
    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    private TipoDeSinonimia tipoDeSinonimia = TipoDeSinonimia.ACCEPTED;
}
