@echo off

echo.
echo ===========================================================================
echo Graphics
echo ===========================================================================
php -f ./scripts/conv_graphics.php
if %ERRORLEVEL% NEQ 0 ( exit /b )

echo.
echo ===========================================================================
echo Compiling music
echo ===========================================================================
php -f ../scripts/preprocess.php music.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\scripts\macro11 -ysl 32 -yus -l _music.lst _music.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
php -f ../scripts/lst2bin.php _music.lst _music.bin bin 100000
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\scripts\zx0 -f _music.bin _music_lz.bin

echo.
echo ===========================================================================
echo Compiling CPU
echo ===========================================================================
php -f ../scripts/preprocess.php acpu.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\scripts\macro11 -ysl 32 -yus -l _acpu.lst _acpu.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
php -f ../scripts/lst2bin.php _acpu.lst _acpu.bin bin 1000
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\scripts\zx0 -f _acpu.bin _acpu_lz.bin

echo.
echo ===========================================================================
echo Compiling GOBLIN2
echo ===========================================================================
php -f ../scripts/preprocess.php bmain.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\scripts\macro11 -ysl 32 -yus -l _bmain.lst _bmain.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
php -f ../scripts/lst2bin.php _bmain.lst ./release/goblin2.bin bbk 2000
if %ERRORLEVEL% NEQ 0 ( exit /b )
php -f ../scripts/bin2wav.php ./release/goblin2.bin
if %ERRORLEVEL% NEQ 0 ( exit /b )

del _acpu.mac
rem del _acpu.lst
del _acpu.bin
del _acpu_lz.bin
del _music.mac
del _music.lst
del _music.bin
del _music_lz.bin
del _bmain.mac
del _bmain.lst

echo.
start ..\..\bkemu\BK_x64.exe /C BK-0011M /B .\release\goblin2.bin
