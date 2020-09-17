@echo off
REM  "Multi" is a thread-pool emulation helper library for controlling multi-threaded windows batch [*.BAT] files
REM  Copyright (c) 2020 Adisak Pochanayon
REM  Contact: adisak@gmail.com
REM  See Multi_License.txt for details

REM :Multi_Setup

call Multi_SetName.bat %1

if "%2"=="" (
	if "%NUMBER_OF_PROCESSORS%"=="" call Multi_SetLimitToMax.bat
) else (
	call Multi_SetLimit.bat %2
)

goto:EOF
