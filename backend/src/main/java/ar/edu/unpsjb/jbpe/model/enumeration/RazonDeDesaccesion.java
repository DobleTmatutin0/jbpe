package ar.edu.unpsjb.jbpe.model.enumeration;

import jakarta.persistence.EnumeratedValue;

// razon_desaccesion_enum
public enum RazonDeDesaccesion {
    MUERTO("muerto"),
    PLAGA_INTRATABLE("plaga_intratable"),
    INVASOR("invasor"),
    INTERCAMBIO("intercambio"),
    DONACION("donacion"),
    IRRELEVANTE_PARA_COLECCION("irrelevante_para_coleccion"),
    ERROR_IDENTIFICACION("error_identificacion"),
    FALTA_ESPACIO("falta_espacio"),
    PERDIDO("perdido"),
    OTRO("otro");

    @EnumeratedValue
    private final String sqlValue;

    RazonDeDesaccesion(String sqlValue) {
        this.sqlValue = sqlValue;
    }

    public String getSqlValue() {
        return sqlValue;
    }
}
