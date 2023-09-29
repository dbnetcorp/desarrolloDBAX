@echo off
set periodo=201309
set dir_spider=E:\DBNeT\Spider\bin
set dir_periodo=E:\DBNeT\Spider\SVS%periodo%

cd %dir_spider%
copy %dir_periodo%\Xbrl-base.mdb %dir_periodo%\Xbrl%periodo%.mdb
start /wait %dir_spider%\"Helium Scraper.appref-ms" "%dir_periodo%\Spider_SVS.hsp?--minimize=true&--auto-close=true"

echo SPIDER %time% >> %dir_periodo%\log.log
exit