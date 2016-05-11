connect target;
sql 'alter system switch logfile'; 		
backup as compressed backupset database;
sql 'alter system switch logfile';
backup archivelog all;
crosscheck backup; 		
crosscheck archivelog all; 		
delete noprompt archivelog all completed before 'sysdate -2';
delete noprompt obsolete recovery window of 2 days;
 
