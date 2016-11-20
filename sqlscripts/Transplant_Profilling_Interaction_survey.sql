SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : Transplant Profiling .log
SPOOL Transplant Profiling .log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------

update SURVEYMETADATA set name = 'Transplant Profiling Ended_'||( select to_char(sysdate, 'MM/DD/YYYY') from dual ), DATE_END = ( select to_char(sysdate, 'MM/DD/YYYY') from dual ) where name = 'Transplant Profiling';

delete from FEATURE_USERGROUP_MAP where FEATURE_ID in ( select id from SURVEYMETADATA where name = 'Transplant Profiling Ended_'||( select to_char(sysdate, 'MM/DD/YYYY') from dual ) ) and PERMISSION_ON_FEATURE = 3;

rem -------------------------------------------------------------------------------------------------

Insert into "SURVEYMETADATA" ("ID","NAME","TYPE","STATE","ACTIVE","DATE_START","DATE_END") 
values (HIBERNATE_SEQUENCE.NEXTVAL,'Transplant Profiling','Interactions','Launched','true', ( select to_char(sysdate, 'MM/DD/YYYY') from dual ), ( select to_char(sysdate + numtoyminterval(1, 'YEAR'), 'MM/DD/YYYY') from dual ));

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);
insert into answer_options_temp values	('NA',3);


execute CREATE_SURVEY_QA('Are you involved in research?','multioptsinglesel','Transplant Profiling','false','1');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Clinical',1);
insert into answer_options_temp values	('Bench',2);
insert into answer_options_temp values	('Both',3);
insert into answer_options_temp values	('NA',4);


execute CREATE_SURVEY_QA('Which are your areas of research interest?','multioptsinglesel','Transplant Profiling','false','2');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);
insert into answer_options_temp values	('NA',3);


execute CREATE_SURVEY_QA('Do you collaborate with industry if you have common research interests?','multioptsinglesel','Transplant Profiling','false','3');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);
insert into answer_options_temp values	('NA',3);

execute CREATE_SURVEY_QA('Are you the lead for the research lab/team?','multioptsinglesel','Transplant Profiling','false','4');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('What is your typical research-supporting FTE support?','simpleText','Transplant Profiling','false','5');

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);
insert into answer_options_temp values	('NA',3);

execute CREATE_SURVEY_QA('Are your lab resources under your control?','multioptsinglesel','Transplant Profiling','false','6');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);
insert into answer_options_temp values	('Maybe',3);
insert into answer_options_temp values	('NA',4);

execute CREATE_SURVEY_QA('Does your institution use a central IRB?','multioptsinglesel','Transplant Profiling','false','7');

delete from answer_options_temp;


rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('Do you foresee any difficulties conducting research with a pharmaceutical company or conflicts within your institution policy to be able to work with industry?','simpleText','Transplant Profiling','false','8'); 

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('If there is no policy against conducting research with industry, what may be other barriers for conducting research?','simpleText','Transplant Profiling','false','9'); 

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('What percentage of your patients are currently enrolled in clinical trials/year?','simpleText','Transplant Profiling','false','10'); 

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('What are your institution''s capabilities/resources with regard to clinical/bench research ?','simpleText','Transplant Profiling','false','11'); 

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);
insert into answer_options_temp values	('Maybe',3);
insert into answer_options_temp values	('NA',4);

execute CREATE_SURVEY_QA('Is your research center capable of conducting research involving an infusible therapy?','multioptsinglesel','Transplant Profiling','false','12');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('What is your proportion of living related donor (LRD), donation after cardiac  death (DCD), extended criteria donor (ECD) organ use in your institution? ','simpleText','Transplant Profiling','false','13'); 

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('What are your standard induction protocols? ','simpleText','Transplant Profiling','false','14'); 

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);
insert into answer_options_temp values	('NA',3);

execute CREATE_SURVEY_QA('Is your induction strategy different for DCD or ECD as opposed to LRD organs?','multioptsinglesel','Transplant Profiling','false','15');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('Induction comments','simpleText','Transplant Profiling','false','16');

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('What are the demographics of patients who seek your expertise in transplantation? ','simpleText','Transplant Profiling','false','17');

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);
insert into answer_options_temp values	('NA',3);

execute CREATE_SURVEY_QA('Do you have patients who have high immunologic risk?','multioptsinglesel','Transplant Profiling','false','18');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('If yes, what is the percentage? ','simpleText','Transplant Profiling','false','19');

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('What patient characteristics do you consider to be high-risk? ','simpleText','Transplant Profiling','false','20');

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('Who do you think about when it comes to research?','simpleText','Transplant Profiling','false','21');

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);
insert into answer_options_temp values	('NA',3);

execute CREATE_SURVEY_QA('Do you perform time-zero biopsies?','multioptsinglesel','Transplant Profiling','false','22');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);
insert into answer_options_temp values	('NA',3);

execute CREATE_SURVEY_QA('Do you perform surveillance biopsies?','multioptsinglesel','Transplant Profiling','false','23');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('If so, when? ','simpleText','Transplant Profiling','false','24');

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('What is your approach if subclinical rejection is evident? ','simpleText','Transplant Profiling','false','25');

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('What are your procedures for diagnosing acute rejection?','simpleText','Transplant Profiling','false','26');

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);
insert into answer_options_temp values	('NA',3);

execute CREATE_SURVEY_QA('Do you assess for donor-specific antibodies (DSA)?','multioptsinglesel','Transplant Profiling','false','27');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);
insert into answer_options_temp values	('Maybe',3);
insert into answer_options_temp values	('NA',4);


execute CREATE_SURVEY_QA('Do you routinely use C4d staining?','multioptsinglesel','Transplant Profiling','false','28');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('What would be your estimate of your institution''s acute rejection rate per year? ','simpleText','Transplant Profiling','false','29');

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('What is your therapeutic approach to the treatment of various grades/levels of rejection?','simpleText','Transplant Profiling','false','30');

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('What characteristics do you consider to be higher immunologic risk?','simpleText','Transplant Profiling','false','31');

rem -------------------------------------------------------------------------------------------------


insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);
insert into answer_options_temp values	('NA',3);


execute CREATE_SURVEY_QA('Do you perform desensitization strategies?','multioptsinglesel','Transplant Profiling','false','32');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('If so, what strategies do you use? ','simpleText','Transplant Profiling','false','33');

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('Who would you approach for clinical advice?  ','simpleText','Transplant Profiling','false','34');

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);
insert into answer_options_temp values	('NA',3);


execute CREATE_SURVEY_QA('Do you use GFR in your institution in assessing kidney function?','multioptsinglesel','Transplant Profiling','false','35');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('If so, since when? ','simpleText','Transplant Profiling','false','36');

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Printed Journals',1);
insert into answer_options_temp values	('Online Journals',2);
insert into answer_options_temp values	('On-line',3);
insert into answer_options_temp values	('Web casts',4);
insert into answer_options_temp values	('Other',5);


execute CREATE_SURVEY_QA('How do you keep up to date?','multioptmultisel','Transplant Profiling','false','37');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('Other','simpleText','Transplant Profiling','false','38');

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);
insert into answer_options_temp values	('NA',3);


execute CREATE_SURVEY_QA('Could I have a copy of your CV and/or publication record?','multioptsinglesel','Transplant Profiling','false','39');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------


insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);
insert into answer_options_temp values	('NA',3);


execute CREATE_SURVEY_QA('Do you serve as a speaker for other pharmaceutical or device companies','multioptsinglesel','Transplant Profiling','false','40');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------


insert into answer_options_temp values	('Astellas',1);
insert into answer_options_temp values	('Genetech',2);
insert into answer_options_temp values	('Genzyme',3);
insert into answer_options_temp values	('LyfeCycle Pharma',4);
insert into answer_options_temp values	('Novartis',5);
insert into answer_options_temp values	('Pfizer',6);
insert into answer_options_temp values	('Roche',7);
insert into answer_options_temp values	('Schering-Plough',8);
insert into answer_options_temp values	('Wyeth',9);
insert into answer_options_temp values	('other',10);

execute CREATE_SURVEY_QA('If yes, which one(s): ','multioptmultisel','Transplant Profiling','false','41');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('Other','simpleText','Transplant Profiling','false','42');

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);
insert into answer_options_temp values	('NA',3);


execute CREATE_SURVEY_QA('Does your institution have barriers or institutional policies on speaking for pharmaceutical companies (ie. cannot speak unless they are in full control of the slides)?','multioptsinglesel','Transplant Profiling','false','43');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('If Yes, please explain ','simpleText','Transplant Profiling','false','44');

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('AST',1);
insert into answer_options_temp values	('ASTS',2);
insert into answer_options_temp values	('TTS',3);
insert into answer_options_temp values	('ASN',4);
insert into answer_options_temp values	('NKF',5);
insert into answer_options_temp values	('FACS',6);
insert into answer_options_temp values	('FASN',7);
insert into answer_options_temp values	('other',8);

execute CREATE_SURVEY_QA('What are your society memberships?','multioptmultisel','Transplant Profiling','false','45');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('Other ','simpleText','Transplant Profiling','false','46');

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('Who do you tend to listen to as a thought leader?  ','simpleText','Transplant Profiling','false','47');

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('What clinical/scientific experts would you be willing to travel for to listen to at a breakfast/lunch/dinner meeting?  ','simpleText','Transplant Profiling','false','48');

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('What clinical/scientific experts would you be willing to travel for to listen to at a conference?','simpleText','Transplant Profiling','false','49');

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);
insert into answer_options_temp values	('Maybe',3);
insert into answer_options_temp values	('NA',4);

execute CREATE_SURVEY_QA('Would you be interested in being a member of an advisory board?','multioptsinglesel','Transplant Profiling','false','50');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('What are your clinical and research areas of interest?','simpleText','Transplant Profiling','false','51');

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('What area(s) do you consider yourself to be an expert? ','simpleText','Transplant Profiling','false','52');

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('Do you have any additional expertise such as bench research; trial design; analysis of clinical or registry databases; or economic, pharmacoeconomic, genomic, or transcription data?','simpleText','Transplant Profiling','false','53');

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('What do you consider to be a great short-term unmet medical need for transplant patients? ','simpleText','Transplant Profiling','false','54');

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('What do you consider to be a great long-term unmet medical need for transplant patients?','simpleText','Transplant Profiling','false','55');

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('Which scientific editorial boards do you sit on ?','simpleText','Transplant Profiling','false','56');

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);
insert into answer_options_temp values	('Maybe',3);
insert into answer_options_temp values	('NA',4);

execute CREATE_SURVEY_QA('Are you an advisor to any Government agency?','multioptsinglesel','Transplant Profiling','false','57');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------


insert into answer_options_temp values	('Yes',1);
insert into answer_options_temp values	('No',2);
insert into answer_options_temp values	('Maybe',3);
insert into answer_options_temp values	('NA',4);

execute CREATE_SURVEY_QA('Are you associated with any federal or state associations that may limit your ability to participate in pharmaceutical-sponsored activities? ','multioptsinglesel','Transplant Profiling','false','58');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA('Summary','simpleText','Transplant Profiling','false','59');

rem -------------------------------------------------------------------------------------------------


rem : group permission

insert into FEATURE_USERGROUP_MAP (ID, FEATURE_ID, USERGROUP_ID, PERMISSION_ON_FEATURE) 
values (HIBERNATE_SEQUENCE.NEXTVAL, (select id from SURVEYMETADATA where name = 'Transplant Profiling'),
','||( select groupid from groups where groupname = 'FRONT_END_ADMIN')||',', 3);

rem --------------------------------------------------------------------------------------------------

commit;

rem --------------------------------------------------------------------------------------------------

rem user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

SPOOL OFF

SET ECHO OFF

exit;

