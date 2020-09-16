@echo off
REM  "Multi" is a thread-pool emulation helper library for controlling multi-threaded windows batch [*.BAT] files
REM  Copyright (c) 2020 Adisak Pochanayon
REM  Contact: adisak@gmail.com
REM  See Multi_License.txt for details

REM :Multi_SetLimit
if "%1"=="" GOTO :NoLimitSet

SET /A MULTI_MAXCHILDREN=%1
if %MULTI_MAXCHILDREN% LSS 1 SET MULTI_MAXCHILDREN=1
GOTO:EOF

:NoLimitSet
if "%MULTI_MAXCHILDREN%"=="" call Multi_SetLimitToMax.bat
