rem ------------------------------------------------------------------------------------------------
rem Filename    :   db_changes_script_BMSv2.2.sql
rem Purpose	:   SQL changes for version 2.2
rem             
rem Date	:   22-Oct-2009
rem Author	:   Yatin
rem ------------------------------------------------------------------------------------------------

SET TIME ON
SET ESCAPE '\'
SET PAGESIZE 50000
SPOOL ON
SET HEADING OFF
rem log file : db_changes_script_BMSv2.2.log
SPOOL db_changes_script_BMSv2.2.log
SET ECHO ON

rem : user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

rem ------------------------------------------------------------------------------------------------

rem : Batch : 1


 CREATE OR REPLACE FORCE VIEW SC_MSL_MPOL_VIEW AS
  SELECT "MSL_STAFF_ID","MSL_TA","OL_USER_ID","OL_STATUS","BEGIN_DATE","END_DATE"
FROM SC_MSL_OL_VIEW
WHERE OL_Status in ('MPA', 'MPTL');
.
/

CREATE OR REPLACE FORCE VIEW SC_INTERACTION_MPOL_VIEW AS
  SELECT 'Actual On Plan' as FIELD_NAME, ia."INTERACTION_ID",ia."INTERACTION_DATE",ia."INTERACTION_TYPE",ia."INTERACTION_TA",ia."ATTENDEE_ID",ia."ATTENDEE_NAME",ia."ATTENDEE_USERID",ia."ATTENDEETYPE",ia."OL_STATUS"
  FROM SC_Interaction_Attendee_View ia
  WHERE ia.OL_status in ('MPTL', 'MPA');
.
/
  commit;

rem : 1>Author name         : Tapan
rem : 2>Purpose of change   : MPOL-->MPTL change in reports, corresponding view changes
rem : 3>Date of change      : 22/10/2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 2

update option_names set name = 'MSL TL Type' where name like 'MSL OL Type';

commit;

rem : 1>Author name         : Tapan
rem : 2>Purpose of change   : updating the Option Name MSL OL Type to MSL TL Type
rem : 3>Date of change      : 22/10/2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 3

insert into groups values (HIBERNATE_SEQUENCE.NEXTVAL, 'OTSUKA_JV', 'OTSUKA_JV', 'User', 1, 85543648, 83397590, 6503);
commit;

insert into attributetable values (HIBERNATE_SEQUENCE.NEXTVAL, 85543697, 'Otsuka Collaboration Flag', 'Otsuka Collaboration 
Flag', 5, '', 0, 1, 'Small', '', 0, 83396610, 1 ,'', '', '', 15);

insert into expertdna_privileges values (HIBERNATE_SEQUENCE.NEXTVAL, (select groupid from groups where groupname = 
'OTSUKA_JV'), 2, 'Expert.BMS_Info.OL_Selection_Criteria', 'N', 'Y', 'N', 'N');
insert into expertdna_privileges values (HIBERNATE_SEQUENCE.NEXTVAL, (select groupid from groups where groupname = 
'OTSUKA_JV'), 2, 'Expert.BMS_Info.OL_Colleagues', 'N', 'Y', 'N', 'N');
insert into expertdna_privileges values (HIBERNATE_SEQUENCE.NEXTVAL, (select groupid from groups where groupname = 
'OTSUKA_JV'), 2, 'Expert.BMS_Info.Neuro_Profile', 'N', 'N', 'N', 'N');
insert into expertdna_privileges values (HIBERNATE_SEQUENCE.NEXTVAL, (select groupid from groups where groupname = 
'OTSUKA_JV'), 2, 'Expert.BMS_Info.Medical_Inquiries', 'N', 'N', 'N', 'N');

insert into expertdna_privileges values (HIBERNATE_SEQUENCE.NEXTVAL, (select groupid from groups where groupname = 
'OTSUKA_JV'), 2, 'Expert.BMS_Info.CVMET_Tags', 'N', 'N', 'N', 'N');
insert into expertdna_privileges values (HIBERNATE_SEQUENCE.NEXTVAL, (select groupid from groups where groupname = 
'OTSUKA_JV'), 2, 'Expert.BMS_Info.Neuro_Attributes', 'N', 'Y', 'N', 'N');
insert into expertdna_privileges values (HIBERNATE_SEQUENCE.NEXTVAL, (select groupid from groups where groupname = 
'OTSUKA_JV'), 2, 'Expert.BMS_Info.Neuro_Tags', 'N', 'N', 'N', 'N');
insert into expertdna_privileges values (HIBERNATE_SEQUENCE.NEXTVAL, (select groupid from groups where groupname = 
'OTSUKA_JV'), 2, 'Expert.BMS_Info.Oncology_Attributes', 'N', 'N', 'N', 'N');

insert into expertdna_privileges values (HIBERNATE_SEQUENCE.NEXTVAL, (select groupid from groups where groupname = 
'OTSUKA_JV'), 2, 'Expert.BMS_Info.Oncology_Tags', 'N', 'N', 'N', 'N');
insert into expertdna_privileges values (HIBERNATE_SEQUENCE.NEXTVAL, (select groupid from groups where groupname = 
'OTSUKA_JV'), 2, 'Expert.BMS_Info.Immunoscience_Tags', 'N', 'N', 'N', 'N');
insert into expertdna_privileges values (HIBERNATE_SEQUENCE.NEXTVAL, (select groupid from groups where groupname = 
'OTSUKA_JV'), 2, 'Expert.BMS_Info.Immunoscience_Attributes', 'N', 'N', 'N', 'N');
insert into expertdna_privileges values (HIBERNATE_SEQUENCE.NEXTVAL, (select groupid from groups where groupname = 
'OTSUKA_JV'), 2, 'Expert.BMS_Info.Virology_Tags', 'N', 'N', 'N', 'N');

insert into expertdna_privileges values (HIBERNATE_SEQUENCE.NEXTVAL, (select groupid from groups where groupname = 
'OTSUKA_JV'), 2, 'Expert.BMS_Info.Virology_Attributes', 'N', 'N', 'N', 'N');
insert into expertdna_privileges values (HIBERNATE_SEQUENCE.NEXTVAL, (select groupid from groups where groupname = 
'OTSUKA_JV'), 2, 'Expert.BMS_Info.Health_Outcomes_Attributes', 'N', 'N', 'N', 'N');
insert into expertdna_privileges values (HIBERNATE_SEQUENCE.NEXTVAL, (select groupid from groups where groupname = 
'OTSUKA_JV'), 2, 'Expert.BMS_Info.CVMET_Attributes', 'N', 'N', 'N', 'N');
insert into expertdna_privileges values (HIBERNATE_SEQUENCE.NEXTVAL, (select groupid from groups where groupname = 
'OTSUKA_JV'), 2, 'Expert.BMS_Info.Health_Outcomes_Tags', 'N', 'N', 'N', 'N');

insert into expertdna_privileges values (HIBERNATE_SEQUENCE.NEXTVAL, (select groupid from groups where groupname = 
'SAXA_JV'), 2, 'Expert.BMS_Info.iPlan_Data', 'N', 'N', 'N', 'N');
insert into expertdna_privileges values (HIBERNATE_SEQUENCE.NEXTVAL, (select groupid from groups where groupname = 
'OTSUKA_JV'), 2, 'Expert.BMS_Info.iPlan_Data', 'N', 'N', 'N', 'N');
update expertdna_privileges set allow_read = 'N' where group_id = (select groupid from groups where groupname = 
'SAXA_JV') and feature_key = 'Expert.BMS_Info.Medical_Inquiries';


Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.Profile.Identifiers','N','N','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.Profile','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.Profile.Profile_Details','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.Profile.Biography_','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.Profile.Education','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.Profile.Org._Affiliations','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.Profile.Career_History','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.Profile.Address','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.Profile.Contact_Information','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.Profile.Additional_Contacts','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.Professional_Activities.Professional_Activities','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.Professional_Activities.Societies','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.Professional_Activities.Industry_Activities','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.Professional_Activities.Presentation','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.Professional_Activities.Committees','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.Professional_Activities.Editorial_Boards','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.Professional_Activities.Grants','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.Professional_Activities.Patents','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.Professional_Activities.Honors','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.Company_Profile.Company_Relationship','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.Company_Profile.Partnership','N','N','Y','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.Company_Profile.Grant','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.Publications.Publications','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.Publications.Topic_Expertise','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.Publications.Interest_Description','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.Trials.BMS_Trials','N','N','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.BMS_Speaker_Profile.Speaker_Profile','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.BMS_Speaker_Profile.Scheduled_/_Past_Events','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.BMS_Speaker_Profile.Training','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Organization.Organization_Profile','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Organization.Plan','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.BMS_Affliations.Affiliations','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Clinical_Trials.Trial_Info','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Clinical_Trials.Trial_Details','N','Y','N','N');
Insert into "EXPERTDNA_PRIVILEGES" ("PRIVILEGE_ID","GROUP_ID","USER_TYPE","FEATURE_KEY","ALLOW_CREATE","ALLOW_READ","ALLOW_UPDATE","ALLOW_DELETE") values (HIBERNATE_SEQUENCE.NEXTVAL,(select groupid from groups where groupname = 'OTSUKA_JV'),2,'Expert.Trials.All_Trials','N','Y','N','N');


update expertdna_privileges set feature_key = 'Expert.BMS_Info.TL_Selection_Criteria'
where feature_key = 'Expert.BMS_Info.OL_Selection_Criteria';

update expertdna_privileges set feature_key = 'Expert.BMS_Info.TL_Colleagues'
where feature_key = 'Expert.BMS_Info.OL_Colleagues';

commit;


rem Permissions for Product to Otsuka_JV except Abilify(Neuro)

UPDATE feature_usergroup_map
SET usergroup_id = usergroup_id ||
  (SELECT groupid
   FROM groups
   WHERE groupname = 'OTSUKA_JV')
|| ','
WHERE feature_id IN
  (SELECT id
   FROM option_lookup
   WHERE option_id = 83398427)
AND feature_id != 86850537;


rem Permissions for Therapeutic Area to Otsuka_JV except Neuro

UPDATE feature_usergroup_map
SET usergroup_id = usergroup_id ||
  (SELECT groupid
   FROM groups
   WHERE groupname = 'OTSUKA_JV')
|| ','
WHERE feature_id IN
  (SELECT id
   FROM option_lookup
   WHERE option_id = 44)
AND feature_id != 85543648;


commit;

rem : 1>Author name         : Vinay/Yatin
rem : 2>Purpose of change   : Support for a new Joint Venture Otsuka_JV
rem : 3>Date of change      : 28/10/2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 4

rem : Query to Create a new Off-Label Product LOV

insert into option_names values (HIBERNATE_SEQUENCE.NEXTVAL, 'Unsolicited Off-label Products', (select parent from option_names where name = 'Product'));

rem : Insert (Copy) all the Product LOVs to Off-Label Product LOVs

insert into option_lookup (select HIBERNATE_SEQUENCE.NEXTVAL, (select id from option_names where name = 'Unsolicited Off-label Products'), optvalue, deleteflag, parent, default_selected, display_order from option_lookup where option_id in (select id from option_names where name = 'Product'));

rem : Update parent of Off-label Topics

update option_names set parent = (select id from option_names where name = 'Unsolicited Off-label Products') where name = 'Off-label Topics';

rem: Updating Off-Label Topic Option Value's Parent option Value ID with the new UnSolicited Off-label Products Option Value ID's

CREATE OR REPLACE PROCEDURE update_offlabel_topic_parent IS CURSOR offlabel_cursor IS
SELECT *
FROM option_lookup
WHERE option_id = 83398433
 AND parent != -1;
offlabel_val offlabel_cursor % rowtype;
par NUMBER(19,0);
counter NUMBER;
BEGIN
  counter := 0;

  OPEN offlabel_cursor;
  LOOP
    FETCH offlabel_cursor
    INTO offlabel_val;
    EXIT
  WHEN offlabel_cursor % NOTFOUND;

  BEGIN
    SELECT offlabelprodid
    INTO par
    FROM
      (SELECT prod.id AS productid,
         offlabelprod.id AS offlabelprodid
       FROM option_lookup prod LEFT
       OUTER JOIN option_lookup offlabelprod ON(offlabelprod.optvalue = prod.optvalue
       AND offlabelprod.parent = prod.parent
       AND offlabelprod.deleteflag = prod.deleteflag)
       WHERE prod.option_id = 83398427
       AND offlabelprod.option_id =
        (SELECT id
         FROM option_names
         WHERE name = 'Unsolicited Off-label Products')
      )
    WHERE productid = offlabel_val.parent;

  EXCEPTION
  WHEN too_many_rows THEN
    DBMS_OUTPUT.PUT_LINE('Too many rows.');
    par := NULL;
  WHEN no_data_found THEN
    DBMS_OUTPUT.PUT_LINE('No row found.');
    par := NULL;
  WHEN others THEN
    raise_application_error(-20011,'Unknown Exception');
  END;

  IF(par IS NOT NULL) THEN
    counter := counter + 1;

    UPDATE option_lookup
    SET parent = par
    WHERE parent = offlabel_val.parent
     AND id = offlabel_val.id
     AND option_id = offlabel_val.option_id;
  END IF;

END LOOP;

CLOSE offlabel_cursor;

DBMS_OUTPUT.PUT_LINE('No. of rows updated: ' || counter);

END;
.
/

call update_offlabel_topic_parent();


CREATE OR REPLACE PROCEDURE update_interactiondata_lovid IS CURSOR unsolictedofflabel_cursor IS
SELECT idata.id AS idataid,
  idata.lovid AS idata_productid,
  optl.id AS optl_id,
  optl.option_id AS option_id,
  optl.optvalue AS productvalue,
  optl.parent AS opt_parentid
FROM interaction_data idata LEFT
OUTER JOIN option_lookup optl ON(optl.id = idata.lovid)
WHERE idata.type = 'unsolictedOffLabelTripletIds';
row_val unsolictedofflabel_cursor % rowtype;
proid NUMBER;
counter NUMBER;
BEGIN
  counter := 0;

  OPEN unsolictedofflabel_cursor;
  LOOP
    FETCH unsolictedofflabel_cursor
    INTO row_val;
    EXIT
  WHEN unsolictedofflabel_cursor % NOTFOUND;

  BEGIN
    SELECT offlabelprodid
    INTO proid
    FROM
      (SELECT prod.id AS productid,
         offlabelprod.id AS offlabelprodid
       FROM option_lookup prod LEFT
       OUTER JOIN option_lookup offlabelprod ON(offlabelprod.optvalue = prod.optvalue
       AND offlabelprod.parent = prod.parent
       AND offlabelprod.deleteflag = prod.deleteflag)
       WHERE prod.option_id = 83398427
       AND offlabelprod.option_id =
        (SELECT id
         FROM option_names
         WHERE name = 'Unsolicited Off-label Products')
      )
    WHERE productid = row_val.idata_productid;

  EXCEPTION
  WHEN too_many_rows THEN
    DBMS_OUTPUT.PUT_LINE('Too many rows.');
    proid := NULL;
  WHEN no_data_found THEN
    DBMS_OUTPUT.PUT_LINE('No row found.');
    proid := NULL;
  WHEN others THEN
    raise_application_error(-20011,'Unknown Exception');
  END;

  IF(proid IS NOT NULL) THEN
    counter := counter + 1;

    UPDATE interaction_data
    SET lovid = proid
    WHERE lovid = row_val.idata_productid
     AND id = row_val.idataid;
  END IF;

END LOOP;

CLOSE unsolictedofflabel_cursor;

DBMS_OUTPUT.PUT_LINE('No. of rows updated: ' || counter);

END;

.
/

call update_interactiondata_lovid();


rem: Procedure to apply Feature Usergroup Permissioning on Unsolicited Off-label Products Option Values

CREATE OR REPLACE PROCEDURE permission_offlabel_products IS CURSOR offlabel_cursor IS
SELECT prod.id AS productid,
  offlabelprod.id AS offlabelprodid
FROM option_lookup prod LEFT
OUTER JOIN option_lookup offlabelprod ON(offlabelprod.optvalue = prod.optvalue
 AND offlabelprod.parent = prod.parent
 AND offlabelprod.deleteflag = prod.deleteflag)
WHERE prod.option_id = 83398427
 AND offlabelprod.option_id =
  (SELECT id
   FROM option_names
   WHERE name = 'Unsolicited Off-label Products')
;

offlabel_val offlabel_cursor % rowtype;
par NUMBER(19,0);
counter NUMBER;

BEGIN
  counter := 0;

  OPEN offlabel_cursor;
  LOOP
    FETCH offlabel_cursor
    INTO offlabel_val;
    EXIT
  WHEN offlabel_cursor % NOTFOUND;

  INSERT
  INTO feature_usergroup_map
    (SELECT hibernate_sequence.nextval,
       offlabel_val.offlabelprodid,
       usergroup_id,
       permission_on_feature
     FROM feature_usergroup_map
     WHERE feature_id = offlabel_val.productid)
  ;

  counter := counter + 1;

END LOOP;

CLOSE offlabel_cursor;

DBMS_OUTPUT.PUT_LINE('No. of Products: ' || counter);

END;
.
/

call permission_offlabel_products();


rem : 1>Author name         : Yatin
rem : 2>Purpose of change   : Queries for Unsolicited Off Label Products Section in Interaction Page
rem : 3>Date of change      : 30/10/2009

rem ------------------------------------------------------------------------------------------------


rem : Batch : 5

update feature_usergroup_map 
set usergroup_id = usergroup_id || ','||(select groupid from groups where groupname like 'OTSUKA_JV')||','
where feature_id in (
select attribute_id from attributetable where parent_id in 
(select entity_type_id from attributetable where name in 
('CVMET Attributes','CVMET Tags','Health Outcomes Attributes','Health Outcomes Tags','Immunoscience Attributes',
'Immunoscience Tags','Virology Attributes','Virology Tags','Oncology Attributes',
'Oncology Tags', 'BMS Trials')));

commit;

rem : 1>Author name         : Tapan
rem : 2>Purpose of change   : Permission on Searchable Attributes for Otsuka JV
rem : 3>Date of change      : 09/11/2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 6

rem : Query to Create Feature Permission on Interaction topic for Otsuka_JV users


update feature_usergroup_map
set usergroup_id = usergroup_id || ','||(select groupid from groups where groupname like 'OTSUKA_JV')||','
where feature_id in 
(select id from option_lookup where optvalue in
('Adboard Discussion','Clinical Trial Discussion','Publication Discussion','Content Development','Product Disease State','Outcomes Research'));

-- INSERTING into FEATURE_USERGROUP_MAP

Insert into "FEATURE_USERGROUP_MAP" ("ID","FEATURE_ID","USERGROUP_ID","PERMISSION_ON_FEATURE") values (HIBERNATE_SEQUENCE.NEXTVAL,83401232,','||(select groupid from groups where groupname like 'OTSUKA_JV')||',',2);
Insert into "FEATURE_USERGROUP_MAP" ("ID","FEATURE_ID","USERGROUP_ID","PERMISSION_ON_FEATURE") values (HIBERNATE_SEQUENCE.NEXTVAL,83401233,','||(select groupid from groups where groupname like 'OTSUKA_JV')||',',2);
Insert into "FEATURE_USERGROUP_MAP" ("ID","FEATURE_ID","USERGROUP_ID","PERMISSION_ON_FEATURE") values (HIBERNATE_SEQUENCE.NEXTVAL,83401234,','||(select groupid from groups where groupname like 'OTSUKA_JV')||',',2);
Insert into "FEATURE_USERGROUP_MAP" ("ID","FEATURE_ID","USERGROUP_ID","PERMISSION_ON_FEATURE") values (HIBERNATE_SEQUENCE.NEXTVAL,91320760,','||(select groupid from groups where groupname like 'OTSUKA_JV')||',',2);
Insert into "FEATURE_USERGROUP_MAP" ("ID","FEATURE_ID","USERGROUP_ID","PERMISSION_ON_FEATURE") values (HIBERNATE_SEQUENCE.NEXTVAL,86860949,','||(select groupid from groups where groupname like 'OTSUKA_JV')||',',2);
Insert into "FEATURE_USERGROUP_MAP" ("ID","FEATURE_ID","USERGROUP_ID","PERMISSION_ON_FEATURE") values (HIBERNATE_SEQUENCE.NEXTVAL,95466601,','||(select groupid from groups where groupname like 'OTSUKA_JV')||',',2);
Insert into "FEATURE_USERGROUP_MAP" ("ID","FEATURE_ID","USERGROUP_ID","PERMISSION_ON_FEATURE") values (HIBERNATE_SEQUENCE.NEXTVAL,95466599,','||(select groupid from groups where groupname like 'OTSUKA_JV')||',',2);
Insert into "FEATURE_USERGROUP_MAP" ("ID","FEATURE_ID","USERGROUP_ID","PERMISSION_ON_FEATURE") values (HIBERNATE_SEQUENCE.NEXTVAL,95466602,','||(select groupid from groups where groupname like 'OTSUKA_JV')||',',2);
Insert into "FEATURE_USERGROUP_MAP" ("ID","FEATURE_ID","USERGROUP_ID","PERMISSION_ON_FEATURE") values (HIBERNATE_SEQUENCE.NEXTVAL,95466600,','||(select groupid from groups where groupname like 'OTSUKA_JV')||',',2);
Insert into "FEATURE_USERGROUP_MAP" ("ID","FEATURE_ID","USERGROUP_ID","PERMISSION_ON_FEATURE") values (HIBERNATE_SEQUENCE.NEXTVAL,95466691,','||(select groupid from groups where groupname like 'OTSUKA_JV')||',',2);
Insert into "FEATURE_USERGROUP_MAP" ("ID","FEATURE_ID","USERGROUP_ID","PERMISSION_ON_FEATURE") values (HIBERNATE_SEQUENCE.NEXTVAL,103332916,','||(select groupid from groups where groupname like 'OTSUKA_JV')||',',2);
Insert into "FEATURE_USERGROUP_MAP" ("ID","FEATURE_ID","USERGROUP_ID","PERMISSION_ON_FEATURE") values (HIBERNATE_SEQUENCE.NEXTVAL,103332917,','||(select groupid from groups where groupname like 'OTSUKA_JV')||',',2);
Insert into "FEATURE_USERGROUP_MAP" ("ID","FEATURE_ID","USERGROUP_ID","PERMISSION_ON_FEATURE") values (HIBERNATE_SEQUENCE.NEXTVAL,103332922,','||(select groupid from groups where groupname like 'OTSUKA_JV')||',',2);
Insert into "FEATURE_USERGROUP_MAP" ("ID","FEATURE_ID","USERGROUP_ID","PERMISSION_ON_FEATURE") values (HIBERNATE_SEQUENCE.NEXTVAL,103364273,','||(select groupid from groups where groupname like 'OTSUKA_JV')||',',2);
Insert into "FEATURE_USERGROUP_MAP" ("ID","FEATURE_ID","USERGROUP_ID","PERMISSION_ON_FEATURE") values (HIBERNATE_SEQUENCE.NEXTVAL,103364289,','||(select groupid from groups where groupname like 'OTSUKA_JV')||',',2);


rem : 1>Author name         : Vinay Rao
rem : 2>Purpose of change   : Query to Create Feature Permission on Interaction topic for Otsuka_JV users
rem : 3>Date of change      : 07/11/2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 7

update option_lookup set optvalue ='Treatment Guidelines/Consensus Statements' where optvalue ='Treatment Guidelines / Consensus Statements';

update option_lookup set optvalue ='ERBITUX CRC-MSL assess TL Core Beliefs based on Strategic Medical Plan' where id=86851909;
update option_lookup set optvalue ='Orencia-Ensure that all TLs are aware of safety profile of Abatacept' where id=90262899;
update option_lookup set optvalue ='Orencia-Ensure that all TLs are aware importance of adequacy of response to biologic therapy' where id=90262900;
update option_lookup set optvalue ='IXEMPRA-Discuss single agent and combination data re: Ixempra efficacy and safety results of completed clinical trials with breast TLs' where id=88430334;
update option_lookup set optvalue ='Discuss the background rationale, including inclusion/exclusion criteria, of the bladder and breast studies with TL Investigators' where id=86860851;
update option_lookup set optvalue ='Discuss vinflunine''s unique binding characteristics with TL Investigators' where id=86860852;
update option_lookup set optvalue ='Understand individual TL treatment patterns in managing advanced breast cancer patients' where id=86860858;
update option_lookup set optvalue ='Discuss single agent and combination data re: Ixempra efficacy and safety results of completed clinical trials with breast TLs' where id=86860859;
update option_lookup set optvalue ='Respond to TL questions re: Ixempra breast, GU, and safety data' where id=86860860;
update option_lookup set optvalue ='Ensure that all TLs are aware of safety profile of Abatacept' where id=96126405;
update option_lookup set optvalue ='Ensure that TLs are aware of importance of adequacy of response to biologic therapy' where id=96126406;


rem : 1>Author name         : Vinay Rao
rem : 2>Purpose of change   : Query to correct the option Value for Scorecard Reports
rem : 3>Date of change      : 07/11/2009

rem ------------------------------------------------------------------------------------------------


rem : Batch : 8

create table StudyDup (newStudyID number(19,0), oldStudyID number(19,0), optValue varchar2(4000));

Insert into studydup values (103193838,101470572,'AI420-084 ST');
Insert into studydup values (103193848,90262466,'AI424-043 ST');
Insert into studydup values (103193816,90262596,'AI424-900 ST');
Insert into studydup values (103193858,90262668,'AI463-014 ST');
Insert into studydup values (103193806,90262669,'AI463-015 ST');
Insert into studydup values (103193808,90262672,'AI463-022 ST');
Insert into studydup values (103193837,90262673,'AI463-026 ST');
Insert into studydup values (103193843,90262674,'AI463-027 ST');
Insert into studydup values (103193811,90262685,'AI463-049 ST');
Insert into studydup values (103193791,90262693,'AI463-085 ST');
Insert into studydup values (103193819,90262706,'AI463-901 ST');
Insert into studydup values (103193867,90262717,'AI464-017 ST');
Insert into studydup values (103193887,101470614,'AI464-019 ST');
Insert into studydup values (103193788,86851070,'CA139-398 ST');
Insert into studydup values (103193898,86851170,'CA146-076 ST');
Insert into studydup values (103193906,86851236,'CA163-046 ST');
Insert into studydup values (103193870,86851242,'CA163-081 ST');
Insert into studydup values (103193881,86851259,'CA163-140 ST');
Insert into studydup values (103193895,86851288,'CA163-177 ST');
Insert into studydup values (103193879,101470390,'CA163-196 ST');
Insert into studydup values (104848761,103193793,'CA163-200 ST');
Insert into studydup values (103193864,86851337,'CA180-034 LT');
Insert into studydup values (103193845,86851338,'CA180-034 ST');
Insert into studydup values (103193826,86851340,'CA180-035 ST');
Insert into studydup values (103193856,86851356,'CA180-056 LT');
Insert into studydup values (103193863,86851357,'CA180-056 ST');
Insert into studydup values (103193868,86851361,'CA180-071 ST');
Insert into studydup values (103927074,103193823,'CA180-207 ST');
Insert into studydup values (103193878,86851470,'CA180-261 ST');
Insert into studydup values (106500682,103193803,'CA180-274 ST');
Insert into studydup values (103927111,103193874,'CA180-308 ST');
Insert into studydup values (103193815,86851509,'CA182-026 ST');
Insert into studydup values (103193908,86851513,'CA182-033 ST');
Insert into studydup values (103193857,86851514,'CA182-034 ST');
Insert into studydup values (103193796,101470699,'CA182-037 ST');
Insert into studydup values (103193865,86851529,'CA183-026 ST');
Insert into studydup values (103193844,86851548,'CA184-024 ST');
Insert into studydup values (103193804,86851549,'CA184-025 ST');
Insert into studydup values (103193847,86851552,'CA184-029 ST');
Insert into studydup values (103193903,86851559,'CA184-043 ST');
Insert into studydup values (103193853,86851560,'CA184-045 ST');
Insert into studydup values (103927067,103193802,'CA184-090 ST');
Insert into studydup values (103927091,103193800,'CA184-091 ST');
Insert into studydup values (103927095,103193810,'CA184-093 ST');
Insert into studydup values (103193849,86851604,'CA187-017 ST');
Insert into studydup values (103193873,86851610,'CA191-004 ST');
Insert into studydup values (103193841,101470492,'CA191-006 ST');
Insert into studydup values (103193850,86851616,'CA194-003 ST');
Insert into studydup values (103193813,101470480,'CA196-004 ST');
Insert into studydup values (103193892,101470394,'CA196-005 ST');
Insert into studydup values (103193888,86851623,'CA200-004 ST');
Insert into studydup values (103193884,101470647,'CN101-123 ST');
Insert into studydup values (103193883,101470753,'CN101-124 ST');
Insert into studydup values (103193901,101470554,'CN102-025 ST');
Insert into studydup values (103193830,86850614,'CN104-141 LT');
Insert into studydup values (103193836,86850615,'CN104-141 ST');
Insert into studydup values (103193807,86850616,'CN104-149 ST');
Insert into studydup values (103193904,101470655,'CN104-154 ST');
Insert into studydup values (103193820,101470485,'CN104-174 LT');
Insert into studydup values (103193789,101470623,'CN104-174 ST');
Insert into studydup values (103193866,101470787,'CN104-175 ST');
Insert into studydup values (103193871,101470580,'CN104-176 LT');
Insert into studydup values (103193896,101470330,'CN104-176 ST');
Insert into studydup values (103193835,86850617,'CN104-187 LT');
Insert into studydup values (103193797,86850618,'CN104-187 ST');
Insert into studydup values (103193832,101470782,'CN104-197 ST');
Insert into studydup values (103193834,86850619,'CN104-201 ST');
Insert into studydup values (103193799,86850620,'CN104-203 ST');
Insert into studydup values (103193889,90262310,'CV168-021 LT');
Insert into studydup values (103193814,90262311,'CV168-021 ST');
Insert into studydup values (103193886,90262312,'CV168-022 LT');
Insert into studydup values (103193846,90262313,'CV168-022 ST');
Insert into studydup values (103193907,90262320,'CV168-048 LT');
Insert into studydup values (103193801,90262321,'CV168-048 ST');
Insert into studydup values (103193842,90262323,'CV168-062 ST');
Insert into studydup values (103193790,90262327,'CV177-008 ST');
Insert into studydup values (103193833,90262335,'CV181-014 LT');
Insert into studydup values (103193805,90262336,'CV181-014 ST');
Insert into studydup values (103193855,90262342,'CV181-038 ST');
Insert into studydup values (103193899,90262344,'CV181-040 LT');
Insert into studydup values (103193818,90262345,'CV181-040 ST');
Insert into studydup values (103193902,90262352,'CV185-010 ST');
Insert into studydup values (103193812,90262354,'CV185-017 ST');
Insert into studydup values (103193828,90262356,'CV185-023 ST');
Insert into studydup values (103193792,90262358,'CV185-030 ST');
Insert into studydup values (103193822,90262359,'CV185-034 ST');
Insert into studydup values (103193893,90262360,'CV185-035 ST');
Insert into studydup values (103193809,90262361,'CV185-036 ST');
Insert into studydup values (103193900,90261177,'IM101-084 LT');
Insert into studydup values (103193869,90261178,'IM101-084 ST');
Insert into studydup values (103193854,90260700,'IM101-101 LT');
Insert into studydup values (103193794,90260701,'IM101-101 ST');
Insert into studydup values (103193877,90260753,'IM101-102 ST');
Insert into studydup values (103193829,90261202,'IM101-108 LT');
Insert into studydup values (103193839,90261203,'IM101-108 ST');
Insert into studydup values (103193860,90261185,'IM101-174 LT');
Insert into studydup values (103193795,90261186,'IM101-174 ST');
Insert into studydup values (103927098,103193827,'IM103-083 ST');
Insert into studydup values (103193891,90262754,'MB102-008 ST');
Insert into studydup values (103193890,90262758,'MB102-014 LT');
Insert into studydup values (103193885,90262759,'MB102-014 ST');
Insert into studydup values (103193825,90262764,'MB102-021 ST');
Insert into studydup values (103193821,90262772,'MB102-033 ST');
Insert into studydup values (103193875,101470551,'MB102-034 ST');

commit;

CREATE OR REPLACE PROCEDURE update_dupStudy_Siteparent IS CURSOR dupStudy_cursor IS
select * from option_lookup where parent in
(select newStudyID from studydup);
optionLookup_val dupStudy_cursor % rowtype;
par NUMBER(19,0);
counter NUMBER;
BEGIN
  counter := 0;

  OPEN dupStudy_cursor;
  LOOP
    FETCH dupStudy_cursor
    INTO optionLookup_val;
    EXIT
  WHEN dupStudy_cursor % NOTFOUND;

  BEGIN
    select oldstudyid INTO par 
    from studydup 
    where newStudyid = optionLookup_val.parent;

  EXCEPTION
  WHEN too_many_rows THEN
    DBMS_OUTPUT.PUT_LINE('Too many rows.');
    par := NULL;
  WHEN no_data_found THEN
    DBMS_OUTPUT.PUT_LINE('No row found.');
    par := NULL;
  WHEN others THEN
    raise_application_error(-20011,'Unknown Exception');
  END;

  IF(par IS NOT NULL) THEN
    counter := counter + 1;

    UPDATE option_lookup
    SET parent = par
    WHERE parent = optionLookup_val.parent
     AND id = optionLookup_val.id
     AND option_id = optionLookup_val.option_id;
  END IF;

END LOOP;

CLOSE dupStudy_cursor;

DBMS_OUTPUT.PUT_LINE('No. of rows updated: ' || counter);

END;
.
/

call update_dupStudy_Siteparent();

commit;

create or replace PROCEDURE update_dupStudy_idata IS CURSOR dupStudy_cursor IS
select * from interaction_data where type = 'selectStudyMultiselectIds'
and lovid in 
(select newStudyID from studydup);
optionLookup_val dupStudy_cursor % rowtype;
par NUMBER(19,0);
counter NUMBER;
BEGIN
  counter := 0;

  OPEN dupStudy_cursor;
  LOOP
    FETCH dupStudy_cursor
    INTO optionLookup_val;
    EXIT
  WHEN dupStudy_cursor % NOTFOUND;

  BEGIN
    select oldstudyid INTO par 
    from studydup 
    where newStudyid = optionLookup_val.lovid;

  EXCEPTION
  WHEN too_many_rows THEN
    DBMS_OUTPUT.PUT_LINE('Too many rows.');
    par := NULL;
  WHEN no_data_found THEN
    DBMS_OUTPUT.PUT_LINE('No row found.');
    par := NULL;
  WHEN others THEN
    raise_application_error(-20011,'Unknown Exception');
  END;

  IF(par IS NOT NULL) THEN
    counter := counter + 1;

    UPDATE interaction_data
    SET lovid = par
    WHERE id = optionLookup_val.id;
  END IF;

END LOOP;

CLOSE dupStudy_cursor;

DBMS_OUTPUT.PUT_LINE('No. of rows updated: ' || counter);

END;
.
/


call update_dupStudy_idata();

commit;

delete from option_lookup where id in 
(select newstudyid from studydup);

commit;

drop table studydup;

commit;

rem : 1>Author name         : Tapan 
rem : 2>Purpose of change   : Script to delete the Study Duplicate LOV's and update the Site Option Lookup and Interaction Data lovid for the deleted Study Values.
rem : 3>Date of change      : 07/12/2009

rem ------------------------------------------------------------------------------------------------

rem : Batch : 9

 CREATE OR REPLACE FORCE VIEW "USER_RELATIONSHIP_VIEW_NEW" ("USERID", "TERRITORY_ID", "TERRITORY", "REGION_ID", "REGION", "TA_ID", "TA", "NAME", "MSL_START", "REGIONUSER_ID", "REGIONUSER", "TERRITORYSTARTDATE", "REGIONSTARTDATE") AS 
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
and ur.begin_date <= sysdate
and ur.end_date >= sysdate
and ur1.begin_date <= sysdate
and ur1.end_date >= sysdate;

commit;

rem : 1>Author name         : Vinay
rem : 2>Purpose of change   : Script to create or replace user_relationship_new_view
rem : 3>Date of change      : 07/16/2009


rem ------------------------------------------------------------------------------------------------


commit;

rem user, time : 

SELECT USER, SUBSTR(SYSTIMESTAMP,1,30) FROM DUAL;

SPOOL OFF


SET ECHO OFF



exit;

rem ------------------------------------------------------------------------------------------------