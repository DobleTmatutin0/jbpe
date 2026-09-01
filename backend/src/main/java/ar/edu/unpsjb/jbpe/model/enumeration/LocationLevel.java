package ar.edu.unpsjb.jbpe.model.enumeration;

public enum LocationLevel {
    COUNTRY("country"),
    STATE_PROVINCE("stateprovince"),
    COUNTY("county"),
    LOCALITY("locality");

    private final String sqlValue;

    LocationLevel(String sqlValue) {
        this.sqlValue = sqlValue;
    }

    public String getSqlValue() {
        return sqlValue;
    }

}
