@echo off
:start
setlocal EnableDelayedExpansion
:: Batch Information
set title=HCVC
set longtitle=High Compression Video Converter x264-MKV
set version=1.0.5 beta
set author=Kevin C.H.I.
set devdate=20140803

cls
echo ===============================================================================
echo.
echo    %title%, %longtitle%
echo.
echo    Version: %version% %devdate% 
echo    Author: %author%  
echo.
echo    Notes:
echo.
echo    - Video resolution is same as source
echo    - Audio sample rate and channel are same as source
echo.
echo ===============================================================================
echo.
echo    1 - Single File Mode
echo    2 - Multiple File Mode
echo    3 - Delete Multiple File Mode
echo.
set /p mode="- Select Mode: > "
set state=false
if /i "%mode%" == "1" set state=true
if /i "%mode%" == "2" set state=true
if /i "%mode%" == "3" set state=true
if "%state%"=="true" (
	if "%mode%" == "1" GOTO singlesetting
	if "%mode%" == "2" GOTO multisetting
	if "%mode%" == "3" GOTO deletesetting
)
if "%state%"=="false" (
	echo.
	echo  ERROR: Please select a file mode.
	echo.
	pause
	GOTO start
)

:singlesetting
cls
echo ===============================================================================
echo  %title% v%version% %devdate% by %author%
echo ===============================================================================
echo.
echo  SINGLE FILE MODE SETTING
echo.
echo  Current Directory : "%cd%"
echo.
set /p dir="- Set folder > "
pushd %dir%
echo.
set /p src="- Which source video file? > "
if exist !src! (
set src=%src:"=%
GOTO singlenext
) 
echo.
echo  ERROR: Please type in the source video file name with extension.
echo.
pause
GOTO singlesetting
:: echo.
:: set /p op="-STEP 2: Output filename > "
echo.
:: set /p extension="-STEP 3: Which format? MP4 or MKV > "

:singlenext
set extension=mkv
echo.
echo  - Bitrate Table --------------------------------------------------------------
echo  Recording : Low resolution 1000 - 2000 High resolution - Desktop Recording
echo  Animation :     Low details 500 - 3500 High details - Anime
echo       Film :        Low VFX 2500 - 4000 High VFX or High Action
echo     Gaming :          Indie 5000 - 10000 Next-Gen VFX FPS MMO RPG
echo         4K :               15000 - 30000 Max Details
echo.
set /p quality="- Quality bitrate > "
if "%quality%" == "" (
echo.
echo  ERROR: Please set the bitrate.
echo.
pause
GOTO singlesetting
)
GOTO single

:multisetting
cls
echo ===============================================================================
echo  %title% v%version% %devdate% by %author%
echo ===============================================================================
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
echo  ERROR: Please type in the extension.
echo.
pause
GOTO multisetting
)
echo.
:: set /p extension="-STEP 3: Which format? MP4 or MKV > "
set extension=mkv
echo.
echo  - Bitrate Table --------------------------------------------------------------
echo  Recording : Low resolution 1000 - 2000 High resolution - Desktop Recording
echo  Animation :     Low details 500 - 3500 High details - Anime
echo       Film :        Low VFX 2500 - 4000 High VFX or High Action
echo     Gaming :          Indie 5000 - 10000 Next-Gen VFX FPS MMO RPG
echo         4K :               15000 - 30000 Max Details
echo.
set /p quality="- Quality bitrate > "
if "%quality%" == "" (
echo.
echo  ERROR: Please set the bitrate.
echo.
pause
GOTO multisetting
)
)
GOTO multi

:deletesetting
cls
echo ===============================================================================
echo  %title% v%version% %devdate% by %author%
echo ===============================================================================
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
echo  ERROR: Please type in the extension.
echo.
pause
GOTO deletesetting
)
echo.
GOTO delete

:single
cls
set /a quality=(%quality% * 1024) / 1000
set source="%cd%\%src%"
set namecopy=%src:~0,-4%
set output="%cd%\%namecopy%.%extension%"
echo ===============================================================================
echo  %title% v%version% %devdate% by %author%
echo ===============================================================================
echo.
echo          SUMMARY
echo.
echo             Mode : Single file
echo      Source file : %source%
echo          Save as : %output%
echo         Location : "%cd%\"
echo.
echo      Video codec : H.264 MPEG-4 AVC, Average ~%quality%%Kbps,
echo      Audio codec : AAC MPEG 240Kbps, sample rate and channel same as source
echo.
echo ===============================================================================
echo.
echo    1 - Continue
echo    2 - Correction
echo    3 - Cancel and start over
echo.
set /p choice="- Select Choice: > "
set state=false
if /i "%choice%" == "1" set state=true
if /i "%choice%" == "2" set state=true
if /i "%choice%" == "3" set state=true
if "%state%"=="true" (
	if "%choice%" == "1" (
		GOTO singleexecute
	)
	if "%choice%" == "2" (
		set choice=
		set dir=
		set src=
		set quality=
		GOTO singlesetting
	)
	if "%choice%" == "3" (
	endlocal
	GOTO start
	)
)
if "%state%"=="false" (
	echo.
	echo  ERROR: Please make a choice.
	echo.
	pause
	GOTO single
)

:multi
cls
set /a quality=(%quality% * 1024) / 1000
echo ===============================================================================
echo  %title% v%version% %devdate% by %author%
echo ===============================================================================
echo.
echo          SUMMARY
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
echo ===============================================================================
echo.
echo    1 - Continue
echo    2 - Correction
echo    3 - Cancel and start over
echo.
set /p choice="- Select Choice: > "
set state=false
if /i "%choice%" == "1" set state=true
if /i "%choice%" == "2" set state=true
if /i "%choice%" == "3" set state=true
if "%state%"=="true" (
	if "%choice%" == "1" (
		GOTO multiexecute
	)
	if "%choice%" == "2" (
		set choice=
		set dir=
		set filter=
		set quality=
		GOTO multisetting
	)
	if "%choice%" == "3" (
	endlocal
	GOTO start
	)
)
if "%state%"=="false" (
	echo.
	echo  ERROR: Please make a choice.
	echo.
	pause
	GOTO multi
)

:delete
cls
set /a quality=(%quality% * 1024) / 1000
echo ===============================================================================
echo  %title% v%version% %devdate% by %author%
echo ===============================================================================
echo.
echo          SUMMARY
echo.
echo             Mode : Delete multiple files
echo           Filter : %filter%
echo         Location : "%cd%\"
echo        To delete : 
for /r %%A in (*.%filter%) do (
echo                    "%%~nxA"
)
echo.
echo ===============================================================================
echo ===============================================================================
echo.
echo    1 - Continue
echo    2 - Correction
echo    3 - Cancel and start over
echo.
set /p choice="- Select Choice: > "
set state=false
if /i "%choice%" == "1" set state=true
if /i "%choice%" == "2" set state=true
if /i "%choice%" == "3" set state=true
if "%state%"=="true" (
	if "%choice%" == "1" (
		GOTO deleteexecute
	)
	if "%choice%" == "2" (
		set choice=
		set dir=
		set filter=
		set quality=
		GOTO deletesetting
	)
	if "%choice%" == "3" (
	endlocal
	GOTO start
	)
)
if "%state%"=="false" (
	echo.
	echo  ERROR: Please make a choice.
	echo.
	pause
	GOTO delete
)

:singleexecute
cls
echo ===============================================================================
echo  %title% v%version% %devdate% by %author%
echo ===============================================================================
echo.
echo  Conversion in progress, please wait.
echo  To Cancel or Skip, press Q.
echo                                                     Process start - !time!
echo.
echo  [1/1] Working: %source%
ffmpeg -loglevel quiet -i %source% -an -vcodec libx264 -pass 1 -preset veryslow -profile:v high -level 4.1 -threads 0 -b:v %quality%k -x264opts frameref=1:fast_pskip=0:keyint=24:min-keyint=2:me=dia:trellis=1:bframes=3:subme=3:direct=auto:b-pyramid:partitions=none:no-dct-decimate -f rawvideo -y NUL
ffmpeg -loglevel quiet -y -i %source% -strict experimental -c:a aac -b:a 240k -vcodec libx264 -pass 2 -preset veryslow -profile:v high -level 4.1 -threads 0 -b:v %quality%k -x264opts frameref=4:fast_pskip=0:keyint=24:min-keyint=2:me=umh:trellis=1:bframes=3:subme=7:vbv-maxrate=40000:vbv-bufsize=30000:direct=auto:b-pyramid:partitions=p8x8,b8x8,i4x4,i8x8:8x8dct:weightb:mixed-refs:mvrange %output%
del "ffmpeg2pass-0.log" /q
del "ffmpeg2pass-0.log.mbtree" /q
echo                                                              Done - !time!
echo.
GOTO completed

:multiexecute
cls
echo ===============================================================================
echo  %title% v%version% %devdate% by %author%
echo ===============================================================================
echo.
echo  Conversion in progress, please wait.
echo  To Cancel or Skip, press Q.
echo                                                     Process start - !time!
echo.
set /a total=0
for /r %%A in (*.%filter%) do (
set /a total=total+1
)
set /a current=0
for /r %%A in (*.%filter%) do (
set /a current=current+1
echo  [!current!/%total%] Working: %%~nxA
ffmpeg -loglevel quiet -y -i "%%~dpnxA" -an -vcodec libx264 -pass 1 -preset veryslow -profile:v high -level 4.1 -threads 0 -b:v %quality%k -x264opts frameref=1:fast_pskip=0:keyint=24:min-keyint=2:me=dia:trellis=1:bframes=3:subme=3:direct=auto:b-pyramid:partitions=none:no-dct-decimate -f rawvideo -y NUL
ffmpeg -loglevel quiet -y -i "%%~dpnxA" -strict experimental -c:a aac -b:a 240k -vcodec libx264 -pass 2 -preset veryslow -profile:v high -level 4.1 -threads 0 -b:v %quality%k -x264opts frameref=4:fast_pskip=0:keyint=24:min-keyint=2:me=umh:trellis=1:bframes=3:subme=7:vbv-maxrate=40000:vbv-bufsize=30000:direct=auto:b-pyramid:partitions=p8x8,b8x8,i4x4,i8x8:8x8dct:weightb:mixed-refs:mvrange "%%~dpnA.%extension%"
del "ffmpeg2pass-0.log" /q
del "ffmpeg2pass-0.log.mbtree" /q
echo                                                              Done - !time!
echo.
)
GOTO completed

:deleteexecute
cls
echo ===============================================================================
echo  %title% v%version% %devdate% by %author%
echo ===============================================================================
echo.
echo  Delete in progress, please wait.
echo                                                     Process start - !time!
echo.
set /a total=0
for /r %%A in (*.%filter%) do (
set /a total=total+1
)
set /a current=0
for /r %%A in (*.%filter%) do (
set /a current=current+1
echo  [!current!/%total%] Deleting: %%~nxA
del "%%A" /q
echo                                                              Done - !time!
echo.
)
GOTO completed

:completed
echo ===============================================================================
echo.
echo                                     Tasks completed at %DATE% - %TIME%
echo.
popd
pause
endlocal
GOTO start