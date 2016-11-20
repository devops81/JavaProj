SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : db_changes_BMS_Prasugel_DCI_Survey.log
SPOOL db_changes_BMS_Prasugel_DCI_Survey.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------



Insert into "SURVEYMETADATA" ("ID","NAME","TYPE","STATE","ACTIVE","DATE_START","DATE_END") 
values (HIBERNATE_SEQUENCE.NEXTVAL,'Prasugrel Reactive','DCI','Launched','true','02/09/2009','02/09/2010');

commit;

rem --------------------------------------

insert into answer_options_temp values ('Interventional CD',1);
insert into answer_options_temp values ('Hospital-based Clinical CD',2);
insert into answer_options_temp values ('Clinical Pharmacists',3);
insert into answer_options_temp values ('Managed Care',4);
insert into answer_options_temp values ('Office-based Clinical CD',5);
insert into answer_options_temp values ('CT Surgeon',6);
insert into answer_options_temp values ('Neurologist',7);
insert into answer_options_temp values ('ED physician',8);
insert into answer_options_temp values ('Hospitalist',9);
insert into answer_options_temp values ('Internal Medicine',10);
insert into answer_options_temp values ('Other(specify)',11);

commit;


execute CREATE_SURVEY_QA(' HCP Specialty','multioptsinglesel','Prasugel - DCI','true','1');

commit;

delete from answer_options_temp;

commit;


rem ----------------------------------------------

execute CREATE_SURVEY_QA(' Other HCP Specialty','simpleText','Prasugel - DCI','false','2'); 

commit;

rem --------------------------------------------



insert into answer_options_temp values ('Tier 1 (national)',1);
insert into answer_options_temp values ('Tier 2 (regional)',2);
insert into answer_options_temp values ('Tier 3 (local)',3);

commit;

execute CREATE_SURVEY_QA(' KTL/OL Tier','multioptsinglesel','Prasugel - DCI','true','3');

commit;

delete from answer_options_temp;

commit;

rem --------------------------------------------

insert into answer_options_temp values ('Yes',1);
insert into answer_options_temp values ('No (end DCI)',2);

commit;


execute CREATE_SURVEY_QA(' Did the HCP mention the FDA''s recent approval of prasugrel? (If yes to #4, proceed with question 5)','multioptsinglesel','Prasugel - DCI','true','4');

commit;

delete from answer_options_temp;

commit;

rem --------------------------------------------


insert into answer_options_temp values ('Will use prasugrel',1);
insert into answer_options_temp values ('Will use cautiously',2);
insert into answer_options_temp values ('Not planning to use prasugrel',3);
insert into answer_options_temp values ('Will not use prasugrel until more data available (specify)',4);
insert into answer_options_temp values ('Did not comment',5);


commit;


execute CREATE_SURVEY_QA(' Did the HCP state how he/she will use prasugrel in his/her individual clinical practice?','multioptsinglesel','Prasugel - DCI','false','5');

commit;

delete from answer_options_temp;

commit;

rem --------------------------------------------

execute CREATE_SURVEY_QA(' What data needs to be available?','simpleText','Prasugel - DCI','false','6'); 

commit;

rem --------------------------------------------



insert into answer_options_temp values ('Concerns about benefit/risk profile',1);
insert into answer_options_temp values ('Concerns about bleeding',2);
insert into answer_options_temp values ('Concerns about subgroups (e.g., stroke/TIA, age>=75years)',3);
insert into answer_options_temp values ('Concerns about patients going to CABG',4);
insert into answer_options_temp values ('Concerns about cancer/malignancy',5);
insert into answer_options_temp values ('Preference for upstream dual antiplatelet therapy in ACS',6);
insert into answer_options_temp values ('Other (specify)',7);
insert into answer_options_temp values ('Did not comment',8);


commit;


execute CREATE_SURVEY_QA(' (If HCP does not plan on using prasugrel, proceed to questions 7-11, If HCP plans on using prasugrel, proceed to questions 12-30). If the HCP does not plan on using prasugrel, what rationale did they provide (Select all that apply)?','multioptmultisel','Prasugel - DCI','false','7');

commit;

delete from answer_options_temp;

commit;

rem -------------------------------------------  

execute CREATE_SURVEY_QA(' Other rationale why the HCP does not plan on using prasugrel','simpleText','Prasugel - DCI','false','8'); 

commit;

rem --------------------------------------------

insert into answer_options_temp values ('No (end of DCI)',1);
insert into answer_options_temp values ('Yes',2);

commit;


execute CREATE_SURVEY_QA(' Did the HCP mention prasugrel''s black box warning, highlighting bleeding risks?','multioptsinglesel','Prasugel - DCI','false','9');

commit;

delete from answer_options_temp;

commit;

rem --------------------------------------------


insert into answer_options_temp values ('Fatal bleeding',1);
insert into answer_options_temp values ('Active pathological bleeding',2);
insert into answer_options_temp values ('History of TIA/stroke',3);
insert into answer_options_temp values ('Age >= years of age',4);
insert into answer_options_temp values ('CABG - if CABG likely, do not start',5);
insert into answer_options_temp values ('For any surgery, discontinue prasugrel at least 7 days prior to any surgery',6);
insert into answer_options_temp values ('Body weight < 60 kg',7);
insert into answer_options_temp values ('Propensity to bleed',8);
insert into answer_options_temp values ('Concomitant use of medications that increase the risk of bleeding',9);
insert into answer_options_temp values ('Other (please specify)',10);


commit;


execute CREATE_SURVEY_QA(' If yes to #9, please check all specific bleeding risks mentioned: (end of DCI)','multioptmultisel','Prasugel - DCI','false','10');

commit;

delete from answer_options_temp;

commit;

rem ---------------------------------------------

execute CREATE_SURVEY_QA(' Other bleeding risks mentioned:(end of DCI)','simpleText','Prasugel - DCI','false','11'); 

commit;

rem --------------------------------------------


insert into answer_options_temp values ('Superior efficacy',1);
insert into answer_options_temp values ('Faster onset of action',2);
insert into answer_options_temp values ('Less variability of response',3);
insert into answer_options_temp values ('No drug-drug interaction concerns',4);
insert into answer_options_temp values ('Ability to see anatomy before using prasugrel',5);
insert into answer_options_temp values ('Impressed with quality and quantity of prasugrel data available',6);
insert into answer_options_temp values ('Benefit/Risk favors prasugrel',7);
insert into answer_options_temp values ('Bleeding is manageable',8);
insert into answer_options_temp values ('Other (specify)',9);
insert into answer_options_temp values ('Did not comment',10);



commit;


execute CREATE_SURVEY_QA(' (Reminder: Only answer questions 12-30 if the HCP plans on using Prasugrel). If the HCP is planning on using prasugrel (or using with caution), did the HCP comment on any factors that may influence treatment decisions around use of prasugrel in clinical practice (Select all that apply)?','multioptmultisel','Prasugel - DCI','false','12');

commit;

delete from answer_options_temp;

commit;

rem ------------------------------------------------ 

execute CREATE_SURVEY_QA(' Other factors the HCP may have commented on that may influence treatment decisions around use of prasugrel in clinical practice','simpleText','Prasugel - DCI','false','13'); 

commit;

rem --------------------------------------------

insert into answer_options_temp values ('High-risk ACS patients',1);
insert into answer_options_temp values ('Stented ACS patients',2);
insert into answer_options_temp values ('Non-stented ACS patients (medically managed)',3);
insert into answer_options_temp values ('Elective PCI',4);
insert into answer_options_temp values ('Stable CAD / history of MI',5);
insert into answer_options_temp values ('Diabetic patients with ACS',6);
insert into answer_options_temp values ('STEMI',7);
insert into answer_options_temp values ('Switching existing Clopidogrel patients to prasugrel (specify)',8);
insert into answer_options_temp values ('Other (specify)',9);
insert into answer_options_temp values ('Did not comment',10);


commit;


execute CREATE_SURVEY_QA(' Did the HCP comment in which patient populations prasugrel may be utilized? (check all that apply)?','multioptmultisel','Prasugel - DCI','false','14');

commit;

delete from answer_options_temp;

commit;

rem ---------------------------------------------


execute CREATE_SURVEY_QA(' Other HCP comments on which patient populations prasugrel may be utilized','simpleText','Prasugel - DCI','false','15'); 


commit;

rem -------------------------------------------- 


insert into answer_options_temp values ('Patients < 75 years of age',1);
insert into answer_options_temp values ('Non-diabetics',2);
insert into answer_options_temp values ('Body weight >= 60kg',3);
insert into answer_options_temp values ('Male patients',4);
insert into answer_options_temp values ('Patients with no other co-morbidities',5);
insert into answer_options_temp values ('Other (please specify)',6);

commit;


execute CREATE_SURVEY_QA(' If HCP commented on prescribing prasugrel for patients at low risk of bleeding, how would they define ''''low risk'''' of bleeding?','multioptsinglesel','Prasugel - DCI','false','16');

commit;

delete from answer_options_temp;

commit;

rem ---------------------------------------------

execute CREATE_SURVEY_QA(' Other HCP definitions of ''''low risk'''' of bleeding','simpleText','Prasugel - DCI','false','17'); 

commit;


rem --------------------------------------------


insert into answer_options_temp values ('Prior TIA/stroke',1);
insert into answer_options_temp values ('Elderly - If applicable specify age',2);
insert into answer_options_temp values ('Low-weight - If applicable specify body weight',3);
insert into answer_options_temp values ('Potential CABG patients',4);
insert into answer_options_temp values ('Other (specify)',5);
insert into answer_options_temp values ('Did not comment',6);


commit;


execute CREATE_SURVEY_QA(' Did the HCP mention any patient sub-groups in which prasugrel may be specifically avoided? (Select all that apply)','multioptmultisel','Prasugel - DCI','false','18');

commit;

delete from answer_options_temp;

commit;

rem ---------------------------------------------

execute CREATE_SURVEY_QA(' Other patient subgroups in which prasugrel may be specifically avoided','simpleText','Prasugel - DCI','false','19'); 

commit;


rem --------------------------------------------



insert into answer_options_temp values ('Prior TIA/stroke',1);
insert into answer_options_temp values ('Elderly - If applicable specify age',2);
insert into answer_options_temp values ('Low-weight - If applicable specify body weight',3);
insert into answer_options_temp values ('Potential CABG patients',4);
insert into answer_options_temp values ('Other (specify)',5);
insert into answer_options_temp values ('Did not comment',6);



commit;


execute CREATE_SURVEY_QA(' Within the patient populations described above where prasugrel may be used by the HCP, did the HCP mention any patient sub-groups in which a lower maintenance dose of prasugrel may be used?  (Select all that apply)','multioptmultisel','Prasugel - DCI','false','20');


commit;

delete from answer_options_temp;

commit;

rem ------------------------------------------------ 

execute CREATE_SURVEY_QA(' Other patient sub-groups in which a lower maintenance dose of prasugrel may be used','simpleText','Prasugel - DCI','false','21'); 

commit;

rem -------------------------------------------- 


insert into answer_options_temp values ('LD upstream, prior to PCI with unknown anatomy',1);
insert into answer_options_temp values ('LD in cath lab after anatomy known, prior to PCI',2);
insert into answer_options_temp values ('LD after PCI',3);
insert into answer_options_temp values ('Other (specify)',4);
insert into answer_options_temp values ('Did not comment',5);



commit;


execute CREATE_SURVEY_QA(' If the HCP plans on using prasugrel in ACS patients who are candidates for PCI, did the HCP comment on which strategy will be chosen?','multioptsinglesel','Prasugel - DCI','false','22');

commit;

delete from answer_options_temp;

commit;

rem ------------------------------------------------ 

execute CREATE_SURVEY_QA(' Other strategies','simpleText','Prasugel - DCI','false','23'); 

commit;

rem -------------------------------------------- 


insert into answer_options_temp values ('Will continue indefinitely',1);
insert into answer_options_temp values ('Will follow same guideline recommendations for clopidogrel in DES patients (i.e. 12 months)',2);
insert into answer_options_temp values ('Prasugrel use in the short-term (<1 month) following PCI, then switch to clopidogrel long-term',3);
insert into answer_options_temp values ('Other (specify)',4);
insert into answer_options_temp values ('Did not comment',5);


commit;


execute CREATE_SURVEY_QA(' If the HCP is planning on using prasugrel, did they comment on how long they would continue it?','multioptsinglesel','Prasugel - DCI','false','24');

commit;

delete from answer_options_temp;

commit;


rem --------------------------------------------

execute CREATE_SURVEY_QA(' Other comments on how long they would continue it','simpleText','Prasugel - DCI','false','25'); 

commit;


rem ------------------------------------------------

insert into answer_options_temp values ('No',1);
insert into answer_options_temp values ('Yes (check all specific bleeding risks mentioned)',2);

commit;


execute CREATE_SURVEY_QA(' Did the HCP specifically comment on black box warning?','multioptsinglesel','Prasugel - DCI','false','26');

commit;

delete from answer_options_temp;

commit;

rem --------------------------------------------


insert into answer_options_temp values ('Fatal bleeding',1);
insert into answer_options_temp values ('Active pathological bleeding',2);
insert into answer_options_temp values ('History of TIA/stroke',3);
insert into answer_options_temp values ('Age >= 75 years of age',4);
insert into answer_options_temp values ('CABG - if CABG likely, do not start',5);
insert into answer_options_temp values ('For any surgery, discontinue prasugrel at least 7 days prior to any surgery',6);
insert into answer_options_temp values ('Body weight < 60 kg',7);
insert into answer_options_temp values ('Propensity to bleed',8);
insert into answer_options_temp values ('Concomitant use of medications that increase the risk of bleeding',9);
insert into answer_options_temp values ('Other (please specify)',10);

commit;


execute CREATE_SURVEY_QA(' If yes to question #26, please check all specific bleeding risks mentioned:','multioptmultisel','Prasugel - DCI','false','27');

commit;

delete from answer_options_temp;

commit;

rem --------------------------------------------

execute CREATE_SURVEY_QA(' Other bleeding risks','simpleText','Prasugel - DCI','false','28'); 

commit;


rem ------------------------------------------------

insert into answer_options_temp values ('Communication from patient',1);
insert into answer_options_temp values ('Medical Records',2);
insert into answer_options_temp values ('Imaging studies',3);
insert into answer_options_temp values ('Other (please specify)',4);
insert into answer_options_temp values ('Did not comment',5);


commit;


execute CREATE_SURVEY_QA(' Since prasugrel is contraindicated in patients with a history of TIA/Stroke, did the HCP indicate how they would determine who has had a history of TIA/Stroke?','multioptsinglesel','Prasugel - DCI','false','29');

commit;

delete from answer_options_temp;

commit;

rem --------------------------------------------



execute CREATE_SURVEY_QA(' Other ways the HCP indicated that they would determine who has had a history of TIA/Stroke','simpleText','Prasugel - DCI','false','30'); 

commit;


rem ------------------------------------------------


rem user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

SPOOL OFF
SET ECHO OFF
exit;


rem : 1>Author name 		: Tapan
rem : 2>Purpose of change	: Prasugrel DCI Survey
rem : 3>Date of change 		: 

rem ------------------------------------------------------------------------------------------------

