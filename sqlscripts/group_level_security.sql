rem ------------------------------------------------------------------------------------------------
rem Filename:   group_level_security.sql
rem Purpose	:   To add Group Level Security to various features
rem Date	:	16-Feb-2009
rem Author	:   Deepak
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

update option_names set parent = (select id from option_names where name = 'Therapeutic Area') where name='Product';

update option_lookup
set parent = (select id from option_lookup where optvalue = 'CVMET' and option_id = (select id from option_names where name = 'Therapeutic Area'))
where option_id = (select id from option_names where name = 'Product') 
and parent = -1;

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
id ,
','||(select groupid from groups where groupname = 'ONC_FLD')||','||
(select groupid from groups where groupname = 'ONC_HQ')||','||
(select groupid from groups where groupname = 'NEURO_FLD')||','||
(select groupid from groups where groupname = 'NEURO_HQ')||',' ||
(select groupid from groups where groupname = 'SAXA_JV')||',', 2
from option_lookup 
where option_id = (select id from option_names where name = 'Product')
and parent = (select id from option_lookup where option_id = (select id from option_names where name = 'Therapeutic Area') 
and optvalue = 'CVMET');

update feature_usergroup_map set usergroup_id = 
','||(select groupid from groups where groupname = 'ONC_FLD')||','||
(select groupid from groups where groupname = 'ONC_HQ')||','||
(select groupid from groups where groupname = 'NEURO_FLD')||','||
(select groupid from groups where groupname = 'NEURO_HQ')||','
where feature_id = (select id from option_lookup where optvalue = 'Diabetes' and option_id = (select id from option_names where name = 'Product'));

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
id ,
','||(select groupid from groups where groupname = 'ONC_FLD')||','||
(select groupid from groups where groupname = 'ONC_HQ')||','||
(select groupid from groups where groupname = 'CVMMET_FLD')||','||
(select groupid from groups where groupname = 'CVMET_HQ')||','  ||
(select groupid from groups where groupname = 'SAXA_JV')||',', 2
from option_lookup 
where option_id = (select id from option_names where name = 'Product')
and parent = (select id from option_lookup where option_id = (select id from option_names where name = 'Therapeutic Area') 
and optvalue = 'Neuro');

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
id ,
','||(select groupid from groups where groupname = 'CVMMET_FLD')||','||
(select groupid from groups where groupname = 'CVMET_HQ')||','||
(select groupid from groups where groupname = 'NEURO_FLD')||','||
(select groupid from groups where groupname = 'NEURO_HQ')||','  ||
(select groupid from groups where groupname = 'SAXA_JV')||',', 2
from option_lookup 
where option_id = (select id from option_names where name = 'Product')
and parent = (select id from option_lookup where option_id = (select id from option_names where name = 'Therapeutic Area') 
and optvalue = 'Oncology');

update feature_usergroup_map set usergroup_id = usergroup_id||
(select groupid from groups where groupname = 'NEURO_FLD')||','||
(select groupid from groups where groupname = 'ONC_FLD')||','
where usergroup_id like '%,'||(select groupid from groups where groupname = 'CVMMET_FLD')||',%'
and feature_id in (select id from option_lookup where 
option_id = (select id from option_names where name = 'Interaction Topic') )
and usergroup_id not like '%,'||(select groupid from groups where groupname = 'NEURO_FLD')||',%'
and usergroup_id not like '%,'||(select groupid from groups where groupname = 'ONC_FLD')||',%';

update feature_usergroup_map set usergroup_id = usergroup_id||
(select groupid from groups where groupname = 'HQ')||','||
(select groupid from groups where groupname = 'NEURO_HQ')||','||
(select groupid from groups where groupname = 'ONC_HQ')||','
where usergroup_id like '%,'||(select groupid from groups where groupname = 'CVMET_HQ')||',%'
and feature_id in (select id from option_lookup where 
option_id = (select id from option_names where name = 'Interaction Topic') )
and usergroup_id not like '%,'||(select groupid from groups where groupname = 'HQ')||',%'
and usergroup_id not like '%,'||(select groupid from groups where groupname = 'NEURO_HQ')||',%'
and usergroup_id not like '%,'||(select groupid from groups where groupname = 'ONC_HQ')||',%';

rem : TA permissions

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
id ,
','||(select groupid from groups where groupname = 'ONC_FLD')||','||
(select groupid from groups where groupname = 'ONC_HQ')||','||
(select groupid from groups where groupname = 'NEURO_FLD')||','||
(select groupid from groups where groupname = 'NEURO_HQ')||',', 2
from option_lookup 
where option_id = (select id from option_names where name = 'Therapeutic Area')
and optvalue = 'CVMET';

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
id ,
','||(select groupid from groups where groupname = 'SAXA_JV')||','||
(select groupid from groups where groupname = 'CVMET_HQ')||','||
(select groupid from groups where groupname = 'CVMMET_FLD')||','||
(select groupid from groups where groupname = 'NEURO_FLD')||','||
(select groupid from groups where groupname = 'NEURO_HQ')||',', 2
from option_lookup 
where option_id = (select id from option_names where name = 'Therapeutic Area')
and optvalue = 'Oncology';

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
id ,
','||(select groupid from groups where groupname = 'ONC_FLD')||','||
(select groupid from groups where groupname = 'ONC_HQ')||','||
(select groupid from groups where groupname = 'CVMMET_FLD')||','||
(select groupid from groups where groupname = 'CVMET_HQ')||','  ||
(select groupid from groups where groupname = 'SAXA_JV')||',', 2
from option_lookup 
where option_id = (select id from option_names where name = 'Therapeutic Area')
and optvalue = 'Neuro';

rem : survey permission

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
id ,
','||(select groupid from groups where groupname = 'ONC_FLD')||','||
(select groupid from groups where groupname = 'ONC_HQ')||',', 2
from SURVEYMETADATA where NAME in (
'NSCLC- MSL- Deep Customer Insights',
'Customer Insights Program');

rem : ------------------------------------------------------------------------------------------------

commit;

rem user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

SPOOL OFF
SET ECHO OFF
exit;
rem ------------------------------------------------------------------------------------------------
