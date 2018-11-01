@ECHO off
REM ===================================================================================================
REM Use this batch file when you have a cable and keep your computer connected to the machine.
REM ===================================================================================================

SETLOCAL EnableDelayedExpansion
START /B /wait platform-tools\adb.exe devices | FINDSTR device > deviceList.txt
SET "cmd=findstr /R /N "^^" deviceList.txt | find /C ":""
FOR /f %%a in ('!cmd!') do SET /A device=%%a
IF "%device%" GEQ "2" (
    ECHO Device found!
) ELSE (
	ECHO Device not found!
	DEL deviceList.txt
	EXIT/B
)

START /B /wait platform-tools\adb.exe shell wm density 240

ECHO FINISHED

DEL deviceList.txt
ENDLOCAL