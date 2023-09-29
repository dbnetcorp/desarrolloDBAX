set FILE=%1
set HOME=C:\DBNeT\dbax_central\visualizador

%HOME%\bin\ReportBuilderRenderer.exe /Instance=%FILE% /ReportsFolder=%HOME%\ARCHIVO_SALIDA.zip /ReportFormat="Html" /Quiet

exit