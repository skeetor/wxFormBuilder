@ECHO OFF


REM Set Defaults
SET config=Release
SET platform=X64
SET install=E:\Programme\wxFormBuilder

REM Handle parameters
:Loop
REM Show help and exit
IF [%1]==[-h]                   GOTO Help
IF [%1]==[--help]               GOTO Help
IF [%1]==[--config]             GOTO Configuration
IF [%1]==[--platform]           GOTO Platform
IF [%1]==[--install]            GOTO Install
GOTO Installation

:Help
ECHO.
ECHO Available options:
ECHO.
ECHO --config               Project config (normally Release or Debug)
ECHO                        Example: --config=Release
ECHO                        Current: %config%
ECHO.
ECHO --platform             Project platform (normally x64 or Win32)
ECHO                        Example: --platform=X64
ECHO                        Current: %platform%
ECHO.
ECHO --install              Target directory where it should be installed (doesn't need to exist)
ECHO                        Example: --install=C:\Programme\wxFormBuilder
ECHO                        Current: %install%
ECHO.
GOTO End

:Configuration
SET config=%2
SHIFT
SHIFT
GOTO Loop

:Platform
SET platform=%2
SHIFT
SHIFT
GOTO Loop

:Install
SET install=%2
SHIFT
SHIFT
GOTO Loop


:Installation
ECHO Installing %platform%\%config% to %install%
IF not exist "%install%\" ( mkdir "%install%" && echo "%install%" created)
for /f "delims=" %%f in ('dir /ad /b "%install%\"') do rd /s /q "%install%\"%%f
robocopy /mir /ndl /nfl /njh install\distribute "%install%"

echo Plugins:
FOR  %%A IN (additional common containers forms layout) DO (
	echo     %%A
	copy /Y "build\%platform%\%config%\plugins\%%A\lib%%A.dll" "%install%\plugins\%%A" >nul:
)

copy /Y "build\%platform%\%config%\wxFormBuilder\wxFormBuilder.exe" "%install%\" >nul:
