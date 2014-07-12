@echo off
:start
echo *************************************************
echo 	Batch Video Converter to x264-MP4/MKV
echo 	by Kevin C.H. Ip
echo *************************************************
echo.
echo USER CONFIGURATION:
echo.
echo Current Directory : %cd%
echo.
set /p source="Source video file : "
set /p output="Output filename : "
REM set /p extension="Which format? MP4 or MKV : "
set extension=mkv
set /p quality="Set Quality Biterate Kbps : "
echo.
echo -------------------------------------------------
echo.

set extstate=false
if /i "%source%" == "" GOTO error
if /i "%output%" == "" GOTO error
if /i "%quality%" == "" GOTO error
if /i "%extension%" == "" GOTO error
REM if /i "%extension%" == "mp4" set extstate=true
if /i "%extension%" == "mkv" set extstate=true
if "%extstate%"=="true" (
    GOTO summary
)
if "%extstate%"=="false" (
    GOTO error
)

:summary

echo Source file : "%cd%\%source%"
echo Output file : "%cd%\%output%.%extension%"
echo.
echo -------------------------------------------------
echo.

pause

REM x264.exe --pass 1 --level 4.1 --stats .stats --bitrate %bitrate% --no-mbtree --keyint 24 --min-keyint 2 --threads auto --bframes 3 --me dia --ref 1 --subme 3 --direct auto --sar 1:1 --b-pyramid strict --partitions none --no-dct-decimate --output NUL %cd%\%source%

REM x264.exe --pass 2 --level 4.1 --stats .stats --bitrate %bitrate% --no-mbtree --keyint 24 --min-keyint 2 --threads auto --bframes 3 --me umh --ref 4 --subme 7 --direct auto --sar 1:1 --b-pyramid strict --partitions p8x8,b8x8,i4x4,i8x8 --8x8dct --vbv-bufsize 30000 --vbv-maxrate 38000 --weightb --mixed-refs --mvrange 511 --aud --trellis 1 --analyse all --output "%cd%\%output%.%extension%" "%cd%\%source%"


ffmpeg -i %cd%\%source% -an -vcodec libx264 -pass 1 -preset veryslow -profile:v high -level 4.1 -threads 0 -b:v %quality%k -x264opts frameref=1:fast_pskip=0:keyint=24:min-keyint=2:me=dia:trellis=1:bframes=3:subme=3:direct=auto:b-pyramid:partitions=none:no-dct-decimate -f rawvideo -y NUL

ffmpeg -i %cd%\%source% -acodec libvo_aacenc -ab 256k -ar 96000 -vcodec libx264 -pass 2 -preset veryslow -profile:v high -level 4.1 -threads 0 -b:v %quality%k -x264opts frameref=4:fast_pskip=0:keyint=24:min-keyint=2:me=umh:trellis=1:bframes=3:subme=7:vbv-maxrate=40000:vbv-bufsize=30000:direct=auto:b-pyramid:partitions=p8x8,b8x8,i4x4,i8x8:8x8dct:weightb:mixed-refs:mvrange %cd%\%output%.%extension%

GOTO completed

echo.

:error
echo SEE ERROR BELOW:
echo.
if "%source%" == "" (
echo Please locate the source video file.
)
if "%output%" == "" (
echo Please type in the output filename.
)
if "%extstate%"=="false" (
echo Please correct the value for the extension parameter.
)
echo.
echo -------------------------------------------------
echo.
pause
cls
GOTO start

:completed
echo.
echo -------------------------------------------------
echo.
echo Conversion Completed.
echo.
pause
cls
GOTO start