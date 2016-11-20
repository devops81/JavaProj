SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file :Reyataz_DCI.log
SPOOL Reyataz_DCI.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------

update SURVEYMETADATA set name = 'Reyataz 2010_'||( select to_char(sysdate, 'MM/DD/YYYY') from dual ), DATE_END = ( select to_char(sysdate, 'MM/DD/YYYY') from dual ) where name = 'Reyataz 2010';

delete from FEATURE_USERGROUP_MAP where FEATURE_ID in ( select id from SURVEYMETADATA where name = 'Reyataz 2010_'||( select to_char(sysdate, 'MM/DD/YYYY') from dual ) ) and PERMISSION_ON_FEATURE = 3;

rem -------------------------------------------------------------------------------------------------

Insert into "SURVEYMETADATA" ("ID","NAME","TYPE","STATE","ACTIVE","DATE_START","DATE_END") 
values (HIBERNATE_SEQUENCE.NEXTVAL,'Reyataz 2010','DCI','Launched','true', ( select to_char(sysdate, 'MM/DD/YYYY') from dual ), ( select to_char(sysdate + numtoyminterval(1, 'YEAR'), 'MM/DD/YYYY') from dual ));

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('National',1);
insert into answer_options_temp values	('Regional A',2);
insert into answer_options_temp values	('Regional B',3);

execute CREATE_SURVEY_QA(' What is the TL Sphere of Influence?','multioptsinglesel','Reyataz 2010','false','1');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('yes',1);
insert into answer_options_temp values	('no',2);

execute CREATE_SURVEY_QA(' Does this TL give promotional presentations on BMS'' behalf?','multioptsinglesel','Reyataz 2010','false','2');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Any treatment-naïve pts',1);
insert into answer_options_temp values	('Treatment-naïve, who cannot tolerate EFV or for whom EFV is not a good option (female CBP)',2);
insert into answer_options_temp values	('I don''t utilize ATV/r in naïve patients',3);
insert into answer_options_temp values	('Other',4);

execute CREATE_SURVEY_QA(' What specific group of naive pts would you choose to use ATV/r vs other ARVs?','multioptsinglesel','Reyataz 2010','false','3');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','Reyataz 2010','false','4');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Due to risk of hyperbilirubinemia / jaundice it is easier to utilize other agents',1);
insert into answer_options_temp values	('Due to drug interaction with PPIs, it is easier to utilize other agents',2);
insert into answer_options_temp values	('Prefer to use RAL post-NNRTI failure due to it''s \"clean\" side effect profile',3);
insert into answer_options_temp values	('Prefer to use DRV/r after any failure as it is more potent and has a higher genetic barrier',4);
insert into answer_options_temp values	('Other',5);

execute CREATE_SURVEY_QA(' What is the primary reason you would not use ATV 2nd line, after a NNRTI, Integrase Inhibitor or PI failure (virologic failure or related side effects)? (Choose all that apply)','multioptmultisel','Reyataz 2010','false','5');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','Reyataz 2010','false','6');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Patients over 50 or adolescent patients ',1);
insert into answer_options_temp values	('Patients co-infected with either HIV/HBV and/or HCV ',2);
insert into answer_options_temp values	('Specific race / ethnicity ( w/ comment box)',3);
insert into answer_options_temp values	('Women including women of child bearing age ',4);
insert into answer_options_temp values	('Patients who have failed (with or without resistance) their 1st line of therapy ',5);
insert into answer_options_temp values	('Other',6);

execute CREATE_SURVEY_QA(' Are there efficacy and safety data in specific patient types that would be helpful to you when considering starting a patient on an Atazanavir-based regimen:','multioptsinglesel','Reyataz 2010','false','7');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','Reyataz 2010','false','8');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('They all rank about the same',1);
insert into answer_options_temp values	('EFV>ATV>DRV>RAL',2);
insert into answer_options_temp values	('EFV>ATV>RAL>DRV',3);
insert into answer_options_temp values	('EFV>ATV>DRV=RAL',4);
insert into answer_options_temp values	('EFV>ATV=DRV=RAL',5);
insert into answer_options_temp values	('EFV=ATV>DRV=RAL',6);
insert into answer_options_temp values	('Other',7);

execute CREATE_SURVEY_QA(' When considering the existing 3rd agents that are used most frequently, how would you rank them in regards to most long-term efficacy and safety data?:','multioptsinglesel','Reyataz 2010','false','9');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','Reyataz 2010','false','10');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Lipids (Tchol, LDL, HDL, Trig)',1);
insert into answer_options_temp values	('Biomarkers (D-dimer, IL6, CRP--see SMART analysis) ',2);
insert into answer_options_temp values	('Endpoints (MI, stroke, death)',3);
insert into answer_options_temp values	('All of the above',4);
insert into answer_options_temp values	('Other',5);

execute CREATE_SURVEY_QA(' When considering long-term metabolic studies, what data is most important?','multioptsinglesel','Reyataz 2010','false','11');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','Reyataz 2010','false','12');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Will not impact at this time, need more longer term data',1);
insert into answer_options_temp values	('Will start to impact when ATV is utilized-may result in ATV being used after 1st or 2nd  tx-failure',2);
insert into answer_options_temp values	('Is already impacting utilization-if not used in naives, it is unlikely to be used due to following sequencing pattern: EFV-RAL-DRV',3);
insert into answer_options_temp values	('Other',4);

execute CREATE_SURVEY_QA(' In your opinion, how will the data on newer  ARVs and novel treatment strategies, impact physician use of Atazanavir in clinical practice?','multioptsinglesel','Reyataz 2010','false','13');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','Reyataz 2010','false','14');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Probably still start with Atripla, if another FDC is created then would either sequence to or start with that',1);
insert into answer_options_temp values	('Nucleoside sparing, with ATV (without RTV) /RAL',2);
insert into answer_options_temp values	('Nucleoside sparing, with DRV (with RTV) /RAL',3);
insert into answer_options_temp values	('Nuceoloside sparing, PI+CCR5 inhibitor',4);
insert into answer_options_temp values	('Will not change from NNRTI or PI backbone with NRTIs, unless there is a large study showing superiority in regards to efficacy and/or safety/tolerability',5);
insert into answer_options_temp values	('I am already incorporating alternative dosing strategies',7);

execute CREATE_SURVEY_QA(' What novel treatment strategies would you consider incorporating into your practice in the future?','multioptsinglesel','Reyataz 2010','false','15');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','Reyataz 2010','false','16');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);
insert into answer_options_temp values	('Other',3);

execute CREATE_SURVEY_QA(' Are you experiencing or hearing about potential formulary restrictions / tiering of ATV?','multioptsinglesel','Reyataz 2010','false','17');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','Reyataz 2010','false','18');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('No impact, I already consider cost when prescribing ARVs',1);
insert into answer_options_temp values	('I may have to chose products that are less efficacious',2);
insert into answer_options_temp values	('I may have to chose products that are dosed less conveniently',3);
insert into answer_options_temp values	('I may have to chose products that are a less favorable side effect profile',4);
insert into answer_options_temp values	('Other',5);

execute CREATE_SURVEY_QA(' In your practice, what would be the clinical impact of formulary restrictions or tiering of ARVs? Choose all that apply:','multioptmultisel','Reyataz 2010','false','19');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','Reyataz 2010','false','20');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

rem : group permission

insert into FEATURE_USERGROUP_MAP (ID, FEATURE_ID, USERGROUP_ID, PERMISSION_ON_FEATURE) 
values (HIBERNATE_SEQUENCE.NEXTVAL, (select id from SURVEYMETADATA where name = 'Reyataz 2010'),
','||( select groupid from groups where groupname = 'FRONT_END_ADMIN')||',', 3);

rem --------------------------------------------------------------------------------------------------

commit;

rem --------------------------------------------------------------------------------------------------

rem user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

SPOOL OFF

SET ECHO OFF

exit;


rem : 1>Author name 		: Vinay Rao
rem : 2>Purpose         	: Script to create the new "Reyataz 2010"
rem : 3>Date of creation	: 03-Feb-2010

rem ------------------------------------------------------------------------------------------------


