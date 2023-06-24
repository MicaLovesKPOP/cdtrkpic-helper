@echo off
setlocal enabledelayedexpansion
REM set variable we can use to navigate through the script
set "nextsection=inputtrack"

:start
del error.log 2>nul
cls
echo ----------------------------------------------------
echo m                                                  m
echo a       Crashday Track Picture Helper Script       a
echo d                 version  #230624                 d
echo e                                                  e
echo ----------------------------------------------------
echo b       Tips (written for Paint.NET users):        b
echo y                                                  y
echo :   1.  Take a screenshot of your track using      :
echo m       the Free Cam. (default key: End)           m
echo i                                                  i
echo c   2.  Resize, Canvas Resize and/or Crop the      c
echo a       image to a resolution of 1280x1024.        a
echo l                                                  l
echo o   3.  Then resize the image to 1024x1024, by     o
echo v       disabling "Maintain Aspect Ratio".         v
echo e                                                  e
echo s   4.  Now save the image as a .TGA file.         s
echo k       Crashday uses 32-bit uncompressed TGAs.    k
echo p                                                  p
echo o   5.  Make sure the tracks and images you want   o
echo p       to merge are in the cdtrkpic folder.       p
echo ----------------------------------------------------
echo.

REM preview currently set variables (after every section)
if defined i (
    echo Input track:  '!i!'
) else (
	echo Input track:  ...
)

if defined p (
    echo Input image:  '!p!'
) else (
	echo Input image:  ...
)

if defined backup_filename (
	echo Backup track: '!backup_filename!'
) else (
	echo Backup track: ...
)
echo.
goto !nextsection!
:ThisBatFileTookMeLongerToCodeThisCleanlyThanIWishToAdmit





REM let user input track
:inputtrack
set /P "i=Enter input track file: "
for /F "delims=" %%a in ("!i!") do set "i=%%~a"

REM check if filename entered doesn't include .trk, add it
set "extension=!i:~-4!"
if /I not "!extension!"==".trk" set "i=!i!.trk"

REM check if file exists
if not exist "!i!" (
	REM input file does not exist, repeating question...
    set "i="
    echo Input track file does not exist. Press any key to try again . . .
    pause > nul
	set "nextsection=inputtrack"
    goto start
)
REM check if user-defined TRK file is actually a Crashday TRK file
:trkcheck
if not "!trkcheck!"=="skip" (
	if exist "..\_python-interpreter\dist\filetype_checker.exe" (
		for /f %%i in ('..\src\python-interpreter\dist\filetype_checker.exe "!i!"') do set "file_type=%%i"
		if "!file_type!"=="TRACK" (
			REM if user came from :changed_mind, send them back
			if /I "!changed_mind!"=="1" (
				set "nextsection=output_track"
				goto start
			)
			set "nextsection=inputimage"
			goto start
		) else (
			REM input file does not appear to be in Crashday's TRK format, despite its .TRK extension
			echo.
			echo Input track file does not appear to be in Crashday TRK format
			echo If you think this is incorrect, please confirm you can load the track ingame
			echo If you can open the track ingame, please notify Mica ^(the author^) and send him the file
			echo.
			echo Press any key to try again . . .
			pause > nul
			set "i="
			set "nextsection=inputtrack"
			goto start
		)
	) else (
		set "trk_or_tga=TRK"
		set "nextsection=filetypechecker_error"
		goto start
	)
	REM ...?
)

REM let user input image
:inputimage
set /P "p=Type or drag input image file: "
for /F "delims=" %%a in ("!p!") do set "p=%%~a"

REM check if filename entered doesn't include .tga, add it
set "extension=!p:~-4!"
if /I not "!extension!"==".tga" set "p=!p!.tga"

if not exist "!p!" (
	REM input file does not exist, repeating question...
    set "p="
    echo Input image file does not exist. Press any key to try again . . .
    pause > nul
	set "nextsection=inputimage"
    goto start
)

REM check if user-defined TGA file is a compatible TGA file
:tgacheck
if not "!tgacheck!"=="skip" (
    if exist "..\_python-interpreter\dist\filetype_checker.exe" (
		for /f %%i in ('..\src\python-interpreter\dist\filetype_checker.exe "!p!"') do set "file_type=%%i"
		if "!file_type!"=="TGA_32_UNCOMPRESSED_1024" (
			REM if user came from :changed_mind, send them back
			if /I "!changedmind!"=="2" (
				set "nextsection=output_track"
				goto start
			)
			set "nextsection=output_track"
			goto start
		) else (
			echo.
			echo ERROR:
			if "!file_type!"=="TGA_32_UNCOMPRESSED_NOT1024" (
				echo TGA is not 1024x1024 pixels
			) else (
				if "!file_type!"=="TGA_32_NOTUNCOMPRESSED_1024" (
					echo TGA is not uncompressed.
				) else (
					if "!file_type!"=="TGA_NOT32_UNCOMPRESSED_1024" (
						echo TGA is not 32-bit
					) else (
						if "!file_type!"=="TGA_32_NOTUNCOMPRESSED_NOT1024" (
							echo TGA is not uncompressed
							echo TGA is not 1024x1024 pixels
						) else (
							if "!file_type!"=="TGA_NOT32_UNCOMPRESSED_NOT1024" (
								echo TGA is not 32-bit
								echo TGA is not 1024x1024 pixels
							) else (
								if "!file_type!"=="TGA_NOT32_NOTUNCOMPRESSED_1024" (
									echo TGA is not 32-bit
									echo TGA is not uncompressed
								) else (
									if "!file_type!"=="TGA_NOT32_NOTUNCOMPRESSED_NOT1024" (
										echo TGA is not 32-bit
										echo TGA is not uncompressed
										echo TGA is not 1024x1024 pixels
									) else (
										REM input file does not appear to be in TGA format, despite its .TGA extension
										set "p="
										echo Input image file does not appear to be in TGA format
										echo If you think this is incorrect, please confirm you can open the file as image
										echo If you can open the file as image, please notify Mica ^(the author^) and send him the file
										echo.
										echo Press any key to try again . . .
										pause > nul
										set "nextsection=inputimage"
										goto start
									)
								)
							)
						)
					)
				)
			)
		)
		REM the below counts for all invalid TGA outcomes
		set "p="
		echo.
		echo Please fix this and then press any key to try again . . .
		pause > nul
		set "nextsection=inputimage"
		goto start
	)
	set "trk_or_tga=TGA"
	set "nextsection=filetypechecker_error"
	goto start
) else goto output_track
REM input file does not appear to be in TGA format, despite its .TGA extension
set "p="
echo Input image file does not appear to be in TGA format
echo If you think this is incorrect, please confirm you can open the file as image
echo If you can open the file as image, please notify Mica ^(the author^) and send him the file
echo.
echo Press any key to try again . . .
pause > nul
set "nextsection=inputimage"
goto start

REM negative filetype check result (for either TRK or TGA)
:filetypechecker_error
echo ERROR:
echo Failed to run 'filetype_checker.exe'
echo - Make sure the '_python-interpreter' folder is present in the same folder as the 'cdtrkpic_mica' folder
echo - Make sure 'filetype_checker.exe' is present in '_python-interpreter/dist' and is not blocked by your antivirus
echo.
REM let's remedy this in one of 4 ways...
echo Your options:
echo ^(1^) Try again     
echo ^(2^) Skip current check 
echo ^(3^) Ignore !trk_or_tga! checks
echo ^(4^) ignore all checks
set /P "filetype_checker=Enter 1/2/3/4: "
REM set this so that if user enters invalid choice or something goes wrong, question gets repeated
set "nextsection=filetypechecker_error"
if "!filetype_checker!"=="1" (
	if "!trk_or_tga!"=="TRK" (
		set "nextsection=trkcheck"
	)
	if "!trk_or_tga!"=="TGA" (
		set "nextsection=tgacheck"
	)
	goto start
)
REM user came from TRK section
if /I "!trk_or_tga!"=="TRK" (
	set "nextsection=inputimage"
	if "!filetype_checker!"=="2" (
	REM set one-time TRK check skip
	set "trkcheck=skip_once"
	)
	if "!filetype_checker!"=="3" (
	REM set permanent TRK check skip
	set "trkcheck=skip"
	)
	REM set permanent TRK & TGA check skip
	if "!filetype_checker!"=="4" (
	set "trkcheck=skip"
	set "tgacheck=skip"
	)
)
REM user came from TGA section
if /I "!trk_or_tga!"=="TGA" (
	set "nextsection=output_track"
	if "!filetype_checker!"=="2" (
	REM set one-time TRK check skip
	set "trkcheck=skip_once"
	)
	if "!filetype_checker!"=="3" (
	REM set permanent TGA check skip
	set "tgacheck=skip"
	)
	REM set permanent TRK & TGA check skip
	if "!filetype_checker!"=="4" (
	set "trkcheck=skip"
	set "tgacheck=skip"
	)
)
goto start

REM set backup track based on input track name + _bkp (so mytrack.trk -> mytrack_bkp.trk)
:output_track
if defined i (
    if defined p (
        if not defined backup_filename (
            set "basename=!i!"
            for %%a in ("!basename!") do set "name=%%~na" & set "ext=%%~xa"
            set "backup_filename=!name!_bkp!ext!"
			set "nextsection=output_track"
			goto start
        )
		REM notify user backup file already exists and will be overwritten
        if exist "!backup_filename!" (
			echo Backup file already exists. If you proceed, it will be overwritten.
        )

        :final_check
        set /P "continue=Do you want to proceed using the above settings? (Y/N): "
        if /I "!continue!"=="Y" (
            REM create backup file and integrate the TGA into the TRK, completing a loop of the script
            copy "!i!" "!backup_filename!" >nul
            cdtrkpic_mica -i "!backup_filename!" -o "!basename!" -p "!p!" > error.log 2>&1
            echo.
			echo Backup complete
			find "Error: Invalid track file." error.log >nul 2>nul
			if not errorlevel 1 (
				echo.
				echo ERROR:
				echo Merge failed ^(Invalid TRK file^)
				echo If you are not using the Filetype Checker, please make sure your input files are valid.
				echo If you still have issues, please contact Mica ^(the author of this script^) and provide him with steps to reproduce.
				echo.
				echo Press any key to try again . . .
				goto reset
			)
			find "Error: Couldn't load image file." error.log >nul 2>nul
			if not errorlevel 1 (
				goto invalidtga
			)
			find "Error: Invalid image resolution. Loaded image must be 1024x1024!" error.log >nul 2>nul
			if not errorlevel 1 (
				:invalidtga
				echo.
				echo ERROR:
				echo Merge failed ^(Invalid TGA file^)
				echo If you are not using the Filetype Checker, please make sure your input files are valid.
				echo If you still have issues, please contact Mica ^(the author of this script^) and provide him with steps to reproduce.
				echo.
				echo Press any key to try again . . .
				goto reset
			)
			if defined trkcheck goto unknown_errorlevel
			if defined tgacheck goto unknown_errorlevel
			goto success
			
			:unknown_errorlevel
			echo Merge complete
			echo.
			echo IMPORTANT:
			echo Since you have skipped or disabled one or more file checks, the result could not be validated.
			echo If you encounter any issues, double-check your input files or use the File Checker to do so.
			echo If you still have issues, please contact Mica ^(the author of this script^) and provide him with steps to reproduce.
			echo.
			echo Press any key to run the tool again . . .
			pause > nul
			REM re-using existing variable below, not actually aborting...
			goto reset
			
			:success
			echo Merge complete
			echo Resulting track: '!basename!'
			echo.
			echo Press any key to run the tool again . . .
			
			:reset
			pause > nul
			:abort
			set "i="
			set "p="
			set "backup_filename="
			set "nextsection=inputtrack"
			goto start
		)

        :changed_mind
        echo What do you want to change?
        echo - Input track  ^(1^)
        echo - Input image  ^(2^)
        echo - Backup track ^(3^)
        set /P "changed_mind=Enter 1/2/3: "
        if /I "!changed_mind!"=="1" (
			REM let user change input track
			set "i="
			set "nextsection=inputtrack"
            goto start
        )
        if /I "!changed_mind!"=="2" (
			REM let user change input image
			set "p="
			set "nextsection=inputimage"
            goto start
        )
        if /I "!changed_mind!"=="3" (
			REM let user change backup track name
			set "backup_filename="
			set "nextsection=backup_inputtrack"
            goto start
        ) else (
			REM invalid input, repeat questions
			set "nextsection=output_track"
            goto start
        )
    )
)

REM user shouldn't end up here
echo ERROR:
echo Strange behavior detected, the script will reset.
echo Please inform Mica (the author of this script) with steps of how to reproduce this.
pause > nul
goto abort

REM User asked to specify custom name for backup track
:backup_inputtrack
set /P "new_backup_filename=Enter custom backup filename: "
for %%a in ("!new_backup_filename!") do set "ext=%%~xa"

REM check if filename entered doesn't include .trk, add it
set "extension=!new_backup_filename:~-4!"
if /I not "!extension!"==".trk" set "new_backup_filename=!new_backup_filename!.trk"

REM check if file exists
if "!new_backup_filename!"=="!i!" (
	REM user entered same name as output file, repeating question...
    echo Backup filename cannot be same as input filename. Press any key to try again . . .
	pause > nul
	set "nextsection=backup_inputtrack"
    goto start
)

REM new file name accepted!
set "backup_filename=!new_backup_filename!"
REM if user came from :changed_mind, send them back
if /I "!changedmind!"=="3" (
	set "nextsection=output_track"
	goto start
)
set "nextsection=final_check"
goto start