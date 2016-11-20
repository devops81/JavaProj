
CREATE OR REPLACE FORCE VIEW OL_INTERACTIONS_VIEW ("INTERACTION_ID", "INTERACTIONDATE", "INTERACTION_TYPE", "IMPACTED", "INTENTOFVISIT", "OLID", "PRODUCT1", "PRODUCT2", "PRODUCT3", "ACTIVITY_TYPE", "MSLID") AS 
select
int.interaction_id,
interactiondate, 
type_lookup.optvalue as interaction_type,
(select count(attendeeCount.attendee_id) from attendees attendeeCount
where int.interaction_id = attendeecount.interaction_id) + 
(select nvl(sum(nvl(otherAttendeeCount.data, 0)),0)
  from interaction_data otherAttendeeCount
  where int.interaction_id = otherAttendeeCount.interaction_id and
  otherAttendeeCount.type = 'AttendeeType' )as impacted,
nvl(intentOfVisit_data.data,'') as intentOfVisit,
kol_table.kolid as olid, 
product1_lookup.optvalue as product1,
product2_lookup.optvalue as product2,
product3_lookup.optvalue as product3,
activity_lookup.optvalue as activity_type,
msl_table.id as mslid
from interaction int, option_lookup type_lookup, attendees att, user_table kol_table,
option_lookup product1_lookup, option_lookup product2_lookup, option_lookup product3_lookup,
interaction_data product_data,
interaction_data activity_data, option_lookup activity_lookup,
user_table msl_table, interaction_data intentOfVisit_data
where
int.interaction_type_id = type_lookup.id and
int.interaction_id = att.interaction_id and
kol_table.id = att.userid and
int.interaction_id = product_data.interaction_id and
product_data.lovid = product1_lookup.id and
product_data.secondary_lovid = product2_lookup.id (+) and
product_data.tertiary_lovid = product3_lookup.id (+) and
product_data.type = 'productMultiselectIds' and
int.interaction_id = activity_data.interaction_id and
activity_lookup.id = activity_data.secondary_lovid and
activity_data.type = 'interactionTypeLOVTripletIds' and
msl_table.id = int.userid and
int.interaction_id = intentOfVisit_data.interaction_id and
intentOfVisit_data.type = 'intentOfVisit';


CREATE OR REPLACE FORCE VIEW OPINION_LEADERS_VIEW ("INTERACTION_ID", "FIRSTNAME", "LASTNAME", "TAG", "MSLID") AS 
  select
int.interaction_id,
edm.firstname as firstname,
edm.lastname as lastname,
edm.msl_ol_type as tag,
int.userid as mslid
from interaction int, attendees att, expert_details_mview edm
where att.interaction_id =  int.interaction_id and
att.userid = edm.id;
 


CREATE OR REPLACE FORCE VIEW OFF_LABEL_INQUIRIES_VIEW ("INTERACTION_ID", "OLID", "PRODUCT", "INQUIRY_TOPIC", "MSLID", "INTERACTIONDATE") AS 
  select
int.interaction_id,
kol_table.kolid as olid,
product_lookup.optvalue as product,
topic_lookup.optvalue as inquiry_topic,
int.userid as mslid,
int.interactiondate
from interaction int, attendees att,
option_lookup product_lookup, option_lookup topic_lookup,
interaction_data intdata, user_table kol_table
where int.interaction_id = att.interaction_id and
int.interaction_id = intdata.interaction_id and
intdata.type = 'unsolictedOffLabelTripletIds' and
intdata.lovid = product_lookup.id and
intdata.secondary_lovid = topic_lookup.id and
att.userid = kol_table.id;



CREATE OR REPLACE FORCE VIEW EDU_DIALOGUE_OBJ_VIEW ("INTERACTION_ID", "OLID", "PRODUCT", "DIALOG_OBJECTIVE", "INTERACTIONDATE", "MSL_ASSESSMENT", "MSLID") AS 
  select
int.interaction_id,
kol_table.kolid as olid,
product_lookup.optvalue as product,
objective_lookup.optvalue as dialog_objective,
int.interactiondate,
assessment_lookup.optvalue as msl_assessment ,
int.userid as mslid
from interaction int, attendees att,
option_lookup product_lookup, option_lookup objective_lookup,
option_lookup assessment_lookup,
interaction_data product_data, interaction_data educational_data, 
user_table kol_table
where int.interaction_id = att.interaction_id and
int.interaction_id = product_data.interaction_id and
product_data.type = 'productMultiselectIds' and
product_data.lovid = product_lookup.id and
int.interaction_id = educational_data.interaction_id and
educational_data.type = 'educationalObjectivesMultiselectIds' and
educational_data.lovid = objective_lookup.id and
educational_data.secondary_lovid = assessment_lookup.id and
att.userid = kol_table.id;
 

 

 
