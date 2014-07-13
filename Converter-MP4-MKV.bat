@echo off
:start
echo ============================================================================
echo.
echo 	High Compression Video Converter x264-MKV/MP4
echo 	Version 0.7 by Kevin C.H.I.
echo.
echo ============================================================================
echo.
echo  SETTING
echo.
echo  Current Directory : %cd%
echo.
set /p source="-STEP 1: Source video file > "
echo.
set /p output="-STEP 2: Output filename > "
echo.
set /p extension="-STEP 3: Which format? MP4 or MKV > "
REM set extension=mkv
echo.
echo  - Bitrate Table ---------------------------------------------
echo  Animation : Low details 1500 - 3500 High details - Anime
echo       Film :     Low VFX 2500 - 4000 High VFX or High Action
echo     Gaming :       Indie 5000 - 10000 Next-Gen VFX FPS MMO RPG
echo         4K :            15000 - 30000 Max Details
echo.
set /p quality="-STEP 4: Quality bitrate > "
echo.
echo ============================================================================
echo.

set extstate=false
if /i "%source%" == "" GOTO error
if /i "%output%" == "" GOTO error
if /i "%quality%" == "" GOTO error
if /i "%extension%" == "" GOTO error
if /i "%extension%" == "mp4" set extstate=true
if /i "%extension%" == "mkv" set extstate=true
if "%extstate%"=="true" (
    GOTO adjustment
)
if "%extstate%"=="false" (
    GOTO error
)

:adjustment
set /a quality=(%quality% * 1024) / 1000

GOTO summary

:summary
cls
echo ============================================================================
echo  SUMMARY
echo.
echo      Source file : %source%
echo          Save as : %output%.%extension%
echo         Location : %cd%
echo.
echo      Video codec : H264 MPEG-4 AVC, Average ~%quality%%Kbps
echo      Audio codec : AAC MPEG 240Kbps, sample rate and channel same as source
echo.
echo ============================================================================
echo.

pause
echo.
echo ============================================================================
echo.
echo  PASS-1 conversion in progress, please wait or press Q twice to cancel.
echo.
echo ============================================================================
echo.
REM x264.exe --pass 1 --level 4.1 --stats .stats --bitrate %bitrate% --no-mbtree --keyint 24 --min-keyint 2 --threads auto --bframes 3 --me dia --ref 1 --subme 3 --direct auto --sar 1:1 --b-pyramid strict --partitions none --no-dct-decimate --output NUL %cd%\%source%

REM x264.exe --pass 2 --level 4.1 --stats .stats --bitrate %bitrate% --no-mbtree --keyint 24 --min-keyint 2 --threads auto --bframes 3 --me umh --ref 4 --subme 7 --direct auto --sar 1:1 --b-pyramid strict --partitions p8x8,b8x8,i4x4,i8x8 --8x8dct --vbv-bufsize 30000 --vbv-maxrate 38000 --weightb --mixed-refs --mvrange 511 --aud --trellis 1 --analyse all --output "%cd%\%output%.%extension%" "%cd%\%source%"

ffmpeg -loglevel warning -i %cd%\%source% -an -vcodec libx264 -pass 1 -preset veryslow -profile:v high -level 4.1 -threads 0 -b:v %quality%k -x264opts frameref=1:fast_pskip=0:keyint=24:min-keyint=2:me=dia:trellis=1:bframes=3:subme=3:direct=auto:b-pyramid:partitions=none:no-dct-decimate -f rawvideo -y NUL
echo.
echo ============================================================================
echo.
echo  PASS-2 conversion in progress, please wait or press Q to cancel.
echo.
echo ============================================================================
echo.
ffmpeg -loglevel warning -i %cd%\%source% -strict experimental -c:a aac -b:a 240k -vcodec libx264 -pass 2 -preset veryslow -profile:v high -level 4.1 -threads 0 -b:v %quality%k -x264opts frameref=4:fast_pskip=0:keyint=24:min-keyint=2:me=umh:trellis=1:bframes=3:subme=7:vbv-maxrate=40000:vbv-bufsize=30000:direct=auto:b-pyramid:partitions=p8x8,b8x8,i4x4,i8x8:8x8dct:weightb:mixed-refs:mvrange %cd%\%output%.%extension%
echo.

GOTO completed

echo.

:error
echo  SEE ERROR BELOW:
echo.
if "%source%" == "" (
echo  Please locate the source video file.
)
if "%output%" == "" (
echo  Please type in the output filename.
)
if "%extstate%"=="false" (
echo  Please correct the value for the extension parameter.
)
echo.
echo ============================================================================
echo.
pause
cls
GOTO start

:completed
echo.
echo ============================================================================
echo.
del "ffmpeg2pass-0.log" /q
del "ffmpeg2pass-0.log.mbtree" /q
echo  Conversion Completed at %DATE:/=-%@%TIME::=-%
echo  File location : %cd%\%output%.%extension%
echo.
pause
cls
GOTO start