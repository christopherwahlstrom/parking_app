import 'package:uuid/uuid.dart';
import 'vehicle.dart';
import 'parking_space.dart';

class Parking {
  String id;
  String personId;
  Vehicle vehicle;
  ParkingSpace parkingSpace;
  DateTime startTime;
  DateTime? endTime;

  Parking({
    required this.personId,
    required this.vehicle,
    required this.parkingSpace,
    required this.startTime,
    this.endTime,
    String? id,
  }) : id = id ?? Uuid().v4();

  factory Parking.fromJson(Map<String, dynamic> json) {
    final personId = json['personId'];
    if (personId == null) {
      throw Exception('❌ personId is missing in Parking JSON: $json');
    }

    return Parking(
      id: json['id'],
      personId: json['personId'] ?? '',
      vehicle: Vehicle.fromJson(json['vehicle']),
      parkingSpace: ParkingSpace.fromJson(json['parkingSpace']),
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
    );
  }

    Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personId': personId,
      'vehicleId': vehicle.id,
      'parkingSpaceId': parkingSpace.id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
    };
  }
}
