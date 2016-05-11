SKRYPT rmanwizzard.bat
...................................................................................................

                   RMAN Wizzard - Archive Config 
        Kreator u�atwiaj�cy poprawne pierwsze skonfigurowanie
                       us�ugi ARCHIVELOG. 
...................................................................................................
  
Autor: Adam Terebi�ski, KAMSOFT S.A., Wydzia� Wdro�e� i Wsparcia Biznesowego, 6150 - Sekcja Konin.
...................................................................................................

ZA�O�ENIA: Uruchomienie us�ugi ARCHIVELOG w bazie danych Oracle 10g i nowszych, na komputerach z systemem Windows. Zaleca si� przechowywanie archiw�w w co najmniej dw�ch lokalizacjach (obszar FRA i co najmniej jedna inna lokalizacja).  
    
Uwaga 1: Skrypt przeznaczony jest dla os�b zorientowanych w administrowaniu i obs�udze baz danych Oracle oraz znaj�cych zagadnienia trybu Archivelog. Niew�a�ciwe u�ycie tego skryptu mo�e prowadzi� do zatrzymania bazy danych i problem�w z jej ponownym uruchomieniem. Skrypt ma na celu przy�pieszenie i u�atwienie konfiguracji trybu Archivelog.

Uwaga 2: Ten skrypt powsta� z my�l� o pierwszej konfiguracji ARCHIVELOG. W przypadku bardziej zaawansowanej konfiguracji trybu Archivelog zaleca si� skorzystanie ze skryptu quickrman.bat

Uwaga 3: U�ytkownik mo�e w ka�dej chwili zako�czy� dzia�anie skryptu, u�ywaj�c kombinacji klawiszy Ctrl + C.

Uwaga 4: Wszystkie dane wprowadzone przez u�ytkownika zostan� wprowadzone do bazy w jednej iteracji pod koniec dzia�ania skryptu. Wymagane b�dzie wtedy ponowne uruchomienie bazy danych. 

Uwaga 5: Jesli podczas dzia�ania skryptu pojawiaj� si� b��dy ORA-12560: 
	 TNS- b��d adaptera protoko�u, podaj sciezke dostepu do katalogu bin serwera Oracle
	 jako drugi paramametr podczas wywolania skryptu:
		quickrman.bat u�ytkownik/has�o@instancja �cie�ka
	 ,gdzie �cie�ka - lokalizacja katalogu bin serwera bazy danych
	 ze znakiem "\" na ko�cu, np. "c:\app\Administrator\product\11.2.0\dbhome_1\BIN\" 
...................................................................................................

U�YCIE: w celu u�ycia skryptu nale�y wykona� komend�:
	quickrman.bat u�ytkownik/has�o@instancja [�cie�ka]

	gdzie:
	u�ytkownik - to nazwa u�ytkownika z prawami administratora np. system
	has�o - has�o u�ytkownika z prawami administratora
	instancja - nazwa instancji bazy danych np. orcl
	[�cie�ka] - opcjonalny parametr - lokalizacja katalogu bin serwera bazy danych
		    ze znakiem "\" na ko�cu, np. "c:\app\Administrator\product\11.2.0\dbhome_1\BIN\"



OPIS:

W pierwszym kroku skrypt wypisze domy�lne parametry obszaru FRA (Flash Recovery Area), w kt�rym  b�d� przechowywane Archivelogi i kopie bazy danych wykonywane przez RMAN (Recovery Manager), gdzie :
DB_RECOVERY_FILE_DEST - to folder, w kt�rym przechowywane b�d� dane obszaru FRA,
DB_RECOVERY_FILE_DEST_SIZE - maksymalna wielko�� folderu z FRA.
U�ytkownik mo�e zachowa� domy�lne ustawienia lub zdecydowa� si� na ich zmian�.
Uwaga: Nale�y zwr�ci� szczeg�ln� uwag� na parametr DB_RECOVERY_FILE_DEST_SIZE. Je�li wielko�� obszaru FRA przekroczy ten parametr, baza danych zatrzyma si�.
W przypadku okre�lania parametru DB_RECOVERY_FILE_DEST_SIZE, nale�y doda� liter� "G" lub "M" w celu poinformowania silnika bazy danych o jednostkach wielko�ci folderu (np. 100G - 100 gigabajt�w).

W drugim kroku nale�y okre�li�, w ilu dodatkowych folderach maj� by� przechowywane kopie archivelog�w. Zaleca si� zdefiniowanie przynajmniej jednego dodatkowego folderu.

W trzecim kroku zostaj� przedstawione wszystkie parametry wprowadzone przez u�ytkownika. Do tej pory wszystkie dane nie zosta�y wprowadzone do bazy. Zostaje postawione pytanie, czy na pewno wprowadzi� dane do systemu. Je�li odpowied� jest twierdz�ca, u�ytkownik zostaje poproszony o podanie identyfikatora SID instancji. Po wprowadzeniu identyfikatora SID instancji, skrypt zmienia parametry bazy na podstawie danych wprowadzonych przez u�ytkownika. Logi z tej operacji b�d� znajdowa�y si� w pliku rmanwizzard.log.
Uwaga: Po wykonaniu trzeciego kroku baza danych zostanie ponownie uruchomiona. Spowoduje to roz��czenie sesji u�ytkownik�w pracuj�cych aktualnie na bazie danych.
R�wnie� w tym kroku w katalogu "c:\archskrypt" zostaj� umieszczone pliki "backup.sql" i "backup.bat" s�u��ce do wykonywania pe�nej kopii zapasowej. Pliki mo�na przenie�� w inne miejsce. Je�li z jakich� powod�w pliki nie zostan� skopiowane, znajduj� si� one w podkatalogu katalogu "skrypty" bie��cego folderu. Aby skonfigurowa� automatyczne wykonywanie kopii zapasowej, nale�y doda� wykonywanie pliku backup.bat do "Harmonogramu zada�" lub do "Zaplanowanych zada�".

W czwartym kroku u�ytkownik ma mo�liwo�� wykonania pe�nego backupu. Jest to czynno�� zalecana z uwagi na to, i� w przypadku awarii dysku, odtworzenie bazy z archivelog�w na innym serwerze, wymaga posiadania pe�nej kopii bazy danych. Skrypt zapyta si� o miejsce docelowe, gdzie ma zapisa� pe�n� kopi� bazy danych. Je�li u�ytkownik nie poda lokalizacji, kopia bazy zapisze si� w domy�lnej lokalizacji. Je�li podana lokalizacja nie b�dzie istnia�a, skrypt stworzy odpowiedni katalog.


�r�d�o:
Oracle Database 10g. RMAN. Archiwizacja i odzyskiwanie danych. - Matthew Hart, Robert G. Freeman - Wydawnictwo Oracle Press. Helion 2008.
Strona internetowa: http://www.tidnab.nowaruda.net/oracle/329/redo-logs-%E2%80%93-czyli-transakcyjne-logi-bazy-danych.html


