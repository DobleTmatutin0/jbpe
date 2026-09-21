package ar.edu.unpsjb.jbpe.model.enumeration;

import jakarta.persistence.EnumeratedValue;

// sector_level
public enum SectorLevel {
    PRINCIPAL("principal"),
    SECUNDARIO("secundario"),
    TERCIARIO("terciario");

    @EnumeratedValue
    private final String sqlValue;

    SectorLevel(String sqlValue) {
        this.sqlValue = sqlValue;
    }

    public String getSqlValue() {
        return sqlValue;
    }
}
