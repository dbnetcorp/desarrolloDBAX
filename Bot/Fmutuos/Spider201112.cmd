@echo off
set dir_spider=C:\DBNeT\Spider\bin
set dir_fondos=C:\DBNeT\Spider\Fmutuos

cd %dir_spider%

start /wait %dir_spider%\"Helium Scraper.appref-ms" "%dir_fondos%\Fon_mutuo.hsp?--starting-url=file:///%dir_fondos%\Fon_mutuo.htm&--minimize=true&--auto-close=true"

start /wait %dir_spider%\gestor %dir_spider%\wget  %dir_periodo%\Descarga %dir_periodo%\Xbrl%periodo%.mdb