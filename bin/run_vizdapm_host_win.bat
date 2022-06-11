:: Usage: bin\<script>

set DEBUG_PATH=/data/debug_dapm
set ASOC_TOP=/sys/kernel/debug/asoc
set BOARD_OUT=%DEBUG_PATH%/vizdapm_target_out
set HOST_OUT=out\vizdapm_host_out

:: ADB remount
adb root && adb wait-for-device && adb remount

:: Run the binary on board
adb shell mkdir -p %DEBUG_PATH%
adb push bin\vizdapm %DEBUG_PATH%
adb shell mkdir -p %BOARD_OUT%
adb shell "sh %DEBUG_PATH%/vizdapm %ASOC_TOP% %BOARD_OUT%/dapm_route.dot"

:: Get the file
mkdir %HOST_OUT%
dotfile=%HOST_OUT%\dapm_route.dot
outfile=%HOST_OUT%\dapm_route.png
adb pull %BOARD_OUT%/dapm_route.dot %dotfile%

echo ""
echo -n "Generate %outfile% using other applications..."
echo "OK!"
