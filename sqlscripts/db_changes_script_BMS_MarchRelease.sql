rem ------------------------------------------------------------------------------------------------
rem Filename    :   db_changes_script_BMS_MarchRelease.sql
rem Purpose	:   SQL changes for release
rem             
rem Date	:   16-Mar-2009
rem Author	:   Tapan
rem ------------------------------------------------------------------------------------------------

SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : db_changes_script_BMS_MarchRelease.log
SPOOL db_changes_script_BMS_MarchRelease.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------

rem : Batch : 1


drop materialized view expert_address_mview;

CREATE MATERIALIZED VIEW "EXPERT_ADDRESS_MVIEW"
REFRESH FORCE START WITH SYSDATE
NEXT trunc(SYSDATE+1) + 2/24
AS 
SELECT A.ID,A.KOLID AS KOLID,
S5.VALUE AS ADDRESS_LINE_1, S2.VALUE AS ADDRESS_LINE_2, S3.VALUE AS ADDRESS_TYPE,
S4.VALUE AS ADDRESS_PREFERRED, S1.VALUE AS ADDRESS_CITY, S6.VALUE AS ADDRESS_STATE,
S7.VALUE AS ADDRESS_POSTAL_CODE, S8.VALUE AS ADDRESS_COUNTRY
FROM
USER_TABLE A
LEFT OUTER JOIN STRING_ATTRIBUTE S1
ON (S1.ROOT_ENTITY_ID = A.KOLID AND S1.ATTRIBUTE_ID = 39)
LEFT OUTER JOIN STRING_ATTRIBUTE S2
ON (S2.ROW_ID = S1.ROW_ID AND S2.ATTRIBUTE_ID = 38)
LEFT OUTER JOIN STRING_ATTRIBUTE S3
ON (S3.ROW_ID = S1.ROW_ID AND S3.ATTRIBUTE_ID = 35)
LEFT OUTER JOIN STRING_ATTRIBUTE S4
ON (S4.ROW_ID = S1.ROW_ID AND S4.ATTRIBUTE_ID = 36)
LEFT OUTER JOIN STRING_ATTRIBUTE S5
ON (S5.ROW_ID = S1.ROW_ID AND S5.ATTRIBUTE_ID = 37)
LEFT OUTER JOIN STRING_ATTRIBUTE S6
ON (S6.ROW_ID = S1.ROW_ID AND S6.ATTRIBUTE_ID = 40)
LEFT OUTER JOIN STRING_ATTRIBUTE S7
ON (S7.ROW_ID = S1.ROW_ID AND S7.ATTRIBUTE_ID = 41)
LEFT OUTER JOIN STRING_ATTRIBUTE S8
ON (S8.ROW_ID = S1.ROW_ID AND S8.ATTRIBUTE_ID = 42)
WHERE A.USER_TYPE_ID = 4 AND A.DELETEFLAG = 'N';


create index kolid_address_mview_index on expert_address_mview(kolid);

 


create or replace FUNCTION GETPRIMARYADDRESSDETAILS(IDNEW NUMBER) 
RETURN EXPERT_PRIMARY_ADDRESS_TABLE PIPELINED IS 
OUT_REC EXPERT_PRIMARY_ADDRESS := EXPERT_PRIMARY_ADDRESS(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
BEGIN
DECLARE 
 CURSOR C_ALLADDRESSES IS
    SELECT *
      FROM EXPERT_ADDRESS_MVIEW ADDR WHERE ADDR.KOLID = IDNEW 
      AND ADDR.ADDRESS_CITY IS NOT NULL ;
 V_ADDRESSREC  C_ALLADDRESSES%ROWTYPE;
 FIRST_CHOICE VARCHAR2(100);
 SECOND_CHOICE VARCHAR2(100);
 THIRD_CHOICE VARCHAR2(100);
BEGIN
  FIRST_CHOICE := 'false';
  SECOND_CHOICE := 'false';
  THIRD_CHOICE := 'false';
  OPEN C_ALLADDRESSES;
  LOOP
  FETCH C_ALLADDRESSES INTO V_ADDRESSREC;
  EXIT WHEN C_ALLADDRESSES%NOTFOUND;
 
  IF V_ADDRESSREC.ADDRESS_TYPE = 'Business' AND V_ADDRESSREC.ADDRESS_PREFERRED = 'Primary' THEN
    FIRST_CHOICE := 'true';
    OUT_REC.ID := V_ADDRESSREC.ID;
    OUT_REC.KOLID := V_ADDRESSREC.KOLID;
    OUT_REC.ADDRESS_LINE_1 := V_ADDRESSREC.ADDRESS_LINE_1;
    OUT_REC.ADDRESS_LINE_2 := V_ADDRESSREC.ADDRESS_LINE_2;
    OUT_REC.ADDRESS_TYPE := V_ADDRESSREC.ADDRESS_TYPE;
    OUT_REC.ADDRESS_PREFERRED := V_ADDRESSREC.ADDRESS_PREFERRED;
    OUT_REC.ADDRESS_CITY := V_ADDRESSREC.ADDRESS_CITY;
    OUT_REC.ADDRESS_STATE := V_ADDRESSREC.ADDRESS_STATE;
    OUT_REC.ADDRESS_POSTAL_CODE := V_ADDRESSREC.ADDRESS_POSTAL_CODE;
    OUT_REC.ADDRESS_COUNTRY := V_ADDRESSREC.ADDRESS_COUNTRY;
    
  ELSIF V_ADDRESSREC.ADDRESS_PREFERRED = 'Primary' AND FIRST_CHOICE = 'false' THEN
    SECOND_CHOICE := 'true';  
    OUT_REC.ID := V_ADDRESSREC.ID;
    OUT_REC.KOLID := V_ADDRESSREC.KOLID;
    OUT_REC.ADDRESS_LINE_1 := V_ADDRESSREC.ADDRESS_LINE_1;
    OUT_REC.ADDRESS_LINE_2 := V_ADDRESSREC.ADDRESS_LINE_2;
    OUT_REC.ADDRESS_TYPE := V_ADDRESSREC.ADDRESS_TYPE;
    OUT_REC.ADDRESS_PREFERRED := V_ADDRESSREC.ADDRESS_PREFERRED;
    OUT_REC.ADDRESS_CITY := V_ADDRESSREC.ADDRESS_CITY;
    OUT_REC.ADDRESS_STATE := V_ADDRESSREC.ADDRESS_STATE;
    OUT_REC.ADDRESS_POSTAL_CODE := V_ADDRESSREC.ADDRESS_POSTAL_CODE;
    OUT_REC.ADDRESS_COUNTRY := V_ADDRESSREC.ADDRESS_COUNTRY;
  ELSIF V_ADDRESSREC.ADDRESS_TYPE = 'Business' AND FIRST_CHOICE = 'false' AND SECOND_CHOICE = 'false' THEN
    THIRD_CHOICE := 'true';
    OUT_REC.ID := V_ADDRESSREC.ID;
    OUT_REC.KOLID := V_ADDRESSREC.KOLID;
    OUT_REC.ADDRESS_LINE_1 := V_ADDRESSREC.ADDRESS_LINE_1;
    OUT_REC.ADDRESS_LINE_2 := V_ADDRESSREC.ADDRESS_LINE_2;
    OUT_REC.ADDRESS_TYPE := V_ADDRESSREC.ADDRESS_TYPE;
    OUT_REC.ADDRESS_PREFERRED := V_ADDRESSREC.ADDRESS_PREFERRED;
    OUT_REC.ADDRESS_CITY := V_ADDRESSREC.ADDRESS_CITY;
    OUT_REC.ADDRESS_STATE := V_ADDRESSREC.ADDRESS_STATE;
    OUT_REC.ADDRESS_POSTAL_CODE := V_ADDRESSREC.ADDRESS_POSTAL_CODE;
    OUT_REC.ADDRESS_COUNTRY := V_ADDRESSREC.ADDRESS_COUNTRY;
  ELSIF FIRST_CHOICE = 'false' AND SECOND_CHOICE = 'false' AND THIRD_CHOICE = 'false' THEN
    OUT_REC.ID := V_ADDRESSREC.ID;
    OUT_REC.KOLID := V_ADDRESSREC.KOLID;
    OUT_REC.ADDRESS_LINE_1 := V_ADDRESSREC.ADDRESS_LINE_1;
    OUT_REC.ADDRESS_LINE_2 := V_ADDRESSREC.ADDRESS_LINE_2;
    OUT_REC.ADDRESS_TYPE := V_ADDRESSREC.ADDRESS_TYPE;
    OUT_REC.ADDRESS_PREFERRED := V_ADDRESSREC.ADDRESS_PREFERRED;
    OUT_REC.ADDRESS_CITY := V_ADDRESSREC.ADDRESS_CITY;
    OUT_REC.ADDRESS_STATE := V_ADDRESSREC.ADDRESS_STATE;
    OUT_REC.ADDRESS_POSTAL_CODE := V_ADDRESSREC.ADDRESS_POSTAL_CODE;
    OUT_REC.ADDRESS_COUNTRY := V_ADDRESSREC.ADDRESS_COUNTRY;
  END IF;  
  END LOOP;
  PIPE ROW(OUT_REC);
  CLOSE C_ALLADDRESSES;
  END;
  RETURN;
  END;
.
run;

commit;


rem : 1>Author name 		: Tapan
rem : 2>Purpose of change	: Droping and recreating the Expert_address_mview, now making the Address_City the mandatory field.
rem : 3>Date of change 		: 16-Mar-2009

rem ------------------------------------------------------------------------------------------------


rem user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

SPOOL OFF
SET ECHO OFF
exit;
rem ------------------------------------------------------------------------------------------------

