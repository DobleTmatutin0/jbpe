package ar.edu.unpsjb.jbpe.model.enumeration;

import jakarta.persistence.EnumeratedValue;

// tipo_evento
public enum TipoDeEvento {
    INGRESO("ingreso"),
    INSPECCION("inspeccion"),
    GERMINACION("germinacion"),
    ENRAIZAMIENTO("enraizamiento"),
    TRASPLANTE("trasplante"),
    ACCESION("accesion"),
    CHEQUEO_ANUAL("chequeo_anual"),
    CAMBIO_UBICACION("cambio_ubicacion"),
    TRATAMIENTO("tratamiento"),
    REDETERMINACION_TAXONOMICA("redeterminacion_taxonomica"),
    DESACCESION("desaccesion");

    @EnumeratedValue
    private final String sqlValue;

    TipoDeEvento(String sqlValue) {
        this.sqlValue = sqlValue;
    }

    public String getSqlValue() {
        return sqlValue;
    }
}
