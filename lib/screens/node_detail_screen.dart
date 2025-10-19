import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/bluetooth_provider.dart';
import '../models/node_status.dart';

class NodeDetailScreen extends StatefulWidget {
  const NodeDetailScreen({super.key});

  @override
  State<NodeDetailScreen> createState() => _NodeDetailScreenState();
}

class _NodeDetailScreenState extends State<NodeDetailScreen> {
  final _messageController = TextEditingController();
  final _targetAddressController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    _targetAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.nodeStatus),
        actions: [
          Consumer<BluetoothProvider>(
            builder: (context, bluetoothProvider, child) {
              return IconButton(
                onPressed: () async {
                  await bluetoothProvider.getNodeStatus();
                },
                icon: const Icon(Icons.refresh),
                tooltip: l10n.refresh,
              );
            },
          ),
          Consumer<BluetoothProvider>(
            builder: (context, bluetoothProvider, child) {
              return IconButton(
                onPressed: bluetoothProvider.isConnected
                    ? () async {
                        await bluetoothProvider.disconnect();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.disconnected),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      }
                    : null,
                icon: const Icon(Icons.bluetooth_disabled),
                tooltip: l10n.disconnect,
              );
            },
          ),
        ],
      ),
      body: Consumer<BluetoothProvider>(
        builder: (context, bluetoothProvider, child) {
          if (!bluetoothProvider.isConnected) {
            return _buildNotConnectedScreen(context);
          }

          return RefreshIndicator(
            onRefresh: () async {
              await bluetoothProvider.getNodeStatus();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildConnectionInfo(context, bluetoothProvider),
                  const SizedBox(height: 16),
                  if (bluetoothProvider.nodeStatus != null) ...[
                    _buildNodeStatusCard(context, bluetoothProvider.nodeStatus!),
                    const SizedBox(height: 16),
                  ],
                  _buildMessageCard(context, bluetoothProvider),
                  const SizedBox(height: 16),
                  _buildActionsCard(context, bluetoothProvider),
                ],
              ),
            ),
          );
        },
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
        ],
      ),
    );
  }

  Widget _buildConnectionInfo(BuildContext context, BluetoothProvider bluetoothProvider) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final device = bluetoothProvider.connectedDevice!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bluetooth_connected,
                  color: Colors.green,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.connected,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(l10n.deviceName, device.displayName),
            _buildInfoRow(l10n.deviceAddress, device.id),
            _buildInfoRow(l10n.rssi, '${device.rssi} dBm'),
          ],
        ),
      ),
    );
  }

  Widget _buildNodeStatusCard(BuildContext context, NodeStatus nodeStatus) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.nodeInformation,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Address', nodeStatus.address),
            _buildInfoRow('State', nodeStatus.stateDescription),
            _buildInfoRow(l10n.uptime, nodeStatus.formattedUptime),
            _buildInfoRow('Mode', nodeStatus.stationary ? 'Stationary' : 'Mobile'),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageCard(BuildContext context, BluetoothProvider bluetoothProvider) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.sendMessage,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _targetAddressController,
              decoration: InputDecoration(
                labelText: l10n.targetAddress,
                hintText: 'Enter target node address...',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: l10n.message,
                hintText: 'Enter your message...',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.message),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _sendMessage(bluetoothProvider),
                icon: const Icon(Icons.send),
                label: Text(l10n.send),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard(BuildContext context, BluetoothProvider bluetoothProvider) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await bluetoothProvider.getKnownNodes();
                },
                icon: const Icon(Icons.device_hub),
                label: Text(l10n.knownNodes),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await bluetoothProvider.getNetworkStats();
                },
                icon: const Icon(Icons.analytics),
                label: Text(l10n.networkStatistics),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(BluetoothProvider bluetoothProvider) async {
    final targetAddress = _targetAddressController.text.trim();
    final message = _messageController.text.trim();

    if (targetAddress.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both target address and message'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final success = await bluetoothProvider.sendMessage(targetAddress, message);
    
    if (mounted) {
      if (success) {
        _messageController.clear();
        _targetAddressController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Message sent successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send message: ${bluetoothProvider.lastError}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}