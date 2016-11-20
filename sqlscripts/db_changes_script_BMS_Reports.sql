rem ------------------------------------------------------------------------------------------------
rem Filename    :   db_changes_script_BMS_Reports.sql
rem Purpose	:   SQL changes for Reports
rem             
rem Date	:   15-Jun-2009
rem Author	:   Tapan
rem ------------------------------------------------------------------------------------------------

SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : db_changes_script_BMS_Reports.log
SPOOL db_changes_script_BMS_Reports.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------

rem : Batch : 1

 CREATE OR REPLACE FORCE VIEW USER_RELATIONSHIP_VIEW ("USERID", "TERRITORY_ID", "TERRITORY", "REGION_ID", 
 "REGION", "TA_ID", "TA", "NAME", "MSL_START", "REGIONUSER_ID", "REGIONUSER", 
 "TERRITORYSTARTDATE", "REGIONSTARTDATE") AS 
  select 
u.id as userId,
o.id as territory_id,
o.optvalue as territory,
o1.id as region_id,
o1.optvalue as region,
o2.id as TA_ID,
o2.optvalue as TA,
u.lastname||', '||u.firstname name,
u.msl_start_date msl_start,
u2.id as regionuser_id,
u2.lastname||', '||u2.firstname RegionUser,
u.msl_start_date territoryStartDate,
u2.msl_start_date regionStartDate
from user_table u,
user_relationship ur,
user_relationship ur1,
user_table u2,
option_lookup o,
option_lookup o1,
option_lookup o2
where 
ur.user_id = u.id
and ur1.user_id = u2.id
and o.id = ur.territory
and o1.id = ur1.territory
and o1.id = o.parent
and o2.id = o1.parent
and ur.relationship_type = 1
and ur1.relationship_type = 2;
.
/


CREATE OR REPLACE
FUNCTION getMSLVisitFrequency(mslId NUMBER, startDate timestamp, endDate timestamp, 
msloltype varchar2) RETURN number is 
frequency number;
totalFrequency number;
totalOl number;
begin
totalFrequency := 0;
totalOl := 0;
frequency := 0;
declare
cursor c1 is
select att.userid as attendeeUserId, 
inter.userid as interactionCreator,
count(distinct(inter.interaction_id)) as visits, 
trunc(((max(inter.interactiondate) - min(inter.interactionDate))/7)) as weeks
from attendees att
left outer join 
(select i.* from interaction i, interaction_data idata
where
idata.interaction_id = i.interaction_id
and i.interactiondate >= startDate
and i.interactiondate <= endDate
and i.deleteflag = 'N'
and i.interaction_type_id = 
(select id from option_lookup where upper(optValue) = '1:1 FACE TO FACE (2 OR LESS)' and 
option_id = (select id from option_names where upper(name) = 'INTERACTION TYPE'))
and idata.lovid in 
(select optl.id from option_lookup optl where optl.option_id = 
(select id from option_names optn where upper(optn.name) = 'PRODUCT'))
)inter
on (inter.interaction_id = att.interaction_id)
group by att.userid, inter.userid
having 
inter.userid = mslId
and att.userid in (
select distinct(edm.id) from user_table ut, contacts con, expert_details_mview edm
where ut.id = mslId
and con.staffid = ut.staffid
and edm.id = con.kolid
--and edm.msl_ol_type in (msloltype)
and msloltype like '%'||edm.msl_ol_type||'%'
and edm.msl_ol_type is not null
);
begin
for cr in c1
loop
if cr.visits >= 1 and cr.weeks > 0 then
 totalFrequency := totalFrequency + (cr.weeks/cr.visits);
 totalOl := totalOl + 1;
end if;
end loop;
end;
if totalFrequency >0 and totalOl > 0 then
 frequency := totalFrequency/totalOl;
 return round(frequency, 2);
else
 return 0;
end if;
END;
.
/

rem : 1>Author name 		: Tapan
rem : 2>Report Name		: MPOL/HCP Visit Frequency Reports
rem : 3>Date of change 		: 01-Jul-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 2

create or replace FUNCTION getUser(userid IN NUMBER) RETURN VARCHAR2 AS name VARCHAR2(200);

   BEGIN
    select user_table.lastname||', '||user_table.firstname into name from user_table where id=userid;
    RETURN name;
   EXCEPTION
   when NO_DATA_FOUND then
      DBMS_OUTPUT.PUT_LINE('Caught raised exception NO_DATA_FOUND');
      return null;
   END;
.
/

rem ------------------------------------------------------------------------------------------------

create or replace FUNCTION  getUsersTerritory(userid NUMBER)
RETURN varchar2 AS territory varchar2(255) ;
region_no option_lookup.PARENT%type;

BEGIN
   select option_lookup.optValue,parent into territory,region_no from option_lookup where id in (select user_relationship.territory from user_relationship where user_id = userid);
   RETURN territory;
   EXCEPTION
   when NO_DATA_FOUND then
   DBMS_OUTPUT.PUT_LINE('Caught raised exception NO_DATA_FOUND');
   return null;
  
END;
.
/

rem ------------------------------------------------------------------------------------------------

create or replace FUNCTION  getUserRegion(userid NUMBER)
RETURN varchar2 IS territory_region varchar2(255) ;
territory varchar2(255);
region_no option_lookup.PARENT%type;

BEGIN
   select option_lookup.optValue,parent into territory,region_no from option_lookup where id in (select user_relationship.territory from user_relationship where user_id = userid);
   select option_lookup.optValue into territory_region from option_lookup where id=region_no;
   RETURN territory_region;
   EXCEPTION
   when NO_DATA_FOUND then
   DBMS_OUTPUT.PUT_LINE('Caught raised exception NO_DATA_FOUND');
   return null;
  
END;
.
/

rem ------------------------------------------------------------------------------------------------

create or replace FUNCTION  getQuestionText(qn_id NUMBER,sur_id  number)
RETURN varchar is var varchar(400) ;
num number;
BEGIN

   select questiontext into var from surveyquestionsmetadata where id = qn_id;
   select cast(questionnumber as number) into num from surveyquestionsmetadata where id = qn_id and surveyid = sur_id;
   var :=num||') '||var;
   return var; 
   EXCEPTION
   when NO_DATA_FOUND then
      DBMS_OUTPUT.PUT_LINE('Caught raised exception NO_DATA_FOUND');
      return null;  
 
END;
.
/

rem ------------------------------------------------------------------------------------------------

create or replace FUNCTION  getanswer(qn_id NUMBER,questionid number,ans varchar2)
RETURN varchar is var varchar(4000) ;

type_qn surveyQuestionsmetadata.type%type;
answerText filled_Questions.ANSWER_TEXT%type;
cursor subQuestions is select sub_question , answer_option from filled_subques_answers where parent_question = qn_id;
subQn filled_subques_answers.PARENT_QUESTION%type;
subquestion_text surveysubquestionsmetadata.SUBQUESTIONTEXT%type;
answer_option filled_subques_answers.ANSWER_OPTION%type;
subanswer_text surveyanswersdata.ANSWERTEXT%type;

BEGIN

    select type into type_qn from surveyquestionsmetadata where id = questionid;
   
    case 
      when type_qn = 'simpleText' or  type_qn ='numText'
      then
          var :=ans;
  
      when type_qn = 'likert' or  type_qn ='likert5'
      then 
           var :='';
      
          open subQuestions;
          fetch subQuestions into subqn , answer_option ;
          while(subQuestions%found)
          loop
       
              select SubQuestionText into subquestion_text from surveysubquestionsmetadata where id = subqn;
              select answertext into subanswer_text from surveyanswersdata where id = answer_option;
              var := var || subquestion_text||'||'||subanswer_text||',';

              fetch subQuestions into subqn , answer_option ;

          end loop;
          close subquestions;

     when  type_qn = 'multioptmultisel' or  type_qn ='multioptsinglesel'
       then
           var :='';
            open subQuestions;
            fetch subQuestions into subqn , answer_option ;
            while(subQuestions%found)
            loop
       
              select answertext into subanswer_text from surveyanswersdata where id = answer_option;
              if var!='' then
              var := ',';
              end if;
               var := var||subanswer_text;
               
              fetch subQuestions into subqn , answer_option ;
       
            end loop;
            close subquestions;
           
    else
       dbms_output.put('Wrond Id');
         end case;  
 
return var; 
 EXCEPTION
    when NO_DATA_FOUND then
    DBMS_OUTPUT.PUT_LINE('Caught raised exception NO_DATA_FOUND');
     return var;

END;
.
/

rem : 1>Author name 		: Yatin
rem : 2>Report Name		: Generic Survey Export
rem : 3>Date of change 		: 25-Jun-2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 3


create or replace function getProactiveDecks(interactionId number, intType number, intTopic number, intSubTopic number, idataType varchar2, sectionType varchar2) 
return varchar2 is proactiveDecks varchar2(4000);
begin
proactiveDecks := '';
declare
sectionOpened varchar2(1000);
countOfSection number;

cursor c1 is
select decks.optValue from interaction_data idata left outer join option_lookup decks
on (decks.id = idata.lovid)
where idata.type = idataType
and idata.interaction_id = interactionId;

begin
countOfSection := 0;

select count(ils.section) into countOfSection from interaction_lovtriplet_section ils 
where ils.primary_lovid = intType
and ils.secondary_lovid = intTopic
and ils.tertiary_lovid = intSubTopic;

if countOfSection != 0 then

  select ils.section into sectionOpened from interaction_lovtriplet_section ils 
  where ils.primary_lovid = intType
  and ils.secondary_lovid = intTopic
  and ils.tertiary_lovid = intSubTopic;
  
  if sectionOpened is not null and sectionOpened = sectionType and sectionOpened = 'speakerTrainingSection' then
    for cr in c1
    loop
    proactiveDecks := proactiveDecks||cr.optValue||' |' ;
    end loop;
    RETURN substr(proactiveDecks,0,length(proactiveDecks)-1);
  end if; 
  
  if sectionOpened is not null and sectionOpened = sectionType and sectionOpened = 'productPresentationSection' then
    for cr in c1
    loop
    proactiveDecks := proactiveDecks||cr.optValue||' |' ;
    end loop;
    RETURN substr(proactiveDecks,0,length(proactiveDecks)-1);
  end if; 
  
  if sectionOpened is not null and sectionOpened = sectionType and sectionOpened = 'diseaseStateSection' then
    for cr in c1
    loop
    proactiveDecks := proactiveDecks||cr.optValue||' |' ;
    end loop;
    RETURN substr(proactiveDecks,0,length(proactiveDecks)-1);
  end if; 
  
end if;
  
end;
RETURN null;
end;
.
/

CREATE OR REPLACE FORCE VIEW INTERACTIONDETAILREPORTVIEW  AS 
  select idata.interaction_id as InteractionId, idata.data as data, 
topic.optvalue as interactionTopic, subtopic.optvalue as Interaction_SubTopic,
getproactivedecks(idata.interaction_id, idata.lovid, idata.secondary_lovid, idata.tertiary_lovid, 'diseaseStateMultiselectIds', 'diseaseStateSection')
as diseaseStateProducts,
getproactivedecks(idata.interaction_id, idata.lovid, idata.secondary_lovid, idata.tertiary_lovid, 'speakerDecksMultiselectIds', 'speakerTrainingSection')
as speakerTrainingProducts,
getproactivedecks(idata.interaction_id, idata.lovid, idata.secondary_lovid, idata.tertiary_lovid, 'ProductPresentationMultiselectIds', 'productPresentationSection')
as productpresentationProducts,
idata.lovid intTypeLOVId, idata.secondary_lovid as intTopicLOVId, 
idata.tertiary_lovid as intSubTopicLOVId
from interaction_data idata 
left outer join option_lookup topic
on (topic.id = idata.secondary_lovid)
left outer join option_lookup subtopic
on (subtopic.id = idata.tertiary_lovid)
where idata.type = 'interactionTypeLOVTripletIds';
 


create or replace FUNCTION InteractionDetailAttendeeCount(interactionId NUMBER) RETURN number is totalAttendeeCount number;
begin
totalAttendeeCount:=0;
declare
idataAttendeeCount number;
attAttendeeCount number;
begin
attAttendeeCount :=0;
idataAttendeeCount :=0;

select nvl(sum(nvl(otherAttendeeCount.data, 0)),0) into idataAttendeeCount
from interaction_data otherAttendeeCount
where otherAttendeeCount.interaction_id = interactionId and
otherAttendeeCount.type = 'AttendeeType';

select count(*) into attAttendeeCount from attendees att 
where att.interaction_id = interactionId;

totalAttendeeCount := idataAttendeeCount+attAttendeeCount;
end;
RETURN totalAttendeeCount;
END;
.
/

CREATE OR REPLACE
function getMSLInteractionCount(interactionUserId number, startDate timestamp, endDate timestamp) return number is mslinteractionCount number;
begin
mslInteractionCount := 0;

select count(inter.interaction_id) into mslInteractionCount from interaction inter 
where inter.userid = interactionUserId and inter.deleteflag = 'N'
and inter.interactionDate >= startdate and inter.interactionDate <= endDate;

return mslInteractionCount;
end;
.
/

CREATE OR REPLACE
function getRegionInteractionCount(regionId number, startDate timestamp, endDate timestamp) return number is regionInteractionCount number;
begin
regionInteractionCount := 0;

select count(inter.interaction_id) into regionInteractionCount from interaction inter 
where inter.userid in 
(select urv.userid from user_relationship_view urv where urv.region_id = regionId)
and inter.interactiondate >= startDate
and inter.interactiondate <= endDate
and inter.deleteflag = 'N';

return regionInteractionCount;
end;
.
/



create  table temp_triplet_rank (id number, rnk number);

insert into temp_triplet_rank
select it.id, rank() over (partition by it.interaction_id order by it.id) rnk from interaction_data it
where it.type = 'interactionTypeLOVTripletIds';

CREATE INDEX EMP_TRIPLET_RANK_INDEX1 ON TEMP_TRIPLET_RANK (ID); 

update interaction_data ito set ito.data = (select ttr.rnk from temp_triplet_rank ttr where ttr.id = ito.id )
where ito.id in (select id from temp_triplet_rank)
and ito.type = 'interactionTypeLOVTripletIds'
and ito.data is null;

drop table temp_triplet_rank;
 
commit;

rem : 1>Author name 		: Tapan
rem : 2>Report Name		: Interaction Detail Report
rem : 3>Date of change 		: 02-Jul-2009

rem ------------------------------------------------------------------------------------------------


rem : Batch : 5

  CREATE OR REPLACE FORCE VIEW USER_RELATIONSHIP_VIEW_NEW  AS 
  select 
u.id as userId,
o.id as territory_id,
o.optvalue as territory,
o1.id as region_id,
o1.optvalue as region,
o2.id as TA_ID,
o2.optvalue as TA,
u.lastname||', '||u.firstname name,
u.msl_start_date msl_start,
u2.id as regionuser_id,
u2.lastname||', '||u2.firstname RegionUser,
u.msl_start_date territoryStartDate,
u2.msl_start_date regionStartDate
from user_table u,
user_relationship ur,
user_relationship ur1,
user_table u2,
option_lookup o,
option_lookup o1,
option_lookup o2
where 
ur.user_id = u.id
and ur1.user_id = u2.id
and o.id = ur.territory
and o1.id = ur1.territory
and o1.id = o.parent
and o2.id = o1.parent
and ur.relationship_type = 1
and ur1.relationship_type = 2
and ur.begin_date < sysdate
and ur.end_date > sysdate
and ur1.begin_date < sysdate
and ur1.end_date > sysdate;


rem : 1>Author name 		: Tapan
rem : 2>Report Name		: Assigned HCP OL Summary Report
rem : 3>Date of change 		: 01-Jul-2009

rem ------------------------------------------------------------------------------------------------


commit;

rem user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

SPOOL OFF


SET ECHO OFF



exit;




rem ------------------------------------------------------------------------------------------------

