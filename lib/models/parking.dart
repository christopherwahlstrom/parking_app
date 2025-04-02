import 'package:uuid/uuid.dart';
import 'vehicle.dart';
import 'parking_space.dart';

class Parking {
  final String id;
  final String personId;
  final String vehicleId;
  final String parkingSpaceId;
  final DateTime startTime;
  final DateTime? endTime;

  Parking({
    required this.id,
    required this.personId,
    required this.vehicleId,
    required this.parkingSpaceId,
    required this.startTime,
    this.endTime,
  });

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json['id'],
      personId: json['personId'],
      vehicleId: json['vehicleId'],
      parkingSpaceId: json['parkingSpaceId'],
      startTime: DateTime.parse(json['startTime']),
      endTime:
          json['endTime'] != null ? DateTime.tryParse(json['endTime']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'personId': personId,
    'vehicleId': vehicleId,
    'parkingSpaceId': parkingSpaceId,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
  };
}
