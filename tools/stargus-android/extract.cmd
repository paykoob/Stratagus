@ECHO OFF
IF "%1"=="" GOTO :Usage
startool.exe %1 data.sc
IF ERRORLEVEL 1 GOTO :Exit
xcopy /s /y contrib data.sc
exit 0

:Usage
ECHO Syntax is: extract.cmd path_to_starcraft_cd

:Exit
exit 1