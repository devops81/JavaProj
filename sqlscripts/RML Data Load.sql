
-- drop the groups
 
DELETE FROM GROUPS WHERE GROUPNAME LIKE 'RML_%';
DELETE FROM GROUPS WHERE GROUPNAME LIKE 'COM_%';

--drop the users of RML groups

delete from user_table where password='test' and email='test@test.com';
delete from user_address where userid > 0;

DELETE FROM user_group_map where group_id in (select groupid from groups where groupname LIKE 'COM%');
DELETE FROM user_group_map where group_id in (select groupid from groups where groupname LIKE 'RML%');

---insert into groups

insert into groups values((SELECT NVL(MAX(GROUPID),0)+1 FROM GROUPS),'RML_HF','HF Group','Expert',1,(select id from option_lookup where optvalue ='Heart Failure' and option_id = (select id from option_names where name like 'Therapeutic Area')),(select id from option_lookup where optvalue='Medical Affairs'),(select id from option_lookup where optvalue ='USA'));
insert into groups values((SELECT NVL(MAX(GROUPID),0)+1 FROM GROUPS),'RML_MBT','MBT Group','Expert',1,(select id from option_lookup where optvalue ='Metabolic Bone' and option_id = (select id from option_names where name like 'Therapeutic Area')),(select id from option_lookup where optvalue='Medical Affairs'),(select id from option_lookup where optvalue ='USA'));
insert into groups values((SELECT NVL(MAX(GROUPID),0)+1 FROM GROUPS),'RML_HOPE','Hope Group','Expert',1,(select id from option_lookup where optvalue ='GHE/HOPE' and option_id = (select id from option_names where name like 'Therapeutic Area')),(select id from option_lookup where optvalue='Medical Affairs'),(select id from option_lookup where optvalue ='USA'));
insert into groups values((SELECT NVL(MAX(GROUPID),0)+1 FROM GROUPS),'RML_NEP','Nephrology Group','Expert',1,(select id from option_lookup where optvalue ='Nephrology' and option_id = (select id from option_names where name like 'Therapeutic Area')),(select id from option_lookup where optvalue='Medical Affairs'),(select id from option_lookup where optvalue ='USA'));
insert into groups values((SELECT NVL(MAX(GROUPID),0)+1 FROM GROUPS),'RML_ONC','Oncology Group','Expert',1,(select id from option_lookup where optvalue ='Oncology' and option_id = (select id from option_names where name like 'Therapeutic Area')),(select id from option_lookup where optvalue='Medical Affairs'),(select id from option_lookup where optvalue ='USA'));
insert into groups values((SELECT NVL(MAX(GROUPID),0)+1 FROM GROUPS),'RML_INF','Inflammation Group','Expert',1,(select id from option_lookup where optvalue ='Inflammation' and option_id = (select id from option_names where name like 'Therapeutic Area')),(select id from option_lookup where optvalue='Medical Affairs'),(select id from option_lookup where optvalue ='USA'));


---Insert RML_HF Users
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Chong','Sue','sunghuic','Regional Medical Liaison II','48425');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Desai','Amy','adesai','Regional Medical Liaison II','89504');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Foster','Terry','terryf','Sr Regional Medical Liaison I','76238');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Gladden','Ben','bgladeen','Regional Medical Liaison II','41544');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Jones','Dean','jonese','Regional Medical Liaison II','40506');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Than','Andrew','athan','Assoc Dir Reg Medical Liaison','78457');

-- Insert RML_MBTusers
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Appajoysula','Sireesh','sireesh','Regional Medical Liaison II','48833');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Aurora','Bill','daurora','Sr Dir Regional Medical Liaison','65254');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Baldwin','Kay','kbaldwin','Assoc Dir Medical Services','50334');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Bass','Lynn','jbass','Regional Medical Liaison II','28333');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Bohn','Juergen','jbohn','Europ. RML Head Denosumab','31550');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Branvold','Adam','adamb','Sr Regional Medical Liaison I','55686');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Estus','Todd','testus','Regional Medical Liaison II','29508');

insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Evans','Dedra','dedrae','Regional Medical Liaison II','51699');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Farrar','Julie','Jfarrar','Regional Medical Liaison II',' ');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Hails','Deborah','dhails','Regional Medical Liaison II','46210');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Hamman','Michael','mhamann','Associate Director Medical Affairs','29233');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Larkins','Kim','larkinsk','Assoc Dir Reg Medical Liaison','64326');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Leff','John','jleff','VP Medical Affairs No America','63677');

insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Loh','Vicki','vloh','Sr Mgr Medical Comm','81811');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Mayer','Harmony','hmayer','Regional Medical Liaison II','78697');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'McKeirnan','Kelly','kmckeirn','Admin Coordinator IV','51632');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Minne','Paul','pminne','Regional Medical Liaison II','44569');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Morelli','Angela','amorelli','Regional Medical Liaison II','29168');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Mosdell','Kristen','mosdellk','Assoc Dir Medical Services','63284');

insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Norbash','Ali','anorbash','Regional Medical Liaison II','44036');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Null','Michael','nullm','Assoc Dir Medical Affairs','64314');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Pollard','Kristina','kpollard','Admin Coordinator IV','16099');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Ross','Alexandra','alross','Project Coordinator II','77178');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'San Martin','Javier','jsanmart','Dir Global Dev Leader','43548');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Scheifele','Andrew','ascheife','Assoc Dir Medical Affairs','55701');

insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Smith','Drew','andsmith','Assoc Dir Reg Medical Liaison','88744');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Stad','Robert','rstad','Medical Communications Manager III','88407');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Steidle','Michael','msteidle','Regional Medical Liaison II','32544');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Wagman','Rachel','rwagman','Dir Clinical Research','41952');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Wilkinson','Jim','jwilkins','Sr Mgr Medical Services','60862');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'Yeganegi','Homa','homay','Sr Dir Medical Affairs','611');

---Insert Hope new users
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'CLARK','TIMOTHY','TICLARK','Regional Medical Liaison II','85420');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'CLAY','REGINALD','BCLAY','Regional Medical Liaison I','56458');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'HURLEY','DANA','DHURLEY','Regional Medical Liason','24655');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'LYONS','ANN','LYONSA','Regional Medical Liaison II','24654');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'MASAMITSU','MICHAEL','MMASAMIT','Regional Medical Liaison-MCO','60670');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'PANNONE','ROBERT','RPANNONE','Regional Medical Liaison II','54729');

insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'PARKER','DIANNE','DIPARKER','Regional Medical Liaison II','85320');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'PHAM','HOA','HOA','Regional Medical Liaison II','81882');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'RYU','SEONYOUNG','SRYU','Sr Mgr','51040');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'STOLSHEK','BRADLEY','STOLSHEK','Assoc Dir Reg Medical Liaison','52942');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'THOMAS','JESSY','JESSYT','Regional Medical Liaison II','40362');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'TUCKER','BARRY','BARRYT','Regional Medical Liaison II','86460');

-- Insrt Inflammation users
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'ACOSTA','MARIA','ACOSTAM','Regional Medical Liaison I','64309');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'AGNESE','WENDY','WAGNESE','Clin Res & Ed Mgr','55681');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'ARRINGTON','LORI','LARRINGT','Regional Medical Liaison I','31145');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'BARR','MARIA','MBARR','Regional Medical Liaison II','34763');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'BARTON','JOHN','CBARTON','Regional Medical Liaison I','50999');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'BUTTS','JOHN','BUTTSJ','Regional Medical Liaison I','64390');

insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'CHATAS','CHRISTINE','CHATASC','Assoc Dir Reg Medical Liaison','64317');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'CLARK','QUENTIN','QCLARK','DM','1962');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'COMMODORE','MONCHIERE','MMALBRUE','Regional Medical Liaison II','31769');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'DAHM','CHARLES','DAHMC','Regional Medical Liaison I','64430');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'GIBSON','DAVID','DGIBSON','Regional Medical Liaison II','85659');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'GOFNEY','LESLIE','GOFNEYL','Regional Medical Liaison I','64554');

insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'GOLDENBERG','PHILIP','PHILIPG','Amgn Connected User','60949');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'HARWOOD','PATRICIA','HARWOODP','Regional Medical Liaison I','64538');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'HEMBY','LISA','LHEMBY','Regional Medical Liaison II','30561');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'HINES','KEITH','KHINES','Regional Medical Liaison I','60684');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'HUNKELE','JENENE','JHUNKELE','Regional Medical Liaison II','31768');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'ISOPI','MARK','MISOPI','Regional Medical Liaison II','39638');

insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'JOHNSON','CARRIE','JOHNSONC','Mgr I Medical Affairs','64446');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'KAKKA','REENA','RKAKKA','Regional Medical Liaison II','41616');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'KANG-CIPOLLA','LILY','LKANG','Regional Medical Liaison II','26702');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'KOELSCH','ROBYN','RKOELSCH','Regional Medical Liaison II','31619');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'KOO','SUPIN','SKOO','Regional Medical Liaison II','16391');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'LACHINA','ILONA','ILACHI01','Regional Medical Liaison I','15956');

insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'LICOS','ANNE MARIE','LICOSA','Regional Medical Liaison I','64536');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'MALOLEY','PIERRE','PMALOLEY','Assoc Dir Reg Medical Liaison','61369');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'MARHENKE','KEVIN','MARHENKK','Regional Medical Liaison I','64336');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'MEAD','ROBERT','RMEAD','Regional Medical Liaison I','71789');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'NGUYEN','HA','NGUYENH','Regional Medical Liaison I','71979');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'OKPOSO','KOME','KOKPOSO','Regional Medical Liaison II','30293');

insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'ORTMEIER','BRIAN','ORTMEIEB','Regional Medical Liaison-MCO','64440');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'PAULEY','TIMOTHY','TPAULEY','Regional Medical Liaison I','83669');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'PLUGGE','MICHELLE','MPLUGGE','Regional Medical Liaison II','90491');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'POURFARZIB','RAMIN','RAMINP','Assoc Dir Reg Medical Liaison','55882');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'RAAP','JONATHON','JRAAP','Regional Medical Liaison II','40570');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'ROBERTS','SARAH','SEROBERT','Regional Medical Liaison 
II','35279');

insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'SALINAS','MARISA','MSALINAS','Regional Medical Liaison I','56454');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'SIMMONS','ROY','SIMMONSR','Regional Medical Liaison II','24712');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'UNDERWOOD','JAMES','EDDIEU','Regional Medical Liaison II','65407');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'VALDES','CARLOS','CVALDES','Regional Medical Liaison I','89085');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'WIESER','KIMBERLY','KWIESER','Admin Coordinator III','26214');

--Insert Nephrology users

insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'ANDERSON','DANIEL','DANIELA','Regional Medical Liaison II','50919');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'ANDERSON','DOUGLAS','DOUGLASA','Assoc Dir Medical Affairs','50061');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'AVILES','ACELA','ACELAA','Regional Medical Liaison II','75259');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'BELLARD','TAMOKA','TBELLARD','Regional Medical Liaison I','34989');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'CAMPBELL','KATHERINE','KMCAMPBE','Regional Medical Liaison II','32894');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'CAVALIERE','KRISTI','KRISTIB','Regional Medical Liaison I','69682');

insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'DRAGO','REBECCA','RDRAGO','Project Analyst','67126');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'ELWELL','ROWLAND','RELWELL','Regional Medical Liaison I','34990');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'ENRIQUEZ','NORMAN','NORMANE','Regional Medical Liaison II','76690');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'FERRIMAN','DOUGLAS','FERRIMAN','Regional Medical Liaison II','32267');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'GIANNINI','RONALD','RGIANNIN','Regional Medical Liaison II','32107');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'HENDERSON','TARROW','TARROWH','Regional Medical Liaison I','58270');

insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'HURLEY JR.','PHILLIP','PHILLIPH','Regional Medical Liaison II','30656');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'IYDROOSE','MOHAMED','MOHAMEDI','Regional Medical Liaison II','33563');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'KASE','BONNIE','BKASE','Regional Medical Liaison II','78078');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'KAYE','LILY','LKAYE','Regional Medical Liaison II','61791');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'KIEBLER','BETH','BKIEBLER','Regional Medical Liaison II','52845');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'LEVY','MARGARET','LEVY','Regional Medical Liaison I','63941');

insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'LEWIS','MATTHEW','MALEWIS','Regional Medical Liaison II','75260');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'LYCETT','DEBRA','DLYCETT','Regional Medical Liaison II','80233');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'MEHTA','SUNIL','SUNILM','Regional Medical Liaison II','32265');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'MEMMOTT','HEIDI','HMEMMOTT','Regional Medical Liaison II','51774');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'PAGANO','THOMAS','TPAGANO','Regional Medical Liaison II','78079');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'PEARSON','PAULA','PEARSONP','Regional Medical Liaison II','52989');

insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'PELLEGRINO','TRACY','TPELLEGR','Regional Medical Liaison II','28437');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'RADKOWSKI','JAMES','JRADKOWS','Regional Medical Liaison II','80870');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'RIM','JINA','JRIM',' ','70357');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'SNOOK','JENNIFER','JSNOOK','Regional Medical Liaison II','78077');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'SOLOMON','BRIDGET','BSOLOMON','Regional Medical Liaison II','61928');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'SWANK','RICHARD','SWANKIII','Regional Medical Liaison II','76966');

insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'TEJEDA','JENNIFER','TEJEDAJ','Admin Coordinator III','64255');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'WACHSMAN','BRUCE','BRUCEW','Regional Medical Liaison I','63942');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'WASHINGTON','RAQUEL','RWASHING','Regional Medical Liaison II','48967');

-- Insert oncology users
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'ABBOTT','BEVERLY','BABBOTT','Regional Medical Liaison I','56215');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'AN','ARIANE','AAN','Regional Medical Liaison I','55682');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'ANDES','EUGENE','GANDES','Senior Manager, Medical Communications','55705');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'BABER','MICHELE','BABERM','Regional Medical Liaison I','64332');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'BADAWI','OSAMA','OBADAWI','Regional Medical Liaison II','67318');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'BAGLIO','MICHAEL','MBAGLIO','Regional Medical Liaison I','67767');

insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'BARRANS','STEFANIE','SBARRANS','Regional Medical Liaison II','33605');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'BOARD','SUSAN','SBOARD','Regional Medical Liaison I','55685');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'BOGDAN','DIANNE','DBOGDAN','Regional Medical Liaison II','18077');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'BRATTON','TAMMY','BRATTONT','Mgr I Medical Affairs','63272');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'BURCH','JONATHON','JBURCH','Regional Medical Liaison I','56613');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'CAMPBELL','KIMBERLEY','CAMPBELK','Regional Medical Liaison I','67658');

insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'CHAMBERS','LORENA','LOCHAMBE','Regional Medical Liaison II','44870');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'CHIN','JULIE','WANGCHIN','Regional Medical Liaison II','40571');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'CLINE','VANCE','VCLINE','Regional Medical Liaison I','18126');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'COPELAND','KELLY','COPELAND','Regional Medical Liaison I','64304');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'COUGHLIN','SUSAN','COUGHLIN','Assoc Dir Medical Affairs','29836');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'CROM','WILLIAM','WCROM','Regional Medical Liaison II','52951');

insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'DE LA CRUZ','JENNIFER','JENNYD','Planning & Ops Sr Anlst','70944');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'DO','TAMARA','TAMARAD','Regional Medical Liaison I','63350');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'DOAK','KAREN','KDOAK','Regional Medical Liaison II','26885');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'FAUST','ELIZABETH','EFAUST','Dir Reg Medical Liaison','8812');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'FIER','CAROL','CAROLF','Mgr II Medical Affairs','1266');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'FUJIOKA','MICHELE','MFUJIOKA','Regional Medical Liaison I','55689');

insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'GURITZ','GARY','GGURITZ','Regional Medical Liaison I','66865');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'JIMENEZ','MAYRA','MAYRAJ','Regional Medical Liaison I','71040');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'LAWLESS','LINDA','LLAWLESS','Regional Medical Liaison II','78176');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'LAWRENCE','JOHN','LAWRENCJ','Regional Medical Liaison I','61759');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'LAYON','MICHAEL','MLAYON','Regional Medical Liaison I','27797');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'LECH','JACEK','JLECH','Regional Medical Liaison II','46576');

insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'LECHPAMMER','STANISLAV','SLECHPAM','Regional Medical Liaison II','32635');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'LUI','BEVERLY','BLUI','Regional Medical Liaison II','15847');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'MCALLISTER','SCOTT','STMCALLI','Regional Medical Liaison II','26146');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'MCFARLAND','HELEN','HMCFARLA','Regional Medical Liaison II','45365');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'MCPHERSON','MICHAEL','MMCPHERS','Regional Medical Liaison II','29529');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'MEHTA','SANDIP','SMEHTA','Regional Medical Liaison I','55698');

insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'MULZAC','DIANNA','DMULZAC','Regional Medical Liaison I','70425');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'NEJFELT','CHRISTINE','CNEJFELT','Regional Medical Liaison I','67209');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'OBURML','TRAINING','OBURML1','Amgn Test User',' ');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'PARTYKA','JAMES','JPARTYKA','Regional Medical Liaison I','67857');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'PETRALIA','SANDRA','PETRALIA','Regional Medical Liaison II','17928');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'PHILLIPS','RODERICK','RJPHILLI','Regional Medical Liaison I','70897');

insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'POWELL','TREY','TPOWELL','Regional Medical Liaison I','67210');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'PREMO','KIMBERLY','KPREMO','Regional Medical Liaison I','67766');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'PRICE','RICHARD','PRICER','Regional Medical Liaison II','80395');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'RENN','ELIZABETH','ERENN','Regional Medical Liaison I','67654');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'REUSCHER','RISA','RISAR','Regional Medical Liaison I','66651');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'RODRIGUEZ','MICHAEL','MIRODRIG','Regional Medical Liaison I','58479');

insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'ROSTAMIAN','MARIANA','MARIANAR','Regional Medical Liaison II','54821');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'ROWENHORST','LISA','LROWENHO','Regional Medical Liaison I','66888');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'SMITH','LISA','LISMITH','Admin Coordinator III','66209');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'SOEFJE','SCOTT','SSOEFJ01','Regional Medical Liaison I','85660');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'STANFORD','BRAD','BRADS','Regional Medical Liaison II','46861');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'TAN','MARIANNE','MTAN','Regional Medical Liaison I','15955');

insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'THORESON','MOLLY','MOLLYT','Regional Medical Liaison I','63352');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'TURNAK','MARK','MTURNAK','Regional Medical Liaison I','66881');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'VITALE','ANTHONY','AVITALE',' ','65266');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'WAGLEY','HARVEY','HWAGLEY','Regional Medical Liaison I','78177');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'WERKING','SANDRA','SWERKING','Regional Medical Liaison II','45043');
insert into user_table(ID,LASTNAME,FIRSTNAME,USERNAME,TITLE,STAFFID) values( (SELECT NVL(MAX(ID),0)+1 FROM USER_TABLE),'ZILISCH','JANICE','JZILISCH','Regional Medical Liaison II','50124');

--- insert users into RML_HF group
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_HF' ), (select id from user_table where username='sunghuic'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_HF' ), (select id from user_table where username='adesai'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_HF' ), (select id from user_table where username='terryf'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_HF' ), (select id from user_table where username='bgladeen'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_HF' ), (select id from user_table where username='jonese'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_HF' ), (select id from user_table where username='athan'));

---insert users in to MBT group
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='sireesh'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='daurora'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='kbaldwin'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='jbass'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='jbohn'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='adamb'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='testus'));

insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='dedrae'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='Jfarrar'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='dhails'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='mhamann'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='larkinsk'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='jleff'));

insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='vloh'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='hmayer'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='kmckeirn'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='pminne'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='amorelli'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='mosdellk'));

insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='anorbash'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='nullm'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='kpollard'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='alross'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='jsanmart'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='ascheife'));

insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='andsmith'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='rstad'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='msteidle'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='rwagman'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='jwilkins'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_MBT' ), (select id from user_table where username='homay'));


--- insert users in to Hope group
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_HOPE' ), (select id from user_table where username='TICLARK'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_HOPE' ), (select id from user_table where username='BCLAY'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_HOPE' ), (select id from user_table where username='DHURLEY'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_HOPE' ), (select id from user_table where username='LYONSA'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_HOPE' ), (select id from user_table where username='MMASAMIT'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_HOPE' ), (select id from user_table where username='RPANNONE'));

insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_HOPE' ), (select id from user_table where username='DIPARKER'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_HOPE' ), (select id from user_table where username='HOA'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_HOPE' ), (select id from user_table where username='SRYU'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_HOPE' ), (select id from user_table where username='STOLSHEK'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_HOPE' ), (select id from user_table where username='JESSYT'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_HOPE' ), (select id from user_table where username='BARRYT'));


--- insert users into inflammation group
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='ACOSTAM'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='WAGNESE'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='LARRINGT'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='MBARR'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='CBARTON'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='BUTTSJ'));

insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='CHATASC'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='QCLARK'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='MMALBRUE'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='DAHMC'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='DGIBSON'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='GOFNEYL'));

insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='PHILIPG'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='HARWOODP'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='LHEMBY'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='KHINES'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='JHUNKELE'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='MISOPI'));

insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='JOHNSONC'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='RKAKKA'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='LKANG'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='RKOELSCH'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='SKOO'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='ILACHI01'));

insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='LICOSA'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='PMALOLEY'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='MARHENKK'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='RMEAD'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='NGUYENH'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='KOKPOSO'));

insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='ORTMEIEB'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='TPAULEY'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='MPLUGGE'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='RAMINP'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='JRAAP'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='SEROBERT'));

insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='MSALINAS'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='SIMMONSR'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='EDDIEU'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='CVALDES'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_INF' ), (select id from user_table where username='KWIESER'));

---insert users into nephrology group
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='DANIELA'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='DOUGLASA'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='ACELAA'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='TBELLARD'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='KMCAMPBE'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='KRISTIB'));

insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='RDRAGO'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='RELWELL'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='NORMANE'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='FERRIMAN'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='RGIANNIN'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='TARROWH'));

insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='PHILLIPH'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='MOHAMEDI'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='BKASE'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='LKAYE'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='BKIEBLER'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='LEVY'));

insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='MALEWIS'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='DLYCETT'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='SUNILM'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='HMEMMOTT'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='TPAGANO'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='PEARSONP'));

insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='TPELLEGR'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='JRADKOWS'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='JRIM'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='JSNOOK'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='BSOLOMON'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='SWANKIII'));

insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='TEJEDAJ'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='BRUCEW'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_NEP' ), (select id from user_table where username='RWASHING'));



---insert users into oncology group

insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='BABBOTT'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='AAN'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='GANDES'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='BABERM'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='OBADAWI'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='MBAGLIO'));

insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='SBARRANS'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='SBOARD'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='DBOGDAN'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='BRATTONT'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='JBURCH'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='CAMPBELK'));

insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='LOCHAMBE'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='WANGCHIN'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='VCLINE'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='COPELAND'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='COUGHLIN'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='WCROM'));

insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='JENNYD'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='TAMARAD'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='KDOAK'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='EFAUST'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='CAROLF'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='MFUJIOKA'));

insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='GGURITZ'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='MAYRAJ'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='LLAWLESS'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='LAWRENCJ'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='MLAYON'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='JLECH'));

insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='SLECHPAM'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='BLUI'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='STMCALLI'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='HMCFARLA'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='MMCPHERS'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='SMEHTA'));

insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='DMULZAC'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='CNEJFELT'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='OBURML1'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='JPARTYKA'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='PETRALIA'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='RJPHILLI'));

insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='TPOWELL'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='KPREMO'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='PRICER'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='ERENN'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='RISAR'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='MIRODRIG'));

insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='MARIANAR'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='LROWENHO'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='LISMITH'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='SSOEFJ01'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='BRADS'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='MTAN'));

insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='MOLLYT'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='MTURNAK'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='AVITALE'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='HWAGLEY'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='SWERKING'));
insert into user_group_map values( (SELECT NVL(MAX(ID),0)+1 FROM user_group_map) ,(select groupid from groups where groupname='RML_ONC' ), (select id from user_table where username='JZILISCH'));


-------------------------------------insert address entry for all the user --------------------------------------------------------

---insert address in to HF group users
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='sunghuic'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='adesai'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='terryf'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='bgladeen'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='jonese'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='athan'));

---insert address in to MBT group users
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='sireesh'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='daurora'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='kbaldwin'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='jbass'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='jbohn'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='adamb'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='testus'));

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='dedrae'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='Jfarrar'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='dhails'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='mhamann'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='larkinsk'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='jleff'));

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='vloh'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='hmayer'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='kmckeirn'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='pminne'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='amorelli'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='mosdellk'));

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='anorbash'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='nullm'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='kpollard'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='alross'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='jsanmart'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='ascheife'));

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='andsmith'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='rstad'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='msteidle'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='rwagman'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='jwilkins'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='homay'));


--- insert address in to Hope group users

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='TICLARK'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='BCLAY'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='DHURLEY'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='LYONSA'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='MMASAMIT'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='RPANNONE'));

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='DIPARKER'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='HOA'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='SRYU'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='STOLSHEK'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='JESSYT'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='BARRYT'));


--- insert address into inflammation group users

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='ACOSTAM'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='WAGNESE'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='LARRINGT'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='MBARR'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='CBARTON'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='BUTTSJ'));

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='CHATASC'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='QCLARK'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='MMALBRUE'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='DAHMC'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='DGIBSON'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='GOFNEYL'));

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='PHILIPG'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='HARWOODP'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='LHEMBY'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='KHINES'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='JHUNKELE'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='MISOPI'));

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='JOHNSONC'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='RKAKKA'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='LKANG'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='RKOELSCH'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='SKOO'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='ILACHI01'));

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='LICOSA'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='PMALOLEY'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='MARHENKK'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='RMEAD'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='NGUYENH'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='KOKPOSO'));

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='ORTMEIEB'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='TPAULEY'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='MPLUGGE'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='RAMINP'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='JRAAP'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='SEROBERT'));

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='MSALINAS'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='SIMMONSR'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='EDDIEU'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='CVALDES'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='KWIESER'));

---insert address into nephrology group users

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='DANIELA'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='DOUGLASA'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='ACELAA'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='TBELLARD'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='KMCAMPBE'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='KRISTIB'));

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='RDRAGO'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='RELWELL'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='NORMANE'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='FERRIMAN'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='RGIANNIN'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='TARROWH'));

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='PHILLIPH'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='MOHAMEDI'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='BKASE'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='LKAYE'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='BKIEBLER'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='LEVY'));

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='MALEWIS'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='DLYCETT'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='SUNILM'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='HMEMMOTT'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='TPAGANO'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='PEARSONP'));

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='TPELLEGR'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='JRADKOWS'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='JRIM'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='JSNOOK'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='BSOLOMON'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='SWANKIII'));

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='TEJEDAJ'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='BRUCEW'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='RWASHING'));



---insert address into oncology group users

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='BABBOTT'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='AAN'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='GANDES'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='BABERM'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='OBADAWI'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='MBAGLIO'));

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='SBARRANS'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='SBOARD'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='DBOGDAN'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='BRATTONT'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='JBURCH'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='CAMPBELK'));

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='LOCHAMBE'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='WANGCHIN'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='VCLINE'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='COPELAND'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='COUGHLIN'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='WCROM'));

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='JENNYD'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='TAMARAD'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='KDOAK'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='EFAUST'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='CAROLF'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='MFUJIOKA'));

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='GGURITZ'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='MAYRAJ'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='LLAWLESS'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='LAWRENCJ'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='MLAYON'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='JLECH'));

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='SLECHPAM'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='BLUI'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='STMCALLI'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='HMCFARLA'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='MMCPHERS'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='SMEHTA'));

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='DMULZAC'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='CNEJFELT'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='OBURML1'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='JPARTYKA'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='PETRALIA'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='RJPHILLI'));

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='TPOWELL'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='KPREMO'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='PRICER'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='ERENN'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='RISAR'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='MIRODRIG'));

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='MARIANAR'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='LROWENHO'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='LISMITH'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='SSOEFJ01'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='BRADS'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='MTAN'));

insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='MOLLYT'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='MTURNAK'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='AVITALE'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='HWAGLEY'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='SWERKING'));
insert into user_address(id,userid) values( (SELECT NVL(MAX(ID),0)+1 FROM user_address),  (select id from user_table where username='JZILISCH'));




------------------- UPDATE ADDRESS ID INTO USER_TABLE ------------------------------------------------------------------------------------------


---insert address id in to HF group users
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='sunghuic')) where username='sunghuic';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='adesai')) where username='adesai';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='terryf')) where username='terryf';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='bgladeen')) where username='bgladeen';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='jonese')) where username='jonese';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='athan')) where username='athan';

---insert address id in to MBT group users
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='sireesh')) where username='sireesh';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='daurora')) where username='daurora';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='kbaldwin')) where username='kbaldwin';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='jbass')) where username='jbass';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='jbohn')) where username='jbohn';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='adamb')) where username='adamb';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='testus')) where username='testus';

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='dedrae')) where username='dedrae';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='Jfarrar')) where username='Jfarrar';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='dhails')) where username='dhails';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='mhamann')) where username='mhamann';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='larkinsk')) where username='larkinsk';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='larkinsk')) where username='larkinsk';

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='vloh')) where username='vloh';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='hmayer')) where username='hmayer';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='kmckeirn')) where username='kmckeirn';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='pminne')) where username='pminne';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='amorelli')) where username='amorelli';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='mosdellk')) where username='mosdellk';

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='anorbash')) where username='anorbash';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='nullm')) where username='nullm';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='kpollard')) where username='kpollard';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='alross')) where username='alross';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='jsanmart')) where username='jsanmart';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='ascheife')) where username='ascheife';

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='andsmith')) where username='andsmith';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='rstad')) where username='rstad';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='msteidle')) where username='msteidle';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='rwagman')) where username='rwagman';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='jwilkins')) where username='jwilkins';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='homay')) where username='homay';

--- insert address id in to Hope group users

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='TICLARK')) where username='TICLARK';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='BCLAY')) where username='BCLAY';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='DHURLEY')) where username='DHURLEY';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='LYONSA')) where username='LYONSA';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='MMASAMIT')) where username='MMASAMIT';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='RPANNONE')) where username='RPANNONE';


update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='DIPARKER')) where username='DIPARKER';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='HOA')) where username='HOA';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='SRYU')) where username='SRYU';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='STOLSHEK')) where username='STOLSHEK';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='JESSYT')) where username='JESSYT';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='BARRYT')) where username='BARRYT';

--- insert  address id in into inflammation group users

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='ACOSTAM')) where username='ACOSTAM';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='WAGNESE')) where username='WAGNESE';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='LARRINGT')) where username='LARRINGT';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='MBARR')) where username='MBARR';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='CBARTON')) where username='CBARTON';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='BUTTSJ')) where username='BUTTSJ';


update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='CHATASC')) where username='CHATASC';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='QCLARK')) where username='QCLARK';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='MMALBRUE')) where username='MMALBRUE';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='DAHMC')) where username='DAHMC';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='DGIBSON')) where username='DGIBSON';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='GOFNEYL')) where username='GOFNEYL';


update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='PHILIPG')) where username='PHILIPG';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='HARWOODP')) where username='HARWOODP';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='LHEMBY')) where username='LHEMBY';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='KHINES')) where username='KHINES';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='JHUNKELE')) where username='JHUNKELE';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='MISOPI')) where username='MISOPI';

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='JOHNSONC')) where username='JOHNSONC';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='RKAKKA')) where username='RKAKKA';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='LKANG')) where username='LKANG';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='RKOELSCH')) where username='RKOELSCH';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='SKOO')) where username='SKOO';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='ILACHI01')) where username='ILACHI01';

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='LICOSA')) where username='LICOSA';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='PMALOLEY')) where username='PMALOLEY';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='MARHENKK')) where username='MARHENKK';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='RMEAD')) where username='RMEAD';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='NGUYENH')) where username='NGUYENH';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='KOKPOSO')) where username='KOKPOSO';

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='ORTMEIEB')) where username='ORTMEIEB';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='TPAULEY')) where username='TPAULEY';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='MPLUGGE')) where username='MPLUGGE';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='RAMINP')) where username='RAMINP';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='JRAAP')) where username='JRAAP';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='SEROBERT')) where username='SEROBERT';

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='MSALINAS')) where username='MSALINAS';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='SIMMONSR')) where username='SIMMONSR';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='EDDIEU')) where username='EDDIEU';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='CVALDES')) where username='CVALDES';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='KWIESER')) where username='KWIESER';



---insert  address id into nephrology group users

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='DANIELA')) where username='DANIELA';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='DOUGLASA')) where username='DOUGLASA';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='ACELAA')) where username='ACELAA';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='TBELLARD')) where username='TBELLARD';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='KMCAMPBE')) where username='KMCAMPBE';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='KRISTIB')) where username='KRISTIB';

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='RDRAGO')) where username='RDRAGO';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='RELWELL')) where username='RELWELL';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='NORMANE')) where username='NORMANE';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='FERRIMAN')) where username='FERRIMAN';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='RGIANNIN')) where username='RGIANNIN';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='TARROWH')) where username='TARROWH';

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='PHILLIPH')) where username='PHILLIPH';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='MOHAMEDI')) where username='MOHAMEDI';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='BKASE')) where username='BKASE';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='LKAYE')) where username='LKAYE';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='BKIEBLER')) where username='BKIEBLER';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='LEVY')) where username='LEVY';

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='MALEWIS')) where username='MALEWIS';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='DLYCETT')) where username='DLYCETT';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='SUNILM')) where username='SUNILM';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='HMEMMOTT')) where username='HMEMMOTT';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='TPAGANO')) where username='TPAGANO';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='PEARSONP')) where username='PEARSONP';

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='TPELLEGR')) where username='TPELLEGR';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='JRADKOWS')) where username='JRADKOWS';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='JRIM')) where username='JRIM';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='JSNOOK')) where username='JSNOOK';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='BSOLOMON')) where username='BSOLOMON';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='SWANKIII')) where username='SWANKIII';


update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='TEJEDAJ')) where username='TEJEDAJ';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='BRUCEW')) where username='BRUCEW';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='RWASHING')) where username='RWASHING';


---insert  address id into oncology group users

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='BABBOTT')) where username='BABBOTT';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='AAN')) where username='AAN';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='GANDES')) where username='GANDES';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='BABERM')) where username='BABERM';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='OBADAWI')) where username='OBADAWI';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='MBAGLIO')) where username='MBAGLIO';

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='SBARRANS')) where username='SBARRANS';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='SBOARD')) where username='SBOARD';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='DBOGDAN')) where username='DBOGDAN';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='BRATTONT')) where username='BRATTONT';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='JBURCH')) where username='JBURCH';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='CAMPBELK')) where username='CAMPBELK';

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='LOCHAMBE')) where username='LOCHAMBE';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='WANGCHIN')) where username='WANGCHIN';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='VCLINE')) where username='VCLINE';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='COPELAND')) where username='COPELAND';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='COUGHLIN')) where username='COUGHLIN';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='WCROM')) where username='WCROM';

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='JENNYD')) where username='JENNYD';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='TAMARAD')) where username='TAMARAD';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='KDOAK')) where username='KDOAK';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='EFAUST')) where username='EFAUST';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='CAROLF')) where username='CAROLF';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='MFUJIOKA')) where username='MFUJIOKA';

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='GGURITZ')) where username='GGURITZ';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='MAYRAJ')) where username='MAYRAJ';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='LLAWLESS')) where username='LLAWLESS';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='LAWRENCJ')) where username='LAWRENCJ';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='MLAYON')) where username='MLAYON';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='JLECH')) where username='JLECH';

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='SLECHPAM')) where username='SLECHPAM';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='BLUI')) where username='BLUI';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='STMCALLI')) where username='STMCALLI';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='HMCFARLA')) where username='HMCFARLA';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='MMCPHERS')) where username='MMCPHERS';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='SMEHTA')) where username='SMEHTA';

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='DMULZAC')) where username='DMULZAC';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='CNEJFELT')) where username='CNEJFELT';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='OBURML1')) where username='OBURML1';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='JPARTYKA')) where username='JPARTYKA';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='PETRALIA')) where username='PETRALIA';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='RJPHILLI')) where username='RJPHILLI';

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='TPOWELL')) where username='TPOWELL';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='KPREMO')) where username='KPREMO';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='PRICER')) where username='PRICER';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='ERENN')) where username='ERENN';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='RISAR')) where username='RISAR';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='MIRODRIG')) where username='MIRODRIG';

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='MARIANAR')) where username='MARIANAR';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='LROWENHO')) where username='LROWENHO';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='LISMITH')) where username='LISMITH';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='SSOEFJ01')) where username='SSOEFJ01';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='BRADS')) where username='BRADS';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='MTAN')) where username='MTAN';

update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='MOLLYT')) where username='MOLLYT';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='MTURNAK')) where username='MTURNAK';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='AVITALE')) where username='AVITALE';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='HWAGLEY')) where username='HWAGLEY';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='SWERKING')) where username='SWERKING';
update user_table set address_id=(select id from user_address where userid =(select id from user_table where username='JZILISCH')) where username='JZILISCH';

--update all the users 

update user_table set user_type_id=2,influencelevel=0,latitude=0,longitude=0,kolid=0,prefix=618,suffix=622,email='test@test.com', password='test' ,deleteflag='N' where influencelevel is null;

-- update all user_address

update user_address set address1='test',city='test',state_lookup_id=11,country_lookup_id=278,zip='test',fullprofile=0 where fullprofile is null;


commit;
