@echo off
REM  "Multi" is a thread-pool emulation helper library for controlling multi-threaded windows batch [*.BAT] files
REM  Copyright (c) 2020-2021 Adisak Pochanayon
REM  Contact: adisak@gmail.com
REM  See Multi_License.txt for details
REM  Currently hosted at https://github.com/adisak/MultiBat

REM -----------------------------------

REM :Multi_SetLimitToMax
REM Parameter 1: (optional)
REM		Passed to Multi_SetHyperThread if present
REM Returns: MULTI_MAXCHILDREN - max number of "threads" in pool for "Multi"

if "%1"=="" (
	REM Check if Hyperthreading support was initialized
	if "%NumberOfCores%"=="" (
		call Multi_SetHyperThread.bat 0
		REM Multi_SetHyperThread calls back to this subroutine so exit to prevent recursion
		goto:EOF
	)
) else (
	call Multi_SetHyperThread.bat %1
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
