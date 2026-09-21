package ar.edu.unpsjb.jbpe.model.enumeration;

import jakarta.persistence.EnumeratedValue;

// tipo_sinonimia_enum

public enum TipoDeSinonimia {
    ACCEPTED("accepted"),
    SYNONYM("synonym"),
    DEPRECATED("deprecated");

    @EnumeratedValue
    private final String sqlValue;

    TipoDeSinonimia(String sqlValue) {
        this.sqlValue = sqlValue;
    }

    public String getSqlValue() {
        return sqlValue;
    }
}
