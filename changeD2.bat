SETLOCAL EnableDelayedExpansion
START /B /wait platform-tools\adb.exe devices > deviceList.txt
set "cmd=findstr /R /N "^^" deviceList.txt | find /C ":""
for /f %%a in ('!cmd!') do set /A device=%%a
echo %device%
if "%device%" EQU "3" (
    ECHO Device found!
) else (
	ECHO Device not found!
	DEL deviceList.txt
	EXIT/B
)

START /B /wait platform-tools\adb.exe shell wm density 240

DEL deviceList.txt
ENDLOCAL