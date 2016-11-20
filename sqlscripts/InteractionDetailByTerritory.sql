 CREATE OR REPLACE FORCE VIEW INTERACTION_TA_RELATIONSHIP  AS 
  (
select i.interaction_id,i.interaction_type_id,i.deleteflag ,i.interactiondate,u.id as userid,u.lastname||', '||u.firstname name,ta.id as ta_id,ta.optvalue as ta,region.id as region_id,region.optvalue as region,territory.id as territory_id,territory.optvalue as territory from interaction i
left outer join option_lookup ta
on(ta.id=i.ta)
left outer join option_lookup territory
on(territory.id=i.territory_id)
left outer join option_lookup region 
on(territory.parent=region.id)
left outer join user_table u
on(u.id=i.userid)
where i.territory_id >0
);


CREATE OR REPLACE
function getMSLInteractionCountT(interactionUserId number,territoryId number, startDate timestamp, endDate timestamp) return number is mslinteractionCount number;
begin
mslInteractionCount := 0;

select count(inter.interaction_id) into mslInteractionCount from interaction inter 
where inter.userid = interactionUserId and inter.deleteflag = 'N'
and inter.interactionDate >= startdate and inter.interactionDate <= endDate
and inter.territory_id=territoryId;

return mslInteractionCount;
end;

create or replace function getRegionInteractionCountT(regionId number, startDate timestamp, endDate timestamp) return number is regionInteractionCount number;
begin
regionInteractionCount := 0;

select count(inter.interaction_id) into regionInteractionCount from interaction inter 
where inter.userid in 
(select urv.userid from interaction_ta_relationship urv where urv.region_id = regionId)
and inter.interactiondate >= startDate
and inter.interactiondate <= endDate
and inter.deleteflag = 'N';

return regionInteractionCount;
end;