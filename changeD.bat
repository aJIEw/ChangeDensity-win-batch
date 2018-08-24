@echo off

Rem This is for changing the screen density of tablet with chips manufactured by rock-chips, please refer to (http://www.rock-chips.com/a/cn/product/index.html)

SETLOCAL EnableDelayedExpansion

CLS
platform-tools\adb.exe kill-server 

Rem platform-tools\adb.exe devices | find /v /c ""
Rem check if device has connected
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

Rem check if this device density is changeable or not
platform-tools\adb.exe shell getprop | findstr ro.sf.lcd_density > density.txt
set "cmd=findstr /R /N "^^" density.txt | find /C ":""
for /f %%a in ('!cmd!') do set /A density=%%a
if "%density%" EQU "1" (
	ECHO Device density can be changed!
) else (
	ECHO Device density does not support changing!
	EXIT/B
)

:: Rem pull build.prop file to local and change the density
:: platform-tools\adb.exe pull /system/build.prop .\
:: powershell -Command "(gc build.prop) -replace 'ro.sf.lcd_density=160', 'ro.sf.lcd_density=240' | Out-File build.prop"

Rem push build.prop back to the device
START /B /wait platform-tools\adb.exe root
START /B /wait platform-tools\adb.exe shell mount -o rw,remount /system
START /B /wait platform-tools\adb.exe push build.prop /system/
START /B /wait platform-tools\adb.exe shell mount -o ro,remount /system
START /B /wait platform-tools\adb.exe shell chmod 644 /system

Rem get device density and write into file 
platform-tools\adb.exe pull /system/build.prop .\
type build.prop | findstr ro.sf.lcd_density > density.txt

platform-tools\adb.exe reboot

	ECHO
	ECHO Done, please wait until your device finished rebooting!
	ECHO Goodbye~

DEL deviceList.txt
ENDLOCAL

