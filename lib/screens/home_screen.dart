import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/bluetooth_provider.dart';
import 'messages_screen.dart';
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

    final List<Widget> screens = [
      const NodeHomeScreen(),
      const MessagesScreen(),
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
            icon: const Icon(Icons.home),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat_bubble),
            label: l10n.messages,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}

// Combined home screen with connection + node info + stats
class NodeHomeScreen extends StatefulWidget {
  const NodeHomeScreen({super.key});

  @override
  State<NodeHomeScreen> createState() => _NodeHomeScreenState();
}

class _NodeHomeScreenState extends State<NodeHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final bluetoothProvider = Provider.of<BluetoothProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          if (!bluetoothProvider.isConnected)
            IconButton(
              icon: Icon(
                bluetoothProvider.isScanning
                    ? Icons.bluetooth_searching
                    : Icons.bluetooth,
              ),
              onPressed: () {
                if (bluetoothProvider.isScanning) {
                  bluetoothProvider.stopScan();
                } else {
                  bluetoothProvider.startScan();
                }
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => bluetoothProvider.getNodeStatus(),
            ),
        ],
      ),
      body: bluetoothProvider.isConnected
          ? _buildConnectedView(context, bluetoothProvider)
          : _buildScanView(context, bluetoothProvider),
    );
  }

  Widget _buildScanView(BuildContext context, BluetoothProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    
    if (!provider.isBluetoothEnabled) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bluetooth_disabled, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              l10n.bluetoothNotEnabled,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.bluetoothNotAvailable,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Scan status header
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue[50],
          child: Row(
            children: [
              Icon(
                provider.isScanning ? Icons.bluetooth_searching : Icons.bluetooth,
                color: Colors.blue[700],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.isScanning ? l10n.scanning : l10n.readyToScan,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    Text(
                      provider.isScanning
                          ? l10n.lookingForRealMeshNodes
                          : l10n.tapScanToFindNodes,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
              ),
              if (!provider.isScanning)
                ElevatedButton.icon(
                  onPressed: provider.startScan,
                  icon: const Icon(Icons.search, size: 18),
                  label: Text(l10n.scan),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
            ],
          ),
        ),

        // Devices list
        Expanded(
          child: provider.devices.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.devices, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        provider.isScanning
                            ? l10n.searchingForDevices
                            : l10n.noDevicesFound,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      if (!provider.isScanning) ...[
                        const SizedBox(height: 8),
                        Text(
                          l10n.makeSureNodeIsPowered,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: provider.devices.length,
                  itemBuilder: (context, index) {
                    final device = provider.devices[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue[100],
                          child: Icon(
                            Icons.device_hub,
                            color: Colors.blue[700],
                          ),
                        ),
                        title: Text(
                          device.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('${l10n.signal}: ${device.rssi} dBm'),
                        trailing: IconButton(
                          icon: const Icon(Icons.login),
                          onPressed: () async {
                            final success = await provider.connectToDevice(device);
                            if (success && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.connectedTo(device.name)),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildConnectedView(BuildContext context, BluetoothProvider provider) {
    final status = provider.nodeStatus;
    final l10n = AppLocalizations.of(context)!;
    
    return RefreshIndicator(
      onRefresh: () async {
        await provider.getNodeStatus();
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Connection status card
          Card(
            color: Colors.green[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green[700], size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.connected,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[900],
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          provider.connectedDevice?.name ?? 'Unknown',
                          style: TextStyle(color: Colors.green[700]),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: provider.disconnect,
                    icon: const Icon(Icons.logout, size: 18),
                    label: Text(l10n.disconnect),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.green[700],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Node identity
          _buildInfoCard(
            context,
            l10n.nodeIdentity,
            Icons.badge,
            [
              _buildInfoRow(l10n.deviceAddress, status?.address ?? 'Unknown'),
              _buildInfoRow(l10n.domain, status?.domain ?? 'Unknown'),
              _buildInfoRow(l10n.type, status?.stationary == true ? l10n.stationary : l10n.mobile),
            ],
          ),

          const SizedBox(height: 16),

          // Network stats
          _buildInfoCard(
            context,
            l10n.network,
            Icons.network_check,
            [
              _buildInfoRow(l10n.knownNodes, status?.knownNodes.toString() ?? '0'),
              _buildInfoRow(l10n.uptime, _formatUptime(status?.uptimeSeconds ?? 0)),
              _buildInfoRow(l10n.battery, '${status?.batteryPercentage ?? 0}%'),
            ],
          ),

          const SizedBox(height: 16),

          // Radio stats
          _buildInfoCard(
            context,
            l10n.radio,
            Icons.radio,
            [
              _buildInfoRow(l10n.frequency, '${status?.radioFrequency ?? 0} MHz'),
              _buildInfoRow(l10n.bandwidth, '${status?.radioBandwidth ?? 0} kHz'),
              _buildInfoRow(l10n.spreadingFactor, status?.radioSf?.toString() ?? 'SF12'),
              _buildInfoRow(l10n.txPower, '${status?.radioTxPower ?? 20} dBm'),
            ],
          ),

          const SizedBox(height: 16),

          // Message stats
          _buildInfoCard(
            context,
            l10n.messages,
            Icons.mail,
            [
              _buildInfoRow(l10n.sent, status?.messagesSent.toString() ?? '0'),
              _buildInfoRow(l10n.received, status?.messagesReceived.toString() ?? '0'),
              _buildInfoRow(l10n.errors, status?.errors.toString() ?? '0'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, IconData icon, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _formatUptime(int seconds) {
    if (seconds < 60) return '${seconds}s';
    if (seconds < 3600) return '${seconds ~/ 60}m';
    if (seconds < 86400) return '${seconds ~/ 3600}h ${(seconds % 3600) ~/ 60}m';
    return '${seconds ~/ 86400}d ${(seconds % 86400) ~/ 3600}h';
  }
}