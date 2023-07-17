@echo off
SET THEFILE=c:\users\senras\desktop\fod\fod202~1\prctic~1\practi~1\p1e3b.exe
echo Linking %THEFILE%
d:\dev-pas\bin\ldw.exe  -s   -b base.$$$ -o c:\users\senras\desktop\fod\fod202~1\prctic~1\practi~1\p1e3b.exe link.res
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occured while assembling %THEFILE%
goto end
:linkend
echo An error occured while linking %THEFILE%
:end
