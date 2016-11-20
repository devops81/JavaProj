SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : db_changes_BMS_MedicalIntelligenceSurvey.log
SPOOL db_changes_script_BMS_MedicalIntelligenceSurvey.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------


CREATE TABLE "ANSWER_OPTIONS_TEMP" 
   (	"VALUE" VARCHAR2(4000 BYTE) NOT NULL ENABLE, 
	"OPTION_ORDER" NUMBER
   ) ;



create or replace procedure CREATE_SURVEY_QA 
 (QUESTIONTEXT VARCHAR2, QUESTIONTYPE VARCHAR2, PARENTSURVEY VARCHAR2,ISMANDATORY VARCHAR2, QUESTIONNUMBER VARCHAR2)
 AS
parentQuestion_id number;
hibernateNextVal number;
parentSurvey_Id number;
tempValue varchar2(4000);
tempOrder number;
cursor c2 is select value,option_order from answer_options_temp;
BEGIN
  open c2;
  fetch c2 into tempValue,tempOrder;
  select HIBERNATE_SEQUENCE.NEXTVAL into parentQuestion_id from dual;
  select id into parentSurvey_Id from surveymetadata where name=PARENTSURVEY;  
  Insert into SURVEYQUESTIONSMETADATA ("ID","SURVEYID","QUESTIONTEXT","TYPE","MANDATORY","QUESTIONNUMBER") values (parentQuestion_id,parentSurvey_Id,QUESTIONTEXT,QUESTIONTYPE,ISMANDATORY,QUESTIONNUMBER);
  if(c2%FOUND) then
      while(c2%found)
      loop
         select HIBERNATE_SEQUENCE.NEXTVAL into hibernateNextVal from dual;
	 Insert into SURVEYANSWERSDATA("ID","QUESTIONID","ANSWERTEXT","OPTION_ORDER") values (hibernateNextVal,parentQuestion_id,tempValue,tempOrder);
	 fetch c2 into tempValue,tempOrder;
      end loop; 
      end if;
 END;

.
run:

Insert into "SURVEYMETADATA" ("ID","NAME","TYPE","STATE","ACTIVE","DATE_START","DATE_END") values (HIBERNATE_SEQUENCE.NEXTVAL,'Medical Intelligence','Medical Intelligence','Launched','true','01/23/2009','12/23/2009');

commit;

insert into answer_options_temp values ('CV',1);
insert into answer_options_temp values ('MET',2);
insert into answer_options_temp values ('NS',3);
insert into answer_options_temp values ('Onc',4);
insert into answer_options_temp values ('IMS',5);
insert into answer_options_temp values ('Vir',6);

commit;

execute CREATE_SURVEY_QA(' Therapeutic Area Impacted','multioptmultisel','Medical Intelligence','true','1');

commit;

delete from answer_options_temp;

commit;


insert into answer_options_temp values ('Androgen Receptor Antagonist (Cancer)',1);
insert into answer_options_temp values ('IGF-1R Antagonist (Cancer)',2);
insert into answer_options_temp values ('VEGF R-2 Inhibitor (Cancer)',3);
insert into answer_options_temp values ('ErbB/VEGF Receptor Inhibitor (Cancer)',4);
insert into answer_options_temp values ('Anti-CD137 Antibody (Cancer)',5);
insert into answer_options_temp values ('Epothilone-Folate (Cancer)',6);
insert into answer_options_temp values ('Met Kinase Inhibitors (Cancer)',7);
insert into answer_options_temp values ('SMO Inhibitor (Cancer)',8);
insert into answer_options_temp values ('Hsp90 Inhibitor (Cancer)',9);
insert into answer_options_temp values ('Cdc7 Inhibitor (Cancer)',10);
insert into answer_options_temp values ('p38 Kinase Inhibitors (Rheumatoid Arthritis)',11);
insert into answer_options_temp values ('GR Agonists (Immunology)',12);
insert into answer_options_temp values ('11ßHSD Inhibitors (Diabetes)',13);
insert into answer_options_temp values ('DPP4 Inhibitor (Diabetes)',14);
insert into answer_options_temp values ('Glucokinase Activator (Diabetes)',15);
insert into answer_options_temp values ('CB1 Antagonist (Obesity)',16);
insert into answer_options_temp values ('CCR2 Antagonist (CV/Met)',17);
insert into answer_options_temp values ('DGAT Inhibitors (CV/Met)',18);
insert into answer_options_temp values ('LXR Agonist (Atherosclerosis)',19);
insert into answer_options_temp values ('PCSK9 Inhibitor (Cardiovascular)',20);
insert into answer_options_temp values ('Delta PKC Inhibitor (Cardiovascular)',21);
insert into answer_options_temp values ('Triple Reuptake Inhibitor (Depression)',22);
insert into answer_options_temp values ('GABA-A Modulator (Anxiety)',23);
insert into answer_options_temp values ('Gamma Secretase Inhibitor (Alzheimer’s)',24);
insert into answer_options_temp values ('Microtubule Stabilizer (Alzheimer’s)',25);
insert into answer_options_temp values ('HCV Inhibitor Target 1 (Hepatitis C)',26);
insert into answer_options_temp values ('HCV Inhibitor Target 2 (Hepatitis C)',27);
insert into answer_options_temp values ('HCV Inhibitors Target 3 (Hepatitis C)',28);
insert into answer_options_temp values ('HIV Attachment Inhibitor (HIV/AIDS)',29);
insert into answer_options_temp values ('HIV Integrase Inhibitor (HIV/AIDS)',30);
insert into answer_options_temp values ('IXEMPRA (ixabepilone) (Cancer)',31);
insert into answer_options_temp values ('Ipilimumab (Cancer)',32);
insert into answer_options_temp values ('Brivanib (Cancer)',33);
insert into answer_options_temp values ('Tanespimycin (Cancer)',34);
insert into answer_options_temp values ('Belatacept (Solid Organ Transplant)',35);
insert into answer_options_temp values ('ONGLYZA (saxagliptin) (Diabetes)',36);
insert into answer_options_temp values ('Dapagliflozin (Diabetes)',37);
insert into answer_options_temp values ('Apixaban (Thrombosis)',38);
insert into answer_options_temp values ('SPRYCEL',39);
insert into answer_options_temp values ('ERBITUX',40);
insert into answer_options_temp values ('ORENCIA',41);
insert into answer_options_temp values ('PLAVIX',42);
insert into answer_options_temp values ('AVAPRO/AVALIDE',43);
insert into answer_options_temp values ('ABILIFY',44);
insert into answer_options_temp values ('BARACLUDE',45);
insert into answer_options_temp values ('REYATAZ',46);
insert into answer_options_temp values ('SUSTIVA/ATRIPLA',47);
insert into answer_options_temp values ('Other',48);

commit;


execute CREATE_SURVEY_QA(' Product/Compound Impacted','multioptmultisel','Medical Intelligence','true','2');

commit;

delete from answer_options_temp;

commit;


insert into answer_options_temp values ('US Strategy',1);
insert into answer_options_temp values ('Managed Markets',2);
insert into answer_options_temp values ('R and D',3);

commit;

execute CREATE_SURVEY_QA(' Medical Intelligence Stakeholder ','multioptmultisel','Medical Intelligence','true','3'); 

commit;

delete from answer_options_temp;

commit;


insert into answer_options_temp values ('OL',1);
insert into answer_options_temp values ('Industry Professional',2);
insert into answer_options_temp values ('Other',3);

commit;

execute CREATE_SURVEY_QA(' Medical Intelligence source type (If Other, please answer 7)','multioptsinglesel','Medical Intelligence','true','4'); 

commit;

delete from answer_options_temp;

commit;


execute CREATE_SURVEY_QA(' Other Medical Intelligence source type','simpleText','Medical Intelligence','false','5'); 

commit;





insert into answer_options_temp values ('Clinical trial–Marketed brand',1);
insert into answer_options_temp values ('Clinical trial–Investigational compound',2);
insert into answer_options_temp values ('Outcomes',3);
insert into answer_options_temp values ('Industry news/Sales/Promotions',4);
insert into answer_options_temp values ('Medical Education',5);
insert into answer_options_temp values ('Regulatory/FDA/filings',6);
insert into answer_options_temp values ('Other',7); 

commit;

execute CREATE_SURVEY_QA(' Type of Medical Intelligence (If Other, please answer 9)','multioptmultisel','Medical Intelligence','true','6'); 

commit;

delete from answer_options_temp;

commit;

execute CREATE_SURVEY_QA(' Other Type of Medical Intelligence','simpleText','Medical Intelligence','false','7'); 

commit;


execute CREATE_SURVEY_QA(' Summarize medical intelligence','simpleText','Medical Intelligence','true','8'); 

commit;

rem : 1>Author name 		: Kiruba
rem : 2>Purpose of change	: To add Medical Intelligence Survey into the SurveyMetadata
rem : 3>Date of change 		: 29-January-2009

rem ------------------------------------------------------------------------------------------------


insert into feature_usergroup_map values (HIBERNATE_SEQUENCE.NEXTVAL,(select id from surveymetadata where name='Medical Intelligence'),',83397592,83397593,84702161,83397591,',3);

commit;

rem : 1>Author name 		: Kiruba
rem : 2>Purpose of change	: To give permissions for all groups for Medical Intelligence survey
rem : 3>Date of change 		: 29-January-2009

rem ------------------------------------------------------------------------------------------------