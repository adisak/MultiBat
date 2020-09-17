@echo off
REM  "Multi" is a thread-pool emulation helper library for controlling multi-threaded windows batch [*.BAT] files
REM  Copyright (c) 2020 Adisak Pochanayon
REM  Contact: adisak@gmail.com
REM  See Multi_License.txt for details

REM :Multi_RunWin

if "%MULTI_CHILDPROC_WINNAME%"=="" call Multi_SetName.bat

call Multi_WaitChildrenMax.bat
start "%MULTI_CHILDPROC_WINNAME%" /BELOWNORMAL cmd /c %*
goto:EOF
