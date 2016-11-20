rem ------------------------------------------------------------------------------------------------
rem Filename    :   db_changes_script_BMSv3.1.sql
rem Purpose	:   SQL changes for version 3.1
rem             
rem Date	:   18-FEB-2010
rem Author	:   Vinay Rao	
rem ------------------------------------------------------------------------------------------------

SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : db_changes_script_BMSv3.1.log

SPOOL db_changes_script_BMSv3.1.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------

rem : Batch : 1

 CREATE OR REPLACE FORCE VIEW "USER_RELATIONSHIP_VIEW_HQ" ("REPORTLEVEL", "TERRITORY", "TERRITORY_ID", "REGION", "REGION_ID", "TA", "TA_ID", "NAME", "USERID", "TERRITORYSTARTDATE") AS 
  (
(select ur.relationship_type as ReportLevel,
optl.optValue as Territory,
optl.id as territory_id,
optl_region.optValue as Region,
optl_region.id as region_id,
optl_ta.optValue as TA,
optl_ta.id as Ta_id,
ut.lastname||', '||ut.firstname as name,
ut.id as userId,
ur.begin_date as territoryStartDate

from user_table ut
inner join user_relationship ur
on (ur.user_id = ut.id)
inner join option_lookup optl
on (optl.id = ur.territory)
inner join user_table ut_regionLevel
on (ut_regionLevel.id = ur.related_user_id)
inner join user_relationship ur_region
on (ur_region.user_id = ut_regionLevel.id)
inner join option_lookup optl_region
on (optl_region.id = ur_region.territory)
inner join user_table ut_taLevel
on (ut_taLevel.id = ur_region.related_user_id)
inner join user_relationship ur_ta
on (ur_ta.user_id = ut_taLevel.id)
inner join option_lookup optl_ta
on (optl_ta.id = ur_ta.territory)
where ut.deleteflag = 'N'
and ut_regionLevel.deleteflag = 'N'
and ut_taLevel.deleteflag = 'N'
and ur.relationship_type = 1
and ur_region.relationship_type = 2
and ur_ta.relationship_type = 3
and ur.begin_date <= sysdate
and ur.end_date >= sysdate
and ur_region.begin_date <= sysdate
and ur_region.end_date >= sysdate
and ur_ta.begin_date <= sysdate
and ur_ta.end_date >= sysdate)
union
( 
select ur_region.relationship_type as ReportLevel,
'N/A' as Territory,
null as territory_id,
optl_region.optValue as Region,
optl_region.id as region_id,
optl_ta.optValue as TA,
optl_ta.id as Ta_id,
ut_regionLevel.lastname||', '||ut_regionLevel.firstname as name,
ut_regionLevel.id as userId,
ur_region.begin_date as territoryStartDate

from user_table ut_regionLevel
inner join user_relationship ur_region
on (ur_region.user_id = ut_regionLevel.id)
inner join option_lookup optl_region
on (optl_region.id = ur_region.territory)
inner join user_table ut_taLevel
on (ut_taLevel.id = ur_region.related_user_id)
inner join user_relationship ur_ta
on (ur_ta.user_id = ut_taLevel.id)
inner join option_lookup optl_ta
on (optl_ta.id = ur_ta.territory)
where ut_regionLevel.deleteflag = 'N'
and ut_taLevel.deleteflag = 'N'
and ur_region.relationship_type = 2
and ur_ta.relationship_type = 3
and ur_region.begin_date <= sysdate
and ur_region.end_date >= sysdate
and ur_ta.begin_date <= sysdate
and ur_ta.end_date >= sysdate
)
union
(select ur_ta.relationship_type as ReportLevel,
'N/A' as Territory,
null as territory_id,
'N/A' as Region,
null as region_id,
optl_ta.optValue as TA,
optl_ta.id as Ta_id,
ut_ta.lastname||', '||ut_ta.firstname as name,
ut_ta.id as userId,
ur_ta.begin_date as territoryStartDate
from user_table ut_ta
inner join user_relationship ur_ta
on (ur_ta.user_id = ut_ta.id)
inner join option_lookup optl_ta
on (optl_ta.id = ur_ta.territory)
where ut_ta.deleteflag = 'N'
and ur_ta.relationship_type in (3,4)
and ur_ta.begin_date <= sysdate
and ur_ta.end_date >= sysdate
));
 
commit;

rem : 1>Author name         : Vinay Rao
rem : 2>Purpose of change   : View for Interaction Detail Report 
rem : 3>Date of change      : 23/02/2010

rem ------------------------------------------------------------------------------------------------
 
rem : Batch : 2

alter table iplan_map_value add deleteFlag varchar2(1);
update iplan_map_value set deleteFlag='N';
commit;

rem : 1>Author name         : Tapan Ghia
rem : 2>Purpose of change   : Adding Deleteflag to iPlan_Map_Value table.
rem : 3>Date of change      : 24/02/2010

rem ------------------------------------------------------------------------------------------------
 
rem : Batch : 3

create table Zip_LatLong_Map 
(zip_code varchar2(4000), Latitude float(126), longitude float(126));


CREATE OR REPLACE
PROCEDURE Map_zip_lat_long 
as 
userid user_table.id%type;
userlongtitude user_table.longitude%type;
userlatitude user_table.latitude%type;
Zlongitude zip_latlong_map.longitude%type;
Zlatitude zip_latlong_map.latitude%type;
CURSOR longitude_latitude_null is 
select id, longitude,latitude from user_table where 
(latitude is null or longitude is null or latitude=0 or longitude=0) and user_type_id=4;
BEGIN
open longitude_latitude_null;

if longitude_latitude_null%ISOPEN then
loop
Zlongitude:=0;
Zlatitude:=0;
fetch longitude_latitude_null into userid,userlongtitude,userlatitude;
begin
select longitude,latitude into Zlongitude, Zlatitude from zip_latlong_map where zip_code=(select edmv.addr_postal_code from expert_details_mview edmv where edmv.id=userid);
exception when no_data_found then null;
end;
update user_table  set longitude= Zlongitude,latitude= Zlatitude where id=userid;
exit when longitude_latitude_null%notfound;

end loop;
end if;
END;
.
/

commit;

rem : 1>Author name         : Tapan Ghia
rem : 2>Purpose of change   : Enabling GeoMapping on Latitude Longitude, Procedure to update the Latitude/Longitude.
rem : 3>Date of change      : 24/02/2010

rem ------------------------------------------------------------------------------------------------
 
rem : Batch : 4

insert into option_names values (hibernate_sequence.nextVal, 'Source Referenced', (select id from option_names where name like 'Off-label Topics'));
commit;

rem : 1>Author name         : Tapan Ghia
rem : 2>Purpose of change   : Adding Source Referenced LOV.
rem : 3>Date of change      : 05/03/2010

rem ------------------------------------------------------------------------------------------------
 
rem : Batch : 5

insert into attributetable (attribute_id, parent_id, name, description, entity_type_id, 
mandatory, searchable, attributesize, arraylist, optionid, showable, display_order) values  (
hibernate_sequence.nextVal, (select entity_type_id from attributetable where name like 'Address'),
'Address Line 3', 'Address Line 3', '1', '0', '0', 'Small', '0', '0', '1', '10000' );

insert into attributetable (attribute_id, parent_id, name, description, entity_type_id, 
mandatory, searchable, attributesize, arraylist, optionid, showable, display_order) values  (
hibernate_sequence.nextVal, (select entity_type_id from attributetable where name like 'Address'),
'Address Line 4', 'Address Line 4', '1', '0', '0', 'Small', '0', '0', '1', '10000' );

insert into attributetable (attribute_id, parent_id, name, description, entity_type_id, 
mandatory, searchable, attributesize, arraylist, optionid, showable, display_order) values  (
hibernate_sequence.nextVal, (select entity_type_id from attributetable where name like 'Address'),
'CMEH Address ID', 'CMEH Address ID', '1', '0', '0', 'Small', '0', '0', '0', '10000' );


update attributetable set display_order = 5 where name like 'Address Line 3';
update attributetable set display_order = 6 where name like 'Address Line 4';
update attributetable set display_order = 7 where name like 'Address City';
update attributetable set display_order = 8 where name like 'Address State/Prov.';
update attributetable set display_order = 9 where name like 'Address Postal Code';
update attributetable set display_order = 10 where name like 'Address Country';

insert into option_names values (hibernate_sequence.nextVal, 'Region_Code', '-1');

insert into option_names values (hibernate_sequence.nextVal, 'Sub-Region', (select id from option_names where name like 'Region_Code'));

insert into attributetable (attribute_id, parent_id, name, description, entity_type_id, 
mandatory, searchable, attributesize, arraylist, optionid, showable, display_order) values  (
hibernate_sequence.nextVal, (select entity_type_id from attributetable where name like 'Identifiers'),
'Region', 'Region', '5', '0', '1', 'Small', '0', 
(select id from option_names where name like 'Region_Code'), '1', '10000' );


insert into attributetable (attribute_id, parent_id, name, description, entity_type_id, 
mandatory, searchable, attributesize, arraylist, optionid, showable, display_order) values  (
hibernate_sequence.nextVal, (select entity_type_id from attributetable where name like 'Identifiers'),
'Sub-Region', 'Sub-Region', '5', '0', '1', 'Small', '0', 
(select id from option_names where name like 'Sub-Region'), '1', '10000' );


insert into entitytypes(entity_type_id, name, description, treedepth) values (
hibernate_sequence.nextVal, 'Consent Forms', 'Consent Forms', 2);

insert into attributetable (attribute_id, parent_id, name, description, entity_type_id, 
mandatory, searchable, attributesize, arraylist, optionid, showable, display_order) values  (
hibernate_sequence.nextVal, (select entity_type_id from attributetable where name like 'BMS Info'),
'Consent Forms', 'Consent Forms', (select entity_type_id from entitytypes where name like 'Consent Forms'), 
'0', '0', 'Small', '1', '0', '1', '10000' );

insert into option_names values (hibernate_sequence.nextVal, 'Consent Form Type', '-1');

insert into attributetable (attribute_id, parent_id, name, description, entity_type_id, 
mandatory, searchable, attributesize, arraylist, optionid, showable, display_order) values  (
hibernate_sequence.nextVal, (select entity_type_id from attributetable where name like 'Consent Forms'),
'Consent Form Type', 'Consent Form Type', '5', '1', '1', 'Small', '0', 
(select id from option_names where name like 'Consent Form Type'), '1', '1' );


insert into attributetable (attribute_id, parent_id, name, description, entity_type_id, 
mandatory, searchable, attributesize, arraylist, optionid, showable, display_order) values  (
hibernate_sequence.nextVal, (select entity_type_id from attributetable where name like 'Consent Forms'),
'Date', 'Date', '1', '1', '0', 'Small', '0', '0', '1', '3' );

insert into attributetable (attribute_id, parent_id, name, description, entity_type_id, 
mandatory, searchable, attributesize, arraylist, optionid, showable, display_order) values  (
hibernate_sequence.nextVal, (select entity_type_id from attributetable where name like 'Consent Forms'),
'Consent Form', 'Consent Form', '7', '1', '0', 'Small', '0', '0', '1', '2' );


insert into option_lookup values (hibernate_sequence.nextVal, 
(select id from option_names where name like 'Region_Code'), 'US', 'N', '-1', '0', '10000');

insert into option_lookup values (hibernate_sequence.nextVal, 
(select id from option_names where name like 'Region_Code'), 'Intercon', 'N', '-1', '0', '10000');

insert into option_lookup values (hibernate_sequence.nextVal, 
(select id from option_names where name like 'Region_Code'), 'EU', 'N', '-1', '0', '10000');


insert into option_lookup values (hibernate_sequence.nextVal, 
(select id from option_names where name like 'Sub-Region'), 'N/A', 'N', (select id from option_lookup where option_id = 
(select id from option_names where name like 'Region_Code') and optValue like 'US'), '0', '10000');

insert into option_lookup values (hibernate_sequence.nextVal, 
(select id from option_names where name like 'Sub-Region'), 'N/A', 'N', (select id from option_lookup where option_id = 
(select id from option_names where name like 'Region_Code') and optValue like 'Intercon'), '0', '10000');

insert into option_lookup values (hibernate_sequence.nextVal, 
(select id from option_names where name like 'Sub-Region'), 'Canada', 'N', (select id from option_lookup where option_id = 
(select id from option_names where name like 'Region_Code') and optValue like 'Intercon'), '0', '10000');

insert into option_lookup values (hibernate_sequence.nextVal, 
(select id from option_names where name like 'Sub-Region'), 'Mexico', 'N', (select id from option_lookup where option_id = 
(select id from option_names where name like 'Region_Code') and optValue like 'Intercon'), '0', '10000');

insert into option_lookup values (hibernate_sequence.nextVal, 
(select id from option_names where name like 'Sub-Region'), 'Brazil', 'N', (select id from option_lookup where option_id = 
(select id from option_names where name like 'Region_Code') and optValue like 'Intercon'), '0', '10000');

insert into option_lookup values (hibernate_sequence.nextVal, 
(select id from option_names where name like 'Sub-Region'), 'Hub South', 'N', (select id from option_lookup where option_id = 
(select id from option_names where name like 'Region_Code') and optValue like 'Intercon'), '0', '10000');

insert into option_lookup values (hibernate_sequence.nextVal, 
(select id from option_names where name like 'Sub-Region'), 'Hub North', 'N', (select id from option_lookup where option_id = 
(select id from option_names where name like 'Region_Code') and optValue like 'Intercon'), '0', '10000');

insert into option_lookup values (hibernate_sequence.nextVal, 
(select id from option_names where name like 'Sub-Region'), 'Puerto Rico', 'N', (select id from option_lookup where option_id = 
(select id from option_names where name like 'Region_Code') and optValue like 'Intercon'), '0', '10000');

insert into option_lookup values (hibernate_sequence.nextVal, 
(select id from option_names where name like 'Sub-Region'), 'MEA', 'N', (select id from option_lookup where option_id = 
(select id from option_names where name like 'Region_Code') and optValue like 'Intercon'), '0', '10000');

insert into option_lookup values (hibernate_sequence.nextVal, 
(select id from option_names where name like 'Sub-Region'), 'FOT', 'N', (select id from option_lookup where option_id = 
(select id from option_names where name like 'Region_Code') and optValue like 'Intercon'), '0', '10000');

insert into option_lookup values (hibernate_sequence.nextVal, 
(select id from option_names where name like 'Sub-Region'), 'South Africa', 'N', (select id from option_lookup where option_id = 
(select id from option_names where name like 'Region_Code') and optValue like 'Intercon'), '0', '10000');

update attributetable set name = 'BMS Contracts' where name = 'iPlan Data';
update attributetable set name = 'Product/Disease State' where name = 'Speaker for Product';

insert into option_names values (hibernate_sequence.nextVal, 'Contract_Type', '-1');

insert into option_lookup values (hibernate_sequence.nextval, 
(select id from option_names where name like 'Contract_Type'), 'Speaker', 'N', '-1', '0', '10000');

insert into option_lookup values (hibernate_sequence.nextval, 
(select id from option_names where name like 'Contract_Type'), 'Consultant', 'N', '-1', '0', '10000');

insert into attributetable (attribute_id, parent_id, name, description, entity_type_id, 
mandatory, searchable, attributesize, arraylist, optionid, showable, display_order) values  (
hibernate_sequence.nextVal, (select entity_type_id from attributetable where name like 'BMS Contracts'),
'Contract Type', 'Contract Type', '5', '0', '1', 'Small', '0', 
(select id from option_names where name like 'Contract_Type'), '1', '10000' );


commit;

rem : 1>Author name         : Tapan Ghia
rem : 2>Purpose of change   : 3.1 EAV/LOV changes
rem : 3>Date of change      : 05/03/2010

rem ------------------------------------------------------------------------------------------------
 