select name "sciezka do FRA", round(space_limit/1024/1024,2) "limit MB", round(space_used/1024/1024,2) "uzyte MB", round(space_reclaimable/1024/1024,2) "do odzysku MB", number_of_files "il. plik¢w" from v$recovery_file_dest;
SET lines 140
SET PAGESIZE 100
SET WRAP OFF
select * from v$flash_recovery_area_usage;
exit
 
