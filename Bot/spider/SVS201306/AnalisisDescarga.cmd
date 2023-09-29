set periodo=201306
start E:\DBNeT\spider\SVS%periodo%\cmd1_spider.cmd

PING -n 1 -w 15000 1.1.1.1 > nul

@ECHO OFF

:loop
CLS

set errorlevel=

tasklist /fi "imagename eq Helium Scraper.exe" | find /i "Helium Scraper.exe"> NUL

if /i %errorlevel% GTR 0 goto yes

ECHO Esperando que finalice Helium Scraper...
PING -n 1 -w 15000 1.1.1.1 > nul
GOTO loop

:yes
start E:\DBNeT\spider\SVS%periodo%\cmd2_descarga_xbrl.cmd
	PING -n 1 -w 15000 1.1.1.1 > nul

	@ECHO OFF

	:loop2
	CLS

	set errorlevel=

	tasklist /fi "imagename eq gestor_all.exe" | find /i "gestor_all.exe"> NUL

	if /i %errorlevel% GTR 0 goto yes2

	ECHO Esperando que finalice Helium Scraper...
	PING -n 1 -w 15000 1.1.1.1 > nul
	GOTO loop2
	:yes2
exit