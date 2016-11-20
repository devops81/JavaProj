rem -----------------------------------------------------------------------

create table ORGCONTACTS(CONTACTID NUMBER(19) NOT NULL,ORGID NUMBER(19),CONTACTNAME VARCHAR2(255),
EMAIL VARCHAR2(255),PHONE VARCHAR2(255),ISPRIMARYCONTACT VARCHAR2(255),STAFFID NUMBER(19),
BEGINDATE DATE,ENDDATE DATE);

rem Date:       10-JUL-2007
rem Author:    Raghavan, Kuliza Technologies
rem Comment:    To create a new orgcontacts table for org alignment
rem -----------------------------------------------------------------------



rem------------------------------------------------------------------------

create table USER_RELATIONSHIP(ID NUMBER PRIMARY KEY,USER_ID NUMBER,RELATED_USER_ID NUMBER,
RELATIONSHIP_TYPE NUMBER,BEGIN_DATE TIMESTAMP(6),END_DATE TIMESTAMP(6),TERRITORY NUMBER);

rem Date:       10-JUL-2007
rem Author:    Raghavan, Kuliza Technologies
rem comment:   To create new user relationship table
rem -----------------------------------------------------------------------


rem -----------------------------------------------------------------------

INSERT INTO OPTION_NAMES VALUES(HIBERNATE_SEQUENCE.NEXTVAL,'REPORTPRIVILEGE',-1);
INSERT INTO OPTION_LOOKUP VALUES(HIBERNATE_SEQUENCE.NEXTVAL,(SELECT ID FROM OPTION_NAMES WHERE NAME= 'REPORTPRIVILEGE'),'1','N',-1);
INSERT INTO OPTION_LOOKUP VALUES(HIBERNATE_SEQUENCE.NEXTVAL,(SELECT ID FROM OPTION_NAMES WHERE NAME= 'REPORTPRIVILEGE'),'2','N',-1);
INSERT INTO OPTION_LOOKUP VALUES(HIBERNATE_SEQUENCE.NEXTVAL,(SELECT ID FROM OPTION_NAMES WHERE NAME= 'REPORTPRIVILEGE'),'3','N',-1);
INSERT INTO OPTION_LOOKUP VALUES(HIBERNATE_SEQUENCE.NEXTVAL,(SELECT ID FROM OPTION_NAMES WHERE NAME= 'REPORTPRIVILEGE'),'4','N',-1);
INSERT INTO OPTION_LOOKUP VALUES(HIBERNATE_SEQUENCE.NEXTVAL,(SELECT ID FROM OPTION_NAMES WHERE NAME= 'REPORTPRIVILEGE'),'5','N',-1);
INSERT INTO OPTION_LOOKUP VALUES(HIBERNATE_SEQUENCE.NEXTVAL,(SELECT ID FROM OPTION_NAMES WHERE NAME= 'REPORTPRIVILEGE'),'99','N',-1);


rem Date:       10-JUL-2007
rem Author:    Raghavan, Kuliza Technologies
rem comment:   To add report privilege in option values
rem -----------------------------------------------------------------------


rem -----------------------------------------------------------------------

alter table CONTACTS add (BEGINDATE DATE,ENDDATE DATE);

rem Date:       11-JUL-2007
rem Author:    Raghavan, Kuliza Technologies
rem comment:   To ADD TWO NEW COLUMNS IN CONTACTS TABLE
rem -----------------------------------------------------------------------

rem -----------------------------------------------------------------------

commit;
rem -----------------------------------------------------------------------