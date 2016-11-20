SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : Sustiva_Atripla_DCI_Survey.log
SPOOL Sustiva_Atripla_DCI_Survey.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------

update SURVEYMETADATA set name = 'Sustiva/Atripla DCI Ended_'||( select to_char(sysdate, 'MM/DD/YYYY') from dual ), DATE_END = ( select to_char(sysdate, 'MM/DD/YYYY') from dual ) where name = 'Sustiva/Atripla DCI';

delete from FEATURE_USERGROUP_MAP where FEATURE_ID in ( select id from SURVEYMETADATA where name = 'Sustiva/Atripla DCI Ended_'||( select to_char(sysdate, 'MM/DD/YYYY') from dual ) ) and PERMISSION_ON_FEATURE = 3;

rem -------------------------------------------------------------------------------------------------

Insert into "SURVEYMETADATA" ("ID","NAME","TYPE","STATE","ACTIVE","DATE_START","DATE_END") 
values (HIBERNATE_SEQUENCE.NEXTVAL,'Sustiva/Atripla DCI','DCI','Launched','true', ( select to_char(sysdate, 'MM/DD/YYYY') from dual ), ( select to_char(sysdate + numtoyminterval(1, 'YEAR'), 'MM/DD/YYYY') from dual ));

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Patients over 50 yrs. old',1);
insert into answer_options_temp values	('Patients co-infected with either HIV/HBV and/or HCV',2);
insert into answer_options_temp values	('African-American, Hispanic men and women',3);
insert into answer_options_temp values	('Women of child-bearing age',4);
insert into answer_options_temp values	('Patients at risk for CV disease',5);


execute CREATE_SURVEY_QA(' Are there efficacy and safety data in specific patient types that would be helpful to you when considering starting or switching a patient to Sustiva/Atripla:','multioptmultisel','Sustiva/Atripla DCI','false','1');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Patients with poor adherence',1);
insert into answer_options_temp values	('Patients with GI symptoms impacting their QOL',2);
insert into answer_options_temp values	('Patients requesting a switch to a QD regimen',3);
insert into answer_options_temp values	('Patients with lipoatrophy',4);


execute CREATE_SURVEY_QA(' What types of patients would you consider switching to an EFV or Atripla-based regimen?','multioptmultisel','Sustiva/Atripla DCI','false','2');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);


execute CREATE_SURVEY_QA(' Are you likely to use raltegravir in naïve patients?','multioptsinglesel','Sustiva/Atripla DCI','false','3');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Dosing frequency - prefer to use a QD regimen',1);
insert into answer_options_temp values	('Concern with low genetic barrier of RAL',2);
insert into answer_options_temp values	('Lack of long-term data in naïve patients',3);
insert into answer_options_temp values	('Good clinical experiences with other ARVs',4);
insert into answer_options_temp values	('Prefer to reserve it for more highly experienced patients in salvage regimens',5);
insert into answer_options_temp values	('Other',6);


execute CREATE_SURVEY_QA(' If you answered NO to question #3, what are some reason(s) why you would not use raltegravir in naïve patients?','multioptmultisel','Sustiva/Atripla DCI','false','4');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','Sustiva/Atripla DCI','false','5'); 

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Efficacy - Based on immune and virologic responses',1);
insert into answer_options_temp values	('Viral dynamics - Fast decline in viral load',2);
insert into answer_options_temp values	('Resistance - I am concerned about transmission of de novo resistance with K103N',3);
insert into answer_options_temp values	('Adverse events - Particularly CNS profile',4);
insert into answer_options_temp values	('Adverse events - Particularly metabolic profile',5);
insert into answer_options_temp values	('Substance Abuse - it can be used in patients on methadone without making a dose adjustment',6);
insert into answer_options_temp values	('Special Populations -  it can be used it in women of child-bearing age',7);
insert into answer_options_temp values	('Drug Interactions - fewer drug interactions than with ARVs metabolized by CYP3A4',8);
insert into answer_options_temp values	('Other',9);

execute CREATE_SURVEY_QA(' If you answered YES to question #3, what are some factors that might impact your use of raltegravir in naïve patients?','multioptmultisel','Sustiva/Atripla DCI','false','6');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','Sustiva/Atripla DCI','false','7'); 

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('PI + 2 nucs',1);
insert into answer_options_temp values	('PI, no nucs',2);
insert into answer_options_temp values	('NNRTI + 2 nucs',3);
insert into answer_options_temp values	('NNRTI, no nucs',4);
insert into answer_options_temp values	('With 2 nucs',5);
insert into answer_options_temp values	('Based on results of genotype',6);
insert into answer_options_temp values	('Other',7);

execute CREATE_SURVEY_QA(' What antiretroviral agents are you likely to pair with raltegravir?','multioptmultisel','Sustiva/Atripla DCI','false','8');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);


execute CREATE_SURVEY_QA(' Would you consider using maravioc in naïve patients?','multioptsinglesel','Sustiva/Atripla DCI','false','9');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Dosing frequency - prefer to use a QD regimen',1);
insert into answer_options_temp values	('Drug interactions - Multiple drug interactions with MVC make it challenging to use in naïve patients',2);
insert into answer_options_temp values	('Cost and Inconvenience - cost associated with Trofile assay limits MVC use in naïve patients',3);
insert into answer_options_temp values	('Lack of long-term data in naïve patients',4);
insert into answer_options_temp values	('Good clinical experiences with other ARVs',5);
insert into answer_options_temp values	('Other',6);

execute CREATE_SURVEY_QA(' If you answered NO to question #9, what is the main reason that you would not use maraviroc in naïve patients?','multioptmultisel','Sustiva/Atripla DCI','false','10');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','Sustiva/Atripla DCI','false','11'); 

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Efficacy - Based on immune and virologic responses',1);
insert into answer_options_temp values	('Resistance - I am concerned about transmission of de novo resistance with K103N',2);
insert into answer_options_temp values	('Adverse Events - Particularly CNS profile (of efavirenz)',3);
insert into answer_options_temp values	('Adverse Events - Particularly metabolic profile (of efavirenz)',4);
insert into answer_options_temp values	('Tolerability',5);
insert into answer_options_temp values	('Other',6);

execute CREATE_SURVEY_QA(' If you answered YES to question #9, what is the main factor that might impact your use of maraviroc in naïve patients?','multioptmultisel','Sustiva/Atripla DCI','false','12');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','Sustiva/Atripla DCI','false','13'); 

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('PI + 2 nucs',1);
insert into answer_options_temp values	('PI, no nucs',2);
insert into answer_options_temp values	('NNRTI + 2 nucs',3);
insert into answer_options_temp values	('NNRTI, no nucs',4);
insert into answer_options_temp values	('With 2 nucs',5);
insert into answer_options_temp values	('Based on results of genotype',6);
insert into answer_options_temp values	('Other',7);

execute CREATE_SURVEY_QA(' What antiretroviral agents are you likely to pair with maraviroc?','multioptmultisel','Sustiva/Atripla DCI','false','14');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','Sustiva/Atripla DCI','false','15'); 

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('ARV CSF penetration is clinically significant, as it correlates with long term cognitive function',1);
insert into answer_options_temp values	('ARV CSF penetration is not clinically significant, as these data do not correlate with long term cognitive function',2);
insert into answer_options_temp values	('Not practical to do spinal taps to measure CSF',3);
insert into answer_options_temp values	('None of the above',4);

execute CREATE_SURVEY_QA(' Are the data on CSF penetration of ARVs a clinically significant factor in choosing an ARV regimen?','multioptsinglesel','Sustiva/Atripla DCI','false','16');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Yes - with NNRTIs',1);
insert into answer_options_temp values	('Yes - with PIs',2);
insert into answer_options_temp values	('Yes - with integrase inhibitors',3);
insert into answer_options_temp values	('Yes - with CCR5 antagonists, no nucs',4);
insert into answer_options_temp values	('Yes - with NRTIs',5);
insert into answer_options_temp values	('I don''t see any differences',6);
insert into answer_options_temp values	('I don''t monitor Vit. D levels routinely',7);

execute CREATE_SURVEY_QA(' If you monitor Vit. D levels of patients on antiretroviral treatment, do you see deficiencies with any particular classes of drugs?','multioptsinglesel','Sustiva/Atripla DCI','false','17');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Etravirine',1);
insert into answer_options_temp values	('Boosted PI',2);
insert into answer_options_temp values	('Raltegravir',3);
insert into answer_options_temp values	('Maraviroc',4);
insert into answer_options_temp values	('Other',5);

execute CREATE_SURVEY_QA(' What drug(s) do you anticipate using in your next regimen after a patient has failed EFV with a K103N mutation?  Please check all that apply.','multioptsinglesel','Sustiva/Atripla DCI','false','18');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','Sustiva/Atripla DCI','false','19'); 

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Tier 1 = National',1);
insert into answer_options_temp values	('Tier 2 = Regional',2);
insert into answer_options_temp values	('Tier 3 = Local',3);

execute CREATE_SURVEY_QA(' What is the tier of the person who were asked the questions?','multioptsinglesel','Sustiva/Atripla DCI','false','20');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('NP',1);
insert into answer_options_temp values	('DO',2);
insert into answer_options_temp values	('MD.',3);
insert into answer_options_temp values	('PA',4);
insert into answer_options_temp values	('PhD',5);
insert into answer_options_temp values	('PharmD',6);
insert into answer_options_temp values	('RPh',7);
insert into answer_options_temp values	('RN',8);

execute CREATE_SURVEY_QA(' What are the credentials of the responder?','multioptmultisel','Sustiva/Atripla DCI','false','21');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

rem : group permission

insert into FEATURE_USERGROUP_MAP (ID, FEATURE_ID, USERGROUP_ID, PERMISSION_ON_FEATURE) 
values (HIBERNATE_SEQUENCE.NEXTVAL, (select id from SURVEYMETADATA where name = 'Sustiva/Atripla DCI'),
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
rem : 2>Purpose         	: Script to create the new "Sustiva/Atripla DCI Survey"
rem : 3>Date of creation	: 20-Oct-2009

rem ------------------------------------------------------------------------------------------------
