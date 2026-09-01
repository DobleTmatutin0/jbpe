package ar.edu.unpsjb.jbpe.model.enumeration;

import jakarta.persistence.EnumeratedValue;

public enum LocationLevel {
    COUNTRY("country"),
    STATE_PROVINCE("stateprovince"),
    COUNTY("county"),
    LOCALITY("locality");


    @EnumeratedValue
    private final String sqlValue;

    LocationLevel(String sqlValue) {
        this.sqlValue = sqlValue;
    }

    public String getSqlValue() {
        return sqlValue;
    }

}
