CREATE OR REPLACE FORCE VIEW SPEAKERTRAININGVIEW ("INTERACTIONID", "DATA", "INTERACTIONTOPIC", "INTERACTION_SUBTOPIC", "DISEASESTATEPRODUCTS", "SPEAKERTRAININGPRODUCTS", "PRODUCTPRESENTATIONPRODUCTS", "INTTYPELOVID", "INTTOPICLOVID", "INTSUBTOPICLOVID", "STATUS") AS 
  select idata.interaction_id as InteractionId, idata.data as data, 
topic.optvalue as interactionTopic, subtopic.optvalue as Interaction_SubTopic,
getproactivedecks(idata.interaction_id, idata.lovid, idata.secondary_lovid, idata.tertiary_lovid, 'diseaseStateMultiselectIds', 'diseaseStateSection')
as diseaseStateProducts,
getproactivedecks(idata.interaction_id, idata.lovid, idata.secondary_lovid, idata.tertiary_lovid, 'speakerDecksMultiselectIds', 'speakerTrainingSection')
as speakerTrainingProducts,
getproactivedecks(idata.interaction_id, idata.lovid, idata.secondary_lovid, idata.tertiary_lovid, 'ProductPresentationMultiselectIds', 'productPresentationSection')
as productpresentationProducts,
idata.lovid intTypeLOVId, idata.secondary_lovid as intTopicLOVId, 
idata.tertiary_lovid as intSubTopicLOVId,
iplan.status as status
from interaction_data idata 
left outer join option_lookup topic
on (topic.id = idata.secondary_lovid)
left outer join option_lookup subtopic
on (subtopic.id = idata.tertiary_lovid)
left outer join iplan_data iplan
on(idata.interaction_id= iplan.INTERACTIONID)
where idata.type = 'interactionTypeLOVTripletIds';
 