rem ------------------------------------------------------------------------------------------------
rem Filename:   db_changes_script_BMSv3.1.sql
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
 
rem : 1>Author name         : Vinay Rao
rem : 2>Purpose of change   : "View for Interaction Detail Report"
rem : 3>Date of change      : 02/23/2010

rem ------------------------------------------------------------------------------------------------
 
rem : Batch : 2

alter table iplan_map_value add deleteFlag varchar2(1);

update iplan_map_value set deleteFlag='N';

rem : 1>Author name         : Tapan Ghia
rem : 2>Purpose of change   : "Adding Deleteflag to iPlan_Map_Value table"
rem : 3>Date of change      : 02/24/2010

rem ------------------------------------------------------------------------------------------------
 
rem : Batch : 3

create table Zip_LatLong_Map (zip_code varchar2(4000), Latitude float(126), longitude float(126));


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

rem : 1>Author name         : Tapan Ghia
rem : 2>Purpose of change   : "Enabling GeoMapping on Latitude Longitude, Procedure to update the Latitude/Longitude"
rem : 3>Date of change      : 02/24/2010

rem ------------------------------------------------------------------------------------------------
 
rem : Batch : 4

insert into entitytypes (select hibernate_sequence.nextval,'BMS Attributes','BMS Attributes','',2 from dual);

rem : "INSERTING into ATTRIBUTETABLE"

Insert into ATTRIBUTETABLE ( select hibernate_sequence.nextval,83005800,'BMS Attributes','BMS Attributes',(select entity_type_id from entitytypes where name='BMS Attributes'),null,0,0,'Small',null,0,5,1,null,null,null,5 from dual);

Insert into "ATTRIBUTETABLE" (select hibernate_sequence.nextval,(select entity_type_id from entitytypes where name ='BMS Attributes'),'Speaker','Speaker',5,null,0,1,null,null,0,83396610,1,null,null,null,0 from dual);
Insert into "ATTRIBUTETABLE" (select hibernate_sequence.nextval,(select entity_type_id from entitytypes where name ='BMS Attributes'),'Investigator','Investigator',5,null,0,1,null,null,0,83396610,1,null,null,null,0 from dual);
Insert into "ATTRIBUTETABLE" (select hibernate_sequence.nextval,(select entity_type_id from entitytypes where name ='BMS Attributes'),'Advisor','Advisor',5,null,0,1,null,null,0,83396610,1,null,null,null,0 from dual);
Insert into "ATTRIBUTETABLE" (select hibernate_sequence.nextval,(select entity_type_id from entitytypes where name ='BMS Attributes'),'Author','Author',5,null,0,1,null,null,0,83396610,1,null,null,null,0 from dual);
Insert into "ATTRIBUTETABLE" (select hibernate_sequence.nextval,(select entity_type_id from entitytypes where name ='BMS Attributes'),'Market Access','Market Access Flag',5,null,0,0,null,null,0,83396610,1,null,null,null,0 from dual);

rem : "Update query to make TA Attribute not showable"

update attributetable set showable = 0 where (name like '%Speaker' or name like '%Advisor' or name like '%Author' or name like'%Investigator' or name like '%Market Access') and name not like 'Saxa%' and entity_type_id =5 and parent_id !=(select entity_type_id from entitytypes where name ='BMS Attributes');

rem : "Permission for BMS Attributes allow CRUD only for Front_end_admin with user type as user"

insert into expertdna_Privileges (select hibernate_sequence.nextval,groupid,'2','Expert.BMS_Info.BMS_Attributes','N','N','N','N' from groups where groupname !='FRONT_END_ADMIN');
insert into expertdna_Privileges (select hibernate_sequence.nextval,groupid,'2','Expert.BMS_Info.BMS_Attributes','Y','Y','Y','Y' from groups where groupname ='FRONT_END_ADMIN');

rem : 1>Author name         : Vinay Rao
rem : 2>Purpose of change   : "Global attributes creation and hiding th present TA specific attributes"
rem : 3>Date of change      : 02/24/2010

rem ------------------------------------------------------------------------------------------------
 
rem : Batch : 5

insert into option_names values (hibernate_sequence.nextVal, 'Source Referenced', (select id from option_names where name like 'Off-label Topics'));

rem : 1>Author name         : Tapan Ghia
rem : 2>Purpose of change   : "Adding Source Referenced LOV"
rem : 3>Date of change      : 03/05/2010

rem ------------------------------------------------------------------------------------------------
 
rem : Batch : 6

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

insert into option_names values (hibernate_sequence.nextVal, 'Sub-Region', 42);

insert into attributetable (attribute_id, parent_id, name, description, entity_type_id, 
mandatory, searchable, attributesize, arraylist, optionid, showable, display_order) values  (
hibernate_sequence.nextVal, (select entity_type_id from attributetable where name like 'Identifiers'),
'Region', 'Region', '5', '0', '1', 'Small', '0', 42, '1', '10000' );

insert into attributetable (attribute_id, parent_id, name, description, entity_type_id, 
mandatory, searchable, attributesize, arraylist, optionid, showable, display_order) values  (
hibernate_sequence.nextVal, (select entity_type_id from attributetable where name like 'Identifiers'),
'Sub-Region', 'Sub-Region', '5', '0', '1', 'Small', '0', (select id from option_names where name like 'Sub-Region'), '1', '10000' );

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

insert into option_lookup values (hibernate_sequence.nextVal, 42, 'US', 'N', '-1', '0', '10000');

insert into option_lookup values (hibernate_sequence.nextVal, 42, 'Intercon', 'N', '-1', '0', '10000');

insert into option_lookup values (hibernate_sequence.nextVal, 42, 'EU', 'N', '-1', '0', '10000');

insert into option_lookup values (hibernate_sequence.nextVal, 
(select id from option_names where name like 'Sub-Region'), 'N/A', 'N', (select id from option_lookup where option_id = 42 and optValue like 'US'), '0', '10000');

insert into option_lookup values (hibernate_sequence.nextVal, 
(select id from option_names where name like 'Sub-Region'), 'N/A', 'N', (select id from option_lookup where option_id = 42 and optValue like 'Intercon'), '0', '10000');

insert into option_lookup values (hibernate_sequence.nextVal, 
(select id from option_names where name like 'Sub-Region'), 'Canada', 'N', (select id from option_lookup where option_id = 42 and optValue like 'Intercon'), '0', '10000');

insert into option_lookup values (hibernate_sequence.nextVal, 
(select id from option_names where name like 'Sub-Region'), 'Mexico', 'N', (select id from option_lookup where option_id = 42 and optValue like 'Intercon'), '0', '10000');

insert into option_lookup values (hibernate_sequence.nextVal, 
(select id from option_names where name like 'Sub-Region'), 'Brazil', 'N', (select id from option_lookup where option_id = 42 and optValue like 'Intercon'), '0', '10000');

insert into option_lookup values (hibernate_sequence.nextVal, 
(select id from option_names where name like 'Sub-Region'), 'Hub South', 'N', (select id from option_lookup where option_id = 42 and optValue like 'Intercon'), '0', '10000');

insert into option_lookup values (hibernate_sequence.nextVal, 
(select id from option_names where name like 'Sub-Region'), 'Hub North', 'N', (select id from option_lookup where option_id = 42 and optValue like 'Intercon'), '0', '10000');

insert into option_lookup values (hibernate_sequence.nextVal, 
(select id from option_names where name like 'Sub-Region'), 'Puerto Rico', 'N', (select id from option_lookup where option_id = 42 and optValue like 'Intercon'), '0', '10000');

insert into option_lookup values (hibernate_sequence.nextVal, 
(select id from option_names where name like 'Sub-Region'), 'MEA', 'N', (select id from option_lookup where option_id = 42 and optValue like 'Intercon'), '0', '10000');

insert into option_lookup values (hibernate_sequence.nextVal, 
(select id from option_names where name like 'Sub-Region'), 'FOT', 'N', (select id from option_lookup where option_id = 42 and optValue like 'Intercon'), '0', '10000');

insert into option_lookup values (hibernate_sequence.nextVal, 
(select id from option_names where name like 'Sub-Region'), 'South Africa', 'N', (select id from option_lookup where option_id = 42 and optValue like 'Intercon'), '0', '10000');
insert into option_lookup values (hibernate_sequence.nextVal, 
(select id from option_names where name like 'Sub-Region'), 'Middle East', 'N', (select id from option_lookup where option_id = 42 and optValue like 'Intercon'), '0', '10000');

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

rem : 1>Author name         : Tapan Ghia
rem : 2>Purpose of change   : "3.1 EAV/LOV changes"
rem : 3>Date of change      : 03/05/2010

rem ------------------------------------------------------------------------------------------------
 
rem : Batch : 7

insert into option_names values 
(hibernate_sequence.nextVal, 'SpeakerTraining_Deck_Ids', (select id from option_names where name like 'Speaker Training Decks'));


rem : 1>Author name         : Tapan Ghia
rem : 2>Purpose of change   : "New Speaker Training Deck Ids to store the Deck Ids"
rem : 3>Date of change      : 03/11/2010

rem ------------------------------------------------------------------------------------------------
 
rem : Batch : 8

create table LOV_related_metadata ( 
id number(19,0) not null enable, 
property varchar2(4000),
property_description varchar2(4000),
constraint metadata_id_pk primary key(id));

rem : "Create unique constraint"
	
ALTER TABLE OPTION_LOOKUP
ADD CONSTRAINT OPTION_LOOKUP_UK1 UNIQUE (  ID ) 
ENABLE;

create table LOV_related_data(
id number(19,0) not null enable, 
option_lookup_ID number(19,0) not null enable,
property_type_id number(19,0) not null enable,
property_value varchar2(4000),
constraint optl_id_fk foreign key(option_lookup_id) references option_lookup(id),
constraint prop_type_fk foreign key(property_type_id) references LOV_related_metadata(id));

rem : 1>Author name         : Tapan Ghia
rem : 2>Purpose of change   : "LOV Framework to store option Lookup related information"
rem : 3>Date of change      : 03/12/2010

rem ------------------------------------------------------------------------------------------------

rem : Batch : 9

insert into groups (GROUPID, GROUPNAME, GROUPDESCRIPTION, GROUPTYPE, PARENTGROUP, THERUPTICAREA, FUNCTIONALAREA, REGION) values (hibernate_sequence.nextval, 'Intercon_HQ', 'Intercon_HQ', 'User', 1, 83397444, 85543650, (select id from option_lookup where option_id = 42 and optValue like 'Intercon'));
insert into groups (GROUPID, GROUPNAME, GROUPDESCRIPTION, GROUPTYPE, PARENTGROUP, THERUPTICAREA, FUNCTIONALAREA, REGION) values (hibernate_sequence.nextval, 'Intercon_Oncology', 'Intercon_Oncology', 'User', 1, 85543649, 83007201, (select id from option_lookup where option_id = 42 and optValue like 'Intercon'));
insert into groups (GROUPID, GROUPNAME, GROUPDESCRIPTION, GROUPTYPE, PARENTGROUP, THERUPTICAREA, FUNCTIONALAREA, REGION) values (hibernate_sequence.nextval, 'Intercon_Virology', 'Intercon_Virology', 'User', 1, 88437879, 83007201, (select id from option_lookup where option_id = 42 and optValue like 'Intercon'));
insert into groups (GROUPID, GROUPNAME, GROUPDESCRIPTION, GROUPTYPE, PARENTGROUP, THERUPTICAREA, FUNCTIONALAREA, REGION) values (hibernate_sequence.nextval, 'Intercon_CVMET', 'Intercon_CVMET', 'User', 1, 83397444, 83007201, (select id from option_lookup where option_id = 42 and optValue like 'Intercon'));
insert into groups (GROUPID, GROUPNAME, GROUPDESCRIPTION, GROUPTYPE, PARENTGROUP, THERUPTICAREA, FUNCTIONALAREA, REGION) values (hibernate_sequence.nextval, 'Intercon_Immunoscience', 'Intercon_Immunoscience', 'User', 1, 88437878, 83007201, (select id from option_lookup where option_id = 42 and optValue like 'Intercon'));
insert into groups (GROUPID, GROUPNAME, GROUPDESCRIPTION, GROUPTYPE, PARENTGROUP, THERUPTICAREA, FUNCTIONALAREA, REGION) values (hibernate_sequence.nextval, 'Intercon_Neuro', 'Intercon_Neuro', 'User', 1, 85543648, 83007201, (select id from option_lookup where option_id = 42 and optValue like 'Intercon'));
insert into groups (GROUPID, GROUPNAME, GROUPDESCRIPTION, GROUPTYPE, PARENTGROUP, THERUPTICAREA, FUNCTIONALAREA, REGION) values (hibernate_sequence.nextval, 'Intercon_CVMET_Immunoscience', 'Intercon_CVMET_Immunoscience', 'User', 1, 83397444, 83007201, (select id from option_lookup where option_id = 42 and optValue like 'Intercon'));
insert into groups (GROUPID, GROUPNAME, GROUPDESCRIPTION, GROUPTYPE, PARENTGROUP, THERUPTICAREA, FUNCTIONALAREA, REGION) values (hibernate_sequence.nextval, 'Intercon_CVMET_Neuro', 'Intercon_CVMET_Neuro', 'User', 1, 83397444, 83007201, (select id from option_lookup where option_id = 42 and optValue like 'Intercon'));
insert into groups (GROUPID, GROUPNAME, GROUPDESCRIPTION, GROUPTYPE, PARENTGROUP, THERUPTICAREA, FUNCTIONALAREA, REGION) values (hibernate_sequence.nextval, 'Intercon_CVMET_Oncology', 'Intercon_CVMET_Oncology', 'User', 1, 83397444, 83007201, (select id from option_lookup where option_id = 42 and optValue like 'Intercon'));
insert into groups (GROUPID, GROUPNAME, GROUPDESCRIPTION, GROUPTYPE, PARENTGROUP, THERUPTICAREA, FUNCTIONALAREA, REGION) values (hibernate_sequence.nextval, 'Intercon_CVMET_Virology', 'Intercon_CVMET_Virology', 'User', 1, 83397444, 83007201, (select id from option_lookup where option_id = 42 and optValue like 'Intercon'));
insert into groups (GROUPID, GROUPNAME, GROUPDESCRIPTION, GROUPTYPE, PARENTGROUP, THERUPTICAREA, FUNCTIONALAREA, REGION) values (hibernate_sequence.nextval, 'Intercon_Immunoscience_Neuro', 'Intercon_Immunoscience_Neuro', 'User', 1, 88437878, 83007201, (select id from option_lookup where option_id = 42 and optValue like 'Intercon'));
insert into groups (GROUPID, GROUPNAME, GROUPDESCRIPTION, GROUPTYPE, PARENTGROUP, THERUPTICAREA, FUNCTIONALAREA, REGION) values (hibernate_sequence.nextval, 'Intercon_Immunoscience_Oncology', 'Intercon_Immunoscience_Oncology', 'User', 1, 88437878, 83007201, (select id from option_lookup where option_id = 42 and optValue like 'Intercon'));
insert into groups (GROUPID, GROUPNAME, GROUPDESCRIPTION, GROUPTYPE, PARENTGROUP, THERUPTICAREA, FUNCTIONALAREA, REGION) values (hibernate_sequence.nextval, 'Intercon_Immunoscience_Virology', 'Intercon_Immunoscience_Virology', 'User', 1, 88437878, 83007201, (select id from option_lookup where option_id = 42 and optValue like 'Intercon'));
insert into groups (GROUPID, GROUPNAME, GROUPDESCRIPTION, GROUPTYPE, PARENTGROUP, THERUPTICAREA, FUNCTIONALAREA, REGION) values (hibernate_sequence.nextval, 'Intercon_Neuro_Oncology', 'Intercon_Neuro_Oncology', 'User', 1, 85543648, 83007201, (select id from option_lookup where option_id = 42 and optValue like 'Intercon'));
insert into groups (GROUPID, GROUPNAME, GROUPDESCRIPTION, GROUPTYPE, PARENTGROUP, THERUPTICAREA, FUNCTIONALAREA, REGION) values (hibernate_sequence.nextval, 'Intercon_Neuro_Virology', 'Intercon_Neuro_Virology', 'User', 1, 85543648, 83007201, (select id from option_lookup where option_id = 42 and optValue like 'Intercon'));
insert into groups (GROUPID, GROUPNAME, GROUPDESCRIPTION, GROUPTYPE, PARENTGROUP, THERUPTICAREA, FUNCTIONALAREA, REGION) values (hibernate_sequence.nextval, 'Intercon_Oncology_Virologogy', 'Intercon_Oncology_Virologogy', 'User', 1, 85543649, 83007201, (select id from option_lookup where option_id = 42 and optValue like 'Intercon'));

rem : 1>Author name         : Deepak Singh Rawat
rem : 2>Purpose of change   : "Add new user groups"
rem : 3>Date of change      : 03/16/2010

rem ------------------------------------------------------------------------------------------------

rem : Batch : 10

rem : "Add new LOV for Level 3"
	
insert into option_names (ID, NAME, PARENT) values (hibernate_sequence.nextval, 'Territory Level 3', -1);

rem : "Make 'Territory Level 3' parent of 'RAD'"
	
update option_names set parent = (select id from option_names where name = 'Territory Level 3') where name = 'RAD';

rem : "Insert US TAs and Intercon Sub-Region values in the 'Territory Level 3' LOV"
	
insert into option_lookup
select 
hibernate_sequence.nextval,
(select id from option_names where name = 'Territory Level 3'),
optvalue, deleteflag, 85248368, 0, 10000
from option_lookup where option_id in (select id from option_names where name in ( 'Sub-Region', 'Therapeutic Area'));

rem : "Enable LOV security for 'Territory Level 3' LOV"
	
insert into feature_usergroup_map
select
hibernate_sequence.nextval,
id ,
(select ','||wm_concat(groupid)||',' from groups where groupname  like 'Intercon_%'), 
2
from option_lookup 
where option_id = (select id from option_names where name = 'Territory Level 3')
and optvalue in (select optvalue from option_lookup where option_id = (select id from option_names where name  = 'Therapeutic Area'));

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
id ,
(select ','||wm_concat(groupid)||',' from groups where groupname not like 'Intercon_%' and groupname != 'Groups'), 
2
from option_lookup 
where option_id = (select id from option_names where name = 'Territory Level 3') 
and optvalue in (select optvalue from option_lookup where option_id = (select id from option_names where name  = 'Sub-Region'));

rem : "Insert Intercon values in the 'RAD' LOV for Intercon"

insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 83397442, 'NS', 'N', (select id from option_lookup where optvalue = 'Canada' and option_id = (select id from option_names where name='Sub-Region')), 0, 1);
insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 83397442, 'Imm/Vir', 'N', (select id from option_lookup where optvalue = 'Canada' and option_id = (select id from option_names where name='Sub-Region')), 0, 1);
insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 83397442, 'CVMET', 'N', (select id from option_lookup where optvalue = 'Canada' and option_id = (select id from option_names where name='Sub-Region')), 0, 1);
insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 83397442, 'Onc', 'N', (select id from option_lookup where optvalue = 'Canada' and option_id = (select id from option_names where name='Sub-Region')), 0, 1);
insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 83397442, 'NS/Onc', 'N', (select id from option_lookup where optvalue = 'Mexico' and option_id = (select id from option_names where name='Sub-Region')), 0, 1);
insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 83397442, 'Imm/Vir', 'N', (select id from option_lookup where optvalue = 'Mexico' and option_id = (select id from option_names where name='Sub-Region')), 0, 1);
insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 83397442, 'CVMET', 'N', (select id from option_lookup where optvalue = 'Mexico' and option_id = (select id from option_names where name='Sub-Region')), 0, 1);
insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 83397442, 'Onc', 'N', (select id from option_lookup where optvalue = 'Mexico' and option_id = (select id from option_names where name='Sub-Region')), 0, 1);
insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 83397442, 'Imm', 'N', (select id from option_lookup where optvalue = 'Brazil' and option_id = (select id from option_names where name='Sub-Region')), 0, 1);
insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 83397442, 'Vir', 'N', (select id from option_lookup where optvalue = 'Brazil' and option_id = (select id from option_names where name='Sub-Region')), 0, 1);
insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 83397442, 'CVMET', 'N', (select id from option_lookup where optvalue = 'Brazil' and option_id = (select id from option_names where name='Sub-Region')), 0, 1);
insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 83397442, 'Onc', 'N', (select id from option_lookup where optvalue = 'Brazil' and option_id = (select id from option_names where name='Sub-Region')), 0, 1);
insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 83397442, 'Imm/Vir', 'N', (select id from option_lookup where optvalue = 'Hub South' and option_id = (select id from option_names where name='Sub-Region')), 0, 1);
insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 83397442, 'CVMET', 'N', (select id from option_lookup where optvalue = 'Hub South' and option_id = (select id from option_names where name='Sub-Region')), 0, 1);
insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 83397442, 'Onc', 'N', (select id from option_lookup where optvalue = 'Hub South' and option_id = (select id from option_names where name='Sub-Region')), 0, 1);
insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 83397442, 'Vacant-Dummy-Hub-North', 'N', (select id from option_lookup where optvalue = 'Hub North' and option_id = (select id from option_names where name='Sub-Region')), 0, 1);
insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 83397442, 'Vacant-Dummy-Puerto-Rico', 'N', (select id from option_lookup where optvalue = 'Puerto Rico' and option_id = (select id from option_names where name='Sub-Region')), 0, 1);
insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 83397442, 'ME', 'N', (select id from option_lookup where optvalue = 'MEA' and option_id = (select id from option_names where name='Sub-Region')), 0, 1);
insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 83397442, 'FOT', 'N', (select id from option_lookup where optvalue = 'MEA' and option_id = (select id from option_names where name='Sub-Region')), 0, 1);
insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 83397442, 'Africa', 'N', (select id from option_lookup where optvalue = 'MEA' and option_id = (select id from option_names where name='Sub-Region')), 0, 1);

rem : "Enable LOV security for 'RAD' LOV"	

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
id ,
(select ','||wm_concat(groupid)||',' from groups where groupname not like 'Intercon_%' and groupname != 'Groups'), 
2
from option_lookup 
where option_id = (select id from option_names where name = 'RAD')
and optvalue in (select optvalue from option_lookup where option_id = (select id from option_names where name  = 'Therapeutic Area'));

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
id ,
(select ','||wm_concat(groupid)||',' from groups where groupname like 'Intercon_%'), 
2
from option_lookup 
where option_id = (select id from option_names where name = 'RAD') 
and optvalue not in (select optvalue from option_lookup where option_id = (select id from option_names where name  = 'Sub-Region'));
	
rem : 1>Author name         : Deepak Singh Rawat
rem : 2>Purpose of change   : "Reporting hierarchy related changes"
rem : 3>Date of change      : 03/16/2010

rem ------------------------------------------------------------------------------------------------

rem : Batch : 11

insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 6, 'Brazil', 'N', -1, 0, 1);
insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 6, 'Puerto Rico', 'N', -1, 0, 1);
insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 6, 'South Africa', 'N', -1, 0, 1);
insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 6, 'Argentina', 'N', -1, 0, 1);
insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 6, 'Peru', 'N', -1, 0, 1);
insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 6, 'Chile', 'N', -1, 0, 1);
insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 6, 'Columbia', 'N', -1, 0, 1);
insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 6, 'Venezuela', 'N', -1, 0, 1);
insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 6, 'Algeria', 'N', -1, 0, 1);
insert into option_lookup (ID, OPTION_ID, OPTVALUE, DELETEFLAG, PARENT, DEFAULT_SELECTED, DISPLAY_ORDER) values (hibernate_sequence.nextval, 6, 'Tunisia', 'N', -1, 0, 1);

rem : 1>Author name         : Deepak Singh Rawat
rem : 2>Purpose of change   : "Add new countries to the Country LOV"
rem : 3>Date of change      : 03/16/2010

rem ------------------------------------------------------------------------------------------------

rem : Batch : 12

update option_names set parent = (select id from option_names where name = 'Sub-Region') where name = 'Country';

update option_lookup set parent = (select id from option_lookup where option_id = (select id from option_names where name = 'Sub-Region') and optvalue = 'Brazil') where option_id = 6 and optvalue = 'Brazil';
update option_lookup set parent = (select id from option_lookup where option_id = (select id from option_names where name = 'Sub-Region') and optvalue = 'Canada') where option_id = 6 and optvalue = 'Canada';
update option_lookup set parent = (select id from option_lookup where option_id = (select id from option_names where name = 'Sub-Region') and optvalue = 'Puerto Rico') where option_id = 6 and optvalue = 'Puerto Rico';
update option_lookup set parent = (select id from option_lookup where option_id = (select id from option_names where name = 'Sub-Region') and optvalue = 'South Africa') where option_id = 6 and optvalue = 'South Africa';
update option_lookup set parent = (select id from option_lookup where option_id = (select id from option_names where name = 'Sub-Region') and optvalue = 'South Africa') where option_id = 6 and optvalue = 'Israel';
update option_lookup set parent = (select id from option_lookup where option_id = (select id from option_names where name = 'Sub-Region') and optvalue = 'Hub South') where option_id = 6 and optvalue = 'Argentina';
update option_lookup set parent = (select id from option_lookup where option_id = (select id from option_names where name = 'Sub-Region') and optvalue = 'Hub South') where option_id = 6 and optvalue = 'Peru';
update option_lookup set parent = (select id from option_lookup where option_id = (select id from option_names where name = 'Sub-Region') and optvalue = 'Hub South') where option_id = 6 and optvalue = 'Chile';
update option_lookup set parent = (select id from option_lookup where option_id = (select id from option_names where name = 'Sub-Region') and optvalue = 'Hub North') where option_id = 6 and optvalue = 'Columbia';
update option_lookup set parent = (select id from option_lookup where option_id = (select id from option_names where name = 'Sub-Region') and optvalue = 'Hub North') where option_id = 6 and optvalue = 'Venezuela';
update option_lookup set parent = (select id from option_lookup where option_id = (select id from option_names where name = 'Sub-Region') and optvalue = 'FOT') where option_id = 6 and optvalue = 'Algeria';
update option_lookup set parent = (select id from option_lookup where option_id = (select id from option_names where name = 'Sub-Region') and optvalue = 'FOT') where option_id = 6 and optvalue = 'Tunisia';
update option_lookup set parent = (select id from option_lookup where option_id = (select id from option_names where name = 'Sub-Region') and optvalue = 'Middle East') where option_id = 6 and optvalue = 'Saudi Arabia';
update option_lookup set parent = (select id from option_lookup where option_id = (select id from option_names where name = 'Sub-Region') and optvalue = 'Middle East') where option_id = 6 and optvalue = 'Egypt';

rem : 1>Author name         : Deepak Singh Rawat
rem : 2>Purpose of change   : "Set parent Sub-Regions for the countries"
rem : 3>Date of change      : 03/16/2010

rem ------------------------------------------------------------------------------------------------

rem : Batch : 13

update option_lookup set optvalue = 'Market Access' where optvalue = 'Managed Markets';

update option_lookup set optvalue = 'Pipeline (Non-Market Access)' where optvalue = 'Pipeline (Non-Managed Markets)';

rem : 1>Author name         : Raghavan
rem : 2>Purpose of change   : "Interaction LOV changes"
rem : 3>Date of change      : 03/16/2010

rem ------------------------------------------------------------------------------------------------

rem : Batch : 14

rem : "Insert LOV values to disable Disease State/Product ppt sections for Intercon groups"
	
insert into option_lookup
select hibernate_sequence.nextval,
option_id, optvalue, deleteflag, parent, default_selected,10000
from option_lookup where optvalue like 'Proactive' 
and parent in (select id from option_lookup where optvalue in ( 'Disease State', 'Product')
and parent in (select id from option_lookup where optvalue in (
'Web Conference 1:1', 'Group Presentation (3 or more)', '1:1 Face to Face (2 or less)', 
'Telephone', 'Web Conference Group')));

rem : "To restrict US values for Disease State topic children in Sub-Topic LOV for Intercon groups"

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
id ,
(select ','||wm_concat(groupid)||',' from groups where groupname  like 'Intercon_%'), 
2
from option_lookup where optvalue like 'Proactive' and id  in 
(select TERTIARY_LOVID from interaction_lovtriplet_section)
and parent in (select id from option_lookup where optvalue in ( 'Disease State', 'Product')
and parent in (select id from option_lookup where optvalue in ('Web Conference 1:1', 
'Group Presentation (3 or more)', '1:1 Face to Face (2 or less)', 
'Telephone', 'Web Conference Group')));

rem : "To restrict Intercon values for Disease State topic children in Sub-Topic LOV for US groups"
	
insert into feature_usergroup_map
select
hibernate_sequence.nextval,
id ,
(select ','||wm_concat(groupid)||',' from groups where groupname not like 'Intercon_%' and groupname != 'Groups'), 
2
from option_lookup where optvalue like 'Proactive' and id not in 
(select TERTIARY_LOVID from interaction_lovtriplet_section)
and parent in (select id from option_lookup where optvalue in ( 'Disease State', 'Product')
and parent in (select id from option_lookup where optvalue in ('Web Conference 1:1', 
'Group Presentation (3 or more)', '1:1 Face to Face (2 or less)', 
'Telephone', 'Web Conference Group')));

rem : 1>Author name         : Raghavan
rem : 2>Purpose of change   : "Disease State and Product Presentation section's configuration"
rem : 3>Date of change      : 03/16/2010

rem ------------------------------------------------------------------------------------------------

rem : Batch : 15

insert into option_lookup values (hibernate_sequence.nextval,
(select id from option_names where name = 'Interaction Topic'),
'Dinner Program/RoundTable','N',
(select id from option_lookup where optvalue = 'Group Presentation (3 or more)'), 0,10000);

rem : 1>Author name         : Raghavan
rem : 2>Purpose of change   : "Add Dinner Program / Round Table under Type = Group Presentation"
rem : 3>Date of change      : 03/16/2010

rem ------------------------------------------------------------------------------------------------

rem : Batch : 16

insert into feature_usergroup_map
values (
hibernate_sequence.nextval,
(select id from option_lookup where optvalue = 'Dinner Program/RoundTable') ,
(select ','||wm_concat(groupid)||',' from groups where groupname not like 'Intercon_%' and groupname != 'Groups'), 
2);

rem : 1>Author name         : Raghavan
rem : 2>Purpose of change   : "Making Dinner Program / Round Table accessible only for intercon groups"
rem : 3>Date of change      : 03/16/2010

rem ------------------------------------------------------------------------------------------------

rem : Batch : 17

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
id ,
(select ','||wm_concat(groupid)||',' from groups where groupname  like 'Intercon_%'), 
2
from option_lookup where optvalue like 'iPlan Program';

rem : 1>Author name         : Raghavan
rem : 2>Purpose of change   : "To remove iPlan Program for intercon groups"
rem : 3>Date of change      : 03/16/2010

rem ------------------------------------------------------------------------------------------------

rem : Batch : 18

update option_lookup set deleteflag = 'Y' where parent in (select id from option_lookup 
where optvalue like 'Speaker Training' ) and optvalue like 'N/A';

rem : 1>Author name         : Raghavan
rem : 2>Purpose of change   : "Take out N/A as an option under Topic = Speaker Training "
rem : 3>Date of change      : 03/16/2010

rem ------------------------------------------------------------------------------------------------

rem : Batch : 19

insert into option_lookup   
(select hibernate_sequence.nextval,
(select id from option_names where name = 'Interaction Sub-Topic'),
'Investigator Meeting','N', o.id,0,1000 from option_lookup o 
where o.optvalue = 'Clinical Trial');

rem : 1>Author name         : Raghavan
rem : 2>Purpose of change   : "Add Investigator Meeting under Topic = Clinical Trial"
rem : 3>Date of change      : 03/16/2010


rem ------------------------------------------------------------------------------------------------

rem : Batch : 20

insert into feature_usergroup_map
select
hibernate_sequence.nextval,
id ,
(select ','||wm_concat(groupid)||',' from groups where groupname not like 'Intercon_%' and groupname != 'Groups'), 
2
from option_lookup where optvalue like 'Investigator Meeting';

rem : 1>Author name         : Raghavan
rem : 2>Purpose of change   : "Restricting US user from Investigator meeting"
rem : 3>Date of change      : 03/16/2010

rem ------------------------------------------------------------------------------------------------

rem: Batch : 21

rem : "INSERTING into OPTION_NAMES"
	
Insert into "OPTION_NAMES" ("ID","NAME","PARENT") values (hibernate_sequence.nextval,'Selection Criteria Answers',-1);

rem : "INSERTING into OPTION_LOOKUP"
	
Insert into "OPTION_LOOKUP" ("ID","OPTION_ID","OPTVALUE","DELETEFLAG","PARENT","DEFAULT_SELECTED","DISPLAY_ORDER") values (hibernate_sequence.nextval,(select id from option_names where name ='Selection Criteria Answers'),'National','N',-1,'0',0);
Insert into "OPTION_LOOKUP" ("ID","OPTION_ID","OPTVALUE","DELETEFLAG","PARENT","DEFAULT_SELECTED","DISPLAY_ORDER") values (hibernate_sequence.nextval,(select id from option_names where name ='Selection Criteria Answers'),'International','N',-1,'0',0);
Insert into "OPTION_LOOKUP" ("ID","OPTION_ID","OPTVALUE","DELETEFLAG","PARENT","DEFAULT_SELECTED","DISPLAY_ORDER") values (hibernate_sequence.nextval,(select id from option_names where name ='Selection Criteria Answers'),'Yes','N',-1,'0',0);
Insert into "OPTION_LOOKUP" ("ID","OPTION_ID","OPTVALUE","DELETEFLAG","PARENT","DEFAULT_SELECTED","DISPLAY_ORDER") values (hibernate_sequence.nextval,(select id from option_names where name ='Selection Criteria Answers'),'No','N',-1,'0',0);

rem : "insert into optionlookup for SOI values(permisionilng not set)"
	
Insert into "OPTION_LOOKUP" ("ID","OPTION_ID","OPTVALUE","DELETEFLAG","PARENT","DEFAULT_SELECTED","DISPLAY_ORDER") values (hibernate_sequence.nextval,(select id from option_names where name ='Sphere of Influence'),'International','N',-1,'0',0);
Insert into "OPTION_LOOKUP" ("ID","OPTION_ID","OPTVALUE","DELETEFLAG","PARENT","DEFAULT_SELECTED","DISPLAY_ORDER") values (hibernate_sequence.nextval,(select id from option_names where name ='Sphere of Influence'),'Local','N',-1,'0',0);

update attributetable set optionid=(select id from option_names where name ='Selection Criteria Answers') where description ='Member of national or international treatment guideline committee within the last 2 years';	
update attributetable set optionid=(select id from option_names where name ='Selection Criteria Answers') where description ='Committee/board member of scientific committee for national or international associations within the last 2 years';	
update attributetable set optionid=(select id from option_names where name ='Selection Criteria Answers') where description ='Chairman/speaker at an national or international scientific meeting';	
update attributetable set optionid=(select id from option_names where name ='Selection Criteria Answers') where description ='Professor/Assoc Professor with academic affiliation that are associated with medical school';	
update attributetable set optionid=(select id from option_names where name ='Selection Criteria Answers') where description ='Previous or current principle investigator, study chair or member of study steering committee for large multi-site National/International trial';	
update attributetable set optionid=(select id from option_names where name ='Selection Criteria Answers') where description ='Editor or member of editorial board for peer reviewed journal';	
update attributetable set optionid=(select id from option_names where name ='Selection Criteria Answers') where description ='Published in peer reviewed journal within the last 2 years';	 

rem : 1>Author name         : Vinay Rao
rem : 2>Purpose of change   : "3.1 EAV/ Selection Criteria LOV changes"
rem : 3>Date of change      : 03/17/2010

rem ------------------------------------------------------------------------------------------------

rem : Batch : 22

create table source_referenced (
R_Object_id varchar2(4000),
documentID varchar2(4000),
product varchar2(4000),
off_label_topic varchar2(4000),
reporting_title varchar2(4000),
documentName varchar2(4000)
);

insert into lov_related_metadata values (hibernate_sequence.nextVal, 'R_Object_id', 'Data related to Source Referenced LOV');
insert into lov_related_metadata values (hibernate_sequence.nextVal, 'documentID', 'Data related to Source Referenced LOV');
insert into lov_related_metadata values (hibernate_sequence.nextVal, 'product', 'Data related to Source Referenced LOV');
insert into lov_related_metadata values (hibernate_sequence.nextVal, 'off_label_topic', 'Data related to Source Referenced LOV');
insert into lov_related_metadata values (hibernate_sequence.nextVal, 'reporting_title', 'Data related to Source Referenced LOV');
insert into lov_related_metadata values (hibernate_sequence.nextVal, 'documentName', 'Data related to Source Referenced LOV');




rem : 1>Author name         : Tapan
rem : 2>Purpose of change   : "Source Referenced LOV"
rem : 3>Date of change      : 03/23/2010

rem ------------------------------------------------------------------------------------------------





commit;

rem user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

SPOOL OFF

SET ECHO OFF

exit;
