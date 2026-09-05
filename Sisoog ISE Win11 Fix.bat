@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Sisoog - Xilinx ISE 14.7 Windows 11 Patch
color 0B

REM ============================================================
REM  This script can live in any folder under C:\Xilinx, e.g.:
REM     C:\Xilinx\Sisoog ISE Win11 Fix\patch_ise.bat
REM  Next to it there must be two folders:
REM     ...\nt\libPortability.dll     (32-bit)
REM     ...\nt64\libPortability.dll   (64-bit)
REM
REM  64-bit file goes into these 7 locations:
REM     ISE\sysgen\bin\nt64
REM     ISE\bin\nt64
REM     EDK\lib\nt64\sdk
REM     EDK\lib\nt64
REM     ISE\lib\nt64
REM     common\lib\nt64
REM     xinstall\bin\nt64
REM
REM  32-bit file goes into these 3 locations:
REM     EDK\lib\nt
REM     ISE\lib\nt
REM     common\lib\nt
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
set "SRC_NT=%BASE%nt"
set "SRC_NT64=%BASE%nt64"

for %%A in ("%BASE%..") do set "XILINX_ROOT=%%~fA"

echo Looking for patch files...
if not exist "%SRC_NT%\libPortability.dll" (
    echo ERROR: File not found: %SRC_NT%\libPortability.dll
    set "SUCCESS=0"
    goto :RESULT
)
if not exist "%SRC_NT64%\libPortability.dll" (
    echo ERROR: File not found: %SRC_NT64%\libPortability.dll
    set "SUCCESS=0"
    goto :RESULT
)
echo Patch files found.
echo.

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

REM ----- 64-bit destinations -----
set "T64[0]=ISE\sysgen\bin\nt64"
set "T64[1]=ISE\bin\nt64"
set "T64[2]=EDK\lib\nt64\sdk"
set "T64[3]=EDK\lib\nt64"
set "T64[4]=ISE\lib\nt64"
set "T64[5]=common\lib\nt64"
set "T64[6]=xinstall\bin\nt64"

REM ----- 32-bit destinations -----
set "T32[0]=EDK\lib\nt"
set "T32[1]=ISE\lib\nt"
set "T32[2]=common\lib\nt"

echo Copying 64-bit files...
for /L %%I in (0,1,6) do (
    set "REL=!T64[%%I]!"
    set "DEST=%ISE_DS%\!REL!"
    if not exist "!DEST!" mkdir "!DEST!"
    if exist "!DEST!\libPortability.dll" (
        if not exist "!DEST!\libPortability.dll.bak" (
            copy /Y "!DEST!\libPortability.dll" "!DEST!\libPortability.dll.bak" >nul
        )
    )
    copy /Y "%SRC_NT64%\libPortability.dll" "!DEST!\libPortability.dll" >nul
    if errorlevel 1 (
        echo   FAILED: !REL!
        set "SUCCESS=0"
    ) else (
        echo   OK: !REL!
    )
)

echo.
echo Copying 32-bit files...
for /L %%I in (0,1,2) do (
    set "REL=!T32[%%I]!"
    set "DEST=%ISE_DS%\!REL!"
    if not exist "!DEST!" mkdir "!DEST!"
    if exist "!DEST!\libPortability.dll" (
        if not exist "!DEST!\libPortability.dll.bak" (
            copy /Y "!DEST!\libPortability.dll" "!DEST!\libPortability.dll.bak" >nul
        )
    )
    copy /Y "%SRC_NT%\libPortability.dll" "!DEST!\libPortability.dll" >nul
    if errorlevel 1 (
        echo   FAILED: !REL!
        set "SUCCESS=0"
    ) else (
        echo   OK: !REL!
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
