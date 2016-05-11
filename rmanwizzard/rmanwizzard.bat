@MODE CON COLS=100
@rem MODE CON ROWS=1
@echo off
del skrypty\orders.sql
:CHECK
IF "%1" == "" GOTO CREDENTIALS_ERROR
:BEGIN
cls
echo. 
echo. 
echo                            Projekt Pracowniczy 
echo                              Adam Terebi‰ski
echo                               KAMSOFT S.A.
echo .................................................................................
echo.
echo                   RMAN Wizzard - Archive Config 
echo        Kreator uàatwiaj•cy poprawne skonfigurowanie
echo                       usàugi ARCHIVELOG.
echo                       v.1.3 (2016-05-11) 
echo.  
echo       Zaàoæenia: Uruchomnienie usàugi ARCHIVELOG w bazie danych
echo       Oracle 10g i nowszych. Przechowywanie archiw¢w w co najmniej
echo       dw¢ch lokalizacjach (obszar FRA i co najmniej jedna inna lokalizacja).
echo.
echo       Uwaga 1: Skrypt przeznaczony jest dla os¢b zorientowanych w administrowaniu
echo       i obsàudze baz danych Oracle oraz znaj•cych zagadnienia trybu Archivelog.
echo       Niewàaòciwe uæycie tego skryptu moæe prowadziÜ do zatrzymania bazy danych
echo       i problem¢w z jej ponownym uruchomieniem.  
echo.    
echo       Uwaga 2: Ten skrypt powstaà z myòl• o pierwszej konfiguracji ARCHIVELOG.
echo       W przypadku bardziej zaawansowanej konfiguracji trybu Archivelog 
echo       zaleca si© skorzystanie ze skryptu quickrman.bat
echo.
echo       Uwaga 3: Uæytkownik moæe w kaædej chwili zako‰czyÜ dziaàanie skryptu, 
echo       uæywaj•c kombinacji klawiszy Ctrl + C.
echo.
echo       Uwaga 4: Wszystkie dane wprowadzone przez uæytkownika zostan• wprowadzone
echo       do bazy w jednej iteracji pod koniec dziaàania skryptu. Wymagane b©dzie
echo       wtedy ponowne uruchomienie bazy danych. 
echo.
echo       Uwaga 5: Jesli podczas dziaàania skryptu pojawiaj• si© bà•d:
echo              "ORA-12560: TNS- bà•d adaptera protokoàu",
echo       podaj òcieæk© dostepu do katalogu bin serwera Oracle,
echo       jako drugi parametr podczas wywoàania skryptu:
echo             rmanwizzard.bat uæytkownik/hasào@instancja òcieæka
echo        ,gdzie òcieæka - lokalizacja katalogu bin serwera bazy danych w podw¢jnym cudzysàowiu,
echo       ze znakiem "\" na ko‰cu, np. "c:\app\Administrator\product\11.2.0\dbhome_1\BIN\" 
echo.
echo.
echo.                         
pause
:KROK1
cls
echo --- KROK1: SPRAWDZENIE PARAMETR‡W OBSZARU FRA ---
echo.
echo.  
%2sqlplus %1 @skrypty\ParametryFRA.sql
echo.
echo.
echo POWYΩEJ ZNAJDUJ§ SI® DOMYóLNE PARAMETRY OBSZARU "FRA", W KT‡RYM B®D§ PRZECHOWYWANE 
echo ARCHIVELOGI I KOPIE BAZY DANYCH WYKONYWANE PRZEZ RMAN, GDZIE:
echo DB_RECOVERY_FILE_DEST: FOLDER W KT‡RYM ZAPISYWANE S§ DANE
echo DB_RECOVERY_FILE_DEST_SIZE: MAKSYMALNA WIELKOSè FOLDERU W KT‡RYM ZAPISYWANE S§ DANE
echo (UWAGA! - JESLI WIELKOòè DANYCH W OBSZARZE "FRA" PRZEKROCZY TEN PARAMETR, 
echo BAZA DANYCH ZATRZYMA SI®!) 
echo.
set rmank1=
set /p rmank1=CZY CHCESZ ABY ZACHOWAè TE DOMYóLNE PARAMETRY? (t/n):
set rmank1=%rmank1:~0,1%
if "%rmank1%"=="t" goto KROK2
if "%rmank1%"=="n" goto KROK1a
if "%rmank1%"=="q" goto END
echo 
pause
goto KROK1

:KROK1a
echo.
set rmanfrafoldest=
echo PODAJ NOW§ óCIEΩK® DO FOLDERU ZAWIERAJ§CEGO OBSZAR "FRA"
echo LUB POZOSTAW PARAMETR PUSTY ABY ZOSTAWIè DOTYCHCZASOW§ WARTOSè.
set /p rmanfrafoldest=óCIEZKA:
rem if "%rmanfrafoldest%"=="" set rmanfrafoldest=c:\fra  
echo.
:KROK1b 
echo.
set rmanfrafolsize=
echo PODAJ MAKSYMALN§ WIELKOóè FOLDERU ZAWIERAJ§CEGO OBSZAR "FRA",
echo gdzie przyrostek G - Gigabajty(np.: 10G, 20G)
echo LUB POZOSTAW PARAMETR PUSTY ABY ZOSTAWIè DOTYCHCZASOW§ WARTOSè.
set /p rmanfrafolsize=WIELKOSè: 
rem if "%rmanfrafolsize%"=="" set rmanfrafolsize=40G                               
:KROK2
cls
echo --- KROK2: DODATKOWE FOLDERY Z ARCHIVELOGAMI---
:KROK2a
echo.
set rmaniledod=
set /p rmaniledod=W ILU DODATKOWYCH FOLDERACH MAJ§ BYè PRZECHOWYWANE KOPIE ARCHIVELOG‡W?(0-3):
if "%rmaniledod%"==""  goto KROK2a
if "%rmaniledod%" LSS "1" goto KROK3
:KROK2b
echo.
set rmansciezka1=
set /p rmansciezka1=PODAJ óCIEZK® DO PIERWSZEGO FOLDERU (np. c:\katalog):
if "%rmansciezka1%"==""  goto KROK2b
if "%rmaniledod%" LSS "2" goto KROK3
:KROK2c
echo.
set rmansciezka2=
set /p rmansciezka2=PODAJ óCIEZK® DO DRUGIEGO FOLDERU:
if "%rmansciezka2%"==""  goto KROK2c
if "%rmaniledod%" LSS "3" goto KROK3
:KROK2d
echo.
set rmansciezka3=
set /p rmansciezka3=PODAJ óCIEZK® DO TRZECIEGO FOLDERU:
if "%rmansciezka3%"==""  goto KROK2d
  
:KROK3
cls
echo ---KROK 3: SPRAWDç POPRAWNOSè DANYCH--- 
echo.
echo UWAGA! ZA CHWIL® NAST§PI WPROWADZENIE PODANYCH PRZEZ CIEBIE ZMIENNYCH DO BAZY.
echo PRZED T§ OPERACJ§ SPRAWDç POPRAWNOSè DANYCH:
echo.
if "%rmank1%"=="t" goto NOPRINT2
if "%rmanfrafoldest%"=="" goto NOPRINT1
echo óCIEΩKA DO FOLDERU Z OBSZAREM FRA: %rmanfrafoldest% 
:NOPRINT1
if "%rmanfrafolsize%"=="" goto NOPRINT2
echo MAKSYMALNA WILEKOóè FOLDERU Z OBSZAREM FRA: %rmanfrafolsize%
:NOPRINT2
if "%rmaniledod%" GEQ "1" echo óCIEZKA DO PIERWSZEGO DODATKOWEGO FOLDERU: %rmansciezka1%
if "%rmaniledod%" GEQ "2" echo óCIEZKA DO DRUGIEGO DODATKOWEGO FOLDERU: %rmansciezka2%
if "%rmaniledod%" GEQ "3" echo óCIEZKA DO TRZECIEGO DODATKOWEGO FOLDERU: %rmansciezka3%
echo.
echo.
echo.
set rmank2= 
set /p rmank2=CZY NA PEWNO CHCESZ WPROWADZIè TE DANE DO BAZY DANYCH? (t/n)
set rmank2=%rmank2:~0,1%
if "%rmank2%"=="t" goto KROK3a
if "%rmank2%"=="n" goto ABORT
echo invalid choice
goto KROK3 

:KROK3a
cls
echo.
echo.
echo PODAJ IDENTYFIKATOR SID INSTANCJI.
echo. 
echo.
set userinp= 
set /p userinp=SID:
if "%userinp%"=="" goto KROK3a
echo. 
echo set ORACLE_SID=%userinp% 
set ORACLE_SID=%userinp%
echo.
echo.
echo UWAGA: ZA CHWIL® NAST§PI WYù§CZENIE I PONOWNE Wù§CZENIE BAZY DANYCH!
echo.
echo.
pause
rem copy "skrypty\pusty" "skrypty\orders.sql"
if exist skrypty\orders.sql del skrypty\orders.sql 
echo spool rmanwizzard.log>>skrypty\orders.sql
rem echo select name, value from v$parameter where name like '%rmanfrafoldest%';>>skrypty\orders.sql
if "%rmank1%"=="t" goto ADDLOCAL
if "%rmanfrafoldest%"=="" goto KROK3B
if NOT EXIST %rmanfrafoldest% md %rmanfrafoldest%  
echo alter system set db_recovery_file_dest='' scope=both;>>skrypty\orders.sql
echo alter system set db_recovery_file_dest='%rmanfrafoldest%' scope=both;>>skrypty\orders.sql
:KROK3B
if "%rmanfrafolsize%"=="" goto ADDLOCAL
echo alter system set db_recovery_file_dest_size=%rmanfrafolsize% scope=both;>>skrypty\orders.sql  

:ADDLOCAL
echo alter system set log_archive_dest_10='LOCATION=USE_DB_RECOVERY_FILE_DEST' scope=both;>>skrypty\orders.sql

if "%rmaniledod%" LSS "1" goto ARCHIVELOGON
if "%rmansciezka1%" == "" goto ADDLOCAL1
if NOT EXIST %rmansciezka1% md %rmansciezka1% 
echo alter system set log_archive_dest_1='LOCATION=%rmansciezka1%' scope=both;>>skrypty\orders.sql

:ADDLOCAL1
if "%rmaniledod%" LSS "2" goto ARCHIVELOGON
if "%rmansciezka2%" == "" goto ADDLOCAL2
if NOT EXIST %rmansciezka2% md %rmansciezka2%
echo alter system set log_archive_dest_2='LOCATION=%rmansciezka2%' scope=both;>>skrypty\orders.sql

:ADDLOCAL2
if "%rmaniledod%" LSS "3" goto ARCHIVELOGON
if "%rmansciezka3%" == "" goto ARCHIVELOGON
if NOT EXIST %rmansciezka3% md %rmansciezka3%
echo alter system set log_archive_dest_3='LOCATION=%rmansciezka3%' scope=both;>>skrypty\orders.sql








:ARCHIVELOGON
echo shutdown immediate>>skrypty\orders.sql
echo startup mount>>skrypty\orders.sql
echo alter database archivelog;>>skrypty\orders.sql
echo alter database open;>>skrypty\orders.sql
echo spool off>>skrypty\orders.sql
echo exit>>skrypty\orders.sql    
%2sqlplus "/ as sysdba" @skrypty\orders.sql 
del skrypty\orders.sql
rem echo connect target %1;>>skrypty\orders.sql
echo configure controlfile autobackup on;>>skrypty\orders.sql
echo exit>>skrypty\orders.sql    
%2rman target %1 @skrypty\orders.sql 
del skrypty\orders.sql
 
if NOT EXIST c:\archskrypt md c:\archskrypt
if NOT EXIST c:\archskrypt\backup.sql copy skrypty\backup.sql c:\archskrypt\backup.sql
if NOT EXIST c:\archskrypt\backup.bat copy skrypty\backup.bat c:\archskrypt\backup.bat  
echo.
echo.
echo Wù§CZENIE TRYBU ARCHIVELOG I SKONFIGUROWANIE NA PODSTAWIE DANYCH WPROWADZONYCH 
echo W POPRZEDNICH KROKACH ZAKO„CZYùO SI®. SPRAWDç W PLIKU "rmanwizzard.log" 
echo CZY PODCZAS WYKONYWANIA SKRYPTU NIE POJAWIùY SI® Bù®DY.
echo W RAZIE PROBLEM‡W PROSZ® ZAPOZNAè SI® Z DOKUMENTACJ§.
echo.
echo UWAGA:
echo W KATALOGU c:\archskrypt UMIESZCZONE S§ PLIKI backup.sql I backup.bat SùUΩ§CE
echo DO WYKONYWANIA PEùNEJ KOPII ZAPASOWEJ. JEóLI CHCESZ MOΩESZ JE PRZENIEóè W INNE
echo MIEJSCE. ABY SKONFIGUROWAè WYKONYWANIE AUTOMATYCZNE PEùNEJ KOPII ZAPASOWEJ,
echo DODAJ WYKONWYANIE PLIKU backup.bat DO "HARMONOGRAMU ZADA„" ALBO DO "ZAPLANOWANYCH
echo ZADA„".
echo.
echo.
pause
:KROK4
cls
echo ---KROK 4: WYKONANIE BACKUPU BAZY DANYCH--- 
echo.
echo.
echo ODZYSKIWANIE BAZY DANYCH NA INNYM SERWERZE, ZA POMOC§ PROGRAMU RMAN, WYMAGA 
echo DYSPONOWANIA PEùN§ ZAPASOW§ BAZY DANYCH.  
echo.
set rmank1=
set /p rmank1=CZY CHCESZ WYKONAè TERAZ PEùN§ KOPI® BAZY? (ZALECANE) (t/n)
set rmank1=%rmank1:~0,1%
if "%rmank1%"=="t" goto BACKUP
if "%rmank1%"=="n" goto KROK6
goto KROK4 
:BACKUP
echo.
echo.
set rmanparam=
echo W jakim katalogu ma byÜ zapisana kopia bazy danych?
echo Zostaw wartosÜ pust• aby zarchiwizowaÜ do domyslnego katalogu.
echo.
set /p rmanparam=Wprowad´ scieæk© i wcisnij ENTER:
echo.
echo.
if exist skrypty\orders.sql del skrypty\orders.sql 
:KROK5
cls
echo.
echo.
echo  ---KROK 5: ROZPOCZ®CIE WYKONANIA BACKUPU...   --- 
echo ==============================================================
echo.
echo.
if "%rmanparam%"=="" goto KROK5b   
rem echo spool quickrman_log>>skrypty\orders.sql
rem echo connect target %1;>>skrypty\orders.sql
rem echo run>>skrypty\orders.sql  
rem echo {>>skrypty\orders.sql
rem echo SET CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '%rmanparam%\%%F.BK2';>>skrypty\orders.sql  
rem echo  allocate channel d1 device type disk format '%rmanparam%\%%U.BK1';>>skrypty\orders.sql 
rem echo   backup as compressed backupset database;>>skrypty\orders.sql 
rem echo  release channel d1;>>skrypty\orders.sql 
rem echo }>>skrypty\orders.sql 
rem echo backup as compressed backupset database include current controlfile format='c:\kopia\%%U';>>skrypty\orders.sql 
rem echo exit>>skrypty\orders.sql
:KROK5a
if NOT EXIST %rmanparam% md %rmanparam%
echo sql 'alter system switch logfile';>>skrypty\orders.sql
echo backup as compressed backupset database to destination '%rmanparam%';>>skrypty\orders.sql
echo sql 'alter system switch logfile';>>skrypty\orders.sql
echo backup archivelog all to destination '%rmanparam%';>>skrypty\orders.sql
echo backup spfile to destination '%rmanparam%';>>skrypty\orders.sql
echo backup current controlfile to destination '%rmanparam%';>>skrypty\orders.sql
rem echo backup spfile;>>skrypty\orders.sql
rem echo crosscheck backup;>>skrypty\orders.sql
rem echo crosscheck archivelog all;>>skrypty\orders.sql
rem echo delete noprompt expired backupset;>>skrypty\orders.sql
rem echo delete noprompt expired archivelog all;>>skrypty\orders.sql
goto KROK5c
:KROK5b
echo sql 'alter system switch logfile';>>skrypty\orders.sql
echo backup as compressed backupset database;>>skrypty\orders.sql
echo sql 'alter system switch logfile';>>skrypty\orders.sql
echo backup spfile;>>skrypty\orders.sql
echo backup archivelog all;>>skrypty\orders.sql
rem echo backup spfile;>>skrypty\orders.sql
echo crosscheck backup;>>skrypty\orders.sql
echo crosscheck archivelog all;>>skrypty\orders.sql
echo delete noprompt expired backupset;>>skrypty\orders.sql
echo delete noprompt expired archivelog all;>>skrypty\orders.sql
echo backup current controlfile;>>skrypty\orders.sql
:KROK5c       
%2rman target %1 @skrypty\orders.sql
echo.
echo.
echo ==============================================================
echo   BACKUP ZAKO„CZONY.
echo.
echo.
pause
if exist skrypty\orders.sql del skrypty\orders.sql
goto KROK6

:KROK6
echo.
echo.
echo.
echo WST®PNA KONFIGURACJA TRYBU ARCHIVELOG ZOSTAùA ZAKO„CZONA.
echo DALSZA KONFIGURACJA TRYBU ARCHIVELOG MOΩLIWA JEST POPRZEZ SKRYPT "quickrman.bat".
echo.  
pause
goto END

:ABORT
echo OPERACJA WPROWADZANIA DANYCH ZOSTAùA ANULOWANA
echo.
echo.
pause
goto END

:CREDENTIALS_ERROR
echo. 
echo. 
echo    NIEPRAWIDùOWE URUCHOMIENIE SKRYPTU
echo.
echo    W celu uæycia skryptu naleæy wykonaÜ komend©:
echo        rmanwizzard.bat uæytkownik/hasào@instancja [òcieæka]
echo.
echo    gdzie:
echo        uæytkownik - to nazwa uæytkownika z prawami administratora np. system
echo        hasào - hasào uæytkownika z prawami administratora
echo        instancja - nazwa instancji bazy danych np. orcl
echo        [òcieæka] - opcjonalny parametr - lokalizacja katalogu bin serwera bazy danych
echo          ze znakiem "\" na ko‰cu, np. "c:\app\Administrator\product\11.2.0\dbhome_1\BIN\"
echo          ócieæka powinna byÜ podana w podw¢jnym cudzysàowiu (");
echo.
echo.
pause
goto END

:END
rem Usuwanie zmiennych srodowiskowych
set rmanparam=
set rmank1=
set rmank2=
set rmanfrafoldest=
set rmanfrafolsize=
set rmaniledod=
set rmansciezka1=
set rmansciezka2=
set rmansciezka3=
set userinp=
if exist skrypty\orders.sql del skrypty\orders.sql