import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/bluetooth_provider.dart';
import '../models/realmesh_device.dart';
import '../widgets/device_card.dart';

class DeviceScanScreen extends StatefulWidget {
  const DeviceScanScreen({super.key});

  @override
  State<DeviceScanScreen> createState() => _DeviceScanScreenState();
}

class _DeviceScanScreenState extends State<DeviceScanScreen> {
  @override
  void initState() {
    super.initState();
    // Start scanning when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bluetoothProvider = Provider.of<BluetoothProvider>(context, listen: false);
      if (bluetoothProvider.isBluetoothEnabled) {
        bluetoothProvider.startScan();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          Consumer<BluetoothProvider>(
            builder: (context, bluetoothProvider, child) {
              return IconButton(
                onPressed: bluetoothProvider.isScanning
                    ? bluetoothProvider.stopScan
                    : bluetoothProvider.startScan,
                icon: Icon(
                  bluetoothProvider.isScanning
                      ? Icons.stop
                      : Icons.refresh,
                ),
                tooltip: bluetoothProvider.isScanning
                    ? l10n.stopScan
                    : l10n.refresh,
              );
            },
          ),
        ],
      ),
      body: Consumer<BluetoothProvider>(
        builder: (context, bluetoothProvider, child) {
          if (!bluetoothProvider.isBluetoothEnabled) {
            return _buildBluetoothDisabledScreen(context);
          }

          if (bluetoothProvider.lastError.isNotEmpty) {
            return _buildErrorScreen(context, bluetoothProvider.lastError);
          }

          if (bluetoothProvider.devices.isEmpty && bluetoothProvider.isScanning) {
            return _buildScanningScreen(context);
          }

          if (bluetoothProvider.devices.isEmpty && !bluetoothProvider.isScanning) {
            return _buildNoDevicesScreen(context);
          }

          return _buildDeviceList(context, bluetoothProvider.devices);
        },
      ),
      floatingActionButton: Consumer<BluetoothProvider>(
        builder: (context, bluetoothProvider, child) {
          if (!bluetoothProvider.isBluetoothEnabled) {
            return const SizedBox.shrink();
          }

          return FloatingActionButton(
            onPressed: bluetoothProvider.isScanning
                ? bluetoothProvider.stopScan
                : bluetoothProvider.startScan,
            child: Icon(
              bluetoothProvider.isScanning
                  ? Icons.stop
                  : Icons.bluetooth_searching,
            ),
          );
        },
      ),
    );
  }

  Widget _buildBluetoothDisabledScreen(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bluetooth_disabled,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.bluetoothNotEnabled,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Please enable Bluetooth to scan for RealMesh devices',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen(BuildContext context, String error) {
    final l10n = AppLocalizations.of(context)!;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.error,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Provider.of<BluetoothProvider>(context, listen: false).startScan();
            },
            icon: const Icon(Icons.refresh),
            label: Text(l10n.refresh),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningScreen(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            l10n.scanning,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.lookingForRealMeshDevices,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDevicesScreen(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bluetooth_searching,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noDevicesFound,
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.makeSureDeviceIsPowered,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Provider.of<BluetoothProvider>(context, listen: false).startScan();
            },
            icon: const Icon(Icons.refresh),
            label: Text(l10n.refresh),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceList(BuildContext context, List<RealMeshDevice> devices) {
    return RefreshIndicator(
      onRefresh: () async {
        final bluetoothProvider = Provider.of<BluetoothProvider>(context, listen: false);
        await bluetoothProvider.startScan();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];
          return DeviceCard(
            device: device,
            onConnect: () => _connectToDevice(device),
          );
        },
      ),
    );
  }

  void _connectToDevice(RealMeshDevice device) async {
    final bluetoothProvider = Provider.of<BluetoothProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    // Show connecting dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Expanded(child: Text(l10n.connecting)),
          ],
        ),
      ),
    );

    final success = await bluetoothProvider.connectToDevice(device);
    
    if (mounted) {
      Navigator.of(context).pop(); // Close connecting dialog
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.connected} ${device.displayName}'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.connectionFailed}: ${bluetoothProvider.lastError}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}