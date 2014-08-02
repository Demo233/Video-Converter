@echo off
setlocal
:start
echo ============================================================================
echo.
echo    High Compression Video Converter x264-MKV
echo    Version 0.9.9 beta by Kevin C.H.I.
echo.
echo    NOTES:
echo.
echo    - Video resolution is same as source
echo    - Audio sample rate and channel are same as source
echo.
echo ============================================================================
echo.
set /p mode="File Mode: Single (1) or Multiple (2) > "
cls
echo ============================================================================
echo.
if "%mode%" == "" GOTO error
if "%mode%" == "1" GOTO single setting
if "%mode%" == "2" GOTO multi setting
echo.

:single setting
cls
echo ============================================================================
echo.
echo  SINGLE FILE MODE SETTING
echo.
echo  Current Directory : "%cd%"
echo.
set /p src="-STEP 1: Source video file > "
REM echo.
REM set /p op="-STEP 2: Output filename > "
echo.
REM set /p extension="-STEP 3: Which format? MP4 or MKV > "
set extension=mkv
echo.
echo  - Bitrate Table ----------------------------------------------------------
echo  Recording : Low resolution 1000 - 2000 High resolution - Desktop Recording
echo  Animation :     Low details 500 - 3500 High details - Anime
echo       Film :        Low VFX 2500 - 4000 High VFX or High Action
echo     Gaming :          Indie 5000 - 10000 Next-Gen VFX FPS MMO RPG
echo         4K :               15000 - 30000 Max Details
echo.
set /p quality="-STEP 2: Quality bitrate > "
cls
echo ============================================================================
echo.
set extstate=false
if /i "%quality%" == "" GOTO error
GOTO single

:multi start
cls
echo ============================================================================
echo.
echo  MULTIPLE FILE MODE SETTING
echo.
echo  Current Directory : "%cd%"
echo.
set /p filter="-STEP 1: Which extension to convert > "
echo.
REM set /p extension="-STEP 3: Which format? MP4 or MKV > "
set extension=mkv
echo.
echo  - Bitrate Table ----------------------------------------------------------
echo  Recording : Low resolution 1000 - 2000 High resolution - Desktop Recording
echo  Animation :     Low details 500 - 3500 High details - Anime
echo       Film :        Low VFX 2500 - 4000 High VFX or High Action
echo     Gaming :          Indie 5000 - 10000 Next-Gen VFX FPS MMO RPG
echo         4K :               15000 - 30000 Max Details
echo.
set /p quality="-STEP 2: Quality bitrate > "
cls
echo ============================================================================
echo.
set extstate=false
if /i "%quality%" == "" GOTO error
GOTO multi

:single
cls
set /a quality=(%quality% * 1024) / 1000
set source="%cd%\%src:"=%"
set newname=%src:"=%
set namecopy=%newname:~0,-4%
set output="%cd%\%namecopy%.%extension%"
echo ============================================================================
echo  SUMMARY
echo.
echo             Mode : Single file
echo      Source file : %source%
echo          Save as : %output%
echo         Location : "%cd%\"
echo.
echo      Video codec : H.264 MPEG-4 AVC, Average ~%quality%%Kbps,
echo      Audio codec : AAC MPEG 240Kbps, sample rate and channel same as source
echo.
echo ============================================================================
echo.
pause
GOTO single execute

:multi
cls
set /a quality=(%quality% * 1024) / 1000
echo ============================================================================
echo  SUMMARY
echo.
echo             Mode : Multiple files
echo           Filter : %filter%
echo         Location : "%cd%\"
echo          Save as : 
if "%dir%" == "" (
for /r %%A in (*.%filter%) do (
echo                    "%%~dpnA.%extension%"
))
echo.
echo      Video codec : H.264 MPEG-4 AVC, Average ~%quality%%Kbps,
echo      Audio codec : AAC MPEG 240Kbps, sample rate and channel same as source
echo.
echo ============================================================================
echo.
pause
GOTO multi execute

:single execute
echo.
echo  To Cancel or Skip, press Q.
echo.
echo  Converting : %source%
echo  PASS-1 conversion in progress, please wait.
ffmpeg -loglevel quiet -i %source% -an -vcodec libx264 -pass 1 -preset veryslow -profile:v high -level 4.1 -threads 0 -b:v %quality%k -x264opts frameref=1:fast_pskip=0:keyint=24:min-keyint=2:me=dia:trellis=1:bframes=3:subme=3:direct=auto:b-pyramid:partitions=none:no-dct-decimate -f rawvideo -y NUL
echo  PASS-2 conversion in progress, please wait.
ffmpeg -loglevel quiet -i %source% -strict experimental -c:a aac -b:a 240k -vcodec libx264 -pass 2 -preset veryslow -profile:v high -level 4.1 -threads 0 -b:v %quality%k -x264opts frameref=4:fast_pskip=0:keyint=24:min-keyint=2:me=umh:trellis=1:bframes=3:subme=7:vbv-maxrate=40000:vbv-bufsize=30000:direct=auto:b-pyramid:partitions=p8x8,b8x8,i4x4,i8x8:8x8dct:weightb:mixed-refs:mvrange %output%
echo.
del "ffmpeg2pass-0.log" /q
del "ffmpeg2pass-0.log.mbtree" /q
GOTO completed


:multi execute
if "%dir%" == "" (
for /r %%A in (*.%filter%) do (
echo  To Cancel or Skip, press Q.
echo.
echo  Converting : %%A
echo  PASS-1 conversion in progress, please wait.
ffmpeg -loglevel quiet -i "%%A" -an -vcodec libx264 -pass 1 -preset veryslow -profile:v high -level 4.1 -threads 0 -b:v %quality%k -x264opts frameref=1:fast_pskip=0:keyint=24:min-keyint=2:me=dia:trellis=1:bframes=3:subme=3:direct=auto:b-pyramid:partitions=none:no-dct-decimate -f rawvideo -y NUL
echo  PASS-2 conversion in progress, please wait.
ffmpeg -loglevel quiet -i "%%A" -strict experimental -c:a aac -b:a 240k -vcodec libx264 -pass 2 -preset veryslow -profile:v high -level 4.1 -threads 0 -b:v %quality%k -x264opts frameref=4:fast_pskip=0:keyint=24:min-keyint=2:me=umh:trellis=1:bframes=3:subme=7:vbv-maxrate=40000:vbv-bufsize=30000:direct=auto:b-pyramid:partitions=p8x8,b8x8,i4x4,i8x8:8x8dct:weightb:mixed-refs:mvrange "%%~dpnA.%extension%"
echo.
del "ffmpeg2pass-0.log" /q
del "ffmpeg2pass-0.log.mbtree" /q
)
)
GOTO completed

echo.

:completed
echo.
echo ============================================================================
echo.
echo  Conversion Completed at %DATE:/=-%@%TIME::=-%
echo.
pause
cls
GOTO start


:error
echo  SEE ERROR BELOW:
echo.
if "%mode%" == "" (
echo  Please set the file mode.
)
if "%quality%" == "" (
echo  Please set the quality.
)
echo.
echo ============================================================================
echo.
pause
cls
GOTO start
