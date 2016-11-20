rem ------------------------------------------------------------------------------------------------
rem Filename:   db_changes_script.sql
rem Purpose:    To replace databaseNoted.xls for recording SQls to update the DB
rem             
rem Date:       26-September-2008
rem Author:     Deepak Sinigh Rawat, Kuliza Technologies
rem ------------------------------------------------------------------------------------------------

SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
SPOOL db_changes_script.log
SET ECHO ON

rem -- log file : db_changes_script.log

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------
rem : Use rem at the begining of a line to write comments

rem Important :
rem 1: add ; at the end of a SQL.
rem 2: write commit; at the end of any DDL.
rem 3: record the latest batch number that you execute on the DB below. 
rem  : It will only be used to record the batch number ran on sandbox branch or a demo branch or on the production server.


rem ------------------------------------------------------------------------------------------------

rem : Latest Executed Batch Number : 32 (Executed on Linux sandbox) 

rem ------------------------------------------------------------------------------------------------

rem : Batch : 1

DELETE FROM FEATURE_PERMISSION_METADATA;
ALTER TABLE FEATURE_PERMISSION_METADATA ADD (ALLOWED_BY_DEFAULT CHAR(1 BYTE) NOT NULL);

COMMENT ON COLUMN FEATURE_PERMISSION_METADATA.ALLOWED_BY_DEFAULT IS '1=allowed, 0=not allowed';

INSERT INTO FEATURE_PERMISSION_METADATA VALUES(1,'Report Permission',0);
INSERT INTO FEATURE_PERMISSION_METADATA VALUES(2,'LOV Permission',1);
COMMIT;


rem : 1>Author name 		: Deepak
rem : 2>Purpose of change	: To add permission default type and meta data for Group Level Security. If we define a new permission type
rem                           then it is important that an entry for that type is in this table
rem : 3>Date of change 		: 26-September-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 2

INSERT INTO USER_GROUP_MAP
SELECT HIBERNATE_SEQUENCE.NEXTVAL AS ID,1 AS GROUP_ID,(SELECT ID FROM USER_TABLE WHERE USERNAME='admin') AS USER_ID FROM DUAL;
COMMIT;



rem : 1>Author name 		: Deepak
rem : 2>Purpose of change	: To assign usergroup to admin user.
rem :                             It''s required to give admin all the permissions.
rem : 3>Date of change 		: 26-September-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 3

ALTER TABLE OPTION_LOOKUP 
MODIFY (DEFAULT_SELECTED NOT NULL);

rem : 1>Author name 		: Deepak
rem : 2>Purpose of change	: Change made so that default value=0 is set.
rem : 3>Date of change 		: 26-September-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 4

CREATE TABLE INTERACTION_LOVTRIPLET_SECTION
(
  ID NUMBER NOT NULL,
  LOV_TRIPLET VARCHAR2(500) NOT NULL,
  SECTION VARCHAR2(500) NOT NULL
, CONSTRAINT INTERACTION_LOVTRIPLET_SE_PK PRIMARY KEY
  (
    ID
  )
  ENABLE
)
;

rem : 1>Author name 		: Deepak
rem : 2>Purpose of change	: To store lov triplet and interaction sections mapping
rem : 3>Date of change 		: 02-October-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 5


ALTER TABLE INTERACTION_DATA 
ADD (SECONDARY_LOVID NUMBER);

ALTER TABLE INTERACTION_DATA
ADD (TERTIARY_LOVID NUMBER);

ALTER TABLE INTERACTION_DATA 
ADD CONSTRAINT INTERACTION_DATA_OPTION_L_FK1 FOREIGN KEY 
(
SECONDARY_LOVID
) REFERENCES OPTION_LOOKUP 
(
ID
) ENABLE;

ALTER TABLE INTERACTION_DATA 
ADD CONSTRAINT INTERACTION_DATA_OPTION_L_FK2 FOREIGN KEY 
(
TERTIARY_LOVID
) REFERENCES OPTION_LOOKUP 
(
ID
) ENABLE;

rem : 1>Author name 		: Deepak
rem : 2>Purpose of change	: To store new sections data for BMS
rem : 3>Date of change 		: 17-October-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 6

ALTER TABLE INTERACTION 
ADD (SUPERVISOR_ID NUMBER DEFAULT 0 NOT NULL)
;

ALTER TABLE INTERACTION 
ADD (GROUP_ID NUMBER DEFAULT 0 NOT NULL)
;

ALTER TABLE INTERACTION 
ADD (TERRITORY_ID NUMBER DEFAULT 0 NOT NULL)
;

ALTER TABLE INTERACTION 
ADD (REPORT_LEVEL_ID NUMBER DEFAULT 0)
;

ALTER TABLE INTERACTION 
ADD (THERAPEUTIC_AREA_ID NUMBER DEFAULT 0 NOT NULL)
;


rem : 1>Author name 		: Deepak
rem : 2>Purpose of change	: To tag information for Interaction for report generation
rem : 3>Date of change 		: 18-October-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 7

INSERT INTO FEATURE_PERMISSION_METADATA VALUES (3,'Survey Permission',0);

COMMIT;
rem : 1>Author name 		: Vaibhav
rem : 2>Purpose of change	: To set survey Permissions we need to have the type entry of surveys in the metadata table.
rem : 3>Date of change 		: 21-October-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 8

ALTER TABLE SURVEYMETADATA 
ADD ("DATE_START" VARCHAR2(50))
;

ALTER TABLE SURVEYMETADATA 
ADD ("DATE_END" VARCHAR2(50))
;


rem : 1>Author name 		: Vaibhav
rem : 2>Purpose of change	: To add effective addting we need start date and end date, this query adds these two fileds on our table.
rem : 3>Date of change 		: 21-October-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 9

 DROP TABLE INTERACTION_LOVTRIPLET_SECTION;
  
  CREATE TABLE INTERACTION_LOVTRIPLET_SECTION
   (	ID NUMBER NOT NULL ENABLE, 
	PRIMARY_LOVID NUMBER DEFAULT 0 NOT NULL ENABLE, 
	SECONDARY_LOVID NUMBER DEFAULT 0 NOT NULL ENABLE, 
	TERTIARY_LOVID NUMBER DEFAULT 0 NOT NULL ENABLE,
	SECTION VARCHAR2(500 BYTE) NOT NULL ENABLE
);

rem : 1>Author name 		: Deepak
rem : 2>Purpose of change	: To store the interaction triplet and section mapping. It is critical that after running
rem							  these queries this table is populated with the right Interaction triplet ids and section name.
rem 						  If this table is empty then hidden Interaction sections will not be visible even after choosing 
rem 						  the right triplet.
rem : 3>Date of change 		: 18-October-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 10

  CREATE OR REPLACE FORCE VIEW "HOME_USER_ADDRESS_VIEW" ("ID", "KOLID", "STATE", "COUNTRY", "CITY", "USAGE", "ZIP") AS 
  SELECT
A.ID,A.KOLID, H.VALUE AS STATE, I.VALUE AS COUNTRY,L.VALUE AS CITY,K1.VALUE AS USAGE,T1.VALUE AS ZIP
FROM USER_TABLE A
LEFT OUTER JOIN ENTITIES_ATTRIBUTE J
ON (J.PARENT_ID=A.KOLID AND J.ATTRIBUTE_ID=1)
LEFT OUTER JOIN ENTITIES_ATTRIBUTE T2
ON (T2.PARENT_ID=J.MYENTITY_ID AND T2.ATTRIBUTE_ID=34)
LEFT OUTER JOIN STRING_ATTRIBUTE T1
ON (T1.PARENT_ID=T2.MYENTITY_ID AND T1.ATTRIBUTE_ID=41)
LEFT OUTER JOIN STRING_ATTRIBUTE H
ON (H.PARENT_ID=T2.MYENTITY_ID AND H.ATTRIBUTE_ID=40)
LEFT OUTER JOIN STRING_ATTRIBUTE I
ON (I.PARENT_ID = T2.MYENTITY_ID AND I.ATTRIBUTE_ID=42)
LEFT OUTER JOIN STRING_ATTRIBUTE K1
ON (K1.PARENT_ID = T2.MYENTITY_ID AND K1.ATTRIBUTE_ID=36)
LEFT OUTER JOIN STRING_ATTRIBUTE L
ON (L.PARENT_ID = T2.MYENTITY_ID AND L.ATTRIBUTE_ID=39)
WHERE A.DELETEFLAG='N' AND A.USER_TYPE_ID=4 
ORDER BY A.ID;
 

rem : 1>Author name 		: Tapan
rem : 2>Purpose of change	: Modified the view to perform Left Outer Joins to get data for all the Experts.
rem : 3>Date of change 		: 22-October-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 11

  CREATE OR REPLACE FORCE VIEW "HOME_USER_PHONE_VIEW" ("ID", "TYPE", "KOLID", "PHONE", "CONTACTFLAG") AS 
  SELECT DISTINCT
A.ID, K4.VALUE, A.KOLID, K2.VALUE AS PHONE,
case 
    when K3.VALUE is null then 0
    else 1
end  AS CONTACTFLAG
FROM USER_TABLE A
LEFT OUTER JOIN ENTITIES_ATTRIBUTE J
ON (J.PARENT_ID=A.KOLID AND J.ATTRIBUTE_ID=1)
LEFT OUTER JOIN ENTITIES_ATTRIBUTE K22
ON (K22.PARENT_ID = J.MYENTITY_ID AND K22.ATTRIBUTE_ID = 43)
LEFT OUTER JOIN STRING_ATTRIBUTE K2
ON (K2.PARENT_ID = K22.MYENTITY_ID AND K2.ATTRIBUTE_ID = 83009820)
LEFT OUTER JOIN STRING_ATTRIBUTE K3
ON (K3.PARENT_ID = K22.MYENTITY_ID AND K3.ATTRIBUTE_ID = 83009821)
LEFT OUTER JOIN STRING_ATTRIBUTE K4
ON (K4.PARENT_ID = K22.MYENTITY_ID AND K4.ATTRIBUTE_ID = 44)
WHERE A.DELETEFLAG='N' AND A.USER_TYPE_ID=4
ORDER BY A.ID;
  

rem : 1>Author name 		: Tapan
rem : 2>Purpose of change	: Modified the view to perform Left Outer Joins to get data for all the Experts.
rem : 3>Date of change 		: 22-October-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 12

  CREATE OR REPLACE FORCE VIEW "HOME_USER_VIEW" ("ID", "FIRSTNAME", "MIDDLENAME", "LASTNAME", "DELETEFLAG", "KOLID", "SPECIALTY1", "SPECIALTY2", "SPECIALTY3", "SPECIALTY4", "SPECIALTY5", "SPECIALTY6", "STAFFID", "TITLE", "TIER") AS 
  SELECT 
A.ID, A.FIRSTNAME, A.MIDDLENAME, A.LASTNAME, A.DELETEFLAG,A.KOLID,B.VALUE AS SPECIALTY1, 
C.VALUE AS SPECIALTY2, D.VALUE AS SPECIALTY3, ' ' AS SPECIALTY4, 
' ' AS SPECIALTY5, ' ' AS SPECIALTY6,A.STAFFID,' ' AS TITLE,H.value as TIER
FROM USER_TABLE A 
LEFT OUTER JOIN ENTITIES_ATTRIBUTE J 
ON ( J.PARENT_ID=A.KOLID AND J.ATTRIBUTE_ID=1 ) 
LEFT OUTER JOIN ENTITIES_ATTRIBUTE K 
ON ( K.PARENT_ID=J.MYENTITY_ID AND K.ATTRIBUTE_ID=16 ) 
LEFT OUTER JOIN STRING_ATTRIBUTE B 
ON ( B.PARENT_ID=K.MYENTITY_ID AND B.ATTRIBUTE_ID=24 ) 
LEFT OUTER JOIN STRING_ATTRIBUTE C 
ON ( C.PARENT_ID=K.MYENTITY_ID AND C.ATTRIBUTE_ID=25 )
LEFT OUTER JOIN  STRING_ATTRIBUTE D 
ON ( D.PARENT_ID=K.MYENTITY_ID AND D.ATTRIBUTE_ID=26 ) 
LEFT OUTER JOIN STRING_ATTRIBUTE H 
ON ( H.PARENT_ID=K.MYENTITY_ID AND H.ATTRIBUTE_ID=83009814) 
WHERE A.DELETEFLAG='N' AND A.USER_TYPE_ID=4 
ORDER BY A.ID;
 
  

rem : 1>Author name 		: Tapan
rem : 2>Purpose of change	: Modified the view to perform Left Outer Joins to get data for all the Experts.
rem : 3>Date of change 		: 22-October-2008

rem ------------------------------------------------------------------------------------------------


rem : Batch : 13

  alter table user_table add MSL_START_DATE date;
 
  

rem : 1>Author name 		: Dayanand
rem : 2>Purpose of change	: Added column in user_table
rem : 3>Date of change 		: 12-Nov-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 14

CREATE OR REPLACE FORCE VIEW  "SPECIALTY_VIEW" ("ID", "FIRSTNAME", "MIDDLENAME", "LASTNAME", "DELETEFLAG", "KOLID", "USER_TYPE_ID", "SPECIALTY1", "SPECIALTY2", "SPECIALTY3") AS 
  select 
A.ID, A.FIRSTNAME, A.MIDDLENAME, A.LASTNAME, A.DELETEFLAG,A.KOLID,A.USER_TYPE_ID,sp1.value as specialty1,
sp2.value as specialty2,sp3.value as specialty3 from
(select st.*,u.kolid "kol" from user_table u,
entities_attribute e,
entities_attribute en,
string_attribute st
where st.parent_id = en.myentity_id
and en.parent_id = e.myentity_id
and e.parent_id = u.kolid
and st.attribute_id = 24) sp1,
(select st.*,u.kolid "kol" from user_table u,
entities_attribute e,
entities_attribute en,
string_attribute st
where st.parent_id = en.myentity_id
and en.parent_id = e.myentity_id
and e.parent_id = u.kolid
and st.attribute_id = 25) sp2,
(select st.*,u.kolid "kol" from user_table u,
entities_attribute e,
entities_attribute en,
string_attribute st
where st.parent_id = en.myentity_id
and en.parent_id = e.myentity_id
and e.parent_id = u.kolid
and st.attribute_id = 26) sp3,
user_table a
where a.kolid = sp2."kol"(+)
and a.kolid = sp3."kol"(+)
and a.kolid = sp1."kol"(+)
AND A.USER_TYPE_ID=4 
ORDER BY a.ID;
 
  

rem : 1>Author name 		: Dayanand
rem : 2>Purpose of change	: Modified the view to have the desired results
rem : 3>Date of change 		: 12-Nov-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 15

ALTER TABLE FILLED_SURVEY 
ADD ("CREATEDATE" DATE NOT NULL)
;
ALTER TABLE FILLED_SURVEY 
ADD ("UPDATEDATE" DATE NOT NULL)
;

ALTER TABLE FILLED_SURVEY 
ADD ("USERID" NUMBER NOT NULL)
;

rem : 1>Author name 		: Kirubakaran
rem : 2>Purpose of change	: Altered Table to store the created user, create date,update date of the survey
rem : 3>Date of change 		: 14-Nov-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 16

INSERT INTO FEATURE_PERMISSION_METADATA VALUES(4,'SearchAttributes Permission',1);
COMMIT;


rem : 1>Author name 		: Kirubakaran
rem : 2>Purpose of change	: Restriction on Advanced search attributes based on group
rem : 3>Date of change 		: 14-Nov-2008

rem ------------------------------------------------------------------------------------------------
 
rem : Batch : 17


  CREATE OR REPLACE FORCE VIEW "HOME_USER_VIEW" ("ID", "FIRSTNAME", "MIDDLENAME", "LASTNAME", "DELETEFLAG", "KOLID", "SPECIALTY1", "SPECIALTY2", "SPECIALTY3", "SPECIALTY4", "SPECIALTY5", "SPECIALTY6", "STAFFID", "TITLE", "TIER", "MSL_OL_TYPE", "CVMET_SPHERE_OF_INFLUENCE") AS 
  SELECT 
A.ID, A.FIRSTNAME, A.MIDDLENAME, A.LASTNAME, A.DELETEFLAG,A.KOLID,B.VALUE AS SPECIALTY1, 
C.VALUE AS SPECIALTY2, D.VALUE AS SPECIALTY3, ' ' AS SPECIALTY4, 
' ' AS SPECIALTY5, ' ' AS SPECIALTY6,A.STAFFID,' ' AS TITLE,H.value as TIER, R.VALUE AS MSL_OL_TYPE,
S.VALUE AS CVMET_SPHERE_OF_INFLUENCE
FROM USER_TABLE A 
LEFT OUTER JOIN ENTITIES_ATTRIBUTE J 
ON ( J.PARENT_ID=A.KOLID AND J.ATTRIBUTE_ID=1 ) 
LEFT OUTER JOIN ENTITIES_ATTRIBUTE K 
ON ( K.PARENT_ID=J.MYENTITY_ID AND K.ATTRIBUTE_ID=16 ) 
LEFT OUTER JOIN STRING_ATTRIBUTE B 
ON ( B.PARENT_ID=K.MYENTITY_ID AND B.ATTRIBUTE_ID=24 ) 
LEFT OUTER JOIN STRING_ATTRIBUTE C 
ON ( C.PARENT_ID=K.MYENTITY_ID AND C.ATTRIBUTE_ID=25 )
LEFT OUTER JOIN  STRING_ATTRIBUTE D 
ON ( D.PARENT_ID=K.MYENTITY_ID AND D.ATTRIBUTE_ID=26 ) 
LEFT OUTER JOIN STRING_ATTRIBUTE H 
ON ( H.PARENT_ID=K.MYENTITY_ID AND H.ATTRIBUTE_ID=83009814)
LEFT OUTER JOIN ENTITIES_ATTRIBUTE P
ON (P.PARENT_ID = A.KOLID AND P.ATTRIBUTE_ID = 83005801)
LEFT OUTER JOIN ENTITIES_ATTRIBUTE Q
ON (Q.PARENT_ID = P.MYENTITY_ID AND Q.ATTRIBUTE_ID = 83396589)
LEFT OUTER JOIN STRING_ATTRIBUTE R
ON (R.PARENT_ID = Q.MYENTITY_ID AND R.ATTRIBUTE_ID = 83396591)
LEFT OUTER JOIN ENTITIES_ATTRIBUTE T
ON (T.PARENT_ID = P.MYENTITY_ID AND T.ATTRIBUTE_ID = 83396609)
LEFT OUTER JOIN STRING_ATTRIBUTE S
ON (S.PARENT_ID = T.MYENTITY_ID AND S.ATTRIBUTE_ID = 83396615)
WHERE A.DELETEFLAG='N' AND A.USER_TYPE_ID=4 
ORDER BY A.ID;
  
  

rem : 1>Author name 		: Tapan
rem : 2>Purpose of change	: Modified the HOME_USER_VIEW view to have the desired results
rem : 3>Date of change 		: 14-Nov-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 18

CREATE OR REPLACE FORCE VIEW "HOME_USER_PHONE_VIEW" ("ID", "TYPE", "KOLID", "PHONE", "CONTACTFLAG") AS 
  SELECT DISTINCT
A.ID, K4.VALUE, A.KOLID, K2.VALUE AS PHONE,
case 
    when K3.VALUE like 'Yes' then 1
    else 0
end  AS CONTACTFLAG
FROM USER_TABLE A
LEFT OUTER JOIN ENTITIES_ATTRIBUTE J
ON (J.PARENT_ID=A.KOLID AND J.ATTRIBUTE_ID=1)
LEFT OUTER JOIN ENTITIES_ATTRIBUTE K22
ON (K22.PARENT_ID = J.MYENTITY_ID AND K22.ATTRIBUTE_ID = 43)
LEFT OUTER JOIN STRING_ATTRIBUTE K2
ON (K2.PARENT_ID = K22.MYENTITY_ID AND K2.ATTRIBUTE_ID = 83009820)
LEFT OUTER JOIN STRING_ATTRIBUTE K3
ON (K3.PARENT_ID = K22.MYENTITY_ID AND K3.ATTRIBUTE_ID = 83009821)
LEFT OUTER JOIN STRING_ATTRIBUTE K4
ON (K4.PARENT_ID = K22.MYENTITY_ID AND K4.ATTRIBUTE_ID = 44)
WHERE A.DELETEFLAG='N' AND A.USER_TYPE_ID=4
ORDER BY A.ID;
   

rem : 1>Author name 		: Tapan
rem : 2>Purpose of change	: Modified the HOME_USER_PHONE_VIEW view to consider the primary contact flag value.
rem : 3>Date of change 		: 14-Nov-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 19

create or replace FUNCTION GETCONTACTS(IDnew NUMBER) RETURN VARCHAR2 is V VARCHAR2(4000);
begin
v:='';
declare
cursor c1 is
select distinct(u.lastname||','||u.firstname) as contactname from user_table u
where u.staffid in (select c.staffid from contacts c where c.kolid =idnew) 
order by contactname;
begin
for cr in c1
loop
v :=v||cr.contactname||' ;';
end loop;
end;
RETURN substr(V,0,length(V)-1);
END;
   

rem : 1>Author name 		: Tapan
rem : 2>Purpose of change	: Modified the getContacts Function.
rem : 3>Date of change 		: 14-Nov-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 20

CREATE TABLE AUDIT_LOG ( 
  AUDIT_LOG_ID NUMBER(22,0) NOT NULL,
  ENTITY_ID VARCHAR2(50) NOT NULL,
  ENTITY_CLASS VARCHAR2(100) NOT NULL,
  ENTITY_ATTRIBUTE VARCHAR2(50) NOT NULL,
  OLD_VALUE VARCHAR2(4000) NULL,
  NEW_VALUE VARCHAR2(4000) NULL,
  OPERATION_TYPE VARCHAR2(50) NULL,
  USER_ID NUMBER(22,0) NOT NULL,
  UPDATED_DATE TIMESTAMP(6) NOT NULL,
  PRIMARY KEY(AUDIT_LOG_ID)
);

CREATE INDEX AUDIT_LOG_ID_ATTR_INDX ON AUDIT_LOG(ENTITY_ID, ENTITY_ATTRIBUTE);

CREATE TABLE AUDIT_LOG_HISTORY ( 
  AUDIT_LOG_ID NUMBER(22,0) NOT NULL,
  ENTITY_ID VARCHAR2(50) NOT NULL,
  ENTITY_CLASS VARCHAR2(100) NOT NULL,
  ENTITY_ATTRIBUTE VARCHAR2(50) NOT NULL,
  OLD_VALUE VARCHAR2(4000) NULL,
  NEW_VALUE VARCHAR2(4000) NULL,
  OPERATION_TYPE VARCHAR2(50) NULL,
  USER_ID NUMBER(22,0) NOT NULL,
  UPDATED_DATE TIMESTAMP(6) NOT NULL,
  ARCHIVED_DATE TIMESTAMP(6) NOT NULL,
  PRIMARY KEY(AUDIT_LOG_ID)
);

CREATE OR REPLACE PROCEDURE AUDITRECORDSARCHIVEPROCEDURE
 (CURRENTDATE VARCHAR2, ARCHIVEDATE VARCHAR2)
 IS BEGIN
   INSERT INTO AUDIT_LOG_HISTORY
     (AUDIT_LOG_ID, ENTITY_ID, ENTITY_CLASS, ENTITY_ATTRIBUTE, OLD_VALUE, NEW_VALUE,
      OPERATION_TYPE, USER_ID, UPDATED_DATE, ARCHIVED_DATE)
     (SELECT AUDIT_LOG_ID, ENTITY_ID, ENTITY_CLASS, ENTITY_ATTRIBUTE, OLD_VALUE,
      NEW_VALUE, OPERATION_TYPE, USER_ID, UPDATED_DATE, TO_DATE(CURRENTDATE, 'yyyy/mm/dd:hh:mi:ssam')
      FROM AUDIT_LOG WHERE UPDATED_DATE < TO_DATE(ARCHIVEDATE, 'yyyy/mm/dd:hh:mi:ssam'));
    DELETE FROM AUDIT_LOG WHERE UPDATED_DATE < TO_DATE(ARCHIVEDATE, 'yyyy/mm/dd:hh:mi:ssam');
END

rem : 1>Author name 		: Amit
rem : 2>Purpose of change	: Adding create table statements for Audit related tables
rem : 3>Date of change 		: 14-Nov-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 21

CREATE OR REPLACE FORCE VIEW "HOME_USER_ADDRESS_VIEW" ("ID", "KOLID", "ADDR_LINE1", "ADDR_LINE2", "STATE", "COUNTRY", "CITY", "USAGE", "ZIP") AS 
  SELECT
A.ID,A.KOLID, P.VALUE AS ADDR_LINE1,Q.VALUE AS ADDR_LINE2,
H.VALUE AS STATE, I.VALUE AS COUNTRY,L.VALUE AS CITY,K1.VALUE AS USAGE,T1.VALUE AS ZIP
FROM USER_TABLE A
LEFT OUTER JOIN ENTITIES_ATTRIBUTE J
ON (J.PARENT_ID=A.KOLID AND J.ATTRIBUTE_ID=1)
LEFT OUTER JOIN ENTITIES_ATTRIBUTE T2
ON (T2.PARENT_ID=J.MYENTITY_ID AND T2.ATTRIBUTE_ID=34)
LEFT OUTER JOIN STRING_ATTRIBUTE T1
ON (T1.PARENT_ID=T2.MYENTITY_ID AND T1.ATTRIBUTE_ID=41)
LEFT OUTER JOIN STRING_ATTRIBUTE H
ON (H.PARENT_ID=T2.MYENTITY_ID AND H.ATTRIBUTE_ID=40)
LEFT OUTER JOIN STRING_ATTRIBUTE I
ON (I.PARENT_ID = T2.MYENTITY_ID AND I.ATTRIBUTE_ID=42)
LEFT OUTER JOIN STRING_ATTRIBUTE K1
ON (K1.PARENT_ID = T2.MYENTITY_ID AND K1.ATTRIBUTE_ID=36)
LEFT OUTER JOIN STRING_ATTRIBUTE L
ON (L.PARENT_ID = T2.MYENTITY_ID AND L.ATTRIBUTE_ID=39)
LEFT OUTER JOIN STRING_ATTRIBUTE P
ON (P.PARENT_ID = T2.MYENTITY_ID AND P.ATTRIBUTE_ID = 37)
LEFT OUTER JOIN STRING_ATTRIBUTE Q
ON (Q.PARENT_ID = T2.MYENTITY_ID AND Q.ATTRIBUTE_ID = 38)
WHERE A.DELETEFLAG='N' AND A.USER_TYPE_ID=4 
ORDER BY A.ID;
   

rem : 1>Author name 		: Tapan
rem : 2>Purpose of change	: Added ADDR_LINE1 and ADDR_LINE2 fields to the HOME_USER_ADDRESS_VIEW.
rem : 3>Date of change 		: 15-Nov-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 22

insert into feature_usergroup_map(id,feature_id,usergroup_id,permission_on_feature)
values (HIBERNATE_SEQUENCE.NEXTVAL,83005886,',83397591,',4);
insert into feature_usergroup_map(id,feature_id,usergroup_id,permission_on_feature)
values (HIBERNATE_SEQUENCE.NEXTVAL,83005885,',83397591,',4);
insert into feature_usergroup_map(id,feature_id,usergroup_id,permission_on_feature)
values (HIBERNATE_SEQUENCE.NEXTVAL,83005891,',83397591,',4);
commit;

rem : 1>Author name 		: Kiruba
rem : 2>Purpose of change	: Search attributes restricted for SAXA_JV Group.
rem : 3>Date of change 		: 15-Nov-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 23

CREATE OR REPLACE FORCE VIEW "HOME_USER_ADDRESS_VIEW" ("UNQ_ID", "ID", "KOLID", "ADDR_LINE1", "ADDR_LINE2", "STATE", "COUNTRY", "CITY", "USAGE", "TYPE", "ZIP") AS 
  SELECT
ROWNUM AS UNQ_ID,A.ID,A.KOLID, P.VALUE AS ADDR_LINE1,Q.VALUE AS ADDR_LINE2,
H.VALUE AS STATE, I.VALUE AS COUNTRY,L.VALUE AS CITY,K1.VALUE AS USAGE,K2.VALUE AS TYPE,T1.VALUE AS ZIP
FROM USER_TABLE A
LEFT OUTER JOIN ENTITIES_ATTRIBUTE J
ON (J.PARENT_ID=A.KOLID AND J.ATTRIBUTE_ID=1)
LEFT OUTER JOIN ENTITIES_ATTRIBUTE T2
ON (T2.PARENT_ID=J.MYENTITY_ID AND T2.ATTRIBUTE_ID=34)
LEFT OUTER JOIN STRING_ATTRIBUTE T1
ON (T1.PARENT_ID=T2.MYENTITY_ID AND T1.ATTRIBUTE_ID=41)
LEFT OUTER JOIN STRING_ATTRIBUTE H
ON (H.PARENT_ID=T2.MYENTITY_ID AND H.ATTRIBUTE_ID=40)
LEFT OUTER JOIN STRING_ATTRIBUTE I
ON (I.PARENT_ID = T2.MYENTITY_ID AND I.ATTRIBUTE_ID=42)
LEFT OUTER JOIN STRING_ATTRIBUTE K1
ON (K1.PARENT_ID = T2.MYENTITY_ID AND K1.ATTRIBUTE_ID=36)
LEFT OUTER JOIN STRING_ATTRIBUTE K2
ON (K2.PARENT_ID = T2.MYENTITY_ID AND K2.ATTRIBUTE_ID=35)/*Address Type*/
LEFT OUTER JOIN STRING_ATTRIBUTE L
ON (L.PARENT_ID = T2.MYENTITY_ID AND L.ATTRIBUTE_ID=39)
LEFT OUTER JOIN STRING_ATTRIBUTE P
ON (P.PARENT_ID = T2.MYENTITY_ID AND P.ATTRIBUTE_ID = 37)
LEFT OUTER JOIN STRING_ATTRIBUTE Q
ON (Q.PARENT_ID = T2.MYENTITY_ID AND Q.ATTRIBUTE_ID = 38)
WHERE A.DELETEFLAG='N' AND A.USER_TYPE_ID=4
ORDER BY A.ID;

COMMIT;

rem : 1>Author name 		: Kiruba
rem : 2>Purpose of change	: Address type brought into the view and a unique column added.
rem : 3>Date of change 		: 17-Nov-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 24

insert into surveyquestionsmetadata(ID,SURVEYID,QUESTIONTEXT,TYPE,MANDATORY,QUESTIONNUMBER)
values
(HIBERNATE_SEQUENCE.NEXTVAL,83395360,'Describe areas of diabetes research that are of greatest interest or priority to him/her ?','simpleText','false',15);

COMMIT;

rem : 1>Author name 		: Kiruba
rem : 2>Purpose of change	: New Question added into the saxa profiling survey.
rem : 3>Date of change 		: 17-Nov-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 25

CREATE OR REPLACE FORCE VIEW "HOME_USER_PHONE_VIEW" ("UNQ_ID", "ID", "TYPE", "KOLID", "PHONE", "CONTACTFLAG") AS 
  SELECT DISTINCT
ROWNUM AS UNQ_ID,A.ID, K4.VALUE, A.KOLID, K2.VALUE AS PHONE,
case 
    when K3.VALUE like 'Yes' then 1
    else 0
end  AS CONTACTFLAG
FROM USER_TABLE A
LEFT OUTER JOIN ENTITIES_ATTRIBUTE J
ON (J.PARENT_ID=A.KOLID AND J.ATTRIBUTE_ID=1)
LEFT OUTER JOIN ENTITIES_ATTRIBUTE K22
ON (K22.PARENT_ID = J.MYENTITY_ID AND K22.ATTRIBUTE_ID = 43)
LEFT OUTER JOIN STRING_ATTRIBUTE K2
ON (K2.PARENT_ID = K22.MYENTITY_ID AND K2.ATTRIBUTE_ID = 83009820)
LEFT OUTER JOIN STRING_ATTRIBUTE K3
ON (K3.PARENT_ID = K22.MYENTITY_ID AND K3.ATTRIBUTE_ID = 83009821)
LEFT OUTER JOIN STRING_ATTRIBUTE K4
ON (K4.PARENT_ID = K22.MYENTITY_ID AND K4.ATTRIBUTE_ID = 44)
WHERE A.DELETEFLAG='N' AND A.USER_TYPE_ID=4
ORDER BY A.ID;

COMMIT;

rem : 1>Author name 		: Kiruba
rem : 2>Purpose of change	: Home User Phone View modified for unique rows.
rem : 3>Date of change 		: 17-Nov-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 26

CREATE OR REPLACE FORCE VIEW  "HCP_OL_SUMMARY" ("KOLID", "CVMET OL TYPE", "MSL OL TYPE", "SAXA REVIEW STATUS") AS 
  select u.kolid ,str1.value as "CVMET OL TYPE",
str2.value as "MSL OL TYPE",
str3.value as "SAXA REVIEW STATUS"
from
(select u.kolid kolid,st1.value 
from entities_attribute en,
entities_attribute en1,
string_attribute st1,
user_table u
where st1.parent_id = en1.myentity_id
and en1.parent_id = en.myentity_id
and en.parent_id = u.kolid
and st1.attribute_id = 83005851)str1,




(select u.kolid kolid,st2.value 
from entities_attribute en,
entities_attribute en1,
string_attribute st2,
user_table u
where st2.parent_id = en1.myentity_id
and en1.parent_id = en.myentity_id
and en.parent_id = u.kolid
and st2.attribute_id = 83396591)str2,

(select u.kolid kolid,st3.value 
from entities_attribute en,
entities_attribute en1,
string_attribute st3,
user_table u
where st3.parent_id = en1.myentity_id
and en1.parent_id = en.myentity_id
and en.parent_id = u.kolid
and st3.attribute_id = 83396620)str3,
user_table u
where u.kolid = str1.kolid(+)
and u.kolid = str2.kolid(+)
and u.kolid = str3.kolid(+)
and u.user_type_id = 4;
 
 
  

rem : 1>Author name 		: Dayanand
rem : 2>Purpose of change	: Created the view for MSL ol Type,Saxa Status,CVMET Ol Type
rem : 3>Date of change 		: 12-Nov-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 27


  CREATE OR REPLACE FORCE VIEW "BMS"."HCP_OL_SUMMARY" ("EXPERT_ID", "KOLID", "CVMET_OL_TYPE", "MSL_OL_TYPE", "SAXA_REVIEW_STATUS") AS 
  select U.ID, u.kolid ,str1.value as "CVMET OL TYPE",
str2.value as "MSL OL TYPE",
str3.value as "SAXA REVIEW STATUS"
from
(select u.kolid kolid,st1.value
from entities_attribute en,
entities_attribute en1,
string_attribute st1,
user_table u
where st1.parent_id = en1.myentity_id
and en1.parent_id = en.myentity_id
and en.parent_id = u.kolid
and st1.attribute_id = 83396615)str1,

(select u.kolid kolid,st2.value
from entities_attribute en,
entities_attribute en1,
string_attribute st2,
user_table u
where st2.parent_id = en1.myentity_id
and en1.parent_id = en.myentity_id
and en.parent_id = u.kolid
and st2.attribute_id = 83396591)str2,

(select u.kolid kolid,st3.value
from entities_attribute en,
entities_attribute en1,
string_attribute st3,
user_table u
where st3.parent_id = en1.myentity_id
and en1.parent_id = en.myentity_id
and en.parent_id = u.kolid
and st3.attribute_id = 83612120)str3,
user_table u
where u.kolid = str1.kolid(+)
and u.kolid = str2.kolid(+)
and u.kolid = str3.kolid(+)
and u.user_type_id=4;
 


rem : 1>Author name 		: Deepak
rem : 2>Purpose of change	: Modified the view to add kols userid and remove spaces from column names
rem : 3>Date of change 		: 20-Nov-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 28

update string_attribute set value='Off-plan OL/HCP' where value='Off-Plan OL/HCP';

commit;

rem : 1>Author name 		: Deepak
rem : 2>Purpose of change	: correct the spelling
rem : 3>Date of change 		: 20-Nov-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 29


create or replace FUNCTION GETPRIMARYADDRESS(IDNEW NUMBER) RETURN NUMBER IS UNQ_ID NUMBER;
BEGIN
UNQ_ID:=0;
DECLARE 
 V_UNQ_ID HOME_USER_ADDRESS_VIEW.UNQ_ID%TYPE;
 V_USAGE HOME_USER_ADDRESS_VIEW.USAGE%TYPE;
 CURSOR C_ALLADDRESSES IS
    SELECT *
      FROM HOME_USER_ADDRESS_VIEW HUAV WHERE HUAV.KOLID = IDNEW 
      AND HUAV.ADDR_LINE1 IS NOT NULL ORDER BY HUAV.USAGE;
 V_ADDRESSREC  C_ALLADDRESSES%ROWTYPE;
BEGIN
  OPEN C_ALLADDRESSES;
  LOOP
  FETCH C_ALLADDRESSES INTO V_ADDRESSREC;
  EXIT WHEN C_ALLADDRESSES%NOTFOUND OR C_ALLADDRESSES%ROWCOUNT>1;
  UNQ_ID:= V_ADDRESSREC.UNQ_ID;
  END LOOP;
  CLOSE C_ALLADDRESSES;
  END;
  RETURN UNQ_ID;
  END;

rem : 1>Author name 		: Tapan
rem : 2>Purpose of change	: getPrimaryAddress: A New function to return the Primary Address, if not then Secondary Address else any Address.
rem : 3>Date of change 		: 15-Nov-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 30

create or replace FUNCTION GETPRIMARYCONTACT(IDNEW NUMBER,CONTACTTYPE VARCHAR2) RETURN NUMBER IS UNIQUE_ID NUMBER;
BEGIN
UNIQUE_ID:=0;
DECLARE 
 CURSOR C_ALLPHONES IS
    SELECT * FROM HOME_USER_PHONE_VIEW HUPV 
    WHERE HUPV.KOLID = IDNEW 
    and hupv.type is not null and hupv.type = CONTACTTYPE
    ORDER  BY HUPV.CONTACTFLAG DESC;
 V_PHONEREC C_ALLPHONES%ROWTYPE;
BEGIN
  OPEN C_ALLPHONES;
  LOOP
  FETCH C_ALLPHONES INTO V_PHONEREC;
  EXIT WHEN C_ALLPHONES%NOTFOUND OR C_ALLPHONES%ROWCOUNT>1;
  UNIQUE_ID:= V_PHONEREC.UNQ_ID;
   END LOOP;
  CLOSE C_ALLPHONES;
  END;
  RETURN UNIQUE_ID;
  END;
  

rem : 1>Author name 		: Tapan
rem : 2>Purpose of change	: getPrimaryContact: Function to return the Primary Contact (Any type of Contact) 
rem : 3>Date of change 		: 15-Nov-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 31

update user_table u
set u.password='Et6pb+wgWTVmq3VpLJlJWWgzrck='
where u.username='user';

update user_table u
set u.password='BieGq+qUrQ5gmaQ0/hk3PNmeYt4='
where u.username='admin';

commit;

rem : 1>Author name 		: Vaibhav
rem : 2>Purpose of change	: To store the encripted passwords of user and admin in db. 
rem : 3>Date of change 		: 21-Nov-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 32

ALTER TABLE INTERACTION 
DROP COLUMN "THERAPEUTIC_AREA_ID";

rem : 1>Author name 		: Deepak
rem : 2>Purpose of change	: column no longer required. Data stored in TA column
rem : 3>Date of change 		: 21-Nov-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 33

INSERT INTO FEATURE_USERGROUP_MAP
SELECT
HIBERNATE_SEQUENCE.NEXTVAL AS ID, 
Z.FEATURE_ID, 
','||Z.USERGROUP_ID||',', 
Z.PERMISSION_ON_FEATURE
FROM 
(SELECT OPTION_LOOKUP.ID FEATURE_ID, 
(SELECT GROUPID FROM GROUPS WHERE GROUPNAME='SAXA_JV') USERGROUP_ID,
(SELECT ID FROM FEATURE_PERMISSION_METADATA WHERE PERMISSION_NAME = 'LOV Permission') PERMISSION_ON_FEATURE
FROM OPTION_NAMES , OPTION_LOOKUP
WHERE OPTION_NAMES.ID = OPTION_LOOKUP.OPTION_ID
AND OPTION_NAMES.NAME = 'Product'
AND OPTION_LOOKUP.OPTVALUE != 'Diabetes' 
AND OPTION_LOOKUP.DELETEFLAG != 'Y') Z;

COMMIT;

rem : 1>Author name 		: Deepak
rem : 2>Purpose of change	: Only have 'Diabetes' for Product LOV for SAXA_JV group
rem : 3>Date of change 		: 24-Nov-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 34

truncate table ATTENDEES drop storage;
truncate table INTERACTION_DATA drop storage;
delete from INTERACTION ;
commit;

ALTER TABLE INTERACTION 
DROP COLUMN "EXPENSE_TYPE_ID"
;

ALTER TABLE INTERACTION 
DROP COLUMN "SIM_ID"
;

ALTER TABLE INTERACTION 
DROP COLUMN "SITE_ID"
;

ALTER TABLE INTERACTION 
DROP COLUMN "INTASSESS"
;

ALTER TABLE INTERACTION 
DROP COLUMN "EXPENSE_AMOUNT"
;

ALTER TABLE INTERACTION 
DROP COLUMN "LITERATURE"
;

ALTER TABLE INTERACTION 
DROP COLUMN "EXPENSE_VENUE"
;

ALTER TABLE INTERACTION 
DROP COLUMN "FA"
;

ALTER TABLE INTERACTION 
DROP COLUMN "REGION"
;

ALTER TABLE INTERACTION 
DROP COLUMN "STATUS"
;
ALTER TABLE INTERACTION 
DROP COLUMN "STAFFIDS"
;

ALTER TABLE ATTENDEES 
DROP COLUMN "TITLE"
;

ALTER TABLE ATTENDEES 
DROP COLUMN "STATE"
;

ALTER TABLE ATTENDEES 
DROP COLUMN "TA"
;

ALTER TABLE ATTENDEES 
DROP COLUMN "TYPE"
;

ALTER TABLE ATTENDEES 
DROP COLUMN "FIRSTNAME"
;

ALTER TABLE ATTENDEES 
DROP COLUMN "LASTNAME"
;

ALTER TABLE ATTENDEES 
DROP COLUMN "SSOID"
;

ALTER TABLE ATTENDEES 
DROP COLUMN "SSNAME"
;

ALTER TABLE ATTENDEES 
DROP COLUMN "CITY"
;

ALTER TABLE ATTENDEES 
DROP COLUMN "ZIP"
;
ALTER TABLE INTERACTION_DATA 
MODIFY ("LOVID" NUMBER)
;
ALTER TABLE INTERACTION_DATA 
MODIFY ("INTERACTION_ID" NUMBER)
;
ALTER TABLE INTERACTION_DATA 
DROP COLUMN "STATUSID"
;
ALTER TABLE ATTENDEES 
DROP CONSTRAINT "FKEADFCAF92F841268"
;

ALTER TABLE ATTENDEES 
ADD CONSTRAINT ATTENDEES_INTERACTION_FK1 FOREIGN KEY 
(
"INTERACTION_ID"
) REFERENCES INTERACTION 
(
"INTERACTION_ID"
)
ON DELETE CASCADE ENABLE
;

ALTER TABLE INTERACTION_DATA 
ADD CONSTRAINT INTERACTION_DATA_OPTION_L_FK3 FOREIGN KEY 
(
"LOVID"
) REFERENCES OPTION_LOOKUP 
(
"ID"
) ENABLE
;
ALTER TABLE INTERACTION_DATA 
ADD CONSTRAINT INTERACTION_DATA_INTERACT_FK1 FOREIGN KEY 
(
"INTERACTION_ID"
) REFERENCES INTERACTION 
(
"INTERACTION_ID"
)
ON DELETE CASCADE ENABLE
;
ALTER TABLE INTERACTION_LOVTRIPLET_SECTION 
ADD CONSTRAINT INTERACTION_LOVTRIPLET_SE_FK1 FOREIGN KEY 
(
"PRIMARY_LOVID"
) REFERENCES OPTION_LOOKUP 
(
"ID"
) ENABLE
;

ALTER TABLE INTERACTION_LOVTRIPLET_SECTION 
ADD CONSTRAINT INTERACTION_LOVTRIPLET_SE_FK2 FOREIGN KEY 
(
"SECONDARY_LOVID"
) REFERENCES OPTION_LOOKUP 
(
"ID"
) ENABLE
;

ALTER TABLE INTERACTION_LOVTRIPLET_SECTION 
ADD CONSTRAINT INTERACTION_LOVTRIPLET_SE_FK3 FOREIGN KEY 
(
"TERTIARY_LOVID"
) REFERENCES OPTION_LOOKUP 
(
"ID"
) ENABLE
;


rem : 1>Author name 		: Deepak
rem : 2>Purpose of change	: Interaction cleanup
rem : 3>Date of change 		: 30-Nov-2008

rem ------------------------------------------------------------------------------------------------


rem : Batch : 35

CREATE OR REPLACE FORCE VIEW  "HCP_OL_SUMMARY" ("EXPERT_ID", "KOLID", "CVMET_OL_TYPE", "MSL_OL_TYPE", "SAXA_REVIEW_STATUS") AS 
 select U.ID, u.kolid ,str1.value as "CVMET OL TYPE",
str2.value as "MSL OL TYPE",
str3.value as "SAXA REVIEW STATUS"
from
(select u.kolid kolid,st1.value
from entities_attribute en,
entities_attribute en1,
string_attribute st1,
user_table u
where st1.parent_id = en1.myentity_id
and en1.parent_id = en.myentity_id
and en.parent_id = u.kolid
and st1.attribute_id = 83396615)str1,

(select u.kolid kolid,st2.value
from entities_attribute en,
entities_attribute en1,
string_attribute st2,
user_table u
where st2.parent_id = en1.myentity_id
and en1.parent_id = en.myentity_id
and en.parent_id = u.kolid
and st2.attribute_id = 83396591)str2,

(select u.kolid kolid,st3.value
from entities_attribute en,
entities_attribute en1,
string_attribute st3,
user_table u
where st3.parent_id = en1.myentity_id
and en1.parent_id = en.myentity_id
and en.parent_id = u.kolid
and st3.attribute_id = 83396620)str3,
user_table u
where u.kolid = str1.kolid(+)
and u.kolid = str2.kolid(+)
and u.kolid = str3.kolid(+)
and u.user_type_id=4;

rem : 1>Author name 		: Dayanand
rem : 2>Purpose of change	: Changed the Attribute_id for saxa review status
rem : 3>Date of change 		: 4-Dec-2008

rem ------------------------------------------------------------------------------------------------
 
  
rem : Batch : 36

CREATE OR REPLACE
FUNCTION MultiOptMultiSelConcat(IDNew NUMBER) RETURN VARCHAR2 is V VARCHAR2(4000);
begin
v:='';
declare
cursor c1 is
select sa.answertext as NAME from filled_subques_answers fa, surveyanswersdata sa WHERE fa.parent_question=IDNew and fa.answer_option= sa.id order by NAME;
begin
for cr in c1
loop
v :=v||cr.name||' ,';
end loop;
end;
RETURN substr(V,0,length(V)-1);
END;


rem : 1>Author name         : Dayanand
rem : 2>Purpose of change   : TO get the Results in comma separated form
rem : 3>Date of change  : 11-Dec-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 37 


CREATE OR REPLACE
PROCEDURE AUDITRECORDSARCHIVEPROCEDURE
 (CURRENTDATE VARCHAR2, ARCHIVEDATE VARCHAR2)
 IS BEGIN
   INSERT INTO AUDIT_LOG_HISTORY
     (AUDIT_LOG_ID, ENTITY_ID, ENTITY_CLASS, ENTITY_ATTRIBUTE, OLD_VALUE, NEW_VALUE,
      OPERATION_TYPE, USER_ID, UPDATED_DATE, ARCHIVED_DATE)
     (SELECT AUDIT_LOG_ID, ENTITY_ID, ENTITY_CLASS, ENTITY_ATTRIBUTE, OLD_VALUE,
      NEW_VALUE, OPERATION_TYPE, USER_ID, UPDATED_DATE, TO_DATE(CURRENTDATE, 'yyyy/mm/dd:hh:mi:ssam')
      FROM AUDIT_LOG WHERE UPDATED_DATE < TO_DATE(ARCHIVEDATE, 'yyyy/mm/dd:hh:mi:ssam'));
    DELETE FROM AUDIT_LOG WHERE UPDATED_DATE < TO_DATE(ARCHIVEDATE, 'yyyy/mm/dd:hh:mi:ssam');
END;
 
rem : 1>Author name 		: Dayanand
rem : 2>Purpose of change	: Modified Amit's Audit Procedure'
rem : 3>Date of change 	: 10-Dec-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 38

CREATE OR REPLACE FORCE VIEW "SURVEY_SAXA_VIEW" ("EXPERTID", "QUESTIONNUMBER", "ANSWER") AS 
  (select fs.expertid as expertid,sqm.QUESTIONNUMBER as questionnumber,
case when sqm.type='multioptsinglesel' then sans.answertext
     when sqm.type='multioptmultisel' then MULTIOPTMULTISELCONCAT(fsans.PARENT_QUESTION)   
end answer
from filled_survey fs, SURVEYMETADATA sm , FILLED_QUESTIONS fq, SURVEYQUESTIONSMETADATA sqm, SURVEYANSWERSDATA sans, FILLED_SUBQUES_ANSWERS fsans
where
fs.surveyid = sm.id
and fq.parent_survey = fs.id
and fq.questionid = sqm.id
and fsans.PARENT_QUESTION = fq.id
and fsans.answer_option = sans.id
and sans.QUESTIONID = sqm.id
)   
UNION ALL
(select fs.expertid as expertId,sqm.QUESTIONNUMBER as questionNumber,fq.answer_text as answer
from filled_survey fs, SURVEYMETADATA sm , FILLED_QUESTIONS fq, SURVEYQUESTIONSMETADATA sqm
where
fs.surveyid = sm.id
and fq.parent_survey = fs.id
and fq.questionid = sqm.id
and sqm.type in ('simpleText', 'numText'));
 
 
rem : 1>Author name         : Dayanand
rem : 2>Purpose of change   : Created View for Saxa Profiling
rem : 3>Date of change  : 10-Dec-2008


rem ------------------------------------------------------------------------------------------------

rem : Batch : 39

CREATE OR REPLACE
TRIGGER BOOLEAN_AUDIT BEFORE INSERT OR UPDATE OR DELETE ON BOOLEAN_ATTRIBUTE 
FOR EACH ROW 
BEGIN
    IF INSERTING THEN
      /*INSERT INTO ALERT_AUDIT_QUEUE(ID, ATTRIBUTE, ATTRIBUTE_ID, NEW_VALUE, OPERATION, CREATED_AT, UPDATED_AT, SOURCE)
        VALUES(HIBERNATE_SEQUENCE.NEXTVAL, :NEW.ID, :NEW.ATTRIBUTE_ID, :NEW.VALUE, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'BooleanAttribute');
      */
 
 INSERT INTO ALERT_AUDIT_QUEUE(ID,ATTRIBUTE, ATTRIBUTE_ID, NEW_VALUE, OPERATION, CREATED_AT, UPDATED_AT,SOURCE,KOLID )
  VALUES(HIBERNATE_SEQUENCE.NEXTVAL,nvl(:NEW.ID,0), nvl((select attribute_id  from attributetable where entity_type_id = 
 (select parent_id from attributetable where attribute_id=:NEW.ATTRIBUTE_ID)),0),:NEW.VALUE, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'BooleanAttribute',
   nvl((select u.id from  entities_attribute atts1, entities_attribute atts2, user_table u
 where atts1.myentity_id = :NEW.PARENT_ID 
 and atts1.parent_id = atts2.myentity_id
 and atts2.parent_id = u.kolid),0));


    END IF;
    IF UPDATING THEN
      /*INSERT INTO ALERT_AUDIT_QUEUE(ID, ATTRIBUTE, ATTRIBUTE_ID, ORIGINAL_VALUE, NEW_VALUE, OPERATION, CREATED_AT, UPDATED_AT, SOURCE)
        VALUES(HIBERNATE_SEQUENCE.NEXTVAL, :NEW.ID, :NEW.ATTRIBUTE_ID, :OLD.VALUE, :NEW.VALUE, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'BooleanAttribute' );
      */
      
 INSERT INTO ALERT_AUDIT_QUEUE(ID,ATTRIBUTE, ATTRIBUTE_ID, ORIGINAL_VALUE,NEW_VALUE, OPERATION, CREATED_AT, UPDATED_AT,SOURCE,KOLID )
  VALUES(HIBERNATE_SEQUENCE.NEXTVAL,nvl(:NEW.ID,0), nvl((select attribute_id  from attributetable where entity_type_id = 
 (select parent_id from attributetable where attribute_id=:NEW.ATTRIBUTE_ID)),0),:OLD.VALUE, :NEW.VALUE, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'BooleanAttribute',
   nvl((select u.id from  entities_attribute atts1, entities_attribute atts2, user_table u
 where atts1.myentity_id = :NEW.PARENT_ID 
 and atts1.parent_id = atts2.myentity_id
 and atts2.parent_id = u.kolid),0));
 
    END IF;
    IF DELETING THEN
     /* INSERT INTO ALERT_AUDIT_QUEUE(ID, ATTRIBUTE, ATTRIBUTE_ID, ORIGINAL_VALUE, OPERATION, CREATED_AT, UPDATED_AT, SOURCE)
        VALUES(HIBERNATE_SEQUENCE.NEXTVAL, (SELECT EA2.PARENT_ID FROM ENTITIES_ATTRIBUTE EA1, ENTITIES_ATTRIBUTE EA2 
    WHERE EA1.MYENTITY_ID=:OLD.PARENT_ID AND EA2.MYENTITY_ID = EA1.PARENT_ID), :OLD.ATTRIBUTE_ID, :OLD.VALUE, 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'BooleanAttribute');
      */
 
 INSERT INTO ALERT_AUDIT_QUEUE(ID,ATTRIBUTE, ATTRIBUTE_ID, ORIGINAL_VALUE, OPERATION, CREATED_AT, UPDATED_AT,SOURCE,KOLID )
  VALUES(HIBERNATE_SEQUENCE.NEXTVAL,nvl(:OLD.ID,0), nvl((select attribute_id  from attributetable where entity_type_id = 
 (select parent_id from attributetable where attribute_id=:OLD.ATTRIBUTE_ID)),0),:OLD.VALUE, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'BooleanAttribute',
   nvl((select u.id from  entities_attribute atts1, entities_attribute atts2, user_table u
 where atts1.myentity_id = :OLD.PARENT_ID 
 and atts1.parent_id = atts2.myentity_id
 and atts2.parent_id = u.kolid),0));
    END IF;
  END;

rem : 1>Author name 		: Dayanand
rem : 2>Purpose of change	: Boolean Audit modified
rem : 3>Date of change 	: 15-Dec-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 40


create or replace TRIGGER DATE_AUDIT BEFORE INSERT OR UPDATE OR DELETE ON DATE_ATTRIBUTE 
FOR EACH ROW 
BEGIN
    IF INSERTING THEN
     /* INSERT INTO ALERT_AUDIT_QUEUE(ID, ATTRIBUTE, ATTRIBUTE_ID, NEW_VALUE, OPERATION, CREATED_AT, UPDATED_AT, SOURCE)
        VALUES(HIBERNATE_SEQUENCE.NEXTVAL, :NEW.ID, :NEW.ATTRIBUTE_ID, :NEW.VALUE, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'DateAttribute');
      */
 
 INSERT INTO ALERT_AUDIT_QUEUE(ID,ATTRIBUTE, ATTRIBUTE_ID, NEW_VALUE, OPERATION, CREATED_AT, UPDATED_AT,SOURCE,KOLID )
  VALUES(HIBERNATE_SEQUENCE.NEXTVAL,nvl(:NEW.ID,0), nvl((select attribute_id  from attributetable where entity_type_id = 
 (select parent_id from attributetable where attribute_id=:NEW.ATTRIBUTE_ID)),0),:NEW.VALUE, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'DateAttribute',
   nvl((select u.id from  entities_attribute atts1, entities_attribute atts2, user_table u
 where atts1.myentity_id = :NEW.PARENT_ID 
 and atts1.parent_id = atts2.myentity_id
 and atts2.parent_id = u.kolid),0));


    END IF;
    IF UPDATING THEN
     /* INSERT INTO ALERT_AUDIT_QUEUE(ID, ATTRIBUTE, ATTRIBUTE_ID, ORIGINAL_VALUE, NEW_VALUE, OPERATION, CREATED_AT, UPDATED_AT, SOURCE)
        VALUES(HIBERNATE_SEQUENCE.NEXTVAL, :NEW.ID, :NEW.ATTRIBUTE_ID, :OLD.VALUE, :NEW.VALUE, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'DateAttribute' );
      */
      
 INSERT INTO ALERT_AUDIT_QUEUE(ID,ATTRIBUTE, ATTRIBUTE_ID, ORIGINAL_VALUE,NEW_VALUE, OPERATION, CREATED_AT, UPDATED_AT,SOURCE,KOLID )
  VALUES(HIBERNATE_SEQUENCE.NEXTVAL,nvl(:NEW.ID,0), nvl((select attribute_id  from attributetable where entity_type_id = 
 (select parent_id from attributetable where attribute_id=:NEW.ATTRIBUTE_ID)),0),:OLD.VALUE, :NEW.VALUE, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'DateAttribute',
   nvl((select u.id from  entities_attribute atts1, entities_attribute atts2, user_table u
 where atts1.myentity_id = :NEW.PARENT_ID 
 and atts1.parent_id = atts2.myentity_id
 and atts2.parent_id = u.kolid),0));
 
    END IF;
    IF DELETING THEN
      /*INSERT INTO ALERT_AUDIT_QUEUE(ID, ATTRIBUTE, ATTRIBUTE_ID, ORIGINAL_VALUE, OPERATION, CREATED_AT, UPDATED_AT, SOURCE)
        VALUES(HIBERNATE_SEQUENCE.NEXTVAL, (SELECT EA2.PARENT_ID FROM ENTITIES_ATTRIBUTE EA1, ENTITIES_ATTRIBUTE EA2 
    WHERE EA1.MYENTITY_ID=:OLD.PARENT_ID AND EA2.MYENTITY_ID = EA1.PARENT_ID), :OLD.ATTRIBUTE_ID, :OLD.VALUE, 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'DateAttribute');
      */
 
 INSERT INTO ALERT_AUDIT_QUEUE(ID,ATTRIBUTE, ATTRIBUTE_ID, ORIGINAL_VALUE, OPERATION, CREATED_AT, UPDATED_AT,SOURCE,KOLID )
  VALUES(HIBERNATE_SEQUENCE.NEXTVAL,nvl(:OLD.ID,0), nvl((select attribute_id  from attributetable where entity_type_id = 
 (select parent_id from attributetable where attribute_id=:OLD.ATTRIBUTE_ID)),0),:OLD.VALUE, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'DateAttribute',
   nvl((select u.id from  entities_attribute atts1, entities_attribute atts2, user_table u
 where atts1.myentity_id = :OLD.PARENT_ID 
 and atts1.parent_id = atts2.myentity_id
 and atts2.parent_id = u.kolid),0));
    END IF;
  END;
  
rem : 1>Author name 		: Dayanand
rem : 2>Purpose of change	: Date Audit modified
rem : 3>Date of change 	: 15-Dec-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 41


create or replace TRIGGER NUMBER_AUDIT BEFORE INSERT OR UPDATE OR DELETE ON NUMBER_ATTRIBUTE 
FOR EACH ROW 
BEGIN
    IF INSERTING THEN
      /*INSERT INTO ALERT_AUDIT_QUEUE(ID, ATTRIBUTE, ATTRIBUTE_ID, NEW_VALUE, OPERATION, CREATED_AT, UPDATED_AT, SOURCE)
        VALUES(HIBERNATE_SEQUENCE.NEXTVAL, :NEW.ID, :NEW.ATTRIBUTE_ID, :NEW.VALUE, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'NUMBERAttribute');
      */
 
 INSERT INTO ALERT_AUDIT_QUEUE(ID,ATTRIBUTE, ATTRIBUTE_ID, NEW_VALUE, OPERATION, CREATED_AT, UPDATED_AT,SOURCE,KOLID )
  VALUES(HIBERNATE_SEQUENCE.NEXTVAL,nvl(:NEW.ID,0), nvl((select attribute_id  from attributetable where entity_type_id = 
 (select parent_id from attributetable where attribute_id=:NEW.ATTRIBUTE_ID)),0),:NEW.VALUE, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'NumberAttribute',
   nvl((select u.id from  entities_attribute atts1, entities_attribute atts2, user_table u
 where atts1.myentity_id = :NEW.PARENT_ID 
 and atts1.parent_id = atts2.myentity_id
 and atts2.parent_id = u.kolid),0));


    END IF;
    IF UPDATING THEN
      /*INSERT INTO ALERT_AUDIT_QUEUE(ID, ATTRIBUTE, ATTRIBUTE_ID, ORIGINAL_VALUE, NEW_VALUE, OPERATION, CREATED_AT, UPDATED_AT, SOURCE)
        VALUES(HIBERNATE_SEQUENCE.NEXTVAL, :NEW.ID, :NEW.ATTRIBUTE_ID, :OLD.VALUE, :NEW.VALUE, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'NumberAttribute' );
      */
      
 INSERT INTO ALERT_AUDIT_QUEUE(ID,ATTRIBUTE, ATTRIBUTE_ID, ORIGINAL_VALUE,NEW_VALUE, OPERATION, CREATED_AT, UPDATED_AT,SOURCE,KOLID )
  VALUES(HIBERNATE_SEQUENCE.NEXTVAL,nvl(:NEW.ID,0), nvl((select attribute_id  from attributetable where entity_type_id = 
 (select parent_id from attributetable where attribute_id=:NEW.ATTRIBUTE_ID)),0),:OLD.VALUE, :NEW.VALUE, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'NumberAttribute',
   nvl((select u.id from  entities_attribute atts1, entities_attribute atts2, user_table u
 where atts1.myentity_id = :NEW.PARENT_ID 
 and atts1.parent_id = atts2.myentity_id
 and atts2.parent_id = u.kolid),0));
 
    END IF;
    IF DELETING THEN
     /* INSERT INTO ALERT_AUDIT_QUEUE(ID, ATTRIBUTE, ATTRIBUTE_ID, ORIGINAL_VALUE, OPERATION, CREATED_AT, UPDATED_AT, SOURCE)
        VALUES(HIBERNATE_SEQUENCE.NEXTVAL, (SELECT EA2.PARENT_ID FROM ENTITIES_ATTRIBUTE EA1, ENTITIES_ATTRIBUTE EA2 
    WHERE EA1.MYENTITY_ID=:OLD.PARENT_ID AND EA2.MYENTITY_ID = EA1.PARENT_ID), :OLD.ATTRIBUTE_ID, :OLD.VALUE, 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'NumberAttribute');
      */
 
 INSERT INTO ALERT_AUDIT_QUEUE(ID,ATTRIBUTE, ATTRIBUTE_ID, ORIGINAL_VALUE, OPERATION, CREATED_AT, UPDATED_AT,SOURCE,KOLID )
  VALUES(HIBERNATE_SEQUENCE.NEXTVAL,nvl(:OLD.ID,0), nvl((select attribute_id  from attributetable where entity_type_id = 
 (select parent_id from attributetable where attribute_id=:OLD.ATTRIBUTE_ID)),0),:OLD.VALUE, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'NumberAttribute',
   nvl((select u.id from  entities_attribute atts1, entities_attribute atts2, user_table u
 where atts1.myentity_id = :OLD.PARENT_ID 
 and atts1.parent_id = atts2.myentity_id
 and atts2.parent_id = u.kolid),0));
    END IF;
  END; 
  
rem : 1>Author name 		: Dayanand
rem : 2>Purpose of change	: Number Audit modified
rem : 3>Date of change 	: 15-Dec-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 42

create or replace TRIGGER STRING_AUDIT BEFORE INSERT OR UPDATE OR DELETE ON STRING_ATTRIBUTE 
FOR EACH ROW 
BEGIN
    IF INSERTING THEN 
      /*INSERT INTO ALERT_AUDIT_QUEUE(ID, ATTRIBUTE, ATTRIBUTE_ID, NEW_VALUE, OPERATION, CREATED_AT, UPDATED_AT, SOURCE)
        VALUES(HIBERNATE_SEQUENCE.NEXTVAL, :NEW.ID, :NEW.ATTRIBUTE_ID, :NEW.VALUE, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'BooleanAttribute');
      */
 
 INSERT INTO ALERT_AUDIT_QUEUE(ID,ATTRIBUTE, ATTRIBUTE_ID, NEW_VALUE, OPERATION, CREATED_AT, UPDATED_AT,SOURCE,KOLID )
  VALUES(HIBERNATE_SEQUENCE.NEXTVAL,nvl(:NEW.ID,0), nvl((select attribute_id  from attributetable where entity_type_id = 
 (select parent_id from attributetable where attribute_id=:NEW.ATTRIBUTE_ID)),0),:NEW.VALUE, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'StringAttribute',
   nvl((select u.id from  entities_attribute atts1, entities_attribute atts2, user_table u
 where atts1.myentity_id = :NEW.PARENT_ID 
 and atts1.parent_id = atts2.myentity_id
 and atts2.parent_id = u.kolid),0));


    END IF;
    IF UPDATING THEN
      /*INSERT INTO ALERT_AUDIT_QUEUE(ID, ATTRIBUTE, ATTRIBUTE_ID, ORIGINAL_VALUE, NEW_VALUE, OPERATION, CREATED_AT, UPDATED_AT, SOURCE)
        VALUES(HIBERNATE_SEQUENCE.NEXTVAL, :NEW.ID, :NEW.ATTRIBUTE_ID, :OLD.VALUE, :NEW.VALUE, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'BooleanAttribute' );
      */
      
 INSERT INTO ALERT_AUDIT_QUEUE(ID,ATTRIBUTE, ATTRIBUTE_ID, ORIGINAL_VALUE,NEW_VALUE, OPERATION, CREATED_AT, UPDATED_AT,SOURCE,KOLID )
  VALUES(HIBERNATE_SEQUENCE.NEXTVAL,nvl(:NEW.ID,0), nvl((select attribute_id  from attributetable where entity_type_id = 
 (select parent_id from attributetable where attribute_id=:NEW.ATTRIBUTE_ID)),0),:OLD.VALUE, :NEW.VALUE, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'StringAttribute',
   nvl((select u.id from  entities_attribute atts1, entities_attribute atts2, user_table u
 where atts1.myentity_id = :NEW.PARENT_ID 
 and atts1.parent_id = atts2.myentity_id
 and atts2.parent_id = u.kolid),0));
 
    END IF;
    IF DELETING THEN
     /* INSERT INTO ALERT_AUDIT_QUEUE(ID, ATTRIBUTE, ATTRIBUTE_ID, ORIGINAL_VALUE, OPERATION, CREATED_AT, UPDATED_AT, SOURCE)
        VALUES(HIBERNATE_SEQUENCE.NEXTVAL, (SELECT EA2.PARENT_ID FROM ENTITIES_ATTRIBUTE EA1, ENTITIES_ATTRIBUTE EA2 
    WHERE EA1.MYENTITY_ID=:OLD.PARENT_ID AND EA2.MYENTITY_ID = EA1.PARENT_ID), :OLD.ATTRIBUTE_ID, :OLD.VALUE, 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'BooleanAttribute');
      */
 
 INSERT INTO ALERT_AUDIT_QUEUE(ID,ATTRIBUTE, ATTRIBUTE_ID, ORIGINAL_VALUE, OPERATION, CREATED_AT, UPDATED_AT,SOURCE,KOLID )
  VALUES(HIBERNATE_SEQUENCE.NEXTVAL,nvl(:OLD.ID,0), nvl((select attribute_id  from attributetable where entity_type_id = 
 (select parent_id from attributetable where attribute_id=:OLD.ATTRIBUTE_ID)),0),:OLD.VALUE, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'StringAttribute',
   nvl((select u.id from  entities_attribute atts1, entities_attribute atts2, user_table u
 where atts1.myentity_id = :OLD.PARENT_ID 
 and atts1.parent_id = atts2.myentity_id
 and atts2.parent_id = u.kolid),0));
    END IF;
  END;
  
rem : 1>Author name 		: Dayanand
rem : 2>Purpose of change	: String Audit modified
rem : 3>Date of change 	: 15-Dec-2008

rem ------------------------------------------------------------------------------------------------
 

ALTER TABLE FILLED_SURVEY 
ADD ("SURVEYDATE" DATE );

UPDATE FILLED_SURVEY SET SURVEYDATE=CREATEDATE WHERE SURVEYDATE IS NULL;

rem : 1>Author name 		: Kiruba
rem : 2>Purpose of change	: Altered survey filled table and added new field surveydate
rem : 3>Date of change 	: 15-Dec-2008

rem ------------------------------------------------------------------------------------------------
