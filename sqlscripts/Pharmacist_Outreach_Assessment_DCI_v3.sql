SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : Pharmacist_Outreach_Assessment_DCI_v3.log
SPOOL Pharmacist_Outreach_Assessment_DCI_v3.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------

update SURVEYMETADATA set name = 'Pharmacist Outreach DCI Ended_'||( select to_char(sysdate, 'MM/DD/YYYY') from dual ), DATE_END = ( select to_char(sysdate, 'MM/DD/YYYY') from dual ) where name = 'Pharmacist Outreach DCI';

delete from FEATURE_USERGROUP_MAP where FEATURE_ID in ( select id from SURVEYMETADATA where name = 'Pharmacist Outreach DCI Ended_'||( select to_char(sysdate, 'MM/DD/YYYY') from dual ) ) and PERMISSION_ON_FEATURE = 3;

rem -------------------------------------------------------------------------------------------------

Insert into "SURVEYMETADATA" ("ID","NAME","TYPE","STATE","ACTIVE","DATE_START","DATE_END") values (HIBERNATE_SEQUENCE.NEXTVAL,'Pharmacist Outreach DCI','DCI','Launched','true', ( select to_char(sysdate, 'MM/DD/YYYY') from dual ), ( select to_char(sysdate + numtoyminterval(1, 'YEAR'), 'MM/DD/YYYY') from dual ));

rem --------------------------------------

insert into answer_options_temp values  ('Pre-meeting Assessment',1);
insert into answer_options_temp values  ('Post-meeting Assessment',2);

execute CREATE_SURVEY_QA(' Time of assessment:','multioptsinglesel','Pharmacist Outreach DCI','false','1');

delete from answer_options_temp;

rem --------------------------------------------

insert into answer_options_temp values  ('Unaware',1);
insert into answer_options_temp values  ('Basic knowledge of incidence and cost',2);
insert into answer_options_temp values  ('Knowledgeable of incidence, direct/indirect costs, consequences of inadequate treatment',3);

execute CREATE_SURVEY_QA(' Assessment of knowledge on the burden of illness with MDD:','multioptsinglesel','Pharmacist Outreach DCI','false','2');

delete from answer_options_temp;

rem --------------------------------------------

insert into answer_options_temp values  ('Unaware',1);
insert into answer_options_temp values  ('Misunderstanding of indication (i.e., monotherapy, first-line)',2);
insert into answer_options_temp values  ('Misunderstanding of indication (i.e., treatment resistant/refractory)',3);
insert into answer_options_temp values  ('Appropriate knowledge of indication',4);

execute CREATE_SURVEY_QA(' Assessment of knowledge on the indication of Abilify in MDD:','multioptsinglesel','Pharmacist Outreach DCI','false','3');

delete from answer_options_temp;

rem --------------------------------------------

insert into answer_options_temp values  ('Unaware',1);
insert into answer_options_temp values  ('Partial knowledge of efficacy data (MADRS)',2);
insert into answer_options_temp values  ('Knowledgeable of efficacy data (MADRS and SDS)',3);

execute CREATE_SURVEY_QA(' Assessment of knowledge on the efficacy data with Abilify in MDD:','multioptsinglesel','Pharmacist Outreach DCI','false','4');

delete from answer_options_temp;

rem ------------------------------------------

insert into answer_options_temp values  ('Unaware',1);
insert into answer_options_temp values  ('Partial knowledge regarding patient population in Abilify MDD trials (diagnosis OR history of ADT partial response/non-response)',2);
insert into answer_options_temp values  ('Knowledgeable regarding patient population in Abilify MDD trials (diagnosis AND history of ADT partial response/non-response)',3);

execute CREATE_SURVEY_QA(' Assessment of knowledge on the patient population in Abilify MDD trials:','multioptsinglesel','Pharmacist Outreach DCI','false','5');

delete from answer_options_temp;

rem ------------------------------------------

insert into answer_options_temp values  ('Unaware',1);
insert into answer_options_temp values  ('Partial knowledge of safety/tolerability profile (most common AEs OR discontinuation due to AEs OR management of AEs OR metabolic profile)',2);
insert into answer_options_temp values  ('Knowledgeable of safety/tolerability profile (most common AEs AND discontinuation due to AEs AND management of AEs AND metabolic profile)',3);

execute CREATE_SURVEY_QA(' Assessment of knowledge on the safety/tolerability of Abilify in MDD:','multioptsinglesel','Pharmacist Outreach DCI','false','6');

delete from answer_options_temp;

rem --------------------------------------------

insert into answer_options_temp values  ('Efficacy',1);
insert into answer_options_temp values  ('Patient population',2);
insert into answer_options_temp values  ('Safety/tolerability',3);
insert into answer_options_temp values  ('Dosing',4);
insert into answer_options_temp values  ('Other',5);
insert into answer_options_temp values  ('Not applicable',6);

execute CREATE_SURVEY_QA(' Pharmacist had misunderstanding of Abilify data in the following area(s): (select all that apply)','multioptmultisel','Pharmacist Outreach DCI','false','7');

delete from answer_options_temp;

rem --------------------------------------------

execute CREATE_SURVEY_QA(' Other areas pharmacists had misunderstood Ability data:','simpleText','Pharmacist Outreach DCI','false','8');

rem --------------------------------------------

rem : group permission

insert into FEATURE_USERGROUP_MAP (ID, FEATURE_ID, USERGROUP_ID, PERMISSION_ON_FEATURE) 
values (HIBERNATE_SEQUENCE.NEXTVAL, (select id from SURVEYMETADATA where name = 'Pharmacist Outreach DCI'),
','||( select groupid from groups where groupname = 'FRONT_END_ADMIN')||',', 3);


rem -- update FEATURE_USERGROUP_MAP set USERGROUP_ID = USERGROUP_ID || 
rem -- ( select groupid from groups where groupname = 'NEURO_FLD')||','||
rem -- ( select groupid from groups where groupname = 'NEURO_HQ')||','
rem -- where FEATURE_ID = (select id from SURVEYMETADATA where name = 'Pharmacist Outreach DCI')
rem -- and PERMISSION_ON_FEATURE = 3;

----------------------------------------------------------------------------------

commit;

rem user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

SPOOL OFF

SET ECHO OFF

exit;

rem : 1>Author name : Deepak
rem : 3>Date 		: 08/03/2009 

rem ------------------------------------------------------------------------------------------------


