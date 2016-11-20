SET SERVEROUTPUT ON SIZE 1000000
set linesize 1000


CREATE OR REPLACE FUNCTION multioptionanswer (parentquestion IN NUMBER) RETURN VARCHAR2 AS
   answer VARCHAR2(2000);
BEGIN
   select sa.answertext into answer from Filled_SubQues_Answers fsa join surveyanswersdata sa on (sa.id = fsa.answer_option) 
   where fsa.parent_question = parentquestion; 
   RETURN answer;
   EXCEPTION 
   when NO_DATA_FOUND then
   return null;
   DBMS_OUTPUT.PUT_LINE('Caught raised exception NO_DATA_FOUND');
  END ;
/

CREATE OR REPLACE FUNCTION agreementanswer (parentquestion IN NUMBER,subquesid IN NUMBER) RETURN VARCHAR2 AS
   answer VARCHAR2(2000);
BEGIN
   select sa.answertext into answer from Filled_SubQues_Answers fsa join surveyanswersdata sa on (sa.id = fsa.answer_option) 
   where fsa.parent_question = parentquestion and fsa.sub_question=subquesid; 
   RETURN answer;
   EXCEPTION 
   when NO_DATA_FOUND then
   return null;
   DBMS_OUTPUT.PUT_LINE('Caught raised exception NO_DATA_FOUND');
  END ;
/

CREATE OR REPLACE FUNCTION getUser (userid IN NUMBER) RETURN VARCHAR2 AS
   name VARCHAR2(200);
BEGIN
   select user_table.lastname||', '||user_table.firstname into name from user_table where id=userid; 
   RETURN name;
   EXCEPTION 
   when NO_DATA_FOUND then
   return null;
   DBMS_OUTPUT.PUT_LINE('Caught raised exception NO_DATA_FOUND');
  END ;
/

CREATE OR REPLACE FUNCTION multioptionmultianswer (parentquestion IN NUMBER) RETURN VARCHAR2 AS
   TYPE AnsArray IS VARRAY(200) of VARCHAR2(4000);
   answerarray AnsArray := AnsArray();
   answer VARCHAR2(4000);
   a_seperator varchar2(10);
  BEGIN
   a_seperator := '==';
   select sa.answertext bulk collect into answerarray from Filled_SubQues_Answers fsa join surveyanswersdata sa on (sa.id = fsa.answer_option) 
   where fsa.parent_question = parentquestion;
   IF answerarray.LAST>1 THEN
   FOR i IN 1..answerarray.COUNT LOOP
   answer := answerarray(i)||answer;
   answer := answer||a_seperator;
   END LOOP; 
   ELSIF answerarray.LAST=1 THEN
   answer := answerarray(1);
   ELSE
   answer := ' ';
   END IF;
   RETURN answer;
   EXCEPTION 
   when NO_DATA_FOUND then
   return null;
   DBMS_OUTPUT.PUT_LINE('Caught raised exception NO_DATA_FOUND');
   answerarray.TRIM(answerarray.LAST);
  END ;
/

CREATE OR REPLACE PROCEDURE Survey(surveyid IN NUMBER) AS
  output_file    utl_file.file_type;
  TYPE str_array IS varray(400) of VARCHAR2(4000); 
  TYPE num_array IS varray(400)  of NUMBER;
  type assoc_arr is table of varchar2(4000) index by varchar2(255);
  l_current      varchar2(255);
  TYPE cur_typ   IS REF CURSOR;
  c1             cur_typ;
  c2             cur_typ;
  c3             cur_typ;
  query_str1     VARCHAR2(1000);
  query_str2     VARCHAR2(1000);
  query_str3     VARCHAR2(1000);
  str1           VARCHAR2(2000);
  answer         VARCHAR2(4000);
  name           VARCHAR2(1000);
  l_separator    VARCHAR2(10);
  parentquestion NUMBER;
  id             NUMBER;
  l_a            NUMBER;
  userid         NUMBER;
  expertid       NUMBER;
  questionid     NUMBER;
  question       VARCHAR2(1000);
  questiontype   VARCHAR2(1000);
  questype       str_array := str_array();
  subquestion    str_array := str_array();
  subquestid     num_array := num_array();
  a_question     str_array := str_array();
  a_questionid   num_array := num_array();
  a_answer       assoc_arr;
  date1          date;
  BEGIN
    output_file := utl_file.fopen ('NEW','output'||surveyid||'.csv', 'W',32767);
    query_str2 := 'select fs.id,fs.userid,fs.expertid,svm.name,fs.createdate  from filled_survey fs join surveymetadata svm on (svm.id=fs.surveyid)
    where fs.surveyid= :surveyid';
    query_str3 := 'select fq.answer_text,fq.questionid,svm.type,fq.id from filled_questions fq join surveyquestionsmetadata svm on
    (svm.id=fq.questionid) where fq.parent_survey = :parent_survey and svm.surveyid = :surveyid';
    query_str1 := 'select sqm.type,sqm.questiontext,ssqm.SubQuestionText,sqm.id,ssqm.id 
    from SurveyQuestionsMetaData sqm left outer join surveysubquestionsmetadata ssqm on(sqm.id=ssqm.questionid) 
    where sqm.surveyid= :surveyid';
    l_separator := '|';
    open c1 for query_str1 using surveyid;
    fetch c1 bulk collect into questype,a_question,subquestion,a_questionid,subquestid;
    close c1;
    utl_file.put(output_file,'Survey Name|Survey User|Expert|Create Date');
    FOR i IN 1..a_question.COUNT LOOP
    IF (questype(i) = 'agreement' OR questype(i)= 'agreement5') THEN
    a_questionid(i) := subquestid(i);
    utl_file.put(output_file,l_separator||TRIM(TO_CHAR(subquestid(i))));
    utl_file.put(output_file,SUBSTR(subquestion(i),1,50));
    utl_file.put(output_file,' ');
    utl_file.put(output_file,SUBSTR(a_question(i),1,50));
    ELSE
    utl_file.put(output_file,l_separator||TRIM(TO_CHAR(a_questionid(i))));
    utl_file.put(output_file,SUBSTR(a_question(i),1,50));
    END IF;
    END LOOP;
    utl_file.new_line(output_file);
    open c2 FOR query_str2 using surveyid;
    LOOP
    fetch c2  into id,userid,expertid,name,date1;
    EXIT WHEN c2%NOTFOUND;
    open c3 FOR query_str3 using id,surveyid;
    LOOP
    fetch c3 into answer,questionid,questiontype,parentquestion;
    EXIT WHEN c3%NOTFOUND;
    FOR i IN 1..a_question.COUNT LOOP
    IF a_questionid(i) = questionid THEN
    IF (questiontype = 'simpleText' OR questiontype = 'numText') THEN
    IF answer is NULL THEN
    a_answer(to_char(a_questionid(i))) := ' ';
    ELSE 
    a_answer(to_char(a_questionid(i))) := answer;
    END IF;
    ELSIF (questiontype = 'multioptsinglesel') THEN
    a_answer(to_char(a_questionid(i))) := multioptionanswer(parentquestion);
    ELSIF (questiontype = 'multioptmultisel') THEN
    a_answer(to_char(a_questionid(i))) := multioptionmultianswer(parentquestion);
    ELSIF (questiontype = 'agreement' OR questiontype ='agreement5') THEN
    a_answer(to_char(a_questionid(i))) := agreementanswer(parentquestion,a_questionid(i));
    ELSE
    a_answer(to_char(a_questionid(i))) := answer;
    END IF;
    EXIT;
    END IF;
    END LOOP;
    END LOOP;
    utl_file.put(output_file,name||'|'||getUser(userid)||'|'||getUser(expertid)||'|'||TO_CHAR(date1));
    FOR j IN 1..a_questionid.COUNT LOOP
    utl_file.put(output_file,l_separator||a_answer(to_char(a_questionid(j))));
    a_answer.DELETE(to_char(a_questionid(j)));
    END LOOP;
    utl_file.new_line(output_file);
    END LOOP;
    utl_file.fclose(output_file);
     close c2;
    close c3;
    EXCEPTION
    when NO_DATA_FOUND then
    DBMS_OUTPUT.PUT_LINE('Caught raised exception NO_DATA_FOUND');
  END;
/
  

declare
   new_id number :=83395360;
  begin
   Survey(new_id);
  end;
 /

 