# Android-App

Hier findest Du Informationen, falls Du an der (Weiter-)Entwicklung der LMU-Navigator Android-App
interessiert bist.

## Ursprung

Die ursprüngliche Version der Android-App wurde im Rahmen des [Praktikums Mobile Und Verteilte
Systeme][1] im Wintersemester 2013/14 entwickelt. Diese enthielt noch mehr Features als die
aktuelle App (z.B. Indoor-Routing und Indoor Localization via WLAN-Fingerprinting), welche jedoch
vorläufig entfernt wurden, da es sich mehr um "Proof-of-Concept"-Implementierungen handelte.
Der Code aus dem damaligen Praktikum lässt sich noch [hier][2] einsehen (ein Account bei [Gitlab][3]
wird benötigt).

Nach dem Praktikum wurde der Code komplett neu geschrieben und nur noch die Kernfunktionalitäten
implementiert. Ziel war es, die App für alle Studenten zu veröffentlichen und Interessierten die
Weiterentwicklung zu ermöglichen.

[1]: http://www.mobile.ifi.uni-muenchen.de/studium_lehre/verg_semester/ws1314/msp/index.html
[2]: https://gitlab.cip.ifi.lmu.de/loewe/lmu-navi
[3]: https://gitlab.cip.ifi.lmu.de/

## Repository

Der Code befindet sich, wie der Rest des Projekts, auf GitHub:
[https://github.com/lmu-navigator/android]()

Möchtest Du etwas zum Projekt beitragen, so sind [Pull Requests][4] jederzeit willkommen. Falls Du
Interesse hast, mittel- oder längerfristig an dem Projekt zu arbeiten, statten wir Dich natürlich
gerne mit allen Schreib- und Leserechten für das Repository aus. Bitte melde Dich bei uns!
**TODO: Kontakt!**

[4]: https://help.github.com/articles/using-pull-requests/

## Setup/Installation

Es werden das Android-SDK und Android Studio benötigt. Informationen zur Installation findest Du
auf der offiziellen [Android-Developer Webseite][5].

Lade zunächst den Code herunter, z.B. via git-clone auf der Kommandozeile:
`git clone git@github.com:lmu-navigator/android.git`

[5]: http://developer.android.com/index.html

### Android Studio

Importiere das Projekt in Android-Studio:

  1. Starte Android-Studio und wähle *Open an existing Android Studio project*
  2. In der folgenden Pfadauswahl wähle das Projekt-Root-Verzeichnis (*android/*) aus
  3. Folge allen eventuellen Anweisungen, die Standardeinstellungen können i.d.R. alle beibehalten
  werden

### Kommandozeile

Die App lässt sich auch über die Kommandozeile bauen (aus dem Root-Verzeichnis):
`./gradlew assemble`

Die fertige .apk-Datei befindet sich anschließend im Ordner *app/build/outputs/apk/* und lässt sich
beispielsweise via `adb` installieren.

## Code Dokumentation

Der Code ist derzeit nur wenig dokumentiert. Wer jedoch mit Android-Entwicklung vertraut ist,
sollte sich schnell zurecht finden können.

Das Datenmodell ist in der [Server-Dokumentation](server.md) beschrieben.

## App Design

Das User Interface der App orientiert sich an den [Material Design Guidelines][22].

[22]: http://www.google.com/design/spec/material-design/introduction.html

## 3rd-Party Libraries

Folgende Open-Source-Bibliotheken werden verwendet und sind größtenteils gut dokumentiert:

  * [realm-java][6]: Datenbank
  * [Butterknife][7]: View-Injection
  * [Retrofit][8]: Network/REST library
  * [Picasso][9]: Image library
  * [android-maps-utils][10]: Map clustering
  * [TileView][11]: Kachel-View für Gebäudeplanansicht
  * [simmetrics][21]: Fuzzy Suche
  * [guava][12]
  * [EventBus][13]
  * [material-dialogs][14]
  * [PagerSlidingTabStrip][15]
  * [CircularImageView][16]
  * [Android-ObservableScrollView][17]
  * [commons-lang][18]
  * [FloatingActionButton][19]
  * [Prefs][20]
  * Google Play Services
  * Google Support Libraries

**Wichtig: Die Lizenzen zu allen Open-Source-Bibliotheken müssen in der App aufgeführt werden!**

[6]: https://github.com/realm/realm-java
[7]: https://github.com/JakeWharton/butterknife
[8]: https://github.com/square/retrofit
[9]: https://github.com/square/picasso
[10]: https://github.com/googlemaps/android-maps-utils
[11]: https://github.com/moagrius/TileView
[12]: https://github.com/google/guava
[13]: https://github.com/greenrobot/EventBus
[14]: https://github.com/afollestad/material-dialogs
[15]: https://github.com/jpardogo/PagerSlidingTabStrip
[16]: https://github.com/Pkmmte/CircularImageView
[17]: https://github.com/ksoichiro/Android-ObservableScrollView
[18]: https://github.com/apache/commons-lang
[19]: https://github.com/makovkastar/FloatingActionButton
[20]: https://github.com/Alexrs95/Prefs
[21]: http://sourceforge.net/projects/simmetrics/

## Bug Tracker

Bugs oder Feature Requests können auf [GitHub][23] gemeldet werden.

[23]: https://github.com/lmu-navigator/android/issues

## Future Work

Zusätzliche Features könnten sein:

  * Informationen zur Barrierefreiheit der Gebäude
  * Integration von "Points of Interests" wie Mensen, Bibliotheken,
  Toiletten, etc.
  * Mehr Kontextinformationen zu Gebäuden und Räumen, z.B. ansässige Institute, Raumbelegung, etc.
  * Indoor-Routing
  * Indoor-Positionierung, z.B. mit WLAN-Fingerprinting
