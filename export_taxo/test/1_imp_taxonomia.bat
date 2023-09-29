@echo off
set user=dbax
set pwd=dbax
set serv=.\SQLSERVER2008
set base=dbax

sqlcmd -U %user% -P %pwd% -S %serv% -d %base% -i 1_dat_taxonomia.sql -o 2_dat_taxonomia.log