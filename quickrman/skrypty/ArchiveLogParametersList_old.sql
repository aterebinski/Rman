select name, value from v$parameter where name like 'log_archive_format';
select name, value from v$parameter where name like 'log_archive_min_succeed_dest';
select name, value from v$parameter where name like 'log_archive_trace';
select name, value from v$parameter where name like 'log_archive_local_first';
select name, value from v$parameter where name like 'log_archive_max_processes';
select name, value from v$parameter where name like 'log_archive_config';
exit