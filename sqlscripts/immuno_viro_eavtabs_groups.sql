rem ------------------------------------------------------------------------------------------------
rem Filename:   immuno_viro_eavtabs_groups.sql
rem Purpose	:   To add new EAV Tabs for immunology and virology, usergroups
rem Date	:	06-Mar-2009
rem Author	:   Kiruba
rem ------------------------------------------------------------------------------------------------

SET TIME ON
SET ESCAPE \
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : immuno_viro_eavtabs_groups.log
SPOOL immuno_viro_eavtabs_groups.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------


insert into option_lookup values (hibernate_sequence.nextval, 44, 'Immunoscience', 'N', 85248368, 0, 10000);
insert into option_lookup values (hibernate_sequence.nextval, 44, 'Virology', 'N', 85248368, 0, 10000);


insert into groups values (hibernate_sequence.nextval, 'IMMUNO_FLD', 'IMMUNO_FLD', 'User', 1, 
(select id from option_lookup where optvalue = 'Immunoscience' and option_id = 44), 
(select id from option_lookup where optvalue = 'FLD' and option_id = 34),
6503);

insert into groups values (hibernate_sequence.nextval, 'IMMUNO_HQ', 'IMMUNO_HQ', 'User', 1, 
(select id from option_lookup where optvalue = 'Immunoscience'  and option_id = 44), 
(select id from option_lookup where optvalue = 'HQ' and option_id = 34), 
6503);


insert into groups values (hibernate_sequence.nextval, 'VIROLOGY_FLD', 'VIROLOGY_FLD', 'User', 1, 
(select id from option_lookup where optvalue = 'Virology'  and option_id = 44), 
(select id from option_lookup where optvalue = 'FLD'  and option_id = 34), 6503);

insert into groups values (hibernate_sequence.nextval, 'VIROLOGY_HQ', 'VIROLOGY_HQ', 'User', 1, 
(select id from option_lookup where optvalue = 'Virology'  and option_id = 44), 
(select id from option_lookup where optvalue = 'HQ' and option_id = 34),
6503);

rem ------------------------------------------------------------------------------------------------

rem ------------------------------------------------------------------------------------------------


insert into entitytypes values (hibernate_sequence.nextval, 'Virology Attributes', 'Virology Attributes', null, 2);

insert into attributetable values (hibernate_sequence.nextval, 83005800, 'Virology Attributes', 'Virology Attributes',
(select entity_type_id from entitytypes where name = 'Virology Attributes'), null, 0, 0, 'Small', null, 0, -1, 1, null, null, null,0);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Virology Attributes'),
'Virology Sphere of Influence','Virology Sphere of Influence', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 0);


insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Virology Attributes'),
'Virology Speaker','Virology Speaker', 5, null, 0, 1, null, null, 0, 83396610, 1, null, null, null, 1);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Virology Attributes'),
'Virology Investigator','Virology Investigator', 5, null, 0, 1, null, null, 0, 83396610, 1, null, null, null, 2);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Virology Attributes'),
'Virology Advisor','Virology Advisor', 5, null, 0, 1, null, null, 0, 83396610, 1, null, null, null, 3);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Virology Attributes'),
'Virology Author','Virology Author', 5, null, 0, 1, null, null, 0, 83396610, 1, null, null, null, 4);


rem ------------------------------------------------------------------------------------------------


insert into option_names values ( hibernate_sequence.nextval, 'Virology Tags', -1);

insert into entitytypes values (hibernate_sequence.nextval, 'Virology Tags', 'Virology Tags', null, 2);

insert into attributetable values (hibernate_sequence.nextval,83005800, 'Virology Tags', 'Virology Tags',
(select entity_type_id from entitytypes where name = 'Virology Tags'), null, 0, 1, null, null, 1, -1, 1, null, null, null,0);

insert into attributetable values (hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name = 'Virology Tags'), 'Virology Tags', 'Virology Tags', 5, null, 0, 1, null, null, 0, 
(select id from option_names where name='Virology Tags'), 1, null, null,null, 1);


insert into entitytypes values (hibernate_sequence.nextval, 'Immunoscience Attributes', 'Immunoscience Attributes', null, 2);

insert into attributetable values (hibernate_sequence.nextval, 83005800, 'Immunoscience Attributes', 'Immunoscience Attributes',
(select entity_type_id from entitytypes where name = 'Immunoscience Attributes'), null, 0, 0, 'Small', null, 0, -1, 1, null, null, null,0);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Immunoscience Attributes'),
'Immunoscience Sphere of Influence','Immunoscience Sphere of Influence', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 0);


insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Immunoscience Attributes'),
'Immunoscience Speaker','Immunoscience Speaker', 5, null, 0, 1, null, null, 0, 83396610, 1, null, null, null, 1);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Immunoscience Attributes'),
'Immunoscience Investigator','Immunoscience Investigator', 5, null, 0, 1, null, null, 0, 83396610, 1, null, null, null, 2);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Immunoscience Attributes'),
'Immunoscience Advisor','Immunoscience Advisor', 5, null, 0, 1, null, null, 0, 83396610, 1, null, null, null, 3);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Immunoscience Attributes'),
'Immunoscience Author','Immunoscience Author', 5, null, 0, 1, null, null, 0, 83396610, 1, null, null, null, 4);

rem ------------------------------------------------------------------------------------------------

insert into option_names values ( hibernate_sequence.nextval, 'Immunoscience Tags', -1);

insert into entitytypes values (hibernate_sequence.nextval, 'Immunoscience Tags', 'Immunoscience Tags', null, 2);

insert into attributetable values (hibernate_sequence.nextval,83005800, 'Immunoscience Tags', 'Immunoscience Tags',
(select entity_type_id from entitytypes where name = 'Immunoscience Tags'), null, 0, 1, null, null, 1, -1, 1, null, null, null,0);

insert into attributetable values (hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name = 'Immunoscience Tags'), 'Immunoscience Tags', 'Immunoscience Tags', 5, null, 0, 1, null, null, 0, 
(select id from option_names where name='Immunoscience Tags'), 1, null, null,null, 1);


rem ------------------------------------------------------------------------------------------------

insert into expertdna_privileges
select
hibernate_sequence.nextval, 
groupid,
2,'Expert.BMS_Info.Immunoscience_Tags', 'N', 'N', 'N', 'N' 
from groups where groupname not in ('IMMUNO_FLD', 'IMMUNO_HQ');

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
attribute_id ,
','||(select groupid from groups where groupname = 'ONC_FLD')||','||
(select groupid from groups where groupname = 'ONC_HQ')||','||
(select groupid from groups where groupname = 'CVMET_FLD')||','||
(select groupid from groups where groupname = 'CVMET_HQ')||','||
(select groupid from groups where groupname = 'NEURO_FLD')||','||
(select groupid from groups where groupname = 'NEURO_HQ')||','||
(select groupid from groups where groupname = 'VIROLOGY_FLD')||','||
(select groupid from groups where groupname = 'VIROLOGY_HQ')||',', 4
from attributetable 
where parent_id = (select entity_type_id from entitytypes where name = 'Immunoscience Tags');



insert into expertdna_privileges
select
hibernate_sequence.nextval, 
groupid,
2,'Expert.BMS_Info.Oncology_Tags', 'N', 'N', 'N', 'N' 
from groups where groupname in ('VIROLOGY_FLD', 'VIROLOGY_HQ','IMMUNO_HQ','IMMUNO_FLD');

insert into expertdna_privileges
select
hibernate_sequence.nextval, 
groupid,
2,'Expert.BMS_Info.Oncology_Attributes', 'N', 'N', 'N', 'N' 
from groups where groupname in ('VIROLOGY_FLD', 'VIROLOGY_HQ','IMMUNO_HQ','IMMUNO_FLD');

insert into expertdna_privileges
select
hibernate_sequence.nextval, 
groupid,
2,'Expert.BMS_Info.CVMET_Attributes', 'N', 'N', 'N', 'N' 
from groups where groupname in ('VIROLOGY_FLD', 'VIROLOGY_HQ','IMMUNO_HQ','IMMUNO_FLD');

insert into expertdna_privileges
select
hibernate_sequence.nextval, 
groupid,
2,'Expert.BMS_Info.CVMET_Tags', 'N', 'N', 'N', 'N' 
from groups where groupname in ('VIROLOGY_FLD', 'VIROLOGY_HQ','IMMUNO_HQ','IMMUNO_FLD');

insert into expertdna_privileges
select
hibernate_sequence.nextval, 
groupid,
2,'Expert.BMS_Info.Neuro_Attributes', 'N', 'N', 'N', 'N' 
from groups where groupname in ('VIROLOGY_FLD', 'VIROLOGY_HQ','IMMUNO_HQ','IMMUNO_FLD');

insert into expertdna_privileges
select
hibernate_sequence.nextval, 
groupid,
2,'Expert.BMS_Info.Neuro_Tags', 'N', 'N', 'N', 'N' 
from groups where groupname in ('VIROLOGY_FLD', 'VIROLOGY_HQ','IMMUNO_HQ','IMMUNO_FLD');



rem ------------------------------------------------------------------------------------------------


update feature_usergroup_map
set usergroup_id = usergroup_id||
(select groupid from groups where groupname = 'VIROLOGY_FLD')||','||
(select groupid from groups where groupname = 'VIROLOGY_HQ')||','||
(select groupid from groups where groupname = 'IMMUNO_FLD')||','||
(select groupid from groups where groupname = 'IMMUNO_HQ')||','
where feature_id in (select entity_type_id from entitytypes where name in ('Neuro Tags','Neuro Attributes','CVMET Tags','CVMET Attributes','Oncology Attributes','Oncology Tags'));

insert into expertdna_privileges
select
hibernate_sequence.nextval, 
groupid,
2,'Expert.BMS_Info.Immunoscience_Attributes', 'N', 'N', 'N', 'N' 
from groups where groupname not in ( 'IMMUNO_FLD', 'IMMUNO_HQ');

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
attribute_id ,
','||(select groupid from groups where groupname = 'ONC_FLD')||','||
(select groupid from groups where groupname = 'ONC_HQ')||','||
(select groupid from groups where groupname = 'CVMET_FLD')||','||
(select groupid from groups where groupname = 'CVMET_HQ')||','||
(select groupid from groups where groupname = 'NEURO_FLD')||','||
(select groupid from groups where groupname = 'NEURO_HQ')||','||
(select groupid from groups where groupname = 'VIROLOGY_FLD')||','||
(select groupid from groups where groupname = 'VIROLOGY_HQ')||',', 4
from attributetable 
where parent_id = (select entity_type_id from entitytypes where name = 'Immunoscience Attributes');

rem ------------------------------------------------------------------------------------------------

insert into expertdna_privileges
select
hibernate_sequence.nextval, 
groupid,
2,'Expert.BMS_Info.Virology_Tags', 'N', 'N', 'N', 'N' 
from groups where groupname not in ('VIROLOGY_FLD', 'VIROLOGY_HQ');

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
attribute_id ,
','||(select groupid from groups where groupname = 'ONC_FLD')||','||
(select groupid from groups where groupname = 'ONC_HQ')||','||
(select groupid from groups where groupname = 'CVMET_FLD')||','||
(select groupid from groups where groupname = 'CVMET_HQ')||','||
(select groupid from groups where groupname = 'NEURO_FLD')||','||
(select groupid from groups where groupname = 'NEURO_HQ')||','||
(select groupid from groups where groupname = 'IMMUNO_FLD')||','||
(select groupid from groups where groupname = 'IMMUNO_HQ')||',', 4
from attributetable 
where parent_id = (select entity_type_id from entitytypes where name = 'Virology Tags');


rem ------------------------------------------------------------------------------------------------

insert into expertdna_privileges
select
hibernate_sequence.nextval, 
groupid,
2,'Expert.BMS_Info.Virology_Attributes', 'N', 'N', 'N', 'N' 
from groups where groupname not in ( 'VIROLOGY_FLD', 'VIROLOGY_HQ');

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
attribute_id ,
','||(select groupid from groups where groupname = 'ONC_FLD')||','||
(select groupid from groups where groupname = 'ONC_HQ')||','||
(select groupid from groups where groupname = 'CVMET_FLD')||','||
(select groupid from groups where groupname = 'CVMET_HQ')||','||
(select groupid from groups where groupname = 'NEURO_FLD')||','||
(select groupid from groups where groupname = 'NEURO_HQ')||','||
(select groupid from groups where groupname = 'IMMUNO_FLD')||','||
(select groupid from groups where groupname = 'IMMUNO_HQ')||',', 4
from attributetable 
where parent_id = (select entity_type_id from entitytypes where name = 'Virology Attributes');


rem : ------------------------------------------------------------------------------------------------

commit;

rem user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

SPOOL OFF
SET ECHO OFF
exit;
rem ------------------------------------------------------------------------------------------------


