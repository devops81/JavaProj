package com.openq.ovid;

/**
 * Created by IntelliJ IDEA.
 * User: abhrap
 * Date: Sep 25, 2006
 * Time: 8:09:55 PM
 * To change this template use File | Settings | File Templates.
 */
public class OvidConstants {
    public static final String OVID_AUTHENTICATION_PARAMS = "authentication nov999/xusxafpp";
    public static final String OVID_CONNECTION_URL = "open z3950.ovid.com";
    public static final String OVID_CONNECTION_PORT = "210";
    public static final String OVID_PUBMED_DATABASE = "base medx";
    public static final String OVID_EMBASE_DATABASE = "base emef";
    public static final String OVID_DISPLAY_FORMAT = "format sutrs";
    public static final String OVID_DISPLAY_RESULTS = "show all";
    public static final int CONFIDENCE_FACTOR_FULL = 100;
    public static final int CONFIDENCE_FACTOR_SEMI = 75;
    public static final int CONFIDENCE_FACTOR_HALF = 50;
    public static final String QUERY_STR0 = "find ";
    public static final String QUERY_STR1 = "@and ";
    public static final String QUERY_STR2 = "@attr 1=";
    public static final String QUERY_STR3 = "@or ";
    public static final String NAME_ATTRIBUTE = "1003 ";
    public static final String SPECIALTY_ATTRIBUTE = "62 ";
    public static final String INSTITUTION_ATTRIBUTE = "2 ";
    public static final String NEXT_RESULT_POSITION = "nextResultSetPosition";
    public static final String UNIQUE_IDENTIFIER = "Unique Identifier";
    public static final String ACCESSION_NUMBER = "Accession Number";
    public static final String AUTHOR_FULL_NAME = "Authors Full Name";
    public static final String AUTHORS = "Authors";
    public static final String TITLE = "Title";
    public static final String ORIGINAL_TITLE = "Original Title";
    public static final String SERIALS_CODE = "Serials Code";
    public static final String SOURCE = "Source";
    public static final String NLM_JOURNAL_NAME = "NLM Journal Name";
    public static final String JOURNAL_NAME = "Journal Name";
    public static final String COUNTRY_OF_PUBLICATION = "Country of Publication";
    public static final String MESH_SUBJECT_HEADINGS = "MeSH Subject Headings";
    public static final String ABSTRACT = "Abstract";
    public static final String PUBLICATION_TYPE = "Publication Type";
    public static final String LANGUAGE = "Language";
    public static final String DATE_OF_PUBLICATION = "Date of Publication";
    public static final String YEAR_OF_PUBLICATION = "Year of Publication";
    public static final String INSTITUTION = "Institution";
    public static final String CAS_REGISTRY = "CAS Registry/EC Number/Name of Substance";
    public static final String NUMBER_OF_REFERENCES = "Number of References";
    public static final String PUBLISHING_MODEL = "Publishing Model";
    public static final String VOLUME = "Volume";
    public static final String NUMBER_OF_HITS = "Number of hits:";
}
