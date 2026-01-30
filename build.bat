@echo off
setlocal EnableDelayedExpansion

if "%1"=="" set CONFIG=Release
if "%1"=="Release" set CONFIG=Release
if "%1"=="Debug" set CONFIG=Debug
if "%2"=="" set PLATFORM=x64
if "%2"=="x64" set PLATFORM=x64
if "%2"=="Win32" set PLATFORM=Win32

echo === Building Rufus ===
echo Configuration: %CONFIG%
echo Platform: %PLATFORM%
echo.

set MSBUILD=
if exist "%ProgramFiles%\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe" (
    set "MSBUILD=%ProgramFiles%\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe"
)
if "!MSBUILD!"=="" (
    if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe" (
        set "MSBUILD=%ProgramFiles(x86)%\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe"
    )
)
if "!MSBUILD!"=="" (
    if exist "%ProgramFiles%\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe" (
        set "MSBUILD=%ProgramFiles%\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe"
    )
)
if "!MSBUILD!"=="" (
    if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe" (
        set "MSBUILD=%ProgramFiles(x86)%\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe"
    )
)
if "!MSBUILD!"=="" (
    if exist "%ProgramFiles%\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe" (
        set "MSBUILD=%ProgramFiles%\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe"
    )
)
if "!MSBUILD!"=="" (
    if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe" (
        set "MSBUILD=%ProgramFiles(x86)%\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe"
    )
)

if "!MSBUILD!"=="" (
    echo ERROR: MSBuild not found!
    echo Please install Visual Studio 2022
    echo Or use Developer Command Prompt for VS 2022
    pause
    exit /b 1
)

echo Found MSBuild: !MSBUILD!
echo.

if not exist "rufus.sln" (
    echo ERROR: rufus.sln not found!
    echo Make sure you are in the project root directory
    pause
    exit /b 1
)

echo Starting build...
"!MSBUILD!" rufus.sln /p:Configuration=%CONFIG% /p:Platform=%PLATFORM% /m

if %ERRORLEVEL% EQU 0 (
    echo.
    echo === Build completed successfully! ===
    set "OUTDIR=.vs\%PLATFORM%\%CONFIG%"
    if "%PLATFORM%"=="Win32" set "OUTDIR=.vs\x86\%CONFIG%"
    if exist "!OUTDIR!\rufus.exe" (
        echo File: !OUTDIR!\rufus.exe
    )
) else (
    echo.
    echo === BUILD FAILED ===
    pause
    exit /b %ERRORLEVEL%
)

pause
