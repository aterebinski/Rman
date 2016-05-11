SKRYPT rmanwizzard.bat
...................................................................................................

                   RMAN Wizzard - Archive Config 
        Kreator u≥atwiajπcy poprawne pierwsze skonfigurowanie
                       us≥ugi ARCHIVELOG. 
...................................................................................................
  
Autor: Adam TerebiÒski, KAMSOFT S.A., Wydzia≥ WdroøeÒ i Wsparcia Biznesowego, 6150 - Sekcja Konin.
...................................................................................................

ZA£OØENIA: Uruchomienie us≥ugi ARCHIVELOG w bazie danych Oracle 10g i nowszych, na komputerach z systemem Windows. Zaleca siÍ przechowywanie archiwÛw w co najmniej dwÛch lokalizacjach (obszar FRA i co najmniej jedna inna lokalizacja).  
    
Uwaga 1: Skrypt przeznaczony jest dla osÛb zorientowanych w administrowaniu i obs≥udze baz danych Oracle oraz znajπcych zagadnienia trybu Archivelog. Niew≥aúciwe uøycie tego skryptu moøe prowadziÊ do zatrzymania bazy danych i problemÛw z jej ponownym uruchomieniem. Skrypt ma na celu przyúpieszenie i u≥atwienie konfiguracji trybu Archivelog.

Uwaga 2: Ten skrypt powsta≥ z myúlπ o pierwszej konfiguracji ARCHIVELOG. W przypadku bardziej zaawansowanej konfiguracji trybu Archivelog zaleca siÍ skorzystanie ze skryptu quickrman.bat

Uwaga 3: Uøytkownik moøe w kaødej chwili zakoÒczyÊ dzia≥anie skryptu, uøywajπc kombinacji klawiszy Ctrl + C.

Uwaga 4: Wszystkie dane wprowadzone przez uøytkownika zostanπ wprowadzone do bazy w jednej iteracji pod koniec dzia≥ania skryptu. Wymagane bÍdzie wtedy ponowne uruchomienie bazy danych. 

Uwaga 5: Jesli podczas dzia≥ania skryptu pojawiajπ siÍ b≥Ídy ORA-12560: 
	 TNS- b≥πd adaptera protoko≥u, podaj sciezke dostepu do katalogu bin serwera Oracle
	 jako drugi paramametr podczas wywolania skryptu:
		quickrman.bat uøytkownik/has≥o@instancja úcieøka
	 ,gdzie úcieøka - lokalizacja katalogu bin serwera bazy danych
	 ze znakiem "\" na koÒcu, np. "c:\app\Administrator\product\11.2.0\dbhome_1\BIN\" 
...................................................................................................

UØYCIE: w celu uøycia skryptu naleøy wykonaÊ komendÍ:
	quickrman.bat uøytkownik/has≥o@instancja [úcieøka]

	gdzie:
	uøytkownik - to nazwa uøytkownika z prawami administratora np. system
	has≥o - has≥o uøytkownika z prawami administratora
	instancja - nazwa instancji bazy danych np. orcl
	[úcieøka] - opcjonalny parametr - lokalizacja katalogu bin serwera bazy danych
		    ze znakiem "\" na koÒcu, np. "c:\app\Administrator\product\11.2.0\dbhome_1\BIN\"



OPIS:

W pierwszym kroku skrypt wypisze domyúlne parametry obszaru FRA (Flash Recovery Area), w ktÛrym  bÍdπ przechowywane Archivelogi i kopie bazy danych wykonywane przez RMAN (Recovery Manager), gdzie :
DB_RECOVERY_FILE_DEST - to folder, w ktÛrym przechowywane bÍdπ dane obszaru FRA,
DB_RECOVERY_FILE_DEST_SIZE - maksymalna wielkoúÊ folderu z FRA.
Uøytkownik moøe zachowaÊ domyúlne ustawienia lub zdecydowaÊ siÍ na ich zmianÍ.
Uwaga: Naleøy zwrÛciÊ szczegÛlnπ uwagÍ na parametr DB_RECOVERY_FILE_DEST_SIZE. Jeúli wielkoúÊ obszaru FRA przekroczy ten parametr, baza danych zatrzyma siÍ.
W przypadku okreúlania parametru DB_RECOVERY_FILE_DEST_SIZE, naleøy dodaÊ literÍ "G" lub "M" w celu poinformowania silnika bazy danych o jednostkach wielkoúci folderu (np. 100G - 100 gigabajtÛw).

W drugim kroku naleøy okreúliÊ, w ilu dodatkowych folderach majπ byÊ przechowywane kopie archivelogÛw. Zaleca siÍ zdefiniowanie przynajmniej jednego dodatkowego folderu.

W trzecim kroku zostajπ przedstawione wszystkie parametry wprowadzone przez uøytkownika. Do tej pory wszystkie dane nie zosta≥y wprowadzone do bazy. Zostaje postawione pytanie, czy na pewno wprowadziÊ dane do systemu. Jeúli odpowiedü jest twierdzπca, uøytkownik zostaje poproszony o podanie identyfikatora SID instancji. Po wprowadzeniu identyfikatora SID instancji, skrypt zmienia parametry bazy na podstawie danych wprowadzonych przez uøytkownika. Logi z tej operacji bÍdπ znajdowa≥y siÍ w pliku rmanwizzard.log.
Uwaga: Po wykonaniu trzeciego kroku baza danych zostanie ponownie uruchomiona. Spowoduje to roz≥πczenie sesji uøytkownikÛw pracujπcych aktualnie na bazie danych.
RÛwnieø w tym kroku w katalogu "c:\archskrypt" zostajπ umieszczone pliki "backup.sql" i "backup.bat" s≥uøπce do wykonywania pe≥nej kopii zapasowej. Pliki moøna przenieúÊ w inne miejsce. Jeúli z jakichú powodÛw pliki nie zostanπ skopiowane, znajdujπ siÍ one w podkatalogu katalogu "skrypty" bieøπcego folderu. Aby skonfigurowaÊ automatyczne wykonywanie kopii zapasowej, naleøy dodaÊ wykonywanie pliku backup.bat do "Harmonogramu zadaÒ" lub do "Zaplanowanych zadaÒ".

W czwartym kroku uøytkownik ma moøliwoúÊ wykonania pe≥nego backupu. Jest to czynnoúÊ zalecana z uwagi na to, iø w przypadku awarii dysku, odtworzenie bazy z archivelogÛw na innym serwerze, wymaga posiadania pe≥nej kopii bazy danych. Skrypt zapyta siÍ o miejsce docelowe, gdzie ma zapisaÊ pe≥nπ kopiÍ bazy danych. Jeúli uøytkownik nie poda lokalizacji, kopia bazy zapisze siÍ w domyúlnej lokalizacji. Jeúli podana lokalizacja nie bÍdzie istnia≥a, skrypt stworzy odpowiedni katalog.


èrÛd≥o:
Oracle Database 10g. RMAN. Archiwizacja i odzyskiwanie danych. - Matthew Hart, Robert G. Freeman - Wydawnictwo Oracle Press. Helion 2008.
Strona internetowa: http://www.tidnab.nowaruda.net/oracle/329/redo-logs-%E2%80%93-czyli-transakcyjne-logi-bazy-danych.html


