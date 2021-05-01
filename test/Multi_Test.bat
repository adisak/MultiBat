@echo off
REM  "Multi" is a thread-pool emulation helper library for controlling multi-threaded windows batch [*.BAT] files
REM  Copyright (c) 2020-2021 Adisak Pochanayon
REM  Contact: adisak@gmail.com
REM  See Multi_License.txt for details
REM  Currently hosted at https://github.com/adisak/MultiBat

REM -----------------------------------

REM TEST Multi
REM :TestMultithreading
SETLOCAL
SET PATH=%PATH%;..\scripts

call Multi_Setup.bat

SET MULTI_MAXCHILDREN=4

call Multi_RunWin.bat pause
call Multi_RunWin.bat pause
call Multi_RunWin.bat pause
call Multi_RunWin.bat pause
call Multi_RunWin.bat pause
call Multi_RunWin.bat pause

call Multi_WaitChildren.bat

ENDLOCAL
goto:EOF
