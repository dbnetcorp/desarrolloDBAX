@echo off
set periodo=201309
set dir_spider=E:\DBNeT\Spider\bin
set dir_periodo=E:\DBNeT\Spider\SVS%periodo%
start /wait c:\dbnet\dbax\bin\dbax.CuentaXbrl.exe E:\DBNeT\Spider\ %periodo%

cd %dir_spider%
rem pause
rem rd /S /Q %dir_periodo%\Descarga
mkdir %dir_periodo%\Descarga
start /wait %dir_spider%\gestor_all %dir_spider%\wget %dir_periodo%\Descarga %dir_periodo%\Xbrl%periodo%.mdb
rem pause
echo RESCATA %time% >> %dir_periodo%\log.log
rem pause
exit
