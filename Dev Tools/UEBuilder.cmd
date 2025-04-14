@ECHO off
setlocal

REM At first i wanted to have more checks for more versions of unreal engine, but i think that would be overkill
REM I  realized it would be the same logic just written many more times so i figured 5.3 and 5.4 is enough to test. 

REM ============================ UNREAL VERSION PROMPT ============================
echo Select Unreal Engine Version:
echo [1] Unreal Engine 5.3
echo [2] Unreal Engine 5.4
set /p UE_VERSION_CHOICE="Enter 1 or 2: "

if "%UE_VERSION_CHOICE%"=="1" (
    set UE_VERSION=5.3
) else if "%UE_VERSION_CHOICE%"=="2" (
    set UE_VERSION=5.4
) else (
    echo Invalid choice. Exiting.
    pause
    exit /b
)
echo Unreal Engine version set to %UE_VERSION%
REM ==================================================================

REM ============================ CONFIGURATION ============================
REM IMPORTANT: the project name and path is set to my own team project repo location on my home pc and would require changing for testing.... unless you have the same files.
ECHO Expected unreal engine version: 5.4
SET UE_VERSION=5.4
SET PROJECT_NAME=Sledgrence
SET PROJECT_PATH=C:\Users\Public\GD76PG27PR-Walrus-Unreal\%PROJECT_NAME%.uproject
SET BUILD_CONFIG=Shipping
SET PLATFORM=Win64
SET OUTPUT_DIR=C:\Builds\%PROJECT_NAME%
REM ==================================================================

REM === DESIRED UNREAL PROJECT BUILD PATH  GOES HERE===
SET UE_PATH="C:\Program Files\Epic Games\UE_%UE_VERSION%\Engine\Binaries\Win64\UnrealEditor-Cmd.exe"
REM UnrealEditor-Cmd.exe is part of the ue packaging and not the script i wrote. idk how i confused that but i got stuck on that for a bit 
REM i didnt think there would be a cmd version of the editor
REM ==================================================================

REM ============================ BUILD ============================
ECHO Packaging project...
%UE_PATH% %PROJECT_PATH% -run=Cook ^
-targetplatform=%PLATFORM% ^
-unattended ^
-cookall ^
-build ^
-stage ^
-pak ^
-archive ^
-archivedirectory=%OUTPUT_DIR% ^
-compressed ^
-clientconfig=%BUILD_CONFIG%
REM ==================================================================

ECHO Build complete. Output located at:
ECHO %OUTPUT_DIR%
PAUSE

REM ============================ FLAG NOTES ============================
REM          note to self... stop calling them tags, they are flags

REM -run=Cook =         This flag tells Unreal Engine to run the cooking process, which prepares game assets for packaging
REM                     Cooking is the process of converting game assets (like textures, meshes, sounds, etc.) into a format that can be used by the game engine

REM -unattended =       Run the build process without requiring any user interaction or confirmation prompts.
REM                     This is used for automated or batch processing, ensurin the process runs without waiting for the user to respond to any pop-ups or warnings

REM -cookall =          Tells Unreal Engine to cook ALL game content, not just the content that has changed since the last build
REM                     This ensures that all assets (textures, sounds, meshes, etc.) are pre-processed and optimized, even if no new changes were made to them
REM                     This option can be useful if you want a completely fresh and consistent build.
REM                     

REM -build =            Triggers the compilation and buildign of the project. This step compiles any C++ code (if it applies) and prepares the project for packaging
REM                     This step is essential if your project has code changes or if you want to ensure all assets and resources are up-to-date

REM -stage =            Stages the project by organizing the necessary files and preparing them for packaging
REM                     It effectively sets up everything that will be included in the final packaged build, ensuring the files are properly organized in the correct structure
REM                     Basically setting everythign up so nobody gets left behind. and things are in propper order.

REM -pak =              Packages the project by bundling all the assets and files into .pak files
REM                     .pak files are a format used by Unreal Engine to bundle assets like textures, meshes, and sounds together in a single file for more efficient distribution and loading during gameplay
REM                     so on this one, i mainly referenced soem stack overflow recomendations and i definitely still have questions. it says its a great way to reduce load times and improve performance
REM                     but i am not sure if this is the only way to do that. it seems to make sense i would just want to make sure i am not missing anything

REM -archive =          Archives the final build output once the packaging process is complete
REM                     This step saves the packaged project to a specified directory, effectively creating a backup or final release version of the build
REM                     Tell it to save to the archive directory I specified basically.

REM -archivedirectory = where do you want the archive to go. 

REM -nullrhi  =         NOT CURRENTLY BEING USED 
REM                     It would be -nographics from what i read online. Apparently nographics is unity based and nullrhyi means no rendering, so it runs in the background. this will be useful for future builds maybe?

REM ==================================================================



