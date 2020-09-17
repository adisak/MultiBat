@echo off
REM  "Multi" is a thread-pool emulation helper library for controlling multi-threaded windows batch [*.BAT] files
REM  Copyright (c) 2020 Adisak Pochanayon
REM  Contact: adisak@gmail.com
REM  See Multi_License.txt for details

REM :Multi_WaitChildren

SETLOCAL
REM multi_WAITCOUNT is a local variable
SET multi_WAITCOUNT=1

if "%1"=="" GOTO :loop_WaitChildren
SET /A multi_WAITCOUNT=%1
if %WAITCOUNT% LSS 1 set multi_WAITCOUNT=1

:loop_WaitChildren
call Multi_GetNumChildren.bat
if %MULTI_NUM_CHILDREN% LSS %multi_WAITCOUNT% GOTO :exit_WaitChildren
timeout /t 1 /nobreak > nul
GOTO :loop_WaitChildren

:exit_WaitChildren
ENDLOCAL
goto:EOF
