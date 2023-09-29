@echo off
set periodo=201312
set dir_spider=E:\DBNeT\Spider\bin

rem set dir_periodo=E:\DBNeT\Spider\SVS%periodo%
set dir_periodo=E:\DBNeT\Spider\

rem start /wait c:\dbnet\dbax\bin\dbax.CuentaXbrl.exe E:\DBNeT\Spider\ %periodo%

cd %dir_spider%
rem pause
rem rd /S /Q %dir_periodo%\Descarga
mkdir %dir_periodo%\Descarga

rem pause
rem start /wait %dir_spider%\gestor_all %dir_spider%\wget %dir_periodo%\Descarga %dir_periodo%\Xbrl%periodo%.mdb
start /wait %dir_spider%\gestorDescargas2 %dir_spider%\wget E:\DBNeT\spider\ E:\DBNeT\spider\xbrlTodos.mdb
rem pause
echo RESCATA %time% >> %dir_periodo%\log.log
rem pause
exit