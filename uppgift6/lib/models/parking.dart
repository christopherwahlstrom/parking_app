// import 'package:uuid/uuid.dart';
// import 'vehicle.dart';
import 'parking_space.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Parking {
  final String id;
  final String personId;
  final String vehicleId;
  final String parkingSpaceId;
  final DateTime startTime;
  final DateTime? endTime;

  final ParkingSpace? parkingSpace;

  Parking({
    required this.id,
    required this.personId,
    required this.vehicleId,
    required this.parkingSpaceId,
    required this.startTime,
    this.endTime,
    this.parkingSpace,
  });

  static DateTime? parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String) return DateTime.tryParse(value);
    if (value is Timestamp) return value.toDate();
    return null;
  }


    factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json['id'],
      personId: json['personId'],
      vehicleId: json['vehicleId'],
      parkingSpaceId: json['parkingSpaceId'],
      startTime: parseDateTime(json['startTime'])!,
      endTime: parseDateTime(json['endTime']),
      parkingSpace: json['parkingSpace'] != null
          ? ParkingSpace.fromJson(json['parkingSpace'])
          : null,
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
