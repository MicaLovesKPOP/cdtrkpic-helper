@echo off

echo ----------------------------------------------------
echo m                                                  m
echo a       Crashday Track Picture Helper Script       a
echo d                       v1.0                       d
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

:start
echo.
set /P i="Type or drag input track file: " 

cdtrkpic_mica -e -i %i% -o picture.png

if %ERRORLEVEL% == 0 echo Merge complete!
goto start
