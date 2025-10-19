// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NodeStatus _$NodeStatusFromJson(Map<String, dynamic> json) => NodeStatus(
  address: json['address'] as String,
  state: (json['state'] as num).toInt(),
  uptime: (json['uptime'] as num).toInt(),
  stationary: json['stationary'] as bool,
);

Map<String, dynamic> _$NodeStatusToJson(NodeStatus instance) =>
    <String, dynamic>{
      'address': instance.address,
      'state': instance.state,
      'uptime': instance.uptime,
      'stationary': instance.stationary,
    };
