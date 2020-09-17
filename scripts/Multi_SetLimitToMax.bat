@echo off
REM  "Multi" is a thread-pool emulation helper library for controlling multi-threaded windows batch [*.BAT] files
REM  Copyright (c) 2020 Adisak Pochanayon
REM  Contact: adisak@gmail.com
REM  See Multi_License.txt for details

REM :Multi_SetLimitToMax

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
