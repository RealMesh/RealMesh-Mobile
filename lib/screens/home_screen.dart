import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/bluetooth_provider.dart';
import 'device_scan_screen.dart';
import 'node_detail_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bluetoothProvider = Provider.of<BluetoothProvider>(context);

    final List<Widget> screens = [
      const DeviceScanScreen(),
      bluetoothProvider.isConnected 
          ? const NodeDetailScreen()
          : _buildNotConnectedScreen(context),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.bluetooth_searching),
            label: l10n.scanForDevices,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              bluetoothProvider.isConnected 
                  ? Icons.device_hub 
                  : Icons.device_hub_outlined,
            ),
            label: l10n.nodeStatus,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }

  Widget _buildNotConnectedScreen(BuildContext context) {
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
            l10n.disconnected,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.connectToViewStatus,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _selectedIndex = 0; // Switch to scan tab
              });
            },
            icon: const Icon(Icons.bluetooth_searching),
            label: Text(l10n.scanForDevices),
          ),
        ],
      ),
    );
  }
}