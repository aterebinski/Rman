select name, value from v$parameter where name like 'db_recovery_file_dest';
select name, display_value from v$parameter where name like 'db_recovery_file_dest_size';
exit