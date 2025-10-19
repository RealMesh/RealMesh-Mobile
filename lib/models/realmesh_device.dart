import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class RealMeshDevice {
  final String id;
  final String name;
  final BluetoothDevice bluetoothDevice;
  final int rssi;
  final DateTime lastSeen;

  RealMeshDevice({
    required this.id,
    required this.name,
    required this.bluetoothDevice,
    required this.rssi,
    required this.lastSeen,
  });

  factory RealMeshDevice.fromScanResult(ScanResult scanResult) {
    return RealMeshDevice(
      id: scanResult.device.remoteId.str,
      name: scanResult.advertisementData.advName.isNotEmpty 
          ? scanResult.advertisementData.advName 
          : 'RealMesh Node',
      bluetoothDevice: scanResult.device,
      rssi: scanResult.rssi,
      lastSeen: DateTime.now(),
    );
  }

  String get displayName {
    if (name.isNotEmpty && name != 'Unknown') {
      return name;
    }
    return 'RealMesh ${id.substring(0, 8)}';
  }

  String get signalStrengthDescription {
    if (rssi >= -50) return 'Excellent';
    if (rssi >= -60) return 'Good';
    if (rssi >= -70) return 'Fair';
    if (rssi >= -80) return 'Poor';
    return 'Very Poor';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RealMeshDevice &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'RealMeshDevice{id: $id, name: $name, rssi: $rssi}';
  }
}