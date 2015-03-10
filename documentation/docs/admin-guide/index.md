# Anleitung für den Administrator

Auf dieser Seite beschreiben wir kurz den Ablauf, was gemacht werden muss um die Daten der App auf dem aktuellen Stand zu behalten.

Zum Aktualisieren der Raumdaten und Raumpläne sind folgende Teilschritte notwendig:

1. Zuerst müssen die neuen CSV- und PDF-Dateien vom Referat IV.1 angefordert werden.
2. Anschließend muss man die PDFs in PNGs umwandeln, welche man für die manuelle Positionierung der Räume und die Generierung der Kacheln benötigt.
3. Der Positionierungsalgorithmus für die Räume muss serverseitig ausgeführt werden und kann entweder als REST-API angesprochen werden oder man speichert sich die JSON-Dateien ab.
4. Als vorletzter Schritt steht die Generierung der Kacheln an.
5. Nun müssen nur noch alle statischen Dateien veröffentlicht werden, damit die App den neuen Stand synchronisieren kann.

Unabhängig von den ersten Schritten kann man optional auch die Bilder der Gebäude aktualisieren.


## 1. CSV- und PDF-Dateien einlesen

Einmal pro Semester wird vom Referat IV.1 der LMU München der aktualisierte Datenbestand zur Verfügung gestellt. Dieser beinhaltet einen CSV-Export aus deren Gebäudeverwaltungsystem und alle WebPDF-Dateien, welche auch öffentlich auf der [LMU Webseite](http://www.uni-muenchen.de/ueber_die_lmu/standorte/lageplaene/index.html) verfügbar sind.

Alle wichtigen Schritte welche vom Referats IV.1 für den CSV- und PDF-Export zu berücksichtigen sind, haben wir in unserem Wiki zusammengefasst: [CSV-Dateien anfordern](https://github.com/lmu-navigator/data/wiki/CSV-Dateien-anfordern)

Diese Dateien bindet man nun bei der Entwicklungsumgebung ein und referenziert sie in der Tomcat-Instanz. Für weitere Infos zum Server, siehe _Developer Guide > Server_.

1. Zuerst die neuen CSV-Dateien über dieses [Upload-Formular](http://141.84.213.246:8080/lmu-navigator/upload/) in die Datenbank laden.
1. Anschließend alle PDFs mittels FTP/SFTP/SCP auf den Server ablegen.

Die CSV-Dateien müssen im folgenden Format vorliegen, damit sie automatisch in die Datenbank eingelesen werden können.
```
[01_Stadt.csv]        Stadtcode;Stadt;Dateiname
[02_Strasse.csv]      Stadtcode;Stadt;Dateiname
[03_Bauwerk.csv]      BWCode;Stadtcode;Straßencode;Benennung
[04_BauteilHaus.csv]  BTCode;Stadtcode;Straßencode;BWCode;BauteilHaus
[05_Geschoss.csv]     GCode;Stadtcode;Straßencode;BWCode;BTCode;Geschoss;Benennung;Dateiname
[06_Raum.csv]         GCode;Stadtcode;Straßencode;BWCode;BTCode;Geschoss;Benennung;Raumnummer;RCode;Dateiname
```


## 2. PDFs zu PNGs umwandeln

Als nächstes steht ein etwas mühsamerer Schritt an, es müssen alle PDFs in PNGs umgewandelt werden. Hierbei können einige Fehler auftreten. Eine Sammlung der häufigsten Fehler findet ihr in unserem GitHub-Wiki, welches nur für Projektmitglieder sichtbar ist: [PNG-Dateien generieren](https://github.com/lmu-navigator/data/wiki/PNG-Dateien-generieren)

1. Photoshop öffnen und dort die Aktionen gemäß den [Vorgaben im Wiki](https://github.com/lmu-navigator/data/wiki/PNG-Dateien-generieren) anlegen.
1. Mittels Stapelverarbeitung zuerst jeweils ca. 100 PDFs öffnen und mittels der zweiten Aktion automatisiert als PNG speichern lassen.
1. Nun die fertig umgewandelten PNGs auf den Server hochladen (zur Raumpositionierung) und als Ausgangsbasis für die Generierung der Kacheln verwenden (siehe )
1. Sicherstellen, dass [die Anwendung](http://141.84.213.246:8080/lmu-navigator/data/) auf die richtigen PDF-Ordner und PNG-Ordner verweist.
1. Die neuen PNG

Bisher haben wir diesen Schritt mit Photoshop umgesetzt, da dort die Qualität der PNGs zufriedenstellender war.


## 3. Räume positionieren & JSON-Export

Die Positionierung der Räume auf den PDFs erfolgt serverseitig. Dafür müssen die CSV-Dateien (Schritt 1) importiert worden sein und die PDF- + PNG-Dateien auf den Server hochgeladen worden sein (Schritt 2). Das Servlet zur Positionierung kann hier erreicht werden: [http://<tomcat-server>/lmu-navigator/data/](http://141.84.213.246:8080/lmu-navigator/data/).

1. Die PNG- und PDF-Pfade aktualisieren.
1. Die absolute Größe der PNG-Dateien bestimmen (calculate dimension of PNGs)
1. Nun entweder für die ersten Stockwerke einzeln den Algorithmus anwenden (in der Tabelle in der Spalte _positionRooms_ "automated" auswählen), oder gleich für die alle Räume den "batch update" durchführen.
1. Ggf. noch manuell korrigieren, falls ein Raum nicht korrekt positioniert wurde. Falls manche Räume gar nicht gefunden wurden, werden diese in der Spalte _notPos_ als rot angezeigt.
1. Alle Daten noch überprüfen, ob nicht doch ausversehen auf den ausgegrauten Flächen ein Raum positioniert wurde.

Diese Daten können bereits über die REST Schnittstelle (sehe Developer Guide > Server) angesprochen werden. Für den Produktiveinsatz sind wir aus Performance-Gründen den Umweg über statische Dateien gegangen.

Hierfür die REST API manuell aufrufen und manuell als JSON-Datei abspeichern.

* http://141.84.213.246:8080/lmu-navigator/rest/cities
* http://141.84.213.246:8080/lmu-navigator/rest/streets
* http://141.84.213.246:8080/lmu-navigator/rest/buildings
* http://141.84.213.246:8080/lmu-navigator/rest/buildingparts
* http://141.84.213.246:8080/lmu-navigator/rest/floors
* http://141.84.213.246:8080/lmu-navigator/rest/rooms


## 4. Tiles generieren

TODO: PNG zu MBTiles umwandeln, siehe Skript

## 5. Alle Daten deployen

Zum Deployen der aufbereiteten Daten für die Android- und iOS-Apps genügt es die folgenden Daten in das LMU Navigator github.io-Repository zu pushen. Die Apps prüfen in regelmäßigen Abständen ob es Neuerungen auf dem Server gibt.

```
  /data/json/    # aus Schritt 3
  /data/tiles/   # aus Schritt 4
  /data/photos/  # siehe unten

```

## Neue Bilder einbinden

Die Gebäudebilder liegen wie alle anderen statischen Dateien auf unserer github.io-Seite und können über folgenden Pfad angesprochen werden: [http://lmu-navigator.github.io/data/photos/](https://github.com/lmu-navigator/lmu-navigator.github.io/tree/master/data/photos)

Die Bilder sind nach dem Bauwerk-Code benannt und liegen in folgenden Unterordnern:

    [1] /photos (700px)
    [2] /photos/thumbnails (150px)

Als Export-Qualität für die JPGs haben wir 80% gewählt und die Bilder mit einer kurzen Kante von 700 Pixel exportiert [1]. Die Vorschaubilder haben eine Höhe bzw. Breite von mindestens 150 Pixel. Die Originaldateien von den Gebäuden liegen im Unterordner /photos/original.
