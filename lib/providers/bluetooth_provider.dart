import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/realmesh_device.dart';
import '../models/node_status.dart';

class BluetoothProvider extends ChangeNotifier {
  static const String serviceUuid = '12345678-1234-1234-1234-123456789abc';
  static const String characteristicUuid = '87654321-4321-4321-4321-cba987654321';

  bool _isScanning = false;
  bool _isBluetoothEnabled = false;
  List<RealMeshDevice> _devices = [];
  RealMeshDevice? _connectedDevice;
  NodeStatus? _nodeStatus;
  String _lastError = '';

  StreamSubscription<List<ScanResult>>? _scanSubscription;
  BluetoothCharacteristic? _characteristic;

  // Getters
  bool get isScanning => _isScanning;
  bool get isBluetoothEnabled => _isBluetoothEnabled;
  List<RealMeshDevice> get devices => List.unmodifiable(_devices);
  RealMeshDevice? get connectedDevice => _connectedDevice;
  NodeStatus? get nodeStatus => _nodeStatus;
  String get lastError => _lastError;
  bool get isConnected => _connectedDevice != null && _characteristic != null;

  BluetoothProvider() {
    _initializeBluetooth();
  }

  Future<void> _initializeBluetooth() async {
    // Check if Bluetooth is supported
    if (await FlutterBluePlus.isSupported == false) {
      _lastError = 'Bluetooth not supported by this device';
      notifyListeners();
      return;
    }

    // Listen to Bluetooth state changes
    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      _isBluetoothEnabled = state == BluetoothAdapterState.on;
      notifyListeners();
    });

    // Check current state
    _isBluetoothEnabled = await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on;
    notifyListeners();
  }

  Future<bool> requestPermissions() async {
    if (await Permission.bluetoothScan.isDenied) {
      await Permission.bluetoothScan.request();
    }
    if (await Permission.bluetoothConnect.isDenied) {
      await Permission.bluetoothConnect.request();
    }
    if (await Permission.location.isDenied) {
      await Permission.location.request();
    }

    return await Permission.bluetoothScan.isGranted &&
           await Permission.bluetoothConnect.isGranted &&
           await Permission.location.isGranted;
  }

  Future<void> startScan() async {
    if (_isScanning) return;

    if (!_isBluetoothEnabled) {
      _lastError = 'Bluetooth is not enabled';
      notifyListeners();
      return;
    }

    if (!await requestPermissions()) {
      _lastError = 'Bluetooth permissions not granted';
      notifyListeners();
      return;
    }

    try {
      _devices.clear();
      _isScanning = true;
      _lastError = '';
      notifyListeners();

      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 15),
        withServices: [Guid(serviceUuid)],
      );

      _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
        for (ScanResult result in results) {
          final device = RealMeshDevice.fromScanResult(result);
          
          // Check if device already exists in list
          final existingIndex = _devices.indexWhere((d) => d.id == device.id);
          if (existingIndex != -1) {
            _devices[existingIndex] = device; // Update with new RSSI
          } else {
            _devices.add(device);
          }
        }
        notifyListeners();
      });

      // Auto-stop scanning after timeout
      Timer(const Duration(seconds: 15), () {
        if (_isScanning) {
          stopScan();
        }
      });

    } catch (e) {
      _lastError = 'Failed to start scan: $e';
      _isScanning = false;
      notifyListeners();
    }
  }

  Future<void> stopScan() async {
    if (!_isScanning) return;

    try {
      await FlutterBluePlus.stopScan();
      await _scanSubscription?.cancel();
      _scanSubscription = null;
      _isScanning = false;
      notifyListeners();
    } catch (e) {
      _lastError = 'Failed to stop scan: $e';
      notifyListeners();
    }
  }

  Future<bool> connectToDevice(RealMeshDevice device) async {
    if (_connectedDevice != null) {
      await disconnect();
    }

    try {
      _lastError = '';
      notifyListeners();

      await device.bluetoothDevice.connect(timeout: const Duration(seconds: 10));
      
      // Discover services
      List<BluetoothService> services = await device.bluetoothDevice.discoverServices();
      
      // Find our service and characteristic
      for (BluetoothService service in services) {
        if (service.uuid.toString().toLowerCase() == serviceUuid.toLowerCase()) {
          for (BluetoothCharacteristic characteristic in service.characteristics) {
            if (characteristic.uuid.toString().toLowerCase() == characteristicUuid.toLowerCase()) {
              _characteristic = characteristic;
              
              // Enable notifications if supported
              if (characteristic.properties.notify) {
                await characteristic.setNotifyValue(true);
                characteristic.lastValueStream.listen((value) {
                  if (value.isNotEmpty) {
                    _handleCharacteristicData(String.fromCharCodes(value));
                  }
                });
              }
              
              _connectedDevice = device;
              notifyListeners();
              
              // Get initial status
              await getNodeStatus();
              
              return true;
            }
          }
        }
      }
      
      _lastError = 'RealMesh service not found';
      await device.bluetoothDevice.disconnect();
      return false;
      
    } catch (e) {
      _lastError = 'Connection failed: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> disconnect() async {
    if (_connectedDevice != null) {
      try {
        await _connectedDevice!.bluetoothDevice.disconnect();
      } catch (e) {
        debugPrint('Error disconnecting: $e');
      }
      
      _connectedDevice = null;
      _characteristic = null;
      _nodeStatus = null;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> sendCommand(String command, [Map<String, dynamic>? params]) async {
    if (_characteristic == null) {
      _lastError = 'Not connected to device';
      notifyListeners();
      return null;
    }

    try {
      final commandJson = {
        'command': command,
        if (params != null) ...params,
      };

      final commandString = jsonEncode(commandJson);
      await _characteristic!.write(commandString.codeUnits);
      
      // Wait for response (handled by notification listener)
      // For now, return a success indication
      return {'success': true};
      
    } catch (e) {
      _lastError = 'Failed to send command: $e';
      notifyListeners();
      return null;
    }
  }

  void _handleCharacteristicData(String data) {
    try {
      final response = jsonDecode(data);
      
      if (response['success'] == true && response['data'] != null) {
        // Handle different types of responses
        final responseData = response['data'];
        
        if (responseData['address'] != null) {
          // This is a status response
          _nodeStatus = NodeStatus.fromJson(responseData);
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error parsing characteristic data: $e');
    }
  }

  // Convenience methods for specific commands
  Future<NodeStatus?> getNodeStatus() async {
    final response = await sendCommand('status');
    return response != null ? _nodeStatus : null;
  }

  Future<List<String>?> getKnownNodes() async {
    final response = await sendCommand('nodes');
    return response?['data']?['nodes']?.cast<String>();
  }

  Future<bool> sendMessage(String targetAddress, String message) async {
    final response = await sendCommand('send', {
      'address': targetAddress,
      'message': message,
    });
    return response?['success'] == true;
  }

  Future<Map<String, dynamic>?> getNetworkStats() async {
    final response = await sendCommand('stats');
    return response?['data'];
  }

  @override
  void dispose() {
    stopScan();
    disconnect();
    super.dispose();
  }
}