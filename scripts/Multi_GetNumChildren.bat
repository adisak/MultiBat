@echo off
REM  "Multi" is a thread-pool emulation helper library for controlling multi-threaded windows batch [*.BAT] files
REM  Copyright (c) 2020 Adisak Pochanayon
REM  Contact: adisak@gmail.com
REM  See Multi_License.txt for details

REM :Multi_GetNumChildren
REM SET MULTI_NUM_CHILDREN=0
REM MULTI_NUM_CHILDREN should contain the number of 
REM running %MULTI_CHILDPROC_WINNAME% instances after this
for /f "usebackq" %%t in (`tasklist /fo csv /fi "WINDOWTITLE eq %MULTI_CHILDPROC_WINNAME%" ^| find /c "cmd"`) do (
	set MULTI_NUM_CHILDREN=%%t
)
goto:EOF
