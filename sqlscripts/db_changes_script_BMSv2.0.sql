rem ------------------------------------------------------------------------------------------------
rem Filename    :   db_changes_script_BMSv2.0.sql
rem Purpose	:   SQL changes for version 2.0
rem             
rem Date	:   21-Aug-2009
rem Author	:   Yatin
rem ------------------------------------------------------------------------------------------------

SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : db_changes_script_BMSv2.0.log
SPOOL db_changes_script_BMSv2.0.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------

rem : Batch : 1

delete from expertdna_privileges where privilege_id=85543661 and group_id=83397593 and user_type=2 and feature_key like 'Expert.BMS_Info.CVMET_Attributes';
delete from expertdna_privileges where privilege_id=85543662 and group_id=83397591 and user_type=2 and feature_key like 'Expert.BMS_Info.CVMET_Attributes';

rem : 1>Author name 		: Yatin
rem : 2>Purpose of change	: To delete specific entries from ExpertDna_Privileges table
rem : 3>Date of change 		: 30-Aug-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 2

DELETE FROM expertdna_privileges WHERE rowid NOT IN (SELECT min(rowid) FROM expertdna_privileges GROUP BY group_id, user_type, feature_key);

rem : 1>Author name 		: Yatin
rem : 2>Purpose of change	: To delete all duplicate entries from ExpertDna_Privileges table
rem : 3>Date of change 		: 21-Aug-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 3

alter table expertdna_privileges add constraint EXPERTDNA_PRIVILEGES_PK unique (GROUP_ID, USER_TYPE, FEATURE_KEY);

rem : 1>Author name 		: Yatin
rem : 2>Purpose of change	: To add constraint in ExpertDna_Privileges table
rem : 3>Date of change 		: 21-Aug-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 4

update option_lookup set optvalue = REPLACE(optvalue,CHR(10),'') where optvalue like '%Abilify-Discuss and gain insights on the role of aripiprazole as an effective and safe treatment choice across the continuum of care in schizophrenia%';
update option_lookup set optvalue = REPLACE(optvalue,CHR(10),'') where optvalue like '%Abilify-Discuss and gain insights on aripiprazole as an effective and safe treatment choice in the treatment of pediatric patients with major psychiatric disorders%';

rem : 1>Author name 		: Yatin
rem : 2>Purpose of change	: To remove newline character in two records of Educational Dialogue in Interaction Page 
rem : 3>Date of change 		: 31-Aug-2009

rem ------------------------------------------------------------------------------------------------


commit;

rem user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

SPOOL OFF


SET ECHO OFF



exit;




rem ------------------------------------------------------------------------------------------------

