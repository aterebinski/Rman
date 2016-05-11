SKRYPT quickrman.bat
...................................................................................................

       Quick RMAN - Skrypt u�atwiaj�cy konfiguracj� i zarz�dzanie
                kopiami bezpiecze�stwa w trybie ARCHIVELOG. 
...................................................................................................  

Autor: Adam Terebi�ski, KAMSOFT S.A., Wydzia� Wdro�e� i Wsparcia Biznesowego, 6150 - Sekcja Konin.
...................................................................................................

ZA�O�ENIA: Przy�pieszenie konfiguracji trybu ARCHIVELOG w bazie danych Oracle 10g i nowszych, na komputerach z systemem Windows. 
    
Uwaga 1: Skrypt przeznaczony jest dla os�b zorientowanych w administrowaniu i obs�udze baz danych Oracle oraz znaj�cych zagadnienia trybu Archivelog. Niew�a�ciwe u�ycie tego skryptu mo�e prowadzi� do zatrzymania bazy danych i problem�w z jej ponownym uruchomieniem.

Uwaga 2: W przypadku pierwszej konfiguracji trybu Archivelog na serwerze, zaleca si� skorzystanie ze skryptu-kreatora rmanwizzard.bat.

Uwaga 3: U�ytkownik mo�e w ka�dej chwili zako�czy� dzia�anie skryptu, u�ywaj�c kombinacji klawiszy Ctrl + C.

Uwaga 4: Jesli podczas dzia�ania skryptu pojawiaj� si� b��dy ORA-12560: 
	 TNS- b��d adaptera protoko�u, podaj sciezke dostepu do katalogu bin serwera Oracle
	 jako drugi paramametr podczas wywolania skryptu:
		quickrman.bat u�ytkownik/has�o@instancja �cie�ka
	 ,gdzie �cie�ka - lokalizacja katalogu bin serwera bazy danych
	 ze znakiem "\" na ko�cu, np. "c:\app\Administrator\product\11.2.0\dbhome_1\BIN\" 
..................................................................................................

U�YCIE: w celu u�ycia skryptu nale�y wykona� komend�:
	quickrman.bat u�ytkownik/has�o@instancja [�cie�ka]

	gdzie:
	u�ytkownik - to nazwa u�ytkownika z prawami administratora np. system
	has�o - has�o u�ytkownika z prawami administratora
	instancja - nazwa instancji bazy danych np. orcl
	[�cie�ka] - opcjonalny parametr - lokalizacja katalogu bin serwera bazy danych
		    ze znakiem "\" na ko�cu, np. "c:\app\Administrator\product\11.2.0\dbhome_1\BIN\"



OPIS:

Menu g��wne skryptu quickrman podzielone jest na dwie sekcje: Konfiguracja trybu Archivelog i Zarz�dzanie kopiami bezpiecze�stwa. 

A. KONFIGURACJA TRYBU ARCHIVELOG.

1. Status/W��czenie/Wy��czenie trybu Archivelog. 
   Skrypt sprawdza czy w bazie danych uruchomiony jest tryb Archivelog. W zale�no�ci od zwr�conej odpowiedzi na zapytanie, tryb archivelog jest w��czony (ARCHIVELOG), lub wy��czony (NOARCHIVELOG).

   Korzystaj�c z menu mo�na w��czy� lub wy��czy� tryb Archivelog. U�ytkownik zostanie poproszony o podanie identyfikatora SID instancji.
   Uwaga!: W��czenie lub wy��czenie trybu Archivelog spowoduje wy��czenie i ponowne w��czenie bazy danych.

2. Sprawdzenie/Konfiguracja parametr�w trybu Archivelog.
   W tym menu u�ytkownik ma mo�liwo�� sprawdzenia lub zmiany nast�puj�cych parametr�w:
     a) LOG_ARCHIVE_DEST_N - zbi�r parametr�w, kt�ry definiuje zestaw katalog�w docelowych zarchiwizowanego dziennika powt�rze�. Ka�d� lokalizacj� mo�na zdefiniowa� jako opcjonaln� lub obowi�zkow� dodaj�c na ko�cu �cie�ki opcj� OPTIONAL lub MANDATORY (np. C:\ARCHIVELOG MANDATORY).�cie�ki powinny wskazywa� katalogi na lokalnych dyskach. Dyski sieciowe nie s� obs�ugiwane (https://forums.oracle.com/message/2139350). Istnieje mo�liwo��, aby zarchiwizowane dzienniki powt�rze� korzysta�y zar�wno z lokalizacji okre�lonych w parametrach log_archive_dest_N, jak i z obszaru FRA, kt�rego lokalizacja okre�lona jest w parametrze db_recovery_file_dest. W tym celu w jednym z parametr�w log_archive_dest_N nale�y wpisa� wyraz "fra" (spowoduje to wprowadzenie do parametru zmiennej LOCATION=USE_DB_RECOVERY_FILE_DEST).   
     b) LOG_ARCHIVE_DEST_STAT_N - zbi�r parametr�w okre�laj�cy, czy lokalizacje zdefiniowane w odpowiednich parametrach LOG_ARCHIVE_DEST_N, b�d� brane pod uwag� w procesie zapisywania zarchiwizowanych dziennik�w powt�rze�. W przypadku ustawienia danego parametru na ENABLE, proces ARCH b�dzie archiwizowa� dzienniki powt�rze� do odpowiedniego katalogu log_archive_dest_N. W przypadku ustawienia parametru na DEFER, katalog powy�szy nie b�dzie brany pod uwag� w procesie archiwizacji dziennik�w powt�rze�. 
     c) DB_RECOVERY_FILE_DEST - parametr ten okre�la po�o�enie katalogu z obszarem FRA (Flash Recovery Area), zawieraj�cego nie tylko zarchiwizowane dzienniki powt�rze�, ale tak�e pe�ne kopie bazy danych, kopie przyrostowe, kopie zarchiwizowanych dziennik�w powt�rze�, kopie zapasowe pliku kontrolnego i pliku parametr�w.
     d) DB_RECOVERY_FILE_DEST_SIZE - okre�la maksymalny rozmiar folderu zawieraj�cego FRA. 
        Uwaga!: Je�li wielko�� katalogu przekroczy wielko�� zdefiniowan� w tym parametrze, baza danych zatrzyma si�. W przypadku takiej sytuacji, aby ponownie uruchomi� baz� danych, trzeba zwi�kszy� parametr DB_RECOVERY_FILE_DEST_SIZE, wy��czy� tryb Archivelog lub usun�� fizycznie cz�� plik�w w obszarze FRA. W przypadku okre�lania parametru DB_RECOVERY_FILE_DEST_SIZE, nale�y doda� liter� "G" lub "M" w celu poinformowania silnika bazy danych o jednostkach wielko�ci folderu (np. 100G - 100 gigabajt�w).
     e) LOG_ARCHIVE_FORMAT - okre�la szablon nazw u�ywany dla zarchiwizowanych dziennik�w powt�rze�.
     f) LOG_ARCHIVE_MIN_SUCCEED_DEST - okre�la minimaln� liczb� kopii katalog�w docelowych zarchiwizowanych dziennik�w powt�rze�, kt�re musz� by� wykonane, aby Oracle m�g� ponownie wykorzysta� wybrany bie��cy dziennik powt�rze�.

3. Sprawdzenie/Konfiguracja plik�w Redolog.
   W tym miejscu u�ytkownik mo�e sprawdzi� parametry plik�w dziennika powt�rze� (redolog) w dw�ch zestawieniach. Pierwsze pokazuje po�o�enie plik�w z odpowiednich grup redolog oraz ich status (online, offline).
   Drugie zestawienie pozwala zorientowa� si� m.in. w statusie, wielko�ci i numerze sekwencji poszczeg�lnych redolog�w.
   Poni�ej znajduje si� menu, dzi�ki kt�remu mo�emy prze��czy� redolog na kolejny oraz doda� lub usun�� redolog. 

B. ZARZ�DZANIE KOPIAMI BEZPIECZE�STWA.

4. Sprawdzanie zaj�to�ci obszaru FRA.
   Wybieraj�c ta opcj�, u�ytkownik mo�e sprawdzi� rozmiar, jaki zajmuje obszar Flash Recovery Area.   Pierwsze zestawienie ukazuje nam: �cie�k� do obszaru FRA (parametr DB_RECOVERY_FILE_DEST), limit wielko�ci obszaru FRA w MB (ustalany na podstawie parametru DB_RECOVERY_FILE_DEST_SIZE), wielko�� aktualnych danych w obszarze FRA, wielko�� przestarza�ych danych w obszarze FRA oraz ilo�� plik�w w obszarze FRA.
   Drugie, bardziej szczeg�owe zestawienie pokazuje procentowy udzia� plik�w u�ytych (PERCENT_SPACE_USED)i przeznaczonych do usuni�cia (PERCENT_SPACE_RECLAIMABLE), w stosunku do zadeklarowanej, ca�kowitej wielko�ci obszaru FRA (parametr DB_RECOVERY_FILE_DEST_SIZE) oraz ilo�� tych plik�w podzielonych na rodzaje(pliki kontrolne, pliki zarchiwizowane dzienniki powt�rze�, itd.).   
     
5. Sprawdzenie listy plik�w przestarza�ych (do usuni�cia) we FRA.
   W tym miejscu u�ytkownik mo�e przejrze� list� plik�w ze statusem "OBSOLETE" (przestarza�y). S� to pliki, z  kt�rych dane znajduj� si� ju� w nowszych kopiach bezpiecze�stwa.
6. Usuwanie przestarza�ych plik�w z FRA
   Ta opcja pozwala usun�� niepotrzebne, przestarza�e pliki kopii bezpiecze�stwa.
7. Wykonanie pe�nego BACKUPu.
   Wybieraj�c t� opcj� u�ytkownik ma mo�liwo�� wykonania pe�nej kopii bazy danych. Skrypt zapyta si� o miejsce docelowe, gdzie ma zapisa� pe�n� kopi� bazy danych. Je�li podana lokalizacja nie b�dzie istnia�a, skrypt stworzy odpowiedni katalog. Pe�na kopia zawiera: pliki z przestrzeniami tabel, plik kontrolny i plik  SPFILE. W pliku z rozszerzeniem BK1 znajduje si� kopia przestrzeni tabel, natomiast W pliku z rozszerzeniem BK2 znajduje si� kopia pliku kontrolnego i pliku SPFILE.


�r�d�o:
Oracle Database 10g. RMAN. Archiwizacja i odzyskiwanie danych. - Matthew Hart, Robert G. Freeman - Wydawnictwo Oracle Press. Helion 2008.
Strona internetowa: http://www.tidnab.nowaruda.net/oracle/329/redo-logs-%E2%80%93-czyli-transakcyjne-logi-bazy-danych.html
