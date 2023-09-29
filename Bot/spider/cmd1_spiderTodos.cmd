@echo off
set periodo=201312
set dir_spider=E:\DBNeT\spider\bin

rem set dir_periodo=E:\DBNeT\Spider\SVS%periodo%
set dir_periodo=E:\DBNeT\spider\

E:
cd %dir_spider%

rem copy %dir_periodo%\Xbrl-base.mdb %dir_periodo%\Xbrl%periodo%.mdb
copy E:\DBNeT\spider\Xbrl-base.mdb E:\DBNeT\spider\XbrlTodos.mdb
rem pause
start /wait %dir_spider%\"Helium Scraper.appref-ms" "E:\DBNeT\spider\Spider_SVS.hsp?--minimize=true&--auto-close=true"
rem pause
rem pause
echo SPIDER %time% >> Todos\log.log
exit