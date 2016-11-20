-- drop COM groups
DELETE FROM GROUPS WHERE GROUPNAME LIKE 'COM_%';
DELETE FROM user_group_map where group_id in (select groupid from groups where groupname LIKE 'COM%');

---insert into groups

insert into groups values((SELECT NVL(MAX(GROUPID),0)+1 FROM GROUPS),'COM_HF','COM-HF Group','Expert',1,(select id from option_lookup where optvalue ='Heart Failure' and option_id = (select id from option_names where name like 'Therapeutic Area')),(select id from option_lookup where optvalue='Commercial'),(select id from option_lookup where optvalue ='USA'));
insert into groups values((SELECT NVL(MAX(GROUPID),0)+1 FROM GROUPS),'COM_MBT','COM-MBT Group','Expert',1,(select id from option_lookup where optvalue ='Metabolic Bone' and option_id = (select id from option_names where name like 'Therapeutic Area')),(select id from option_lookup where optvalue='Commercial'),(select id from option_lookup where optvalue ='USA'));
insert into groups values((SELECT NVL(MAX(GROUPID),0)+1 FROM GROUPS),'COM_HOPE','COM-Hope Group','Expert',1,(select id from option_lookup where optvalue ='GHE/HOPE' and option_id = (select id from option_names where name like 'Therapeutic Area')),(select id from option_lookup where optvalue='Commercial'),(select id from option_lookup where optvalue ='USA'));
insert into groups values((SELECT NVL(MAX(GROUPID),0)+1 FROM GROUPS),'COM_NEP','COM-Nephrology Group','Expert',1,(select id from option_lookup where optvalue ='Nephrology' and option_id = (select id from option_names where name like 'Therapeutic Area')),(select id from option_lookup where optvalue='Commercial'),(select id from option_lookup where optvalue ='USA'));
insert into groups values((SELECT NVL(MAX(GROUPID),0)+1 FROM GROUPS),'COM_ONC','COM-Oncology Group','Expert',1,(select id from option_lookup where optvalue ='Oncology' and option_id = (select id from option_names where name like 'Therapeutic Area')),(select id from option_lookup where optvalue='Commercial'),(select id from option_lookup where optvalue ='USA'));
insert into groups values((SELECT NVL(MAX(GROUPID),0)+1 FROM GROUPS),'COM_INF','COM-Inflammation Group','Expert',1,(select id from option_lookup where optvalue ='Inflammation' and option_id = (select id from option_names where name like 'Therapeutic Area')),(select id from option_lookup where optvalue='Commercial'),(select id from option_lookup where optvalue ='USA'));

--one user per eachh com group

insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Chongg','Suei','sunghuici','Regional Medical Liaison II','12345');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Mark','Amit','amitmark','Regional Medical Liaison III','123456');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Dowg','Suei','downg','Regional Medical Liaison ','123457');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Jacob','Thomas','thomasj','Regional Medical Liaison I','123458');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Rowan','Peter','rpeter','Regional Medical Liaison II','123459');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'John','Perter','hpeter','Regional Medical Liaison II','123460');

insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='COM_HF' ), (select id from user_table where username='sunghuici'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='COM_MBT' ), (select id from user_table where username='amitmark'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='COM_HOPE' ), (select id from user_table where username='downg'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='COM_NEP' ), (select id from user_table where username='thomasj'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='COM_ONC' ), (select id from user_table where username='rpeter'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='COM_INF' ), (select id from user_table where username='hpeter'));

-- insert to user_address

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='sunghuici'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='amitmark'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='downg'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='thomasj'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='rpeter'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='hpeter'));

-- update user_address

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='sunghuici')) where username='sunghuici';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='amitmark')) where username='amitmark';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='downg')) where username='downg';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='thomasj')) where username='thomasj';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='rpeter')) where username='rpeter';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='hpeter')) where username='hpeter';


--update all the users 

update user_table set user_type_id=2,influencelevel=0,latitude=0,longitude=0,kolid=0,prefix=618,suffix=622,email='testc@test.com', password='test' ,deleteflag='N' where influencelevel is null;

-- update all user_address

update user_address set address1='test',city='test',state_lookup_id=11,country_lookup_id=278,zip='test',fullprofile=0 where fullprofile is null;


commit;
