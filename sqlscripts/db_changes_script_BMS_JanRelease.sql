rem ------------------------------------------------------------------------------------------------
rem Filename:   db_changes_script_BMS_JanRelease.sql
rem Purpose	:   To Create db_changes_script_BMS_JanRelease.sql for recording SQls for next Jan Release of BMS
rem             
rem Date	:	24-December-2008
rem Author	:   Dayanand, Kuliza Technologies
rem ------------------------------------------------------------------------------------------------

SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : db_changes_script_BMS_JanRelease.log
SPOOL db_changes_script_BMS_JanRelease.log
SET ECHO ON

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

rem : Latest Executed Batch Number :   

rem ------------------------------------------------------------------------------------------------

rem : Batch : 1

insert into "ATTRIBUTETABLE" ("ATTRIBUTE_ID","PARENT_ID","NAME","DESCRIPTION","ENTITY_TYPE_ID","LABEL","MANDATORY",
"SEARCHABLE","ATTRIBUTESIZE","WIDGET","ARRAYLIST","OPTIONID","SHOWABLE","COLUMNWIDTH","READUSERS","WRITEUSERS","DISPLAY_ORDER") 
values (85246266,83005800,'Survey','Survey',85246265,null,0,0,null,null,0,83396637,1,null,null,null,0);

insert into "ENTITYTYPES" ("ENTITY_TYPE_ID","NAME","DESCRIPTION","LABEL","TREEDEPTH") values (85246265,'Survey','Survey',null,2);
commit;

rem : 1>Author name 		: Dayanand
rem : 2>Purpose of change	: To add 'Survey' attribute in the attributetable so that we can have the tab in the OL Profile Details
rem : 3>Date of change 		: 26-September-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 2

create or replace FUNCTION GetAttendeesList(interactionId NUMBER) RETURN VARCHAR2 is attendeesList VARCHAR2(4000);
begin
attendeesList:='';
declare
cursor c1 is
select NAME from ATTENDEES WHERE INTERACTION_ID= interactionId order by name;
begin
for cr in c1
loop
attendeesList := attendeesList || cr.name||'; ';
end loop;
end;
RETURN substr(attendeesList,0,length(attendeesList)-2);
END;
.
run;

rem : 1>Author name 		: Deepak
rem : 2>Purpose of change	: Return colon separated attendee list
rem : 3>Date of change 		: 30-December-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 3

  CREATE OR REPLACE FORCE VIEW INTERACTION_SEARCH_VIEW ("ID", "INTERACTION_ID", "USER_ID", "USER_NAME", "PRODUCT_LIST", "ATTENDEE_TYPE", "ATTENDEE_LIST", "FIRST_TOPIC", "ATTENDEE_COUNT", "OTHER_ATTENDEE_COUNT") AS 
  select distinct
i.interaction_id as id,
i.interaction_id,
u.id as USER_ID,
u.lastname||', '|| u.firstname as USER_NAME,
lovidLookup.optvalue||
(case when productData.secondary_lovId is not null then ', ' end) || 
secondaryLovidLookup.optvalue ||
(case when productData.secondary_lovId is not null then ', ' end) ||
tertiaryLovidLookup.optvalue as PRODUCT_LIST,
att.attendeetype AS ATTENDEE_TYPE,
getattendeeslist(i.interaction_id) as ATTENDEE_LIST,
(select firstTopicLookup.optvalue 
  from interaction_data firstTopicData, option_lookup firstTopicLookup
  where firstTopicData.secondary_lovid = firsttopiclookup.id and 
        firstTopicData.interaction_id = i.interaction_id and rownum = 1) FIRST_TOPIC, 
(select count(attendeeCount.attendee_id) from attendees attendeeCount 
  where i.interaction_id = attendeecount.interaction_id) as ATTENDEE_COUNT,
(select nvl(sum(nvl(otherAttendeeCount.data, 0)),0)
  from interaction_data otherAttendeeCount 
  where i.interaction_id = otherAttendeeCount.interaction_id and
  otherAttendeeCount.type = 'AttendeeType') as OTHER_ATTENDEE_COUNT
from user_table u, interaction i, interaction_data productData, attendees att,
option_lookup lovidLookup, option_lookup secondaryLovidLookup, option_lookup tertiaryLovidLookup
where i.userid = u.id and
i.interaction_id = productData.interaction_id and
i.interaction_id = att.interaction_id and
productData.lovId = lovidLookup.id and
productData.secondary_lovId = secondaryLovidLookup.id(+) and
productData.tertiary_lovId = tertiaryLovidLookup.id(+) and
productData.type = 'productMultiselectIds' and
 u.deleteflag != 'Y' and
 i.deleteflag != 'Y'
 order by i.interaction_id;
 
 
rem : 1>Author name 		: Deepak
rem : 2>Purpose of change	: View for Interaction Search Results
rem : 3>Date of change 		: 30-December-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 4

update option_lookup set parent=83397444 where option_id = 83005842;

commit;

rem : 1>Author name 		: Tapan
rem : 2>Purpose of change	: This is to make all the Sphere Of Influence option values as children of CVMET Therapeutic Area.
rem : 3>Date of change 	: 05-Jan-2008

rem ------------------------------------------------------------------------------------------------

rem PERFORMANCE SQL scripts

rem : Batch : 5

alter table string_attribute add Root_Entity_Id number(19,0);

alter table string_attribute add Root_Entity_Type number(19,0);

alter table string_attribute add Tab_Attribute_Id number(19,0);

alter table string_attribute add isTable number(1,0);

alter table string_attribute add row_id number(19,0);

alter table boolean_attribute add Root_Entity_Id number(19,0);

alter table boolean_attribute add Root_Entity_Type number(19,0);

alter table boolean_attribute add Tab_Attribute_Id number(19,0);

alter table boolean_attribute add isTable number(1,0);

alter table boolean_attribute add row_id number(19,0);

alter table date_attribute add Root_Entity_Id number(19,0);

alter table date_attribute add Root_Entity_Type number(19,0);

alter table date_attribute add Tab_Attribute_Id number(19,0);

alter table date_attribute add isTable number(1,0);

alter table date_attribute add row_id number(19,0);

alter table number_attribute add Root_Entity_Id number(19,0);

alter table number_attribute add Root_Entity_Type number(19,0);

alter table number_attribute add Tab_Attribute_Id number(19,0);

alter table number_attribute add isTable number(1,0);

alter table number_attribute add row_id number(19,0);

create index SA_TAB_ATTRIBUTE_ID_INDEX on string_attribute(TAB_ATTRIBUTE_ID);

create index SA_ROOT_ENTITY_INDEX on string_attribute(root_entity_id);

create index SA_ROOT_ENTITY__TYPE_INDEX on string_attribute(root_entity_type);
 
rem : 1>Author name 		: Kiruba
rem : 2>Purpose of change	: Alter the basic attribute tables for EAV Flattening
rem : 3>Date of change 	: 12-Jan-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 6

CREATE SEQUENCE  "TABLE_ENTITY_ROW_SEQUENCE"  MINVALUE 1 MAXVALUE 1000000000000000000000000000 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;

rem : 1>Author name 		: Kiruba
rem : 2>Purpose of change	: Function to update the basic attribute tables
rem : 3>Date of change 	: 12-Jan-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 7

create or replace function Traverse_Tree_and_update_eav(kolid number, subtab_id number, entity_type number) return number is
temp number;
attr_id number;
temp2 number;
row_sequence_number number;
is_array_list number;
cursor c2 is select b.myentity_id,b.attribute_id,d.arraylist from entities_attribute b,attributetable d where b.parent_id=subtab_id and d.attribute_id=b.attribute_id;
Begin
   open c2;
   fetch c2 into temp,attr_id,is_array_list;
   if(c2%FOUND) then
      while(c2%found)
      loop
          temp2:=Traverse_Tree_and_update_eav(kolid,temp,entity_type);
          if(temp2=1) then
       if(is_array_list=1) then
             select table_entity_row_sequence.nextVal into row_sequence_number from dual;
                 update string_attribute sa set sa.root_entity_id=kolid, sa.root_entity_type=entity_type, sa.tab_attribute_id=attr_id , sa.istable=1, sa.row_id=row_sequence_number where sa.parent_id=temp;
                 update boolean_attribute sa set sa.root_entity_id=kolid, sa.root_entity_type=entity_type, sa.tab_attribute_id=attr_id, sa.istable=1 , sa.row_id=row_sequence_number where sa.parent_id=temp;
                 update date_attribute sa set sa.root_entity_id=kolid, sa.root_entity_type=entity_type, sa.tab_attribute_id=attr_id, sa.istable=1, sa.row_id=row_sequence_number where sa.parent_id=temp;
             else
                 update string_attribute sa set sa.root_entity_id=kolid, sa.root_entity_type=entity_type, sa.tab_attribute_id=attr_id, sa.istable=0, sa.row_id=0 where sa.parent_id=temp ;
                 update boolean_attribute sa set sa.root_entity_id=kolid, sa.root_entity_type=entity_type, sa.tab_attribute_id=attr_id, sa.istable=0, sa.row_id=0 where sa.parent_id=temp;
                 update date_attribute sa set sa.root_entity_id=kolid, sa.root_entity_type=entity_type, sa.tab_attribute_id=attr_id, sa.istable=0, sa.row_id=0 where sa.parent_id=temp;
             end if;
        end if;
          fetch c2 into temp,attr_id,is_array_list;
      end loop;
      return 0;
   else
      close c2;
      return 1;
   end if;
End;
.
run;

rem : 1>Author name 		: Kiruba
rem : 2>Purpose of change	: Function to update the basic attribute tables
rem : 3>Date of change 	: 12-Jan-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 8

CREATE OR REPLACE
procedure Update_Eav_Tables as 
  subtab_id number;
  temp number;
   cursor c1 is select entity_id from entities where type=101;
   cursor c3 is select entity_id from entities where type=12;
Begin
     open c1;
     fetch c1 into subtab_id;
     while(c1%found)
       loop
           temp:=traverse_tree_and_update_eav(subtab_id,subtab_id,101);
           commit;
           fetch c1 into subtab_id;
       end loop;
       close c1;
    
       open c3;
       fetch c3 into subtab_id;
       while(c3%found)
          loop
             temp:=traverse_tree_and_update_eav(subtab_id, subtab_id, 12);
             commit;
             fetch c3 into subtab_id;
          end loop;
       close c3;
End;
.
run;

rem : 1>Author name 		: Kiruba
rem : 2>Purpose of change	: Procedure to update the Basic attribute tables using the function above.
rem : 3>Date of change 	: 12-Jan-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 9

exec UPDATE_EAV_TABLES();

rem : 1>Author name 		: Kiruba
rem : 2>Purpose of change	: Run the Procedure to update the Basic attribute tables.
rem : 3>Date of change 	: 12-Jan-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 10


CREATE MATERIALIZED VIEW  ORG_VIEW_MATERIALIZED  
REFRESH FORCE START WITH SYSDATE
NEXT trunc(SYSDATE+1) + 3/24
AS 
SELECT
	T2.ROOT_ENTITY_ID AS ID,T2.VALUE AS NAME,K1.VALUE AS ACRONYM, P.VALUE AS ADDR_LINE1,Q.VALUE AS ADDR_LINE2,
H.VALUE AS STATE, I.VALUE AS COUNTRY,L.VALUE AS CITY,K2.VALUE AS TYPE,T1.VALUE AS ZIP
FROM STRING_ATTRIBUTE T2
LEFT OUTER JOIN STRING_ATTRIBUTE T1
ON (T1.ROOT_ENTITY_TYPE =12 AND T1.ROOT_ENTITY_ID=T2.ROOT_ENTITY_ID AND T1.ATTRIBUTE_ID=132)
LEFT OUTER JOIN STRING_ATTRIBUTE H
ON (H.ROOT_ENTITY_TYPE =12 AND H.ROOT_ENTITY_ID=T2.ROOT_ENTITY_ID AND H.ATTRIBUTE_ID=131)
LEFT OUTER JOIN STRING_ATTRIBUTE I
ON (I.ROOT_ENTITY_TYPE =12 AND I.ROOT_ENTITY_ID=T2.ROOT_ENTITY_ID AND I.ATTRIBUTE_ID=133)
LEFT OUTER JOIN STRING_ATTRIBUTE K1
ON (K1.ROOT_ENTITY_TYPE =12 AND K1.ROOT_ENTITY_ID=T2.ROOT_ENTITY_ID AND K1.ATTRIBUTE_ID=119)
LEFT OUTER JOIN STRING_ATTRIBUTE K2
ON (K2.ROOT_ENTITY_TYPE =12 AND K2.ROOT_ENTITY_ID=T2.ROOT_ENTITY_ID AND K2.ATTRIBUTE_ID=120)/*Address Type*/
LEFT OUTER JOIN STRING_ATTRIBUTE L
ON (L.ROOT_ENTITY_TYPE =12 AND L.ROOT_ENTITY_ID=T2.ROOT_ENTITY_ID AND L.ATTRIBUTE_ID=130)
LEFT OUTER JOIN STRING_ATTRIBUTE P
ON (P.ROOT_ENTITY_TYPE =12 AND P.ROOT_ENTITY_ID=T2.ROOT_ENTITY_ID AND P.ATTRIBUTE_ID=128)
LEFT OUTER JOIN STRING_ATTRIBUTE Q
ON (Q.ROOT_ENTITY_TYPE =12 AND Q.ROOT_ENTITY_ID=T2.ROOT_ENTITY_ID AND Q.ATTRIBUTE_ID=129)
WHERE T2.ROOT_ENTITY_TYPE=12 AND T2.ATTRIBUTE_ID=118;

rem : 1>Author name 		: Kiruba
rem : 2>Purpose of change	: New Materialized View for Organizations data
rem : 3>Date of change 	: 12-Jan-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 11

CREATE TYPE EXPERT_PRIMARY_ADDRESS AS OBJECT(
ID NUMBER(19,0),
KOLID NUMBER(19,0),
ADDRESS_LINE_1 VARCHAR2(4000),
ADDRESS_LINE_2 VARCHAR2(4000),
ADDRESS_TYPE VARCHAR2(4000),
ADDRESS_PREFERRED VARCHAR2(4000),
ADDRESS_CITY VARCHAR2(4000),
ADDRESS_STATE VARCHAR2(4000),
ADDRESS_POSTAL_CODE VARCHAR2(4000),
ADDRESS_COUNTRY VARCHAR2(4000));
.
run;
    
CREATE TYPE EXPERT_PRIMARY_ADDRESS_TABLE AS TABLE OF EXPERT_PRIMARY_ADDRESS;
.
run;

CREATE MATERIALIZED VIEW "EXPERT_ADDRESS_MVIEW"
REFRESH FORCE START WITH SYSDATE
NEXT trunc(SYSDATE+1) + 2/24
AS 
SELECT A.ID,A.KOLID AS KOLID,
S1.VALUE AS ADDRESS_LINE_1, S2.VALUE AS ADDRESS_LINE_2, S3.VALUE AS ADDRESS_TYPE,
S4.VALUE AS ADDRESS_PREFERRED, S5.VALUE AS ADDRESS_CITY, S6.VALUE AS ADDRESS_STATE,
S7.VALUE AS ADDRESS_POSTAL_CODE, S8.VALUE AS ADDRESS_COUNTRY
FROM
USER_TABLE A
LEFT OUTER JOIN STRING_ATTRIBUTE S1
ON (S1.ROOT_ENTITY_ID = A.KOLID AND S1.ATTRIBUTE_ID = 37)
LEFT OUTER JOIN STRING_ATTRIBUTE S2
ON (S2.ROW_ID = S1.ROW_ID AND S2.ATTRIBUTE_ID = 38)
LEFT OUTER JOIN STRING_ATTRIBUTE S3
ON (S3.ROW_ID = S1.ROW_ID AND S3.ATTRIBUTE_ID = 35)
LEFT OUTER JOIN STRING_ATTRIBUTE S4
ON (S4.ROW_ID = S1.ROW_ID AND S4.ATTRIBUTE_ID = 36)
LEFT OUTER JOIN STRING_ATTRIBUTE S5
ON (S5.ROW_ID = S1.ROW_ID AND S5.ATTRIBUTE_ID = 39)
LEFT OUTER JOIN STRING_ATTRIBUTE S6
ON (S6.ROW_ID = S1.ROW_ID AND S6.ATTRIBUTE_ID = 40)
LEFT OUTER JOIN STRING_ATTRIBUTE S7
ON (S7.ROW_ID = S1.ROW_ID AND S7.ATTRIBUTE_ID = 41)
LEFT OUTER JOIN STRING_ATTRIBUTE S8
ON (S8.ROW_ID = S1.ROW_ID AND S8.ATTRIBUTE_ID = 42)
WHERE A.USER_TYPE_ID = 4 AND A.DELETEFLAG = 'N';


CREATE MATERIALIZED VIEW "EXPERT_CONTACT_MVIEW"
REFRESH FORCE START WITH SYSDATE
NEXT trunc(SYSDATE+1) + 2/24
AS 
  SELECT A.ID,A.KOLID, 
S1.VALUE AS CONTACT_INFO, S2.VALUE AS CONTACT_TYPE, S3.VALUE AS PREFERRED_CONTACT
FROM 
USER_TABLE A 
LEFT OUTER JOIN STRING_ATTRIBUTE S1
ON (S1.ROOT_ENTITY_ID = A.KOLID AND S1.ATTRIBUTE_ID = 83009820)
LEFT OUTER JOIN STRING_ATTRIBUTE S2
ON (S2.ROW_ID = S1.ROW_ID AND S2.ATTRIBUTE_ID = 44)
LEFT OUTER JOIN STRING_ATTRIBUTE S3
ON (S3.ROW_ID = S1.ROW_ID AND S3.ATTRIBUTE_ID = 83009821)
WHERE A.USER_TYPE_ID = 4 AND A.DELETEFLAG='N';


create or replace FUNCTION GETPRIMARYADDRESSDETAILS(IDNEW NUMBER) 
RETURN EXPERT_PRIMARY_ADDRESS_TABLE PIPELINED IS 
OUT_REC EXPERT_PRIMARY_ADDRESS := EXPERT_PRIMARY_ADDRESS(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
BEGIN
DECLARE 
 CURSOR C_ALLADDRESSES IS
    SELECT *
      FROM EXPERT_ADDRESS_MVIEW ADDR WHERE ADDR.KOLID = IDNEW 
      AND ADDR.ADDRESS_LINE_1 IS NOT NULL ;
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

create or replace FUNCTION GETPRIMARYCONTACTDETAILS(IDNEW NUMBER, CONTACTTYPE VARCHAR2) RETURN VARCHAR2 AS CONTACT_INFO VARCHAR2(1000);
BEGIN
CONTACT_INFO:='';
DECLARE 
 CURSOR C_ALLPHONES IS
    SELECT * FROM EXPERT_CONTACT_MVIEW CON
    WHERE CON.KOLID = IDNEW 
    and CON.CONTACT_TYPE is not null and CON.CONTACT_TYPE = CONTACTTYPE
    ORDER  BY CON.PREFERRED_CONTACT DESC;
 V_PHONEREC C_ALLPHONES%ROWTYPE;
BEGIN
  OPEN C_ALLPHONES;
  LOOP
  FETCH C_ALLPHONES INTO V_PHONEREC;
  EXIT WHEN C_ALLPHONES%NOTFOUND OR C_ALLPHONES%ROWCOUNT>1;
  CONTACT_INFO:= V_PHONEREC.CONTACT_INFO;
   END LOOP;
  CLOSE C_ALLPHONES;
  END;
  RETURN CONTACT_INFO;
  END;
.
run;

 CREATE OR REPLACE FORCE VIEW "EXPERT_DETAILS_VIEW"  AS 
SELECT A.ID AS ID, A.KOLID AS KOLID, A.FIRSTNAME AS FIRSTNAME, 
A.MIDDLENAME AS MIDDLENAME, A.LASTNAME AS LASTNAME , A.DELETEFLAG AS DELETEFLAG,
S1.VALUE AS PRIMARY_SPECIALITY,S2.VALUE AS SECONDARY_SPECIALITY,
S3.VALUE AS TERTIARY_SPECIALITY, S4.VALUE AS TITLE, S5.VALUE AS MSL_OL_TYPE,
S6.VALUE AS SPHERE_OF_INFLUENCE,
(SELECT GETPRIMARYCONTACTDETAILS(A.KOLID,'Business') FROM DUAL) AS PRIMARY_PHONE,
(SELECT GETPRIMARYCONTACTDETAILS(A.KOLID,'Email') FROM DUAL) AS PRIMARY_EMAIL,
(SELECT GETPRIMARYCONTACTDETAILS(A.KOLID,'Fax') FROM DUAL) AS PRIMARY_FAX,
(SELECT ADDRESS_LINE_1
FROM TABLE(CAST(GETPRIMARYADDRESSDETAILS(A.KOLID) AS EXPERT_PRIMARY_ADDRESS_TABLE))) AS ADDR_LINE_1,
(SELECT ADDRESS_LINE_2
FROM TABLE(CAST(GETPRIMARYADDRESSDETAILS(A.KOLID) AS EXPERT_PRIMARY_ADDRESS_TABLE))) AS ADDR_LINE_2,
(SELECT ADDRESS_CITY
FROM TABLE(CAST(GETPRIMARYADDRESSDETAILS(A.KOLID) AS EXPERT_PRIMARY_ADDRESS_TABLE))) AS ADDR_CITY,
(SELECT ADDRESS_STATE
FROM TABLE(CAST(GETPRIMARYADDRESSDETAILS(A.KOLID) AS EXPERT_PRIMARY_ADDRESS_TABLE))) AS ADDR_STATE,
(SELECT ADDRESS_POSTAL_CODE
FROM TABLE(CAST(GETPRIMARYADDRESSDETAILS(A.KOLID) AS EXPERT_PRIMARY_ADDRESS_TABLE))) AS ADDR_POSTAL_CODE,
(SELECT ADDRESS_COUNTRY
FROM TABLE(CAST(GETPRIMARYADDRESSDETAILS(A.KOLID) AS EXPERT_PRIMARY_ADDRESS_TABLE))) AS ADDR_COUNTRY
FROM USER_TABLE A
LEFT OUTER JOIN STRING_ATTRIBUTE S1 
ON (S1.ROOT_ENTITY_TYPE = 101 AND S1.ROOT_ENTITY_ID = A.KOLID AND S1.ATTRIBUTE_ID = 24)
LEFT OUTER JOIN STRING_ATTRIBUTE S2
ON (S1.ROOT_ENTITY_TYPE = 101 AND S2.ROOT_ENTITY_ID = A.KOLID AND S2.ATTRIBUTE_ID = 25)
LEFT OUTER JOIN STRING_ATTRIBUTE S3
ON (S3.ROOT_ENTITY_TYPE = 101 AND S3.ROOT_ENTITY_ID = A.KOLID AND S3.ATTRIBUTE_ID = 26)
LEFT OUTER JOIN STRING_ATTRIBUTE S4
ON (S4.ROOT_ENTITY_TYPE = 101 AND S4.ROOT_ENTITY_ID = A.KOLID AND S4.ATTRIBUTE_ID = 83009814)
LEFT OUTER JOIN STRING_ATTRIBUTE S5
ON (S5.ROOT_ENTITY_TYPE = 101 AND S5.ROOT_ENTITY_ID = A.KOLID AND S5.ATTRIBUTE_ID = 83396591)
LEFT OUTER JOIN STRING_ATTRIBUTE S6
ON (S6.ROOT_ENTITY_TYPE = 101 AND S6.ROOT_ENTITY_ID = A.KOLID AND S6.ATTRIBUTE_ID = 83396615)
WHERE A.DELETEFLAG='N' AND A.USER_TYPE_ID=4 
ORDER BY A.KOLID;


create table temp_expert_details as 
select * from expert_details_view;

alter table temp_expert_details add primary key (id);

CREATE MATERIALIZED VIEW LOG ON temp_expert_details WITH (kolid);

create materialized view expert_details_mview
refresh force start with sysdate
next trunc(sysdate +1)+3/24
for update
as
select * from temp_expert_details;

create index kolid_address_mview_index on expert_address_mview(kolid);

create index kolid_contact_mview_index on expert_contact_mview(kolid);

create index kolid_details_mview_index on expert_details_mview(kolid);

rem : The following queries are required to refresh the materialized view
rem   Please schedule them as a Oracle job or a cron job
rem   Please remove rem from the queries before scheduling them
 
rem truncate table temp_expert_details;
rem insert into temp_expert_details select * from expert_details_view;
rem EXECUTE DBMS_MVIEW.REFRESH('expert_details_mview','F');


rem : 1>Author name 		: Tapan
rem : 2>Purpose of change	: 1. Functions/Procedures for getting the Primary Address and Primary Contacts as per the specified business rules.
				  			  2. Materialized Views for Expert Profile Details, Address and Contact Information.
rem : 3>Date of change 	: 13-Jan-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 12

UPDATE STRING_ATTRIBUTE SET VALUE='Business' WHERE VALUE = 'Business Phone' 
AND ATTRIBUTE_ID = 44;

UPDATE STRING_ATTRIBUTE SET VALUE ='Business' WHERE VALUE = 'Phone' 
AND ATTRIBUTE_ID = 44;

UPDATE OPTION_LOOKUP SET OPTVALUE = 'Business' WHERE OPTVALUE = 'Phone' AND OPTION_ID = 27;

commit;

rem : 1>Author name 		: Tapan
rem : 2>Purpose of change	: Query to update the existing Contact Type values and also the Contact Mechanism Type LOV value.
rem : 3>Date of change 	: 13-Jan-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 13

insert into "OPTION_NAMES" ("ID","NAME","PARENT") values (85248367,'HeadQuarters',-1);

update option_names set parent=85248367 where name like 'Therapeutic Area';

insert into "OPTION_LOOKUP" ("ID","OPTION_ID","OPTVALUE","DELETEFLAG","PARENT","DEFAULT_SELECTED","DISPLAY_ORDER") values (85248368,85248367,'HQ','N',-1,'0',0);

update option_lookup set parent= 85248368 where optvalue = 'CVMET';

commit;

rem : 1>Author name 		: Dayanand	
rem : 2>Purpose of change	: Query to create HQL territory Values and set the relationship
rem : 3>Date of change 	: 13-Jan-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 14

delete from option_lookup where id in(83007200,83612321);

commit;

rem : 1>Author name 		: Dayanand	
rem : 2>Purpose of change	: Query to Delete unwanted HQs
rem : 3>Date of change 	: 14-Jan-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 15

ALTER TABLE ORG_OL_MAP 
MODIFY ("POSITION" VARCHAR2(200))
;
ALTER TABLE ORG_OL_MAP 
MODIFY ("DIVISION" VARCHAR2(200))
;

rem : 1>Author name 		: Vaibhav	
rem : 2>Purpose of change	: Query to alter division and position size
rem : 3>Date of change 	: 19-Jan-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 16

create or replace FUNCTION GETPUBMEDIDS(newID NUMBER) RETURN VARCHAR2 is V VARCHAR2(4000);
begin
v:='';
declare
cursor c1 is
select st3.value name from 
string_attribute st3,
user_table u 
where 
  st3.attribute_id = 104 
and u.kolid = st3.root_entity_id
and rownum < 4
and u.kolid = newId
order by st3.value desc; 
begin
for cr in c1
loop
v :=','||cr.name||v;
end loop;
end;
RETURN V||',';
END;
.
run;

rem : 1>Author name 		: Dayanand	
rem : 2>Purpose of change	: Function to get recent 3 publication ids
rem : 3>Date of change 	: 19-Jan-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 17

CREATE OR REPLACE FORCE VIEW "SURVEY_SAXA_VIEW" ("EXPERTID", "QUESTIONNUMBER", "ANSWER", "SURVEYID", "CREATEDATE") AS 
  (select fs.expertid as expertid,sqm.QUESTIONNUMBER as questionnumber,
case when sqm.type='multioptsinglesel' then sans.answertext
     when sqm.type='multioptmultisel' then MULTIOPTMULTISELCONCAT(fsans.PARENT_QUESTION)   
end answer,
fs.id,
fs.createdate
from filled_survey fs, SURVEYMETADATA sm , FILLED_QUESTIONS fq, SURVEYQUESTIONSMETADATA sqm, SURVEYANSWERSDATA sans, FILLED_SUBQUES_ANSWERS fsans
where
fs.surveyid = sm.id
and fq.parent_survey = fs.id
and fq.questionid = sqm.id
and fsans.PARENT_QUESTION = fq.id
and fsans.answer_option = sans.id
and sans.QUESTIONID = sqm.id
and sm.name like '%Saxa Profiling%')   
UNION ALL
(select fs.expertid as expertId,sqm.QUESTIONNUMBER as questionNumber,fq.answer_text as answer,
fs.id,
fs.createdate
from filled_survey fs, SURVEYMETADATA sm , FILLED_QUESTIONS fq, SURVEYQUESTIONSMETADATA sqm
where
fs.surveyid = sm.id
and fq.parent_survey = fs.id
and fq.questionid = sqm.id
and sm.name like '%Saxa Profiling%'
and sqm.type in ('simpleText', 'numText'));

rem : 1>Author name 		: Dayanand	
rem : 2>Purpose of change	: Saxa Survey View Modified to add extra columns 
rem : 3>Date of change 	: 20-Jan-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 18

update attributetable set name = 'Surveys' where attribute_id = 85246266;

commit;

rem : 1>Author name 		: Dayanand	
rem : 2>Purpose of change	: Renaming Survey Column to Surveys 
rem : 3>Date of change 	: 20-Jan-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 19

 CREATE OR REPLACE FORCE VIEW  "EXPERT_DETAILS_VIEW" ("ID", "KOLID", "FIRSTNAME", "MIDDLENAME", "LASTNAME", "DELETEFLAG", "PRIMARY_SPECIALITY", 
"SECONDARY_SPECIALITY", "TERTIARY_SPECIALITY", "TITLE", "MSL_OL_TYPE", "SPHERE_OF_INFLUENCE", "PRIMARY_PHONE", "PRIMARY_EMAIL", 
"PRIMARY_FAX", "PRIMARY_MOBILE", "ADDR_LINE_1", "ADDR_LINE_2", "ADDR_CITY", "ADDR_STATE", "ADDR_POSTAL_CODE", "ADDR_COUNTRY") AS 
  SELECT A.ID AS ID, A.KOLID AS KOLID, A.FIRSTNAME AS FIRSTNAME, 
A.MIDDLENAME AS MIDDLENAME, A.LASTNAME AS LASTNAME , A.DELETEFLAG AS DELETEFLAG,
S1.VALUE AS PRIMARY_SPECIALITY,S2.VALUE AS SECONDARY_SPECIALITY,
S3.VALUE AS TERTIARY_SPECIALITY, S4.VALUE AS TITLE, S5.VALUE AS MSL_OL_TYPE,
S6.VALUE AS SPHERE_OF_INFLUENCE,
(SELECT GETPRIMARYCONTACTDETAILS(A.KOLID,'Business') FROM DUAL) AS PRIMARY_PHONE,
(SELECT GETPRIMARYCONTACTDETAILS(A.KOLID,'Email') FROM DUAL) AS PRIMARY_EMAIL,
(SELECT GETPRIMARYCONTACTDETAILS(A.KOLID,'Fax') FROM DUAL) AS PRIMARY_FAX,
(SELECT GETPRIMARYCONTACTDETAILS(A.KOLID,'Mobile') FROM DUAL) AS PRIMARY_MOBILE,
(SELECT ADDRESS_LINE_1
FROM TABLE(CAST(GETPRIMARYADDRESSDETAILS(A.KOLID) AS EXPERT_PRIMARY_ADDRESS_TABLE))) AS ADDR_LINE_1,
(SELECT ADDRESS_LINE_2
FROM TABLE(CAST(GETPRIMARYADDRESSDETAILS(A.KOLID) AS EXPERT_PRIMARY_ADDRESS_TABLE))) AS ADDR_LINE_2,
(SELECT ADDRESS_CITY
FROM TABLE(CAST(GETPRIMARYADDRESSDETAILS(A.KOLID) AS EXPERT_PRIMARY_ADDRESS_TABLE))) AS ADDR_CITY,
(SELECT ADDRESS_STATE
FROM TABLE(CAST(GETPRIMARYADDRESSDETAILS(A.KOLID) AS EXPERT_PRIMARY_ADDRESS_TABLE))) AS ADDR_STATE,
(SELECT ADDRESS_POSTAL_CODE
FROM TABLE(CAST(GETPRIMARYADDRESSDETAILS(A.KOLID) AS EXPERT_PRIMARY_ADDRESS_TABLE))) AS ADDR_POSTAL_CODE,
(SELECT ADDRESS_COUNTRY
FROM TABLE(CAST(GETPRIMARYADDRESSDETAILS(A.KOLID) AS EXPERT_PRIMARY_ADDRESS_TABLE))) AS ADDR_COUNTRY
FROM USER_TABLE A
LEFT OUTER JOIN STRING_ATTRIBUTE S1 
ON (S1.ROOT_ENTITY_TYPE = 101 AND S1.ROOT_ENTITY_ID = A.KOLID AND S1.ATTRIBUTE_ID = 24)
LEFT OUTER JOIN STRING_ATTRIBUTE S2
ON (S1.ROOT_ENTITY_TYPE = 101 AND S2.ROOT_ENTITY_ID = A.KOLID AND S2.ATTRIBUTE_ID = 25)
LEFT OUTER JOIN STRING_ATTRIBUTE S3
ON (S3.ROOT_ENTITY_TYPE = 101 AND S3.ROOT_ENTITY_ID = A.KOLID AND S3.ATTRIBUTE_ID = 26)
LEFT OUTER JOIN STRING_ATTRIBUTE S4
ON (S4.ROOT_ENTITY_TYPE = 101 AND S4.ROOT_ENTITY_ID = A.KOLID AND S4.ATTRIBUTE_ID = 83009814)
LEFT OUTER JOIN STRING_ATTRIBUTE S5
ON (S5.ROOT_ENTITY_TYPE = 101 AND S5.ROOT_ENTITY_ID = A.KOLID AND S5.ATTRIBUTE_ID = 83396591)
LEFT OUTER JOIN STRING_ATTRIBUTE S6
ON (S6.ROOT_ENTITY_TYPE = 101 AND S6.ROOT_ENTITY_ID = A.KOLID AND S6.ATTRIBUTE_ID = 83396615)
WHERE A.DELETEFLAG='N' AND A.USER_TYPE_ID=4 
ORDER BY A.KOLID;


rem : 1>Author name 		: Dayanand	
rem : 2>Purpose of change	: Added column to the expert_details_view
rem : 3>Date of change 	: 20-Jan-2008

rem ------------------------------------------------------------------------------------------------

rem : Batch : 20

update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84888029;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84896326;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84901391;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84896820;
update contacts set begindate='11-DEC-08', enddate='31-DEC-13' where kolid=84890222;
update contacts set begindate='03-DEC-08', enddate='31-DEC-13' where kolid=84898077;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84900211;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84904864;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84898315;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84902888;
update contacts set begindate='01-JAN-08', enddate='31-DEC-12' where kolid=84898553;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84727342;
update contacts set begindate='14-NOV-08', enddate='31-DEC-13' where kolid=84898817;
update contacts set begindate='22-OCT-08', enddate='31-DEC-13' where kolid=84898932;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84893924;
update contacts set begindate='11-DEC-08', enddate='11-DEC-09' where kolid=84904259;
update contacts set begindate='12-DEC-08', enddate='12-DEC-09' where kolid=84888489;
update contacts set begindate='12-DEC-08', enddate='12-DEC-09' where kolid=84893131;
update contacts set begindate='12-DEC-08', enddate='12-DEC-09' where kolid=84902081;
update contacts set begindate='12-DEC-08', enddate='12-DEC-09' where kolid=84897976;
update contacts set begindate='12-DEC-08', enddate='12-DEC-09' where kolid=84888818;
update contacts set begindate='12-DEC-08', enddate='12-DEC-09' where kolid=84899989;
update contacts set begindate='01-JAN-08', enddate='31-DEC-12' where kolid=84889040;
update contacts set begindate='01-JAN-08', enddate='31-DEC-12' where kolid=84896943;
update contacts set begindate='01-JAN-08', enddate='31-DEC-12' where kolid=84894650;
update contacts set begindate='01-JAN-08', enddate='31-DEC-12' where kolid=84892439;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84894162;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84903779;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84894039;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84903507;
update contacts set begindate='01-JAN-08', enddate='31-DEC-12' where kolid=84899311;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84901498;
update contacts set begindate='01-JAN-08', enddate='31-DEC-12' where kolid=84891364;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84891481;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84898430;
update contacts set begindate='20-NOV-08', enddate='31-DEC-13' where kolid=84904971;
update contacts set begindate='25-NOV-08', enddate='25-NOV-09' where kolid=84890345;
update contacts set begindate='10-DEC-08', enddate='10-DEC-09' where kolid=84894866;
update contacts set begindate='10-DEC-08', enddate='10-DEC-09' where kolid=84901736;
update contacts set begindate='12-DEC-08', enddate='12-DEC-09' where kolid=84890567;
update contacts set begindate='12-NOV-08', enddate='31-DEC-13' where kolid=84894543;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84903648;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84896574;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84896185;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84897308;
update contacts set begindate='07-OCT-08', enddate='31-DEC-13' where kolid=84902650;
update contacts set begindate='10-DEC-08', enddate='10-DEC-09' where kolid=84904126;
update contacts set begindate='10-DEC-08', enddate='31-DEC-13' where kolid=84892909;
update contacts set begindate='11-DEC-08', enddate='11-DEC-09' where kolid=84901851;
update contacts set begindate='12-DEC-08', enddate='12-DEC-09' where kolid=84897623;
update contacts set begindate='12-DEC-08', enddate='12-DEC-09' where kolid=84897730;
update contacts set begindate='12-DEC-08', enddate='12-DEC-09' where kolid=84893232;
update contacts set begindate='12-DEC-08', enddate='12-DEC-09' where kolid=84891019;
update contacts set begindate='20-OCT-08', enddate='31-DEC-13' where kolid=83875862;
update contacts set begindate='20-OCT-08', enddate='31-DEC-13' where kolid=84897066;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84888152;
update contacts set begindate='01-JAN-08', enddate='31-DEC-12' where kolid=84894269;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84900558;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84891705;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84893801;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84891846;
update contacts set begindate='01-JAN-08', enddate='31-DEC-12' where kolid=84889639;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84895594;
update contacts set begindate='10-DEC-08', enddate='10-DEC-09' where kolid=84892802;
update contacts set begindate='10-DEC-08', enddate='31-DEC-13' where kolid=84897415;
update contacts set begindate='11-DEC-08', enddate='11-DEC-09' where kolid=84901966;
update contacts set begindate='12-DEC-08', enddate='12-DEC-09' where kolid=84888596;
update contacts set begindate='12-DEC-08', enddate='12-DEC-09' where kolid=84890682;
update contacts set begindate='12-DEC-08', enddate='12-DEC-09' where kolid=84902204;
update contacts set begindate='12-DEC-08', enddate='12-DEC-09' where kolid=84902327;
update contacts set begindate='12-DEC-08', enddate='12-DEC-09' where kolid=84891249;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84904011;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84888267;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84897167;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84896441;
update contacts set begindate='05-NOV-08', enddate='31-DEC-13' where kolid=84900929;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84895832;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84892102;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84896078;
update contacts set begindate='21-NOV-08', enddate='31-DEC-13' where kolid=84892554;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84890107;
update contacts set begindate='22-OCT-08', enddate='31-DEC-13' where kolid=84894418;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84893448;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84904598;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84893563;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84891604;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84903011;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84903118;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84905332;
update contacts set begindate='10-DEC-08', enddate='10-DEC-09' where kolid=84894981;
update contacts set begindate='12-DEC-08', enddate='12-DEC-09' where kolid=84897522;
update contacts set begindate='12-DEC-08', enddate='12-DEC-09' where kolid=84888925;
update contacts set begindate='20-OCT-08', enddate='31-DEC-13' where kolid=84899065;
update contacts set begindate='07-NOV-08', enddate='31-DEC-13' where kolid=84903886;
update contacts set begindate='20-OCT-08', enddate='31-DEC-13' where kolid=84889992;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84904721;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84900673;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84895717;
update contacts set begindate='26-NOV-08', enddate='26-NOV-09' where kolid=84899545;
update contacts set begindate='04-DEC-08', enddate='04-DEC-09' where kolid=84892687;
update contacts set begindate='10-DEC-08', enddate='10-DEC-09' where kolid=84899660;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84895338;
update contacts set begindate='12-DEC-08', enddate='12-DEC-09' where kolid=84890912;
update contacts set begindate='12-DEC-08', enddate='12-DEC-09' where kolid=84897853;
update contacts set begindate='01-JAN-08', enddate='31-DEC-12' where kolid=84895977;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84903259;
update contacts set begindate='20-OCT-08', enddate='31-DEC-13' where kolid=84903374;
update contacts set begindate='28-OCT-08', enddate='31-DEC-13' where kolid=84892209;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84901629;
update contacts set begindate='01-JAN-08', enddate='31-DEC-12' where kolid=84902434;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84902535;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84900334;
update contacts set begindate='21-OCT-08', enddate='31-DEC-13' where kolid=84902773;
update contacts set begindate='13-DEC-05', enddate='13-DEC-06' where kolid=84893678;
update contacts set begindate='17-NOV-08', enddate='31-DEC-13' where kolid=84895479;
update contacts set begindate='03-DEC-08', enddate='31-DEC-13' where kolid=84900788;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84898676;
update contacts set begindate='23-OCT-08', enddate='31-DEC-13' where kolid=84891969;
update contacts set begindate='08-DEC-08', enddate='08-DEC-09' where kolid=84888382;
update contacts set begindate='11-DEC-08', enddate='11-DEC-09' where kolid=84895237;
update contacts set begindate='12-DEC-08', enddate='12-DEC-09' where kolid=84899882;
update contacts set begindate='12-DEC-08', enddate='12-DEC-09' where kolid=84890789;
update contacts set begindate='12-DEC-08', enddate='12-DEC-09' where kolid=84904497;
update contacts set begindate='12-DEC-08', enddate='12-DEC-09' where kolid=84888703;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84892332;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84901159;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84901044;
update contacts set begindate='11-DEC-08', enddate='31-DEC-13' where kolid=84899188;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84901276;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84889754;
update contacts set begindate='01-JAN-08', enddate='31-DEC-12' where kolid=84896713;
update contacts set begindate='01-JAN-08', enddate='31-DEC-12' where kolid=84889877;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84900096;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84898208;
update contacts set begindate='23-OCT-08', enddate='31-DEC-13' where kolid=84889278;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84900435;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84889393;
update contacts set begindate='01-JAN-08', enddate='31-DEC-13' where kolid=84905078;
update contacts set begindate='08-OCT-08', enddate='31-DEC-13' where kolid=84905209;
update contacts set begindate='01-DEC-08', enddate='01-DEC-09' where kolid=84894751;
update contacts set begindate='10-DEC-08', enddate='10-DEC-09' where kolid=84890460;
update contacts set begindate='11-DEC-08', enddate='11-DEC-09' where kolid=84899767;
update contacts set begindate='11-DEC-08', enddate='11-DEC-09' where kolid=84895122;
update contacts set begindate='12-DEC-08', enddate='12-DEC-09' where kolid=84893024;
update contacts set begindate='12-DEC-08', enddate='12-DEC-09' where kolid=84904374;
update contacts set begindate='12-DEC-08', enddate='31-DEC-13' where kolid=84891134;

commit;

rem : 1>Author name 		: Deepak	
rem : 2>Purpose of change	: Add effective date for the missing contacts
rem : 3>Date of change 		: 21-Jan-2008
rem ------------------------------------------------------------------------------------------------

rem : Batch : 21

create or replace TRIGGER USER_TABLE_UPDATE
BEFORE UPDATE OF VALUE ON STRING_ATTRIBUTE
FOR EACH ROW

DECLARE
NEW_VALUE STRING_ATTRIBUTE.VALUE%TYPE;
ATTRIBUTE_ID STRING_ATTRIBUTE.ATTRIBUTE_ID%TYPE;
SUMMARY_ID STRING_ATTRIBUTE.PARENT_ID%TYPE;
PROFILE_ID ENTITIES_ATTRIBUTE.PARENT_ID%TYPE;
KOL_ID ENTITIES_ATTRIBUTE.PARENT_ID%TYPE;

BEGIN
ATTRIBUTE_ID := :NEW.ATTRIBUTE_ID;

IF ATTRIBUTE_ID=18 OR ATTRIBUTE_ID=19 OR ATTRIBUTE_ID=20 THEN
   NEW_VALUE := :NEW.VALUE;
   SUMMARY_ID := :NEW.PARENT_ID;
   SELECT PARENT_ID INTO PROFILE_ID FROM ENTITIES_ATTRIBUTE WHERE MYENTITY_ID=SUMMARY_ID;
   SELECT PARENT_ID INTO KOL_ID FROM ENTITIES_ATTRIBUTE WHERE MYENTITY_ID=PROFILE_ID;
   IF ATTRIBUTE_ID=18 THEN
      UPDATE USER_TABLE SET FIRSTNAME=NEW_VALUE WHERE KOLID=KOL_ID;
   END IF;
   
   IF ATTRIBUTE_ID=19 THEN
      UPDATE USER_TABLE SET MIDDLENAME=NEW_VALUE WHERE KOLID=KOL_ID;
   END IF;
   
   IF ATTRIBUTE_ID=20 THEN
      UPDATE USER_TABLE SET LASTNAME=NEW_VALUE WHERE KOLID=KOL_ID;
   END IF;
  
END IF;
END;
.
run

rem : 1>Author name 		: Deepak	
rem : 2>Purpose of change	: Update KOL name in user table when name changes in EAV
rem : 3>Date of change 		: 27-Jan-2008
rem ------------------------------------------------------------------------------------------------

commit;

rem ------------------------------------------------------------------------------------------------

rem : Batch : 22

ALTER TABLE SURVEYANSWERSDATA 
ADD ("OPTION_ORDER" NUMBER DEFAULT 0 NOT NULL);

UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 1 WHERE ID=84713560;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 2 WHERE ID=84713561;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 1 WHERE ID=84713564;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 2 WHERE ID=84713565;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 1 WHERE ID=84713567;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 2 WHERE ID=84713568;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 1 WHERE ID=84713570;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 2 WHERE ID=84713571;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 1 WHERE ID=84713573;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 2 WHERE ID=84713574;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 1 WHERE ID=84713576;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 2 WHERE ID=84713577;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 2 WHERE ID=84713579;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 1 WHERE ID=84713580;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 3 WHERE ID=84713581;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 2 WHERE ID=84713583;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 3 WHERE ID=84713584;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 1 WHERE ID=84713585;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 1 WHERE ID=84713588;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 2 WHERE ID=84713589;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 1 WHERE ID=84713591;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 2 WHERE ID=84713592;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 2 WHERE ID=84713594;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 1 WHERE ID=84713595;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 3 WHERE ID=84713596;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 1 WHERE ID=84713598;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 2 WHERE ID=84713599;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 1 WHERE ID=84713602;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 2 WHERE ID=84713603;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 1 WHERE ID=84713605;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 2 WHERE ID=84713606;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 1 WHERE ID=84713608;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 2 WHERE ID=84713609;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 1 WHERE ID=84713611;
UPDATE SURVEYANSWERSDATA SET OPTION_ORDER = 2 WHERE ID=84713612;

commit;

rem : 1>Author name 		: Kiruba	
rem : 2>Purpose of change	: Add a new column option_order for survey answerOptions,Update Saxa profiling survey add option order.
rem : 3>Date of change 		: 27-Jan-2008
rem ------------------------------------------------------------------------------------------------

rem : Batch : 23

delete from contacts where contactid in
(select min(contactid) from contacts group by kolid,staffid having count(*)>1);

commit;

rem : 1>Author name 		: Dayanand	
rem : 2>Purpose of change	: Removing Duplicate Contacts for a MSL.
rem : 3>Date of change 		: 28-Jan-2008
rem ------------------------------------------------------------------------------------------------


rem : Batch : 24

update user_table set staffid = trim(staffid);

commit;

rem : 1>Author name 		: Deepak	
rem : 2>Purpose of change	: Removing trailing spaces from staffid
rem : 3>Date of change 		: 29-Jan-2008
rem ------------------------------------------------------------------------------------------------
rem : Batch : 25

alter trigger "STRING_AUDIT" enable;

alter trigger "NUMBER_AUDIT" enable;

alter trigger "DATE_AUDIT" enable;

alter trigger "BOOLEAN_AUDIT" enable;

rem : 1>Author name 		: Dayanand	
rem : 2>Purpose of change	: Enabling the Triggers.
rem : 3>Date of change 	: 30-Jan-2008
rem ------------------------------------------------------------------------------------------------

rem user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

SPOOL OFF
SET ECHO OFF
exit;
rem ------------------------------------------------------------------------------------------------


