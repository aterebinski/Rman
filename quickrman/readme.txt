SKRYPT quickrman.bat
...................................................................................................

       Quick RMAN - Skrypt u≥atwiajπcy konfiguracjÍ i zarzπdzanie
                kopiami bezpieczeÒstwa w trybie ARCHIVELOG. 
...................................................................................................  

Autor: Adam TerebiÒski, KAMSOFT S.A., Wydzia≥ WdroøeÒ i Wsparcia Biznesowego, 6150 - Sekcja Konin.
...................................................................................................

ZA£OØENIA: Przyúpieszenie konfiguracji trybu ARCHIVELOG w bazie danych Oracle 10g i nowszych, na komputerach z systemem Windows. 
    
Uwaga 1: Skrypt przeznaczony jest dla osÛb zorientowanych w administrowaniu i obs≥udze baz danych Oracle oraz znajπcych zagadnienia trybu Archivelog. Niew≥aúciwe uøycie tego skryptu moøe prowadziÊ do zatrzymania bazy danych i problemÛw z jej ponownym uruchomieniem.

Uwaga 2: W przypadku pierwszej konfiguracji trybu Archivelog na serwerze, zaleca siÍ skorzystanie ze skryptu-kreatora rmanwizzard.bat.

Uwaga 3: Uøytkownik moøe w kaødej chwili zakoÒczyÊ dzia≥anie skryptu, uøywajπc kombinacji klawiszy Ctrl + C.

Uwaga 4: Jesli podczas dzia≥ania skryptu pojawiajπ siÍ b≥Ídy ORA-12560: 
	 TNS- b≥πd adaptera protoko≥u, podaj sciezke dostepu do katalogu bin serwera Oracle
	 jako drugi paramametr podczas wywolania skryptu:
		quickrman.bat uøytkownik/has≥o@instancja úcieøka
	 ,gdzie úcieøka - lokalizacja katalogu bin serwera bazy danych
	 ze znakiem "\" na koÒcu, np. "c:\app\Administrator\product\11.2.0\dbhome_1\BIN\" 
..................................................................................................

UØYCIE: w celu uøycia skryptu naleøy wykonaÊ komendÍ:
	quickrman.bat uøytkownik/has≥o@instancja [úcieøka]

	gdzie:
	uøytkownik - to nazwa uøytkownika z prawami administratora np. system
	has≥o - has≥o uøytkownika z prawami administratora
	instancja - nazwa instancji bazy danych np. orcl
	[úcieøka] - opcjonalny parametr - lokalizacja katalogu bin serwera bazy danych
		    ze znakiem "\" na koÒcu, np. "c:\app\Administrator\product\11.2.0\dbhome_1\BIN\"



OPIS:

Menu g≥Ûwne skryptu quickrman podzielone jest na dwie sekcje: Konfiguracja trybu Archivelog i Zarzπdzanie kopiami bezpieczeÒstwa. 

A. KONFIGURACJA TRYBU ARCHIVELOG.

1. Status/W≥πczenie/Wy≥πczenie trybu Archivelog. 
   Skrypt sprawdza czy w bazie danych uruchomiony jest tryb Archivelog. W zaleønoúci od zwrÛconej odpowiedzi na zapytanie, tryb archivelog jest w≥πczony (ARCHIVELOG), lub wy≥πczony (NOARCHIVELOG).

   Korzystajπc z menu moøna w≥πczyÊ lub wy≥πczyÊ tryb Archivelog. Uøytkownik zostanie poproszony o podanie identyfikatora SID instancji.
   Uwaga!: W≥πczenie lub wy≥πczenie trybu Archivelog spowoduje wy≥πczenie i ponowne w≥πczenie bazy danych.

2. Sprawdzenie/Konfiguracja parametrÛw trybu Archivelog.
   W tym menu uøytkownik ma moøliwoúÊ sprawdzenia lub zmiany nastÍpujπcych parametrÛw:
     a) LOG_ARCHIVE_DEST_N - zbiÛr parametrÛw, ktÛry definiuje zestaw katalogÛw docelowych zarchiwizowanego dziennika powtÛrzeÒ. Kaødπ lokalizacjÍ moøna zdefiniowaÊ jako opcjonalnπ lub obowiπzkowπ dodajπc na koÒcu úcieøki opcjÍ OPTIONAL lub MANDATORY (np. C:\ARCHIVELOG MANDATORY).åcieøki powinny wskazywaÊ katalogi na lokalnych dyskach. Dyski sieciowe nie sπ obs≥ugiwane (https://forums.oracle.com/message/2139350). Istnieje moøliwoúÊ, aby zarchiwizowane dzienniki powtÛrzeÒ korzysta≥y zarÛwno z lokalizacji okreúlonych w parametrach log_archive_dest_N, jak i z obszaru FRA, ktÛrego lokalizacja okreúlona jest w parametrze db_recovery_file_dest. W tym celu w jednym z parametrÛw log_archive_dest_N naleøy wpisaÊ wyraz "fra" (spowoduje to wprowadzenie do parametru zmiennej LOCATION=USE_DB_RECOVERY_FILE_DEST).   
     b) LOG_ARCHIVE_DEST_STAT_N - zbiÛr parametrÛw okreúlajπcy, czy lokalizacje zdefiniowane w odpowiednich parametrach LOG_ARCHIVE_DEST_N, bÍdπ brane pod uwagÍ w procesie zapisywania zarchiwizowanych dziennikÛw powtÛrzeÒ. W przypadku ustawienia danego parametru na ENABLE, proces ARCH bÍdzie archiwizowa≥ dzienniki powtÛrzeÒ do odpowiedniego katalogu log_archive_dest_N. W przypadku ustawienia parametru na DEFER, katalog powyøszy nie bÍdzie brany pod uwagÍ w procesie archiwizacji dziennikÛw powtÛrzeÒ. 
     c) DB_RECOVERY_FILE_DEST - parametr ten okreúla po≥oøenie katalogu z obszarem FRA (Flash Recovery Area), zawierajπcego nie tylko zarchiwizowane dzienniki powtÛrzeÒ, ale takøe pe≥ne kopie bazy danych, kopie przyrostowe, kopie zarchiwizowanych dziennikÛw powtÛrzeÒ, kopie zapasowe pliku kontrolnego i pliku parametrÛw.
     d) DB_RECOVERY_FILE_DEST_SIZE - okreúla maksymalny rozmiar folderu zawierajπcego FRA. 
        Uwaga!: Jeúli wielkoúÊ katalogu przekroczy wielkoúÊ zdefiniowanπ w tym parametrze, baza danych zatrzyma siÍ. W przypadku takiej sytuacji, aby ponownie uruchomiÊ bazÍ danych, trzeba zwiÍkszyÊ parametr DB_RECOVERY_FILE_DEST_SIZE, wy≥πczyÊ tryb Archivelog lub usunπÊ fizycznie czÍúÊ plikÛw w obszarze FRA. W przypadku okreúlania parametru DB_RECOVERY_FILE_DEST_SIZE, naleøy dodaÊ literÍ "G" lub "M" w celu poinformowania silnika bazy danych o jednostkach wielkoúci folderu (np. 100G - 100 gigabajtÛw).
     e) LOG_ARCHIVE_FORMAT - okreúla szablon nazw uøywany dla zarchiwizowanych dziennikÛw powtÛrzeÒ.
     f) LOG_ARCHIVE_MIN_SUCCEED_DEST - okreúla minimalnπ liczbÍ kopii katalogÛw docelowych zarchiwizowanych dziennikÛw powtÛrzeÒ, ktÛre muszπ byÊ wykonane, aby Oracle mÛg≥ ponownie wykorzystaÊ wybrany bieøπcy dziennik powtÛrzeÒ.

3. Sprawdzenie/Konfiguracja plikÛw Redolog.
   W tym miejscu uøytkownik moøe sprawdziÊ parametry plikÛw dziennika powtÛrzeÒ (redolog) w dwÛch zestawieniach. Pierwsze pokazuje po≥oøenie plikÛw z odpowiednich grup redolog oraz ich status (online, offline).
   Drugie zestawienie pozwala zorientowaÊ siÍ m.in. w statusie, wielkoúci i numerze sekwencji poszczegÛlnych redologÛw.
   Poniøej znajduje siÍ menu, dziÍki ktÛremu moøemy prze≥πczyÊ redolog na kolejny oraz dodaÊ lub usunπÊ redolog. 

B. ZARZ•DZANIE KOPIAMI BEZPIECZE—STWA.

4. Sprawdzanie zajÍtoúci obszaru FRA.
   Wybierajπc ta opcjÍ, uøytkownik moøe sprawdziÊ rozmiar, jaki zajmuje obszar Flash Recovery Area.   Pierwsze zestawienie ukazuje nam: úcieøkÍ do obszaru FRA (parametr DB_RECOVERY_FILE_DEST), limit wielkoúci obszaru FRA w MB (ustalany na podstawie parametru DB_RECOVERY_FILE_DEST_SIZE), wielkoúÊ aktualnych danych w obszarze FRA, wielkoúÊ przestarza≥ych danych w obszarze FRA oraz iloúÊ plikÛw w obszarze FRA.
   Drugie, bardziej szczegÛ≥owe zestawienie pokazuje procentowy udzia≥ plikÛw uøytych (PERCENT_SPACE_USED)i przeznaczonych do usuniÍcia (PERCENT_SPACE_RECLAIMABLE), w stosunku do zadeklarowanej, ca≥kowitej wielkoúci obszaru FRA (parametr DB_RECOVERY_FILE_DEST_SIZE) oraz iloúÊ tych plikÛw podzielonych na rodzaje(pliki kontrolne, pliki zarchiwizowane dzienniki powtÛrzeÒ, itd.).   
     
5. Sprawdzenie listy plikÛw przestarza≥ych (do usuniÍcia) we FRA.
   W tym miejscu uøytkownik moøe przejrzeÊ listÍ plikÛw ze statusem "OBSOLETE" (przestarza≥y). Sπ to pliki, z  ktÛrych dane znajdujπ siÍ juø w nowszych kopiach bezpieczeÒstwa.
6. Usuwanie przestarza≥ych plikÛw z FRA
   Ta opcja pozwala usunπÊ niepotrzebne, przestarza≥e pliki kopii bezpieczeÒstwa.
7. Wykonanie pe≥nego BACKUPu.
   Wybierajπc tπ opcjÍ uøytkownik ma moøliwoúÊ wykonania pe≥nej kopii bazy danych. Skrypt zapyta siÍ o miejsce docelowe, gdzie ma zapisaÊ pe≥nπ kopiÍ bazy danych. Jeúli podana lokalizacja nie bÍdzie istnia≥a, skrypt stworzy odpowiedni katalog. Pe≥na kopia zawiera: pliki z przestrzeniami tabel, plik kontrolny i plik  SPFILE. W pliku z rozszerzeniem BK1 znajduje siÍ kopia przestrzeni tabel, natomiast W pliku z rozszerzeniem BK2 znajduje siÍ kopia pliku kontrolnego i pliku SPFILE.


èrÛd≥o:
Oracle Database 10g. RMAN. Archiwizacja i odzyskiwanie danych. - Matthew Hart, Robert G. Freeman - Wydawnictwo Oracle Press. Helion 2008.
Strona internetowa: http://www.tidnab.nowaruda.net/oracle/329/redo-logs-%E2%80%93-czyli-transakcyjne-logi-bazy-danych.html
