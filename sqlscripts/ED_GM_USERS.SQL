--delete group
DELETE FROM GROUPS WHERE GROUPNAME LIKE 'ED_GM';
DELETE FROM user_group_map where group_id in (select groupid from groups where groupname LIKE 'ED%');


---insert into groups

insert into groups values((SELECT NVL(MAX(GROUPID),0)+1 FROM GROUPS),'ED_GM','ED GM Group','Expert',1,(select id from option_lookup where optvalue ='General Medicine' and option_id = (select id from option_names where name like 'Therapeutic Area')),(select id from option_lookup where optvalue='Early Development'),(select id from option_lookup where optvalue ='USA'));


---Insert ED_GM Users

insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Banfield','Christopher','banfield','67586');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Chung','James','chung','23422');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Daniels','Oranee','odaniels','23422');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Davar','Gudarz','gdavar','20106');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Evelhoch','Jeff','evelhoch','26094');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Friberg','Greg','gfriberg','47514');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Haqq','Chris','chaqq'	,'30973');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Hill'	,'John','jshill','44466');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Hwang','Dah-Ren','dahh','35202');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Keswani','Sanjay','skeswani','35857');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Minning','Dena','dminning','82657');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Padhi','Desmond','dpadhi','44515');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Parnes','Jane','jparnes','49085');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Perfetti','Riccardo','perfetti','27308');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Schlitt','Heidi','hschlitt','44663');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Storgard','Chris','storgard','20346');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Thai','Zung','dthai','32261');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Tran'	,'Jonathan','tranj','35858');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Tsuji','Wayne','tsujiw','64552');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Vincent','Mike','mvincent','74558');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Wang','Fong','fongw','39534');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Williams','Gary','gjwillia','19773');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Yates','Wayne','wyates','22123');

--- insert users into ED_GM group
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='ED_GM' ), (select id from user_table where username='banfield'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='ED_GM' ), (select id from user_table where username='chung'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='ED_GM' ), (select id from user_table where username='odaniels'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='ED_GM' ), (select id from user_table where username='gdavar'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='ED_GM' ), (select id from user_table where username='evelhoch'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='ED_GM' ), (select id from user_table where username='gfriberg'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='ED_GM' ), (select id from user_table where username='chaqq'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='ED_GM' ), (select id from user_table where username='jshill'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='ED_GM' ), (select id from user_table where username='dahh'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='ED_GM' ), (select id from user_table where username='skeswani'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='ED_GM' ), (select id from user_table where username='dminning'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='ED_GM' ), (select id from user_table where username='dpadhi'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='ED_GM' ), (select id from user_table where username='jparnes'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='ED_GM' ), (select id from user_table where username='perfetti'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='ED_GM' ), (select id from user_table where username='hschlitt'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='ED_GM' ), (select id from user_table where username='storgard'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='ED_GM' ), (select id from user_table where username='dthai'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='ED_GM' ), (select id from user_table where username='tranj'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='ED_GM' ), (select id from user_table where username='tsujiw'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='ED_GM' ), (select id from user_table where username='mvincent'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='ED_GM' ), (select id from user_table where username='fongw'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='ED_GM' ), (select id from user_table where username='gjwillia'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='ED_GM' ), (select id from user_table where username='wyates'));

-------------------------------------insert address entry for all the user --------------------------------------------------------

---insert address in to ED_GM group users
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='banfield'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='chung'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='odaniels'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='gdavar'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='evelhoch'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='gfriberg'));

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='chaqq'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='jshill'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='dahh'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='skeswani'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='dminning'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='dpadhi'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='jparnes'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='perfetti'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='hschlitt'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='storgard'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='dthai'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='tranj'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='tsujiw'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='mvincent'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='fongw'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='gjwillia'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='wyates'));

------------------- UPDATE ADDRESS ID INTO USER_TABLE ------------------------------------------------------------------------------------------

---insert address id in to ED_GM group users

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='banfield')) where username='banfield';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='chung')) where username='chung';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='odaniels')) where username='odaniels';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='gdavar')) where username='gdavar';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='evelhoch')) where username='evelhoch';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='gfriberg')) where username='gfriberg';

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='chaqq')) where username='chaqq';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='jshill')) where username='jshill';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='dahh')) where username='dahh';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='skeswani')) where username='skeswani';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='dminning')) where username='dminning';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='dpadhi')) where username='dpadhi';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='jparnes')) where username='jparnes';

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='perfetti')) where username='perfetti';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='hschlitt')) where username='hschlitt';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='storgard')) where username='storgard';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='dthai')) where username='dthai';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='tranj')) where username='tranj';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='tsujiw')) where username='tsujiw';

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='mvincent')) where username='mvincent';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='fongw')) where username='fongw';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='gjwillia')) where username='gjwillia';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='wyates')) where username='wyates';


--update all the users 

update user_table set user_type_id=2,influencelevel=0,latitude=0,longitude=0,kolid=0,prefix=618,suffix=622,email='test@test.com', password='test',TITLE='ED_GM_TEST' ,deleteflag='N' where influencelevel is null;

-- update all user_address

update user_address set address1='ED_GM_TEST',city='test',state_lookup_id=11,country_lookup_id=278,zip='123',fullprofile=0 where fullprofile is null;


commit;
