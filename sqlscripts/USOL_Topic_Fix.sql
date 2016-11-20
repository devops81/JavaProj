
SPOOL ON

rem log file : USOL_Topic_Fix.log
SPOOL USOL_Topic_Fix.log


set echo on

SET ESCAPE '\'

delete from option_lookup where id = 97348010;

update option_lookup set optvalue = 'Outcomes (disease \& pharmacoeconomics)'
where optvalue  in ('Outcomes (disease \& pharmaoeconomics', 'Outcomes (disease \& pharmaoeconomics)' );

commit;

SPOOL OFF

set echo off

exit;

