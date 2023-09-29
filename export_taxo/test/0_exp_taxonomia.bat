@echo off
set user=xbrl
set pwd=xbrl
set serv=NB-MAHUMADA
set base=xbrl

sqlcmd -U %user% -P %pwd% -S %serv% -d %base% -i 0_exp_taxonomia.sql -o 1_dat_taxonomia.sql