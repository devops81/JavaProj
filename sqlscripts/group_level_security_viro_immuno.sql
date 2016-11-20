rem ------------------------------------------------------------------------------------------------
rem Filename:   group_level_security_viro_immuno.sql
rem Purpose	:   To add Group Level Security to various features
rem Date	:	08-Mar-2009
rem Author	:   Tapan
rem ------------------------------------------------------------------------------------------------

SET TIME ON
SET ESCAPE \
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : group_level_security.log
SPOOL group_level_security.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------

rem Restricting 4 groups to view Products of CVMET TA

update feature_usergroup_map
set usergroup_id = usergroup_id||
(select groupid from groups where groupname = 'VIROLOGY_FLD')||','||
(select groupid from groups where groupname = 'VIROLOGY_HQ')||','||
(select groupid from groups where groupname = 'IMMUNO_FLD')||','||
(select groupid from groups where groupname = 'IMMUNO_HQ')||','
where feature_id in
(select id from option_lookup 
where option_id = (select id from option_names where name = 'Product')
and parent = (select id from option_lookup where option_id = (select id from option_names where name = 'Therapeutic Area') 
and optvalue = 'CVMET'));


rem Restricting 4 Groups to view product Diabetes

update feature_usergroup_map set usergroup_id = usergroup_id||
(select groupid from groups where groupname = 'VIROLOGY_FLD')||','||
(select groupid from groups where groupname = 'VIROLOGY_HQ')||','||
(select groupid from groups where groupname = 'IMMUNO_FLD')||','||
(select groupid from groups where groupname = 'IMMUNO_HQ')||','
where feature_id = (select id from option_lookup where optvalue = 'Diabetes' and option_id = (select id from option_names where name = 'Product'));


rem Restricting 4 Groups to view Products of Neuro TA

update feature_usergroup_map set usergroup_id = usergroup_id||
(select groupid from groups where groupname = 'VIROLOGY_FLD')||','||
(select groupid from groups where groupname = 'VIROLOGY_HQ')||','||
(select groupid from groups where groupname = 'IMMUNO_FLD')||','||
(select groupid from groups where groupname = 'IMMUNO_HQ')||','
where feature_id in (select id from option_lookup 
where option_id = (select id from option_names where name = 'Product')
and parent = (select id from option_lookup where option_id = (select id from option_names where name = 'Therapeutic Area') 
and optvalue = 'Neuro'));


rem Restricting 4 Groups to view Products of Oncology TA

update feature_usergroup_map set usergroup_id = usergroup_id||
(select groupid from groups where groupname = 'VIROLOGY_FLD')||','||
(select groupid from groups where groupname = 'VIROLOGY_HQ')||','||
(select groupid from groups where groupname = 'IMMUNO_FLD')||','||
(select groupid from groups where groupname = 'IMMUNO_HQ')||','
where feature_id in (select id from option_lookup 
where option_id = (select id from option_names where name = 'Product')
and parent = (select id from option_lookup where option_id = (select id from option_names where name = 'Therapeutic Area') 
and optvalue = 'Oncology'));


rem Restricting all Other groups , other than CVMET_FLD and CVMET_HQ to view Pravachol Product.

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
id ,
','||(select groupid from groups where groupname = 'ONC_FLD')||','||
(select groupid from groups where groupname = 'ONC_HQ')||','||
(select groupid from groups where groupname = 'NEURO_FLD')||','||
(select groupid from groups where groupname = 'NEURO_HQ')||',' ||
(select groupid from groups where groupname = 'SAXA_JV')||','||
(select groupid from groups where groupname = 'VIROLOGY_FLD')||','||
(select groupid from groups where groupname = 'VIROLOGY_HQ')||','||
(select groupid from groups where groupname = 'IMMUNO_FLD')||','||
(select groupid from groups where groupname = 'IMMUNO_HQ')||',', 2
from option_lookup 
where option_id = (select id from option_names where name = 'Product')
and parent = (select id from option_lookup where option_id = (select id from option_names where name = 'Therapeutic Area') 
and optvalue = 'CVMET');


rem Restricting all other groups to view Products of Virology TA

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
id ,
','||(select groupid from groups where groupname = 'ONC_FLD')||','||
(select groupid from groups where groupname = 'ONC_HQ')||','||
(select groupid from groups where groupname = 'NEURO_FLD')||','||
(select groupid from groups where groupname = 'NEURO_HQ')||',' ||
(select groupid from groups where groupname = 'SAXA_JV')||','||
(select groupid from groups where groupname = 'CVMET_FLD')||','||
(select groupid from groups where groupname = 'CVMET_HQ')||','||
(select groupid from groups where groupname = 'IMMUNO_FLD')||','||
(select groupid from groups where groupname = 'IMMUNO_HQ')||',', 2
from option_lookup 
where option_id = (select id from option_names where name = 'Product')
and parent = (select id from option_lookup where option_id = (select id from option_names where name = 'Therapeutic Area') 
and optvalue = 'Virology');



rem Restricting all other groups to view Products of ImmunoScience TA

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
id ,
','||(select groupid from groups where groupname = 'ONC_FLD')||','||
(select groupid from groups where groupname = 'ONC_HQ')||','||
(select groupid from groups where groupname = 'NEURO_FLD')||','||
(select groupid from groups where groupname = 'NEURO_HQ')||',' ||
(select groupid from groups where groupname = 'SAXA_JV')||','||
(select groupid from groups where groupname = 'CVMET_FLD')||','||
(select groupid from groups where groupname = 'CVMET_HQ')||','||
(select groupid from groups where groupname = 'VIROLOGY_FLD')||','||
(select groupid from groups where groupname = 'VIROLOGY_HQ')||',', 2
from option_lookup 
where option_id = (select id from option_names where name = 'Product')
and parent = (select id from option_lookup where option_id = (select id from option_names where name = 'Therapeutic Area') 
and optvalue = 'Immunoscience');



update feature_usergroup_map set usergroup_id = usergroup_id||
(select groupid from groups where groupname = 'VIROLOGY_FLD')||','||
(select groupid from groups where groupname = 'IMMUNO_FLD')||','
where usergroup_id like '%,'||(select groupid from groups where groupname = 'CVMMET_FLD')||',%'
and feature_id in (select id from option_lookup where 
option_id = (select id from option_names where name = 'Interaction Topic') )
and usergroup_id not like '%,'||(select groupid from groups where groupname = 'IMMUNO_FLD')||',%'
and usergroup_id not like '%,'||(select groupid from groups where groupname = 'VIROLOGY_FLD')||',%';



update feature_usergroup_map set usergroup_id = usergroup_id||
(select groupid from groups where groupname = 'IMMUNO_HQ')||','||
(select groupid from groups where groupname = 'VIROLOGY_HQ')||','
where usergroup_id like '%,'||(select groupid from groups where groupname = 'CVMET_HQ')||',%'
and feature_id in (select id from option_lookup where 
option_id = (select id from option_names where name = 'Interaction Topic') )
and usergroup_id not like '%,'||(select groupid from groups where groupname = 'IMMUNO_HQ')||',%'
and usergroup_id not like '%,'||(select groupid from groups where groupname = 'VIROLOGY_HQ')||',%';

rem : TA permissions

update feature_usergroup_map
set usergroup_id = usergroup_id||
(select groupid from groups where groupname = 'VIROLOGY_FLD')||','||
(select groupid from groups where groupname = 'VIROLOGY_HQ')||','||
(select groupid from groups where groupname = 'IMMUNO_FLD')||','||
(select groupid from groups where groupname = 'IMMUNO_HQ')||','
where feature_id in
(select id from option_lookup 
where option_id = (select id from option_names where name = 'Therapeutic Area')
and optvalue = 'CVMET');

update feature_usergroup_map
set usergroup_id = usergroup_id||
(select groupid from groups where groupname = 'VIROLOGY_FLD')||','||
(select groupid from groups where groupname = 'VIROLOGY_HQ')||','||
(select groupid from groups where groupname = 'IMMUNO_FLD')||','||
(select groupid from groups where groupname = 'IMMUNO_HQ')||','
where feature_id in
(select id from option_lookup 
where option_id = (select id from option_names where name = 'Therapeutic Area')
and optvalue = 'Oncology');

update feature_usergroup_map
set usergroup_id = usergroup_id||
(select groupid from groups where groupname = 'VIROLOGY_FLD')||','||
(select groupid from groups where groupname = 'VIROLOGY_HQ')||','||
(select groupid from groups where groupname = 'IMMUNO_FLD')||','||
(select groupid from groups where groupname = 'IMMUNO_HQ')||','
where feature_id in
(select id from option_lookup 
where option_id = (select id from option_names where name = 'Therapeutic Area')
and optvalue = 'Neuro');

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
id ,
','||(select groupid from groups where groupname = 'SAXA_JV')||','||
(select groupid from groups where groupname = 'CVMET_HQ')||','||
(select groupid from groups where groupname = 'CVMMET_FLD')||','||
(select groupid from groups where groupname = 'NEURO_FLD')||','||
(select groupid from groups where groupname = 'NEURO_HQ')||','||
(select groupid from groups where groupname = 'IMMUNO_FLD')||','||
(select groupid from groups where groupname = 'IMMUNO_HQ')||','||
(select groupid from groups where groupname = 'ONC_FLD')||','||
(select groupid from groups where groupname = 'ONC_HQ')||',', 2
from option_lookup 
where option_id = (select id from option_names where name = 'Therapeutic Area')
and optvalue = 'Virology';

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
id ,
','||(select groupid from groups where groupname = 'SAXA_JV')||','||
(select groupid from groups where groupname = 'CVMET_HQ')||','||
(select groupid from groups where groupname = 'CVMMET_FLD')||','||
(select groupid from groups where groupname = 'NEURO_FLD')||','||
(select groupid from groups where groupname = 'NEURO_HQ')||','||
(select groupid from groups where groupname = 'VIROLOGY_FLD')||','||
(select groupid from groups where groupname = 'VIROLOGY_HQ')||','||
(select groupid from groups where groupname = 'ONC_FLD')||','||
(select groupid from groups where groupname = 'ONC_HQ')||',', 2
from option_lookup 
where option_id = (select id from option_names where name = 'Therapeutic Area')
and optvalue = 'Immunoscience';

rem : ------------------------------------------------------------------------------------------------

commit;

rem user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

SPOOL OFF
SET ECHO OFF
exit;
rem ------------------------------------------------------------------------------------------------
