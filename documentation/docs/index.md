# LMU Navigator

__Repository:__ https://gitlab.cip.ifi.lmu.de/zieglerl/lmu-navigator/

__Offene Fragen__:
* Auf Deutsch oder Englisch die Doku schreiben?



# Android-App

* Verwendete Libraries
* Arbeitsumgebung

      TODO


# Server

## REST API

URI: http://141.84.213.246:8080/lmu-navigator/rest/*

Links:
* http://stackoverflow.com/q/630453/1402076 (PUT vs POST)
* http://goo.gl/C3FPyt (Advanced Rest Client / Chrome Plugin)

### Static JSON files

Hosted on the LMU server

    TODO


### REST functionality of the Tomcat servlet

For Testing the REST-API
* __GET /ping__
  returns Pong, if the Tomcat Webapp is deployed successfully

* __GET /version__
  returns the current version of the stored data
  {"version":7,"timestamp":1409688383}


#### /cities

* __GET	/cities__
	returns a list of all cities with LMU buildings


#### /streets

#### /buildings

#### /buildingparts

#### /floors

* __GET /floors/{floorCode}__
  returns a single floor for the requested floor ID / code

* __GET /floors/{floorCode}/bordering__
  returns all floors associated to the same mapUri (PDF file), excluding the floor itself, required for buildings like the main building (Geschwister-Scholl-Platz)

* __GET /floors__
  returns all available floors from the database

* __GET /floors?code={floorCode}&buildingpart={buildingPartCode}__
  returns all available floors from the database

#### /rooms

__Besonderheiten:__ Es werden nur Räume als JSON ausgegeben, die eine gültige Position haben (PosX != 0 + PosY != 0) und sichtbar sind (hidden == 0). Nicht positionierte und deaktivierte Räume werden somit nicht zur App übertragen.


## Room Canvas

Manually updating the room positions of on the RoomsOverview servlet, e.g.: http://localhost:8080/lmu-navigator/data/rooms?floor=g650301

Features:
* Manual positioning of rooms cross iFrames
* Press the ESC key to abort the manual positioning and scroll back to top
* Right click: Pan
* Left click: select new position



# MkDocs Introduction

For full documentation visit [mkdocs.org](http://mkdocs.org) and [readthedocs.org](docs.readthedocs.org/en/latest/getting_started.html).

## Commands

* `mkdocs new [dir-name]` - Create a new project.
* `mkdocs serve` - Start the live-reloading docs server.
* `mkdocs build` - Build the documentation site.
* `mkdocs help` - Print this help message.

## Project layout

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage.
        ...       # Other markdown pages, images and other files.
