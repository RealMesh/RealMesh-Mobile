import 'package:json_annotation/json_annotation.dart';

part 'node_status.g.dart';

@JsonSerializable()
class NodeStatus {
  final String address;
  final int state;
  final int uptime;
  final bool stationary;
  
  // Additional fields from firmware
  @JsonKey(name: 'known_nodes')
  final int? knownNodes;
  
  @JsonKey(name: 'battery_percent')
  final int? batteryPercentage;
  
  @JsonKey(name: 'messages_sent')
  final int? messagesSent;
  
  @JsonKey(name: 'messages_received')
  final int? messagesReceived;
  
  @JsonKey(name: 'errors')
  final int? errors;
  
  // Radio configuration
  @JsonKey(name: 'frequency')
  final double? radioFrequency;
  
  @JsonKey(name: 'bandwidth')
  final double? radioBandwidth;
  
  @JsonKey(name: 'sf')
  final int? radioSf;
  
  @JsonKey(name: 'tx_power')
  final int? radioTxPower;

  const NodeStatus({
    required this.address,
    required this.state,
    required this.uptime,
    required this.stationary,
    this.knownNodes,
    this.batteryPercentage,
    this.messagesSent,
    this.messagesReceived,
    this.errors,
    this.radioFrequency,
    this.radioBandwidth,
    this.radioSf,
    this.radioTxPower,
  });

  factory NodeStatus.fromJson(Map<String, dynamic> json) => _$NodeStatusFromJson(json);

  Map<String, dynamic> toJson() => _$NodeStatusToJson(this);
  
  String get domain {
    final parts = address.split('@');
    return parts.length > 1 ? parts[1] : 'unknown';
  }
  
  String get nodeType => stationary ? 'Stationary' : 'Mobile';
  
  int get uptimeSeconds => uptime;

  String get stateDescription {
    switch (state) {
      case 0: return 'Initializing';
      case 1: return 'Name Conflict';
      case 2: return 'Discovering';
      case 3: return 'Operational';
      case 4: return 'Error';
      default: return 'Unknown';
    }
  }

  String get formattedUptime {
    final duration = Duration(seconds: uptime);
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    
    if (days > 0) {
      return '${days}d ${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  @override
  String toString() {
    return 'NodeStatus{address: $address, state: $state, uptime: $uptime, stationary: $stationary}';
  }
}