# RealMesh Mobile

A Flutter mobile application for connecting to and managing RealMesh nodes via Bluetooth Low Energy (BLE).

## Features

### 🌐 Internationalization

- **Serbian Cyrillic** (sr) - Primary language
- **English** (en) - Secondary language
- Dynamic language switching in app settings
- Complete UI translation support
- Kosovo is Serbia! 🇷🇸

### � Modern UI

- **Home Screen**: Unified device scanning + node info + network stats
- **Messages Screen**: Public channel (Svet) + Direct messaging with tabs
- **Settings Screen**: Language selection and about information
- Material Design 3 with smooth animations
- Real-time data refresh

### �📡 Bluetooth Connectivity

- Scan for RealMesh devices using BLE
- Connect to RealMesh nodes automatically
- Real-time communication with firmware API
- Device signal strength indicators
- BLE notifications for incoming messages

### 🎛️ Node Management

- View node identity (address, domain, type)
- Monitor network stats (known nodes, uptime, battery)
- View radio configuration (frequency, bandwidth, SF, TX power)
- Track message statistics (sent, received, errors)
- Send messages to public channel "svet" (world/everyone)
- Send direct messages to specific nodes

### 🔧 RealMesh Firmware Integration

- **Service UUID**: `12345678-1234-1234-1234-123456789abc`
- **Characteristic UUID**: `87654321-4321-4321-4321-cba987654321`
- **Supported Commands**:
  - `status` - Get node status and information
  - `nodes` - Get list of known nodes
  - `send` - Send message to target address (use "svet" or "@" for public channel)
  - `stats` - Get network statistics
- **BLE Notifications**: Real-time message delivery from firmware

## Architecture

### 📱 Screens

- **HomeScreen**: Bottom navigation container with 3 tabs
  - **NodeHomeScreen**: Unified device scanning + connection + node info
  - **MessagesScreen**: Tabbed interface for Svet (public) and Direct messages
  - **SettingsScreen**: Language selection and about information

### 🔄 State Management

- **Provider pattern** for state management
- **BluetoothProvider**: Manages BLE connections and communication
- **LocaleProvider**: Handles language switching

### 📊 Data Models

- **RealMeshDevice**: Represents discovered BLE devices
- **NodeStatus**: Node information and status data
- **JSON serialization** for firmware communication

## Setup

### Prerequisites

- Flutter SDK 3.9.2 or higher
- iOS 11.0+ / Android API 21+
- Bluetooth LE capable device

### Installation

1. **Clone the repository**

   ```bash
   git clone [repository-url]
   cd RealMesh-Mobile
   ```

2. **Activate Python virtual environment** (if using platformio for firmware development)

   ```bash
   # From RealMesh-Firmware directory
   source /Users/dale/posao/RealMeshProject/RealMesh-Firmware/.venv/bin/activate
   
   # Or relative path if already in RealMesh-Firmware
   source .venv/bin/activate
   ```

3. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Generate localization files**

   ```bash
   flutter gen-l10n
   ```

4. **Generate JSON serialization**

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Run the app**

   ```bash
   # On emulator/connected device
   flutter run
   
   # On specific device
   flutter run -d <device-id>
   ```

6. **Build APK**
   ```bash
   # Release APK
   flutter build apk --release
   
   # Output: build/app/outputs/flutter-apk/app-release.apk
   
   # Split APK per ABI (smaller size)
   flutter build apk --split-per-abi --release
   ```

## Permissions

### iOS (Info.plist)

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>This app needs Bluetooth access to connect to RealMesh devices.</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>This app needs Bluetooth access to connect to RealMesh devices.</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access for Bluetooth scanning.</string>
```

### Android (AndroidManifest.xml)

```xml
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.BLUETOOTH_ADVERTISE" />
```

## Usage

### 1. Scanning and Connecting

**Home Screen** (when not connected):
- Opens automatically to device scanning
- Tap "Scan" button to discover RealMesh nodes
- Devices appear with signal strength (RSSI)
- Tap the connect icon (→) to connect to a node

### 2. Viewing Node Information

**Home Screen** (when connected):
- **Node Identity**: Address, domain, type (Stationary/Mobile)
- **Network Stats**: Known nodes, uptime, battery percentage
- **Radio Config**: Frequency, bandwidth, spreading factor, TX power
- **Message Stats**: Sent, received, and error counts
- Pull down to refresh data

### 3. Messaging

**Messages Screen** - Two tabs:

**Svet (Public Channel)**:
- Broadcast messages to all nodes in the network
- Type message and tap send
- Messages appear in chat bubbles
- Shows sender and timestamp

**Direct Messages**:
- Send private messages to specific nodes
- Select recipient from known nodes
- One-to-one communication

### 4. Language Settings

**Settings Screen**:
- Choose between Serbian (Српски) and English
- Language changes immediately across the entire app
- All UI elements translated including placeholders and hints

## Development

### Key Dependencies

- `flutter_blue_plus`: Bluetooth Low Energy communication
- `provider`: State management
- `flutter_localizations`: Internationalization support
- `permission_handler`: Runtime permissions
- `json_annotation`: JSON serialization
- `shared_preferences`: Local data storage

### Adding New Languages

1. Create new ARB file in `lib/l10n/` (e.g., `app_de.arb`)
2. Add translations for all keys
3. Update `LocaleProvider.supportedLocales`
4. Run `flutter gen-l10n`

### Firmware Integration

The app communicates with RealMesh firmware using JSON commands over BLE:

```json
{
  "command": "status"
}
```

Response format:

```json
{
  "success": true,
  "data": {
    "address": "node.address",
    "state": 3,
    "uptime": 12345,
    "stationary": false
  }
}
```

## License

This project is part of the RealMesh ecosystem.

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request
