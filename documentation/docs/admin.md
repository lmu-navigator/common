# Anleitung für den Administrator

Die Gebäude- und Raumdaten der LMU werden regelmäßig aktualisiert. Über die Admin-Oberfläche können
die Daten aufbereitet und anschließend für den Abruf in der App zur Verfügung gestellt werden. Die
App checkt bei jedem Start den aktuell verfügbaren Datenbestand und läd ihn bei Bedarf herunter.

*Hinweis*:
Die Admin-Komponente ist als Server mit Weboberfläche konzipiert. Da der Server jedoch bisher an keiner offiziellen
Stelle installiert werden konnte, muss eine lokale Instanz auf dem eigenen Rechner eingerichtet
werden. Siehe dazu die [Server-Dokumentation][4].

[4]: server.md

## Überblick

Einmal pro Semester wird vom [Referat IV.1][1] (Bau, Planung, Bewirtschaftung) der LMU München der
aktualisierte Datenbestand zur Verfügung gestellt. Dieser beinhaltet einen CSV-Export aus deren
Gebäudeverwaltungsystem und alle PDF-Gebäudepläne, welche auch öffentlich auf der [LMU Webseite][2]
verfügbar sind. Unser Hauptansprechpartner hierfür war bisher Herr Petrich.

Alle wichtigen Schritte welche vom Referats IV.1 für den CSV- und PDF-Export zu berücksichtigen
sind, haben wir in unserem Wiki zusammengefasst: [CSV-Dateien anfordern][3]

Auf dieser Seite soll dokumentiert werden, wie anschließend ein Datenupdate durchgeführt werden
kann. Es sind folgende Schritte nötig, welche unten jeweils genauer beschrieben werden:

1. Import der CSV-Dateien in die Datenbank
2. Umwandlung der PDF-Dateien in PNG-Bilder
3. Durchführung des Algorithmus für die Positionierung der Räume
4. Erstellung der Bildkacheln für die App
5. Export und Bereitstellung der Daten für die App

Unabhängig davon lassen sich auch jederzeit die Gebäudefotos aktualisieren, die in der App angezeigt
werden.

[1]: http://www.uni-muenchen.de/einrichtungen/zuv/uebersicht/dez_iv/ref_iv1/index.html
[2]: http://www.uni-muenchen.de/ueber_die_lmu/standorte/lageplaene/index.html
[3]: https://github.com/lmu-navigator/data/wiki/CSV-Dateien-anfordern

## 1. Import der CSV-Dateien

Als Erstes müssen die CSV-Dateien importiert werden. Dazu wählt man in der Weboberfläche
den Punkt *CSV-Upload*, wählt die entsprechende Datei aus und klickt auf *Upload*. Das importiert
die Daten in die Datenbank.

Die CSV-Dateien müssen im folgenden Format vorliegen, damit sie automatisch in die Datenbank eingelesen werden können:

```
[01_Stadt.csv]        Stadtcode;Stadt;Dateiname
[02_Strasse.csv]      Stadtcode;Stadt;Dateiname
[03_Bauwerk.csv]      BWCode;Stadtcode;Straßencode;Benennung
[04_BauteilHaus.csv]  BTCode;Stadtcode;Straßencode;BWCode;BauteilHaus
[05_Geschoss.csv]     GCode;Stadtcode;Straßencode;BWCode;BTCode;Geschoss;Benennung;Dateiname
[06_Raum.csv]         GCode;Stadtcode;Straßencode;BWCode;BTCode;Geschoss;Benennung;Raumnummer;RCode;Dateiname
```

## 2. Umwandlung der PDF-Dateien in PNG-Bilder

Als nächstes steht ein etwas mühsamerer Schritt an, es müssen alle PDFs in PNGs umgewandelt werden.
Hierbei können einige Fehler auftreten. Eine Sammlung der häufigsten Fehler findet ihr in unserem
GitHub-Wiki, welches nur für Projektmitglieder sichtbar ist: [PNG-Dateien generieren][5]

Bisher haben wir diesen Schritt mit Photoshop umgesetzt, da dort die Qualität der PNGs im Vergleich
zu Varianten mit GIMP oder Kommandozeilenskripts zufriedenstellender war.

1. Photoshop öffnen und dort die Aktionen gemäß den [Vorgaben im Wiki](https://github.com/lmu-navigator/data/wiki/PNG-Dateien-generieren) anlegen.
2. Mittels Stapelverarbeitung jeweils ca. 100 PDFs öffnen und mittels der zweiten Aktion
automatisiert als PNG speichern lassen.

Sowohl die PDF- als auch die PNG-Dateien werden für die Raumpositionierung im nächsten Schritt
benötigt. Es muss sichergestellt werden, dass die PDFs und die PNGs in getrennten Ordnern liegen,
bspw. *pdf/* und *png/*. Falls ein Remote-Server verwendet wird, müssen die Dateien dort abgelegt
werden. Anschließend in der Webobefläche den Punkt *Stored Data* aufrufen und in den Feldern oben
die Pfade zu den beiden Ordnern eintragen.

[5]: https://github.com/lmu-navigator/data/wiki/PNG-Dateien-generieren

## 3. Positionierung der Räume

Nachdem die CSV-Dateien importiert (Schritt 1) und die PDF- + PNG-Dateien erstellt und korrekt
referenziert worden sind (Schritt 2), kann die Positionierung der Räume auf den PDFs nun über die
Weboberfläche durchgeführt werden. Dazu die Seite *Stored Data* aufrufen und folgende Schritte
ausführen:

1. Zunächst nochmals PNG- und PDF-Pfade überprüfen
2. Die Bildgrößen der PNG-Dateien bestimmen, dazu auf *calculate dimension of PNGs* klicken
3. Nun kann der eigentliche Algorithmus gestartet werden. Dies kann für jedes Stockwerk einzeln mit
einem Klick auf *automated* in der Spalte **positionRooms** geschehen, oder gleich für den
kompletten Datenbestand über die Schaltfläche *batch update*. Ein Batch-Durchlauf kann durchaus eine
längere Zeit dauern (> 30min)!
4. Unter *manual positioning* kann die Positionierung überprüft und manuell korrigiert werden, falls
ein Raum nicht korrekt positioniert wurde. Falls manche Räume gar nicht gefunden wurden, werden
diese in der Spalte _notPos_ als rot angezeigt.
5. Alle Daten noch überprüfen, ob nicht doch ausversehen auf den ausgegrauten Flächen ein Raum positioniert wurde.

## 4. Erstellung der Bildkacheln für die App

Nun müssen noch die Bildkacheln generiert werden, die in der App zur Anzeige der Gebäudepläne
verwendet werden. Dafür gibt es ein [Kommandozeilenskript][6], welches auf Mac- und Linux-Rechnern
funktionieren sollte. Es wird lediglich die *Imagemagick*-Bibliothek benötigt, die in der Regel
vorinstalliert ist.

Das Skript muss in den Ordner mit den PNG-Dateien kopiert werden. Ein Aufruf sieht folgendermaßen aus: `./create_tiles <datei>.png`

Alle Dateien gleich in einem Kommando zu verarbeiten, ist bspw. so möglich:
```
for i in *.png; do
echo $i
./create_tiles $i
done;
```

Die fertig generierten Kacheln befinden sich anschließend im Ordner *tiles/*.

[6]: https://github.com/lmu-navigator/common/blob/master/util/create_tiles.sh

## 5. Export und Deployment der Daten

Ursprünglich sollten die Daten über das REST-Interface des Servers abgerufen werden können. Da aber
bisher kein Server zur Verfügung steht, werden alle Daten nun statisch auf unserer [github.io][7]
Seite bereitgestellt.

Zunächst muss also die REST API manuell aufgerufen und die Daten als JSON-Datei abgespeichert
werden:

* `http://<Pfad zum Server>/rest/cities` -> `1_city.json`
* `http://<Pfad zum Server>/rest/streets` -> `2_street.json`
* `http://<Pfad zum Server>/rest/buildings` -> `3_building.json`
* `http://<Pfad zum Server>/rest/buildingparts` -> `4_building_part.json`
* `http://<Pfad zum Server>/rest/floors` -> `5_floor.json`
* `http://<Pfad zum Server>/rest/rooms` -> `6_room.json`
* `http://<Pfad zum Server>/rest/version` -> `version.json`

Zum Deployen der Daten für die Android- und iOS-Apps genügt es nun, diese in den Unterordner *data/*
des [github.io-Repositories][8] zu pushen:

```
/data/json/    # json-Dateien
/data/tiles/   # Kacheln aus Schritt 4
/data/photos/  # Gebäudefotos, siehe unten

```

[7]: http://lmu-navigator.github.io
[8]: https://github.com/lmu-navigator/lmu-navigator.github.io

## Neue Bilder einbinden

Die Gebäudebilder liegen wie alle anderen statischen Dateien auf unserer github.io-Seite. Sie können
getrennt von den restlichen Daten aktualisiert werden.

Die Bilder sind nach dem Bauwerk-Code benannt und liegen in folgenden Unterordnern:

    [1] data/photos (700px)
    [2] data/photos/thumbnails (150px)

Ein neues Bild wird also beispielsweise unter `data/photos/bw7070.jpg` und
`data/photos/thumbnails/bw7070.jpg` abgelegt.

Als Export-Qualität für die JPGs haben wir 80% gewählt und die Bilder mit einer kurzen Kante von 700
Pixel exportiert. Die Vorschaubilder haben eine Höhe bzw. Breite von mindestens 150 Pixel. Die
Originaldateien von den Gebäuden liegen im Unterordner /photos/original.
