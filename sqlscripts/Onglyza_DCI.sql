SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : Onglyza_DCI_Survey.log
SPOOL Onglyza_DCI_Survey.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------

update SURVEYMETADATA set name = 'Onglyza DCI'||( select to_char(sysdate, 'MM/DD/YYYY') from dual ), DATE_END = ( select to_char(sysdate, 'MM/DD/YYYY') from dual ) where name = 'Onglyza DCI';

delete from FEATURE_USERGROUP_MAP where FEATURE_ID in ( select id from SURVEYMETADATA where name = 'Onglyza DCI'||( select to_char(sysdate, 'MM/DD/YYYY') from dual ) ) and PERMISSION_ON_FEATURE = 3;

rem -------------------------------------------------------------------------------------------------

Insert into "SURVEYMETADATA" ("ID","NAME","TYPE","STATE","ACTIVE","DATE_START","DATE_END") 
values (HIBERNATE_SEQUENCE.NEXTVAL,'Onglyza DCI','DCI','Launched','true', ( select to_char(sysdate, 'MM/DD/YYYY') from dual ), ( select to_char(sysdate + numtoyminterval(1, 'YEAR'), 'MM/DD/YYYY') from dual ));

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Managed Market',1);
insert into answer_options_temp values	('Thought Leader',2);
insert into answer_options_temp values	('Speaker',3);
insert into answer_options_temp values	('Allied HCP',4);


execute CREATE_SURVEY_QA(' Type of Interaction:','multioptsinglesel','Onglyza DCI','true','1');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' What are the new questions brought up during this interaction?','simpleText','Onglyza DCI','false','2');

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Package Insert Deck',1);
insert into answer_options_temp values	('Core Medical Deck',2);
insert into answer_options_temp values	('Abbreviated Core Medical Deck',3);
insert into answer_options_temp values	('FAQ Deck',4);
insert into answer_options_temp values	('013 Reprint',5);
insert into answer_options_temp values	('039 Reprint',6);
insert into answer_options_temp values	('LRC Articles',7);
insert into answer_options_temp values	('Other',8);

execute CREATE_SURVEY_QA(' What resources were used during this interaction?','multioptmultisel','Onglyza DCI','false','3');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' If other resource, please specify: ','simpleText','Onglyza DCI','false','4'); 

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' What other resources would be useful for objection handling?','simpleText','Onglyza DCI','false','5'); 

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Access/Formulary Restrictions/Insurance Issues',1);
insert into answer_options_temp values	('Cost',2);
insert into answer_options_temp values	('Prefers Januvia, other medication',3);
insert into answer_options_temp values	('Lack of knowledge about Onglyza/DPP-4i',4);
insert into answer_options_temp values	('Does not see appropriate patient',5);
insert into answer_options_temp values	('Other (please specify):',6);


execute CREATE_SURVEY_QA(' (If TL/Speaker is not using Onglyza) What is the barrier in using Onglyza/DPP-4i class?','multioptmultisel','Onglyza DCI','false','6');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','Onglyza DCI','false','7'); 

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other miscellaneous insights (formulary, Victoza, 002, Avandia, pancreatitis):','simpleText','Onglyza DCI','false','8');

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('CV Safety',1);
insert into answer_options_temp values	('Lymphocytes',2);
insert into answer_options_temp values	('URTI/UTI',3);
insert into answer_options_temp values	('Skin/Rash',4);
insert into answer_options_temp values	('Dosing',5);
insert into answer_options_temp values	('Renal Insufficiency',6);
insert into answer_options_temp values	('Selectivity',7);
insert into answer_options_temp values	('Pancreatitis',8);
insert into answer_options_temp values	('Comparison to Januvia',9);
insert into answer_options_temp values	('Victoza',10);
insert into answer_options_temp values	('Byetta',11);

execute CREATE_SURVEY_QA(' Topics Brought Up During Interaction: (multiple check boxes)','multioptmultisel','Onglyza DCI','false','9');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------


rem : group permission

insert into FEATURE_USERGROUP_MAP (ID, FEATURE_ID, USERGROUP_ID, PERMISSION_ON_FEATURE) 
values (HIBERNATE_SEQUENCE.NEXTVAL, (select id from SURVEYMETADATA where name = 'Onglyza DCI'),
','||( select groupid from groups where groupname = 'FRONT_END_ADMIN')||',', 3);

rem --------------------------------------------------------------------------------------------------

commit;

rem --------------------------------------------------------------------------------------------------

rem user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

SPOOL OFF

SET ECHO OFF

exit;


rem : 1>Author name 		: Neha Gupta 
rem : 2>Purpose         	: Script to create the new "Onglyza DCI Survey"
rem : 3>Date of creation	: 15-Mar-2010

rem ------------------------------------------------------------------------------------------------
