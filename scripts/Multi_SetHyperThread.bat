@echo off
REM  "Multi" is a thread-pool emulation helper library for controlling multi-threaded windows batch [*.BAT] files
REM  Copyright (c) 2020-2021 Adisak Pochanayon
REM  Contact: adisak@gmail.com
REM  See Multi_License.txt for details
REM  Currently hosted at https://github.com/adisak/MultiBat

REM -----------------------------------

REM To Enable Hyperthreading, call Multi_SetHyperThread before calling Multi_Setup or Multi_SetLimitToMax

REM :Multi_SetHyperThread
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
call Multi_SetLimitToMax.bat
goto:EOF
