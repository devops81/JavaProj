rem ------------------------------------------------------------------------------------------------

SET TIME ON
SET ESCAPE \
SET PAGESIZE 50000

SET ECHO ON

rem ------------------------------------------------------------------------------------------------

Insert into "SURVEYMETADATA" ("ID","NAME","TYPE","STATE","ACTIVE","DATE_START","DATE_END") values (HIBERNATE_SEQUENCE.NEXTVAL,'Reyataz DCI','DCI','Launched','true','02/09/2009','02/09/2010');

commit;

insert into answer_options_temp values ('Will not impact at this time, need more longer term data',1);
insert into answer_options_temp values ('Will start to impact when ATV is utilized-may result in ATV being used after 1st or 2nd tx-failure',2);
insert into answer_options_temp values ('Other',3);

commit;

execute CREATE_SURVEY_QA('  In your opinion, how will the data on newer ARVs and novel treatment strategies, impact physician use of Atazanavir in clinical practice?','multioptsinglesel','Reyataz DCI','false','1');

commit;

delete from answer_options_temp;

commit;

execute CREATE_SURVEY_QA('  If you answered other to the question above, please comment','simpleText','Reyataz DCI','false','2');

commit;

delete from answer_options_temp;

commit;

insert into answer_options_temp values ('Treatment-naïve',1);
insert into answer_options_temp values ('Treatment-naïve, who cannot tolerate EFV or for whom EFV is not a good option (female CBP)',2);
insert into answer_options_temp values ('1st PI, post NNRTI or Integrase Inhibitor failure',3);

commit;

execute CREATE_SURVEY_QA('   Is there a specific group of pts for whom you would choose to use ATV/r vs other ARVs?','multioptsinglesel','Reyataz DCI','false','3');

commit;


delete from answer_options_temp;

commit;

----------------------------------------

insert into answer_options_temp values ('Yes, however, I prefer to use a PI that does not have dosing issues with PPIs in patients requiring acid reducing agents',1);
insert into answer_options_temp values ('Yes, however,  I dose ATV \& H2s blockers according to the recommendation, but am not comfortable dosing PPIs \& ATV together',2);
insert into answer_options_temp values ('Yes, I dose ATV \& PPIs or H2s blockers according to the recommendation',3);
insert into answer_options_temp values ('Yes, however I would like further clarification on the specific recommendations',4);
insert into answer_options_temp values ('Yes, but I have concerns with patients ability to be compliant to the dosing recommendation, so I don''t use ATV in this situation',5);
insert into answer_options_temp values ('No',6);

commit;

execute CREATE_SURVEY_QA(' Are you aware of the latest dosing recommendation for ATV with H2 blockers \& PPIs? ','multioptsinglesel','Reyataz DCI','true','4');

commit;

delete from answer_options_temp;

commit;



-------------------------------------------


insert into answer_options_temp values ('Drug interaction w/ acid reducing agent',1);
insert into answer_options_temp values ('Risk of hyperbilirubinemia',2);
insert into answer_options_temp values ('Extra co-pay for RTV',3);
insert into answer_options_temp values ('Other',4);


commit;

execute CREATE_SURVEY_QA('  What is the primary reason you would not use ATV as your first PI?','multioptmultisel','Reyataz DCI','false','5');

commit;

delete from answer_options_temp;

commit;

insert into answer_options_temp values ('Yes',1);
insert into answer_options_temp values ('No',2);


commit;

execute CREATE_SURVEY_QA('  If you answered other to the question above, please comment','simpleText','Reyataz DCI','false','6');

commit;

delete from answer_options_temp;

commit;

insert into answer_options_temp values ('Yes - concern around hyperbilirubinemia based on lower BMI',1);
insert into answer_options_temp values ('Yes - lack of safety data related to 1st trimester exposure to ATV',2);
insert into answer_options_temp values ('Yes - other',3);
insert into answer_options_temp values ('No concerns',4);


commit;

execute CREATE_SURVEY_QA('  In your opinion, are there any concerns or limitations around the use of ATV in women? If yes, what would those be?','multioptmultisel','Reyataz DCI','false','7');

commit;

delete from answer_options_temp;

commit;

execute CREATE_SURVEY_QA('  If you answered ''''yes - other'''' to the question above, please comment','simpleText','Reyataz DCI','false','8');

commit;

insert into answer_options_temp values ('How ARV is positioned in the guidelines',1);
insert into answer_options_temp values ('Pregnancy Category',2);
insert into answer_options_temp values ('Safety during pregnancy well documented in clinical trials, esp hyperbili',3);
insert into answer_options_temp values ('Interaction w/ contraceptives well described (depo / OC / ring)',4);
insert into answer_options_temp values ('Other',5);

commit;

execute CREATE_SURVEY_QA('  When creating an ARV regimen for women of child-bearing age, what factors influence your choice of ARVs?','multioptmultisel','Reyataz DCI','false','9');

commit;

delete from answer_options_temp;

commit;

execute CREATE_SURVEY_QA(' If you answered other to the question above, please comment','simpleText','Reyataz DCI','false','10'); 

commit;


insert into answer_options_temp values ('I switch to ATV if there is no pre-existing resistance',1);
insert into answer_options_temp values ('If virologically suppressed, I prefer to add a lipid-lowering agent ',2);
insert into answer_options_temp values ('Start with ATV/r already, removing RTV if well controlled '||chr(38)||' not on TVD',3);
insert into answer_options_temp values ('Other',4);
commit;

execute CREATE_SURVEY_QA('   If your patient is experiencing hyperlipidemia on their existing regimen, what treatment approach do you utilize?','multioptmultisel','Reyataz DCI','false','11');

commit;

delete from answer_options_temp;

commit;

execute CREATE_SURVEY_QA('  If you answered other to the question above, please comment','simpleText','Reyataz DCI','false','12');

commit;



insert into answer_options_temp values ('Tier 1 = National',1);
insert into answer_options_temp values ('Tier 2 = Regional',2);
insert into answer_options_temp values ('Tier 3 = Local',3);

commit;

execute CREATE_SURVEY_QA(' What is the Tier of the person who were asked the questions?','multioptsinglesel','Reyataz DCI','false','13');

commit;

delete from answer_options_temp;

commit;

insert into answer_options_temp values ('ARPN',1);
insert into answer_options_temp values ('DO',2);
insert into answer_options_temp values ('MD',3);
insert into answer_options_temp values ('PA',4);
insert into answer_options_temp values ('Ph.D',5);
insert into answer_options_temp values ('Pharm. D.',6);
insert into answer_options_temp values ('R.Ph.',7);
insert into answer_options_temp values ('RN',8);

commit;

execute CREATE_SURVEY_QA(' What is the credential of the responder?','multioptsinglesel','Reyataz DCI','false','14');

commit;

delete from answer_options_temp;

commit;

