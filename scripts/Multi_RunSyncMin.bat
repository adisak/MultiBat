@echo off
REM  "Multi" is a thread-pool emulation helper library for controlling multi-threaded windows batch [*.BAT] files
REM  Copyright (c) 2020-2021 Adisak Pochanayon
REM  Contact: adisak@gmail.com
REM  See Multi_License.txt for details
REM  Currently hosted at https://github.com/adisak/MultiBat

REM -----------------------------------

REM :Multi_RunSyncMin

REM Use this command to run things that mess with the window title
REM and otherwise would screw up the "Multi" System
start "Multi-Sync" /MIN /WAIT cmd /c %*
goto:EOF
