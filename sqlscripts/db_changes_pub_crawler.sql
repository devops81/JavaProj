
CREATE TABLE ASYNCH_PUBMED_CRAWLER_JOB ( 
    ID              NUMBER(19,0) NOT NULL,
    SCHEDULED_TIME  NUMBER(19,0) NOT NULL,
    STATUS          VARCHAR2(50) NOT NULL,
    TOTAL_OL_COUNT  NUMBER(19,0) DEFAULT 0 NULL,
    PRIMARY KEY(ID)
);

CREATE TABLE ASYNCH_PUBMED_CRAWLER_JOB_ITEM ( 
    ID        NUMBER(19,0) NOT NULL,
    JOBID     NUMBER(19,0) NOT NULL,
    OLID      NUMBER(19,0) NOT NULL,
    STATUS    VARCHAR2(50) NOT NULL,
    FETCHTIME NUMBER(19,0) DEFAULT 0 NULL,
    PRIMARY KEY(ID)
);

ALTER TABLE ASYNCH_PUBMED_CRAWLER_JOB_ITEM
    ADD CONSTRAINT apcji_jobid FOREIGN KEY (JOBID) REFERENCES ASYNCH_PUBMED_CRAWLER_JOB(ID);


ALTER TABLE ASYNCH_PUBMED_CRAWLER_JOB_ITEM
    ADD CONSTRAINT apcji_olid FOREIGN KEY(OLID) REFERENCES USER_TABLE(ID);


CREATE VIEW EXPERT_TA_VIEW ( id, KOLID, LASTNAME, FIRSTNAME, ADDR_LINE_1, ADDR_LINE_2, ADDR_CITY, ADDR_STATE, ADDR_POSTAL_CODE, ADDR_COUNTRY, PRIMARY_EMAIL, PRIMARY_PHONE, TA )
AS
select ol.id,ol.kolid, ol.lastname, ol.firstname, ol.addr_line_1, ol.addr_line_2, 
ol.addr_city, ol.addr_state, ol.addr_postal_code, ol.addr_country, ol.primary_email, ol.primary_phone,
 CASE -- TA will be set to the FIRST SOI that matches in this list; change the order of the WHEN clauses to change the precedence
    WHEN  cvsoi.value<>'N/A' and  cvsoi.value IS NOT NULL THEN 'CVMET'
    WHEN oncsoi.value<>'N/A' and oncsoi.value IS NOT NULL THEN 'Oncology'
    WHEN virsoi.value<>'N/A' and virsoi.value IS NOT NULL THEN 'Virology'
    WHEN immsoi.value<>'N/A' and immsoi.value IS NOT NULL THEN 'Immunoscience'
    WHEN  hosoi.value<>'N/A' and  hosoi.value IS NOT NULL THEN 'Health Outcomes'
    WHEN  nrsoi.value<>'N/A' and  nrsoi.value IS NOT NULL THEN 'Neuro'
    ELSE NULL
  END as TA
from expert_details_mview ol
left outer join attribute_value_view cvsoi  on cvsoi.root_entity_id=ol.kolid  and cvsoi.attribute_path =     '\KOL\BMS Info\CVMET Attributes\CVMET Sphere of Influence'
left outer join attribute_value_view nrsoi  on nrsoi.root_entity_id=ol.kolid  and nrsoi.attribute_path =     '\KOL\BMS Info\Neuro Attributes\Neuro Sphere of Influence'
left outer join attribute_value_view oncsoi on oncsoi.root_entity_id=ol.kolid and oncsoi.attribute_path like '\KOL\BMS Info\Oncology Attributes\% Sphere of Influence'
left outer join attribute_value_view virsoi on virsoi.root_entity_id=ol.kolid and virsoi.attribute_path =    '\KOL\BMS Info\Virology Attributes\Virology Sphere of Influence'
left outer join attribute_value_view immsoi on immsoi.root_entity_id=ol.kolid and immsoi.attribute_path =    '\KOL\BMS Info\Immunoscience Attributes\Immunoscience Sphere of Influence'
left outer join attribute_value_view hosoi  on hosoi.root_entity_id=ol.kolid  and hosoi.attribute_path  =    '\KOL\BMS Info\Health Outcomes Attributes\Health Outcomes Sphere of Influence'
WHERE ol.deleteflag='N';


rem create the ta -> keyword mapping table needed for Pubmed Crawler

CREATE TABLE TA_KEYWORD_MAPPING
(
    "ID" NUMBER(19,0),
    "TA" VARCHAR2(4000 BYTE) NOT NULL,
    "KEYWORD" VARCHAR2(4000 BYTE) NOT NULL,
    CONSTRAINT "TA_KEYWORD_MAPPING_PK" PRIMARY KEY ("ID") ENABLE
);


CREATE TABLE PUB_CRAWLER_CONFIG
(
    "ID" NUMBER(19,0),
    "PROP_KEY" VARCHAR2(255 BYTE) NOT NULL,
    "PROP_VALUE" VARCHAR2(255 BYTE) NOT NULL,
    CONSTRAINT "PUB_CRAWLER_CONFIG_PK" PRIMARY KEY ("ID") ENABLE
);


INSERT INTO PUB_CRAWLER_CONFIG (ID, PROP_KEY, PROP_VALUE) VALUES (1, 'Pubcrawler.run', 'true');