@echo off
REM  "Multi" is a thread-pool emulation helper library for controlling multi-threaded windows batch [*.BAT] files
REM  Copyright (c) 2020 Adisak Pochanayon
REM  Contact: adisak@gmail.com
REM  See Multi_License.txt for details

REM :Multi_SetName

if "%1"=="" (
	SET MULTI_CHILDPROC_WINNAME=Multi-CmdProc
) else (
	SET MULTI_CHILDPROC_WINNAME=Multi-CmdProc-%1
)
goto:EOF
