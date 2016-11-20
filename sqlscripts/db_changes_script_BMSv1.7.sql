rem ------------------------------------------------------------------------------------------------
rem Filename    :   db_changes_script_BMSv1.7.sql
rem Purpose	:   SQL changes for version 1.7
rem             
rem Date	:   12-Jun-2009
rem Author	:   Deepak
rem ------------------------------------------------------------------------------------------------

SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : db_changes_script_BMSv1.7.log
SPOOL db_changes_script_BMSv1.7.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------

rem : Batch : 1

update interaction_data it set it.tertiary_lovid = (
select o.parent from option_lookup o where o.id = it.lovid)
where it.tertiary_lovid is null
and it.type = 'educationalObjectivesMultiselectIds';

CREATE OR REPLACE TRIGGER EDU_PRODUCT_TRIGGER BEFORE INSERT OR UPDATE ON INTERACTION_DATA
FOR EACH ROW
BEGIN
  if (:new.type = 'educationalObjectivesMultiselectIds') then
    select parent into :new.TERTIARY_LOVID from option_lookup where id = :new.lovid;
  end if;
END;


rem : 1>Author name 		: Deepak
rem : 2>Purpose of change	: To record the product id for educational dialog
rem : 3>Date of change 		: 12-Jun-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 2

update interaction_data set data = 1
where id in
(select min(id) from interaction_data where type like 'interactionTypeLOVTripletIds' group by interaction_id);

rem : 1>Author name 		: Deepak
rem : 2>Purpose of change	: Set value in data column to identify first topic
rem : 3>Date of change 		: 12-Jun-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 3


 CREATE OR REPLACE FORCE VIEW INTERACTION_SEARCH_VIEW as
  select 
i.interaction_id,
i.interactiondate,
u.id as USER_ID,
u.lastname||', '|| u.firstname as USER_NAME,
nvl(productData.lovId, 0) primary_product_id,
nvl(productData.secondary_lovId, 0)  secondary_product_id,
nvl(productData.tertiary_lovId, 0)  tertiary_product_id,
primaryProductLookup.optvalue||
(case when productData.secondary_lovId is not null then ', ' end) ||
secondaryProductLookup.optvalue ||
(case when productData.tertiary_lovId is not null then ', ' end) ||
tertiaryProductLookup.optvalue as PRODUCT_LIST,
firstTopicLookup.optvalue FIRST_TOPIC,
nvl(otherAttendeeData.data, 0) as OTHER_ATTENDEE_COUNT
from user_table u, interaction i, 
interaction_data productData, interaction_data firstTopicData, interaction_data otherAttendeeData,
option_lookup primaryProductLookup, option_lookup secondaryProductLookup, option_lookup tertiaryProductLookup,
option_lookup firstTopicLookup
where i.userid = u.id and
i.interaction_id = productData.interaction_id and
i.interaction_id = firstTopicData.interaction_id and
i.interaction_id = otherAttendeeData.interaction_id (+) and
productData.lovId = primaryProductLookup.id and
productData.secondary_lovId = secondaryProductLookup.id(+) and
productData.tertiary_lovId = tertiaryProductLookup.id(+) and
productData.type = 'productMultiselectIds' and
firstTopicData.secondary_lovId = firstTopicLookup.id and
firstTopicData.type = 'interactionTypeLOVTripletIds' and
firstTopicData.data = 1 and
otherAttendeeData.type (+) = 'AttendeeType' and
i.deleteflag != 'Y';



create index ATTENDEES_NAME_INDEX1 on ATTENDEES(lower(name));

rem : 1>Author name 		: Deepak
rem : 2>Purpose of change	: View and Index to improve search
rem : 3>Date of change 		: 12-Jun-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 4

delete from interaction_data where type in ('AttendeeType', 'RelatedEvent') and data is null;

rem : 1>Author name 		: Deepak
rem : 2>Purpose of change	: Delete rows without data
rem : 3>Date of change 		: 12-Jun-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 5

create index Audit_log_entity on Audit_log(entity_id);

rem : 1>Author name 		: Tapan
rem : 2>Purpose of change	: Creating an index on entityId column of Audit_log table.
rem : 3>Date of change 		: 25-Jun-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 6

update attributetable set name='Address State/Prov.' where attribute_id = 40;

rem : 1>Author name 		: Tapan
rem : 2>Purpose of change	: Modifying the Attribute Name from Address State to Address State/Prov.
rem : 3>Date of change 		: 23-Jun-2009


rem ------------------------------------------------------------------------------------------------


commit;

rem user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

SPOOL OFF


SET ECHO OFF



exit;




rem ------------------------------------------------------------------------------------------------

