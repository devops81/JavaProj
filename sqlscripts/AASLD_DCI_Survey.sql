SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : AASLD_DCI_Survey.log
SPOOL AASLD_DCI_Survey.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------

update SURVEYMETADATA set name = 'AASLD DCI Ended_'||( select to_char(sysdate, 'MM/DD/YYYY') from dual ), DATE_END = ( select to_char(sysdate, 'MM/DD/YYYY') from dual ) where name = 'AASLD DCI';

delete from FEATURE_USERGROUP_MAP where FEATURE_ID in ( select id from SURVEYMETADATA where name = 'AASLD DCI Ended_'||( select to_char(sysdate, 'MM/DD/YYYY') from dual ) ) and PERMISSION_ON_FEATURE = 3;

rem -------------------------------------------------------------------------------------------------

Insert into "SURVEYMETADATA" ("ID","NAME","TYPE","STATE","ACTIVE","DATE_START","DATE_END") 
values (HIBERNATE_SEQUENCE.NEXTVAL,'AASLD DCI','DCI','Launched','true', ( select to_char(sysdate, 'MM/DD/YYYY') from dual ), ( select to_char(sysdate + numtoyminterval(1, 'YEAR'), 'MM/DD/YYYY') from dual ));

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values  ('Tier 1 - national thought leader',1);
insert into answer_options_temp values  ('Tier 2 - regional thought leader',2);
insert into answer_options_temp values  ('Tier 3 - local thought leader',3);
insert into answer_options_temp values  ('Tier 4 - mid-level provider (NP/PA-C/Pharm.D.)',4);

execute CREATE_SURVEY_QA(' Please indicate the tier of the HCP that provided the DCI:','multioptsinglesel','AASLD DCI','false','1');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values  ('Non- Asian',1);
insert into answer_options_temp values  ('East Asian (Chinese, Korean, Japanese)',2);
insert into answer_options_temp values  ('Southeast Asian (Vietnamese, Cambodian, Thai, Filipino, Indonesian, Malaysian)',3);
insert into answer_options_temp values  ('South Asian (India, Pakistan)',4);

execute CREATE_SURVEY_QA(' Please indicate ethnic background of the HCP:','multioptsinglesel','AASLD DCI','false','2');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Northeast',1);
insert into answer_options_temp values	('Central',2);
insert into answer_options_temp values	('West',3);

execute CREATE_SURVEY_QA(' Please indicate what region you represent:','multioptsinglesel','AASLD DCI','false','3');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values  ('Extremely important',1);
insert into answer_options_temp values  ('Very important',2);
insert into answer_options_temp values  ('Important',3);
insert into answer_options_temp values  ('Not Important',4);
insert into answer_options_temp values  ('Did not ask',5);
insert into answer_options_temp values  ('Did not respond',6);

execute CREATE_SURVEY_QA(' How important is it to have data on patients with decompensated cirrhosis?','multioptsinglesel','AASLD DCI','false','4');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('No impact',1);
insert into answer_options_temp values	('May influence first line choice',2);
insert into answer_options_temp values	('Definitely influence first line choice',3);
insert into answer_options_temp values	('Data was not relevant since it compared to adefovir',4);
insert into answer_options_temp values	('Tenofovir''s decompensated data is more impactful',5);
insert into answer_options_temp values	('No opinion/ no response',6);
insert into answer_options_temp values  ('Did not see the data',7);
insert into answer_options_temp values  ('Did not ask',8);

execute CREATE_SURVEY_QA(' In your opinion, what is the impact, if any, of the Entecavir data on decompensated cirrhosis when choosing a drug for treatment of CHB?','multioptsinglesel','AASLD DCI','false','5');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values  ('No opinion/ no response',1);
insert into answer_options_temp values  ('Did not see the data',2);
insert into answer_options_temp values  ('Did not ask',3);
insert into answer_options_temp values  ('Combination therapy TDF/FTC should be used for decompensated cirrhosis over monotherapy',4);
insert into answer_options_temp values  ('TDF or ETV monotherapy is as good as TDF/FTC combination',5);
insert into answer_options_temp values  ('ETV and TDF have similar efficacy',6);

execute CREATE_SURVEY_QA(' What are your impressions of TDF vs. TDF/FTC vs. ETV decompensated cirrhosis data?','multioptsinglesel','AASLD DCI','false','6');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('5% in 2 years',1);
insert into answer_options_temp values	('11% in 3 years',2);
insert into answer_options_temp values	('15% in 5 years',3);
insert into answer_options_temp values	('No response',4);
insert into answer_options_temp values	('Did not ask',5);
insert into answer_options_temp values	('Other',6);

execute CREATE_SURVEY_QA(' In your opinion, at what percent would HBsAg loss/seroconversion be a deciding factor in choosing a drug for treatment of CHB?','multioptsinglesel','AASLD DCI','false','7');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','AASLD DCI','false','8'); 

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values  ('Entecavir''s HBsAg loss/seroconversion is similar to Tenofovir''s data at 2 years',1);
insert into answer_options_temp values  ('Enteacvir''s HBsAg loss/seroconversion genotype data applies more to my patient population due to HBsAg loss in genotype B and C',2);
insert into answer_options_temp values  ('Genotype data does not matter',3);
insert into answer_options_temp values  ('Tenofovir''s HBsAg loss/seroconversion data at year 3 is meaningful to my practice',4);
insert into answer_options_temp values  ('No response',5);
insert into answer_options_temp values  ('Did not ask',6);

execute CREATE_SURVEY_QA(' What is your opinion on Entecavir''s HBsAg loss/seroconversion genotype data?','multioptsinglesel','AASLD DCI','false','9');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values  ('Tenofovir is similar to Entecavir in efficacy and safety',1);
insert into answer_options_temp values  ('I have concerns with Tenofovir''s safety',2);
insert into answer_options_temp values  ('Entecavir has longer term efficacy and safety data',3);
insert into answer_options_temp values  ('I did not see the data',4);
insert into answer_options_temp values  ('I need to see more long term data on tenofovir',5);
insert into answer_options_temp values  ('Did not ask',6);


execute CREATE_SURVEY_QA(' What are your impressions of TDF 3 year efficacy and safety data?','multioptsinglesel','AASLD DCI','false','10');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Tenofovir data is similar to Entecavir at 3 years',1);
insert into answer_options_temp values	('Tenofovir really does not have 3 year data since they intensified at 72 weeks with tenofovir/emtricitabine',2);
insert into answer_options_temp values	('Entecavir has longer term resistance data',3);
insert into answer_options_temp values	('I did not see the data',4);
insert into answer_options_temp values	('I need to see more long term resistance data on tenofovir',5);
insert into answer_options_temp values	('Did not ask',6);

execute CREATE_SURVEY_QA(' What are your impressions of Tenofovir''s 3 year resistance data?','multioptsinglesel','AASLD DCI','false','11');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

rem : group permission

insert into FEATURE_USERGROUP_MAP (ID, FEATURE_ID, USERGROUP_ID, PERMISSION_ON_FEATURE) 
values (HIBERNATE_SEQUENCE.NEXTVAL, (select id from SURVEYMETADATA where name = 'AASLD DCI'),
','||( select groupid from groups where groupname = 'FRONT_END_ADMIN')||',', 3);

rem --------------------------------------------------------------------------------------------------

commit;

rem --------------------------------------------------------------------------------------------------

rem user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

SPOOL OFF

SET ECHO OFF

exit;


rem : 1>Author name 		: Deepak
rem : 2>Purpose         	: "Script to create the new AASLD DCI Survey"
rem : 3>Date of creation	: 13-Oct-2009

rem ------------------------------------------------------------------------------------------------
