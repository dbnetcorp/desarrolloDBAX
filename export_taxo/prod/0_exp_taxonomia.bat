@echo off
set user=xbrl
set pwd=xbrl
set serv=216.241.30.190
set base=xbrl

sqlcmd -U %user% -P %pwd% -S %serv% -d %base% -i 0_exp_taxonomia.sql -o 1_dat_taxonomia.sql