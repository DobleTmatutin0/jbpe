package ar.edu.unpsjb.jbpe.model.enumeration;

import jakarta.persistence.EnumeratedValue;

// estado actual
public enum EstadoEjemplar {
    INDEFINIDO("indefinido"),
    ADQUISICION("adquisicion"),
    ACCESION("accesionado"),
    DESACCESION("desaccesionado");

    @EnumeratedValue
    private final String sqlValue;

    EstadoEjemplar(String sqlValue) {
        this.sqlValue = sqlValue;
    }

    public String getSqlValue() {
        return sqlValue;
    }

}
