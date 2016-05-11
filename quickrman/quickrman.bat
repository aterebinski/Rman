@MODE CON COLS=100
@MODE CON ROWS=1
@echo off
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
echo                              QuickRMAN - 
echo               Skrypt uàatwiaj•cy konfiguracj© i zarz•dzanie
echo                kopiami bezpiecze‰stwa w trybie ARCHIVELOG.
echo                           v.1.3 (2016-05-11)  
echo.
echo       Uwaga 1: Skrypt przeznaczony jest dla os¢b zorientowanych w administrowaniu
echo       i obsàudze baz danych Oracle oraz znaj•cych zagadnienia trybu Archivelog.
echo       Niewàaòciwe uæycie tego skryptu moæe doprowadziÜ do zatrzymania bazy danych
echo       i problem¢w z jej ponownym uruchomieniem.  
echo.    
echo       Uwaga 2: W przypadku pierwszej konfiguracji trybu Archivelog na serwerze, 
echo       zaleca si© skorzystanie ze skryptu-kreatora rmanwizzard.bat.
echo.
echo       Uwaga 3: Uæytkownik moæe w kaædej chwili zako‰czyÜ dziaàanie skryptu, 
echo       uæywaj•c kombinacji klawiszy Ctrl + C.
echo.
echo       Uwaga 4: Jesli podczas dziaàania skryptu pojawiaj• si© bà•d:
echo              "ORA-12560: TNS- bà•d adaptera protokoàu",
echo       podaj òcieæk© dostepu do katalogu bin serwera Oracle,
echo       jako drugi parametr podczas wywoàania skryptu:
echo             quickrman.bat uæytkownik/hasào@instancja òcieæka
echo        ,gdzie òcieæka - lokalizacja katalogu bin serwera bazy danych w podw¢jnym cudzysàowiu,
echo       ze znakiem "\" na ko‰cu, np. "c:\app\Administrator\product\11.2.0\dbhome_1\BIN\" 
echo.
echo.
echo.                         
pause

:INPUT_PARAMS
cls
rem if "%1" NEQ "" goto MENU
rem echo Nie podaàes parametr¢w logowania do bazy danych na schemacie system
rem echo Prawidàowe wywoàanie skryptu: rmanwiz.bat system/haslo@SID
rem echo gdzie: haslo - hasào uæytkownika system
rem echo SID - SID bazy danych
rem pause
rem goto END
:MENU
cls
echo.
echo.
echo   MENU Gù‡WNE
echo ================================================================
echo.
echo   Konfiguracja trybu ARCHIVELOG:
echo. 
echo   1 - Status/Wà•czenie/Wyà•czenie trybu ARCHIVELOG
echo   2 - Sprawdzenie/Konfiguracja parametr¢w trybu ARCHIVELOG
echo   3 - Sprawdzenie/Konfiguracja plik¢w Redolog
echo   4 - Sprawdzenie parametr¢w programu RMAN
echo --------------------------------------------------------------
echo   Zarz•dzanie kopiami bezpiecze‰stwa:
echo.
echo   5 - Sprawdzenie zaj©toòci obszaru FRA
echo   6 - Sprawdzenie listy plik¢w przestarzaàych (do usuni©cia) we FRA
echo   7 - Usuwanie przestarzaàych plik¢w z FRA
echo   8 - Wykonanie peànego BACKUPu 
echo   0 - Wyjòcie ze skryptu
echo. 
set /p userinp=Wybierz opcj© i wcisnij ENTER:
set userinp=%userinp:~0,1%
if "%userinp%"=="0" goto END
if "%userinp%"=="1" goto M1
if "%userinp%"=="2" goto M2
if "%userinp%"=="3" goto M3
if "%userinp%"=="4" goto M4
if "%userinp%"=="5" goto M5
if "%userinp%"=="6" goto M6
if "%userinp%"=="7" goto M7
if "%userinp%"=="8" goto M8
echo invalid choice
goto MENU

:M1
cls
echo.
echo.
echo   SPRAWDZENIE CZY TRYB ARCHIVELOG JEST Wù§CZONY
echo ============================================================== 
%2sqlplus %1 @skrypty\ArchiveLogStatus.sql
echo.
echo.
echo   Legenda: 
echo   LOG_MODE: NOARCHIVELOG - wyà•czony tryb Archivelog
echo   LOG_MODE: ARCHIVELOG - wà•czony tryb Archivelog
echo.
echo.
echo   MENU Status/Wà•czanie/Wyà•czanie trybu ARCHIVELOG:
echo ==============================================================
echo. 
rem echo 1 - Status trybu ARCHIVELOG
echo   1 - Wà•czenie trybu ARCHIVELOG
echo   2 - Wyà•czenie trybu ARCHIVELOG 
echo   0 - Powr¢t do gà¢wnego menu
echo. 
set /p userinp=Wybierz opcj© i wcisnij ENTER:
set userinp=%userinp:~0,1%
if "%userinp%"=="0" goto MENU
rem if "%userinp%"=="1" goto M11
if "%userinp%"=="1" goto M12
if "%userinp%"=="2" goto M13
echo invalid choice
goto M1

:M12
REM Wù§CZENIE TRYBU ARCHIVELOG
cls
echo.
echo.
echo   Wù§CZENIE TRYBU ARCHIVELOG - krok 1
echo ============================================================== 
echo.
echo.
echo UWAGA!!!
echo Wù§CZENIE TRYBU ARCHVELOG WYMAGA PONOWNEGO URUCHOMINENIA
echo BAZY DANYCH. SPOWODUJE TO ROZù§CZENIE UΩYTKOWNIK‡W PRACUJ§CYCH
echo W TEJ CHWILI NA BAZIE DANYCH I MOΩE PROWADZIè DO UTRATY WPROWADZONYCH
echo PRZEZ NICH DANYCH. PRZED KONTYNUACJ§ Wù§CZANIA TRYBU ARCHIVELOG,
echo UPEWNIJ SI® ΩE NIKT Z UΩYTKOWNIK‡W NIE PRACUJE W TEJ CHWILI
echo NA BAZIE DANYCH. 
echo. 
echo. 
set /p userinp=CZY CHCESZ KONTYNUOWAè Wù§CZANIE TRYBU ARCHIVELOG? [t/n]:
set userinp=%userinp:~0,1%
if "%userinp%"=="n" goto M1
rem if "%userinp%"=="t" %2sqlplus "%1 as sysdba" @skrypty\ArchiveLogON.sql
if "%userinp%"=="t" goto M121 
pause
echo invalid choice
goto M1

:M121
REM Wù§CZENIE TRYBU ARCHIVELOG
cls
echo.
echo.
echo   Wù§CZENIE TRYBU ARCHIVELOG - krok 2
echo ============================================================== 
echo.
echo.
echo PODAJ IDENTYFIKATOR SID INSTANCJI,
echo KT‡REJ CHCESZ Wù§CZYè TRYB ARCHIVELOG.
echo. 
echo. 
set /p userinp=SID:
rem set userinp=%userinp:~0,3%
if "%userinp%"=="" goto M121
echo. 
echo set ORACLE_SID=%userinp% 
set ORACLE_SID=%userinp%
echo.
echo.
echo UWAGA: ZA CHWIL® NAST§PI WYù§CZENIE I PONOWNE Wù§CZENIE BAZY DANYCH!
echo.
echo.
pause
echo.
echo.
%2sqlplus "/ as sysdba" @skrypty\ArchiveLogON.sql
pause
goto M1

:M13
REM WYù§CZENIE TRYBU ARCHIVELOG
cls
echo.
echo.
echo   WYù§CZENIE TRYBU ARCHIVELOG - krok 1
echo ============================================================== 
echo.
echo.
echo UWAGA!!!
echo WYù§CZENIE TRYBU ARCHVELOG WYMAGA PONOWNEGO URUCHOMINENIA
echo BAZY DANYCH. SPOWODUJE TO ROZù§CZENIE UΩYTKOWNIK‡W PRACUJ§CYCH
echo W TEJ CHWILI NA BAZIE DANYCH I MOΩE PROWADZIè DO UTRATY WPROWADZONYCH
echo PRZEZ NICH DANYCH. PRZED KONTYNUACJ§ Wù§CZANIA TRYBU ARCHIVELOG,
echo UPEWNIJ SI® ΩE NIKT Z UΩYTKOWNIK‡W NIE PRACUJE W TEJ CHWILI
echo NA BAZIE DANYCH. 
echo. 
echo. 
set /p userinp=CZY CHCESZ KONTYNUOWAè WYù§CZANIE TRYBU ARCHIVELOG? [t/n]:
set userinp=%userinp:~0,1%
if "%userinp%"=="n" goto M1
rem if "%userinp%"=="t" %2sqlplus "%1 as sysdba" @skrypty\ArchiveLogOFF.sql
if "%userinp%"=="t" goto M131 
pause
echo invalid choice
goto M1

:M131
REM Wù§CZENIE TRYBU ARCHIVELOG
cls
echo.
echo.
echo   WYù§CZENIE TRYBU ARCHIVELOG - krok 2
echo ============================================================== 
echo.
echo.
echo PODAJ IDENTYFIKATOR SID INSTANCJI,
echo KT‡REJ CHCESZ WYù§CZYè TRYB ARCHIVELOG.
echo. 
echo. 
set /p userinp=SID:
rem set userinp=%userinp:~0,3%
if "%userinp%"=="" goto M131
echo. 
echo set ORACLE_SID=%userinp% 
set ORACLE_SID=%userinp%
echo.
echo.
echo UWAGA: ZA CHWIL® NAST§PI WYù§CZENIE I PONOWNE Wù§CZENIE BAZY DANYCH!
echo.
echo.
pause
echo.
echo.
%2sqlplus "/ as sysdba" @skrypty\ArchiveLogOFF.sql
pause
goto M1

:M2
cls
echo.
echo.
echo   MENU Sprawdzenie/Konfiguracja parametr¢w trybu ARCHIVELOG:
echo ============================================================== 
echo. 
echo   1 - Sprawd´ rozmieszczenie folder¢w trybu ARCHIVELOG
echo       (parametry: log_archive_dest_N, log_archive_dest_state_N, 
echo       db_recovery_file_dest i db_recovery_file_dest_size)
echo   2 - Sprawd´ parametry log_archive_format
echo       i log_archive_min_succeed_dest
echo --------------------------------------------------------------
echo   3 - Zmie‰ parametry log_archive_dest_N 
echo   4 - Zmie‰ parametry log_archive_dest_state_N
echo   5 - Zmie‰ parametr db_recovery_file_dest 
echo   6 - Zmie‰ parametr db_recovery_file_dest_size
echo   7 - Zmie‰ parametr log_archive_format
echo   8 - Zmie‰ parametr log_archive_min_succeed_dest
echo --------------------------------------------------------------     
echo   0 - Powr¢t do gà¢wnego menu
echo.
set userinp= 
set /p userinp=Wybierz opcj© i wcisnij ENTER:
set userinp=%userinp:~0,1%
if "%userinp%"=="0" goto MENU
if "%userinp%"=="1" goto M21
if "%userinp%"=="2" goto M22
rem if "%userinp%"=="3" goto M23
if "%userinp%"=="3" goto M23
if "%userinp%"=="4" goto M24
if "%userinp%"=="5" goto M25
if "%userinp%"=="6" goto M26
if "%userinp%"=="7" goto M27
if "%userinp%"=="8" goto M28
echo invalid choice
goto M2

:M21
REM SPRAWDZ ROZMIESZCZENIA FOLDER‡W TRYBU ARCHIVELOG
cls
echo.
echo.
echo   SPRAWDZENIE ROZMIESZCZENIA FOLDER‡W TRYBU ARCHIVELOG
echo ============================================================== 
%2sqlplus %1 @skrypty\ArchiveLogFoldersParametersList.sql
echo.
echo.
echo.
echo.
pause
goto M2

:M22
REM SPRAWDZ POZOSTAùE PARAMETRY TRYBU ARCHIVELOG
cls
echo.
echo.
echo   SPRAWDZENIE POZOSTAùYCH PARAMETR‡W TRYBU ARCHIVELOG
echo ==============================================================
%2sqlplus %1 @skrypty\ArchiveLogParametersList.sql
echo.
echo.
echo.
echo.
pause
goto M2

:M23
REM Zmie‰ rozmieszczenie katalog¢w trybu ARCHIVELOG
cls
echo.
echo.
echo   ZMIE„ ROZMIESZCZENIE KATALOG‡W TRYBU ARCHIVELOG
echo ==============================================================
echo.
echo   Kt¢ry parametr chcesz zmieniÜ ? 
echo   1 - log_archive_dest_1
echo   2 - log_archive_dest_2
echo   3 - log_archive_dest_3
echo   4 - log_archive_dest_4
echo   5 - log_archive_dest_5
echo   6 - log_archive_dest_6
echo   7 - log_archive_dest_7
echo   8 - log_archive_dest_8
echo   9 - log_archive_dest_9
echo   10 - log_archive_dest_10
echo   0 - Powr¢t do poprzedniego menu
echo.
set userinp= 
set /p userinp=Wybierz opcj© i wcisnij ENTER:
set userinp=%userinp:~0,2%
if "%userinp%"=="0" goto M2
if "%userinp%"=="1" goto M2311
if "%userinp%"=="2" goto M2311
if "%userinp%"=="3" goto M2311
if "%userinp%"=="4" goto M2311
if "%userinp%"=="5" goto M2311
if "%userinp%"=="6" goto M2311
if "%userinp%"=="7" goto M2311
if "%userinp%"=="8" goto M2311
if "%userinp%"=="9" goto M2311
if "%userinp%"=="10" goto M2311
echo invalid choice
goto M23

:M2311
cls
set rmanfrafoldest=
echo.
echo PODAJ óCIEZK® DOST®PU DO FOLDERU log_archive_dest_%userinp%.
echo WPISZ "fra" JESLI CHCESZ SKORZYSTAC Z KATALOGU ZDEFINIOWANEGO
echo W ZMIENNEJ "db_recovery_file_dest".
set /p rmanfrafoldest=Wprowad´ scieæk© i wcisnij ENTER:
if "%rmanfrafoldest%"=="" goto M2311
echo.
if exist skrypty\orders.sql del skrypty\orders.sql 
echo spool quickrman.log>>skrypty\orders.sql
if "%rmanfrafoldest%"=="fra" goto M2311a
if NOT EXIST %rmanfrafoldest% md %rmanfrafoldest%
echo alter system set log_archive_dest_%userinp%='LOCATION=%rmanfrafoldest%'  scope=both;>>skrypty\orders.sql
goto M2311b

:M2311a
echo alter system set log_archive_dest_%userinp%='LOCATION=USE_DB_RECOVERY_FILE_DEST'  scope=both;>>skrypty\orders.sql

:M2311b
rem wyà•czenie i wà•czenie bazy 
rem echo shutdown immediate>>skrypty\orders.sql
rem echo startup mount>>skrypty\orders.sql
rem echo alter database archivelog;>>skrypty\orders.sql
rem echo alter database open;>>skrypty\orders.sql
echo spool off>>skrypty\orders.sql
echo exit>>skrypty\orders.sql    
%2sqlplus %1 @skrypty\orders.sql
pause
del skrypty\orders.sql 
goto M2

:M24
REM Zmie‰ parametr log_archive_dest_stat 
cls
echo.
echo.
echo   ZMIE„ PARAMETR log_archive_dest_stat
echo ==============================================================
echo.
echo   Kt¢ry parametr chcesz zmieniÜ ? 
echo   1 - log_archive_dest_state_1
echo   2 - log_archive_dest_state_2
echo   3 - log_archive_dest_state_3
echo   4 - log_archive_dest_state_4
echo   5 - log_archive_dest_state_5
echo   6 - log_archive_dest_state_6
echo   7 - log_archive_dest_state_7
echo   8 - log_archive_dest_state_8
echo   9 - log_archive_dest_state_9
echo   10 - log_archive_dest_state_10
echo   0 - Powr¢t do poprzedniego menu
echo.
set userinp= 
set /p userinp=Wybierz opcj© i wcisnij ENTER:
set userinp=%userinp:~0,2%
if "%userinp%"=="0" goto M2
if "%userinp%"=="1" goto M241
if "%userinp%"=="2" goto M241
if "%userinp%"=="3" goto M241
if "%userinp%"=="4" goto M241
if "%userinp%"=="5" goto M241
if "%userinp%"=="6" goto M241
if "%userinp%"=="7" goto M241
if "%userinp%"=="8" goto M241
if "%userinp%"=="9" goto M241
if "%userinp%"=="10" goto M241
echo invalid choice
goto M24

:M241
set rmanparam=
echo.
echo PODAJ PARAMETR log_archive_dest_state_%userinp%:
echo  - WPISZ "enable", JEóLI CHCESZ Wù§CZYè KOPIOWANIE ARCHIW‡W
echo      DO LOKALIZACJI log_archive_dest_state_%userinp%, 
echo  - WPISZ "defer", JEóLI CHCESZ WYù§CZYè KOPIOWANIE
echo      ARCHIW‡W DO TEJ LOKALIZACJI,
echo  - WPISZ "exit" LUB ZOSTAW PUST§ WARTOóè, 
echo      JEóLI NIE CHCESZ ZMIENIAè TEJ OPCJI.
echo.
set /p rmanparam=Wprowad´ parametr i wcisnij ENTER:
echo.
if "%rmanparam%"=="ENABLE" goto M241a
if "%rmanparam%"=="enable" goto M241a
if "%rmanparam%"=="DEFER" goto M241a
if "%rmanparam%"=="defer" goto M241a
if "%rmanparam%"=="" goto M2
if "%rmanparam%"=="exit" goto M2
goto M241

:M241a
if exist skrypty\orders.sql del skrypty\orders.sql 
echo spool quickrman.log>>skrypty\orders.sql
echo alter system set log_archive_dest_state_%userinp%='%rmanparam%' scope=both;>>skrypty\orders.sql
rem wyà•czenie i wà•czenie bazy 
rem echo shutdown immediate>>skrypty\orders.sql
rem echo startup mount>>skrypty\orders.sql
rem echo alter database archivelog;>>skrypty\orders.sql
rem echo alter database open;>>skrypty\orders.sql
echo spool off>>skrypty\orders.sql
echo exit>>skrypty\orders.sql    
%2sqlplus %1 @skrypty\orders.sql
echo.
pause
del skrypty\orders.sql 
goto M2


rem ===========================================================================
:M25
set rmanfrafoldest=
cls
echo.
echo.
echo PODAJ NOW§ SCIEΩK® DO FOLDERU ZAWIERAJ§CEGO OBSZAR "FRA"
echo (PARAMETR db_recovery_file_dest), np. c:\katalog\podkatalog,
echo LUB NACISNIJ ENTER ABY ZOSTAWIè PARAMETR NIEZMIENIONY
echo.
set /p rmanfrafoldest=SCIEZKA:
if "%rmanfrafoldest%"=="" goto M2 
echo.
echo.
if NOT EXIST %rmanfrafoldest% md %rmanfrafoldest%
if exist skrypty\orders.sql del skrypty\orders.sql
echo spool quickrman.log>>skrypty\orders.sql
echo alter system set db_recovery_file_dest='' scope=both;>>skrypty\orders.sql  
if NOT "%rmanfrafoldest%"=="" echo alter system set db_recovery_file_dest="%rmanfrafoldest%" scope=both;>>skrypty\orders.sql
echo spool off>>skrypty\orders.sql
echo exit>>skrypty\orders.sql
%2sqlplus %1 @skrypty\orders.sql
echo.
pause
del skrypty\orders.sql
goto M2

:M26
set rmanparam=
cls
echo.
echo.
echo PODAJ MAKSYMALN§ WIELKOóè FOLDERU ZAWIERAJ§CEGO OBSZAR "FRA"
echo (PARAMETR db_recovery_file_dest_size),
echo gdzie przyrostek G - Gigabajty(np.: 10G, 20G).
echo.
echo UWAGA!: JESLI DANE W OBSZARZE FRA OSI§GN§ WIELKOSè PRZEKRACZAJ§CA
echo TEN PARAMETR, BAZA DANYCH ZATRZYMA SI®!
echo.
set /p rmanparam=WIELKOSè:
if "%rmanparam%"=="" goto M2 

if exist skrypty\orders.sql del skrypty\orders.sql 
echo spool quickrman.log>>skrypty\orders.sql
rem echo alter system set db_recovery_file_dest_size='' scope=both;>>skrypty\orders.sql
if NOT "%rmanparam%"=="" echo alter system set db_recovery_file_dest_size=%rmanparam% scope=both;>>skrypty\orders.sql  
echo spool off>>skrypty\orders.sql
echo exit>>skrypty\orders.sql    
%2sqlplus %1 @skrypty\orders.sql
echo.
pause
del skrypty\orders.sql 
goto M2

:M27
set rmanparam=
echo.
echo PODAJ PARAMETR log_archive_format
echo.
set /p rmanparam=Wprowad´ parametr i wcisnij ENTER:
if "%rmanparam%"=="" goto M2
echo.
if exist skrypty\orders.sql del skrypty\orders.sql 
echo spool quickrman.log>>skrypty\orders.sql
echo alter system set log_archive_format='%rmanparam%' scope=spfile;>>skrypty\orders.sql
rem wyà•czenie i wà•czenie bazy 
rem echo shutdown immediate>>skrypty\orders.sql
rem echo startup mount>>skrypty\orders.sql
rem echo alter database archivelog;>>skrypty\orders.sql
rem echo alter database open;>>skrypty\orders.sql
echo spool off>>skrypty\orders.sql
echo exit>>skrypty\orders.sql    
%2sqlplus %1 @skrypty\orders.sql
echo.
pause
del skrypty\orders.sql 
goto M2

:M28
set rmanparam=
echo.
echo PODAJ PARAMETR log_archive_min_succeed_dest
echo.
set /p rmanparam=Wprowad´ parametr i wcisnij ENTER:
if "%rmanparam%"=="" goto M2
echo.
if exist skrypty\orders.sql del skrypty\orders.sql 
echo spool quickrman.log>>skrypty\orders.sql
echo alter system set log_archive_min_succeed_dest=%rmanparam% scope=both;>>skrypty\orders.sql
rem wyà•czenie i wà•czenie bazy 
rem echo shutdown immediate>>skrypty\orders.sql
rem echo startup mount>>skrypty\orders.sql
rem echo alter database archivelog;>>skrypty\orders.sql
rem echo alter database open;>>skrypty\orders.sql
echo spool off>>skrypty\orders.sql
echo exit>>skrypty\orders.sql    
%2sqlplus %1 @skrypty\orders.sql
echo.
pause
del skrypty\orders.sql 
goto M2

:M3
cls
echo.
echo.
echo   MENU Sprawdzenie/Konfiguracja plik¢w Redolog
echo ==============================================================
echo.
%2sqlplus %1 @skrypty\redolog.sql
echo.
echo   Opcje: 
echo   1 - Przeà•cz redolog na nast©pny plik
echo   2 - Dodaj plik redolog
echo   3 - Usu‰ plik redolog
echo   0 - Powr¢t do gà¢wnego menu
echo. 
set /p userinp=Wybierz opcj© i wcisnij ENTER:
set userinp=%userinp:~0,1%
if "%userinp%"=="0" goto MENU
if "%userinp%"=="1" goto M31
if "%userinp%"=="2" goto M32
if "%userinp%"=="3" goto M33
echo invalid choice
goto M3

:M31
REM PRZEù§CZ REDOLOG
echo.
echo.
echo   PRZEù§CZAM PLIK REDOLOG...
echo.
echo.
if exist skrypty\orders.sql del skrypty\orders.sql 
rem echo spool quickrman.log>>skrypty\orders.sql
echo alter system switch logfile;>>skrypty\orders.sql
echo alter system checkpoint;>>skrypty\orders.sql
rem echo spool off>>skrypty\orders.sql
echo exit>>skrypty\orders.sql    
%2sqlplus %1 @skrypty\orders.sql
echo.
pause
del skrypty\orders.sql 
goto M3

:M32
set userinp1=
REM DODAJ PLIK REDOLOG
if exist skrypty\orders.sql del skrypty\orders.sql
echo.
echo.
set /p userinp1=Podaj numer grupy nowego pliku redolog i nacisnij ENTER:
if "%userinp1%"=="" goto M32
set userinp1=%userinp1:~0,2%
:M32a
echo.
set userinp2=
set /p userinp2=Podaj nazw© nowego pliku redolog wraz z scieæk• dost©pu i nacisnij ENTER:
if "%userinp2%"=="" goto M32a
:M32b
echo.
set userinp3=
set /p userinp3=Podaj wielkosÜ nowego pliku redolog (np. 30M) i nacisnij ENTER:
if "%userinp3%"=="" goto M32b
:M32c
set userinp=
echo.
set /p userinp=CZY CHCESZ DODAè PLIK REDOLOG? [t/n]:
set userinp=%userinp:~0,1%
if "%userinp%"=="n" goto M3
if "%userinp%"=="N" goto M3
if "%userinp%"=="t" goto M32d
if "%userinp%"=="T" goto M32d
goto M32c
:M32d
echo alter database add logfile group %userinp1% '%userinp2%' size %userinp3%;>>skrypty\orders.sql
rem echo spool off>>skrypty\orders.sql
echo exit>>skrypty\orders.sql    
%2sqlplus %1 @skrypty\orders.sql
echo.
pause
del skrypty\orders.sql 
goto M3

:M33
REM USU„ PLIK REDOLOG
set userinp1=
if exist skrypty\orders.sql del skrypty\orders.sql
echo.
echo.
set /p userinp1=Podaj numer grupy pliku redolog, kt¢ry chcesz usun•Üi nacisnij ENTER:
if "%userinp1%"=="" goto M33
set userinp1=%userinp1:~0,2%
:M33a
set userinp=
echo.
set /p userinp=CZY CHCESZ USUN§è PLIK REDOLOG? [t/n]:
set userinp=%userinp:~0,1%
if "%userinp%"=="n" goto M3
if "%userinp%"=="N" goto M3
if "%userinp%"=="t" goto M33b
if "%userinp%"=="T" goto M33b
goto M33a
:M33b
echo alter database drop logfile group %userinp1%;>>skrypty\orders.sql
rem echo spool off>>skrypty\orders.sql
echo exit>>skrypty\orders.sql    
%2sqlplus %1 @skrypty\orders.sql
echo.
pause
del skrypty\orders.sql 
goto M3


:M4
rem echo select* from v$recovery_file_dest;>>skrypty\orders.sql
rem echo exit>>skrypty\orders.sql    
rem %2sqlplus %1 @skrypty\orders.sql
cls
echo.
echo.
echo   SPAWDZANIE ZAJ®TOóCI OBSZARU "FRA"
echo ================================================================
echo.
echo.   
%2rman target %1 @skrypty\RMANparameters.sql
PAUSE
del skrypty\orders.sql 
goto MENU

:M5
rem echo select * from v$recovery_file_dest;>>skrypty\orders.sql
rem echo exit>>skrypty\orders.sql    
rem %2sqlplus %1 @skrypty\orders.sql
cls
echo.
echo.
echo   SPAWDZANIE ZAJ®TOóCI OBSZARU "FRA"
echo ================================================================
echo.
echo.   
%2sqlplus %1 @skrypty\FRAusage.sql
PAUSE
del skrypty\orders.sql 
goto MENU

:M6
cls
echo.
echo.
echo   SPAWDZANIE LISTY PLIK‡W PRZESTARZAùYCH (DO USUNI®CIA) WE "FRA"
echo ================================================================
echo.
echo.   
%2rman target %1 @skrypty\ReportObsolete.sql
echo.
pause
goto MENU

:M7
cls
echo.
echo.
echo   USUNI®CIE PLIK‡W PRZESTARZAùYCH z "FRA"
echo ==============================================================
echo.
echo.   
%2rman target %1 @skrypty\DeleteObsolete.sql
echo.
pause
goto MENU

:M8
cls
echo.
echo.
echo   PEùNY BACKUP BAZY DANYCH
echo ==============================================================
echo.
echo.
set rmanparam=
echo W jakim katalogu ma byÜ zapisana kopia bazy danych?
echo Zostaw wartosÜ pust• aby zarchiwizowaÜ do domyslnego katalogu.
echo.
set /p rmanparam=Wprowad´ scieæk© i wcisnij ENTER:
rem if "%rmanparam%"=="" set rmanparam=c:\kopia
echo.
echo.
set /p userinp=CZY NA PEWNO CHCESZ WYKONAè KOPI® BAZY DANYCH? [t/n]:
set userinp=%userinp:~0,1%
if "%userinp%"=="t" goto M81
if "%userinp%"=="n" goto MENU
goto M8

:M81
if exist skrypty\orders.sql del skrypty\orders.sql 
cls
echo.
echo.
echo   ROZPOCZ®CIE WYKONYWANIA BACKUPU...
echo ==============================================================
echo.
echo.   
if "%rmanparam%"=="" goto KROK83   
:KROK82
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
goto KROK84
:KROK83
echo sql 'alter system switch logfile';>>skrypty\orders.sql
echo backup as compressed backupset database;>>skrypty\orders.sql
echo sql 'alter system switch logfile';>>skrypty\orders.sql
echo backup archivelog all;>>skrypty\orders.sql
echo backup spfile;>>skrypty\orders.sql
rem echo backup spfile;>>skrypty\orders.sql
echo crosscheck backup;>>skrypty\orders.sql
echo crosscheck archivelog all;>>skrypty\orders.sql
echo delete noprompt expired backupset;>>skrypty\orders.sql
echo delete noprompt expired archivelog all;>>skrypty\orders.sql
echo backup current controlfile;>>skrypty\orders.sql
:KROK84       
%2rman target %1 @skrypty\orders.sql
echo.
echo.
echo ==============================================================
echo   BACKUP ZAKO„CZONY.
echo.
echo.
pause
if exist skrypty\orders.sql del skrypty\orders.sql
goto MENU

:CREDENTIALS_ERROR
echo. 
echo. 
echo    NIEPRAWIDùOWE URUCHOMIENIE SKRYPTU
echo.
echo    W celu uæycia skryptu naleæy wykonaÜ komend©:
echo        quickrman.bat uæytkownik/hasào@instancja [òcieæka]
echo.
echo    gdzie:
echo        uæytkownik - to nazwa uæytkownika z prawami administratora np. system
echo        hasào - hasào uæytkownika z prawami administratora
echo        instancja - nazwa instancji bazy danych np. orcl
echo        [òcieæka] - opcjonalny parametr - lokalizacja katalogu bin serwera bazy danych
echo          ze znakiem "\" na ko‰cu, np. "c:\app\Administrator\product\11.2.0\dbhome_1\BIN\".
echo          ócieæka powinna byÜ podana w podw¢jnym cudzysàowiu (");
echo.
echo.
pause
goto END

:END
rem Usuwanie zmiennych srodowiskowych
set userinp=
set rmanfrafoldest=
set rmanparam=
set userinp1=
set userinp2=
set userinp3=
if exist skrypty\orders.sql del skrypty\orders.sql