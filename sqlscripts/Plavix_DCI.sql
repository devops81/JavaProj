SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : Plavix_DCI_Survey.log

SPOOL Plavix_DCI_Survey.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------

update SURVEYMETADATA set name = 'Plavix DCI Ended_'||( select to_char(sysdate, 'MM/DD/YYYY') from dual ), DATE_END = ( select to_char(sysdate, 'MM/DD/YYYY') from dual ) where name = 'Plavix DCI';

delete from FEATURE_USERGROUP_MAP where FEATURE_ID in ( select id from SURVEYMETADATA where name = 'Plavix DCI Ended_'||( select to_char(sysdate, 'MM/DD/YYYY') from dual ) ) and PERMISSION_ON_FEATURE = 3;

rem -------------------------------------------------------------------------------------------------

Insert into "SURVEYMETADATA" ("ID","NAME","TYPE","STATE","ACTIVE","DATE_START","DATE_END") 
values (HIBERNATE_SEQUENCE.NEXTVAL,'Plavix DCI','DCI','Launched','true', ( select to_char(sysdate, 'MM/DD/YYYY') from dual ), ( select to_char(sysdate + numtoyminterval(1, 'YEAR'), 'MM/DD/YYYY') from dual ));

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Agree',1);

execute CREATE_SURVEY_QA(' The MSL/RML MAY NOT read the questions or the possible answers to the HCP. The MSLs/RMLs may capture information only if the healthcare professional brings the topic up without any prompting or suggestion from the MSL/RML. As with all DCI related to off-label uses of PLAVIX, these questions may be used only to capture information voluntarily offered by healthcare professionals. That is, MSLs/RMLs may capture the answers to these questions only if the healthcare professional brings the topic up without any prompting or suggestion from the MSL/RML. Under no circumstances may the MSL /RML read the questions or the possible answers to the HCP. Therefore, there is no expectation that the MSL/RML will provide answers to these questions for all, or even any, of the healthcare professionals with whom the MSL/RMLs may be in contact','multioptsinglesel','Plavix DCI','true','1');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Interventional CD',1);
insert into answer_options_temp values ('Hospital-based Clinical CD',2);
insert into answer_options_temp values ('Clinical Pharmacists',3);
insert into answer_options_temp values ('Managed Care',4);
insert into answer_options_temp values ('Office-based Clinical CD',5);
insert into answer_options_temp values ('CT Surgeon',6);
insert into answer_options_temp values ('Neurologist',7);
insert into answer_options_temp values ('ED Physician',8);
insert into answer_options_temp values ('Hospitalist',9);
insert into answer_options_temp values ('Internal Medicine',10);
insert into answer_options_temp values ('Other',11);

execute CREATE_SURVEY_QA(' HCP Specialty','multioptsinglesel','Plavix DCI','false','2');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other (please specify)','simpleText','Plavix DCI','false','3'); 

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Tier 1 (National)',1);
insert into answer_options_temp values ('Tier 2 (Regional)',2);
insert into answer_options_temp values ('Tier 3 (Local)',3);

execute CREATE_SURVEY_QA(' KTL/OL Tier','multioptsinglesel','Plavix DCI','false','4');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Yes - Was added',1);
insert into answer_options_temp values ('Yes - Was not added',2);
insert into answer_options_temp values ('Did not mention',3);

execute CREATE_SURVEY_QA(' Did the HCP mention the formulary status of prasugrel on his/her hospital formulary? (If A. to #5 proceed with # 8 to 18. If B. to #5 proceed to #6 and skip to #18. If C. to #5 proceed to #18)','multioptsinglesel','Plavix DCI','false','5');

delete from answer_options_temp;

rem ------------------------------------------

insert into answer_options_temp values ('Concerns about benefit/risk profile',1);
insert into answer_options_temp values ('Concerns about bleeding',2);
insert into answer_options_temp values ('Concerns about subgroups (e.g., stroke/TIA, age>=75years)',3);
insert into answer_options_temp values ('Concerns about patient going to CABG',4);
insert into answer_options_temp values ('Preference for upstream dual antiplatelet therapy in ACS',5);
insert into answer_options_temp values ('Cost',6);
insert into answer_options_temp values ('Other (please specify)',7);
insert into answer_options_temp values ('Did not comment',8);

execute CREATE_SURVEY_QA(' If prasugrel was not added to formulary, what rationale did the HCP provide for the decision made by the hospital formulary committee (Select all that apply)?','multioptmultisel','Plavix DCI','false','6');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other (please specify)','simpleText','Plavix DCI','false','7'); 

rem -------------------------------------------------------------------------------------------------


insert into answer_options_temp values ('Superior efficacy',1);
insert into answer_options_temp values ('Faster onset of action',2);
insert into answer_options_temp values ('Less variability of response',3);
insert into answer_options_temp values ('No drug-drug interaction concerns',4);
insert into answer_options_temp values ('Ability to see anatomy before using prasugrel',5);
insert into answer_options_temp values ('Impressed with quality and quantity of prasugrel data available',6);
insert into answer_options_temp values ('Benefit/Risk favors prasugrel',7);
insert into answer_options_temp values ('Bleeding is manageable',8);
insert into answer_options_temp values ('Cost',9);
insert into answer_options_temp values ('Other (please specify)',10);
insert into answer_options_temp values ('Did not comment',11);

execute CREATE_SURVEY_QA(' If prasugrel was added to formulary, what rationale did the HCP provide for the decision made by the hospital formulary committee (Select all that apply)?','multioptmultisel','Plavix DCI','false','8');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other (please specify)','simpleText','Plavix DCI','false','9'); 

rem -------------------------------------------------------------------------------------------------


insert into answer_options_temp values ('High-risk ACS patients',1);
insert into answer_options_temp values ('Stented ACS patients',2);
insert into answer_options_temp values ('Non-stented ACS patients (medically managed)',3);
insert into answer_options_temp values ('Elective PCI',4);
insert into answer_options_temp values ('Stable CAD/history of MI',5);
insert into answer_options_temp values ('Diabetic patients with ACS',6);
insert into answer_options_temp values ('STEMI',7);
insert into answer_options_temp values ('Other (please specify)',8);
insert into answer_options_temp values ('Did not comment',9);

execute CREATE_SURVEY_QA(' If prasugrel was added to formulary, did the HCP state in which patient populations will prasugrel be used?','multioptsinglesel','Plavix DCI','false','10');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------  

execute CREATE_SURVEY_QA(' Other (please specify)','simpleText','Plavix DCI','false','11'); 

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Prior TIA/stroke',1);
insert into answer_options_temp values ('Elderly - if applicable, specify age',2);
insert into answer_options_temp values ('Low weight - if applicable, specify body weight',3);
insert into answer_options_temp values ('Potential CABG patients',4);
insert into answer_options_temp values ('Other (please specify)',5);
insert into answer_options_temp values ('Did not comment',6);

execute CREATE_SURVEY_QA(' If prasugrel was added to formulary, did the HCP mention any patient sub-groups in which prasugrel may be specifically avoided? (Select all that apply)','multioptmultisel','Plavix DCI','false','12');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------  

execute CREATE_SURVEY_QA(' Other (please specify)','simpleText','Plavix DCI','false','13'); 

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Prior TIA/stroke',1);
insert into answer_options_temp values ('Elderly - If applicable, specify age',2);
insert into answer_options_temp values ('Low weight - If applicable, specify body weight',3);
insert into answer_options_temp values ('Potential CABG patients',4);
insert into answer_options_temp values ('Other (please specify)',5);
insert into answer_options_temp values ('Did not comment',6);

execute CREATE_SURVEY_QA(' Did the HCP mention any patient sub-groups in which a lower maintenance dose of prasugrel may be used? (Select all that apply)','multioptmultisel','Plavix DCI','false','14');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other (please specify)','simpleText','Plavix DCI','false','15'); 

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Will continue indefinitely',1);
insert into answer_options_temp values ('Will follow same guideline recommendations for clopidogrel in DES patients (i.e. 15 months)',2);
insert into answer_options_temp values ('Prasugrel use in the short-term (<= 30 days) following PCI, then switch to clopidogrel long-term',3);
insert into answer_options_temp values ('Other (please specify)',4);
insert into answer_options_temp values ('Did not comment',5);

execute CREATE_SURVEY_QA(' Did the HCP comment on how long they would continue prasugrel?','multioptsinglesel','Plavix DCI','false','16');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other (please specify)','simpleText','Plavix DCI','false','17'); 

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Yes',1);
insert into answer_options_temp values ('No (end of DCI)',2);

execute CREATE_SURVEY_QA(' Did HCP mention PLATO or ticagrelor?','multioptsinglesel','Plavix DCI','false','18');

delete from answer_options_temp;

rem ---------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Yes (complete remaining DCI)',1);
insert into answer_options_temp values ('No (skip to 13)',2);

execute CREATE_SURVEY_QA(' Is the HCP planning on utilizing ticagrelor in his/her practice once it is available?','multioptsinglesel','Plavix DCI','false','19');

delete from answer_options_temp;

rem ---------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Superior efficacy',1);
insert into answer_options_temp values ('Faster onset of action',2);
insert into answer_options_temp values ('Reversible mechanism of action',3);
insert into answer_options_temp values ('Less variability of response',4);
insert into answer_options_temp values ('No drug-drug interaction concerns',5);
insert into answer_options_temp values ('Benefit/Risk favors ticagrelor',6);
insert into answer_options_temp values ('Bleeding is manageable',7);
insert into answer_options_temp values ('Can load upstream without concerns about CABG',8);
insert into answer_options_temp values ('Decreased stent thrombosis',9);
insert into answer_options_temp values ('Decreased death',10);
insert into answer_options_temp values ('Other',11);
insert into answer_options_temp values ('Did not comment',12);

execute CREATE_SURVEY_QA(' What factors would influence treatment decisions around use of ticagrelor in clinical practice (Select all that apply)','multioptmultisel','Plavix DCI','false','20');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other (please specify)','simpleText','Plavix DCI','false','21'); 

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Concerns about benefit/risk profile',1);
insert into answer_options_temp values ('Concerns about bleeding',2);
insert into answer_options_temp values ('Concerns about ventricular pauses',3);
insert into answer_options_temp values ('Concerns about using in poor renal function',4);
insert into answer_options_temp values ('Concerns about dyspnea',5);
insert into answer_options_temp values ('Concerns about patient compliance due to reversibility of antiplatelet effect',6);
insert into answer_options_temp values ('Concerns about the North American data (Please expound in Excel)',7);
insert into answer_options_temp values ('Concerns about an aspirin interaction (Please expound in Excel)',8);
insert into answer_options_temp values ('Other',9);
insert into answer_options_temp values ('Did not comment',10);

execute CREATE_SURVEY_QA(' What concerns, if any, would he/she have with utilizing ticagrelor? (Select all that apply)','multioptmultisel','Plavix DCI','false','22');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other (please specify)','simpleText','Plavix DCI','false','23'); 

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('High-risk ACS patients',1);
insert into answer_options_temp values ('Stented ACS patients',2);
insert into answer_options_temp values ('Non-stented ACS patients (medically managed)',3);
insert into answer_options_temp values ('Elective PCI',4);
insert into answer_options_temp values ('Stable CAD/history of MI',5);
insert into answer_options_temp values ('Diabetic patients with ACS',6);
insert into answer_options_temp values ('STEMI',7);
insert into answer_options_temp values ('Patients with potential to go on to CABG',8);
insert into answer_options_temp values ('All appropriate patient populations',9);
insert into answer_options_temp values ('Other',10);
insert into answer_options_temp values ('Did not comment',11);

execute CREATE_SURVEY_QA(' Did the HCP comment in which patient populations ticagrelor may be utilized? (select all that apply)','multioptmultisel','Plavix DCI','false','24');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other (please specify)','simpleText','Plavix DCI','false','25'); 

rem -------------------------------------------------------------------------------------------------


rem : group permission

insert into FEATURE_USERGROUP_MAP (ID, FEATURE_ID, USERGROUP_ID, PERMISSION_ON_FEATURE) 
values (HIBERNATE_SEQUENCE.NEXTVAL, (select id from SURVEYMETADATA where name = 'Plavix DCI'),
','||( select groupid from groups where groupname = 'FRONT_END_ADMIN')||',', 3);

rem --------------------------------------------------------------------------------------------------

commit;

rem --------------------------------------------------------------------------------------------------

rem user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

SPOOL OFF

SET ECHO OFF

exit;


rem : 1>Author name 		: Yatin
rem : 2>Purpose         	: Script to create the new "Plavix DCI Survey"
rem : 3>Date of creation	: 08-Jan-2010

rem ------------------------------------------------------------------------------------------------
