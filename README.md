# RealMesh Mobile

A Flutter mobile application for connecting to and managing RealMesh nodes via Bluetooth Low Energy (BLE).

## Features

### 🌐 Internationalization

- **Serbian Cyrillic** (sr) - Primary language
- **English** (en) - Secondary language
- Dynamic language switching in app settings
- Complete UI translation support

### 📡 Bluetooth Connectivity

- Scan for RealMesh devices using BLE
- Connect to RealMesh nodes automatically
- Real-time communication with firmware API
- Device signal strength indicators

### 🎛️ Node Management

- View node status and information
- Send messages to other nodes
- Monitor network statistics
- Real-time node data updates

### 🔧 RealMesh Firmware Integration

- **Service UUID**: `12345678-1234-1234-1234-123456789abc`
- **Characteristic UUID**: `87654321-4321-4321-4321-cba987654321`
- **Supported Commands**:
  - `status` - Get node status and information
  - `nodes` - Get list of known nodes
  - `send` - Send message to target address
  - `stats` - Get network statistics

## Architecture

### 📱 Screens

- **HomeScreen**: Main app with bottom navigation
- **DeviceScanScreen**: Bluetooth device discovery
- **NodeDetailScreen**: Connected node management
- **SettingsScreen**: Language and app settings

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

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Generate localization files**

   ```bash
   flutter gen-l10n
   ```

4. **Generate JSON serialization**

   ```bash
   flutter packages pub run build_runner build
   ```

5. **Run the app**
   ```bash
   flutter run
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

### 1. Scanning for Devices

- Open the app and go to the "Scan" tab
- Tap the scan button to discover RealMesh nodes
- Devices will appear with signal strength indicators

### 2. Connecting to a Node

- Tap "Connect" on any discovered device
- Wait for connection to establish
- Navigate to "Node Status" tab to manage the node

### 3. Managing Connected Node

- View node information and status
- Send messages to other nodes in the network
- Monitor network statistics
- Get list of known nodes

### 4. Language Settings

- Go to Settings tab
- Select between Serbian (Српски) and English
- Language changes immediately across the app

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
