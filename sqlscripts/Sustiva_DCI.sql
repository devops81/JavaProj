SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : Sustiva_DCI.log
SPOOL Sustiva_DCI.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------

update SURVEYMETADATA set name = 'Sustiva DCI Ended_'||( select to_char(sysdate, 'MM/DD/YYYY') from dual ), DATE_END = ( select to_char(sysdate, 'MM/DD/YYYY') from dual ) where name = 'Sustiva DCI';

delete from FEATURE_USERGROUP_MAP where FEATURE_ID in ( select id from SURVEYMETADATA where name = 'Sustiva DCI Ended_'||( select to_char(sysdate, 'MM/DD/YYYY') from dual ) ) and PERMISSION_ON_FEATURE = 3;

rem -------------------------------------------------------------------------------------------------

Insert into "SURVEYMETADATA" ("ID","NAME","TYPE","STATE","ACTIVE","DATE_START","DATE_END") values (HIBERNATE_SEQUENCE.NEXTVAL,'Sustiva DCI','DCI','Launched','true', ( select to_char(sysdate, 'MM/DD/YYYY') from dual ), ( select to_char(sysdate + numtoyminterval(1, 'YEAR'), 'MM/DD/YYYY') from dual ));

rem --------------------------------------

insert into answer_options_temp values	('< 200 CD4 cells',1);
insert into answer_options_temp values	('< 350 CD4 cells',2);
insert into answer_options_temp values  ('< 500 CD4 cells',3);
insert into answer_options_temp values  ('> 500 CD4 cells',4);

execute CREATE_SURVEY_QA(' Assuming that a patient is ready to start therapy, what is your CD4 cell threshold for initiating antiretroviral treatment in a naïve patient?','multioptsinglesel','Sustiva DCI','true','1');

delete from answer_options_temp;

rem --------------------------------------------

insert into answer_options_temp values	('Efficacy - Based on immune and virologic responses',1);
insert into answer_options_temp values	('Viral dynamics - Fast decline in viral load',2);
insert into answer_options_temp values	('Resistance Profile (I am concerned about transmission of de novo resistance with K103N)',3);
insert into answer_options_temp values  ('Adverse event profile, specifically it has a low rate of CNS',4);
insert into answer_options_temp values  ('Adverse event profile, specifically it has a limited effect on metabolic profile',5);
insert into answer_options_temp values  ('Substance Abuse - it can be used in patients on methadone without making a dose adjustment',6);
insert into answer_options_temp values  ('Special Populations -  it can be used it in women of child-bearing age',7);

execute CREATE_SURVEY_QA(' What are some factors that might impact your use of raltegravir in naïve patients?','multioptsinglesel','Sustiva DCI','true','2');

delete from answer_options_temp;

rem --------------------------------------------

insert into answer_options_temp values	('PI + 2 nucs',1);
insert into answer_options_temp values	('PI, no nucs',2);
insert into answer_options_temp values	('NNRTI + 2 nucs',3);
insert into answer_options_temp values	('NNRTI, no nucs',4);
insert into answer_options_temp values  ('With 2 nucs',5);
insert into answer_options_temp values  ('Other',6);

execute CREATE_SURVEY_QA(' What antiretroviral agents are you pairing with raltegravir?','multioptsinglesel','Sustiva DCI','true','3');

delete from answer_options_temp;

rem ------------------------------------------

insert into answer_options_temp values	('Patients with poor adherence',1);
insert into answer_options_temp values	('Patients with GI symptoms impacting their QOL',2);
insert into answer_options_temp values	('Patients requesting a switch to a QD regimen',3);
insert into answer_options_temp values  ('Patients with lipoatrophy',4);

execute CREATE_SURVEY_QA(' What types of patients would you consider switching to an EFV or Atripla-based regimen?','multioptsinglesel','Sustiva DCI','true','4');

delete from answer_options_temp;

rem --------------------------------------------

insert into answer_options_temp values	('patients over 50 yrs. old',1);
insert into answer_options_temp values	('patients co-infected with either HIV/HBV and/or HCV',2);
insert into answer_options_temp values	('African-American, Hispanic men and women',3);
insert into answer_options_temp values	('women of child-bearing age',4);
insert into answer_options_temp values	('patients at risk for CV disease',5);
insert into answer_options_temp values	('other',6);

execute CREATE_SURVEY_QA(' Are there efficacy and safety data in specific patient types that would be helpful to you when considering starting or switching a patient to Sustiva/Atripla:','multioptsinglesel','Sustiva DCI','true','5');

delete from answer_options_temp;

rem --------------------------------------------

insert into answer_options_temp values  ('ARV CSF penetration is clinically significant, as it correlates with long term cognitive function',1);
insert into answer_options_temp values  ('ARV CSF penetration is not clinically significant, as these data do not correlate with long term cognitive function',2);
insert into answer_options_temp values  ('Not practical to do spinal taps to measure CSF',3);
insert into answer_options_temp values  ('None of the above',4);

execute CREATE_SURVEY_QA(' Are the data on CSF penetration of ARVs a clinically significant factor in choosing an ARV regimen?','multioptsinglesel','Sustiva DCI','true','6');

delete from answer_options_temp;

rem --------------------------------------------

insert into answer_options_temp values  ('Yes - with NNRTIs',1);
insert into answer_options_temp values  ('Yes - with PIs',2);
insert into answer_options_temp values  ('Yes - with integrase inhibitors',3);
insert into answer_options_temp values  ('Yes - with CCR5 antagonists',4);
insert into answer_options_temp values  ('Yes - with NRTIs',5);
insert into answer_options_temp values  ('I don''t see any differences',6);
insert into answer_options_temp values  ('I don''t monitor Vit. D levels routinely',7);

execute CREATE_SURVEY_QA(' If you monitor Vit. D levels of patients on antiretroviral treatment, do you see deficiencies with any particular classes of drugs?','multioptsinglesel','Sustiva DCI','true','7');

delete from answer_options_temp;

rem --------------------------------------------

insert into answer_options_temp values  ('Etravirine',1);
insert into answer_options_temp values  ('Boosted PI',2);
insert into answer_options_temp values  ('Raltegravir',3);
insert into answer_options_temp values  ('Maraviroc',4);

execute CREATE_SURVEY_QA(' What drug(s) do you anticipate using in your next regimen after a patient has failed EFV with a K103N mutation?  Please check all that apply.','multioptmultisel','Sustiva DCI','true','8');

delete from answer_options_temp;

rem --------------------------------------------

rem : group permission

insert into FEATURE_USERGROUP_MAP (ID, FEATURE_ID, USERGROUP_ID, PERMISSION_ON_FEATURE) 
values (HIBERNATE_SEQUENCE.NEXTVAL, (select id from SURVEYMETADATA where name = 'Sustiva DCI'),
','||( select groupid from groups where groupname = 'FRONT_END_ADMIN')||','||
( select groupid from groups where groupname = 'HQ')||','||
( select groupid from groups where groupname = 'VIROLOGY_FLD')||','||
( select groupid from groups where groupname = 'VIROLOGY_HQ')||',', 3);

----------------------------------------------------------------------------------

commit;

rem user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

SPOOL OFF

SET ECHO OFF

exit;

rem : 1>Author name : Deepak
rem : 3>Date 		: 07/27/2009 

rem ------------------------------------------------------------------------------------------------


