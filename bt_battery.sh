#!/bin/bash

OUTPUT="🎧"
BATTERY_KEYS=("BatteryPercentCombined" "HeadsetBattery" "BatteryPercentSingle"
              "BatteryPercentCase" "BatteryPercentLeft" "BatteryPercentRight")

BLUETOOTH_DEFAULTS=$(defaults read /Library/Preferences/com.apple.Bluetooth 2>/dev/null)
SYSTEM_PROFILER=$(system_profiler SPBluetoothDataType 2>/dev/null)

get_mac_address() {
    awk '/Minor Type: Headphones/ {getline; getline; print $3}' <<< "$SYSTEM_PROFILER"
}

is_connected() {
    local mac="$1"
    awk -v mac="$mac" '
        /'"$mac"'/ {found=1}
        found && /Connected: Yes/ {print 1; exit}' <<< "$SYSTEM_PROFILER"
}

get_battery_level() {
    local mac="$1"
    local battery_data=$(grep -ia6 "\"$mac\"" <<< "$BLUETOOTH_DEFAULTS")
    local output="$OUTPUT"

    for key in "${BATTERY_KEYS[@]}"; do
        local value=$(awk -v pat="$key" '$0 ~ pat {gsub(";", ""); print $3}' <<< "$battery_data")
        if [[ -n "$value" ]]; then
            local label=$(awk 'match("'"$key"'", /BatteryPercent(Left|Right|Case|Combined|Single|Headset)?/, a) {print substr(a[1],1,1) ": "}' <<< "$key")
            output+=" $label$value%"
        fi
    done

    echo "$output"
}

MAC_ADDR=$(get_mac_address)

if [[ -z "$MAC_ADDR" ]]; then
    echo "$OUTPUT No Bluetooth Headphones Found"
    exit 1
fi

if [[ -n "$(is_connected "$MAC_ADDR")" ]]; then
    get_battery_level "$MAC_ADDR"
else
    echo "$OUTPUT Not Connected"
fi
