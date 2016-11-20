SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : db_changes_BMS_Active_A_DCI_Survey.log
SPOOL db_changes_BMS_Active_A_DCI_Survey.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------



Insert into "SURVEYMETADATA" ("ID","NAME","TYPE","STATE","ACTIVE","DATE_START","DATE_END") 
values (HIBERNATE_SEQUENCE.NEXTVAL,'Active-A DCI','DCI','Launched','true','02/09/2009','02/09/2010');

commit;

rem --------------------------------------

insert into answer_options_temp values	('Cardiac Electrophysiologist',1);
insert into answer_options_temp values	('Interventional cardiologist',2);
insert into answer_options_temp values	('Clinical cardiologist',3);
insert into answer_options_temp values	('Vascular surgery/CT surgery (specify)',4);
insert into answer_options_temp values	('Primary Care/Internal Medicine',5);
insert into answer_options_temp values	('Clinical Pharmacist',6);
insert into answer_options_temp values	('Emergency medicine',7);
insert into answer_options_temp values	('Neurology',8);
insert into answer_options_temp values	('Other (specify)',9);

commit;


execute CREATE_SURVEY_QA(' HCP specialty','multioptsinglesel','Active-A DCI','true','1');

commit;

delete from answer_options_temp;

commit;


rem ----------------------------------------------

execute CREATE_SURVEY_QA(' If you answered other in the previous question, please specify:','simpleText','Active-A DCI','false','2'); 

commit;

rem --------------------------------------------


insert into answer_options_temp values	('Tier 1 (National)',1);
insert into answer_options_temp values	('Tier 2 (Regional)',2);
insert into answer_options_temp values	('Tier 3 (Local)',3);


commit;

execute CREATE_SURVEY_QA(' OL/KTL Tier','multioptsinglesel','Active-A DCI','true','3');

commit;

delete from answer_options_temp;

commit;

rem --------------------------------------------

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);

commit;


execute CREATE_SURVEY_QA(' Did the KOL raise the issue of the ACTIVE-A trial results?','multioptsinglesel','Active-A DCI','true','4');

commit;

delete from answer_options_temp;

commit;

rem --------------------------------------------

insert into answer_options_temp values	('Yes. (question 6)',1);
insert into answer_options_temp values	('No. (end of DCI)',2);
insert into answer_options_temp values	('Somewhat. (question 6)',3);


commit;


execute CREATE_SURVEY_QA(' If yes to 4, was the KOL familiar with data from the ACTIVE A trial presented at ACC?','multioptsinglesel','Active-A DCI','true','5');

commit;

delete from answer_options_temp;

commit;

rem ------------------------------------------


insert into answer_options_temp values	('Was at ACC presentation',1);
insert into answer_options_temp values	('Read NEJM publication',2);
insert into answer_options_temp values	('Heard about it from a colleague',3);
insert into answer_options_temp values	('Read about it in the media',4);
insert into answer_options_temp values	('Other (specify)',5);


commit;


execute CREATE_SURVEY_QA(' How did the KOL know about the results (select all that apply)','multioptmultisel','Active-A DCI','false','6');

commit;

delete from answer_options_temp;

commit;

rem --------------------------------------------

execute CREATE_SURVEY_QA(' If you answered other in the previous question, please specify:','simpleText','Active-A DCI','false','7'); 

commit;

rem -------------------------------------------  

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);
insert into answer_options_temp values	('Did not comment',3);

commit;


execute CREATE_SURVEY_QA(' Was the KOL aware that the positive result in the primary outcome was driven by a reduction in stroke?','multioptsinglesel','Active-A DCI','false','8');

commit;

delete from answer_options_temp;

commit;

rem --------------------------------------------



insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No. Go to 12',2);

commit;


execute CREATE_SURVEY_QA(' Was the KOL concerned about any safety issues with the trial?','multioptsinglesel','Active-A DCI','false','9');

commit;

delete from answer_options_temp;

commit;

rem --------------------------------------------



insert into answer_options_temp values	('Bleeding in general',1);
insert into answer_options_temp values	('Major bleeding specifically',2);
insert into answer_options_temp values	('Intra-cranial hemorrhage in particular',3);
insert into answer_options_temp values	('Intra-cerebral hemorrhage in particular',4);
insert into answer_options_temp values	('Other (specify)',5);

commit;


execute CREATE_SURVEY_QA(' If yes to 9, was the issue raised about: (select all that apply)','multioptmultisel','Active-A DCI','false','10');

commit;

delete from answer_options_temp;

commit;

rem ---------------------------------------------

execute CREATE_SURVEY_QA(' If you answered other in the previous question, please specify:','simpleText','Active-A DCI','false','11'); 

commit;

rem ---------------------------------------------


insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No - data is not strong enough to change their current practice (Go to Q 15)',2);
insert into answer_options_temp values	('No - already use it this way',3);
insert into answer_options_temp values	('Will wait and see',4);
insert into answer_options_temp values	('Only in certain populations',5);
insert into answer_options_temp values	('Did not say',6);



commit;


execute CREATE_SURVEY_QA(' If there was an indication for clopidgrel in AFib patients not willing or not able to take OAC, would the data from this trial change the KOL’s practice to prescribe more C+A in such patients ? (select all that apply)','multioptmultisel','Active-A DCI','false','12');

commit;

delete from answer_options_temp;

commit;


commit;

rem --------------------------------------------  


insert into answer_options_temp values	('All pts unwilling to take OAC',1);
insert into answer_options_temp values	('Most pts unwilling to take OAC',2);
insert into answer_options_temp values	('All pts unable to take OAC (e.g. risk of falling, contra-indications, etc.)',3);
insert into answer_options_temp values	('Most pts unable to take OAC (e.g., risk of falling, contra-indications, etc)',4);
insert into answer_options_temp values	('OAC patients unable to control their anti-coagulation (e.g. unable to get them to INR goal)',5);
insert into answer_options_temp values	('Patients on ASA who are at higher risk of stroke (specify)',6);
insert into answer_options_temp values	('Patients on ASA for AF irrespective of their stroke risk',7);
insert into answer_options_temp values	('Other (specify)',8);
insert into answer_options_temp values	('Didn''t say',9);


commit;


execute CREATE_SURVEY_QA(' Once approved, if the physician were to use C+A in the AF patient population, did they state which patient populations they would use it in (a or e in Q#12) or are currently using it in (c in Q#12)?: (select all that apply)','multioptmultisel','Active-A DCI','false','13');

commit;

delete from answer_options_temp;

commit;


rem --------------------------------------------  


execute CREATE_SURVEY_QA(' If you answered other in the previous question, please specify:','simpleText','Active-A DCI','false','14'); 

commit;


rem --------------------------------------------- 


insert into answer_options_temp values ('Definition of patient population (unwilling or unable) is unclear',1);
insert into answer_options_temp values ('They do not see this patient population (unwilling or unable) in their practice',2);
insert into answer_options_temp values ('ASA treatment is adequate for patients not on OAC',3);
insert into answer_options_temp values ('Data is questionable as trial was too small',4);
insert into answer_options_temp values ('Bleeding risk outweighs efficacy',5);
insert into answer_options_temp values ('Patients unwilling to take OAC will not be willing to take C+A',6);
insert into answer_options_temp values ('Other (specify)',7);


commit;


execute CREATE_SURVEY_QA(' If KOL indicated that the data was not strong enough to change their current practice patterns in Question 12b, did they state what their primary concern was with the data? (select all that apply)','multioptmultisel','Active-A DCI','false','15');


commit;

delete from answer_options_temp;

commit;


rem --------------------------------------------

execute CREATE_SURVEY_QA(' If you answered other in the previous question, please specify:','simpleText','Active-A DCI','false','16'); 

commit;


rem --------------------------------------------- 


rem user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

SPOOL OFF
SET ECHO OFF
exit;


rem : 1>Author name 		: Tapan
rem : 2>Purpose of change	: 
rem : 3>Date of change 		: 

rem ------------------------------------------------------------------------------------------------

