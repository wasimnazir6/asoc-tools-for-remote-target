#!/bin/bash

# Usage: bin/<script>

pushd $(dirname $0) > /dev/null
SCRIPTPATH=$PWD
popd > /dev/null

DEBUG_PATH="/data/debug_dapm"
ASOC_TOP="/sys/kernel/debug/asoc"
BOARD_OUT="$DEBUG_PATH/vizdapm_target_out"
HOST_OUT="out/vizdapm_host_out"

# ADB remount
adb root && adb wait-for-device && adb remount

# Run the binary on board
adb shell mkdir -p $DEBUG_PATH
adb push bin/vizdapm $DEBUG_PATH
adb shell mkdir -p $BOARD_OUT
adb shell "sh $DEBUG_PATH/vizdapm $ASOC_TOP $BOARD_OUT/dapm_route.dot"

# Get the file
mkdir -p $HOST_OUT
dotfile="$HOST_OUT/dapm_route.dot"
outfile="$HOST_OUT/dapm_route.png"
adb pull $BOARD_OUT/dapm_route.dot $dotfile

echo ""
echo -n "Generating $outfile..."
dot -Kfdp -Tpng "$dotfile" -o "$outfile"
echo "OK!"
