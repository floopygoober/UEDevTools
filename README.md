# UEDevTools
stuff for team project, and other useful tools i may develop in the future

I developed the unreal builder first because I made the mistake of starting on a tool before reading the requirements for the assignment. oof.
I have had a hard time thinking of what kind of dev tool i would need to create for our project to be honest so this seemed like a good place to start but it is more just review
I did learn a bit more about the flags that are used when running the command line code to generate a ue project but i fear this is not enough so now i need to think of a python tool to add as well. 

UPDATE 
Had an idea to clean up unnecessary garbage in the levels if its accidentally generated. stuff that has slipped by me in the past is duplicate objects being inside of each other so 
a visual inspection could possibly miss this. with our game being destruction heavy this could really mess us up in performance. so i decided id make a tool to detect the same mesh overlapping itself
added a tolerance to it so that if its off ever so slightly we can still detect it. 
Definitely liking how many libraries python has because it makes somewhat complex things super easy. love how easy the documentation is to find as well!


NEW NOTES FOR FINAL ASSIGNMENT:

i tried to base my project what we did in class but i wanted it to run my duplicate destroyer script, and also delete and regenerate the visual studio files through the cmd script with out you clickity on it.

Issue being i was heavily relying on a GenerateProjectFiles.bat in the directory and the test project i made does not have that in the root unreal file, even after reinstalling.
At this point ive kept it in because im hoping maybe by some chance you have that file in your system and it will work but this does crash on build every time for me and i just dont know how to fix it anymore
You can see all the notes i wrote of the new things i used in this at the bottom of the script, and i am currently making a new C++ project in hopes that maybe that installed the bat file i needed.


With the py script, ive tested it manually i know that works  for sure but it does not give any feedback, it just does it job and closes. if you run that normally (like last assignment)
Im a bit disappointed this didn't work out, i thought i had something cool here but i ran out of time to ask questions so i definitely should have started a lot earlier. 

it does spit out errors into a log in the ue directory so you can check there for the details but i think i might have over reached what i could do on this project. bummer but still i learned some cool things that are possible
like the /s and /q to prevent the popups when deleting files etc, that comes in hadny for sure. 

also windows 11 makes file explorer next to unusable its painful. i need to figure out what is wrong with that


as a last ditch i found this link https://github.com/wallerm/UE4/blob/master/Engine/Build/BatchFiles/GenerateProjectFiles.bat
and ill be trying to add it into the project files in hopes that it works.

so unfortunately that did not work either. i must have missed something really obvious on this one, it seems that ue5 is supposed to have this in the source files but for some reason i cannot generate it. 



========================================================================== FINAL READ ME UPDATE (for now) ==============================================================================================================
The file that i am submitting is both the ueBuilderWorking AND the python mesh overlap script as it is needed for the CMD script

==========================================================================================INSTRUCTIONS================================================================================= (NO Im not lining it up like my comments)

to set up and run this project first ensure both the cmd script and AT LEAST the python script are in the projects root folder. it just makes life easier instead of writing out each file path.
Then next you should navigate to the cmd script in your cmd window, you can choose to run the python script by calling DUPS in the fourth input of the script or write anything else to bypass it. skip, random letters etc as long
as you dont leave the input field blank. 

==========================================================================================Final Notes =================================================================================
in the git repo you can see the unrealPipeline script was what i had initially intended was to run this and also delete and regenerate the visual studio files for the project, but it relied on a bat script that i dont actually have
. you can see in detail the notes above this final section where i tried a few things to see if it could be added back in, and on the unreal forums you can see posts of people saying it should be in the engine folder i was looking
for it but maybe it is deprecated or something. i tried making  a C++ project from scratch to be sure and it also did not in fact have it. i left it in the repo so you can see the process i was trying to get to work but i had to submit a safety net with something that functioned. 