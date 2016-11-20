SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : Orencia_DCI_Survey.log
SPOOL Orencia_DCI_Survey.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------

update SURVEYMETADATA set name = 'Orencia DCI Ended_'||( select to_char(sysdate, 'MM/DD/YYYY') from dual ), DATE_END = ( select to_char(sysdate, 'MM/DD/YYYY') from dual ) where name = 'Orencia DCI';

delete from FEATURE_USERGROUP_MAP where FEATURE_ID in ( select id from SURVEYMETADATA where name = 'Orencia DCI Ended_'||( select to_char(sysdate, 'MM/DD/YYYY') from dual ) ) and PERMISSION_ON_FEATURE = 3;

rem -------------------------------------------------------------------------------------------------

Insert into "SURVEYMETADATA" ("ID","NAME","TYPE","STATE","ACTIVE","DATE_START","DATE_END") 
values (HIBERNATE_SEQUENCE.NEXTVAL,'Orencia DCI','DCI','Launched','true', ( select to_char(sysdate, 'MM/DD/YYYY') from dual ), ( select to_char(sysdate + numtoyminterval(1, 'YEAR'), 'MM/DD/YYYY') from dual ));

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('National',1);
insert into answer_options_temp values	('Regional',2);
insert into answer_options_temp values	('Local',3);

execute CREATE_SURVEY_QA(' Tier','multioptsinglesel','Orencia DCI','false','1');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Radiographic arrest',1);
insert into answer_options_temp values	('Normal physical function',2);
insert into answer_options_temp values	('Clinical (DAS) remission',3);
insert into answer_options_temp values	('All of the above or a composite',4);
insert into answer_options_temp values	('Question not asked',5);

execute CREATE_SURVEY_QA(' Early RA - What is the treatment goal in early disease?','multioptsinglesel','Orencia DCI','false','2');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Off biologic',1);
insert into answer_options_temp values	('Off all drugs',2);
insert into answer_options_temp values	('Delay in disease progression',3);
insert into answer_options_temp values	('Return to normal function',4);
insert into answer_options_temp values	('Question not asked',5);

execute CREATE_SURVEY_QA(' Early RA - What does ''''alter the course'''' of disease mean?','multioptsinglesel','Orencia DCI','false','3');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Convenience for Physician',1);
insert into answer_options_temp values	('Enable earlier use',2);
insert into answer_options_temp values	('Patient Preference',3);
insert into answer_options_temp values	('Question not asked',4);

execute CREATE_SURVEY_QA(' SubQ - What do you see as a benefit for a biologic that can be administered via IV or subQ injection?','multioptsinglesel','Orencia DCI','false','4');

delete from answer_options_temp;

rem ------------------------------------------

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);
insert into answer_options_temp values	('Question not asked',3);

execute CREATE_SURVEY_QA(' SubQ - Would you use the formulation (IV or SC) inter-changeably in your practice?','multioptsinglesel','Orencia DCI','false','5');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);
insert into answer_options_temp values	('Question not asked',3);

execute CREATE_SURVEY_QA(' SubQ - Assuming equal efficacy and safety profile, would you foresee switching formulations in a particular patient?','multioptsinglesel','Orencia DCI','false','6');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('IV to SC',1);
insert into answer_options_temp values	('SC to IV',2);
insert into answer_options_temp values	('Question not asked',3);
insert into answer_options_temp values	('Other (Comments)',4);

execute CREATE_SURVEY_QA(' SubQ - If yes to previous question, which direction would you envision yourself changing?','multioptsinglesel','Orencia DCI','false','7');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other comments','simpleText','Orencia DCI','false','8'); 

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Reducing signs and symptoms',1);
insert into answer_options_temp values	('Inhibition of structural damage',2);
insert into answer_options_temp values	('Patient Outcomes',3);
insert into answer_options_temp values	('Safety',4);
insert into answer_options_temp values	('Other (Comments)',5);
insert into answer_options_temp values	('Question not asked',6);

execute CREATE_SURVEY_QA(' What is the key driver in your decision to choose Orencia?','multioptsinglesel','Orencia DCI','false','9');

delete from answer_options_temp;

rem --------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other key driver in your decision to choose Orencia','simpleText','Orencia DCI','false','10'); 

rem --------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Patient reports',1);
insert into answer_options_temp values	('DAS28',2);
insert into answer_options_temp values	('RAPID',3);
insert into answer_options_temp values	('Gestalt',4);
insert into answer_options_temp values	('ACR',5);
insert into answer_options_temp values	('Measures of structural damage',6);
insert into answer_options_temp values	('Other',7);
insert into answer_options_temp values	('Question not asked',8);

execute CREATE_SURVEY_QA(' How do you measure success when treating a patient with a biologic with Rheumatoid Arthritis?','multioptsinglesel','Orencia DCI','false','11');

delete from answer_options_temp;

rem --------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other ways of measuring success when treating a patient with a biologic with Rheumatoid Arthritis','simpleText','Orencia DCI','false','12'); 

rem -------------------------------------------------------------------------------------------------  

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);
insert into answer_options_temp values	('Question not asked',3);

execute CREATE_SURVEY_QA(' When you initiate dosing with Orencia, are you consistently giving 3 doses during the first month?','multioptsinglesel','Orencia DCI','false','13');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------  

insert into answer_options_temp values ('Don''t know dosing schedule',1);
insert into answer_options_temp values ('Dose like other infusibles',2);
insert into answer_options_temp values ('Not sure',3);
insert into answer_options_temp values ('Question not asked',4);

execute CREATE_SURVEY_QA(' If no to previous question, why?','multioptsinglesel','Orencia DCI','false','14');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);
insert into answer_options_temp values	('Question not asked',3);

execute CREATE_SURVEY_QA(' Do you measure structural damage using Radiographs?','multioptsinglesel','Orencia DCI','false','15');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------  

insert into answer_options_temp values ('6 months',1);
insert into answer_options_temp values ('1 year',2);
insert into answer_options_temp values ('Other (please specify)',3);
insert into answer_options_temp values ('Question not asked',4);

execute CREATE_SURVEY_QA(' If yes to previous question, what is the frequency?','multioptsinglesel','Orencia DCI','false','16');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other frequency','simpleText','Orencia DCI','false','17'); 

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);
insert into answer_options_temp values	('Question not asked',3);

execute CREATE_SURVEY_QA(' Do you measure structural damage using MRI?','multioptsinglesel','Orencia DCI','false','18');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------  

insert into answer_options_temp values ('6 months',1);
insert into answer_options_temp values ('1 year',2);
insert into answer_options_temp values ('Other (please specify)',3);
insert into answer_options_temp values ('Question not asked',4);

execute CREATE_SURVEY_QA(' If yes to previous question, what is the frequency?','multioptsinglesel','Orencia DCI','false','19');

delete from answer_options_temp;

rem ---------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other frequency','simpleText','Orencia DCI','false','20'); 

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);
insert into answer_options_temp values	('Question not asked',3);

execute CREATE_SURVEY_QA(' Do you measure structural damage using ultrasound?','multioptsinglesel','Orencia DCI','false','21');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------  

insert into answer_options_temp values ('6 months',1);
insert into answer_options_temp values ('1 year',2);
insert into answer_options_temp values ('Other (please specify)',3);
insert into answer_options_temp values ('Question not asked',4);

execute CREATE_SURVEY_QA(' If yes to previous question, what is the frequency?','multioptsinglesel','Orencia DCI','false','22');

delete from answer_options_temp;

rem ---------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other frequency','simpleText','Orencia DCI','false','23'); 

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('No knowledge',1);
insert into answer_options_temp values	('Good data, but limited',2);
insert into answer_options_temp values	('Strong efficacy profile',3);
insert into answer_options_temp values	('Not as good as TNF inhibitor',4);
insert into answer_options_temp values	('Need more data (Comments)',5);
insert into answer_options_temp values	('Question not asked',6);

execute CREATE_SURVEY_QA(' What is your knowledge of Orencia''s ability to inhibit progression over the long term with respect to the prevention of structural damage?','multioptsinglesel','Orencia DCI','false','24');

delete from answer_options_temp;

rem ---------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other comments','simpleText','Orencia DCI','false','25'); 

rem --------------------------------------------------------------------------------------------------

rem : group permission

insert into FEATURE_USERGROUP_MAP (ID, FEATURE_ID, USERGROUP_ID, PERMISSION_ON_FEATURE) 
values (HIBERNATE_SEQUENCE.NEXTVAL, (select id from SURVEYMETADATA where name = 'Orencia DCI'),
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
rem : 2>Purpose         	: Script to create the new "Orencia Survey"
rem : 3>Date of creation	: 11-Sep-2009

rem ------------------------------------------------------------------------------------------------
