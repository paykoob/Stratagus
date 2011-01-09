@ECHO OFF
IF "%1"=="" GOTO :Usage
wartool.exe %1/data data.wc2
IF ERRORLEVEL 1 GOTO :Exit
xcopy /s /y contrib data.wc2
exit 0

:Usage
ECHO Syntax is: extract.cmd path_to_warcraft2_cd

:Exit
exit 1