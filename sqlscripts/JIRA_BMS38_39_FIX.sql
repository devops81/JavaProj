SET ECHO ON

update option_lookup set optvalue = 'Engages in Dialogue with Colleagues/Others'  where optvalue = 'Engages in Dialouge with Colleagues/Others';

alter trigger EDU_PRODUCT_TRIGGER disable;

update interaction_data set secondary_lovid = 83398424 where secondary_lovid = 97347688 and type = 'educationalObjectivesMultiselectIds';

alter trigger EDU_PRODUCT_TRIGGER enable;

delete from option_lookup where id = 97347688;

commit;


SET ECHO OFF

exit


