Insert into "SURVEYMETADATA" ("ID","NAME","TYPE","STATE","ACTIVE","DATE_START","DATE_END") values (HIBERNATE_SEQUENCE.NEXTVAL,'Customer Insights Program','DCI','Launched','true','02/09/2009','02/09/2010');

commit;

insert into answer_options_temp values ('Continue to dose escalate to imatinib 600 mg',1);
insert into answer_options_temp values ('Continue to dose escalate to imatinib 800 mg',2);
insert into answer_options_temp values ('Change to Dasatinib',3);
insert into answer_options_temp values ('Change to Nilotinib',4);
insert into answer_options_temp values ('Other',5);


commit;


execute CREATE_SURVEY_QA(' Does 017 data change the way you will treat your patients with resistance to Imatinib 400 mg?  (If Other, please answer 2)','multioptmultisel','Customer Insights Program','true','1');

commit;

delete from answer_options_temp;

commit;

execute CREATE_SURVEY_QA(' Other changes in the way you will treat your patients with resistance to Imatinib 400 mg?','simpleText','Customer Insights Program','false','2'); 

commit;

insert into answer_options_temp values ('Continue to dose escalate to imatinib 800 mg',1);
insert into answer_options_temp values ('Change to Dasatinib',2);
insert into answer_options_temp values ('Change to Nilotinib',3);
insert into answer_options_temp values ('Other',4);


commit;

execute CREATE_SURVEY_QA(' Does 017 data change the way you will treat your patients with resistance to Imatinib 600 mg? (If Other, please answer 4)','multioptmultisel','Customer Insights Program','true','3');

commit;

delete from answer_options_temp;

commit;

execute CREATE_SURVEY_QA(' Other changes in the way you will treat your patients with resistance to Imatinib 600 mg?','simpleText','Customer Insights Program','false','4'); 

commit;


rem-----------------------------------------


insert into answer_options_temp values ('Longer follow up',1);
insert into answer_options_temp values ('Molecular Response Data',2);
insert into answer_options_temp values ('PFS/OS',3);
insert into answer_options_temp values ('Durability of responses',4);
insert into answer_options_temp values ('Other',5);


commit;

execute CREATE_SURVEY_QA('  Is there additional data that you require before considering a switch to another TKI versus escalating the imatinib dose?(If Other, please answer 6)','multioptmultisel','Customer Insights Program','true','5');

commit;

delete from answer_options_temp;

commit;

execute CREATE_SURVEY_QA(' Other Addditional data that you require before considering a switch to another TKI versus escalating the imatinib dose?','simpleText','Customer Insights Program','false','6'); 

commit;

rem-------------------------------------------------------

insert into answer_options_temp values ('Efficacy (response rates)',1);
insert into answer_options_temp values ('Tolerability',2);
insert into answer_options_temp values ('Survival data (PFS, OS)',3);
insert into answer_options_temp values ('Other',4);


commit;

execute CREATE_SURVEY_QA('  What will be most important to you when choosing between dasatinib and nilotinib?(If Other, please answer 8)','multioptmultisel','Customer Insights Program','true','7');

commit;

delete from answer_options_temp;

commit;

execute CREATE_SURVEY_QA(' Other important factors you when choosing between dasatinib and nilotinib?','simpleText','Customer Insights Program','false','8'); 

commit;


rem-------------------------------------------------------

insert into answer_options_temp values ('Yes: Cytopenias',1);
insert into answer_options_temp values ('Yes: Pleural Effusions',2);
insert into answer_options_temp values ('Yes: GI Bleed',3);
insert into answer_options_temp values ('Yes: Liver Toxicity',4);
insert into answer_options_temp values ('Yes: Pancreatic Toxicity',5);
insert into answer_options_temp values ('Yes: Peripheral Edema',6);
insert into answer_options_temp values ('No concerns',7);
insert into answer_options_temp values ('Other',8);


commit;

execute CREATE_SURVEY_QA('  Do you have concerns about the safety of Dasatinib with the new 100mg QD dosing (If Other, please answer 10)?','multioptmultisel','Customer Insights Program','true','9');

commit;

delete from answer_options_temp;

commit;

execute CREATE_SURVEY_QA(' Other concerns about the safety of Dasatinib with the new 100mg QD dosing?','simpleText','Customer Insights Program','false','10'); 

commit;
