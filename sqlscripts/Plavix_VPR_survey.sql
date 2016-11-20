SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : db_changes_BMS_Plavix_VPR_Survey.log
SPOOL db_changes_BMS_Plavix_VPR_Survey.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------



Insert into "SURVEYMETADATA" ("ID","NAME","TYPE","STATE","ACTIVE","DATE_START","DATE_END") 
values (HIBERNATE_SEQUENCE.NEXTVAL,'Plavix VPR','DCI','Launched','true','02/09/2009','02/09/2010');

commit;

rem --------------------------------------

insert into answer_options_temp values	('Interventional Cardiologist',1);
insert into answer_options_temp values	('Clinical Cardiologist',2);
insert into answer_options_temp values	('ED Physician',3);
insert into answer_options_temp values	('Internal Medicine MD',4);
insert into answer_options_temp values	('CT Surgeon',5);
insert into answer_options_temp values	('Hospitalist',6);
insert into answer_options_temp values	('Clinical Pharmacist',7);
insert into answer_options_temp values	('Managed Care OL',8);
insert into answer_options_temp values	('Neurologist',9);
insert into answer_options_temp values	('Other. (specify)',10);

commit;


execute CREATE_SURVEY_QA(' OL Specialty:','multioptsinglesel','Plavix VPR','true','1');

commit;

delete from answer_options_temp;

commit;


rem ----------------------------------------------

execute CREATE_SURVEY_QA(' If you answered other in the previous question, please specify:','simpleText','Plavix VPR','false','2'); 

commit;

rem --------------------------------------------


insert into answer_options_temp values	('Northeast',1);
insert into answer_options_temp values	('Mid-Atlantic',2);
insert into answer_options_temp values	('Southeast',3);
insert into answer_options_temp values	('Mid-West',4);
insert into answer_options_temp values	('South-Central',5);
insert into answer_options_temp values	('South-West',6);
insert into answer_options_temp values	('North-West',7);
insert into answer_options_temp values	('West',8);


commit;

execute CREATE_SURVEY_QA(' OL Location:','multioptsinglesel','Plavix VPR','true','3');

commit;

delete from answer_options_temp;

commit;

rem --------------------------------------------

insert into answer_options_temp values	('Tier 1 (national)',1);
insert into answer_options_temp values	('Tier 2 (regional)',2);
insert into answer_options_temp values	('Tier 3 (local)',3);

commit;


execute CREATE_SURVEY_QA(' OL Tier.','multioptsinglesel','Plavix VPR','true','4');

commit;

delete from answer_options_temp;

commit;

rem --------------------------------------------


insert into answer_options_temp values	('No. (end of DCI)',1);
insert into answer_options_temp values	('Yes. (proceed to question #6)',2);


commit;


execute CREATE_SURVEY_QA(' Did the OL raise the issue of variability of response or hypo-responders to clopidogrel during the visit?','multioptsinglesel','Plavix VPR','true','5');

commit;

delete from answer_options_temp;

commit;

rem ------------------------------------------


insert into answer_options_temp values	('Issues related to genomics (complete questions #8 to #12.)',1);
insert into answer_options_temp values	('Issues related to Drug-Drug Interactions (complete questions #13 and #15.)',2);
insert into answer_options_temp values	('Issues related to underlying disease or co-morbidities (complete questions #16 and #19.)',3);
insert into answer_options_temp values	('Other (specify)',4);


commit;


execute CREATE_SURVEY_QA(' What area or category of variability of response was mentioned? (check all that apply)','multioptmultisel','Plavix VPR','false','6');

commit;

delete from answer_options_temp;

commit;

rem --------------------------------------------

execute CREATE_SURVEY_QA(' If you answered other in the previous question, please specify:','simpleText','Plavix VPR','false','7'); 

commit;

rem -------------------------------------------  


insert into answer_options_temp values	('No. (specify which issues other than CYP2C19)',1);
insert into answer_options_temp values	('Yes. (move to question 9)',2);

commit;


execute CREATE_SURVEY_QA(' Did the OL raise the issue of CYP2C19 polymorphisms during your visit?','multioptsinglesel','Plavix VPR','false','8');

commit;

delete from answer_options_temp;

commit;

rem --------------------------------------------



insert into answer_options_temp values	('No',1);
insert into answer_options_temp values	('Yes. (move to question #10) ',2);

commit;


execute CREATE_SURVEY_QA(' Was the OL familiar with the recently published CPY2C19 polymorphism data?','multioptsinglesel','Plavix VPR','false','9');

commit;

delete from answer_options_temp;

commit;

rem ---------------------------------------------


insert into answer_options_temp values	('No',1);
insert into answer_options_temp values	('Yes. - OL will consider increasing dose of clopidogrel and/or ASA in certain patients',2);
insert into answer_options_temp values	('Yes - OL will consider using newer antiplatelet agents (if available) in certain patients.',3);
insert into answer_options_temp values	('Yes - OL will consider adding additional agents (such as Cilostazol) in certain patients.',4);
insert into answer_options_temp values	('Yes - Other (specify)',5);
insert into answer_options_temp values	('Did not state',6);	


commit;


execute CREATE_SURVEY_QA(' Will these recently published data affect how the OL will use Clopidogrel? (check all that apply)','multioptmultisel','Plavix VPR','false','10');

commit;

delete from answer_options_temp;

commit;


commit;

rem --------------------------------------------  


execute CREATE_SURVEY_QA(' If you answered other in the previous question, please specify:','simpleText','Plavix VPR','false','11'); 

commit;


rem --------------------------------------------- 


insert into answer_options_temp values ('No',1);
insert into answer_options_temp values ('Yes',2);
insert into answer_options_temp values ('Did not state',3);

commit;


execute CREATE_SURVEY_QA(' If genomic testing were available, would OL use genomic testing in patients on clopidogrel?','multioptsinglesel','Plavix VPR','false','12');


commit;

delete from answer_options_temp;

commit;


rem --------------------------------------------



insert into answer_options_temp values ('PPI''s.',1);
insert into answer_options_temp values ('CCB''s',2);
insert into answer_options_temp values ('Other (specify)',3);

commit;


execute CREATE_SURVEY_QA(' Which Drug-Drug Interactions were mentioned?','multioptsinglesel','Plavix VPR','false','13');


commit;

delete from answer_options_temp;

commit;

rem ------------------------------------------------ 

execute CREATE_SURVEY_QA(' If you answered other in the previous question, please specify:','simpleText','Plavix VPR','false','14'); 

commit;

rem -------------------------------------------- 


insert into answer_options_temp values ('No effect.',1);
insert into answer_options_temp values ('OL will increase dose of clopidogrel and/or ASA in patients on these drugs.',2);
insert into answer_options_temp values ('OL will use newer antiplatelet agents (if available) in patients on these drugs.',3);
insert into answer_options_temp values ('OL may use alternative drugs (to PPI''s, CCB''s, etc) when patient is on Clopidogrel.',4);
insert into answer_options_temp values ('Other (specify).',5);
insert into answer_options_temp values ('Did not state.',6);


commit;


execute CREATE_SURVEY_QA(' How will DDI data affect how the OL will use Clopidogrel? (check all that apply)','multioptmultisel','Plavix VPR','false','15');

commit;

delete from answer_options_temp;

commit;

rem ------------------------------------------------ 


insert into answer_options_temp values ('Diabetes.',1);
insert into answer_options_temp values ('Obesity.',2);
insert into answer_options_temp values ('Prior history of ACS.',3);
insert into answer_options_temp values ('Other (specify)',4);

commit;


execute CREATE_SURVEY_QA(' Which co-morbidity or underlying disease was mentioned? (check all that apply)','multioptmultisel','Plavix VPR','false','16'); 

commit;

delete from answer_options_temp;

commit;


rem --------------------------------------------

execute CREATE_SURVEY_QA(' If you answered other in the previous question, please specify:','simpleText','Plavix VPR','false','17'); 

commit;


rem ------------------------------------------------


insert into answer_options_temp values ('No effect.',1);
insert into answer_options_temp values ('OL may consider increase dose of clopidogrel and/or ASA in these patients.',2);
insert into answer_options_temp values ('OL may consider use of newer antiplatelet agents (if available) in these patients.',3);
insert into answer_options_temp values ('OL may consider adding additional agents (such as Cilostazol) in these patients.',4);
insert into answer_options_temp values ('Other (specify).',5);
insert into answer_options_temp values ('Did not state.',6);

commit;


execute CREATE_SURVEY_QA(' How will co-morbidity data effect how OL uses Clopidogrel? (check all that apply)','multioptmultisel','Plavix VPR','false','18'); 

commit;

delete from answer_options_temp;

commit;


rem --------------------------------------------

execute CREATE_SURVEY_QA(' If you answered other in the previous question, please specify:','simpleText','Plavix VPR','false','19'); 

commit;


rem ------------------------------------------------


rem user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

SPOOL OFF
SET ECHO OFF
exit;


rem : 1>Author name 		: Tapan
rem : 2>Purpose of change	: 
rem : 3>Date of change 		: 

rem ------------------------------------------------------------------------------------------------

