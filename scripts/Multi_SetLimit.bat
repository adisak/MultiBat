@echo off
REM  "Multi" is a thread-pool emulation helper library for controlling multi-threaded windows batch [*.BAT] files
REM  Copyright (c) 2020-2021 Adisak Pochanayon
REM  Contact: adisak@gmail.com
REM  See Multi_License.txt for details
REM  Currently hosted at https://github.com/adisak/MultiBat

REM -----------------------------------

REM :Multi_SetLimit
REM Parameter 1:
REM		value=N	- Use N as the number of max threads
REM		unspecified - Compute the default number of max threads
REM Returns: MULTI_MAXCHILDREN - the maximum number of child processes to run simultaneously

if "%1"=="" (
	if "%MULTI_MAXCHILDREN%"=="" call Multi_SetLimitToMax.bat
	goto:EOF
)

SET /A MULTI_MAXCHILDREN=%1
if %MULTI_MAXCHILDREN% LSS 1 SET MULTI_MAXCHILDREN=1
goto:EOF
