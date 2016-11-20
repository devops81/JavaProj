SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : Prasugrel_Reactive_DCI_v3_Survey.log
SPOOL Prasugrel_Reactive_DCI_v3_Survey.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------

update SURVEYMETADATA set name = 'Prasugrel Reactive DCI v3 Ended_'||( select to_char(sysdate, 'MM/DD/YYYY') from dual ), DATE_END = ( select to_char(sysdate, 'MM/DD/YYYY') from dual ) where name = 'Prasugrel Reactive DCI v3';

delete from FEATURE_USERGROUP_MAP where FEATURE_ID in ( select id from SURVEYMETADATA where name = 'Prasugrel Reactive DCI v3 Ended_'||( select to_char(sysdate, 'MM/DD/YYYY') from dual ) ) and PERMISSION_ON_FEATURE = 3;

rem -------------------------------------------------------------------------------------------------

Insert into "SURVEYMETADATA" ("ID","NAME","TYPE","STATE","ACTIVE","DATE_START","DATE_END") 
values (HIBERNATE_SEQUENCE.NEXTVAL,'Prasugrel Reactive DCI v3','DCI','Launched','true', ( select to_char(sysdate, 'MM/DD/YYYY') from dual ), ( select to_char(sysdate + numtoyminterval(1, 'YEAR'), 'MM/DD/YYYY') from dual ));

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Agree',1);

execute CREATE_SURVEY_QA(' As with all DCI related to off-label uses of PLAVIX, these questions may be used only to capture information voluntarily offered by healthcare professionals. That is, MSLs/RMLs may capture the answers to these questions only if the healthcare professional brings the topic up without any prompting or suggestion from the MSL/RML. Under no circumstances may the MSL /RML read the questions or the possible answers to the HCP. Therefore, there is no expectation that the MSL/RML will provide answers to these questions for all, or even any, of the healthcare professionals with whom the MSL/RMLs may be in contact.','multioptsinglesel','Prasugrel Reactive DCI v3','true','1');

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

execute CREATE_SURVEY_QA(' HCP Specialty','multioptsinglesel','Prasugrel Reactive DCI v3','false','2');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other HCP Specialty','simpleText','Prasugrel Reactive DCI v3','false','3'); 

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Tier 1 (National)',1);
insert into answer_options_temp values ('Tier 2 (Regional)',2);
insert into answer_options_temp values ('Tier 3 (Local)',3);

execute CREATE_SURVEY_QA(' KTL/OL Tier','multioptsinglesel','Prasugrel Reactive DCI v3','false','4');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Yes',1);
insert into answer_options_temp values ('No (skip to question 18)',2);

execute CREATE_SURVEY_QA(' Did the HCP mention prasugrel?','multioptsinglesel','Prasugrel Reactive DCI v3','false','5');

delete from answer_options_temp;

rem ------------------------------------------

insert into answer_options_temp values ('Will routinely use prasugrel (proceed to questions 8-17)',1);
insert into answer_options_temp values ('Will use cautiously in select patients (proceed to questions 8-17)',2);
insert into answer_options_temp values ('Not planning to use prasugrel (proceed to questions 7-9, then - question 18)',3);
insert into answer_options_temp values ('Will not use prasugrel until more data available (proceed to questions 7-9, then - question 18)',4);
insert into answer_options_temp values ('Did not comment (skip to question 18)',5);


execute CREATE_SURVEY_QA(' Did the HCP state how he/she will use prasugrel in his/her individual clinical practice?','multioptsinglesel','Prasugrel Reactive DCI v3','false','6');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Concerns about benefit/risk profile',1);
insert into answer_options_temp values ('Concerns about bleeding',2);
insert into answer_options_temp values ('Concerns about subgroups (e.g., stroke/TIA, age>=75years)',3);
insert into answer_options_temp values ('Concerns about patient going to CABG',4);
insert into answer_options_temp values ('Concerns about cancer/malignancy',5);
insert into answer_options_temp values ('Preference for upstream dual antiplatelet therapy in ACS',6);
insert into answer_options_temp values ('Did not comment',7);

execute CREATE_SURVEY_QA(' If HCP does NOT plan on using prasugrel, what rationale did they provide (Select all that apply)?','multioptmultisel','Prasugrel Reactive DCI v3','false','7');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('No',1);
insert into answer_options_temp values ('Yes',2);

execute CREATE_SURVEY_QA(' Did the HCP mention prasugrel''s black box warning, highlighting bleeding risks?','multioptsinglesel','Prasugrel Reactive DCI v3','false','8');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Fatal bleeding',1);
insert into answer_options_temp values ('Active pathological bleeding',2);
insert into answer_options_temp values ('History of TIA/stroke',3);
insert into answer_options_temp values ('Age>=75 years of age',4);
insert into answer_options_temp values ('CABG - if CABG likely, do not start',5);
insert into answer_options_temp values ('For any surgery, discontinue prasugrel at least 7 days prior to any surgery',6);
insert into answer_options_temp values ('Body weight < 60 kg',7);
insert into answer_options_temp values ('Propensity to bleed',8);
insert into answer_options_temp values ('Concomitant use of medications that increase the risk of bleeding',9);

execute CREATE_SURVEY_QA(' If yes to #8, please check all specific bleeding risks mentioned: ','multioptmultisel','Prasugrel Reactive DCI v3','false','9');

delete from answer_options_temp;

rem --------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Superior efficacy',1);
insert into answer_options_temp values ('Faster onset of action',2);
insert into answer_options_temp values ('Less variability of response',3);
insert into answer_options_temp values ('No drug-drug interaction concerns',4);
insert into answer_options_temp values ('Ability to see anatomy before using prasugrel',5);
insert into answer_options_temp values ('Impressed with quality and quantity of prasugrel data available',6);
insert into answer_options_temp values ('Benefit/Risk favors prasugrel',7);
insert into answer_options_temp values ('Bleeding is manageable',8);
insert into answer_options_temp values ('Clopidogrel resistance/failure',9);
insert into answer_options_temp values ('Did not comment',10);

execute CREATE_SURVEY_QA(' If the HCP is planning on using prasugrel, did the HCP comment on any factors that may influence treatment decisions around use of prasugrel in clinical practice (Select all that apply)?','multioptmultisel','Prasugrel Reactive DCI v3','false','10');

delete from answer_options_temp;

rem --------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('High-risk ACS patients',1);
insert into answer_options_temp values ('Stented ACS patients',2);
insert into answer_options_temp values ('Non-stented ACS patients (medically managed)',3);
insert into answer_options_temp values ('Elective PCI',4);
insert into answer_options_temp values ('Stable CAD/history of MI',5);
insert into answer_options_temp values ('Diabetic patients with ACS',6);
insert into answer_options_temp values ('STEMI',7);
insert into answer_options_temp values ('Switching existing Clopidogrel patients to prasugrel',8);
insert into answer_options_temp values ('Did not comment',9);

execute CREATE_SURVEY_QA(' Did the HCP comment in which patient populations prasugrel may be utilized? (check all that apply)?','multioptmultisel','Prasugrel Reactive DCI v3','false','11');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------  

insert into answer_options_temp values ('Patients < 75 years of age',1);
insert into answer_options_temp values ('Non-diabetics',2);
insert into answer_options_temp values ('Male patients',3);
insert into answer_options_temp values ('Patients with no other co-morbidities',4);

execute CREATE_SURVEY_QA(' If HCP commented on prescribing prasugrel for patients at low risk of bleeding, how would they define ''''low risk'''' of bleeding? (Select all that apply)','multioptmultisel','Prasugrel Reactive DCI v3','false','12');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Prior TIA/stroke',1);
insert into answer_options_temp values ('Elderly ',2);
insert into answer_options_temp values ('Low weight',3);
insert into answer_options_temp values ('Potential CABG patients',4);

execute CREATE_SURVEY_QA(' Did the HCP mention any patient sub-groups in which prasugrel may be specifically avoided? (Select all that apply)','multioptmultisel','Prasugrel Reactive DCI v3','false','13');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------  

insert into answer_options_temp values ('Prior TIA/stroke',1);
insert into answer_options_temp values ('Elderly',2);
insert into answer_options_temp values ('Low weight',3);
insert into answer_options_temp values ('Potential CABG patients',4);
insert into answer_options_temp values ('Did not comment',5);

execute CREATE_SURVEY_QA(' Within the patient populations where prasugrel may be used by the HCP, did the HCP mention any patient sub-groups in which a lower maintenance dose of prasugrel may be used? (Select all that apply)','multioptmultisel','Prasugrel Reactive DCI v3','false','14');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('LD upstream, prior to PCI with unknown anatomy',1);
insert into answer_options_temp values ('LD in cath lab after anatomy known, prior to PCI',2);
insert into answer_options_temp values ('LD after PCI',3);
insert into answer_options_temp values ('Did not comment',4);

execute CREATE_SURVEY_QA(' If the HCP plans on using prasugrel in ACS patients who are candidates for PCI, did the HCP comment on which strategy will be chosen?','multioptsinglesel','Prasugrel Reactive DCI v3','false','15');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------  

insert into answer_options_temp values ('Will continue indefinitely',1);
insert into answer_options_temp values ('Will follow same guideline recommendations for clopidogrel in DES patients (i.e. 12 months)',2);
insert into answer_options_temp values ('Prasugrel use in the short-term (<1 month) following PCI, then switch to clopidogrel long-term',3);
insert into answer_options_temp values ('Did not comment',4);

execute CREATE_SURVEY_QA(' If the HCP is planning on using prasugrel, did they comment on how long they would continue it?','multioptsinglesel','Prasugrel Reactive DCI v3','false','16');

delete from answer_options_temp;

rem ---------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Communication from patient',1);
insert into answer_options_temp values ('Medical Records',2);
insert into answer_options_temp values ('Imaging studies',3);
insert into answer_options_temp values ('Did not comment',4);

execute CREATE_SURVEY_QA(' Since prasugrel is contraindicated in patients with a history of TIA/Stroke, did the HCP indicate how they would determine who has had a history of TIA/Stroke? (Select all that apply)','multioptmultisel','Prasugrel Reactive DCI v3','false','17');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------  

insert into answer_options_temp values ('YES',1);
insert into answer_options_temp values ('NO (skip to question 29)',2);

execute CREATE_SURVEY_QA(' Did the TL inquire about the CURRENT/OASIS 7 results presented at the ESC 2009 Meeting?','multioptsinglesel','Prasugrel Reactive DCI v3','false','18');

delete from answer_options_temp;

rem ---------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('YES',1);
insert into answer_options_temp values ('Somewhat',2);
insert into answer_options_temp values ('NO (skip to question 29)',3);

execute CREATE_SURVEY_QA(' Was the TL familiar with the data presented at the ESC 2009 Meeting?','multioptsinglesel','Prasugrel Reactive DCI v3','false','19');

delete from answer_options_temp;

rem ---------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Positive trial',1);
insert into answer_options_temp values ('Neutral trial',2);
insert into answer_options_temp values ('Negative/failed trial',3);
insert into answer_options_temp values ('No comment',4);

execute CREATE_SURVEY_QA(' Did the TL comment on their overall perspective of CURRENT:','multioptsinglesel','Prasugrel Reactive DCI v3','false','20');

delete from answer_options_temp;

rem ---------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Primary endpoint is not significant, no further conclusions can be made',1);
insert into answer_options_temp values ('Primary endpoint is not significant, however the data on the PCI patient population is clinically relevant',2);
insert into answer_options_temp values ('Stent thrombosis endpoint is clinically relevant',3);
insert into answer_options_temp values ('Stent thrombosis + MI endpoints are clinically relevant',4);
insert into answer_options_temp values ('Did not comment',5);

execute CREATE_SURVEY_QA(' Did the TL comment on the efficacy data from the CURRENT/OASIS 7 Trial (select all that apply)?','multioptmultisel','Prasugrel Reactive DCI v3','false','21');

delete from answer_options_temp;

rem ---------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Yes - expressed concerns regarding CURRENT major bleeding, but benefit would outweigh risk',1);
insert into answer_options_temp values ('Yes - expressed concerns regarding CURRENT major bleeding, but risk would outweigh benefit',2);
insert into answer_options_temp values ('Yes - expressed no concerns regarding CURRENT major bleeding',3);
insert into answer_options_temp values ('Yes - expressed concerns about transfusions',4);
insert into answer_options_temp values ('Yes - expressed concerns about TIMI major bleeding',5);
insert into answer_options_temp values ('Yes - expressed concerns about Life threatening bleeding',6);
insert into answer_options_temp values ('Did not comment',7);

execute CREATE_SURVEY_QA(' Did the TL comment on the clinical relevance of the safety profile from CURRENT?','multioptsinglesel','Prasugrel Reactive DCI v3','false','22');

delete from answer_options_temp;

rem ---------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Double dose regiment - 600 mg LD + 150mg MD in all ACS patients',1);
insert into answer_options_temp values ('Double dose regimen in the PCI population only',2);
insert into answer_options_temp values ('300 mg LD + 75 mg MD',3);
insert into answer_options_temp values ('600 mg LD + 75 mg MD',4);
insert into answer_options_temp values ('300 mg LD + 150 mg MD',5);
insert into answer_options_temp values ('Did not comment',6);

execute CREATE_SURVEY_QA(' As a result of CURRENT, did the TL offer comment on which dosing scheme may be utilized when treating ACS patients with an early invasive strategy involving PCI?','multioptsinglesel','Prasugrel Reactive DCI v3','false','23');

delete from answer_options_temp;

rem ---------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Upstream, prior to knowing the coronary anatomy',1);
insert into answer_options_temp values ('After viewing the coronary anatomy',2);
insert into answer_options_temp values ('Would administer 300mg to all patients upstream, then another 300mg to those going with PCI',3);
insert into answer_options_temp values ('Would give 600mg LD, define anatomy then give 150mg in stented patients',4);
insert into answer_options_temp values ('Did not comment',5);

execute CREATE_SURVEY_QA(' As a result of CURRENT, did the TL offer comment on the timing of the dosing scheme that may be utilized:','multioptsinglesel','Prasugrel Reactive DCI v3','false','24');

delete from answer_options_temp;

rem ---------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Yes (skip to question 28)',1);
insert into answer_options_temp values ('No',2);
insert into answer_options_temp values ('Did not comment (skip to question 29)',3);

execute CREATE_SURVEY_QA(' Does the TL think CURRENT will change clinical practice?','multioptsinglesel','Prasugrel Reactive DCI v3','false','25');

delete from answer_options_temp;

rem ---------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Non-significant overall efficacy',1);
insert into answer_options_temp values ('Poor safety data',2);
insert into answer_options_temp values ('Poor benefit/risk',3);
insert into answer_options_temp values ('Practicality of dose regimen',4);
insert into answer_options_temp values ('Would use prasugrel 60 mg instead clopidogrel 600mg',5);
insert into answer_options_temp values ('Did not comment',6);

execute CREATE_SURVEY_QA(' If ''''No'''' to question 25, what was their rationale? (Select all that apply)','multioptmultisel','Prasugrel Reactive DCI v3','false','26');

delete from answer_options_temp;

rem ---------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Will use 600/150/75mg high dose regimen in ACS patients undergoing PCI',1);
insert into answer_options_temp values ('Will continue to use 600mg LD in ACS patients undergoing early invasive strategy followed by standard maintenance dose.',2);
insert into answer_options_temp values ('Will continue to use the standard dose regimen (300mg/75) based on lack of superiority of the high dose regimen.',3);
insert into answer_options_temp values ('Will continue prasugrel ',4);

execute CREATE_SURVEY_QA(' If ''''No'''' to question 25, how will the TL treat patients that undergo an early invasive strategy:','multioptsinglesel','Prasugrel Reactive DCI v3','false','27');

delete from answer_options_temp;

rem ---------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Currently using 600mg LD followed by standard maintenance regimen and will modify to 300mg LD in all invasive strategy patients due to lack of superiority.',1);
insert into answer_options_temp values ('Currently using 600mg LD followed by standard maintenance dose and will modify to only use in PCI patients',2);
insert into answer_options_temp values ('Currently using 600/150/75 in select populations and will modify to 300/75 due to lack of superiority.',3);
insert into answer_options_temp values ('Currently using 300/75 in select populations and will modify to 600/150/75mg.',4);
insert into answer_options_temp values ('Will use 60mg prasugrel LD versus 600mg of clopidogrel.',5);
insert into answer_options_temp values ('Will use a higher aspirin dose than 75 - 100mg.',6);
insert into answer_options_temp values ('Did not comment',7);

execute CREATE_SURVEY_QA(' If ''''Yes'''' to question 25 in patients presenting with ACS that undergo early invasive strategy, will results of the CURRENT/OASIS 7 Trial influence the TL to modify their existing approach to anti-platelet therapy:','multioptsinglesel','Prasugrel Reactive DCI v3','false','28');

delete from answer_options_temp;

rem ---------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Yes',1);
insert into answer_options_temp values ('No (end of DCI)',2);

execute CREATE_SURVEY_QA(' Did HCP mention PLATO or ticagrelor? (If yes, proceed with question 30)','multioptsinglesel','Prasugrel Reactive DCI v3','false','29');

delete from answer_options_temp;

rem ---------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Will use ticagrelor when available (Goto question 32)',1);
insert into answer_options_temp values ('Will use cautiously when available (Goto question 32)',2);
insert into answer_options_temp values ('Not planning to use ticagrelor',3);
insert into answer_options_temp values ('Will not use ticagrelor until more data available',4);
insert into answer_options_temp values ('Did not comment',5);

execute CREATE_SURVEY_QA(' Did the HCP state how he/she may use ticagrelor in his/her individual clinical practice?','multioptsinglesel','Prasugrel Reactive DCI v3','false','30');

delete from answer_options_temp;

rem ---------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Concerns about benefit/risk profile',1);
insert into answer_options_temp values ('Concerns about bleeding',2);
insert into answer_options_temp values ('Concerns about ventricular pauses',3);
insert into answer_options_temp values ('Concerns about dyspnea',4);
insert into answer_options_temp values ('Concerns about patient compliance due to reversibility of antiplatelet effect',5);
insert into answer_options_temp values ('Did not comment',6);

execute CREATE_SURVEY_QA(' If the HCP does not plan on using ticagrelor, what rationale did they provide (Select all that apply)?','multioptmultisel','Prasugrel Reactive DCI v3','false','31');

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
insert into answer_options_temp values ('Decreased CV death',10);
insert into answer_options_temp values ('Did not comment',11);

execute CREATE_SURVEY_QA(' If the HCP is planning on using ticagrelor, did the HCP comment on any factors that may influence treatment decisions around use of ticagrelor in clinical practice (Select all that apply)?','multioptmultisel','Prasugrel Reactive DCI v3','false','32');

delete from answer_options_temp;

rem ---------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('High-risk ACS patients',1);
insert into answer_options_temp values ('Stented ACS patients',2);
insert into answer_options_temp values ('Non-stented ACS patients (medically managed)',3);
insert into answer_options_temp values ('Elective PCI',4);
insert into answer_options_temp values ('Stable CAD / history of MI',5);
insert into answer_options_temp values ('Diabetic patients with ACS',6);
insert into answer_options_temp values ('STEMI',7);
insert into answer_options_temp values ('Switching existing Clopidogrel patients to ticagrelor ',8);
insert into answer_options_temp values ('Patients with potential to go on to CABG',9);
insert into answer_options_temp values ('All appropriate patient populations',10);
insert into answer_options_temp values ('Did not comment',11);

execute CREATE_SURVEY_QA(' Did the HCP comment in which patient populations ticagrelor may be utilized? (check all that apply)?','multioptmultisel','Prasugrel Reactive DCI v3','false','33');

delete from answer_options_temp;

rem ---------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('LD upstream, prior to PCI with unknown anatomy',1);
insert into answer_options_temp values ('LD in cath lab after anatomy known, prior to PCI',2);
insert into answer_options_temp values ('LD after PCI',3);
insert into answer_options_temp values ('Did not comment',4);

execute CREATE_SURVEY_QA(' If the HCP plans on using ticagrelor in ACS patients who are candidates for PCI, did the HCP comment on which strategy will be chosen?','multioptsinglesel','Prasugrel Reactive DCI v3','false','34');

delete from answer_options_temp;

rem ---------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Will continue indefinitely',1);
insert into answer_options_temp values ('Will follow same guideline recommendations for clopidogrel in DES patients (i.e. 12 months)',2);
insert into answer_options_temp values ('Ticagrelor use in the short-term (<1 month) following PCI, then switch to clopidogrel long-term',3);
insert into answer_options_temp values ('Will continue Ticagrelor 9 months only',4);
insert into answer_options_temp values ('Did not comment',5);

execute CREATE_SURVEY_QA(' If the HCP is planning on using ticagrelor, did they comment on how long they would continue it?','multioptsinglesel','Prasugrel Reactive DCI v3','false','35');

delete from answer_options_temp;

rem ---------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Dyspnea',1);
insert into answer_options_temp values ('Ventricular Pauses',2);
insert into answer_options_temp values ('Serum Creatinine Increase',3);
insert into answer_options_temp values ('Hyperuricemia',4);
insert into answer_options_temp values ('Bleeding',5);
insert into answer_options_temp values ('Reversibility',6);

execute CREATE_SURVEY_QA(' If the HCP is not planning on using ticagrelor for the length it was studied in the trial, what is the rational?  (Select all that apply)','multioptmultisel','Prasugrel Reactive DCI v3','false','36');

delete from answer_options_temp;

rem ---------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Ticagrelor will become agent of choice in all patients',1);
insert into answer_options_temp values ('Ticagrelor will become agent of choice in PCI patients',2);
insert into answer_options_temp values ('Ticagrelor will become agent of choice in Non-PCI patients',3);
insert into answer_options_temp values ('Ticagrelor will be used more frequently than prasugrel or clopidogrel in the acute setting ',4);
insert into answer_options_temp values ('Clopidogrel at LD 300mg MD and 75mg will regimen of choice in non-PCI patients',5);
insert into answer_options_temp values ('Clopidogrel at LD 600mg MD and 75mg will be the regimen of choice in the PCI patients',6);
insert into answer_options_temp values ('Clopi at LD 600mg and MD 150 mg X 6 days, 75mg will become regimen of choice in PCI patients',7);
insert into answer_options_temp values ('Did not comment',8);

execute CREATE_SURVEY_QA(' Did the HCP comment on how results of PLATO are interpreted in light of their knowledge of CURRENT?','multioptsinglesel','Prasugrel Reactive DCI v3','false','37');

delete from answer_options_temp;

rem ---------------------------------------------------------------------------------------------------

insert into answer_options_temp values ('Yes',1);
insert into answer_options_temp values ('No',2);

execute CREATE_SURVEY_QA(' Did the HCP state whether this would impact clinical practice?','multioptsinglesel','Prasugrel Reactive DCI v3','false','38');

delete from answer_options_temp;

rem ---------------------------------------------------------------------------------------------------


rem : group permission

insert into FEATURE_USERGROUP_MAP (ID, FEATURE_ID, USERGROUP_ID, PERMISSION_ON_FEATURE) 
values (HIBERNATE_SEQUENCE.NEXTVAL, (select id from SURVEYMETADATA where name = 'Prasugrel Reactive DCI v3'),
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
rem : 2>Purpose         	: Script to create the new "Prasugrel Reactive DCI v3 Survey"
rem : 3>Date of creation	: 29-Sep-2009

rem ------------------------------------------------------------------------------------------------
