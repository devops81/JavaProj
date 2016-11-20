SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : ACTG_5202.log
SPOOL ACTG_5202.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------

update SURVEYMETADATA set name = 'ACTG 5202_'||( select to_char(sysdate, 'MM/DD/YYYY') from dual ), DATE_END = ( select to_char(sysdate, 'MM/DD/YYYY') from dual ) where name = 'ACTG 5202';

delete from FEATURE_USERGROUP_MAP where FEATURE_ID in ( select id from SURVEYMETADATA where name = 'ACTG 5202_'||( select to_char(sysdate, 'MM/DD/YYYY') from dual ) ) and PERMISSION_ON_FEATURE = 3;

rem -------------------------------------------------------------------------------------------------

Insert into "SURVEYMETADATA" ("ID","NAME","TYPE","STATE","ACTIVE","DATE_START","DATE_END") 
values (HIBERNATE_SEQUENCE.NEXTVAL,'ACTG 5202','DCI','Launched','true', ( select to_char(sysdate, 'MM/DD/YYYY') from dual ), ( select to_char(sysdate + numtoyminterval(1, 'YEAR'), 'MM/DD/YYYY') from dual ));

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Reinforces my use of TDF/FTC first line',1);
insert into answer_options_temp values	('Will consider utilizing ABC/3TC in select patients',2);
insert into answer_options_temp values	('Concerned about using ABC/3TC first line, particularly in pts with high VLs',3);
insert into answer_options_temp values	('Concerned about using ABC/3TC first line, in any patients, regardless VL',4);
insert into answer_options_temp values	('Did not ask',5);

execute CREATE_SURVEY_QA(' How does 5202 impact your choice of ARVs in naïve pts?','multioptsinglesel','ACTG 5202','false','1');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Atripla is still my first choice (please ask #4)',1);
insert into answer_options_temp values	('ATV/r is still my first choice (please ask #6)',2);
insert into answer_options_temp values	('Will utilize ATV/r in patients for whom Atripla is not appropriate',3);
insert into answer_options_temp values	('Good to have the data, but I prefer to use other agents first line (DRV).  If so, why? (enter under Other)',4);
insert into answer_options_temp values	('Good to have the data, but I prefer to use other agents first line (RAL).  If so, why? (enter under Other)',5);
insert into answer_options_temp values	('Other',6);
insert into answer_options_temp values	('Did not ask',7);

execute CREATE_SURVEY_QA(' How does 5202 impact your decision to use either EFV or ATV/r in naïve patients?','multioptsinglesel','ACTG 5202','false','2');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','ACTG 5202','false','3');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('availability of long-term efficacy and safety data',1);
insert into answer_options_temp values	('transient nature of CNS side effects',2);
insert into answer_options_temp values	('pill burden',3);
insert into answer_options_temp values	('No PPI / H2B drug-interactions',4);
insert into answer_options_temp values	('No HBR / Jaundice',5);
insert into answer_options_temp values	('Other',6);
insert into answer_options_temp values	('Did not ask',7);

execute CREATE_SURVEY_QA(' When considering the results of ACTG 5202, what factors influence your choice of EFV over  ATV/r in naïve patients?','multioptmultisel','ACTG 5202','false','4');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','ACTG 5202','false','5');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Efficacy and safety data',1);
insert into answer_options_temp values	('Not impacted by NNRTI primary resistance mutations',2);
insert into answer_options_temp values	('Pregnancy category B',3);
insert into answer_options_temp values	('Genetic barrier difference between PIs and NNRTIs',4);
insert into answer_options_temp values	('Clinical relevance of HBR not a determining factor',5);
insert into answer_options_temp values	('Do not need to counsel patient around CNS side effects',6);
insert into answer_options_temp values	('Can be given with methadone',7);
insert into answer_options_temp values	('Impact on lipid profile ',8);
insert into answer_options_temp values	('Other',9);
insert into answer_options_temp values	('Did not ask',10);


execute CREATE_SURVEY_QA(' When considering the results of ACTG 5202, what factors influence your choice of ATV/r over  EFV in naïve patients?','multioptmultisel','ACTG 5202','false','6');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','ACTG 5202','false','7');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Tier 1 - National Thought Leader',1);
insert into answer_options_temp values	('Tier 2 - Regional Thought Leader',2);
insert into answer_options_temp values	('Tier 3 - Local Thought Leader',3);
insert into answer_options_temp values	('Tier 4 - NP/PA/Pharmacist',4);
insert into answer_options_temp values	('Did not ask',5);

execute CREATE_SURVEY_QA(' What is the Tier of the HCP who was asked the DCI?','multioptsinglesel','ACTG 5202','false','8');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('M.D.',1);
insert into answer_options_temp values	('D.O.',2);
insert into answer_options_temp values	('ARNP',3);
insert into answer_options_temp values	('PA-C',4);
insert into answer_options_temp values	('PharmD',5);
insert into answer_options_temp values	('Did not ask',6);


execute CREATE_SURVEY_QA(' What are the credentials of the HCP responding to the DCI questions?','multioptsinglesel','ACTG 5202','false','9');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

rem : group permission

insert into FEATURE_USERGROUP_MAP (ID, FEATURE_ID, USERGROUP_ID, PERMISSION_ON_FEATURE) 
values (HIBERNATE_SEQUENCE.NEXTVAL, (select id from SURVEYMETADATA where name = 'ACTG 5202'),
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
rem : 2>Purpose         	: Script to create the new "ACTG 5202"
rem : 3>Date of creation	: 22-Feb-2010

rem ------------------------------------------------------------------------------------------------

