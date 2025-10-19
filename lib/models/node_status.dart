import 'package:json_annotation/json_annotation.dart';

part 'node_status.g.dart';

@JsonSerializable()
class NodeStatus {
  final String address;
  final int state;
  final int uptime;
  final bool stationary;

  const NodeStatus({
    required this.address,
    required this.state,
    required this.uptime,
    required this.stationary,
  });

  factory NodeStatus.fromJson(Map<String, dynamic> json) => _$NodeStatusFromJson(json);

  Map<String, dynamic> toJson() => _$NodeStatusToJson(this);

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