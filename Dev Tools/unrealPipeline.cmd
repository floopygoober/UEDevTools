@ECHO OFF

REM
REM	Platform : Win | Linux etc
REM

IF "%~4"=="" (
	ECHO Usage: unrealPipeline.cmd ProjectPath Platform BuildCfg RunTests dups
	EXIT /B 1
)

SET "PROJ=%~1"
SET "PLAT=%~2"
SET "CFG=%~3"
SET "TEST=%~4"
SET "FIXMESH=%~5"

SET "UEPLAT="
IF /I "%PLAT%"=="win" SET "UEPLAT=Win64"
IF /I "%PLAT%"=="linux" SET "UEPLAT=Linux"
IF /I "%PLAT%"=="android" SET "UEPLAT=Android"

IF /I "%UEPLAT%"=="" (
	ECHO [ERROR] Unknown Platform
	EXIT /B 1
)

SET "UECFG=Development"
IF /I "%CFG%"=="shipping" SET "UECFG=Shipping"

SET "UE_ROOT=C:\Program Files\Epic Games\UE_5.4"
SET "EU_CMD=%UE_ROOT%\Engine\Binaries\Win64\UnrealEditor-Cmd.exe"
SET "UAT=%UE_ROOT%\Engine\Build\BatchFiles\RunUAT.bat"

SET "LOGDIR=%~dp0logs"
IF NOT EXIST "%LOGDIR%" MD "%LOGDIR%"
SET "TESTLOG=%LOGDIR%\tests_%PLAT%.txt"
SET "BUILDLOG=%LOGDIR%\build_%PLAT%.txt"

ECHO [INFO] Platform=%UEPLAT% Config=%UECFG% RunTests=%TEST%

FOR %%I IN ("%PROJ%") DO SET "PROJ=%%~fI"

IF /I "%TEST%"=="test" (
	ECHO [INFO] Running tests...
	"%EU_CMD%" "%PROJ%" ^
	-unattended ^
	-nopause ^
	-NullRHI ^
	-Map=/Game/UnitTest ^
	-ExecCmds="Automation RunTest Project.Functional.FT_CheckJumpHeight Project.Functional.FT_PlayerSpawns; Quit" ^
	-TestExit="Automation Test Queue Empty" ^
	-ReportOutputPath="%LOGDIR%\AutomationReports" ^
	-log="%TESTLOG%"
	
	IF %ERRORLEVEL% NEQ 0 (
		ECHO [ERROR] Tests failed - see %TESTLOG%
		EXIT /B 1
	)
	ECHO [INFO] Tests passed :D
)

IF /I "%FIXMESH%"=="dups" (
	ECHO [INFO] Running MeshOverlapRemover.py...
	python "%~dp0MeshOverlapRemover.py"
	IF %ERRORLEVEL% NEQ 0 (
		ECHO [ERROR] MeshOverlapRemover failed
		EXIT /B 1
	)
	ECHO [INFO] Mesh overlap removal complete
)

ECHO [INFO] Building project...
"%UAT%" BuildCookRun ^
	-project="%PROJ%" ^
	-noP4 ^
	-platform="%UEPLAT%" ^
	-clientconfig="%UECFG%" ^
	-cook -build -stage -package -archive -pak -prereqs ^
	-utf8output ^
	-log="%BUILDLOG%"

IF %ERRORLEVEL% EQU 1 (
	ECHO [ERROR] Build Failed :C
	EXIT /B 1
)

ECHO [INFO] Build Builded
EXIT /B 0
