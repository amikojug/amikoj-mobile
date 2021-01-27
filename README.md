# AMIKOJ | Projekt Zespołowy

## Spis treści

-   Opis projektu
-   Podział pracy 
-   Technologie
-   Architektura projektu
-   Zakres funkcjonalności
-   Wymogi techniczne
-   Diagramy
-   Testy

## Opis projektu

**Tytuł:** Amikoj

**Kategoria:** Gra towarzyska

**Platforma:** Android

Aplikacja mobilna Amikoj pozwala na przeprowadzenie wspólnej rozgrywki umożliwiającej lepsze poznanie siebie oraz swoich znajomych poprzez odpowiadanie na ciekawe pytania.
Gracze po utworzeniu oraz dołączeniu do pokoju rozpoczynają rozgrywkę polegającą na rozegraniu kilku rund starając się zdobyć jak najwyższą liczbę puntów.
W pojedynczej rundzie wyznaczyć można dwie grupy graczy:
- gracz pytany (jedna osoba),
- gracze odpowiadający (pozostałe osoby).

Dla obu wspomnianych grup wyświetlane jest to samo pytanie oraz 3 odpowiedzi. Zadaniem osoby pytanej jest wybranie jednej z trzech odpowiedzi - tej która najbardziej pasuje do osoby pytanej. Natomiast zadaniem innych graczy jest próba odgadnięcia wyboru osoby pytanej. Punkty zdobywają gracze, którzy poprawnie wytypowali odpowiedź jakiej udzieliła osoba pytana. Gracz, który najlepiej poznał swoich znajmowych (zdobył najwięcej punktów), zostaje zwycięzcą.


## Podział pracy
Kacper Dondziak:
- wygenerowanie projektu
- tworzenie layoutów
- dodawanie avatara
- struktura pokoju
- tworzenie pokoi
- dołączanie do pokoju
- wychodzenie z pokoju
- responsywna liczba graczy widoczna u każdego gracza
- komunikacja po gniazdach
- dodanie menegera stanu (redux)
- zgłaszanie gotowości przez graczy
- usuwanie graczy przez hosta
- tworzenie rozgrywki
- timer podczas rozgrywki
- zakończenie rozgrywki


Natalia Dębska:
- wygenerowanie backendu
- logowanie anonimowe
- rejestracja i logowanie za pomocą utworzonego konta
- walidacja formularza podczas rejestracji
- logowanie za pomocą Googla
- logowanie za pomocą Facebooka
- obsługa wylogowania użytkownika
- tworzenie layoutów
- warunkowe dobieranie współczynników
- walidacja nazwy pokoju podczas tworzenia pokoju
- walidacja nazwy pokoju podczas dołączania do pokoju
- walidacja startu rozgrywki
- kolejkowanie pytań
- kolejkowanie graczy


## Technologie
Technologie wykorzystane w projekcie:
- Flutter - frontend
- Firebase - backend


## Architektura projektu



## Zakres funkcjonalności

### Logowanie i rejestracja
1. Użytkownik może zajerestrować się do aplikacji poprzez podanie:
  - adresu email
  - hasła do konta
    - wymagane powtórzenie hasła w celu weryfikacji zgodności obu podanych haseł
    
2. Użytkownik może zalogować się do aplikacji poprzez:
  - anonimowo
  - utworzone konto
  - Facebook
  - Google

### Pasek nawigacji
1. Na górze ekranu aplikacji znajduje się pasek nawigacyjny z funkcjami:
  - wylogowanie 
  - dostęp do panelu konta
    - zmiana avataru
    - zmiana nazwy użytkownika

### Tworzenie i dołączanie do pokoi
1. Zalogowany użytkownik może utworzyć pokój
  - niezbędne jest nadanie nazwy tworzonemu pokoju według wytycznych
    - nazwa pokoju nie może być dłuższa niż 20 znaków
    - nazwa pokoju nie może być pusta
    - nazwa pokoju musi być rózna od nazw pokojów już istniejących
  - gracz tworzący pokój staje się hostem
  
2. Zalogowany użytkownik może dołączyć do istniejącego pokoju
  - niezbędne jest wpisanie nazwy pokoju a użytkownik dołączy do pokoju gdy
    - nazwa pokoju będzie poprawna a pokój o takiej nazwie już istnieje
    - w istniejącym pokoju, do którego użytkownik chce dołaczyć nie występuje gracz o takiej samej nazwie użytkownika

### Widok pokoju
1. Użytkownik będący hostem może rozpocząć rozgrywkę gdy
  - w pokoju znajduje się więcej niz jeden gracz 
  - wszycy gracze niebędacy hostem zgłoszą gotowość do rozgrywki

2. Użytkownik dołączający do pokoju może zgłosić gotowość do rozgrywki 

3. Gracz będący hostem może usunąć niechcianych graczy z pokoju 

### Rozgrywka
1. Rozgrywka polega na przeprowadzeniu 6 rund, w których wyświetlone jest pytania oraz trzy odpowiedzi

2. Gracze podzieleni są na
  - osobę pytaną - jednen gracz 
    - gracz będący osobą pytaną informowany jest o tym poprzez zmianę koloru obramowania pola z pytaniem na kolor żółty 
    - zadaniem osoby pytanej jest udzielenie szczerej odpowiedzi na pytanie według własnych przekonań
    - po udzieleniu odpowiedzi gracz pytany dostaje informacje o udzieleniu odpowiedzi
  - osoby odpowiadające - pozostali gracz
    - gracze będący osobami odpowiadającymi informowani są o kim jest aktulane pytanie poprzez wyświetlaną informacje
    - zadaniem osób odpowiadających jest próba wytypowania odpowiedzi jakiej udzieliła osoba pytana
    - obramowanie pola z pytaniem u graczy odpowiadających pozostaje białe
    - po udzieleniu odpowiedzi przez gracza odpowiadającego zostaje wyświetlona informacja o poprawności odpowiedzi

3. Po zakończeniu rundy następuje zmiana osoby pytanej oraz zmiana pytania


### Zakończenie rozgrywki
1. Rozgrywka kończy się po zadaniu 6 pytań 
2. Wyświetlana jest tabela punktowa zawierająca informacje o zdobytych punkatch prez poszczególnych graczy


## Wymogi techniczne
1. Aplikacja została utworzona na platformę Android
2. Aplikacja przeznaczona jest do użytku na smartfonach w orientacji portretowej
3. Aplikacja działa podczas połączenia z Internetem


## Diagramy z inżynierii



### Diagram klas



### Diagram ERD



### Diagram przypadków użycia



### Diagram aktorów



## Testy



