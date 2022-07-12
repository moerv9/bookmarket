# Technische Umsetzung
Der Code ist nach dieser [Idee](https://medium.com/flutter-community/flutter-code-organization-revised-b09ad5cef7f6) organisiert:
In der "main.dart"-Datei wird zunächst der Login-Ablauf gestartet. Falls dieser durchläuft und der Nutzer angemeldet ist, wird die App in der "app.dart" erstellt und die einzelnen Seiten, die über die Bottom Bar aufrufbar sind initialisiert.

## Lib-Ordner
Die nachfolgenden Abschnitte beschreiben je einen Ordner in dem lib-Ordner(./lib)

### Assets
In diesem Ordner befinden sich die Schriftarten, das selbsterstellte Appicon, sowie ein Fallback Profilbild.

### Components
Hier befinden sich die Komponenten, die überall im Code wiederverwendet werden können.
Dies können Widgets oder UI-Elemente sein. In dem Projekt waren dies zum Beispiel. :
* einzelne Chat-Nachricht, sowie die Übersicht des einzelnen Chats
* verschiedene Listenkomponenten für die einzelnen Listenseiten
* Einstellungs-Widgets für die Profilseite
* die Komponente für das manuelle hochladen von Buchcover
* Profilbild-Komponente

### Models
In dem Models-Ordner befinden sich die selbstgeschriebenen Klassen. Hier findet man die Elemente, die in den einzelnen Seiten verwendet werden.
So befindet sich hier die allgemeine Klasse [BookItems](../lib/models/books_db.dart). Daten aus der [Firebase Datenbank](Firebase.md#books-sammlung) werden in diesem Typ abgespeichert und verarbeitet. In der Klasse findet man alle Attribute eines Buches, sowie zugehörige Hilfsmethoden, um mit Firebase zu kommunizieren (z.B. Buch zur DB hinzufügen).
Dasselbe passiert in der Chats_DB-Klasse für alle Attribute und Methoden des Chats.
Die Klasse [ApiBook](../lib/models/api_book.dart) wird bei der direkten Abfrage von Büchern aus der [API](API.md) verwendet.


### Screens
In diesem Ordner befinden sich alle wichtigen Seiten der App:
* Die Profile-Seite
* Die Login-Seite, die beim Start der App zuerst angezeigt wird, wenn noch kein User eingeloggt ist.
* In dem Profil-Edit Ordner sind die Seiten, die für das Bearbeiten der Profilseite benötigt werden.
* In dem Chat-Ordner befindet sich die Übersicht-Seite aller Chats und der einzelne Chat.
* In dem Books-Ordner befinden sich die jeweilige Übersichtsseite und Suchseite für Wunschliste und Bücherliste.

### Services
Hier befinden sich Klassen die Abfragen bei APIs, Datenbanken und weiteren Produkten regeln.
Die Login-Seite benutzt die "authentification" Klasse, die den gesamten Registration-/Anmelde-Ablauf handhabt.
In der FirebaseApi Klasse sind ausgelagerte Firebase Methoden.
Um Bücher bei der Google Books API abzufragen, wird in der "api_connection.dart"-Datei die Abfrage gestartet und aus der Antwort eine verwendbare Liste erzeugt.

### Theme
Die App soll überall einen [gleichen Style (Corporate Identity mit Schriftart, Farben und Design)](Design.md#design) besitzen, deswegen wird dieses ausgelagert und kann überall im Code aufgerufen werden. Es wird für alle Plattformen der Cupertino Style von Apple verwendet.

## NICE TO KNOW
### Wichtig bei Flutter Installation auf dem Mac
Füge folgendes zur .bash_profile (Achtung, versteckte Datei) in deinem User-Ordner hinzu, damit die Flutter SDK permanent gesetzt wird:

    # added to include Flutter SDK permanently
    export PATH="$PATH:PATH_TO_DOWNLOADED_FLUTTER_FOLDER/bin"
