# 🎧 AirPods Battery CLI

## 📌 Overview
A lightweight **command-line tool** for retrieving the battery status of **AirPods** (or other Bluetooth headphones) on macOS. This script fetches connection status and battery levels for **left, right, and case batteries** directly from macOS system data.

## 🚀 Features
- ✅ **Check AirPods connection status**
- ✅ **Display battery levels** (left earbud, right earbud, and case)
- ✅ **Lightweight & fast execution**
- ✅ **Fully automated, no additional setup required**
- ✅ **Can be added to macOS menu bar using SwiftBar/BitBar**

## 🛠️ Installation
### **1️⃣ Download the Script**
```bash
curl -O https://github.com/pratikbhavarthe/AirpodsBattery/bt_battery.sh
```

### **2️⃣ Make it Executable**
```bash
chmod +x bt_battery.sh
```

### **3️⃣ Move to System Path (Optional)**
To make it accessible system-wide:
```bash
sudo mv bt_battery.sh /usr/local/bin/bt_battery
```
Now you can run it with:
```bash
bt_battery
```

## 📌 Usage
Run the script:
```bash
./bt_battery.sh
```

### **Example Outputs**
| Scenario | Output |
|----------|--------|
| AirPods connected & battery reported | 🎧 L: 85% R: 90% C: 70% |
| AirPods connected, only one battery value reported | 🎧 85% |
| AirPods **not connected** | 🎧 Not Connected |
| No Bluetooth headphones found | 🎧 No Bluetooth Headphones Found |

## 🧑‍💻 How It Works
1. **Finds AirPods MAC Address**: Extracts Bluetooth headphone details from `system_profiler`.
2. **Checks if AirPods are Connected**: Looks for the `Connected: Yes` field.
3. **Retrieves Battery Data**: Reads battery percentages from macOS Bluetooth preferences.
4. **Displays Status**: Outputs formatted battery information.

## 🛠️ Debugging
If the script does not work as expected, try running these manually:
```bash
system_profiler SPBluetoothDataType | grep -A6 "Headphones"
```
```bash
defaults read /Library/Preferences/com.apple.Bluetooth | grep -A6 "BatteryPercent"
```

## 📌 Automation
### **Add to macOS Menu Bar (SwiftBar/BitBar)**
- Download [SwiftBar](https://github.com/swiftbar/SwiftBar)
- Move `bt_battery.sh` to `~/Documents/SwiftBar/`
- Rename it to `bt_battery.1m.sh` (Runs every 1 minute)
- Your AirPods battery status will appear in the macOS menu bar! 🎉

## 📄 License
This project is licensed under the MIT License.

## 💡 Contributions
Feel free to **fork**, submit **pull requests**, or suggest **enhancements**!

## 🔗 Repository
[GitHub Repo](https://github.com/pratikbhavarthe/AirpodsBattery)

