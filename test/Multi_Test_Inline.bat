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

call :Multi_Setup

SET MULTI_MAXCHILDREN=4

call :Multi_RunWin pause
call :Multi_RunWin pause
call :Multi_RunWin pause
call :Multi_RunWin pause
call :Multi_RunWin pause
call :Multi_RunWin pause

call :Multi_WaitChildren

ENDLOCAL
goto:EOF


REM ---------------------------------------------------------------------------
REM ---------------------------------------------------------------------------
REM ---------------------------------------------------------------------------
goto:EOF
REM Append this to the END of your batch-file [*.BAT] to get inline "Multi" support

REM  "Multi" is a thread-pool emulation helper library for controlling multi-threaded windows batch [*.BAT] files
REM  Copyright (c) 2020-2021 Adisak Pochanayon
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
REM Returns: MULTI_CHILDPROC_WINNAME - name to use for child processes (the window title)

if "%1"=="" (
	SET MULTI_CHILDPROC_WINNAME=Multi-CmdProc
) else (
	SET MULTI_CHILDPROC_WINNAME=Multi-CmdProc-%1
)
goto:EOF

REM -----------------------------------

REM To Enable Hyperthreading, call Multi_SetHyperThread before calling Multi_Setup or Multi_SetLimitToMax

:Multi_SetHyperThread
REM Parameter 1: (optional)
REM		value=1	(or unspecified) - Use Hyperthreading if available
REM		value=0 (or other) - Do not use Hyperthreading to compute the max threads
REM Returns: NumberOfCores - number of real CPU cores
REM Returns: MULTI_HAS_HYPERTHREADING - 1 if the CPU has Hyperthreading
REM Returns: MULTI_USE_HYPERTHREADING - 1 if "Multi" should use Hyperthreading

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

REM Set the max threads to the limit (respecting Hyperthreading options)
call :Multi_SetLimitToMax
goto:EOF

REM -----------------------------------

:Multi_SetLimit
REM Parameter 1:
REM		value=N	- Use N as the number of max threads
REM		unspecified - Compute the default number of max threads
REM Returns: MULTI_MAXCHILDREN - the maximum number of child processes to run simultaneously

if "%1"=="" (
	if "%MULTI_MAXCHILDREN%"=="" call :Multi_SetLimitToMax
	goto:EOF
)

SET /A MULTI_MAXCHILDREN=%1
if %MULTI_MAXCHILDREN% LSS 1 SET MULTI_MAXCHILDREN=1
goto:EOF

REM -----------------------------------

:Multi_SetLimitToMax
REM Parameter 1: (optional)
REM		Passed to Multi_SetHyperThread if present
REM Returns: MULTI_MAXCHILDREN - max number of "threads" in pool for "Multi"

if "%1"=="" (
	REM Check if Hyperthreading support was initialized
	if "%NumberOfCores%"=="" (
		call :Multi_SetHyperThread 0
		REM Multi_SetHyperThread calls back to this subroutine so exit to prevent recursion
		goto:EOF
	)
) else (
	call :Multi_SetHyperThread %1
	REM Multi_SetHyperThread calls back to this subroutine so exit to prevent recursion
	goto:EOF
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

if "%MULTI_CHILDPROC_WINNAME%"=="" call :Multi_SetName

call :Multi_WaitChildrenMax
start "%MULTI_CHILDPROC_WINNAME%" /BELOWNORMAL cmd /c %*
goto:EOF

REM -----------------------------------

:Multi_RunWinMin

if "%MULTI_CHILDPROC_WINNAME%"=="" call :Multi_SetName

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

REM Wait until less than MULTI_MAXCHILDREN children are running

if "%MULTI_MAXCHILDREN%"=="" call :Multi_SetLimitToMax

call :Multi_WaitChildren %MULTI_MAXCHILDREN%
goto:EOF

REM -----------------------------------

:Multi_WaitChildren

SETLOCAL
REM multi_WAITCOUNT is a local variable
SET multi_WAITCOUNT=1

if "%1"=="" GOTO :loop_WaitChildren
SET /A multi_WAITCOUNT=%1
if %multi_WAITCOUNT% LSS 1 set multi_WAITCOUNT=1

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
REM Returns: MULTI_NUM_CHILDREN - the number of "children" processes (Windows named MULTI_CHILDPROC_WINNAME)

if "%MULTI_CHILDPROC_WINNAME%"=="" call :Multi_SetName

REM MULTI_NUM_CHILDREN should contain the number of 
REM running %MULTI_CHILDPROC_WINNAME% instances after this
for /f "usebackq" %%t in (`tasklist /fo csv /fi "WINDOWTITLE eq %MULTI_CHILDPROC_WINNAME%" ^| find /c "cmd"`) do (
	SET MULTI_NUM_CHILDREN=%%t
)
goto:EOF

REM -----------------------------------
