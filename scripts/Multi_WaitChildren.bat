@echo off
REM  "Multi" is a thread-pool emulation helper library for controlling multi-threaded windows batch [*.BAT] files
REM  Copyright (c) 2020-2021 Adisak Pochanayon
REM  Contact: adisak@gmail.com
REM  See Multi_License.txt for details
REM  Currently hosted at https://github.com/adisak/MultiBat

REM -----------------------------------

REM :Multi_WaitChildren
REM Parameter 1: (optional)
REM		value=N - wait until there are less than N children running

SETLOCAL
REM multi_WAITCOUNT is a local variable
SET multi_WAITCOUNT=1

if "%1"=="" GOTO :loop_WaitChildren
SET /A multi_WAITCOUNT=%1
if %multi_WAITCOUNT% LSS 1 set multi_WAITCOUNT=1

if "%2"=="0" (
	REM No Wait
) else if "%2"=="" (
	REM Default Wait is 2 seconds
	call :Wait_Seconds 2
) else (
	REM User Specified Wait Time
	call :Wait_Seconds %2
)

:loop_WaitChildren
call Multi_GetNumChildren.bat
if %MULTI_NUM_CHILDREN% LSS %multi_WAITCOUNT% GOTO :exit_WaitChildren
call :Wait_Seconds
GOTO :loop_WaitChildren

:exit_WaitChildren
ENDLOCAL
goto:EOF

:Wait_Seconds
if ""=="%1" (
	timeout /t 1 /nobreak > nul
) else (
	timeout /t %1 /nobreak > nul
)
goto:EOF