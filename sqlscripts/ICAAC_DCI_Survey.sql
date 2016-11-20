SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : ICAAC_DCI_Survey.log
SPOOL ICAAC_DCI_Survey.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------

update SURVEYMETADATA set name = 'ICAAC DCI Ended_'||( select to_char(sysdate, 'MM/DD/YYYY') from dual ), DATE_END = ( select to_char(sysdate, 'MM/DD/YYYY') from dual ) where name = 'ICAAC DCI';

delete from FEATURE_USERGROUP_MAP where FEATURE_ID in ( select id from SURVEYMETADATA where name = 'ICAAC DCI Ended_'||( select to_char(sysdate, 'MM/DD/YYYY') from dual ) ) and PERMISSION_ON_FEATURE = 3;

update SURVEYMETADATA set name = 'Updated Sustiva DCI' where name = 'Sustiva DCI Ended 9/29/09';

rem -------------------------------------------------------------------------------------------------

Insert into "SURVEYMETADATA" ("ID","NAME","TYPE","STATE","ACTIVE","DATE_START","DATE_END") 
values (HIBERNATE_SEQUENCE.NEXTVAL,'ICAAC DCI','DCI','Launched','true', ( select to_char(sysdate, 'MM/DD/YYYY') from dual ), ( select to_char(sysdate + numtoyminterval(1, 'YEAR'), 'MM/DD/YYYY') from dual ));

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values  ('ID Specialist (Academic Center)',1);
insert into answer_options_temp values  ('ID Specialist (Private Practice)',2);
insert into answer_options_temp values  ('Internal Medicine (Academic Center)',3);
insert into answer_options_temp values  ('Internal Medicine (Private Practice)',4);

execute CREATE_SURVEY_QA(' General Information','multioptsinglesel','ICAAC DCI','false','1');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);

execute CREATE_SURVEY_QA(' Would you consider using maravioc in naïve patients?','multioptsinglesel','ICAAC DCI','false','2');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Dosing frequency - prefer to use a QD regimen',1);
insert into answer_options_temp values	('Drug interactions - Multiple drug interactions with MVC make it challenging to use in naïve patients',2);
insert into answer_options_temp values	('Cost and Inconvenience - cost associated with Trofile assay limits MVC use in naïve patients',3);
insert into answer_options_temp values	('Lack of long-term data in naïve patients',4);
insert into answer_options_temp values	('Good clinical experiences with other ARVs',5);
insert into answer_options_temp values	('Other',6);

execute CREATE_SURVEY_QA(' If you answered NO to question #2, what are some reasons why you would not use maraviroc in naïve patients?','multioptmultisel','ICAAC DCI','false','3');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','ICAAC DCI','false','4'); 

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Efficacy - Based on immune and virologic responses',1);
insert into answer_options_temp values	('Resistance - I am concerned about transmission of de novo resistance with K103N',2);
insert into answer_options_temp values	('Adverse Events - Particularly CNS profile',3);
insert into answer_options_temp values	('Adverse Events - Particularly metabolic profile',4);
insert into answer_options_temp values	('Tolerability',5);
insert into answer_options_temp values	('Other',6);

execute CREATE_SURVEY_QA(' If you answered YES to question #2, what are some factors might impact your use of maraviroc in naïve patients?','multioptmultisel','ICAAC DCI','false','5');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','ICAAC DCI','false','6'); 

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('PI + 2 nucs',1);
insert into answer_options_temp values	('PI, no nucs',2);
insert into answer_options_temp values	('NNRTI + 2 nucs',3);
insert into answer_options_temp values	('NNRTI, no nucs',4);
insert into answer_options_temp values	('With 2 nucs',5);
insert into answer_options_temp values	('Based on results of genotype',6);
insert into answer_options_temp values	('Other',7);

execute CREATE_SURVEY_QA(' What antiretroviral agents are you likely to pair with maraviroc?','multioptmultisel','ICAAC DCI','false','7');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','ICAAC DCI','false','8'); 

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);

execute CREATE_SURVEY_QA(' Are you likely to use raltegravir in naïve patients?','multioptsinglesel','ICAAC DCI','false','9');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Efficacy - Based on immune and virologic responses',1);
insert into answer_options_temp values	('Viral dynamics - Fast decline in viral load',2);
insert into answer_options_temp values	('Resistance - I am concerned about transmission of de novo resistance with K103N',3);
insert into answer_options_temp values	('Adverse events - Particularly CNS profile',4);
insert into answer_options_temp values	('Adverse events - Particularly metabolic profile',5);
insert into answer_options_temp values	('Substance Abuse - it can be used in patients on methadone without making a dose adjustment',6);
insert into answer_options_temp values	('Special Populations - it can be used it in women of child-bearing age',7);
insert into answer_options_temp values	('Other',8);

execute CREATE_SURVEY_QA(' What are some factors that might impact your use of raltegravir in naïve patients?','multioptmultisel','ICAAC DCI','false','10');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','ICAAC DCI','false','11'); 

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('PI + 2 nucs',1);
insert into answer_options_temp values	('PI, no nucs',2);
insert into answer_options_temp values	('NNRTI + 2 nucs',3);
insert into answer_options_temp values	('NNRTI, no nucs',4);
insert into answer_options_temp values	('With 2 nucs',5);
insert into answer_options_temp values	('Based on results of genotype',6);
insert into answer_options_temp values	('Other',7);

execute CREATE_SURVEY_QA(' What antiretroviral agents are you likely to pair with raltegravir?','multioptmultisel','ICAAC DCI','false','12');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','ICAAC DCI','false','13');

rem --------------------------------------------------------------------------------------------------

rem : group permission

insert into FEATURE_USERGROUP_MAP (ID, FEATURE_ID, USERGROUP_ID, PERMISSION_ON_FEATURE) 
values (HIBERNATE_SEQUENCE.NEXTVAL, (select id from SURVEYMETADATA where name = 'ICAAC DCI'),
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
rem : 2>Purpose         	: "Script to create the new ICAAC DCI Survey"
rem : 3>Date of creation	: 01-Oct-2009

rem ------------------------------------------------------------------------------------------------
