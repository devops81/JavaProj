rem -----------------------------------------------------------------------
rem Filename:   openQ-SurveyTool.sql
rem Purpose:    Database changes for survey Requirements
rem             
rem Date:       10-October-2008
rem Author:     D.Kirubakaran, Kuliza Technologies
rem -----------------------------------------------------------------------

CREATE TABLE "SURVEYMETADATA" 
   (	"ID" NUMBER NOT NULL ENABLE, 
	"NAME" VARCHAR2(4000 BYTE) NOT NULL ENABLE, 
	"TYPE" VARCHAR2(4000 BYTE) NOT NULL ENABLE, 
	"STATE" VARCHAR2(4000 BYTE) NOT NULL ENABLE, 
	"ACTIVE" VARCHAR2(4000 BYTE) NOT NULL ENABLE, 
	 CONSTRAINT "SURVEYMETADATA_PK" PRIMARY KEY ("ID") ENABLE
   ) ;

CREATE TABLE "SURVEYANSWERSDATA" 
   (	"ID" NUMBER NOT NULL ENABLE, 
	"QUESTIONID" NUMBER NOT NULL ENABLE, 
	"ANSWERTEXT" VARCHAR2(4000 BYTE), 
	 CONSTRAINT "SURVEYANSWERSDATA_PK" PRIMARY KEY ("ID") ENABLE
   ) ;

  CREATE TABLE "SURVEYQUESTIONSMETADATA" 
   (	"ID" NUMBER, 
	"SURVEYID" NUMBER, 
	"QUESTIONTEXT" VARCHAR2(4000 BYTE), 
	"TYPE" VARCHAR2(4000 BYTE), 
	"MANDATORY" VARCHAR2(4000 BYTE), 
	"QUESTIONNUMBER" VARCHAR2(4000 BYTE) DEFAULT 0, 
	 CONSTRAINT "SURVEYQUESTIONSMETADATA_PK" PRIMARY KEY ("ID") ENABLE
   ) ;


   CREATE TABLE "SURVEYSUBQUESTIONSMETADATA" 
   (	"ID" NUMBER NOT NULL ENABLE, 
	"QUESTIONID" NUMBER NOT NULL ENABLE, 
	"SUBQUESTIONTEXT" VARCHAR2(4000 BYTE), 
	 CONSTRAINT "SURVEYSUBQUESTIONSMETADAT_PK" PRIMARY KEY ("ID") ENABLE
   ) ;

CREATE TABLE "FILLED_QUESTIONS" 
   (	"ID" NUMBER NOT NULL ENABLE, 
	"PARENT_SURVEY" NUMBER NOT NULL ENABLE, 
	"QUESTIONID" NUMBER NOT NULL ENABLE, 
	"ANSWER_TEXT" VARCHAR2(4000 BYTE), 
	 CONSTRAINT "FILLED_QUESTIONS_PK" PRIMARY KEY ("ID") ENABLE
   ) ;
 
 CREATE TABLE "FILLED_SUBQUES_ANSWERS" 
   (	"ID" NUMBER NOT NULL ENABLE, 
	"PARENT_QUESTION" NUMBER NOT NULL ENABLE, 
	"SUB_QUESTION" VARCHAR2(4000 BYTE), 
	"ANSWER_OPTION" VARCHAR2(4000 BYTE), 
	 CONSTRAINT "FILLED_SUBQUES_ANSWERS_PK" PRIMARY KEY ("ID") ENABLE
   ) ;
 
 CREATE TABLE "FILLED_SURVEY" 
   (	"ID" NUMBER NOT NULL ENABLE, 
	"SURVEYID" NUMBER NOT NULL ENABLE, 
	"INTERACTIONID" NUMBER NOT NULL ENABLE, 
	"EXPERTID" NUMBER NOT NULL ENABLE, 
	 CONSTRAINT "FILLED_SURVEY_PK" PRIMARY KEY ("ID") ENABLE
   ) ;

rem ----------------------------------------------------------------------


rem -----------------------------------------------------------------------



