@echo off
REM  "Multi" is a thread-pool emulation helper library for controlling multi-threaded windows batch [*.BAT] files
REM  Copyright (c) 2020 Adisak Pochanayon
REM  Contact: adisak@gmail.com
REM  See Multi_License.txt for details

REM To Enable Hyperthreading, call Multi_SetHyperThread before calling Multi_Setup or Multi_SetLimitToMax

REM :Multi_SetHyperThread

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
call Multi_SetLimitToMax.bat
goto:EOF
