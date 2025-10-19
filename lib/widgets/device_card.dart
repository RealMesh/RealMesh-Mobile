import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/realmesh_device.dart';

class DeviceCard extends StatelessWidget {
  final RealMeshDevice device;
  final VoidCallback onConnect;

  const DeviceCard({
    super.key,
    required this.device,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getSignalColor(),
          child: Icon(
            Icons.device_hub,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          device.displayName,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l10n.deviceAddress}: ${device.id}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(
                  _getSignalIcon(),
                  size: 16,
                  color: _getSignalColor(),
                ),
                const SizedBox(width: 4),
                Text(
                  '${device.rssi} dBm (${device.signalStrengthDescription})',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _getSignalColor(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: onConnect,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(80, 36),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: Text(
            l10n.connect,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Color _getSignalColor() {
    if (device.rssi >= -50) return Colors.green;
    if (device.rssi >= -60) return Colors.lightGreen;
    if (device.rssi >= -70) return Colors.orange;
    if (device.rssi >= -80) return Colors.deepOrange;
    return Colors.red;
  }

  IconData _getSignalIcon() {
    if (device.rssi >= -50) return Icons.signal_wifi_4_bar;
    if (device.rssi >= -60) return Icons.signal_wifi_4_bar;
    if (device.rssi >= -70) return Icons.network_wifi_3_bar;
    if (device.rssi >= -80) return Icons.network_wifi_2_bar;
    return Icons.network_wifi_1_bar;
  }
}