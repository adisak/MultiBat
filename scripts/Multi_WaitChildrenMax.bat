@echo off
REM  "Multi" is a thread-pool emulation helper library for controlling multi-threaded windows batch [*.BAT] files
REM  Copyright (c) 2020-2021 Adisak Pochanayon
REM  Contact: adisak@gmail.com
REM  See Multi_License.txt for details
REM  Currently hosted at https://github.com/adisak/MultiBat

REM -----------------------------------

REM :Multi_WaitChildrenMax
REM Wait until less than MULTI_MAXCHILDREN children are running

if "%MULTI_MAXCHILDREN%"=="" call Multi_SetLimitToMax.bat

call Multi_WaitChildren.bat %MULTI_MAXCHILDREN%
goto:EOF

