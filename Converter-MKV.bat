@echo off
setlocal
:start
cls
echo ============================================================================
echo.
echo    High Compression Video Converter x264-MKV
echo    Version 1.0.2 beta by Kevin C.H.I.
echo.
echo    NOTES:
echo.
echo    - Video resolution is same as source
echo    - Audio sample rate and channel are same as source
echo.
echo ============================================================================
echo.
echo  1 - Single File Mode
echo  2 - Multiple File Mode
echo  3 - Delete Multiple File Mode
echo.
set /p mode="- Select Mode: > "
if "%mode%" == "" (
echo.
echo  ERROR : Please select a file mode.
echo.
pause
GOTO start
)
cls
echo ============================================================================
echo.
if "%mode%" == "1" GOTO singlesetting
if "%mode%" == "2" GOTO multisetting
if "%mode%" == "3" GOTO deletesetting
echo.

:singlesetting
cls
echo ============================================================================
echo.
echo  SINGLE FILE MODE SETTING
echo.
echo  Current Directory : "%cd%"
echo.
set /p dir="- Set folder > "
pushd %dir%
echo.
set /p src="- Which source video file? > "
set src=%src:"=%
if "%src%" == "" (
echo.
echo  ERROR : Please type in the source video file name with extension.
echo.
pause
REM GOTO singlesetting
)
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
set /p quality="- Quality bitrate > "
if "%quality%" == "" (
echo.
echo  ERROR : Please set the bitrate.
echo.
pause
GOTO singlesetting
)
cls
echo ============================================================================
echo.
GOTO single

:multisetting
cls
echo ============================================================================
echo.
echo  MULTIPLE FILE MODE SETTING
echo.
echo  Current Directory : "%cd%"
echo.
set /p dir="- Set folder > "
pushd %dir%
echo.
set /p filter="- Which extension to convert? > "
if "%filter%" == "" (
echo.
echo  ERROR : Please type in the extension.
echo.
pause
GOTO multisetting
)
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
set /p quality="- Quality bitrate > "
if "%quality%" == "" (
echo.
echo  ERROR : Please set the bitrate.
echo.
pause
GOTO multisetting
)
)
cls
echo ============================================================================
echo.
GOTO multi

:deletesetting
cls
echo ============================================================================
echo.
echo  MULTIPLE FILE MODE SETTING
echo.
echo  Current Directory : "%cd%"
echo.
set /p dir="- Set folder > "
pushd %dir%
echo.
set /p filter="- Which extension to delete? > "
if "%filter%" == "" (
echo.
echo  ERROR : Please type in the extension.
echo.
pause
GOTO deletesetting
)
echo.
cls
echo ============================================================================
echo.
GOTO delete

:single
cls
set /a quality=(%quality% * 1024) / 1000
set source="%cd%\%src%"
set namecopy=%src:~0,-4%
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
GOTO singleexecute

:multi
cls
set /a quality=(%quality% * 1024) / 1000
echo ============================================================================
echo  SUMMARY
echo.
echo             Mode : Multiple files
echo           Filter : %filter%
echo         Location : "%cd%\"
echo       To convert : 
for /r %%A in (*.%filter%) do (
echo                    "%%~nxA"
)
echo.
echo      Video codec : H.264 MPEG-4 AVC, Average ~%quality%%Kbps,
echo      Audio codec : AAC MPEG 240Kbps, sample rate and channel same as source
echo.
echo ============================================================================
echo.
pause
GOTO multiexecute

:delete
cls
set /a quality=(%quality% * 1024) / 1000
echo ============================================================================
echo  SUMMARY
echo.
echo             Mode : Delete multiple files
echo           Filter : %filter%
echo         Location : "%cd%\"
echo        To delete : 
for /r %%A in (*.%filter%) do (
echo                    "%%~nxA"
)
echo.
echo ============================================================================
echo.
pause
GOTO deleteexecute

:singleexecute
cls
echo ============================================================================
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

:multiexecute
cls
echo ============================================================================
echo.
echo  To Cancel or Skip, press Q.
echo.
for /r %%A in (*.%filter%) do (
echo  Converting : %%~nxA
echo  PASS-1 conversion in progress, please wait.
ffmpeg -loglevel quiet -i "%%~dpnxA" -an -vcodec libx264 -pass 1 -preset veryslow -profile:v high -level 4.1 -threads 0 -b:v %quality%k -x264opts frameref=1:fast_pskip=0:keyint=24:min-keyint=2:me=dia:trellis=1:bframes=3:subme=3:direct=auto:b-pyramid:partitions=none:no-dct-decimate -f rawvideo -y NUL
echo  PASS-2 conversion in progress, please wait.
ffmpeg -loglevel quiet -i "%%~dpnxA" -strict experimental -c:a aac -b:a 240k -vcodec libx264 -pass 2 -preset veryslow -profile:v high -level 4.1 -threads 0 -b:v %quality%k -x264opts frameref=4:fast_pskip=0:keyint=24:min-keyint=2:me=umh:trellis=1:bframes=3:subme=7:vbv-maxrate=40000:vbv-bufsize=30000:direct=auto:b-pyramid:partitions=p8x8,b8x8,i4x4,i8x8:8x8dct:weightb:mixed-refs:mvrange "%%~dpnA.%extension%"
echo.
del "ffmpeg2pass-0.log" /q
del "ffmpeg2pass-0.log.mbtree" /q
)
GOTO completed

:deleteexecute
cls
echo ============================================================================
echo.
for /r %%A in (*.%filter%) do (
echo  Deleted : %%~nxA
del "%%A" /q
)
echo.
GOTO completed

:completed
echo.
echo ============================================================================
echo.
echo  Tasks completed at %DATE:/=-% @ %TIME::=-%
echo.
popd
pause
GOTO start