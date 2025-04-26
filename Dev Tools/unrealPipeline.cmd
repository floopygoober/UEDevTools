@ECHO OFF
setlocal

REM IMPORTANT NOTE: ive tested this alot now and even reverted back to the one we did in class and for some reason i can not get it to build. so 
REM basically i have to hadn this in as is because im already over time. i would love to find out what went wrong with this but im not sure where to start now. 
REM even when i remove the extra stuff i added it fails to build which sucks but i wanted to submit something showing i tried to build something new 
REM and not just continue to copy stuff we did in class. 

REM ======================================= INTRODUCTION =======================================
REM This script automates building, optional dups fixing, and optional VS file regen for an Unreal project.
REM 
REM After doing a bunch of testing I realized: 
REM It’s better to keep this script modular and simple, rather than stacking too much stuff inside it. hence why i removed the test code from class.
REM ============================================================================================

REM ======================================= USAGE CHECK ========================================
REM Reminder: all params must be filled properly, even if it's "skip" for some.
REM I didn't want optional params to confuse the batch parser later.

IF "%~3"=="" (
    ECHO Usage: unrealPipeline.cmd ProjectPath Platform BuildCfg FixDups RegenVS
    EXIT /B 1
)
REM ============================================================================================

REM ====================================== ARGUMENTS SETUP =====================================
SET "PROJ=%~1"
SET "PLAT=%~2"
SET "CFG=%~3"
SET "FIXDUPS=%~4"
SET "REGEN=%~5"
REM ============================================================================================

REM ====================================== PLATFORM CHECK ======================================
REM Setting the correct Unreal Platform string that Unreal Automation Tool expects.

SET "UEPLAT="
IF /I "%PLAT%"=="win" SET "UEPLAT=Win64"
IF /I "%PLAT%"=="linux" SET "UEPLAT=Linux"
IF /I "%PLAT%"=="android" SET "UEPLAT=Android"

IF /I "%UEPLAT%"=="" (
    ECHO [ERROR] Unknown Platform. Supported: win, linux, android
    EXIT /B 1
)
REM ============================================================================================

REM =================================== CONFIGURATION SETUP ====================================
REM Defaulting to Development config unless otherwise specified.
REM Note: Unreal calls "shipping" builds "Shipping", not "shipping" or anything else.

SET "UECFG=Development"
IF /I "%CFG%"=="shipping" SET "UECFG=Shipping"

REM Set up key paths to Unreal Engine executables.
SET "UE_ROOT=C:\Program Files\Epic Games\UE_5.5"
SET "EU_CMD=%UE_ROOT%\Engine\Binaries\Win64\UnrealEditor-Cmd.exe"
SET "UAT=%UE_ROOT%\Engine\Build\BatchFiles\RunUAT.bat"

REM After further digging apparently this is a file that is supposed to be in the engine folder but it just isnt for me, even after a full reinstall of the engine.
REM im keeping this here in case you have it on your system. But yeah this entire script does not work without it basically. so i think i ran out of time chasing the wrong fix.
REM https://forums.unrealengine.com/t/not-finding-generateprojectfiles-bat/337138 reference to where i found this file and thought i could use it.
REM it could be that i have not set the test uproject up as a C++ build so ill try fixing that
SET "GENPROJ=%UE_ROOT%\Engine\Build\BatchFiles\GenerateProjectFiles.bat"

REM Set log directory relative to where this script is stored.
SET "LOGDIR=%~dp0logs"
IF NOT EXIST "%LOGDIR%" MD "%LOGDIR%"

SET "BUILDLOG=%LOGDIR%\build_%PLAT%.txt"

REM Info dump - useful when debugging
ECHO [INFO] Platform=%UEPLAT% Config=%UECFG%
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

REM ============================ OPTIONAL STEP: REGENERATE VS FILES ============================
REM If wanted, you can clean up old files and force Unreal to regenerate the Visual Studio solution and project files.

IF /I "%REGEN%"=="regen" (
    ECHO [INFO] Cleaning project folders...

    RMDIR /S /Q "%~dp1Intermediate"
    RMDIR /S /Q "%~dp1Binaries"
    RMDIR /S /Q "%~dp1Saved"

    REM After cleaning, regenerate VS project files.
    ECHO [INFO] Regenerating Visual Studio project files...
    CALL "%GENPROJ%" -projectfiles -project="%PROJ%" -game -engine

    IF %ERRORLEVEL% NEQ 0 (
        ECHO [ERROR] Failed to regenerate Visual Studio project files
        EXIT /B 1
    )

    ECHO [INFO] Visual Studio project files regenerated successfully
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

ECHO [INFO] Build Complete :D
EXIT /B 0
REM ============================================================================================

REM ======================================== FLAG NOTES ========================================

REM -pak: Combines assets into optimized .pak files
REM -prereqs: Bundles extra stuff (like redistributables) - still not sure what that fully means tbh. but thats what ive found online.
REM /S Remove all subdirectories and files. with out it rmdir would refuse to delete a folder that has stuff in it. 
REM /Q Quiet mode removes the prompts for "are you sure" on deleting files. which was getting really annoying when testing. 

REM Apparently im ocd enough to line up all of these little dividers because it looks so much cleaner. but its such a waste of time lol.
