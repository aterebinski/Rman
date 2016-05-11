SET ECHO OFF
SET SERVEROUTPUT OFF
select log_mode from v$database;
rem archive log list;
exit 0