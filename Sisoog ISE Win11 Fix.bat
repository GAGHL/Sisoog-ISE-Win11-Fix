@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Sisoog - Xilinx ISE 14.7 Windows 11 Patch
color 0B

REM ============================================================
REM  This script can live in any folder under C:\Xilinx, e.g.:
REM     C:\Xilinx\Sisoog ISE Win11 Fix\patch_ise.bat
REM
REM  Source of the patched DLL (in order of priority):
REM   1) Next to this script:  nt\libPortability.dll  (32-bit)
REM                            nt64\libPortability.dll (64-bit)
REM   2) Inside the ISE install itself (manual method):
REM        ISE\lib\nt\libPortabilityNOSH.dll    (32-bit)
REM        ISE\lib\nt64\libPortabilityNOSH.dll  (64-bit)
REM
REM  64-bit file goes into these 7 locations:
REM     ISE\sysgen\bin\nt64
REM     ISE\bin\nt64
REM     EDK\lib\nt64\sdk
REM     EDK\lib\nt64
REM     ISE\lib\nt64
REM     common\lib\nt64
REM     .xinstall\bin\nt64
REM
REM  32-bit file goes into these 5 locations:
REM     .xinstall\bin\nt
REM     common\lib\nt
REM     EDK\lib\nt
REM     ISE\lib\nt
REM     ISE\sysgen\bin\nt
REM
REM  Existing files are backed up in place as "libPortability.dll.bak"
REM  before being overwritten (only if not already backed up).
REM ============================================================

cls
echo.
echo.
echo        ################################################
echo        #                                              #
echo        #                  S I S O O G                 #
echo        #                                              #
echo        ################################################
echo.
echo                   Author: Abbas Ghalavandi
echo.
echo        Xilinx ISE 14.7 - Windows 11 Compatibility Patch
echo.
echo.
pause
cls

set "SUCCESS=1"

set "BASE=%~dp0"

for %%A in ("%BASE%..") do set "XILINX_ROOT=%%~fA"

echo Looking for the ISE installation folder...
set "ISE_DS="
for /f "delims=" %%D in ('dir /b /ad /s "%XILINX_ROOT%\ISE_DS" 2^>nul') do (
    if not defined ISE_DS set "ISE_DS=%%D"
)
if not defined ISE_DS (
    echo Could not find it automatically.
    set /p ISE_DS="Please type the full path to the ISE_DS folder: "
)
if not exist "%ISE_DS%" (
    echo ERROR: This path does not exist: %ISE_DS%
    set "SUCCESS=0"
    goto :RESULT
)
echo Found: %ISE_DS%
echo.

echo Looking for patch files...
set "SRC_NT=%BASE%nt\libPortability.dll"
set "SRC_NT64=%BASE%nt64\libPortability.dll"
if not exist "%SRC_NT%" (
    echo   32-bit patch file not next to script, trying libPortabilityNOSH.dll from ISE...
    set "SRC_NT=%ISE_DS%\ISE\lib\nt\libPortabilityNOSH.dll"
)
if not exist "%SRC_NT64%" (
    echo   64-bit patch file not next to script, trying libPortabilityNOSH.dll from ISE...
    set "SRC_NT64=%ISE_DS%\ISE\lib\nt64\libPortabilityNOSH.dll"
)
if not exist "%SRC_NT%" (
    echo ERROR: 32-bit patch file not found: %SRC_NT%
    set "SUCCESS=0"
    goto :RESULT
)
if not exist "%SRC_NT64%" (
    echo ERROR: 64-bit patch file not found: %SRC_NT64%
    set "SUCCESS=0"
    goto :RESULT
)
echo   32-bit source: %SRC_NT%
echo   64-bit source: %SRC_NT64%
echo.

REM ----- 64-bit destinations -----
set "T64[0]=ISE\sysgen\bin\nt64"
set "T64[1]=ISE\bin\nt64"
set "T64[2]=EDK\lib\nt64\sdk"
set "T64[3]=EDK\lib\nt64"
set "T64[4]=ISE\lib\nt64"
set "T64[5]=common\lib\nt64"
set "T64[6]=.xinstall\bin\nt64"

REM ----- 32-bit destinations -----
set "T32[0]=.xinstall\bin\nt"
set "T32[1]=common\lib\nt"
set "T32[2]=EDK\lib\nt"
set "T32[3]=ISE\lib\nt"
set "T32[4]=ISE\sysgen\bin\nt"

echo Copying 64-bit files...
for /L %%I in (0,1,6) do (
    set "REL=!T64[%%I]!"
    set "DEST=%ISE_DS%\!REL!"
    if not exist "!DEST!" mkdir "!DEST!"
    attrib -r -s -h "!DEST!\libPortability.dll" >nul 2>&1
    if exist "!DEST!\libPortability.dll" (
        if not exist "!DEST!\libPortability.dll.bak" (
            copy /Y "!DEST!\libPortability.dll" "!DEST!\libPortability.dll.bak" >nul
        )
    )
    copy /Y "%SRC_NT64%" "!DEST!\libPortability.dll" >nul 2>&1
    if errorlevel 1 (
        takeown /f "!DEST!\libPortability.dll" >nul 2>&1
        icacls "!DEST!\libPortability.dll" /grant *S-1-5-32-544:F >nul 2>&1
        attrib -r -s -h "!DEST!\libPortability.dll" >nul 2>&1
        copy /Y "%SRC_NT64%" "!DEST!\libPortability.dll" >nul
    )
    if errorlevel 1 (
        echo   FAILED: !REL!
        set "SUCCESS=0"
    ) else (
        echo   OK: !REL!
    )
)

echo.
echo Copying 32-bit files...
for /L %%I in (0,1,4) do (
    set "REL=!T32[%%I]!"
    set "DEST=%ISE_DS%\!REL!"
    if not exist "!DEST!" mkdir "!DEST!"
    attrib -r -s -h "!DEST!\libPortability.dll" >nul 2>&1
    if exist "!DEST!\libPortability.dll" (
        if not exist "!DEST!\libPortability.dll.bak" (
            copy /Y "!DEST!\libPortability.dll" "!DEST!\libPortability.dll.bak" >nul
        )
    )
    copy /Y "%SRC_NT%" "!DEST!\libPortability.dll" >nul 2>&1
    if errorlevel 1 (
        takeown /f "!DEST!\libPortability.dll" >nul 2>&1
        icacls "!DEST!\libPortability.dll" /grant *S-1-5-32-544:F >nul 2>&1
        attrib -r -s -h "!DEST!\libPortability.dll" >nul 2>&1
        copy /Y "%SRC_NT%" "!DEST!\libPortability.dll" >nul
    )
    if errorlevel 1 (
        echo   FAILED: !REL!
        set "SUCCESS=0"
    ) else (
        echo   OK: !REL!
    )
)

echo.
echo Patching libPortabilityNOSH.dll (the file ISim copies into each project)...
for %%B in (64 32) do (
    if "%%B"=="64" ( set "NOSH=%ISE_DS%\ISE\lib\nt64\libPortabilityNOSH.dll" & set "SRC=%SRC_NT64%" ) else ( set "NOSH=%ISE_DS%\ISE\lib\nt\libPortabilityNOSH.dll" & set "SRC=%SRC_NT%" )
    if /I not "!SRC!"=="!NOSH!" (
        if exist "!NOSH!" (
            attrib -r -s -h "!NOSH!" >nul 2>&1
            if not exist "!NOSH!.bak" copy /Y "!NOSH!" "!NOSH!.bak" >nul
            copy /Y "!SRC!" "!NOSH!" >nul
            if errorlevel 1 ( echo   FAILED: !NOSH! & set "SUCCESS=0" ) else ( echo   OK: !NOSH! )
        )
    )
)

:RESULT
echo.
if "%SUCCESS%"=="1" (
    color 0A
    echo.
    echo        ################################################
    echo        #                                              #
    echo        #                  SUCCESS                     #
    echo        #                                              #
    echo        #        All files were patched correctly.     #
    echo        #                                              #
    echo        ################################################
    echo.
    echo Original files were saved as "libPortability.dll.bak" next to each one.
) else (
    color 0C
    echo.
    echo        ################################################
    echo        #                                              #
    echo        #                  FAILED                      #
    echo        #                                              #
    echo        #      The patch could not be fully applied.   #
    echo        #      Check the messages above for details.   #
    echo        #                                              #
    echo        ################################################
)

echo.
pause
color
endlocal
