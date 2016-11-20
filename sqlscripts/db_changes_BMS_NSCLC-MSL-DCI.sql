Insert into "SURVEYMETADATA" ("ID","NAME","TYPE","STATE","ACTIVE","DATE_START","DATE_END") values (HIBERNATE_SEQUENCE.NEXTVAL,'NSCLC- MSL- Deep Customer Insights','DCI','Launched','true','02/09/2009','02/09/2010');

commit;

insert into answer_options_temp values ('Chemotherapy',1);
insert into answer_options_temp values ('Chemotherapy + bevacizumab',2);
insert into answer_options_temp values ('Chemotherapy + erlotinib',3);
insert into answer_options_temp values ('bevacizumab',4);
insert into answer_options_temp values ('erlotinib',5);
insert into answer_options_temp values ('Other',6);


commit;


execute CREATE_SURVEY_QA(' What is your current treatment of choice for first line treatment of PS 0 or 1 metastatic NSCLC? (If Other, please answer 2)','multioptsinglesel','NSCLC- MSL- Deep Customer Insights','true','1');

commit;

delete from answer_options_temp;

commit;

execute CREATE_SURVEY_QA(' Other treatment of choice for first line treatment of PS 0 or 1 metastatic NSCLC?','simpleText','NSCLC- MSL- Deep Customer Insights','false','2'); 

commit;

rem --------------------------------------------



insert into answer_options_temp values ('Any platinum doublet?',1);
insert into answer_options_temp values ('Taxane + either platinum?',2);
insert into answer_options_temp values ('Taxane + carboplatin?',3);
insert into answer_options_temp values ('Gemcitabine + either platinum?',4);
insert into answer_options_temp values ('Gemcitabine + carboplatin?',5);
insert into answer_options_temp values ('Vinorelbine + either platinum?',6);
insert into answer_options_temp values ('Vinorelbine + carboplatin?',7);
insert into answer_options_temp values ('Pemetrexed + cisplatin',8);
insert into answer_options_temp values ('Other',9);


commit;


execute CREATE_SURVEY_QA(' Which platinum doublet do you prefer to use first line? (If Other, please answer 4)','multioptsinglesel','NSCLC- MSL- Deep Customer Insights','true','3');

commit;

delete from answer_options_temp;

commit;

execute CREATE_SURVEY_QA(' Other platinum doublet you prefer to use first line?','simpleText','NSCLC- MSL- Deep Customer Insights','false','4'); 

commit;


rem --------------------------------------------



insert into answer_options_temp values ('Yes',1);
insert into answer_options_temp values ('No',2);


commit;


execute CREATE_SURVEY_QA(' Do you believe there is a difference between platinum doublets? (If Yes, please answer 6)','multioptsinglesel','NSCLC- MSL- Deep Customer Insights','true','5');

commit;

delete from answer_options_temp;

commit;

execute CREATE_SURVEY_QA(' The difference between platinum doublets?','simpleText','NSCLC- MSL- Deep Customer Insights','false','6'); 

commit;

rem --------------------------------------------



insert into answer_options_temp values ('Yes',1);
insert into answer_options_temp values ('No',2);
insert into answer_options_temp values ('Comments',2);


commit;


execute CREATE_SURVEY_QA(' Do you believe when adding a biologic there is a difference in which doublet is used? (To Comment, please answer 8)','multioptsinglesel','NSCLC- MSL- Deep Customer Insights','true','7');

commit;

delete from answer_options_temp;

commit;

execute CREATE_SURVEY_QA(' Comment on the difference in which a doublet is used while adding a biologic?','simpleText','NSCLC- MSL- Deep Customer Insights','false','8'); 

commit;

rem --------------------------------------------



insert into answer_options_temp values ('Histology',1);
insert into answer_options_temp values ('Insufficient efficacy',2);
insert into answer_options_temp values ('Risk of bleeding',3);
insert into answer_options_temp values ('Brain metastasis',4);
insert into answer_options_temp values ('Performance Status',5);
insert into answer_options_temp values ('Gender',6);
insert into answer_options_temp values ('Age',7);
insert into answer_options_temp values ('Cost/Reimbursement issues',8);
insert into answer_options_temp values ('Other',9);


commit;


execute CREATE_SURVEY_QA(' For patients who do not receive bevacizumab, what influences your treatment decision? (If Other, please answer 10)','multioptmultisel','NSCLC- MSL- Deep Customer Insights','true','9');

commit;

delete from answer_options_temp;

commit;

execute CREATE_SURVEY_QA(' Other factors which influence your treatment decision for patients who do not recieve bevacizumab?','simpleText','NSCLC- MSL- Deep Customer Insights','false','10'); 

commit;

rem --------------------------------------------



insert into answer_options_temp values ('Performance Status',1);
insert into answer_options_temp values ('Histology',2);
insert into answer_options_temp values ('Convenience of administration',3);
insert into answer_options_temp values ('Gender',4);
insert into answer_options_temp values ('Age',5);
insert into answer_options_temp values ('Race',6);
insert into answer_options_temp values ('Safety',7);
insert into answer_options_temp values ('Efficacy',8);
insert into answer_options_temp values ('Other',9);


commit;


execute CREATE_SURVEY_QA(' For front line patients who you treat with erlotinib which criteria do you use to make this treatment choice? (If Other, please answer 12)','multioptmultisel','NSCLC- MSL- Deep Customer Insights','true','11');

commit;

delete from answer_options_temp;

commit;

execute CREATE_SURVEY_QA(' Other criteria you use to make the above treatment choice?','simpleText','NSCLC- MSL- Deep Customer Insights','false','12'); 

commit;


rem --------------------------------------------



insert into answer_options_temp values ('Yes',1);
insert into answer_options_temp values ('No',2);


commit;


execute CREATE_SURVEY_QA('  Do you use Maintenance Therapy? (If Yes, please answer 14)','multioptsinglesel','NSCLC- MSL- Deep Customer Insights','true','13');

commit;

delete from answer_options_temp;

commit;

execute CREATE_SURVEY_QA(' Which agent do you use for Maintenance Therapy?','simpleText','NSCLC- MSL- Deep Customer Insights','false','14'); 

commit;

rem --------------------------------------------

execute CREATE_SURVEY_QA(' How would you define maintenance therapy?','simpleText','NSCLC- MSL- Deep Customer Insights','false','15'); 

commit;

rem --------------------------------------------

insert into answer_options_temp values ('Myelosuppression',1);
insert into answer_options_temp values ('Neurologic',2);
insert into answer_options_temp values ('Cardiac Toxicity',3);
insert into answer_options_temp values ('Bleeding',4);
insert into answer_options_temp values ('Dermatologic',5);
insert into answer_options_temp values ('Hemorrhaging',6);
insert into answer_options_temp values ('Other',10);


commit;


execute CREATE_SURVEY_QA(' Which treatment toxicities are most concerning to you? (If Other, please answer 17)','multioptsinglesel','NSCLC- MSL- Deep Customer Insights','true','16');

commit;

delete from answer_options_temp;

commit;

execute CREATE_SURVEY_QA(' Other treatment toxicities which are most concerning to you?','simpleText','NSCLC- MSL- Deep Customer Insights','false','17'); 

commit;

rem --------------------------------------------

execute CREATE_SURVEY_QA(' What is your current treatment of choice in first line treatment of PS 2 patients with metastatic NSCLC?','simpleText','NSCLC- MSL- Deep Customer Insights','false','18'); 

commit;


rem --------------------------------------------



insert into answer_options_temp values ('Yes',1);
insert into answer_options_temp values ('No',2);


commit;


execute CREATE_SURVEY_QA('   Do you currently test for biomarkers in NSCLC? (If Yes, please answer 20)','multioptsinglesel','NSCLC- MSL- Deep Customer Insights','true','19');

commit;

delete from answer_options_temp;

commit;

execute CREATE_SURVEY_QA(' If you answered Yes to question 19, please list which ones?','simpleText','NSCLC- MSL- Deep Customer Insights','false','20'); 

commit;


rem ------------------------------------------------

update surveymetadata set name='NSCLC-MSL - Deep Customer Insights' where name='NSCLC- MSL- Deep Customer Insights'

commit;

rem ----------------------------------------------