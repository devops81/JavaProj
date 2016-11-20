rem ------------------------------------------------------------------------------------------------
rem Filename    :   db_changes_script_BMSv2.1.sql
rem Purpose	:   SQL changes for version 2.1
rem             
rem Date	:   11-Sep-2009
rem Author	:   Yatin
rem ------------------------------------------------------------------------------------------------

SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : db_changes_script_BMSv2.1.log
SPOOL db_changes_script_BMSv2.1.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------

rem : Batch : 1

update option_lookup set optvalue = 'MPTL' where optvalue = 'MPOL';
ALTER TRIGGER STRING_AUDIT DISABLE;
update string_attribute set value = 'MPTL' where value = 'MPOL';
ALTER TRIGGER STRING_AUDIT ENABLE;

rem : 1>Author name 		: Yatin
rem : 2>Purpose of change	: To change MPOL to MPTL in tables
rem : 3>Date of change 		: 11-Sep-2009

rem ------------------------------------------------------------------------------------------------


rem : Batch : 2

ALTER TABLE EVENTS ADD ("COUNTRY" NUMBER(19, 0));

rem : 1>Author name 		: Vinay Rao
rem : 2>Purpose of change	: To add country to events table
rem : 3>Date of change 		: 16-Sep-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 4

update attributetable set name = REPLACE(name,'OL','TL') where name like 'OL%' or name like '% OL%';

rem : 1>Author name 		: Yatin
rem : 2>Purpose of change	: To change OL to TL in AttributeTable
rem : 3>Date of change 		: 23-Sep-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 5

 CREATE TABLE SITES
   (	"ID" NUMBER(19,0), 
	"PROTOCOL_NUMBER" VARCHAR2(4000 BYTE) NOT NULL ENABLE, 
	"SITE_REFERENCE" NUMBER(19,0) DEFAULT 0 NOT NULL ENABLE, 
	"INVESTIGATOR_TITLE" VARCHAR2(4000 BYTE), 
	"FORENAME" VARCHAR2(4000 BYTE), 
	"SURNAME" VARCHAR2(4000 BYTE), 
	"CENTERNAME" VARCHAR2(4000 BYTE) NOT NULL ENABLE, 
	"PURPOSE" VARCHAR2(4000 BYTE), 
	"ADDRESS" VARCHAR2(4000 BYTE), 
	"CITY" VARCHAR2(4000 BYTE) NOT NULL ENABLE, 
	"PROVINCE_COUNTY" VARCHAR2(4000 BYTE) NOT NULL ENABLE, 
	"POASTAL_CODE" VARCHAR2(4000 BYTE), 
	"COUNTRY" VARCHAR2(4000 BYTE), 
	"TELEPHONE_NUMBER" VARCHAR2(4000 BYTE), 
	"FAX_NUMBER" VARCHAR2(4000 BYTE), 
	"MIDDLENAME" VARCHAR2(4000 BYTE), 
	 CONSTRAINT "SITES_PK" PRIMARY KEY ("ID") ENABLE
   ) ;
 


rem : 1>Author name 		: Tapan
rem : 2>Purpose of change	: To add new table sites
rem : 3>Date of change 		: 23-Sep-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 6

update user_table set staffid = trim(staffid);
update contacts set staffid = trim(staffid);

rem : 1>Author name 		: Yatin
rem : 2>Purpose of change	: To trim StaffId in user_table and contacts table
rem : 3>Date of change 		: 25-Sep-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 7

update events set title = 'ITNS' where title = '"ITNS"';

rem : 1>Author name         : Deepak
rem : 2>Purpose of change   : "To fix the BMS-129 issue"
rem : 3>Date of change      : 30-Sep-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 8

update interaction_data set data = replace(data,chr(10), ' ') where type = 'selectStudyMultiselectIds' and data is not null;
update interaction_data set data = replace(data,chr(13), ' ') where type = 'selectStudyMultiselectIds' and data is not null;
update interaction_data set data = replace(data,'"', '''''') where type = 'selectStudyMultiselectIds' and data is not null;


create or replace TRIGGER FLTER_CHAR_TRIGGER BEFORE INSERT OR UPDATE ON INTERACTION_DATA
FOR EACH ROW
BEGIN
  if (:new.type = 'selectStudyMultiselectIds' and :new.data is not null) then
    select replace(:new.data, chr(10), ' ') into :new.data from dual;
    select replace(:new.data, chr(13), ' ') into :new.data from dual;
    select replace(:new.data, '"', '''''') into :new.data from dual;
  end if;
END;
.
/

rem : 1>Author name         : Deepak
rem : 2>Purpose of change   : "Scope document not populating due to newline character"
rem : 3>Date of change      : 07-Oct-2009

rem ------------------------------------------------------------------------------------------------


rem : Batch : 9


alter table sites modify PROTOCOL_NUMBER null;

alter table sites modify SITE_REFERENCE null;


rem : 1>Author name         : Tapan
rem : 2>Purpose of change   : Dropping a few constraints from Sites table.
rem : 3>Date of change      : 07-Oct-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 10

update events set title = replace(title,'"', '''''');
update events set description = replace(description,'"', '''''') where description is not null;

create or replace TRIGGER FLTER_EVENTCHAR_TRIGGER BEFORE INSERT OR UPDATE ON EVENTS
FOR EACH ROW
BEGIN
    select replace(:new.title, '"', '''''') into :new.title from dual;
    select replace(:new.description, '"', '''''') into :new.description from dual;
END;
.
/

rem : 1>Author name         : Deepak
rem : 2>Purpose of change   : "Event in calendar view not populating due to double-quotes in title character"
rem : 3>Date of change      : 15-Oct-2009

rem ------------------------------------------------------------------------------------------------

commit;

rem user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

SPOOL OFF


SET ECHO OFF



exit;

rem ------------------------------------------------------------------------------------------------