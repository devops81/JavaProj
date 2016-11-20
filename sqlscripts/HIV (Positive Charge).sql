SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : HIV(Positive_Charge).log
SPOOL HIV(Positive_Charge).log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------

update SURVEYMETADATA set name = 'HIV (Positive Charge)_'||( select to_char(sysdate, 'MM/DD/YYYY') from dual ), DATE_END = ( select to_char(sysdate, 'MM/DD/YYYY') from dual ) where name = 'HIV (Positive Charge)';

delete from FEATURE_USERGROUP_MAP where FEATURE_ID in ( select id from SURVEYMETADATA where name = 'HIV (Positive Charge)_'||( select to_char(sysdate, 'MM/DD/YYYY') from dual ) ) and PERMISSION_ON_FEATURE = 3;

rem -------------------------------------------------------------------------------------------------

Insert into "SURVEYMETADATA" ("ID","NAME","TYPE","STATE","ACTIVE","DATE_START","DATE_END") 
values (HIBERNATE_SEQUENCE.NEXTVAL,'HIV (Positive Charge)','DCI','Launched','true', ( select to_char(sysdate, 'MM/DD/YYYY') from dual ), ( select to_char(sysdate + numtoyminterval(1, 'YEAR'), 'MM/DD/YYYY') from dual ));

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('National',1);
insert into answer_options_temp values	('Regional A',2);
insert into answer_options_temp values	('Regional B',3);

execute CREATE_SURVEY_QA(' What is the TL Sphere of Influence?','multioptsinglesel','HIV (Positive Charge)','false','1');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('yes',1);
insert into answer_options_temp values	('no',2);

execute CREATE_SURVEY_QA(' Does this TL give promotional presentations on BMS'' behalf?','multioptsinglesel','HIV (Positive Charge)','false','2');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('If patient is ready and requests treatment',1);
insert into answer_options_temp values	('If patient is assumed to have potential for good adherence',2);
insert into answer_options_temp values	('If other co-morbidities are present (HepB, HIVAN, etc)',3);
insert into answer_options_temp values	('If patient is older',4);
insert into answer_options_temp values	('If patient is pregnant',5);
insert into answer_options_temp values	('I do not typically see patients with a CD4 count > 350',6);
insert into answer_options_temp values	('Other',7);

execute CREATE_SURVEY_QA(' When do you initiate treatment in patients with a CD4 count > 350?  Choose all that apply:','multioptmultisel','HIV (Positive Charge)','false','3');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','HIV (Positive Charge)','false','4');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Improved immune function',1);
insert into answer_options_temp values	('Prevention of opportunistic diseases',2);
insert into answer_options_temp values	('Reduced secondary complications (CV, renal, hepatic)',3);
insert into answer_options_temp values	('Prevention of transmission',4);
insert into answer_options_temp values	('Other',5);

execute CREATE_SURVEY_QA(' What do you consider to be the benefits of starting therapy earlier?  Choose all that apply:','multioptmultisel','HIV (Positive Charge)','false','5');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','HIV (Positive Charge)','false','6');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------


insert into answer_options_temp values	('Lack of access to care/financial (co-pays, waiting lists, lack of transportation to clinic, etc)',1);
insert into answer_options_temp values	('Lack of family/social support',2);
insert into answer_options_temp values	('Psychiatric illness',3);
insert into answer_options_temp values	('Ethanol/drug abuse',4);
insert into answer_options_temp values	('Fear of stigma/fear of people knowing',5);
insert into answer_options_temp values	('Fear of side effects',6);
insert into answer_options_temp values	('Patients with known infection, not presenting for care until symptomatic',7);
insert into answer_options_temp values	('Patients not being diagnosed until they are symptomatic',8);
insert into answer_options_temp values	('Risk of ARV side effects and potential to develop resistance to ARVs',9);
insert into answer_options_temp values	('Other',10);

execute CREATE_SURVEY_QA(' What do you consider to be the barriers to initiating treatment earlier (CD4 count > 350) Choose all that apply:','multioptmultisel','HIV (Positive Charge)','false','7');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','HIV (Positive Charge)','false','8');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Information available at screening/intake centers about local providers',1);
insert into answer_options_temp values	('Provide child care services while mother is in clinic',2);
insert into answer_options_temp values	('Allow for scheduling of mother and child visits on same day if child is positive and if clinic sees adults and children',3);
insert into answer_options_temp values	('Support groups specifically for women and for women with children',4);
insert into answer_options_temp values	('Address psychiatric illnesses',5);
insert into answer_options_temp values	('Substance abuse programs',6);
insert into answer_options_temp values	('Enhance adherence counseling',7);
insert into answer_options_temp values	('Provide primary care to minimize the need to see multiple providers',8);
insert into answer_options_temp values	('Patient friendly internet educational information',9);
insert into answer_options_temp values	('Other',10);

execute CREATE_SURVEY_QA(' What local strategies and resources are most effective at enabling HIV+ women to be engaged and linked to care?  Choose all that apply:','multioptmultisel','HIV (Positive Charge)','false','9');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','HIV (Positive Charge)','false','10');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

insert into answer_options_temp values	('Information available at screening/intake centers about local providers',1);
insert into answer_options_temp values	('Address language and literacy needs',2);
insert into answer_options_temp values	('Address psychiatric illnesses',3);
insert into answer_options_temp values	('Substance abuse programs',4);
insert into answer_options_temp values	('Enhance adherence counseling',5);
insert into answer_options_temp values	('Provide primary care to minimize the need to see multiple providers',6);
insert into answer_options_temp values	('Patient friendly internet educational information',7);
insert into answer_options_temp values	('Outreach/community liaison',8);
insert into answer_options_temp values	('Other',9);

execute CREATE_SURVEY_QA(' What local strategies and resources are most effective at enabling individuals of different ethnic/racial backgrounds to be engaged and linked to care?  Choose all that apply:','multioptmultisel','HIV (Positive Charge)','false','11');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

execute CREATE_SURVEY_QA(' Other','simpleText','HIV (Positive Charge)','false','12');

delete from answer_options_temp;

rem -------------------------------------------------------------------------------------------------

rem : group permission

insert into FEATURE_USERGROUP_MAP (ID, FEATURE_ID, USERGROUP_ID, PERMISSION_ON_FEATURE) 
values (HIBERNATE_SEQUENCE.NEXTVAL, (select id from SURVEYMETADATA where name = 'HIV (Positive Charge)'),
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
rem : 2>Purpose         	: Script to create the new "HIV (Positive Charge) Survey"
rem : 3>Date of creation	: 03-Feb-2010

rem ------------------------------------------------------------------------------------------------

