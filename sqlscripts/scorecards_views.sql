SET ECHO ON

rem ------------------------------------------------------- 
rem -- DDL for View SC_INTERACTION_DATA_VIEW
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_INTERACTION_DATA_VIEW (INTERACTION_ID, ID, TYPE, LOV1_ID, LOV1_VALUE, LOV2_ID, LOV2_VALUE, LOV3_ID, LOV3_VALUE, DATA) AS 
  select it.interaction_id, it.id, it.type, it.lovid as Lov1_ID, opt1.optvalue as Lov1_Value, 
  it.secondary_lovid as Lov2_Id, opt2.optvalue as Lov2_Value,  
  it.tertiary_lovid as Lov3_Id, opt3.optvalue as Lov3_Value, it.data
from interaction_data it
  left outer join option_lookup opt1 ON opt1.id= it.lovid
  left outer join option_lookup opt2 ON opt2.id= it.secondary_lovid  
  left outer join option_lookup opt3 ON opt3.id= it.tertiary_lovid;

rem -------------------------------------------------------
rem -- DDL for View SC_INTERACTION_TOPIC_VIEW 
rem -------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW SC_INTERACTION_TOPIC_VIEW (INTERACTION_ID, INTERACTION_TYPE, INTERACTION_TOPIC, INTERACTION_SUBTOPIC, INTERACTION_TYPE_INDEX) AS 
  select interaction_id, lov1_value as interaction_type, lov2_value as interaction_topic, lov3_value as interaction_subtopic, data as interaction_type_index
from SC_INTERACTION_DATA_VIEW
where type='interactionTypeLOVTripletIds';

rem -------------------------------------------------------
rem -- DDL for View SC_INTERACTION_VIEW
rem -------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW SC_INTERACTION_VIEW (INTERACTION_ID, INTERACTION_DATE, INTERACTION_TA, INTERACTION_INTENT, INTERACTION_TYPE, FIRST_ATTENDEE_OL_STATUS, OTHER_ATTENDEE_COUNT) AS 
  select i.interaction_id, i.interactiondate as interaction_date, ta.optvalue as Interaction_TA, intent.data as Interaction_Intent, t.interaction_type, ol.msl_ol_type as First_Attendee_OL_Status, TO_NUMBER(NVL(othatt.data, 0)) as Other_Attendee_Count
from interaction i
  inner join option_lookup ta ON i.ta = ta.id  
  inner join SC_INTERACTION_TOPIC_VIEW t ON t.interaction_id=i.interaction_id and t.interaction_type_index='1'
  left outer join (
    select interaction_id, min(attendee_id) as attendee_id
    from attendees
    where attendeetype=1
    group by interaction_id
  ) firstOlAttendee ON firstOlAttendee.interaction_id=i.interaction_id
  left outer join attendees att ON att.attendee_id=firstOlAttendee.attendee_id
  left outer join expert_details_mview ol ON ol.id= att.userid
  left outer join interaction_data intent ON intent.interaction_id= i.interaction_id and intent.type='intentOfVisit'    
  LEFT OUTER JOIN interaction_data othAtt ON othAtt.interaction_id=i.interaction_id and othAtt.type='AttendeeType'
WHERE i.deleteflag = 'N';

rem ------------------------------------------------------- 
rem -- DDL for View SC_MSL_MPOL_COUNT_VIEW
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_MSL_MPOL_COUNT_VIEW (MSL_USER_ID, OL_COUNT) AS 
  SELECT ol.id AS MSL_USER_ID, count(*)
FROM Expert_details_mview ol
  INNER JOIN Contacts c ON c.kolid=ol.id
WHERE ol.msl_ol_type in ('MPA', 'MPOL')
GROUP BY ol.id;

rem -------------------------------------------------------
rem -- DDL for View SC_MSL_VIEW
rem -------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW SC_MSL_VIEW (MSL_USER_ID, MSL_TA, BEGIN_DATE, END_DATE, KOLID, STAFFID) AS select msl.id as MSL_USER_ID, ta.optvalue as MSL_TA, begin_date, end_date, msl.kolid, msl.staffid
from user_table msl
  inner join user_relationship ur on ur.user_id=msl.id and ur.relationship_type=1
  inner join option_lookup territory on territory.id=ur.territory
  inner join option_lookup region on region.id=territory.parent 
  inner join option_lookup ta on ta.id=region.parent
WHERE msl.deleteflag='N';

rem -------------------------------------------------------
rem -- DDL for View SC_MSL_OL_VIEW
rem -------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW SC_MSL_OL_VIEW (MSL_STAFF_ID, MSL_TA, OL_USER_ID, OL_STATUS, BEGIN_DATE, END_DATE) AS SELECT msl.staffid as MSL_STAFF_ID, msl.msl_ta, c.kolid as OL_USER_ID, ol.msl_ol_type as OL_Status, c.begindate as BEGIN_DATE, c.enddate as END_DATE
FROM Contacts c
  INNER JOIN Expert_details_mview ol ON ol.id=c.kolid
  INNER JOIN SC_MSL_VIEW msl ON msl.staffid=c.staffid;

  --------------------------------------------------------
rem -- DDL for View SC_MSL_MPOL_VIEW
rem -------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW SC_MSL_MPOL_VIEW (MSL_STAFF_ID, MSL_TA, OL_USER_ID, OL_STATUS, BEGIN_DATE, END_DATE) AS SELECT MSL_STAFF_ID,MSL_TA,OL_USER_ID,OL_STATUS,BEGIN_DATE,END_DATE
FROM SC_MSL_OL_VIEW
WHERE OL_Status in ('MPA', 'MPOL');

rem -------------------------------------------------------
 --  DDL for View SC_NAMED_ATTENDEE_COUNT_VIEW
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_NAMED_ATTENDEE_COUNT_VIEW (INTERACTION_ID, CHILD_ATTENDEE_COUNT) AS 
  SELECT i.interaction_id, count(*) as CHILD_ATTENDEE_COUNT
  FROM interaction i
  LEFT OUTER JOIN attendees att on att.interaction_id=i.interaction_id
  group by i.interaction_id;

rem ------------------------------------------------------- 
rem -- DDL for View SC_OTHER_ATTENDEE_COUNT_VIEW
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_OTHER_ATTENDEE_COUNT_VIEW (INTERACTION_ID, OTHER_ATTENDEE_COUNT) AS 
  SELECT i.interaction_id, TO_NUMBER(NVL(othatt.data, 0)) as Other_Attendee_count  
  FROM interaction i
  LEFT OUTER JOIN interaction_data othAtt ON othAtt.interaction_id=i.interaction_id and othAtt.type='AttendeeType'  
  group by i.interaction_id, othatt.data;

rem ------------------------------------------------------- 
rem -- DDL for View SC_INTERACTION_TOPIC_VIEW
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_INTERACTION_TOPIC_VIEW (INTERACTION_ID, INTERACTION_TYPE, INTERACTION_TOPIC, INTERACTION_SUBTOPIC, INTERACTION_TYPE_INDEX) AS 
  select interaction_id, lov1_value as interaction_type, lov2_value as interaction_topic, lov3_value as interaction_subtopic, data as interaction_type_index
from SC_INTERACTION_DATA_VIEW
where type='interactionTypeLOVTripletIds';

rem ------------------------------------------------------- 
rem -- DDL for View SC_ATTENDEE_VIEW
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_ATTENDEE_VIEW (ATTENDEE_ID, NAME, USERID, ATTENDEETYPE, INTERACTION_ID, OL_STATUS) AS 
  SELECT att.*, ol.msl_ol_type as OL_Status
from attendees att
  left outer join expert_details_mview ol ON ol.id= att.userid;

rem ------------------------------------------------------- 
rem -- DDL for View SC_INTERACTION_PROACTIVE_VIEW
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_INTERACTION_PROACTIVE_VIEW (INTERACTION_ID, INTERACTION_DATE, INTERACTION_TA, INTERACTION_INTENT, INTERACTION_TYPE, FIRST_ATTENDEE_OL_STATUS) AS 
  SELECT INTERACTION_ID,INTERACTION_DATE,INTERACTION_TA,INTERACTION_INTENT,INTERACTION_TYPE,FIRST_ATTENDEE_OL_STATUS
from sc_interaction_view 
WHERE interaction_intent='Proactive';

rem -------------------------------------------------------
rem -- DDL for View SC_INTERACTION_REACTIVE_VIEW
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_INTERACTION_REACTIVE_VIEW (INTERACTION_ID, INTERACTION_DATE, INTERACTION_TA, INTERACTION_INTENT, INTERACTION_TYPE, FIRST_ATTENDEE_OL_STATUS) AS 
  SELECT INTERACTION_ID,INTERACTION_DATE,INTERACTION_TA,INTERACTION_INTENT,INTERACTION_TYPE,FIRST_ATTENDEE_OL_STATUS
from sc_interaction_view 
WHERE interaction_intent='Reactive' ;


rem ------------------------------------------------------- 
rem -- DDL for View SC_INTERACTION_EMAIL_VIEW
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_INTERACTION_EMAIL_VIEW (INTERACTION_ID, INTERACTION_DATE, INTERACTION_TA, INTERACTION_INTENT, INTERACTION_TYPE, FIRST_ATTENDEE_OL_STATUS) AS 
  SELECT INTERACTION_ID,INTERACTION_DATE,INTERACTION_TA,INTERACTION_INTENT,INTERACTION_TYPE,FIRST_ATTENDEE_OL_STATUS
From SC_interaction_view
where interaction_type='Email';


rem ------------------------------------------------------- 
rem -- DDL for View SC_INTERACTION_PHONE_VIEW
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_INTERACTION_PHONE_VIEW (INTERACTION_ID, INTERACTION_DATE, INTERACTION_TA, INTERACTION_INTENT, INTERACTION_TYPE, FIRST_ATTENDEE_OL_STATUS) AS 
  SELECT INTERACTION_ID,INTERACTION_DATE,INTERACTION_TA,INTERACTION_INTENT,INTERACTION_TYPE,FIRST_ATTENDEE_OL_STATUS
  From SC_interaction_view
  where interaction_type='Telephone';

rem ------------------------------------------------------- 
rem -- DDL for View SC_INTERACTION_HCMPRES_VIEW
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_INTERACTION_HCMPRES_VIEW (INTERACTION_ID, INTERACTION_DATE, INTERACTION_TA, INTERACTION_INTENT, INTERACTION_TYPE, FIRST_ATTENDEE_OL_STATUS) AS 
  SELECT INTERACTION_ID,INTERACTION_DATE,INTERACTION_TA,INTERACTION_INTENT,INTERACTION_TYPE,FIRST_ATTENDEE_OL_STATUS
  From SC_interaction_view
where interaction_id IN (
  SELECT interaction_id
  FROM SC_Interaction_topic_view
  WHERE interaction_type='Group Presentation (3 or more)'
  AND interaction_topic IN ('Managed Markets', 'Managed Markets Presentation')
);

rem ------------------------------------------------------- 
rem -- DDL for View SC_INTERACTION_OTHERPRES_VIEW
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_INTERACTION_OTHERPRES_VIEW (INTERACTION_ID, INTERACTION_DATE, INTERACTION_TA, INTERACTION_INTENT, INTERACTION_TYPE, FIRST_ATTENDEE_OL_STATUS) AS 
  SELECT INTERACTION_ID,INTERACTION_DATE,INTERACTION_TA,INTERACTION_INTENT,INTERACTION_TYPE,FIRST_ATTENDEE_OL_STATUS
  From SC_interaction_view
where interaction_id IN (
  SELECT interaction_id
  FROM SC_Interaction_topic_view
  WHERE interaction_type='Group Presentation (3 or more)'
  AND interaction_topic NOT IN ('Managed Markets', 'Managed Markets Presentation')
);
 

rem ------------------------------------------------------- 
rem -- DDL for View SC_ATTENDEE_COUNT_VIEW
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_ATTENDEE_COUNT_VIEW (FIELD_NAME, INTERACTION_ID, INTERACTION_DATE, INTERACTION_TYPE, INTERACTION_TA, CHILD_ATTENDEE_COUNT, OTHER_ATTENDEE_COUNT, TOTAL_ATTENDEE_COUNT) AS 
  SELECT 'Total Impacted' as FIELD_NAME, i.interaction_id, i.interaction_date, i.interaction_type, i.interaction_ta, namedatt.child_attendee_count, otherAtt.Other_Attendee_count, namedatt.child_attendee_count + otherAtt.Other_Attendee_count as Total_Attendee_Count
  FROM SC_INTERACTION_VIEW i
    INNER JOIN SC_NAMED_ATTENDEE_COUNT_VIEW namedAtt ON namedAtt.interaction_id=i.interaction_id
    INNER JOIN SC_OTHER_ATTENDEE_COUNT_VIEW otherAtt ON otherAtt.interaction_id=i.interaction_id;

rem ------------------------------------------------------- 
rem -- DDL for View SC_1ON1_ATTENDEE_COUNT_VIEW
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_1ON1_ATTENDEE_COUNT_VIEW (FIELD_NAME, INTERACTION_ID, INTERACTION_DATE, INTERACTION_TYPE, INTERACTION_TA, CHILD_ATTENDEE_COUNT, OTHER_ATTENDEE_COUNT, TOTAL_ATTENDEE_COUNT) AS 
  SELECT FIELD_NAME,INTERACTION_ID,INTERACTION_DATE,INTERACTION_TYPE,INTERACTION_TA,CHILD_ATTENDEE_COUNT,OTHER_ATTENDEE_COUNT,TOTAL_ATTENDEE_COUNT
FROM sc_attendee_count_view
WHERE interaction_type='1:1 Face to Face (2 or less)';

rem ------------------------------------------------------- 
rem -- DDL for View SC_DLG_OBJECTIVE_VIEW
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_DLG_OBJECTIVE_VIEW (INTERACTION_ID, INTERACTION_DATE, INTERACTION_TA, OBJECTIVE_PRODUCT_ID, OBJECTIVE_PRODUCT, OBJECTIVE_NAME, OBJECTIVE_UNDERSTANDING) AS 
  select i.interaction_id, i.interaction_date, i.interaction_ta, id.lov3_id as Objective_Product_Id,id.lov3_value as Objective_Product, id.lov1_value as Objective_Name, id.lov2_value as Objective_Understanding
from SC_INTERACTION_DATA_VIEW id
  inner join SC_interaction_view i on i.interaction_id= id.interaction_id
where id.type='educationalObjectivesMultiselectIds';

rem ------------------------------------------------------- 
rem -- DDL for View SC_INQUIRY_VIEW
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_INQUIRY_VIEW (INTERACTION_ID, INTERACTION_DATE, INTERACTION_TA, FIRST_ATTENDEE_OL_STATUS, INQUIRY_PRODUCT_ID, INQUIRY_PRODUCT, INQUIRY_TOPIC) AS 
  select i.interaction_Id, i.interaction_date, i.interaction_ta, i.first_attendee_ol_status,  id.lov1_id as Inquiry_Product_Id, id.lov1_value as Inquiry_Product, DECODE(SUBSTR(id.lov2_value,1,5),'Other','Other', id.lov2_value) as Inquiry_Topic
from SC_INTERACTION_DATA_VIEW id
  inner join SC_interaction_view i on i.interaction_id=id.interaction_id
WHERE id.type='unsolictedOffLabelTripletIds';

rem ------------------------------------------------------- 
rem -- DDL for View SC_INTERACTION_ATTENDEE_VIEW
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_INTERACTION_ATTENDEE_VIEW (INTERACTION_ID, INTERACTION_DATE, INTERACTION_TYPE, INTERACTION_TA, ATTENDEE_ID, ATTENDEE_NAME, ATTENDEE_USERID, ATTENDEETYPE, OL_STATUS) AS 
  SELECT i.interaction_id, i.interaction_date, i.interaction_type, i.interaction_ta, att.attendee_id, att.name as Attendee_name, att.userid as attendee_userid, att.attendeetype, att.ol_status
from sc_interaction_view i
  left outer join sc_attendee_view att on i.interaction_id= att.interaction_id;

rem ------------------------------------------------------- 
rem -- DDL for View SC_INTERACTION_EMAILPHONE_VIEW
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_INTERACTION_EMAILPHONE_VIEW (FIELD_NAME, INTERACTION_ID, INTERACTION_DATE, INTERACTION_TA, INTERACTION_INTENT, INTERACTION_TYPE, FIRST_ATTENDEE_OL_STATUS, OTHER_ATTENDEE_COUNT) AS 
  SELECT 'E-Mail/Telephone' as FIELD_NAME, i.INTERACTION_ID,i.INTERACTION_DATE,i.INTERACTION_TA,i.INTERACTION_INTENT,i.INTERACTION_TYPE,i.FIRST_ATTENDEE_OL_STATUS,i.OTHER_ATTENDEE_COUNT
  FROM sc_interaction_view i
  WHERE  interaction_type in ('Email', 'Telephone'); 

rem ------------------------------------------------------- 
rem -- DDL for View SC_INTERACTION_GROUP_VIEW
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_INTERACTION_GROUP_VIEW (FIELD_NAME, INTERACTION_ID, INTERACTION_DATE, INTERACTION_TA, INTERACTION_INTENT, INTERACTION_TYPE, FIRST_ATTENDEE_OL_STATUS, OTHER_ATTENDEE_COUNT) AS 
  SELECT 'Group' as FIELD_NAME, i.INTERACTION_ID,i.INTERACTION_DATE,i.INTERACTION_TA,i.INTERACTION_INTENT,i.INTERACTION_TYPE,i.FIRST_ATTENDEE_OL_STATUS,i.OTHER_ATTENDEE_COUNT
  FROM sc_interaction_view i
  WHERE  interaction_type='Group Presentation (3 or more)'; 


rem ------------------------------------------------------- 
rem -- DDL for View SC_INTERACTION_MPOL_VIEW
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_INTERACTION_MPOL_VIEW (FIELD_NAME, INTERACTION_ID, INTERACTION_DATE, INTERACTION_TYPE, INTERACTION_TA, ATTENDEE_ID, ATTENDEE_NAME, ATTENDEE_USERID, ATTENDEETYPE, OL_STATUS) AS 
  SELECT 'Actual On Plan' as FIELD_NAME, ia.INTERACTION_ID,ia.INTERACTION_DATE,ia.INTERACTION_TYPE,ia.INTERACTION_TA,ia.ATTENDEE_ID,ia.ATTENDEE_NAME,ia.ATTENDEE_USERID,ia.ATTENDEETYPE,ia.OL_STATUS
  FROM SC_Interaction_Attendee_View ia
  WHERE ia.OL_status in ('MPOL', 'MPA');


rem ----------------------------------------------------------------------------------------------

create or replace function GET_USER_REPORT_LEVEL(userid user_table.id%TYPE) 
RETURN user_relationship.user_id%TYPE is report_level user_relationship.user_id%TYPE;
begin
select nvl( relationship_type, 0 ) into report_level  from user_relationship where user_id = userid;
return report_level;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
     return -1;
end;
.
/
rem -------------------------------------------------------------------------------------------------------

truncate table GLOBAL_CONSTANTS;
insert into GLOBAL_CONSTANTS values (1, 'SCORECARD_NOT_PERMITTED_MSG', 'You are not authorized to run this report.');

commit;
rem ------------------------------------------------------- 
rem -- File created - Sunday-July-19-2009    
rem ------------------------------------------------------- 

rem ------------------------------------------------------- 
rem -- DDL for View SC_DLGUNDERSTANDING_Q1_ONC
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_DLGUNDERSTANDING_Q1_ONC (INTERACTION_TA, OBJECTIVE_UNDERSTANDING, FIELD_VALUE) AS SELECT interaction_ta, objective_understanding, count(*) as RECORD_COUNT
FROM sc_dlg_objective_view
WHERE interaction_date>=date'2009-07-20' AND interaction_date<=date'2009-07-20'
and interaction_ta='Oncology'
GROUP BY interaction_ta, objective_understanding
ORDER BY COUNT(*) DESC; 

rem ------------------------------------------------------- 
rem -- DDL for View SC_DLG_OBJ_VIEW_Q1_ONC_ERBITUX
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_DLG_OBJ_VIEW_Q1_ONC_ERBITUX (INTERACTION_TA, OBJECTIVE_PRODUCT, OBJECTIVE_NAME, RECORD_COUNT) AS SELECT interaction_ta, objective_product, objective_name, count(*) as RECORD_COUNT
FROM SC_dlg_objective_view
WHERE interaction_date>=date'2009-07-20' AND interaction_date<=date'2009-07-20'
and interaction_ta='Oncology'
and objective_product='Erbitux'
GROUP BY interaction_ta, objective_product, objective_name
ORDER BY count(*) DESC; 

rem ------------------------------------------------------- 
rem -- DDL for View SC_INQUIRY_VIEW_Q1
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_INQUIRY_VIEW_Q1 (INQUIRY_TOPIC, RECORD_COUNT) AS SELECT Inquiry_Topic, count(*) as Record_Count
FROM Sc_Inquiry_View
WHERE interaction_date>=date'2009-07-20' AND interaction_date<=date'2009-07-20'
GROUP BY Inquiry_Topic 
ORDER BY Inquiry_Topic; 

rem ------------------------------------------------------- 
rem -- DDL for View SC_INQUIRY_VIEW_Q1_ONC
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_INQUIRY_VIEW_Q1_ONC (INTERACTION_TA, INQUIRY_TOPIC, RECORD_COUNT) AS SELECT Interaction_TA, Inquiry_Topic, count(*) as Record_Count
FROM SC_Inquiry_View
WHERE interaction_date>=date'2009-07-20' AND interaction_date<=date'2009-07-20'
and interaction_TA='Oncology'
GROUP BY Interaction_TA, Inquiry_Topic
ORDER BY Interaction_TA, Inquiry_Topic; 

rem ------------------------------------------------------- 
rem -- DDL for View SC_INQUIRY_VIEW_Q1_ONC_ERBITUX
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_INQUIRY_VIEW_Q1_ONC_ERBITUX (INTERACTION_TA, INQUIRY_TOPIC, INQUIRY_PRODUCT, RECORD_COUNT) AS SELECT Interaction_TA, Inquiry_Topic, Inquiry_Product, count(*) as Record_Count
FROM SC_Inquiry_View
WHERE interaction_date>=date'2009-07-20' AND interaction_date<=date'2009-07-20'
and interaction_TA='Oncology'
and inquiry_product='Erbitux'
GROUP BY Interaction_TA, Inquiry_Topic, Inquiry_Product
ORDER BY Interaction_TA, Inquiry_Topic, Inquiry_Product; 

rem ------------------------------------------------------- 
rem -- DDL for View SC_INQUIRY_VIEW_Q1_ONC_MPA
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_INQUIRY_VIEW_Q1_ONC_MPA (INTERACTION_TA, INQUIRY_TOPIC, RECORD_COUNT) AS SELECT Interaction_TA, Inquiry_Topic,  count(*) as Record_Count
FROM SC_Inquiry_View
WHERE interaction_date>=date'2009-07-20' AND interaction_date<=date'2009-07-20'
and interaction_Ta='Oncology'
and first_attendee_ol_status='MPA'
GROUP BY Interaction_TA, Inquiry_Topic, First_Attendee_OL_Status
ORDER BY Interaction_TA, Inquiry_Topic, First_Attendee_OL_Status; 

rem ------------------------------------------------------- 
rem -- DDL for View SC_INQUIRY_VIEW_Q1_ONC_MPOL
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_INQUIRY_VIEW_Q1_ONC_MPOL (INTERACTION_TA, INQUIRY_TOPIC, RECORD_COUNT) AS SELECT Interaction_TA, Inquiry_Topic,  count(*) as Record_Count
FROM SC_Inquiry_View
WHERE interaction_date>=date'2009-07-20' AND interaction_date<=date'2009-07-20'
and interaction_Ta='Oncology'
and first_attendee_ol_status='MPOL'
GROUP BY Interaction_TA, Inquiry_Topic, First_Attendee_OL_Status
ORDER BY Interaction_TA, Inquiry_Topic, First_Attendee_OL_Status; 

rem ------------------------------------------------------- 
rem -- DDL for View SC_INQUIRY_VIEW_Q2
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_INQUIRY_VIEW_Q2 (INQUIRY_TOPIC, RECORD_COUNT) AS SELECT Inquiry_Topic, count(*) as Record_Count
FROM Sc_Inquiry_View
WHERE interaction_date>=date'2009-04-01' AND interaction_date<=date'2009-06-30'
GROUP BY Inquiry_Topic 
ORDER BY Inquiry_Topic; 


rem ------------------------------------------------------- 
rem -- DDL for View SC_INTERACTION_SUMMARY_VIEW_Q1
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_INTERACTION_SUMMARY_VIEW_Q1 (INTERACTION_TA, FIELD_NAME, FIELD_VALUE) AS 
  SELECT interaction_ta, 'Total Impacted' as FIELD_NAME, sum(total_attendee_count) as Field_Value
  FROM SC_ATTENDEE_COUNT_VIEW
  WHERE interaction_date>=date'2009-07-20' AND interaction_date<=date'2009-07-20'
  GROUP BY interaction_ta
UNION ALL
  SELECT interaction_ta, 'Actual On Plan' as FIELD_NAME, count(*) as Field_Value
  FROM SC_INTERACTION_MPOL_VIEW att
  WHERE interaction_date>=date'2009-07-20' AND interaction_date<=date'2009-07-20'
  and ol_status in ('MPOL', 'MPA')
  GROUP BY interaction_ta
UNION ALL
  SELECT interaction_ta, 'Field Response' as FIELD_NAME, count(*) as Field_Value
  FROM SC_INTERACTION_Reactive_View
  WHERE interaction_date>=date'2009-07-20' AND interaction_date<=date'2009-07-20'
  GROUP BY interaction_ta
UNION ALL
  SELECT interaction_ta, 'E-mail/Telephone' as FIELD_NAME, count(*) as Field_Value
  FROM SC_INTERACTION_EMAILPHONE_VIEW
  WHERE interaction_date>=date'2009-07-20' AND interaction_date<=date'2009-07-20'
  GROUP BY interaction_ta
UNION ALL
  SELECT interaction_ta, 'Group' as FIELD_NAME, count(*) as Field_Value
  FROM SC_interaction_group_view
  WHERE interaction_date>=date'2009-07-20' AND interaction_date<=date'2009-07-20'
  GROUP BY interaction_ta  ; 

rem ------------------------------------------------------- 
rem -- DDL for View SC_MSL_VIEW_Q1
rem ------------------------------------------------------- 

  CREATE OR REPLACE FORCE VIEW SC_MSL_VIEW_Q1 (MSL_USER_ID, MSL_TA, BEGIN_DATE, DAYS_IN_PD_AFTER_START_DATE, END_DATE, DAYS_IN_PD_B4_END_DATE) AS select 
  MSL_USER_ID, MSL_TA, 
  begin_date,
  date'2009-07-20'-greatest(begin_date,date'2009-07-20') as Days_In_Pd_After_Start_Date,
  end_date,
  least(end_date,date'2009-07-20')-date'2009-07-20' as Days_In_Pd_B4_End_Date
from SC_MSL_VIEW
WHERE end_date>=date'2009-07-20' AND begin_date<=date'2009-07-20'; 

rem -------------------------------------------------------
rem -- DDL for View SC_ACTIVITY_SUMMARY_VIEW_Q1
rem -------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW SC_ACTIVITY_SUMMARY_VIEW_Q1 (INTERACTION_TA, FIELD_NAME, FIELD_VALUE) AS 
  SELECT MSL_TA as INTERACTION_TA, 'Field MSLs' AS FIELD_NAME, COUNT(DISTINCT MSL_USER_ID)  AS FIELD_VALUE
  FROM SC_MSL_VIEW
  WHERE end_date>=date'2009-01-01' AND begin_date<=date'2009-03-31'
  GROUP BY MSL_TA
UNION ALL  
  SELECT MSL_TA as INTERACTION_TA, 'MP OLs' AS FIELD_NAME, count(*) AS FIELD_VALUE
  FROM SC_MSL_MPOL_VIEW
  WHERE end_date>=date'2009-01-01' AND begin_date<=date'2009-03-31'
  GROUP BY MSL_TA
UNION ALL  
  SELECT INTERACTION_TA, 'Total Interactions' AS FIELD_NAME, COUNT(*) AS FIELD_VALUE
  FROM SC_INTERACTION_VIEW
  WHERE interaction_date>=date'2009-01-01' AND interaction_date<=date'2009-03-31'
  GROUP BY interaction_ta  
UNION ALL   
  SELECT INTERACTION_TA, '# Proactive Visits' AS FIELD_NAME, COUNT(*) AS FIELD_VALUE
  FROM SC_INTERACTION_PROACTIVE_VIEW
  WHERE interaction_date>=date'2009-01-01' AND interaction_date<=date'2009-03-31'
  GROUP BY interaction_ta   
UNION ALL  SELECT INTERACTION_TA, '# Field Response Visits' AS FIELD_NAME, COUNT(*) AS FIELD_VALUE
  FROM SC_INTERACTION_REACTIVE_VIEW
  WHERE interaction_date>=date'2009-01-01' AND interaction_date<=date'2009-03-31'
  GROUP BY interaction_ta  
UNION ALL
  SELECT INTERACTION_TA, 'OL Email Interactions' AS FIELD_NAME, COUNT(*) AS FIELD_VALUE
  FROM SC_INTERACTION_EMAIL_VIEW
  WHERE interaction_date>=date'2009-01-01' AND interaction_date<=date'2009-03-31'
  GROUP BY interaction_ta    
UNION ALL
  SELECT INTERACTION_TA, 'OL Telephone Interactions' AS FIELD_NAME, COUNT(*) AS FIELD_VALUE
  FROM sc_INTERACTION_phone_view
  WHERE interaction_date>=date'2009-01-01' AND interaction_date<=date'2009-03-31'
  GROUP BY interaction_ta    
UNION ALL
  SELECT INTERACTION_TA, 'HCM Presentations' AS FIELD_NAME, COUNT(*) AS FIELD_VALUE
  FROM sc_INTERACTION_hcmpres_view
  WHERE interaction_date>=date'2009-01-01' AND interaction_date<=date'2009-03-31'
  GROUP BY interaction_ta    
UNION ALL
  SELECT INTERACTION_TA, 'Other Group Presentations' AS FIELD_NAME, COUNT(*) AS FIELD_VALUE
  FROM sc_INTERACTION_otherpres_view
  WHERE interaction_date>=date'2009-01-01' AND interaction_date<=date'2009-03-31'
  GROUP BY interaction_ta    
UNION ALL
  SELECT INTERACTION_TA, 'Total 1 on 1 Impacted' AS FIELD_NAME, SUM(TOTAL_ATTENDEE_COUNT) as FIELD_VALUE
  FROM sc_1on1_attendee_count_view
  WHERE interaction_date>=date'2009-01-01' AND interaction_date<=date'2009-03-31'
  GROUP BY interaction_ta  
UNION ALL
  SELECT INTERACTION_TA, 'Total Impacted (group, 1-1, phone, email)' AS FIELD_NAME, SUM(TOTAL_ATTENDEE_COUNT) AS FIELD_VALUE
  FROM sc_attendee_count_view
  WHERE interaction_date>=date'2009-01-01' AND interaction_date<=date'2009-03-31'
  GROUP BY INTERACTION_TA;


rem ------------------------------------------------------- 

SET ECHO OFF

exit;

