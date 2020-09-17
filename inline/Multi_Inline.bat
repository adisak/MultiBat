REM ---------------------------------------------------------------------------
REM ---------------------------------------------------------------------------
REM ---------------------------------------------------------------------------
goto:EOF
REM Append this to the END of your batch-file [*.BAT] to get inline "Multi" support

REM  "Multi" is a thread-pool emulation helper library for controlling multi-threaded windows batch [*.BAT] files
REM  Copyright (c) 2020 Adisak Pochanayon
REM  Contact: adisak@gmail.com
REM  See Multi_License.txt for details

REM -----------------------------------

:Multi_Setup

call :Multi_SetName %1

if "%2"=="" (
	if "%NUMBER_OF_PROCESSORS%"=="" call :Multi_SetLimitToMax
) else (
	call :Multi_SetLimit %2
)
goto:EOF

REM -----------------------------------

:Multi_SetName

if "%1"=="" (
	SET MULTI_CHILDPROC_WINNAME=Multi-CmdProc
) else (
	SET MULTI_CHILDPROC_WINNAME=Multi-CmdProc-%1
)
goto:EOF

REM -----------------------------------

REM To Enable Hyperthreading, call Multi_SetHyperThread before calling Multi_Setup or Multi_SetLimitToMax

:Multi_SetHyperThread

REM Set variable NumberOfCores
if "%NumberOfCores%"=="" (
	for /f "tokens=*" %%f in ('wmic cpu get NumberOfCores /value ^| find "="') do set %%f
)

REM Set variable MULTI_HAS_HYPERTHREADING
if "%MULTI_HAS_HYPERTHREADING%"=="" (
	if "%NumberOfCores%"=="%NUMBER_OF_PROCESSORS%" (
		REM Non-Hyperthreading
		SET MULTI_HAS_HYPERTHREADING=0
	) else (
		REM Hyperthreading
		SET MULTI_HAS_HYPERTHREADING=1
	)
}

if "%1"=="" (
	SET MULTI_USE_HYPERTHREADING=%MULTI_HAS_HYPERTHREADING%
) else (
	SET MULTI_USE_HYPERTHREADING=%1
)

REM Set the max threads to the limit for Hyperthreading
call :Multi_SetLimitToMax
goto:EOF

REM -----------------------------------

:Multi_SetLimit

if "%1"=="" (
	if "%MULTI_MAXCHILDREN%"=="" call :Multi_SetLimitToMax
	goto:EOF
)

SET /A MULTI_MAXCHILDREN=%1
if %MULTI_MAXCHILDREN% LSS 1 SET MULTI_MAXCHILDREN=1
goto:EOF

REM -----------------------------------

:Multi_SetLimitToMax

REM Set variable NumberOfCores
if "%NumberOfCores%"=="" (
	for /f "tokens=*" %%f in ('wmic cpu get NumberOfCores /value ^| find "="') do set %%f
)

if %NUMBER_OF_PROCESSORS% LEQ 3 (
	SET MULTI_MAXCHILDREN=1
) else (
	if "%NumberOfCores%"=="%NUMBER_OF_PROCESSORS%" (
		REM Non-Hyperthreading
		SET /A MULTI_MAXCHILDREN=%NUMBER_OF_PROCESSORS%-2
	) else if "%MULTI_USE_HYPERTHREADING%"=="1" (
		REM Hyperthreading available and used
		SET /A MULTI_MAXCHILDREN=%NUMBER_OF_PROCESSORS%/2 - 1
	) else (
		REM Hyperthreading available but not used
		SET /A MULTI_MAXCHILDREN=%NUMBER_OF_PROCESSORS%-2
	)
)
goto:EOF

REM -----------------------------------

:Multi_RunWin

call :Multi_WaitChildrenMax
start "%MULTI_CHILDPROC_WINNAME%" /BELOWNORMAL cmd /c %*
goto:EOF

REM -----------------------------------

:Multi_RunWinMin

call :Multi_WaitChildrenMax
start "%MULTI_CHILDPROC_WINNAME%" /MIN /BELOWNORMAL cmd /c %*
goto:EOF

REM -----------------------------------

:Multi_RunSyncMin

REM Use this command to run things that mess with the window title
REM and otherwise would screw up the "Multi" System
start "Multi-Sync" /MIN /WAIT cmd /c %*
goto:EOF

REM -----------------------------------

:Multi_WaitChildrenMax

call :Multi_WaitChildren %MULTI_MAXCHILDREN%
goto:EOF

REM -----------------------------------

:Multi_WaitChildren

SETLOCAL
REM multi_WAITCOUNT is a local variable
SET multi_WAITCOUNT=1

if "%1"=="" GOTO :loop_WaitChildren
SET /A multi_WAITCOUNT=%1
if %WAITCOUNT% LSS 1 set multi_WAITCOUNT=1

:loop_WaitChildren
call :Multi_GetNumChildren
if %MULTI_NUM_CHILDREN% LSS %multi_WAITCOUNT% GOTO :exit_WaitChildren
timeout /t 1 /nobreak > nul
GOTO :loop_WaitChildren

:exit_WaitChildren
ENDLOCAL
goto:EOF

REM -----------------------------------

:Multi_GetNumChildren

REM MULTI_NUM_CHILDREN should contain the number of 
REM running %MULTI_CHILDPROC_WINNAME% instances after this
for /f "usebackq" %%t in (`tasklist /fo csv /fi "WINDOWTITLE eq %MULTI_CHILDPROC_WINNAME%" ^| find /c "cmd"`) do (
	SET MULTI_NUM_CHILDREN=%%t
)
goto:EOF

REM -----------------------------------
