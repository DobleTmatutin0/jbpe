package ar.edu.unpsjb.jbpe.model.enumeration;

import jakarta.persistence.EnumeratedValue;

// tipo_persona (son distintos a los reales)
public enum TipoPersona {

    // datos que tienen que tienen q estar en la db a futuro
    // INTERNO,
    // EXTERNO,
    // CIENTIFICO

    // Datos reales de la db
    DONADOR("donador"),
    COLECTOR("colector"),
    CIENTIFICO("cientifico"),
    CULTIVADOR("cultivador"),
    OTRO("otro");

    @EnumeratedValue
    private final String sqlValue;

    TipoPersona(String sqlValue) {
        this.sqlValue = sqlValue;
    }

    public String getSqlValue() {
        return sqlValue;
    }
}
