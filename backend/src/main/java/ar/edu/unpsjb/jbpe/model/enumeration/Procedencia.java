package ar.edu.unpsjb.jbpe.model.enumeration;

import jakarta.persistence.EnumeratedValue;

// procedencias
public enum Procedencia {
    SILVESTRE("silvestre"),
    CULTIVADA_A_PARTIR_DE_MATERIAL_SILVESTRE(
        "cultivada_a_partir_de_material_silvestre"
    );

    @EnumeratedValue
    private final String sqlValue;

    Procedencia(String sqlValue) {
        this.sqlValue = sqlValue;
    }

    public String getSqlValue() {
        return sqlValue;
    }
}
