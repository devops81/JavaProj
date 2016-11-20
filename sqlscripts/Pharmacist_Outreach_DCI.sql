SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : db_changes_BMS_Pharmacist_Outreach_DCI_Survey.log
SPOOL db_changes_BMS_Pharmacist_Outreach_DCI_Survey.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------



Insert into "SURVEYMETADATA" ("ID","NAME","TYPE","STATE","ACTIVE","DATE_START","DATE_END") 
values (HIBERNATE_SEQUENCE.NEXTVAL,'Pharmacist Outreach DCI','DCI','Launched','true','07/03/2009','07/03/2010');

commit;

rem --------------------------------------

insert into answer_options_temp values	('Pre-meeting Assessment',1);
insert into answer_options_temp values	('Post-meeting Assessment',2);


commit;


execute CREATE_SURVEY_QA(' Time of assessment:','multioptsinglesel','Pharmacist Outreach DCI','true','1');

commit;

delete from answer_options_temp;

commit;

rem --------------------------------------------


insert into answer_options_temp values	('Unaware',1);
insert into answer_options_temp values	('Basic knowledge of incidence and cost',2);
insert into answer_options_temp values	('Knowledgeable of incidence, direct/indirect costs, consequences of inadequate treatment',3);


commit;

execute CREATE_SURVEY_QA(' Assessment of knowledge regarding burden of illness with MDD:','multioptsinglesel','Pharmacist Outreach DCI','true','2');

commit;

delete from answer_options_temp;

commit;

rem --------------------------------------------

insert into answer_options_temp values	('Unaware',1);
insert into answer_options_temp values	('Misunderstanding of indication (i.e., monotherapy, first-line)',2);
insert into answer_options_temp values	('Misunderstanding of indication (i.e., treatment-resistant/refractory)',3);
insert into answer_options_temp values	('Appropriate knowledge of indication',4);

commit;


execute CREATE_SURVEY_QA(' Assessment of knowledge regarding indication of Abilify in MDD','multioptsinglesel','Pharmacist Outreach DCI','true','3');

commit;

delete from answer_options_temp;

commit;

rem --------------------------------------------


insert into answer_options_temp values	('Unaware',1);
insert into answer_options_temp values	('Partial knowledge regarding patient population in Abilify MDD trials (diagnosis OR history of ADT partial response/non-response)',2);
insert into answer_options_temp values	('Knowledgeable regarding patient population in Abilify MDD trials (diagnosis AND history of ADT partial response/non-response)',3);

commit;

execute CREATE_SURVEY_QA(' Assessment of knowledge regarding efficacy data with Abilify in MDD:','multioptsinglesel','Pharmacist Outreach DCI','true','4');

commit;

delete from answer_options_temp;

commit;

rem ------------------------------------------


insert into answer_options_temp values	('Unaware',1);
insert into answer_options_temp values	('Partial knowledge of safety/tolerability profile (most common AEs OR discontinuation due to AEs OR management of AEs OR metabolic profile)',2);
insert into answer_options_temp values	('Knowledgeable of safety/tolerability profile (most common AEs AND discontinuation due to AEs AND management of AEs AND metabolic profile)',3);

commit;


execute CREATE_SURVEY_QA(' Assessment of knowledge regarding patient population in Abilify MDD trials:','multioptsinglesel','Pharmacist Outreach DCI','true','5');

commit;

delete from answer_options_temp;

commit;

rem --------------------------------------------


insert into answer_options_temp values	('Efficacy',1);
insert into answer_options_temp values	('Patient population',2);
insert into answer_options_temp values	('Safety/tolerability',3);
insert into answer_options_temp values	('Dosing',4);
insert into answer_options_temp values	('Other',5);
insert into answer_options_temp values	('Not applicable',6);

commit;


execute CREATE_SURVEY_QA(' Pharmacist had misunderstanding of Abilify data in the following area(s): (select all that apply)','multioptmultisel','Pharmacist Outreach DCI','true','6');

commit;

delete from answer_options_temp;

commit;

rem --------------------------------------------



execute CREATE_SURVEY_QA(' Other areas pharmacist had misunderstood Abilify data','simpleText','Pharmacist Outreach DCI','false','7');

commit;

rem --------------------------------------------


rem user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;



SPOOL OFF



SET ECHO OFF




exit;



rem : 1>Author name 		: Yatin
rem : 2>Purpose of change	: 
rem : 3>Date of change 		: 

rem ------------------------------------------------------------------------------------------------


