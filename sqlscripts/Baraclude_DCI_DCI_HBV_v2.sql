SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : Baraclude_DCI_DCI_HBV_v2.log
SPOOL Baraclude_DCI_DCI_HBV_v2.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------

update SURVEYMETADATA set name = 'DCI HBV Ended_'||( select to_char(sysdate, 'MM/DD/YYYY') from dual ), DATE_END = ( select to_char(sysdate, 'MM/DD/YYYY') from dual ) where name = 'DCI HBV';

delete from FEATURE_USERGROUP_MAP where FEATURE_ID in ( select id from SURVEYMETADATA where name = 'DCI HBV Ended_'||( select to_char(sysdate, 'MM/DD/YYYY') from dual ) ) and PERMISSION_ON_FEATURE = 3;

rem -------------------------------------------------------------------------------------------------

Insert into "SURVEYMETADATA" ("ID","NAME","TYPE","STATE","ACTIVE","DATE_START","DATE_END") values (HIBERNATE_SEQUENCE.NEXTVAL,'DCI HBV','DCI','Launched','true', ( select to_char(sysdate, 'MM/DD/YYYY') from dual ), ( select to_char(sysdate + numtoyminterval(1, 'YEAR'), 'MM/DD/YYYY') from dual ));

rem --------------------------------------

insert into answer_options_temp values  ('Tier 1 - national thought leader',1);
insert into answer_options_temp values  ('Tier 2 - regional thought leader',2);
insert into answer_options_temp values  ('Tier 3 - local thought leader',3);
insert into answer_options_temp values  ('Tier 4 - mid-level provider (NP/PA-C/Pharm.D.)',4);

execute CREATE_SURVEY_QA(' Please indicate the tier of the HCP that provided the DCI:','multioptsinglesel','DCI HBV','false','1');

delete from answer_options_temp;

rem --------------------------------------------

insert into answer_options_temp values  ('Non- Asian',1);
insert into answer_options_temp values  ('East Asian (Chinese, Korean, Japanese)',2);
insert into answer_options_temp values  ('Southeast Asian (Vietnamese, Cambodian, Thai, Filipino, Indonesian, Malaysian)',3);
insert into answer_options_temp values  ('South Asian (India, Pakistan)',4);

execute CREATE_SURVEY_QA(' Please indicate ethnic background of the HCP:','multioptsinglesel','DCI HBV','false','2');

delete from answer_options_temp;

rem --------------------------------------------

insert into answer_options_temp values  ('Northeast',1);
insert into answer_options_temp values  ('Central',2);
insert into answer_options_temp values  ('West',3);

execute CREATE_SURVEY_QA(' Please indicate what region you represent:','multioptsinglesel','DCI HBV','false','3');

delete from answer_options_temp;

rem --------------------------------------------

insert into answer_options_temp values  ('Sustained efficacy/potency',1);
insert into answer_options_temp values  ('Long-term resistance profile OR high genetic barrier',2);
insert into answer_options_temp values  ('Safety profile',3);
insert into answer_options_temp values  ('% sAg loss/seroconversion',4);
insert into answer_options_temp values  ('Cost/coverage',5);

execute CREATE_SURVEY_QA(' What is the most important attribute when choosing a drug to treat chronic hepatitis B?','multioptsinglesel','DCI HBV','false','4');

delete from answer_options_temp;

rem ------------------------------------------

insert into answer_options_temp values  ('Your own clinical experience',1);
insert into answer_options_temp values  ('Registrational trial data',2);
insert into answer_options_temp values  ('Historical data including use in other disease states/indication',3);
insert into answer_options_temp values  ('Post marketing package insert information',4);
insert into answer_options_temp values  ('Other',5);

execute CREATE_SURVEY_QA(' How do you define safety?','multioptsinglesel','DCI HBV','false','5');

delete from answer_options_temp;


rem --------------------------------------------

execute CREATE_SURVEY_QA(' Other ways you define safety:','simpleText','DCI HBV','false','6');

rem ------------------------------------------

insert into answer_options_temp values  ('Yes',1);
insert into answer_options_temp values  ('No',2);

execute CREATE_SURVEY_QA(' In your opinion, is HBsAg loss/seroconversion an appropriate endpoint for CHB therapy?','multioptsinglesel','DCI HBV','false','7');

delete from answer_options_temp;

rem --------------------------------------------

execute CREATE_SURVEY_QA(' Please give reason why for above answer','simpleText','DCI HBV','false','8');

rem --------------------------------------------

insert into answer_options_temp values  ('Race',1);
insert into answer_options_temp values  ('Genotype',2);
insert into answer_options_temp values  ('eAg status',3);
insert into answer_options_temp values  ('Viral load',4);
insert into answer_options_temp values  ('ALT and necroinflammation score',5);

execute CREATE_SURVEY_QA(' In your opinion, what is the most important factor contributing to HBsAg loss/seroconversion?','multioptsinglesel','DCI HBV','false','9');

delete from answer_options_temp;

rem --------------------------------------------

insert into answer_options_temp values  ('Extremely important',1);
insert into answer_options_temp values  ('Very important',2);
insert into answer_options_temp values  ('Important',3);
insert into answer_options_temp values  ('Not Important',4);

execute CREATE_SURVEY_QA(' In your opinion, how important are sAg titers in determining the effectiveness of a drug for treatment of CHB?','multioptsinglesel','DCI HBV','false','10');

delete from answer_options_temp;

rem --------------------------------------------

insert into answer_options_temp values  ('The number of mutations that the virus requires for resistance',1);
insert into answer_options_temp values  ('Viral Fitness - reduced replication of resistant variant relative to wild-type and the role it plays relative to emergence of resistance',2);
insert into answer_options_temp values  ('Pharmacologic Barrier – Using higher dose of a drug or more “potent” drugs to reduce emergence of resistance',3);
insert into answer_options_temp values  ('All of the above',4);
insert into answer_options_temp values  ('None of the above',5);

execute CREATE_SURVEY_QA(' How do you define genetic barrier as it relates to HBV resistance?','multioptsinglesel','DCI HBV','false','11');

delete from answer_options_temp;

rem --------------------------------------------

insert into answer_options_temp values  ('perform genotypic resistance testing',1);
insert into answer_options_temp values  ('monitor for viral load breakthrough (>1 log10 IU/mL increase from nadir)',2);
insert into answer_options_temp values  ('monitor for viral load (>1 log10 IU/mL increase from nadir) and biochemical breakthrough (ALT >2 x ULN)',3);
insert into answer_options_temp values  ('other',4);

execute CREATE_SURVEY_QA(' How do you monitor for antiviral resistance?','multioptsinglesel','DCI HBV','false','12');

delete from answer_options_temp;

rem --------------------------------------------

execute CREATE_SURVEY_QA(' Other ways you monitor for antiviral resistance:','simpleText','DCI HBV','false','13');

rem --------------------------------------------

insert into answer_options_temp values  ('Salvage regimen',1);
insert into answer_options_temp values  ('Naïve regimen',2);
insert into answer_options_temp values  ('No role in CHB',3);
insert into answer_options_temp values  ('For special populations (cirrhotics, transplants, etc.)',4);

execute CREATE_SURVEY_QA(' In your opinion, what role should combination therapy play in treating CHB patients?','multioptsinglesel','DCI HBV','false','14');

delete from answer_options_temp;

rem --------------------------------------------

rem : group permission

insert into FEATURE_USERGROUP_MAP (ID, FEATURE_ID, USERGROUP_ID, PERMISSION_ON_FEATURE) 
values (HIBERNATE_SEQUENCE.NEXTVAL, (select id from SURVEYMETADATA where name = 'DCI HBV'),
','||( select groupid from groups where groupname = 'FRONT_END_ADMIN')||',', 3);


rem -- update FEATURE_USERGROUP_MAP set USERGROUP_ID = USERGROUP_ID || 
rem -- ( select groupid from groups where groupname = 'NEURO_FLD')||','||
rem -- ( select groupid from groups where groupname = 'NEURO_HQ')||','
rem -- where FEATURE_ID = (select id from SURVEYMETADATA where name = 'DCI HBV')
rem -- and PERMISSION_ON_FEATURE = 3;

----------------------------------------------------------------------------------

commit;

rem user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

SPOOL OFF

SET ECHO OFF

exit;

rem : 1>Author name : Deepak
rem : 3>Date 		: 08/12/2009 

rem ------------------------------------------------------------------------------------------------


