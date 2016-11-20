rem ------------------------------------------------------------------------------------------------
rem Filename    :   db_changes_script_BMSv3.0.sql
rem Purpose	:   SQL changes for version 3.0
rem             
rem Date	:   03-Dec-2009
rem Author	:   Yatin
rem ------------------------------------------------------------------------------------------------

SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : db_changes_script_BMSv3.0.log

SPOOL db_changes_script_BMSv3.0.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------

rem : Batch : 1

insert into attributetable 
select
hibernate_sequence.nextval,
e.entity_type_id,
optvalue||' Affiliation', optvalue||' Affiliation',5,null,0,1,null,null,0,83396610,1,null,null,null,0
from option_lookup o, entitytypes e 
where e.name = o.optvalue||' Attributes'
and o.option_id = 44;

alter trigger STRING_AUDIT disable;

insert into string_attribute 
select
hibernate_sequence.nextval,
affatt.attribute_id,
soi.parent_id, 
'Yes', soi.root_entity_id, soi.root_entity_type, soi.tab_attribute_id, soi.istable, soi.row_id 
from string_attribute soi, attributetable soiatt, option_lookup ta, attributetable affatt
where soi.attribute_id = soiatt.attribute_id
and soiatt.name = ta.optvalue||' Sphere of Influence'
and ta.option_id = 44
and soi.value in ('N/A', 'Local', 'Regional', 'National')
and affatt.name = ta.optvalue||' Affiliation';

alter trigger STRING_AUDIT enable;

insert into attributetable values (hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name = 'TL Selection Criteria'), 'Sphere of Influence', 'Sphere of Influence', 5, null, 0, 1, null, null, 0, 
(select id from option_names where name='Sphere of Influence'), 1, null, null,null,0);

commit;

rem : 1>Author name         : Deepak
rem : 2>Purpose of change   : "New TA Affiliation attributes added"
rem : 3>Date of change      : 15-Dec-2009
rem ------------------------------------------------------------------------------------------------

rem : Batch : 2


alter trigger STRING_AUDIT disable;

update attributetable set showable=0 where parent_id=83396588 and name not in ('MSL TL Type', 'Sphere of Influence');

update string_attribute set value='N/A' where attribute_id=83396591;

update attributetable set showable=0 where name like '% Sphere of Influence';

update string_attribute set value='N/A' where attribute_id in (select attribute_id from attributetable where name like '% Sphere of Influence%');

alter trigger STRING_AUDIT enable;

commit;


rem : 1>Author name         : Vinay Rao
rem : 2>Purpose of change   : "Purge data for all Sphere of Influence, change MPTL status to N/A, change all selection criteria"
rem : 3>Date of change      : 03-Dec-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 3

insert into option_names values (hibernate_sequence.nextVal, 'Medical Objective', (select id from option_names where name like 'Product'));

insert into option_names values (hibernate_sequence.nextVal, 'Dialog Objective', (select id from option_names where name like 'Product'));

commit;

rem : 1>Author name         : Tapan Ghia
rem : 2>Purpose of change   : "Adding new LOVs Medical and Dialog Objective for the Medical Plan Activity Section on Interaction's Page"
rem : 3>Date of change      : 07-Dec-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 4

insert into attributetable select
hibernate_sequence.nextval,
e.entity_type_id,
optvalue||' Market Access', optvalue||' Market Access Flag',5,null,0,0,null,null,0,83396610,1,null,null,null,0
from option_lookup o, entitytypes e 
where e.name = o.optvalue||' Attributes'
and o.option_id = 44;

commit;

rem : 1>Author name         : Yatin
rem : 2>Purpose of change   : "EAV work - create a market access flag on all TA Attributes pages"
rem : 3>Date of change      : 14-Dec-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 5

UPDATE user_table SET firstname = TRIM(firstname);

commit;

rem : 1>Author name         : Yatin
rem : 2>Purpose of change   : Query to trim Firstname field of user_table
rem : 3>Date of change      : 03-Dec-2009
rem ------------------------------------------------------------------------------------------------

rem : Batch : 6

Insert into attributetable values (hibernate_sequence.nextval, (select entity_type_id from attributetable where name = 'TL Selection Criteria') ,'Member nat''l/internat''l treatment guideline committee w/i 2 yrs', 'Member of national or international treatment guideline committee within the last 2 years',5,null,1,0,null,null,0,83009346,1,null,null,null,0);
Insert into attributetable values (hibernate_sequence.nextval, (select entity_type_id from attributetable where name = 'TL Selection Criteria') ,'Member of scientific committee for nat''l or internat''l assoc w/i 2 years', 'Committee/board member of scientific committee for national or international associations within the last 2 years',5,null,1,0,null,null,0,83009346,1,null,null,null,1);
Insert into attributetable values (hibernate_sequence.nextval, (select entity_type_id from attributetable where name = 'TL Selection Criteria') ,'Chairman/speaker nat''l or internat''l scientific meeting', 'Chairman/speaker at an national or international scientific meeting',5,null,1,0,null,null,0,83009346,1,null,null,null,2);
Insert into attributetable values (hibernate_sequence.nextval, (select entity_type_id from attributetable where name = 'TL Selection Criteria') ,'Prof/Assoc Prof w/ academic affiliation associated w/ medical school', 'Professor/Assoc Professor with academic affiliation that are associated with medical school',5,null,1,0,null,null,0,83009346,1,null,null,null,3);
Insert into attributetable values (hibernate_sequence.nextval, (select entity_type_id from attributetable where name = 'TL Selection Criteria') ,'Previous or current PI, study chair or member of study steering committee for large multi-site Nat''l/Internat''l trial', 'Previous or current principle investigator, study chair or member of study steering committee for large multi-site National/International trial',5,null,1,0,null,null,0,83009346,1,null,null,null,4);
Insert into attributetable values (hibernate_sequence.nextval, (select entity_type_id from attributetable where name = 'TL Selection Criteria') ,'Editor or member of editorial board for peer reviewed journal', 'Editor or member of editorial board for peer reviewed journal',5,null,1,0,null,null,0,83009346,1,null,null,null,5);
Insert into attributetable values (hibernate_sequence.nextval, (select entity_type_id from attributetable where name = 'TL Selection Criteria') ,'Published peer reviewed journal w/i 2 years', 'Published in peer reviewed journal within the last 2 years',5,null,1,0,null,null,0,83009346,1,null,null,null,6);
Insert into attributetable values (hibernate_sequence.nextval, (select entity_type_id from attributetable where name = 'TL Selection Criteria') ,'Regional leader in clinical community; validated Scientific/ Clinical  expert (5 peer nominations)', 'Well recognized regional leader in clinical community; Scientific/ Clinical  expert as validated by a minimum of 5 peer nominations in a given region',5,null,1,0,null,null,0,83009346,1,null,null,null,7);
Insert into attributetable values (hibernate_sequence.nextval, (select entity_type_id from attributetable where name = 'TL Selection Criteria') ,'Chair or leader in disease area at regional/state assoc/societies', 'Chair or leader in disease area at regional/state assocations/societies',5,null,1,0,null,null,0,83009346,1,null,null,null,8);
Insert into attributetable values (hibernate_sequence.nextval, (select entity_type_id from attributetable where name = 'TL Selection Criteria') ,'Regionally recognized speaker: BMS or IME, national/regional speaker', 'Regionally recognized speaker: BMS or IME, national/regional speaker',5,null,1,0,null,null,0,83009346,1,null,null,null,9);
Insert into attributetable values (hibernate_sequence.nextval, (select entity_type_id from attributetable where name = 'TL Selection Criteria') ,'Published in peer reviewed journal w/i 3 - 5 years', 'Published in peer reviewed journal within the last 3 - 5 years',5,null,1,0,null,null,0,83009346,1,null,null,null,10);
Insert into attributetable values (hibernate_sequence.nextval, (select entity_type_id from attributetable where name = 'TL Selection Criteria') ,'Decision makers providing input to organizations (eg. Managed Care Organizations) around pt access to meds', 'Decision makers providing input to organizations controlling patient access to medications (eg. Managed Care Organizations), which may include pharmacists, pharmacoeconomic or health outcomes researchers etc.',5,null,1,0,null,null,0,83009346,1,null,null,null,11);
Insert into attributetable values (hibernate_sequence.nextval, (select entity_type_id from attributetable where name = 'TL Selection Criteria') ,'Investigator at local clinical trial site (phase I-IV)', 'Investigator at local clinical trial site (phase I-IV)',5,null,1,0,null,null,0,83009346,1,null,null,null,12);
Insert into attributetable values (hibernate_sequence.nextval, (select entity_type_id from attributetable where name = 'TL Selection Criteria') ,'Faculty with academic affiliation, assoc w/ medicine', 'Faculty with academic affiliation that are associated with medicine',5,null,1,0,null,null,0,83009346,1,null,null,null,13);
Insert into attributetable values (hibernate_sequence.nextval, (select entity_type_id from attributetable where name = 'TL Selection Criteria') ,'Member of editorial board for a peer review journal', 'Member of editorial board for a peer review journal',5,null,1,0,null,null,0,83009346,1,null,null,null,14);

insert into option_names values ( hibernate_sequence.nextval, 'Selection Criteria Question', (select id from option_names where name = 'Sphere of Influence'));

delete from option_lookup where option_id = (select id from option_names where name = 'Sphere of Influence') and optvalue not in ('N/A', 'National');

insert into option_lookup values (hibernate_sequence.nextval, (select id from option_names where name = 'Sphere of Influence'), 'Regional A', 'N', -1, 0, 1);

insert into option_lookup values (hibernate_sequence.nextval, (select id from option_names where name = 'Sphere of Influence'), 'Regional B', 'N', -1, 0, 2);

update option_lookup set display_order = 3 where option_id = (select id from option_names where name = 'Sphere of Influence') and optvalue = 'National';

update option_lookup set display_order = 4 where option_id = (select id from option_names where name = 'Sphere of Influence') and optvalue = 'N/A';

update attributetable set display_order = 15 where parent_id = (select entity_type_id from attributetable where name = 'TL Selection Criteria') and name = 'MSL TL Type';

update attributetable set description = name where name = 'MSL TL Type';

update attributetable set display_order = 16 where parent_id = (select entity_type_id from attributetable where name = 'TL Selection Criteria') and name = 'Sphere of Influence'; 

insert into option_lookup
select
hibernate_sequence.nextval,
(select id from option_names where name = 'Selection Criteria Question'),
attribute_id,
'N',
case when display_order <= 6 then
  (select id from option_lookup where option_id = (select id from option_names where name = 'Sphere of Influence') and optvalue = 'National')
else
  (select id from option_lookup where option_id = (select id from option_names where name = 'Sphere of Influence') and optvalue = 'Regional A')
end,
0, 10000
from attributetable
where parent_id = (select entity_type_id from attributetable where name = 'TL Selection Criteria')
and display_order <= 14
and showable = 1;

Insert into GLOBAL_CONSTANTS (ID,NAME,VALUE) values (1,'MSL_OL_TYPE','MSL TL Type');
Insert into GLOBAL_CONSTANTS (ID,NAME,VALUE) values (2,'SPHERE_OF_INFLUENCE','Sphere of Influence');

delete from option_lookup where option_id = (select id from option_names where name = 'MSL TL Type');

insert into option_lookup values (hibernate_sequence.nextval, (select id from option_names where name = 'MSL TL Type'), 'TL', 'N', -1, 0, 1);
insert into option_lookup values (hibernate_sequence.nextval, (select id from option_names where name = 'MSL TL Type'), 'HCP', 'N', -1, 0, 2);
insert into option_lookup values (hibernate_sequence.nextval, (select id from option_names where name = 'MSL TL Type'), 'N/A', 'N', -1, 0, 3);

commit;

rem : 1>Author name         : Deepak
rem : 2>Purpose of change   : "New selection criteria questions"
rem : 3>Date of change      : 15-Dec-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 7

update attributetable set name='Thought Leader Criteria',description='Thought Leader Criteria' where name='TL Selection Criteria';

commit;

rem : 1>Author name         : Yatin
rem : 2>Purpose of change   : Query to change the name of 'TL Selection Criteria' attribute under BMS Info to 'Thought Leader Criteria'
rem : 3>Date of change      : 18-Dec-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 8

update option_names set parent = (select id from option_names where name = 'Dialog Objective')
where name = 'Medical Objective';

alter table option_lookup modify OPTVALUE VARCHAR2(4000);

rem : 1>Author name         : Tapan
rem : 2>Purpose of change   : sql to make the Communication Topic the parent of Medical Objective
rem : 3>Date of change      : 22-Dec-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 9


create or replace FUNCTION InteractionDetailAttendeeNames(interactionId NUMBER) RETURN varchar is V varchar(1000);
begin
v:='';
declare
cursor c1 is
SELECT * FROM attendees
WHERE interaction_id = interactionId
 AND userid NOT IN
  (SELECT userid
   FROM attendees att
   WHERE att.interaction_id = interactionId
   AND att.attendee_id =
    (SELECT MIN(attendee_id)
     FROM attendees attendee
     WHERE attendee.interaction_id = interactionId
     GROUP BY attendee.interaction_id)
  );
begin
for cr in c1
loop
v := v || cr.name || ' | ';
end loop;
end;
RETURN substr(v,0,length(v)-2);
END;
.
/

rem : 1>Author name         : Yatin
rem : 2>Purpose of change   : Interaction Detail Report - function to get other TL attendees
rem : 3>Date of change      : 22-Dec-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 10

  CREATE OR REPLACE FORCE VIEW "EXPERT_DETAILS_VIEW" ("ID", "KOLID", "FIRSTNAME", "MIDDLENAME", "LASTNAME", "DELETEFLAG", "PRIMARY_SPECIALITY", "SECONDARY_SPECIALITY", "TERTIARY_SPECIALITY", "TITLE", "MSL_OL_TYPE", "SPHERE_OF_INFLUENCE", "PRIMARY_PHONE", "PRIMARY_EMAIL", "PRIMARY_FAX", "PRIMARY_MOBILE", "ADDR_LINE_1", "ADDR_LINE_2", "ADDR_CITY", "ADDR_STATE", "ADDR_POSTAL_CODE", "ADDR_COUNTRY") AS 
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
ON (S6.ROOT_ENTITY_TYPE = 101 AND S6.ROOT_ENTITY_ID = A.KOLID AND S6.ATTRIBUTE_ID in (select attribute_id from attributetable where name='Sphere of Influence'))
WHERE A.DELETEFLAG='N' AND A.USER_TYPE_ID=4
ORDER BY A.KOLID;

rem : 1>Author name         : Yatin
rem : 2>Purpose of change   : Fetching value of new Sphere of Influence
rem : 3>Date of change      : 24-Dec-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 11

CREATE OR REPLACE FORCE VIEW "SC_INTERACTION_MPOL_VIEW" ("FIELD_NAME", "INTERACTION_ID", "INTERACTION_DATE", "INTERACTION_TYPE", "INTERACTION_TA", "ATTENDEE_ID", "ATTENDEE_NAME", "ATTENDEE_USERID", "ATTENDEETYPE", "OL_STATUS") AS 
SELECT 'Actual On Plan' as FIELD_NAME, ia.INTERACTION_ID,ia.INTERACTION_DATE,ia.INTERACTION_TYPE,ia.INTERACTION_TA,ia.ATTENDEE_ID,ia.ATTENDEE_NAME,ia.ATTENDEE_USERID,ia.ATTENDEETYPE,ia.OL_STATUS
FROM SC_Interaction_Attendee_View ia
WHERE ia.OL_status in ('TL', 'HCP');


  CREATE OR REPLACE FORCE VIEW "HCP_OL_SUMMARY" ("EXPERT_ID", "KOLID", "CVMET_OL_TYPE", "MSL_OL_TYPE", "SAXA_REVIEW_STATUS") AS 
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

rem : 1>Author name         : Yatin
rem : 2>Purpose of change   : Changed the values in OL_status to TL, HCP in SC_INTERACTION_MPOL_VIEW; Corrected the hard-coded value of attribute 'Saxa Review Status' in HCP_OL_SUMMARY
rem : 3>Date of change      : 24-Dec-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 12

alter trigger STRING_AUDIT disable;

insert into string_attribute
select
hibernate_sequence.nextval, (select attribute_id from attributetable where name = 'Sphere of Influence'), parent_id, 'N/A', 
root_entity_id, root_entity_type, tab_attribute_id, istable, row_id
from string_attribute where attribute_id = 83396591
and root_entity_id not in (select root_entity_id from string_attribute where attribute_id = (select attribute_id from attributetable where name = 'Sphere of Influence'));

alter trigger STRING_AUDIT enable;

commit;

rem : 1>Author name         : Deepak
rem : 2>Purpose of change   : "Set default values for SOI"
rem : 3>Date of change      : 28-Dec-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 13

update option_lookup set deleteflag='Y' where option_id = (select id from option_names where name like 'Off-label Topics');
commit;


rem : 1>Author name         : Tapan
rem : 2>Purpose of change   : Soft deleting all the Off Label Topics in the system. This query needs to be run before the Off Label Topic LOV load is done.
rem : 3>Date of change      : 29-Dec-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 14

CREATE OR REPLACE FORCE VIEW "HQ_AFFILIATION_ATTRIBUTES_VIEW" ("TA", "ATTRIBUTE_ID", "ATTRIBUTE_PATH") AS
  SELECT ta.ta, at.attribute_id, at.attribute_path FROM hq_ta_view ta
  LEFT OUTER JOIN attribute_tree_view at ON at.attribute_path= ta.ta_attribute_path||'Affiliation';

CREATE OR REPLACE FORCE VIEW "HQ_OL_SOI_VIEW" ("ROOT_ENTITY_ID", "ATTRIBUTE_ID", "ATTRIBUTE_PATH", "ATTRIBUTE_NAME", "VALUE") AS 
  SELECT val.root_entity_id, val.attribute_id, val.attribute_path, val.column_name as attribute_name, value
FROM scalar_attribute_value_view val where val.column_name = 'Sphere of Influence';
 

  CREATE OR REPLACE FORCE VIEW "HQ_OL_AFFILIATION_VIEW" ("ROOT_ENTITY_ID", "TA", "ATTRIBUTE_ID", "ATTRIBUTE_PATH", "ATTRIBUTE_NAME", "VALUE") AS 
  SELECT val.root_entity_id, affi_attr.ta,  val.attribute_id, val.attribute_path, val.column_name as attribute_name, value
FROM scalar_attribute_value_view val
INNER JOIN hq_affiliation_attributes_view affi_attr on affi_attr.attribute_id= val.attribute_id;


rem : 1>Author name         : Deepak
rem : 2>Purpose of change   : "Views changed for HQ reports"
rem : 3>Date of change      : 29-Dec-2009

rem ------------------------------------------------------------------------------------------------


rem : Batch : 15

update option_lookup set deleteflag = 'Y' where id in (
select id from option_lookup where parent in (
select id from option_lookup where parent in (
select id from option_lookup where optValue in ('Oncology', 'CVMET') and 
option_id = (select id from option_names where name like 'Therapeutic Area'))
and option_id = (select id from option_names where name like 'Product'))
and option_id = (select id from option_names where name like 'Dialog Objective'));


rem : 1>Author name         : Tapan
rem : 2>Purpose of change   : "Soft deleting all the Communication Topic (Dialog Objective LOVs) for CVMET and ONC TA's"
rem : 3>Date of change      : 30-Dec-2009

rem ------------------------------------------------------------------------------------------------


rem : Batch : 16

update entitytypes set name='Thought Leader Criteria', description='Thought Leader Criteria' where name='TL Selection Criteria'

commit;

rem : 1>Author name         : Yatin
rem : 2>Purpose of change   : Updating 'TL Selection Criteria' to 'Thought Leader Criteria' in Entitytypes table.
rem : 3>Date of change      : 11-Jan-2010

rem ------------------------------------------------------------------------------------------------



commit;

rem user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

SPOOL OFF

SET ECHO OFF

exit;

rem ------------------------------------------------------------------------------------------------