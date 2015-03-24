# LMU Navigator Dokumentation

Willkommen bei der Dokumentation für den [LMU Navigator][1]!

## Was ist der LMU Navigator?

Der LMU Navigator ist ein studentisches Forschungsprojekt zweier Informatiker an der
[LMU München][2]. Ziel des Projekts ist es, Studenten die Orientierung auf dem verteilten Campus der
LMU zu erleichtern, indem Gebäude- und Raumdaten der Universität geeignet aufbereitet und in einer
App bereitgestellt werden.

[1]: http://lmu-navigator.github.io/
[2]: http://www.uni-muenchen.de

## Überblick

Das Projekt besteht aus mehreren Teilen:

### Android-App

Hauptbestandteil ist eine Android-App mit folgenden Features:

* Alle Standorte der LMU lassen sich durchsuchen oder auf einer Karte anzeigen
* Zu einem Standort kann eine Routenführung gestartet und die zugehörigen Gebäudepläne angezeigt
werden
* Die Räume eines Standortes können durchsucht und auf den Gebäudeplänen lokalisiert werden
* Die Gebäude- und Raumdaten können regelmäßig aktualisiert werden

Screenshots und eine kurze Erklärung der Benutzeroberfläche befinden sich unter [App-Übersicht][8].

Unser Ziel ist es, diese App zu veröffentlichen und damit allen Studenten bereitzustellen. Auf Grund
rechtlicher Fragen ist dies bisher jedoch noch nicht möglich.

### Administrator-Interface

Zusätzlich zur App wurde ein Administrator-Interface erstellt, mit dessen Hilfe die von der
Universität zur Verfügung gestellten Daten aufbereitet werden. Insbesondere wurde ein Algorithmus
entwickelt, der es erlaubt, Räume auf dem zugehörigen PDF-Gebäudeplan zu lokalisieren.

### iOS-App

Es existiert ein rudimentärer Port der Android-App für iOS, welcher jedoch noch nicht alle Features
beinhaltet. Hier ist noch einige Arbeit nötig, um die App potentiell veröffentlichbar zu machen.

## Lies weiter!

Mehr Details zu den einzelnen Komponenten findest Du auf den jeweiligen Unterseiten:

* [App-Übersicht][8]
* [Admin-Guide][5]
* [Android-App][3]
* [Admin-Server][4]
* [iOS-App][6]

[3]: android.md
[4]: server.md
[5]: admin.md
[6]: ios.md
[8]: app.md

## Mach mit!

Das Projekt ist Open-Source! Den Aktuellen Code kannst Du bei [GitHub][7] einsehen.

* Du willst mehr wissen?
* Du willst Feedback oder Verbesserungsvorschläge loswerden?
* Du hast Interesse, an dem Projekt mitzuwirken oder es weiterzuentwickeln?

**Dann melde Dich bei uns!**

[7]: https://github.com/lmu-navigator

### Kontakt

Timo Loewe (timo.loewe (at) campus.lmu.de) <br />
Lukas Ziegler (lukas.ziegler (at) campus.lmu.de)
