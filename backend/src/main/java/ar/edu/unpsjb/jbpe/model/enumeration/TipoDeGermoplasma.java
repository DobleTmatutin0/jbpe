package ar.edu.unpsjb.jbpe.model.enumeration;

import jakarta.persistence.EnumeratedValue;

// tipo_germoplasma

public enum TipoDeGermoplasma {
    SEMILLA("semilla"),
    ESQUEJE("esqueje"),
    PLANTULA("plantula"),
    PLANTA("planta"),
    BULBO("bulbo"),
    ESPORA("espora"),
    PROPAGULO("propágulo"),
    OTRO("otro");

    @EnumeratedValue
    private final String sqlValue;

    TipoDeGermoplasma(String sqlValue) {
        this.sqlValue = sqlValue;
    }

    public String getSqlValue() {
        return sqlValue;
    }
}
