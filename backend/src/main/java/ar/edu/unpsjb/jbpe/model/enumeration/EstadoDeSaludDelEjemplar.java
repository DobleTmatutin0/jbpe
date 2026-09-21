package ar.edu.unpsjb.jbpe.model.enumeration;

import jakarta.persistence.EnumeratedValue;

// estado_salud_enum
public enum EstadoDeSaludDelEjemplar {
    EXCELENTE("excelente"),
    BUENO("bueno"),
    REGULAR("regular"),
    MALO("malo"),
    CRITICO("critico"),
    MUERTO("muerto"),
    INFECTADO("infectado"),
    CON_PLAGA("con_plaga"),
    INVASOR("invasor"),
    DESACORDE("desacorde"),
    PERDIDO("perdido"),
    OTRO("otro");

    @EnumeratedValue
    private final String sqlValue;

    EstadoDeSaludDelEjemplar(String sqlValue) {
        this.sqlValue = sqlValue;
    }

    public String getSqlValue() {
        return sqlValue;
    }
}

// Yo sacaria "con plaga", "perdido", "desacorde"
