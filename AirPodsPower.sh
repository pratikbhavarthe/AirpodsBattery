#!/bin/bash

OUTPUT="🎧"

BLUETOOTH_DEFAULTS=$(defaults read /Library/Preferences/com.apple.Bluetooth 2>/dev/null)
SYSTEM_PROFILER=$(system_profiler SPBluetoothDataType 2>/dev/null)

MAC_ADDR=$(awk '/Minor Type: Headphones/ {getline; getline; print $3}' <<< "$SYSTEM_PROFILER")

if [[ -z "$MAC_ADDR" ]]; then
    echo "$OUTPUT No Bluetooth Headphones Found"
    exit 1
fi

CONNECTED=$(awk -v mac="$MAC_ADDR" '
    /'"$MAC_ADDR"'/ {found=1}
    found && /Connected: Yes/ {print 1; exit}' <<< "$SYSTEM_PROFILER")


BATTERY_KEYS=("BatteryPercentCombined" "HeadsetBattery" "BatteryPercentSingle" \
              "BatteryPercentCase" "BatteryPercentLeft" "BatteryPercentRight")

# If Connected, Fetch Battery Levels
if [[ -n "$CONNECTED" ]]; then
    BLUETOOTH_DATA=$(grep -ia6 "\"$MAC_ADDR\"" <<< "$BLUETOOTH_DEFAULTS")

    for key in "${BATTERY_KEYS[@]}"; do
        value=$(awk -v pat="$key" '$0 ~ pat {gsub(";", ""); print $3}' <<< "$BLUETOOTH_DATA")
        [[ -n "$value" ]] && OUTPUT+=" $(awk -v k="$key" 'match(k, /BatteryPercent(Left|Right|Case|Combined|Single|Headset)?/, a) {print substr(a[1], 1, 1) ": "}' <<< "$key")$value%"
    done

    echo "$OUTPUT"
else
    echo "$OUTPUT Not Connected"
fi
