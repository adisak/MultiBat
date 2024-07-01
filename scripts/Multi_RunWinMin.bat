@echo off
REM  "Multi" is a thread-pool emulation helper library for controlling multi-threaded windows batch [*.BAT] files
REM  Copyright (c) 2020-2021 Adisak Pochanayon
REM  Contact: adisak@gmail.com
REM  See Multi_License.txt for details
REM  Currently hosted at https://github.com/adisak/MultiBat

REM -----------------------------------

REM :Multi_RunWinMin

if "%MULTI_CHILDPROC_WINNAME%"=="" call Multi_SetName.bat

call Multi_WaitChildrenMax.bat 0
start "%MULTI_CHILDPROC_WINNAME%" /MIN /BELOWNORMAL cmd /c %*
goto:EOF
