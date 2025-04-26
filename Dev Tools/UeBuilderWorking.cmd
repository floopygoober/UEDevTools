@ECHO OFF

REM
REM	Platform : Win | Linux ettc kjhdkjhdgf
REM

IF "%~4"=="" (
	ECHO Usage: unrealPipeline.cmd ProjectPath Platform BuildCfg dups
)

SET "PROJ=%~1"
SET "PLAT=%~2"
SET "CFG=%~3"
SET "DUPS=%~4"
REM REMOVED REGEN FILES AND TEST BECAUSE I COULDNT GET IT TO WORK.

REM ====================================== PLATFORM CHECK ======================================
SET "UEPLAT="
IF /I "%PLAT%"=="win" SET "UEPLAT=Win64"
IF /I "%PLAT%"=="linux" SET "UEPLAT=Linux"
IF /I "%PLAT%"=="android" SET "UEPLAT=Android"

IF /I "%UEPLAT%"=="" (
	ECHO [ERROR] Unknown Platform
	EXIT /B 1
)
REM ============================================================================================

REM =================================== CONFIGURATION SETUP ====================================
SET "UECFG=Development"
IF /I "%CFG%"=="shipping" SET "UECFG=Shipping"

SET "UE_ROOT=C:\Program Files\Epic Games\UE_5.5"
SET "EU_CMD=%UE_ROOT%\Engine\Binaries\Win64\UnrealEditor-Cmd.exe"
SET "UAT=%UE_ROOT%\Engine\Build\BatchFiles\RunUAT.bat"

REM Set log directory relative to where this script is stored.
SET "LOGDIR=%~dp0logs"
IF NOT EXIST "%LOGDIR%" MD "%LOGDIR%"
SET "BUILDLOG=%LOGDIR%\build_%PLAT%.txt"

REM Info dump - useful when debugging
ECHO [INFO] Platform=%UEPLAT% Config=%UECFG% RunTests=%TEST%
REM ============================================================================================

REM =================================== PROJECT PATH CLEANUP ===================================
REM Making sure the project path is fully qualified.
REM Avoids relative paths issues (especially on different drives).
REM I hope this works on all systems, ive only tested it on my own pc so far. so its just like a trust
REM the dude on stack overflow moment.
REM If %PROJ% was set to a relative path like .. , this command would resolve it to something like C:\Users\Folder\YourProjectName

FOR %%I IN ("%PROJ%") DO SET "PROJ=%%~fI"
REM ============================================================================================

REM ============================== OPTIONAL STEP: FIX DUPLICATES ===============================
REM Before building, optionally fix mesh overlaps with a helper python script.

IF /I "%FIXDUPS%"=="dups" (
    ECHO [INFO] Running MeshOverlapRemover.py...
    python "%~dp0MeshOverlapRemover.py"
    IF %ERRORLEVEL% NEQ 0 (
        ECHO [ERROR] MeshOverlapRemover failed
        EXIT /B 1
    )
    ECHO [INFO] Mesh overlap removal complete
)
REM ============================================================================================

REM ==================================== BUILD THE PROJECT =====================================
REM Trigger Unreal Automation Tool to build the project.

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

ECHO [INFO] Build builded :D
EXIT /B 0
REM ============================================================================================


REM -pak: Combines assets into optimized .pak files
REM -prereqs: Bundles extra stuff (like redistributables) - still not sure what that fully means tbh. but thats what ive found online.
REM /S Remove all subdirectories and files. with out it rmdir would refuse to delete a folder that has stuff in it. 
REM /Q Quiet mode removes the prompts for "are you sure" on deleting files. which was getting really annoying when testing. 

REM Apparently im ocd enough to line up all of these little dividers because it looks so much cleaner. but its such a waste of time lol.