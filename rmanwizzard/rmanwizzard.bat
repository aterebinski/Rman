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
echo                              Adam Terebi�ski
echo                               KAMSOFT S.A.
echo .................................................................................
echo.
echo                   RMAN Wizzard - Archive Config 
echo        Kreator u�atwiaj�cy poprawne skonfigurowanie
echo                       us�ugi ARCHIVELOG.
echo                       v.1.3 (2016-05-11) 
echo.  
echo       Za�o�enia: Uruchomnienie us�ugi ARCHIVELOG w bazie danych
echo       Oracle 10g i nowszych. Przechowywanie archiw�w w co najmniej
echo       dw�ch lokalizacjach (obszar FRA i co najmniej jedna inna lokalizacja).
echo.
echo       Uwaga 1: Skrypt przeznaczony jest dla os�b zorientowanych w administrowaniu
echo       i obs�udze baz danych Oracle oraz znaj�cych zagadnienia trybu Archivelog.
echo       Niew�a�ciwe u�ycie tego skryptu mo�e prowadzi� do zatrzymania bazy danych
echo       i problem�w z jej ponownym uruchomieniem.  
echo.    
echo       Uwaga 2: Ten skrypt powsta� z my�l� o pierwszej konfiguracji ARCHIVELOG.
echo       W przypadku bardziej zaawansowanej konfiguracji trybu Archivelog 
echo       zaleca si� skorzystanie ze skryptu quickrman.bat
echo.
echo       Uwaga 3: U�ytkownik mo�e w ka�dej chwili zako�czy� dzia�anie skryptu, 
echo       u�ywaj�c kombinacji klawiszy Ctrl + C.
echo.
echo       Uwaga 4: Wszystkie dane wprowadzone przez u�ytkownika zostan� wprowadzone
echo       do bazy w jednej iteracji pod koniec dzia�ania skryptu. Wymagane b�dzie
echo       wtedy ponowne uruchomienie bazy danych. 
echo.
echo       Uwaga 5: Jesli podczas dzia�ania skryptu pojawiaj� si� b��d:
echo              "ORA-12560: TNS- b��d adaptera protoko�u",
echo       podaj �cie�k� dostepu do katalogu bin serwera Oracle,
echo       jako drugi parametr podczas wywo�ania skryptu:
echo             rmanwizzard.bat u�ytkownik/has�o@instancja �cie�ka
echo        ,gdzie �cie�ka - lokalizacja katalogu bin serwera bazy danych w podw�jnym cudzys�owiu,
echo       ze znakiem "\" na ko�cu, np. "c:\app\Administrator\product\11.2.0\dbhome_1\BIN\" 
echo.
echo.
echo.                         
pause
:KROK1
cls
echo --- KROK1: SPRAWDZENIE PARAMETR�W OBSZARU FRA ---
echo.
echo.  
%2sqlplus %1 @skrypty\ParametryFRA.sql
echo.
echo.
echo POWY�EJ ZNAJDUJ� SI� DOMY�LNE PARAMETRY OBSZARU "FRA", W KT�RYM B�D� PRZECHOWYWANE 
echo ARCHIVELOGI I KOPIE BAZY DANYCH WYKONYWANE PRZEZ RMAN, GDZIE:
echo DB_RECOVERY_FILE_DEST: FOLDER W KT�RYM ZAPISYWANE S� DANE
echo DB_RECOVERY_FILE_DEST_SIZE: MAKSYMALNA WIELKOS� FOLDERU W KT�RYM ZAPISYWANE S� DANE
echo (UWAGA! - JESLI WIELKO�� DANYCH W OBSZARZE "FRA" PRZEKROCZY TEN PARAMETR, 
echo BAZA DANYCH ZATRZYMA SI�!) 
echo.
set rmank1=
set /p rmank1=CZY CHCESZ ABY ZACHOWA� TE DOMY�LNE PARAMETRY? (t/n):
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
echo PODAJ NOW� �CIE�K� DO FOLDERU ZAWIERAJ�CEGO OBSZAR "FRA"
echo LUB POZOSTAW PARAMETR PUSTY ABY ZOSTAWI� DOTYCHCZASOW� WARTOS�.
set /p rmanfrafoldest=�CIEZKA:
rem if "%rmanfrafoldest%"=="" set rmanfrafoldest=c:\fra  
echo.
:KROK1b 
echo.
set rmanfrafolsize=
echo PODAJ MAKSYMALN� WIELKO�� FOLDERU ZAWIERAJ�CEGO OBSZAR "FRA",
echo gdzie przyrostek G - Gigabajty(np.: 10G, 20G)
echo LUB POZOSTAW PARAMETR PUSTY ABY ZOSTAWI� DOTYCHCZASOW� WARTOS�.
set /p rmanfrafolsize=WIELKOS�: 
rem if "%rmanfrafolsize%"=="" set rmanfrafolsize=40G                               
:KROK2
cls
echo --- KROK2: DODATKOWE FOLDERY Z ARCHIVELOGAMI---
:KROK2a
echo.
set rmaniledod=
set /p rmaniledod=W ILU DODATKOWYCH FOLDERACH MAJ� BY� PRZECHOWYWANE KOPIE ARCHIVELOG�W?(0-3):
if "%rmaniledod%"==""  goto KROK2a
if "%rmaniledod%" LSS "1" goto KROK3
:KROK2b
echo.
set rmansciezka1=
set /p rmansciezka1=PODAJ �CIEZK� DO PIERWSZEGO FOLDERU (np. c:\katalog):
if "%rmansciezka1%"==""  goto KROK2b
if "%rmaniledod%" LSS "2" goto KROK3
:KROK2c
echo.
set rmansciezka2=
set /p rmansciezka2=PODAJ �CIEZK� DO DRUGIEGO FOLDERU:
if "%rmansciezka2%"==""  goto KROK2c
if "%rmaniledod%" LSS "3" goto KROK3
:KROK2d
echo.
set rmansciezka3=
set /p rmansciezka3=PODAJ �CIEZK� DO TRZECIEGO FOLDERU:
if "%rmansciezka3%"==""  goto KROK2d
  
:KROK3
cls
echo ---KROK 3: SPRAWD� POPRAWNOS� DANYCH--- 
echo.
echo UWAGA! ZA CHWIL� NAST�PI WPROWADZENIE PODANYCH PRZEZ CIEBIE ZMIENNYCH DO BAZY.
echo PRZED T� OPERACJ� SPRAWD� POPRAWNOS� DANYCH:
echo.
if "%rmank1%"=="t" goto NOPRINT2
if "%rmanfrafoldest%"=="" goto NOPRINT1
echo �CIE�KA DO FOLDERU Z OBSZAREM FRA: %rmanfrafoldest% 
:NOPRINT1
if "%rmanfrafolsize%"=="" goto NOPRINT2
echo MAKSYMALNA WILEKO�� FOLDERU Z OBSZAREM FRA: %rmanfrafolsize%
:NOPRINT2
if "%rmaniledod%" GEQ "1" echo �CIEZKA DO PIERWSZEGO DODATKOWEGO FOLDERU: %rmansciezka1%
if "%rmaniledod%" GEQ "2" echo �CIEZKA DO DRUGIEGO DODATKOWEGO FOLDERU: %rmansciezka2%
if "%rmaniledod%" GEQ "3" echo �CIEZKA DO TRZECIEGO DODATKOWEGO FOLDERU: %rmansciezka3%
echo.
echo.
echo.
set rmank2= 
set /p rmank2=CZY NA PEWNO CHCESZ WPROWADZI� TE DANE DO BAZY DANYCH? (t/n)
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
echo UWAGA: ZA CHWIL� NAST�PI WY��CZENIE I PONOWNE W��CZENIE BAZY DANYCH!
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
echo W��CZENIE TRYBU ARCHIVELOG I SKONFIGUROWANIE NA PODSTAWIE DANYCH WPROWADZONYCH 
echo W POPRZEDNICH KROKACH ZAKO�CZY�O SI�. SPRAWD� W PLIKU "rmanwizzard.log" 
echo CZY PODCZAS WYKONYWANIA SKRYPTU NIE POJAWI�Y SI� B��DY.
echo W RAZIE PROBLEM�W PROSZ� ZAPOZNA� SI� Z DOKUMENTACJ�.
echo.
echo UWAGA:
echo W KATALOGU c:\archskrypt UMIESZCZONE S� PLIKI backup.sql I backup.bat S�U��CE
echo DO WYKONYWANIA PE�NEJ KOPII ZAPASOWEJ. JE�LI CHCESZ MO�ESZ JE PRZENIE�� W INNE
echo MIEJSCE. ABY SKONFIGUROWA� WYKONYWANIE AUTOMATYCZNE PE�NEJ KOPII ZAPASOWEJ,
echo DODAJ WYKONWYANIE PLIKU backup.bat DO "HARMONOGRAMU ZADA�" ALBO DO "ZAPLANOWANYCH
echo ZADA�".
echo.
echo.
pause
:KROK4
cls
echo ---KROK 4: WYKONANIE BACKUPU BAZY DANYCH--- 
echo.
echo.
echo ODZYSKIWANIE BAZY DANYCH NA INNYM SERWERZE, ZA POMOC� PROGRAMU RMAN, WYMAGA 
echo DYSPONOWANIA PE�N� ZAPASOW� BAZY DANYCH.  
echo.
set rmank1=
set /p rmank1=CZY CHCESZ WYKONA� TERAZ PE�N� KOPI� BAZY? (ZALECANE) (t/n)
set rmank1=%rmank1:~0,1%
if "%rmank1%"=="t" goto BACKUP
if "%rmank1%"=="n" goto KROK6
goto KROK4 
:BACKUP
echo.
echo.
set rmanparam=
echo W jakim katalogu ma by� zapisana kopia bazy danych?
echo Zostaw wartos� pust� aby zarchiwizowa� do domyslnego katalogu.
echo.
set /p rmanparam=Wprowad� scie�k� i wcisnij ENTER:
echo.
echo.
if exist skrypty\orders.sql del skrypty\orders.sql 
:KROK5
cls
echo.
echo.
echo  ---KROK 5: ROZPOCZ�CIE WYKONANIA BACKUPU...   --- 
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
echo   BACKUP ZAKO�CZONY.
echo.
echo.
pause
if exist skrypty\orders.sql del skrypty\orders.sql
goto KROK6

:KROK6
echo.
echo.
echo.
echo WST�PNA KONFIGURACJA TRYBU ARCHIVELOG ZOSTA�A ZAKO�CZONA.
echo DALSZA KONFIGURACJA TRYBU ARCHIVELOG MO�LIWA JEST POPRZEZ SKRYPT "quickrman.bat".
echo.  
pause
goto END

:ABORT
echo OPERACJA WPROWADZANIA DANYCH ZOSTA�A ANULOWANA
echo.
echo.
pause
goto END

:CREDENTIALS_ERROR
echo. 
echo. 
echo    NIEPRAWID�OWE URUCHOMIENIE SKRYPTU
echo.
echo    W celu u�ycia skryptu nale�y wykona� komend�:
echo        rmanwizzard.bat u�ytkownik/has�o@instancja [�cie�ka]
echo.
echo    gdzie:
echo        u�ytkownik - to nazwa u�ytkownika z prawami administratora np. system
echo        has�o - has�o u�ytkownika z prawami administratora
echo        instancja - nazwa instancji bazy danych np. orcl
echo        [�cie�ka] - opcjonalny parametr - lokalizacja katalogu bin serwera bazy danych
echo          ze znakiem "\" na ko�cu, np. "c:\app\Administrator\product\11.2.0\dbhome_1\BIN\"
echo          �cie�ka powinna by� podana w podw�jnym cudzys�owiu (");
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