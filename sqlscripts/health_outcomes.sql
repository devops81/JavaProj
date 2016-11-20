rem ------------------------------------------------------------------------------------------------
rem Filename:   health_outcomes.sql
rem Purpose	:   To add new Health Outcomes tabs in profile based on TA
rem Date	:	27-Mar-2009
rem Author	:   Deepak
rem ------------------------------------------------------------------------------------------------

SET TIME ON
SET ESCAPE \
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : health_outcomes.log
SPOOL health_outcomes.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------

rem --- Add the new TA

insert into option_lookup values (hibernate_sequence.nextval, 44, 'Health Outcomes', 'N', 85248368, 0, 10000);

rem --- Add the new Functional Area

insert into option_lookup values (hibernate_sequence.nextval, 34, 'Health Outcomes', 'N', -1, 0, 10000);

rem --- Add the new Groups

insert into groups values (hibernate_sequence.nextval, 'Health Outcomes_FLD', 'Health Outcomes_FLD', 'User', 1, 
(select id from option_lookup where optvalue = 'Health Outcomes' and option_id = 44), 
(select id from option_lookup where optvalue = 'Health Outcomes' and option_id = 34),
6503);

insert into groups values (hibernate_sequence.nextval, 'Health Outcomes_HQ', 'Health Outcomes_HQ', 'User', 1, 
(select id from option_lookup where optvalue = 'Health Outcomes' and option_id = 44), 
(select id from option_lookup where optvalue = 'HQ' and option_id = 34),
6503);

rem --- Add TA Attribute Tab and attributes

insert into entitytypes values (hibernate_sequence.nextval, 'Health Outcomes Attributes', 'Health Outcomes Attributes', null, 2);

insert into attributetable values (hibernate_sequence.nextval, 83005800, 'Health Outcomes Attributes', 'Health Outcomes Attributes',
(select entity_type_id from entitytypes where name = 'Health Outcomes Attributes'), null, 0, 0, 'Small', null, 0, -1, 1, null, null, null,0);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Health Outcomes Attributes'),
'Health Outcomes Sphere of Influence','Health Outcomes Sphere of Influence', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 0);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Health Outcomes Attributes'),
'Health Outcomes Advisor','Health Outcomes Advisor', 5, null, 0, 1, null, null, 0, 83396610, 1, null, null, null, 2);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Health Outcomes Attributes'),
'Health Outcomes Author','Health Outcomes Author', 5, null, 0, 1, null, null, 0, 83396610, 1, null, null, null, 3);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Health Outcomes Attributes'),
'Health Outcomes Investigator','Health Outcomes Investigator', 5, null, 0, 1, null, null, 0, 83396610, 1, null, null, null, 4);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Health Outcomes Attributes'),
'Health Outcomes Speaker','Health Outcomes Speaker', 5, null, 0, 1, null, null, 0, 83396610, 1, null, null, null, 5);

rem --- Add EAV permissions for the new TA Attribute TAB

insert into expertdna_privileges
select
hibernate_sequence.nextval, 
groupid,
2,'Expert.BMS_Info.Health_Outcomes_Attributes', 'N', 'N', 'N', 'N' 
from groups where groupname not in ( 'Health Outcomes_FLD', 'Health Outcomes_HQ' );

rem --- Disable access to the other TA Attribute tabs

insert into expertdna_privileges
select
hibernate_sequence.nextval, 
groupid,
2,'Expert.BMS_Info.CVMET_Attributes', 'N', 'N', 'N', 'N' 
from groups where groupname in ( 'Health Outcomes_FLD', 'Health Outcomes_HQ' );

insert into expertdna_privileges
select
hibernate_sequence.nextval, 
groupid,
2,'Expert.BMS_Info.Immunoscience_Attributes', 'N', 'N', 'N', 'N' 
from groups where groupname in ( 'Health Outcomes_FLD', 'Health Outcomes_HQ' );

insert into expertdna_privileges
select
hibernate_sequence.nextval, 
groupid,
2,'Expert.BMS_Info.Neuro_Attributes', 'N', 'N', 'N', 'N' 
from groups where groupname in ( 'Health Outcomes_FLD', 'Health Outcomes_HQ' );

insert into expertdna_privileges
select
hibernate_sequence.nextval, 
groupid,
2,'Expert.BMS_Info.Oncology_Attributes', 'N', 'N', 'N', 'N' 
from groups where groupname in ( 'Health Outcomes_FLD', 'Health Outcomes_HQ' );

insert into expertdna_privileges
select
hibernate_sequence.nextval, 
groupid,
2,'Expert.BMS_Info.Virology_Attributes', 'N', 'N', 'N', 'N' 
from groups where groupname in ( 'Health Outcomes_FLD', 'Health Outcomes_HQ' );

rem --- Disable access to the other TA Attribute Advance Search Attributes

update feature_usergroup_map set usergroup_id = usergroup_id||
(select groupid from groups where groupname like 'Health Outcomes_FLD')||','
where feature_id in (select attribute_id from attributetable 
where parent_id in (select entity_type_id from entitytypes where
name not like 'Health Outcomes Attributes' and 
name like '%_Attributes')) and permission_on_feature = 4;

update feature_usergroup_map set usergroup_id = usergroup_id||
(select groupid from groups where groupname like 'Health Outcomes_HQ')||','
where feature_id in (select attribute_id from attributetable 
where parent_id in (select entity_type_id from entitytypes where
name not like 'Health Outcomes Attributes' and 
name like '%_Attributes')) and permission_on_feature = 4;

rem --- Add Advance Search permissions for the new TA Attribute TAB

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
attribute_id ,
','||(select groupid from groups where groupname = 'ONC_FLD')||','||
(select groupid from groups where groupname = 'ONC_HQ')||','||
(select groupid from groups where groupname = 'NEURO_HQ')||','||
(select groupid from groups where groupname = 'NEURO_HQ')||','||
(select groupid from groups where groupname = 'SAXA_JV')||','||
(select groupid from groups where groupname = 'CVMET_FLD')||','||
(select groupid from groups where groupname = 'CVMET_HQ')||',' , 4
from attributetable 
where parent_id = (select entity_type_id from entitytypes where name = 'Health Outcomes Attributes');

rem --- Add new LOV for the new TA Attribute TAB

insert into option_names values ( hibernate_sequence.nextval, 'Health Outcomes Tags', -1);

rem --- Add TA Tags Tab and attributes

insert into entitytypes values (hibernate_sequence.nextval, 'Health Outcomes Tags', 'Health Outcomes Tags', null, 2);

insert into attributetable values (hibernate_sequence.nextval,83005800, 'Health Outcomes Tags', 'Health Outcomes Tags',
(select entity_type_id from entitytypes where name = 'Health Outcomes Tags'), null, 0, 1, null, null, 1, -1, 1, null, null, null,0);

insert into attributetable values (hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name = 'Health Outcomes Tags'), 'Health Outcomes Tags', 'Health Outcomes Tags', 5, null, 0, 1, null, null, 0, 
(select id from option_names where name='Health Outcomes Tags'), 1, null, null,null, 4);

rem --- Add EAV permissions for the new TA Tags TAB

insert into expertdna_privileges
select
hibernate_sequence.nextval, 
groupid,
2,'Expert.BMS_Info.Health_Outcomes_Tags', 'N', 'N', 'N', 'N' 
from groups where groupname not in ( 'Health Outcomes_FLD', 'Health Outcomes_HQ' );

rem --- Disable access to the other TA Tags tabs

insert into expertdna_privileges
select
hibernate_sequence.nextval, 
groupid,
2,'Expert.BMS_Info.CVMET_Tags', 'N', 'N', 'N', 'N' 
from groups where groupname in ( 'Health Outcomes_FLD', 'Health Outcomes_HQ' );

insert into expertdna_privileges
select
hibernate_sequence.nextval, 
groupid,
2,'Expert.BMS_Info.Immunoscience_Tags', 'N', 'N', 'N', 'N' 
from groups where groupname in ( 'Health Outcomes_FLD', 'Health Outcomes_HQ' );

insert into expertdna_privileges
select
hibernate_sequence.nextval, 
groupid,
2,'Expert.BMS_Info.Neuro_Tags', 'N', 'N', 'N', 'N' 
from groups where groupname in ( 'Health Outcomes_FLD', 'Health Outcomes_HQ' );

insert into expertdna_privileges
select
hibernate_sequence.nextval, 
groupid,
2,'Expert.BMS_Info.Oncology_Tags', 'N', 'N', 'N', 'N' 
from groups where groupname in ( 'Health Outcomes_FLD', 'Health Outcomes_HQ' );

insert into expertdna_privileges
select
hibernate_sequence.nextval, 
groupid,
2,'Expert.BMS_Info.Virology_Tags', 'N', 'N', 'N', 'N' 
from groups where groupname in ( 'Health Outcomes_FLD', 'Health Outcomes_HQ' );

rem --- Disable access to the other TA Tags Advance Search Attributes

update feature_usergroup_map set usergroup_id = usergroup_id||
(select groupid from groups where groupname like 'Health Outcomes_FLD')||','
where feature_id in (select attribute_id from attributetable 
where parent_id in (select entity_type_id from entitytypes where
name not like 'Health Outcomes Tags' and 
name like '%_Tags')) and permission_on_feature = 4;

update feature_usergroup_map set usergroup_id = usergroup_id||
(select groupid from groups where groupname like 'Health Outcomes_HQ')||','
where feature_id in (select attribute_id from attributetable 
where parent_id in (select entity_type_id from entitytypes where
name not like 'Health Outcomes Tags' and 
name like '%_Tags')) and permission_on_feature = 4;

rem --- Add Advance Search permissions for the new TA Tags TAB

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
attribute_id ,
','||(select groupid from groups where groupname = 'ONC_FLD')||','||
(select groupid from groups where groupname = 'ONC_HQ')||','||
(select groupid from groups where groupname = 'NEURO_HQ')||','||
(select groupid from groups where groupname = 'NEURO_HQ')||','||
(select groupid from groups where groupname = 'SAXA_JV')||','||
(select groupid from groups where groupname = 'CVMET_FLD')||','||
(select groupid from groups where groupname = 'CVMET_HQ')||',' , 4
from attributetable 
where parent_id = (select entity_type_id from entitytypes where name = 'Health Outcomes Tags');

rem : ------------------------------------------------------------------------------------------------

commit;

rem user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

SPOOL OFF
SET ECHO OFF
exit;
rem ------------------------------------------------------------------------------------------------