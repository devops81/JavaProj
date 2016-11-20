rem ------------------------------------------------------------------------------------------------
rem Filename    :   HQ_Reports_Script.sql
rem Purpose :   SQL for HQ Reports
rem             
rem Date    :   01-Sep-2009
rem Author  :   Deepak
rem ------------------------------------------------------------------------------------------------

SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : HQ_Reports_Script.log
SPOOL HQ_Reports_Script.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------

rem : Batch : 1


CREATE OR REPLACE FORCE VIEW "HQ_TA_VIEW" ("TA_ID", "TA", "TA_ATTRIBUTE_PATH") AS select ID as TA_ID, optvalue as TA, '\KOL\BMS Info\'|| optvalue||' Attributes\'||optvalue||' ' as TA_ATTRIBUTE_PATH
from option_lookup
where option_id=(select id from option_names where name='Therapeutic Area')
and deleteflag='N';

  CREATE OR REPLACE FORCE VIEW "HQ_ADVISOR_ATTRIBUTES_VIEW" ("TA", "ATTRIBUTE_ID", "ATTRIBUTE_PATH") AS select ta.ta, at.attribute_id, at.attribute_path
    from hq_ta_view ta
    left outer join attribute_tree_view at ON at.attribute_path= ta.ta_attribute_path||'Advisor';

  CREATE OR REPLACE FORCE VIEW "HQ_AUTHOR_ATTRIBUTES_VIEW" ("TA", "ATTRIBUTE_ID", "ATTRIBUTE_PATH") AS select ta.ta, at.attribute_id, at.attribute_path
    from hq_ta_view ta
    left outer join attribute_tree_view at ON at.attribute_path= ta.ta_attribute_path||'Author';

  CREATE OR REPLACE FORCE VIEW "HQ_INVESTIGATOR_ATTRIBS_VIEW" ("TA", "ATTRIBUTE_ID", "ATTRIBUTE_PATH") AS select ta.ta, at.attribute_id, at.attribute_path
    from hq_ta_view ta
    left outer join attribute_tree_view at ON at.attribute_path= ta.ta_attribute_path||'Investigator';

  CREATE OR REPLACE FORCE VIEW "HQ_SOI_ATTRIBUTES_VIEW" ("TA", "ATTRIBUTE_ID", "ATTRIBUTE_PATH") AS select ta.ta, at.attribute_id, at.attribute_path
    from hq_ta_view ta
    left outer join attribute_tree_view at ON at.attribute_path= ta.ta_attribute_path||'Sphere of Influence';

  CREATE OR REPLACE FORCE VIEW "HQ_SPEAKER_ATTRIBUTES_VIEW" ("TA", "ATTRIBUTE_ID", "ATTRIBUTE_PATH") AS select ta.ta, at.attribute_id, at.attribute_path
    from hq_ta_view ta
    left outer join attribute_tree_view at ON at.attribute_path= ta.ta_attribute_path||'Speaker';

  CREATE OR REPLACE FORCE VIEW "HQ_OL_ADVISOR_VIEW" ("ROOT_ENTITY_ID", "TA", "ATTRIBUTE_ID", "ATTRIBUTE_PATH", "ATTRIBUTE_NAME", "VALUE") AS SELECT val.root_entity_id, soi.ta,  val.attribute_id, val.attribute_path, val.column_name as attribute_name, value
FROM scalar_attribute_value_view val
INNER JOIN hq_advisor_attributes_view soi on soi.attribute_id= val.attribute_id;

  CREATE OR REPLACE FORCE VIEW "HQ_OL_AUTHOR_VIEW" ("ROOT_ENTITY_ID", "TA", "ATTRIBUTE_ID", "ATTRIBUTE_PATH", "ATTRIBUTE_NAME", "VALUE") AS SELECT val.root_entity_id, soi.ta,  val.attribute_id, val.attribute_path, val.column_name as attribute_name, value
FROM scalar_attribute_value_view val
INNER JOIN hq_author_attributes_view soi on soi.attribute_id= val.attribute_id;

  CREATE OR REPLACE FORCE VIEW "HQ_OL_INVESTIGATOR_VIEW" ("ROOT_ENTITY_ID", "TA", "ATTRIBUTE_ID", "ATTRIBUTE_PATH", "ATTRIBUTE_NAME", "VALUE") AS SELECT val.root_entity_id, soi.ta,  val.attribute_id, val.attribute_path, val.column_name as attribute_name, value
FROM scalar_attribute_value_view val
INNER JOIN hq_investigator_attribs_view soi on soi.attribute_id= val.attribute_id;

  CREATE OR REPLACE FORCE VIEW "HQ_OL_SOI_VIEW" ("ROOT_ENTITY_ID", "TA", "ATTRIBUTE_ID", "ATTRIBUTE_PATH", "ATTRIBUTE_NAME", "VALUE") AS SELECT val.root_entity_id, soi.ta,  val.attribute_id, val.attribute_path, val.column_name as attribute_name, value
FROM scalar_attribute_value_view val
INNER JOIN hq_soi_attributes_view soi on soi.attribute_id= val.attribute_id;

  CREATE OR REPLACE FORCE VIEW "HQ_OL_SPEAKER_VIEW" ("ROOT_ENTITY_ID", "TA", "ATTRIBUTE_ID", "ATTRIBUTE_PATH", "ATTRIBUTE_NAME", "VALUE") AS SELECT val.root_entity_id, soi.ta,  val.attribute_id, val.attribute_path, val.column_name as attribute_name, value
FROM scalar_attribute_value_view val
INNER JOIN hq_speaker_attributes_view soi on soi.attribute_id= val.attribute_id;

CREATE OR REPLACE FORCE VIEW "HQ_OL_TRIAL_ATTRIBUTE_VIEW" AS
SELECT val.root_entity_id, val.attribute_id, val.attribute_path, val.column_name as attribute_name, value, row_id
FROM attribute_value_view val
WHERE val.attribute_path like '\KOL\Trials\BMS Trials\%';

CREATE OR REPLACE FORCE VIEW HQ_INVESTIGATOR_TRIAL_VIEW AS
SELECT title.root_entity_id, title.value as title, type.value as Type, pm.value as Protocol_Manager, product.value as Product, role.value as Role
FROM HQ_OL_TRIAL_ATTRIBUTE_VIEW title
  INNER JOIN HQ_OL_TRIAL_ATTRIBUTE_VIEW type ON type.root_entity_id=title.root_entity_id AND type.row_id=title.row_id AND type.attribute_id=83005887
  INNER JOIN HQ_OL_TRIAL_ATTRIBUTE_VIEW pm ON pm.root_entity_id=title.root_entity_id AND pm.row_id=title.row_id AND pm.attribute_id=83005891
  INNER JOIN HQ_OL_TRIAL_ATTRIBUTE_VIEW product ON product.root_entity_id=title.root_entity_id AND product.row_id=title.row_id AND product.attribute_id=83005886
  INNER JOIN HQ_OL_TRIAL_ATTRIBUTE_VIEW role ON role.root_entity_id=title.root_entity_id AND role.row_id=title.row_id AND role.attribute_id=83005888
WHERE title.attribute_id=83005885;

  CREATE OR REPLACE FORCE VIEW "HQ_OL_VIEW" ("EXPERT_ID", "OLFIRSTNAME", "OLLASTNAME", "KOLID", "ADDRLINE1", "ADDRLINE2", "CITY", "STATE", "PHONE", "EMAIL", "FAX", "TYPE", "ZIP", "SPECIALTY", "SUFFIX", "TITLE", "DEGREE", "SAXA_REVIEW_STATUS") AS select
exp.id as expert_id,
exp.firstname as OLFirstName, 
exp.lastname as OLLastName,
exp.kolid,
exp.ADDR_LINE_1 as AddrLine1,
exp.ADDR_LINE_2   as AddrLine2,
exp.ADDR_city  as City,
exp.ADDR_state  as State,
exp.primary_phone   as Phone,
exp.primary_email   as Email,
exp.primary_fax   as Fax,
exp.msl_ol_type Type,
exp.addr_postal_code   as Zip,
exp.primary_speciality Specialty,
suffix_lookup.optvalue as suffix,
exp.title as Title,
degree_query.degree,
saxa_review_alias.value as Saxa_Review_Status
/*tier_alias.value as Tier,
speaker_alias.value as Saxa_Speaker,
advisor_alias.value as Saxa_Potential_Speaker,
investigator_alias.value as Saxa_Investigator,
author_alias.value as author*/
from expert_details_mview exp
left outer join user_table ut on ( exp.id = ut.id ) -- ea.expert_id = exp.id
left outer join option_lookup suffix_lookup on ( ut.suffix = suffix_lookup.id )
left outer join (
  SELECT
    kolid,
    RTRIM (
      xmlagg (
        xmlelement (
          c, 
          val || ','
        ) order by val
      ).extract ('//text()'),
      ',' 
    ) AS degree
  FROM (
    select u.kolid, st.value val
    from user_table u
    left outer join string_attribute st on (st.root_entity_id = u.kolid and st.attribute_id = 10) -- education type
    where st.value != 'NA' and u.kolid != 0
  )
  GROUP BY kolid
) degree_query on ( ut.kolid = degree_query.kolid ) 
left outer join string_attribute saxa_review_alias on(
  saxa_review_alias.root_entity_id  = ut.kolid and
  saxa_review_alias.attribute_id = 83396620 -- SAXA Review Status
)
/*left outer join string_attribute speaker_alias on(
  speaker_alias.root_entity_id = ut.kolid and
  speaker_alias.attribute_id in (
    select attribute_id
    from attributetable
    where upper(name) like upper($P{reportTherapeuticArea}||' Speaker')
  )
)
left outer join string_attribute advisor_alias on(
  speaker_alias.root_entity_id  = ut.kolid and
  speaker_alias.attribute_id in (
    select attribute_id
    from attributetable
    where upper(name) like upper($P{reportTherapeuticArea}|| ' Advisor')
  )
)
left outer join string_attribute investigator_alias on(
  investigator_alias.root_entity_id  = ut.kolid and
  investigator_alias.attribute_id in (
    select attribute_id
    from attributetable
    where upper(name) like upper($P{reportTherapeuticArea}||' Investigator')
  )
)
left outer join string_attribute tier_alias on(
  tier_alias.root_entity_id  = ut.kolid and
  tier_alias.attribute_id in (
    select attribute_id
    from attributetable
    where upper(name) like upper($P{reportTherapeuticArea}||' Sphere of Influence')
  )
)
left outer join string_attribute author_alias on(
  author_alias.root_entity_id = ut.kolid and
  author_alias.attribute_id in (
    select attribute_id
    from attributetable
    where upper(name) like upper($P{reportTherapeuticArea}||' Author')
  )
)*/;

rem : 1>Author name         : Adam added by Deepak
rem : 2>Purpose of change   : View for HQ Reports
rem : 3>Date of change      : 09-Sep-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 2

 CREATE OR REPLACE FORCE VIEW HQ_EVENT_VIEW AS 
  select event_id, eventdate as Event_StartDate, ENDDATE as event_enddate, et.optvalue as event_type, 
title as Event_Title, Description, ta.optvalue as Event_TA, 
th.optvalue as Event_Therapy, City, st.optvalue as State, 
e.ta as event_ta_id, 
e.therapy as event_therapy_id,
(select count(*) from eventattendee ea, user_table u 
where ea.event_id = e.event_id 
and ea.expert_id = u.id
and u.user_type_id = 4
and u.deleteflag = 'N' ) as Event_Attendee_Count,
(select count(*) from interaction i, interaction_data idt 
where i.interaction_id = idt.interaction_id
and idt.data = e.event_id 
and idt.type = 'RelatedEvent'
and i.deleteflag = 'N') as Event_Interaction_Count
from events e 
inner join option_lookup et ON et.id=e.event_type
-- inner join user_table u on u.id=e.userid -- same as owner
inner join option_lookup ta on ta.id=e.ta
inner join option_lookup th on th.id= e.therapy
inner join option_lookup st on st.id= e.state
where e.deleteflag='N';


rem : 1>Author name         : Deepak
rem : 2>Purpose of change   : View for Events
rem : 3>Date of change      : 02-Sep-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 2

 insert into global_constants values (hibernate_sequence.nextVal, 'OBJECTIVETEXT_CONFERENCE_INTERACTION', 'Dummy Objective Text for HQ_Conference Interaction');


rem : 1>Author name         : Tapan
rem : 2>Purpose of change   : Placeholder objective text for Conference Interaction report
rem : 3>Date of change      : 02-Sep-2009

rem ------------------------------------------------------------------------------------------------


rem : Batch : 3

insert into global_constants values ( hibernate_sequence.nextval, 'OBJECTIVETEXT_ABOARD_ATTENDEE', 'Dummy Objective Text for Adboard Attendee');


rem : 1>Author name         : Deepak
rem : 2>Purpose of change   : Placeholder objective text for Aboard Attendee report
rem : 3>Date of change      : 02-Sep-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 4

insert into global_constants values ( hibernate_sequence.nextval, 'OBJECTIVETEXT_BMS_AUTHOR', 'Dummy Objective Text for BMS Author');


rem : 1>Author name         : Deepak
rem : 2>Purpose of change   : Placeholder objective text for BMS Author report
rem : 3>Date of change      : 04-Sep-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 5

insert into global_constants values ( hibernate_sequence.nextval, 'OBJECTIVETEXT_BMS_INVESTIGATOR', 'Dummy Objective Text for BMS Investigator');


rem : 1>Author name         : Deepak
rem : 2>Purpose of change   : Placeholder objective text for BMS Investigator report
rem : 3>Date of change      : 04-Sep-2009

rem ------------------------------------------------------------------------------------------------


rem : Batch : 6

insert into global_constants values ( hibernate_sequence.nextval, 'OBJECTIVETEXT_BMS_POTENTIAL_EXPERTS', 'Dummy Objective Text for BMS Potential Adboard Experts');


rem : 1>Author name         : Tapan
rem : 2>Purpose of change   : Placeholder objective text for BMS Potential Experts report
rem : 3>Date of change      : 08-Sep-2009

rem ------------------------------------------------------------------------------------------------


rem : Batch : 7

insert into global_constants values ( hibernate_sequence.nextval, 'OBJECTIVETEXT_BMS_SPEAKER', 'Dummy Objective Text for BMS Speakers');


rem : 1>Author name         : Tapan
rem : 2>Purpose of change   : Placeholder objective text for BMS Speakers report
rem : 3>Date of change      : 08-Sep-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 8

CREATE OR REPLACE FORCE VIEW HQ_SPEAKER_ATTRIBUTES_VIEW ("TA", "ATTRIBUTE_ID", "ATTRIBUTE_PATH") AS 
  select ta.ta, at.attribute_id, at.attribute_path
    from hq_ta_view ta
    left outer join attribute_tree_view at ON at.attribute_path= ta.ta_attribute_path||'Speaker';
 



CREATE OR REPLACE FORCE VIEW HQ_OL_IPLAN_ATTRIBUTE_VIEW ("ROOT_ENTITY_ID", "ATTRIBUTE_ID", "ATTRIBUTE_PATH", "ATTRIBUTE_NAME", "VALUE", "ROW_ID") AS 
  SELECT val.root_entity_id, val.attribute_id, val.attribute_path, val.column_name as attribute_name, 
value, row_id
FROM attribute_value_view val
WHERE val.attribute_path like '\KOL\BMS Info\iPlan Data\%';



CREATE OR REPLACE FORCE VIEW HQ_SPEAKER_IPLAN_VIEW ("ROOT_ENTITY_ID", "PRODUCT", "ACTIVE", "STARTDATE", "ENDDATE") AS 
  SELECT product.root_entity_id, product.value as product, active.value as active, 
startDate.value as startDate, endDate.value as endDate
FROM HQ_OL_IPLAN_ATTRIBUTE_VIEW product
  INNER JOIN HQ_OL_IPLAN_ATTRIBUTE_VIEW active ON active.root_entity_id=product.root_entity_id AND active.row_id=product.row_id AND active.attribute_id=103935653
  INNER JOIN HQ_OL_IPLAN_ATTRIBUTE_VIEW startDate ON startDate.root_entity_id=product.root_entity_id AND startDate.row_id=product.row_id AND startDate.attribute_id=104023299
  INNER JOIN HQ_OL_IPLAN_ATTRIBUTE_VIEW endDate ON endDate.root_entity_id=product.root_entity_id AND endDate.row_id=product.row_id AND endDate.attribute_id=104023300
WHERE product.attribute_id=103935652;
 



rem : 1>Author name         : Tapan
rem : 2>Purpose of change   : Views for HQ BMS Speaker Report
rem : 3>Date of change      : 08-Sep-2009

rem ------------------------------------------------------------------------------------------------


commit;

rem user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

SPOOL OFF

SET ECHO OFF

exit;

rem ------------------------------------------------------------------------------------------------

