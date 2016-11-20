rem ------------------------------------------------------------------------------------------------
rem Filename:   New_TA_Tabs.sql
rem Purpose	:   To add new tabs in profile based on TA
rem Date	:	04-Feb-2009
rem Author	:   Deepak
rem ------------------------------------------------------------------------------------------------

SET TIME ON
SET ESCAPE \
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : New_TA_Tabs.log
SPOOL New_TA_Tabs.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------

insert into option_lookup values (hibernate_sequence.nextval, 44, 'Neuro', 'N', 85248368, 0, 10000);
insert into option_lookup values (hibernate_sequence.nextval, 44, 'Oncology', 'N', 85248368, 0, 10000);

insert into option_lookup values (hibernate_sequence.nextval, 34, 'HQ', 'N', -1, 0, 10000);

update groups set FUNCTIONALAREA = (select id from option_lookup where optvalue = 'HQ' and option_id = 34) where groupname = 'CVMET_HQ';

insert into groups values (hibernate_sequence.nextval, 'HQ', 'HQ', 'User', 1, -1,
(select id from option_lookup where optvalue = 'HQ' and option_id = 34), 6503);

insert into groups values (hibernate_sequence.nextval, 'ONC_FLD', 'ONC_FLD', 'User', 1, 
(select id from option_lookup where optvalue = 'Oncology' and option_id = 44), 
(select id from option_lookup where optvalue = 'FLD' and option_id = 34),
6503);

insert into groups values (hibernate_sequence.nextval, 'ONC_HQ', 'ONC_HQ', 'User', 1, 
(select id from option_lookup where optvalue = 'Oncology'  and option_id = 44), 
(select id from option_lookup where optvalue = 'HQ' and option_id = 34), 
6503);

insert into groups values (hibernate_sequence.nextval, 'NEURO_FLD', 'NEURO_FLD', 'User', 1, 
(select id from option_lookup where optvalue = 'Neuro'  and option_id = 44), 
(select id from option_lookup where optvalue = 'FLD'  and option_id = 34), 6503);

insert into groups values (hibernate_sequence.nextval, 'NEURO_HQ', 'NEURO_HQ', 'User', 1, 
(select id from option_lookup where optvalue = 'Neuro'  and option_id = 44), 
(select id from option_lookup where optvalue = 'HQ' and option_id = 34),
6503);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='CVMET Attributes'),
'CVMET Speaker','CVMET Speaker',5,null,0,1,null,null,0,83396610,1,null,null,null,0);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='CVMET Attributes'),
'CVMET Investigator','CVMET Investigator',5,null,0,1,null,null,0,83396610,1,null,null,null,0);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='CVMET Attributes'),
'CVMET Advisor','CVMET Advisor',5,null,0,1,null,null,0,83396610,1,null,null,null,0);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='CVMET Attributes'),
'CVMET Author','CVMET Author',5,null,0,1,null,null,0,83396610,1,null,null,null,0);

insert into expertdna_privileges
select
hibernate_sequence.nextval, 
groupid,
2,'Expert.BMS_Info.CVMET_Attributes', 'N', 'N', 'N', 'N' 
from groups where groupname not in ( 'CVMET_FLD', 'CVMET_HQ', 'Saxa_JV');

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
attribute_id ,
','||(select groupid from groups where groupname = 'ONC_FLD')||','||
(select groupid from groups where groupname = 'ONC_HQ')||','||
(select groupid from groups where groupname = 'NEURO_FLD')||','||
(select groupid from groups where groupname = 'NEURO_HQ')||',' , 4
from attributetable 
where parent_id = (select entity_type_id from entitytypes where name = 'CVMET Attributes');

insert into option_names values ( hibernate_sequence.nextval, 'CVMET Tags', -1);

insert into entitytypes values (hibernate_sequence.nextval, 'CVMET Tags', 'CVMET Tags', null, 2);

insert into attributetable values (hibernate_sequence.nextval,83005800, 'CVMET Tags', 'CVMET Tags',
(select entity_type_id from entitytypes where name = 'CVMET Tags'), null, 0, 1, null, null, 1, -1, 1, null, null, null, 1);

insert into attributetable values (hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name = 'CVMET Tags'), 'CVMET Tags', 'CVMET Tags', 5, null, 0, 1, null, null, 0, 
(select id from option_names where name='CVMET Tags'), 1, null, null,null,0);

insert into expertdna_privileges
select
hibernate_sequence.nextval, 
groupid,
2,'Expert.BMS_Info.CVMET_Tags', 'N', 'N', 'N', 'N' 
from groups where groupname not in ( 'CVMET_FLD', 'CVMET_HQ', 'Saxa_JV');

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
attribute_id ,
','||(select groupid from groups where groupname = 'ONC_FLD')||','||
(select groupid from groups where groupname = 'ONC_HQ')||','||
(select groupid from groups where groupname = 'NEURO_FLD')||','||
(select groupid from groups where groupname = 'NEURO_HQ')||',' , 4
from attributetable 
where parent_id = (select entity_type_id from entitytypes where name = 'CVMET Tags');

rem : ------------------------------------------------------------------------------------------------
rem : Neuro 

delete from entities_attribute where attribute_id = (select attribute_id from attributetable where name = 'Neuro Profile');
delete from attributetable where parent_id = (select entity_type_id from entitytypes where name = 'Neuro Profile');
delete from attributetable where name = 'Neuro Profile';

delete from entities_attribute where myentity_id in (select
entity_id from entities where type = (select entity_type_id from entitytypes where name = 'Neuro Profile'));

delete from entities where type = (select entity_type_id from entitytypes where name = 'Neuro Profile');
delete from entitytypes where name = 'Neuro Profile';

insert into entitytypes values (hibernate_sequence.nextval, 'Neuro Attributes', 'Neuro Attributes', null, 2);

insert into attributetable values (hibernate_sequence.nextval, 83005800, 'Neuro Attributes', 'Neuro Attributes',
(select entity_type_id from entitytypes where name = 'Neuro Attributes'), null, 0, 0, 'Small', null, 0, -1, 1, null, null, null,0);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Neuro Attributes'),
'Neuro Sphere of Influence','Neuro Sphere of Influence', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 0);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Neuro Attributes'),
'Neuro Schizophrenia Tier','Neuro Schizophrenia Tier', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 10);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Neuro Attributes'),
'Neuro Bipolar Tier','Neuro Bipolar Tier', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 3);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Neuro Attributes'),
'Neuro MDD Tier','Neuro MDD Tier', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 5);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Neuro Attributes'),
'Neuro Pediatric Schizophrenia Tier','Neuro Pediatric Schizophrenia Tier', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 7);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Neuro Attributes'),
'Neuro Pediatric BiPolar Tier','Neuro Pediatric BiPolar Tier', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 9);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Neuro Attributes'),
'Neuro Physical Health Tier','Neuro Physical Health Tier', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 8);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Neuro Attributes'),
'Neuro Autism Tier','Neuro Autism Tier', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 2);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Neuro Attributes'),
'Neuro GAD Tier','Neuro GAD Tier', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 4);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Neuro Attributes'),
'Neuro Alzheimers Tier','Neuro Alzheimers Tier', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 1);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Neuro Attributes'),
'Neuro Neuropathic Pain Tier','Neuro Neuropathic Pain Tier', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 6);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Neuro Attributes'),
'Neuro Speaker','Neuro Speaker', 5, null, 0, 1, null, null, 0, 83396610, 1, null, null, null, 14);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Neuro Attributes'),
'Neuro Investigator','Neuro Investigator', 5, null, 0, 1, null, null, 0, 83396610, 1, null, null, null, 13);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Neuro Attributes'),
'Neuro Advisor','Neuro Advisor', 5, null, 0, 1, null, null, 0, 83396610, 1, null, null, null, 11);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Neuro Attributes'),
'Neuro Author','Neuro Author', 5, null, 0, 1, null, null, 0, 83396610, 1, null, null, null, 12);

insert into expertdna_privileges
select
hibernate_sequence.nextval, 
groupid,
2,'Expert.BMS_Info.Neuro_Attributes', 'N', 'N', 'N', 'N' 
from groups where groupname not in ( 'NEURO_FLD', 'NEURO_HQ');

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
attribute_id ,
','||(select groupid from groups where groupname = 'ONC_FLD')||','||
(select groupid from groups where groupname = 'ONC_HQ')||','||
(select groupid from groups where groupname = 'SAXA_JV')||','||
(select groupid from groups where groupname = 'CVMET_FLD')||','||
(select groupid from groups where groupname = 'CVMET_HQ')||',' , 4
from attributetable 
where parent_id = (select entity_type_id from entitytypes where name = 'Neuro Attributes');

insert into option_names values ( hibernate_sequence.nextval, 'Neuro Tags', -1);

insert into option_lookup values ( hibernate_sequence.nextval, 
(select id from option_names where name = 'Neuro Tags'), 'Abilify OL', 'N', -1, 0, 10000);

insert into option_lookup values ( hibernate_sequence.nextval, 
(select id from option_names where name = 'Neuro Tags'), 'Abilify MPA', 'N', -1, 0, 10000);

insert into option_lookup values ( hibernate_sequence.nextval, 
(select id from option_names where name = 'Neuro Tags'), 'EMSAM OL', 'N', -1, 0, 10000);

insert into option_lookup values ( hibernate_sequence.nextval, 
(select id from option_names where name = 'Neuro Tags'), 'EMSAM MPA', 'N', -1, 0, 10000);

insert into option_lookup values ( hibernate_sequence.nextval, 
(select id from option_names where name = 'Neuro Tags'), 'Abilify Speaker', 'N', -1, 0, 10000);

insert into option_lookup values ( hibernate_sequence.nextval, 
(select id from option_names where name = 'Neuro Tags'), 'EMSAM Speaker', 'N', -1, 0, 10000);

insert into option_lookup values ( hibernate_sequence.nextval, 
(select id from option_names where name = 'Neuro Tags'), 'Abilify Pillars \& Platforms Shizophrenia', 'N', -1, 0, 10000);

insert into option_lookup values ( hibernate_sequence.nextval, 
(select id from option_names where name = 'Neuro Tags'), 'Abilify Pillars \& Platforms Bipolar', 'N', -1, 0, 10000);

insert into option_lookup values ( hibernate_sequence.nextval, 
(select id from option_names where name = 'Neuro Tags'), 'Abilify Pillars \& Platforms MDD', 'N', -1, 0, 10000);

insert into option_lookup values ( hibernate_sequence.nextval, 
(select id from option_names where name = 'Neuro Tags'), 'Abilify Pillars \& Platforms Apex', 'N', -1, 0, 10000);

insert into option_lookup values ( hibernate_sequence.nextval, 
(select id from option_names where name = 'Neuro Tags'), 'Abilify Pillars \& Platforms Physical Health Metabolic', 'N', -1, 0, 10000);

insert into option_lookup values ( hibernate_sequence.nextval, 
(select id from option_names where name = 'Neuro Tags'), 'Abilify Pillars \& Platforms Physical Health Endocrine', 'N', -1, 0, 10000);

insert into option_lookup values ( hibernate_sequence.nextval, 
(select id from option_names where name = 'Neuro Tags'), 'Abilify Pillars \& Platforms', 'N', -1, 0, 10000);

insert into option_lookup values ( hibernate_sequence.nextval, 
(select id from option_names where name = 'Neuro Tags'), 'Emerging Indications GAD', 'N', -1, 0, 10000);

insert into option_lookup values ( hibernate_sequence.nextval, 
(select id from option_names where name = 'Neuro Tags'), 'Emerging Indications Autism', 'N', -1, 0, 10000);

insert into option_lookup values ( hibernate_sequence.nextval, 
(select id from option_names where name = 'Neuro Tags'), 'Emerging Indications GAD', 'N', -1, 0, 10000);

insert into option_lookup values ( hibernate_sequence.nextval, 
(select id from option_names where name = 'Neuro Tags'), 'BMS Sponsored Trials', 'N', -1, 0, 10000);

insert into option_lookup values ( hibernate_sequence.nextval, 
(select id from option_names where name = 'Neuro Tags'), 'Non BMS ARI Trials', 'N', -1, 0, 10000);

insert into option_lookup values ( hibernate_sequence.nextval, 
(select id from option_names where name = 'Neuro Tags'), 'IST', 'N', -1, 0, 10000);

insert into option_lookup values ( hibernate_sequence.nextval, 
(select id from option_names where name = 'Neuro Tags'), 'Abstracts/Posters', 'N', -1, 0, 10000);

insert into option_lookup values ( hibernate_sequence.nextval, 
(select id from option_names where name = 'Neuro Tags'), 'Manuscripts', 'N', -1, 0, 10000);

insert into option_lookup values ( hibernate_sequence.nextval, 
(select id from option_names where name = 'Neuro Tags'), 'Ad Boards', 'N', -1, 0, 10000);

insert into option_lookup values ( hibernate_sequence.nextval, 
(select id from option_names where name = 'Neuro Tags'), 'MAOI High Knowledge', 'N', -1, 0, 10000);

insert into option_lookup values ( hibernate_sequence.nextval, 
(select id from option_names where name = 'Neuro Tags'), 'MAOI Medium Knowledge', 'N', -1, 0, 10000);

insert into option_lookup values ( hibernate_sequence.nextval, 
(select id from option_names where name = 'Neuro Tags'), 'MAOI Low Knowledge', 'N', -1, 0, 10000);

insert into option_lookup values ( hibernate_sequence.nextval, 
(select id from option_names where name = 'Neuro Tags'), 'Treatment Resistant Expert in Depression', 'N', -1, 0, 10000);

insert into entitytypes values (hibernate_sequence.nextval, 'Neuro Tags', 'Neuro Tags', null, 2);

insert into attributetable values (hibernate_sequence.nextval,83005800, 'Neuro Tags', 'Neuro Tags',
(select entity_type_id from entitytypes where name = 'Neuro Tags'), null, 0, 1, null, null, 1, -1, 1, null, null, null,0);

insert into attributetable values (hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name = 'Neuro Tags'), 'Neuro Tags', 'Neuro Tags', 5, null, 0, 1, null, null, 0, 
(select id from option_names where name='Neuro Tags'), 1, null, null,null, 4);

insert into expertdna_privileges
select
hibernate_sequence.nextval, 
groupid,
2,'Expert.BMS_Info.Neuro_Tags', 'N', 'N', 'N', 'N' 
from groups where groupname not in ('NEURO_FLD', 'NEURO_HQ');

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
attribute_id ,
','||(select groupid from groups where groupname = 'ONC_FLD')||','||
(select groupid from groups where groupname = 'ONC_HQ')||','||
(select groupid from groups where groupname = 'SAXA_JV')||','||
(select groupid from groups where groupname = 'CVMET_FLD')||','||
(select groupid from groups where groupname = 'CVMET_HQ')||',' , 4
from attributetable 
where parent_id = (select entity_type_id from entitytypes where name = 'Neuro Tags');

rem : ------------------------------------------------------------------------------------------------
rem : Oncology

insert into entitytypes values (hibernate_sequence.nextval, 'Oncology Attributes', 'Oncology Attributes', null, 2);

insert into attributetable values (hibernate_sequence.nextval, 83005800, 'Oncology Attributes', 'Oncology Attributes',
(select entity_type_id from entitytypes where name = 'Oncology Attributes'),  null, 0, 0, 'Small', null, 0, -1, 1, null, null, null,7);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Oncology Attributes'),
'Oncology Sphere of Influence','Oncology Sphere of Influence', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 0);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Oncology Attributes'),
'Bladder Sphere of Influence','Bladder Sphere of Influence', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 1);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Oncology Attributes'),
'Breast Sphere of Influence','Breast Sphere of Influence', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 2);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Oncology Attributes'),
'Cervical Sphere of Influence','Cervical Sphere of Influence', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 3);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Oncology Attributes'),
'CLL Sphere of Influence','CLL Sphere of Influence', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 4);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Oncology Attributes'),
'CML Sphere of Influence','CML Sphere of Influence', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 5);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Oncology Attributes'),
'Colorectal Sphere of Influence','Colorectal Sphere of Influence', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 6);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Oncology Attributes'),
'Endometrial Sphere of Influence','Endometrial Sphere of Influence', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 7);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Oncology Attributes'),
'Esophageal Sphere of Influence','Esophageal Sphere of Influence', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 8);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Oncology Attributes'),
'Glioblastoma Sphere of Influence','Glioblastoma Sphere of Influence', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 9);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Oncology Attributes'),
'Head and Neck Sphere of Influence','Head and Neck Sphere of Influence', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 10);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Oncology Attributes'),
'Hepaocellular Sphere of Influence','Hepaocellular Sphere of Influence', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 11);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Oncology Attributes'),
'Lymphoma Sphere of Influence','Lymphoma Sphere of Influence', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 12);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Oncology Attributes'),
'Melanoma Sphere of Influence','Melanoma Sphere of Influence', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 13);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Oncology Attributes'),
'Multiple Myeloma Sphere of Influence','Multiple Myeloma Sphere of Influence', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 14);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Oncology Attributes'),
'NSCLC Sphere of Influence','NSCLC Sphere of Influence', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 15);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Oncology Attributes'),
'Ovarian Sphere of Influence','Ovarian Sphere of Influence', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 16);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Oncology Attributes'),
'Pancreatic Sphere of Influence','Pancreatic Sphere of Influence', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 17);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Oncology Attributes'),
'Ph+ALL Sphere of Influence','Ph+ALL Sphere of Influence', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 18);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Oncology Attributes'),
'Prostate Sphere of Influence','Prostate Sphere of Influence', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 19);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Oncology Attributes'),
'Renal Sphere of Influence','Renal Sphere of Influence', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 20);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Oncology Attributes'),
'SCLC Sphere of Influence','SCLC Sphere of Influence', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 21);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Oncology Attributes'),
'Testicular Sphere of Influence','Testicular Sphere of Influence', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 22);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Oncology Attributes'),
'Thyroid Sphere of Influence','Thyroid Sphere of Influence', 5, null, 0, 1, null, null, 0, 83005842, 1, null, null, null, 23);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Oncology Attributes'),
'Oncology Speaker','Oncology Speaker', 5, null, 0, 1, null, null, 0, 83396610, 1, null, null, null, 27);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Oncology Attributes'),
'Oncology Investigator','Oncology Investigator', 5, null, 0, 1, null, null, 0, 83396610, 1, null, null, null, 26);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Oncology Attributes'),
'Oncology Advisor','Oncology Advisor', 5, null, 0, 1, null, null, 0, 83396610, 1, null, null, null, 24);

insert into attributetable values(
hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name ='Oncology Attributes'),
'Oncology Author','Oncology Author', 5, null, 0, 1, null, null, 0, 83396610, 1, null, null, null, 25);

insert into expertdna_privileges
select
hibernate_sequence.nextval, 
groupid,
2,'Expert.BMS_Info.Oncology_Attributes', 'N', 'N', 'N', 'N' 
from groups where groupname not in ( 'ONC_FLD', 'ONC_HQ');

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
attribute_id ,
','||(select groupid from groups where groupname = 'NEURO_FLD')||','||
(select groupid from groups where groupname = 'NEURO_HQ')||','||
(select groupid from groups where groupname = 'SAXA_JV')||','||
(select groupid from groups where groupname = 'CVMET_FLD')||','||
(select groupid from groups where groupname = 'CVMET_HQ')||',' , 4
from attributetable 
where parent_id = (select entity_type_id from entitytypes where name = 'Oncology Attributes');

insert into option_names values ( hibernate_sequence.nextval, 'Oncology Tags', -1);

insert into entitytypes values (hibernate_sequence.nextval, 'Oncology Tags', 'Oncology Tags', null, 2);

insert into attributetable values (hibernate_sequence.nextval,83005800, 'Oncology Tags', 'Oncology Tags',
(select entity_type_id from entitytypes where name = 'Oncology Tags'), null, 0, 1, null, null, 1, -1, 1, null, null, null,8);

insert into attributetable values (hibernate_sequence.nextval,
(select entity_type_id from entitytypes where name = 'Oncology Tags'), 'Oncology Tags', 'Oncology Tagsv', 5, null, 0, 1, null, null, 0, 
(select id from option_names where name='Oncology Tags'), 1, null, null,null,0);

insert into expertdna_privileges
select
hibernate_sequence.nextval, 
groupid,
2,'Expert.BMS_Info.Oncology_Tags', 'N', 'N', 'N', 'N' 
from groups where groupname not in ('ONC_FLD', 'ONC_HQ');

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
attribute_id ,
','||(select groupid from groups where groupname = 'NEURO_FLD')||','||
(select groupid from groups where groupname = 'NEURO_HQ')||','||
(select groupid from groups where groupname = 'SAXA_JV')||','||
(select groupid from groups where groupname = 'CVMET_FLD')||','||
(select groupid from groups where groupname = 'CVMET_HQ')||',' , 4
from attributetable 
where parent_id = (select entity_type_id from entitytypes where name = 'Oncology Tags');

rem : re-arranging neuro sub tabs

update attributetable set display_order = 0 where name = 'CVMET Attributes';
update attributetable set display_order = 2 where name = 'Medical Inquiries';
update attributetable set display_order = 5 where name = 'OL Colleagues';
update attributetable set display_order = 6 where name = 'OL Selection Criteria';
update attributetable set display_order = 7 where name = 'Surveys';

rem : ------------------------------------------------------------------------------------------------

commit;

rem user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

SPOOL OFF
SET ECHO OFF
exit;
rem ------------------------------------------------------------------------------------------------