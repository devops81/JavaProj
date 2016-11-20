rem ------------------------------------------------------------------------------------------------
rem Filename:   db_changes_script_BMS_FebRelease.sql
rem Purpose	:   SQL changes for release
rem             
rem Date	:	21-Feb-2009
rem Author	:   Deepak
rem ------------------------------------------------------------------------------------------------

SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : db_changes_script_BMS_FebRelease.log
SPOOL db_changes_script_BMS_FebRelease.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------

rem : Batch : 1

  CREATE OR REPLACE FORCE VIEW INTERACTION_SEARCH_VIEW ("ID", "INTERACTION_ID", "USER_ID", "USER_NAME", "PRODUCT_LIST", "ATTENDEE_TYPE", "ATTENDEE_LIST", "FIRST_TOPIC", "ATTENDEE_COUNT", "OTHER_ATTENDEE_COUNT") AS 
  select distinct
i.interaction_id as id,
i.interaction_id,
u.id as USER_ID,
u.lastname||', '|| u.firstname as USER_NAME,
lovidLookup.optvalue||
(case when productData.secondary_lovId is not null then ', ' end) || 
secondaryLovidLookup.optvalue ||
(case when productData.secondary_lovId is not null then ', ' end) ||
tertiaryLovidLookup.optvalue as PRODUCT_LIST,
att.attendeetype AS ATTENDEE_TYPE,
getattendeeslist(i.interaction_id) as ATTENDEE_LIST,
(select firstTopicLookup.optvalue 
  from interaction_data firstTopicData, option_lookup firstTopicLookup
  where firstTopicData.secondary_lovid = firsttopiclookup.id and 
        firstTopicData.interaction_id = i.interaction_id and 
		rownum = 1 and
		firstTopicData.type = 'interactionTypeLOVTripletIds') FIRST_TOPIC, 
(select count(attendeeCount.attendee_id) from attendees attendeeCount 
  where i.interaction_id = attendeecount.interaction_id) as ATTENDEE_COUNT,
(select nvl(sum(nvl(otherAttendeeCount.data, 0)),0)
  from interaction_data otherAttendeeCount 
  where i.interaction_id = otherAttendeeCount.interaction_id and
  otherAttendeeCount.type = 'AttendeeType') as OTHER_ATTENDEE_COUNT
from user_table u, interaction i, interaction_data productData, attendees att,
option_lookup lovidLookup, option_lookup secondaryLovidLookup, option_lookup tertiaryLovidLookup
where i.userid = u.id and
i.interaction_id = productData.interaction_id and
i.interaction_id = att.interaction_id and
productData.lovId = lovidLookup.id and
productData.secondary_lovId = secondaryLovidLookup.id(+) and
productData.tertiary_lovId = tertiaryLovidLookup.id(+) and
productData.type = 'productMultiselectIds' and
 u.deleteflag != 'Y' and
 i.deleteflag != 'Y'
 order by i.interaction_id;
 

rem : 1>Author name 		: Deepak
rem : 2>Purpose of change	: First topic was coming wrong
rem : 3>Date of change 		: 21-Feb-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 2

update attributetable set name = name || '_Not_In_Use' where attribute_id = 83393267;

update string_attribute set attribute_id = 83396615 where id in (85330165, 85330695, 85331315) and attribute_id = 83393267;

delete from string_attribute where attribute_id = 83393267;

rem : 1>Author name 		: Deepak
rem : 2>Purpose of change	: Fixed wrong first topic getting displayed
rem : 3>Date of change 		: 21-Feb-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 3

update option_lookup set parent=-1 where option_id = 83005842;

rem : 1>Author name 		: Deepak
rem : 2>Purpose of change	: setting sphere of influence parent to none
rem : 3>Date of change 		: 21-Feb-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 4


Insert into "OPTION_NAMES" ("ID","NAME","PARENT") values (hibernate_sequence.nextval,'Report Level',-1);

Insert into option_lookup("ID","OPTION_ID","OPTVALUE","DELETEFLAG","PARENT","DEFAULT_SELECTED","DISPLAY_ORDER") values 
(hibernate_sequence.nextval,(select id from option_names where name like 'Report Level' ),'Territory','N',-1,'0',0);
Insert into option_lookup("ID","OPTION_ID","OPTVALUE","DELETEFLAG","PARENT","DEFAULT_SELECTED","DISPLAY_ORDER") values 
(hibernate_sequence.nextval,(select id from option_names where name like 'Report Level' ),'Region','N',-1,'0',0);

rem : 1>Author name 		: Dayanand
rem : 2>Purpose of change	: Adding LOVs to the report UI
rem : 3>Date of change 		: 23-Feb-2009

rem ------------------------------------------------------------------------------------------------

CREATE INDEX ATTENDEES_USERID_INDEX1 ON ATTENDEES (USERID);
CREATE INDEX ATTENDEES_INTERACTIONID_INDEX1 ON ATTENDEES (INTERACTION_ID);

CREATE INDEX INTERACTION_INDEX1 ON INTERACTION (USERID);
CREATE INDEX INTERACTION_INDEX2 ON INTERACTION (INTERACTIONDATE);

CREATE INDEX INTERACTION_DATA_INDEX1 ON INTERACTION_DATA (INTERACTION_ID);
CREATE INDEX INTERACTION_DATA_INDEX2 ON INTERACTION_DATA (LOVID);
CREATE INDEX INTERACTION_DATA_INDEX3 ON INTERACTION_DATA (SECONDARY_LOVID);
CREATE INDEX INTERACTION_DATA_INDEX4 ON INTERACTION_DATA (TERTIARY_LOVID);
CREATE INDEX INTERACTION_DATA_INDEX5 ON INTERACTION_DATA (TYPE);

rem : 1>Author name 		: Deepak
rem : 2>Purpose of change	: Indexes on interaction related tables
rem : 3>Date of change 		: 24-Feb-2009

rem ------------------------------------------------------------------------------------------------

create index contacts_kolid on contacts(kolid);
create index contacts_staffid on contacts(staffid);

create index attendees_userid on attendees(userid);
create index attendees_interactionid on attendees(interaction_id);

rem : 1>Author name 		: Tarun Gupta
rem : 2>Purpose of change	: Indexes on contacts table and attendees table
rem : 3>Date of change 		: 26-Feb-2009

rem ------------------------------------------------------------------------------------------------


 

delete from option_lookup where optvalue in ('Territory','Region');

delete select * from option_names where name like 'Report Level';

 
Insert into "OPTION_NAMES" ("ID","NAME","PARENT") values (hibernate_sequence.nextval,'Report Level',-1);

Insert into option_lookup("ID","OPTION_ID","OPTVALUE","DELETEFLAG","PARENT","DEFAULT_SELECTED","DISPLAY_ORDER") values 
(hibernate_sequence.nextval,(select id from option_names where name like 'Report Level' ),'Detail','N',-1,'0',0);
Insert into option_lookup("ID","OPTION_ID","OPTVALUE","DELETEFLAG","PARENT","DEFAULT_SELECTED","DISPLAY_ORDER") values 
(hibernate_sequence.nextval,(select id from option_names where name like 'Report Level' ),'Summary','N',-1,'0',0);

rem : 1>Author name 		: Dayanand
rem : 2>Purpose of change	: Modified the Report LOV Values
rem : 3>Date of change 		: 05-Mar-2009

rem ------------------------------------------------------------------------------------------------


commit;

rem user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

SPOOL OFF
SET ECHO OFF
exit;
rem ------------------------------------------------------------------------------------------------


