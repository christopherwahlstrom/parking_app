import 'vehicle.dart';
import 'parking_space.dart';

class Parking {
  final String id;
  final String personId;
  final String vehicleId;
  final String parkingSpaceId;
  final DateTime startTime;
  final DateTime? endTime;

  final Vehicle? vehicle;
  final ParkingSpace? parkingSpace;

  Parking({
    required this.id,
    required this.personId,
    required this.vehicleId,
    required this.parkingSpaceId,
    required this.startTime,
    this.endTime,
    this.vehicle,
    this.parkingSpace,
  });

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json['id'],
      personId: json['personId'],
      vehicleId: json['vehicleId'],
      parkingSpaceId: json['parkingSpaceId'],
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.tryParse(json['endTime']) : null,
      vehicle: json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null,
      parkingSpace: json['parkingSpace'] != null ? ParkingSpace.fromJson(json['parkingSpace']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'personId': personId,
    'vehicleId': vehicleId,
    'parkingSpaceId': parkingSpaceId,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
    if (vehicle != null) 'vehicle': vehicle!.toJson(),
    if (parkingSpace != null) 'parkingSpace': parkingSpace!.toJson(),
  };

  Parking copyWith({
    String? id,
    String? personId,
    String? vehicleId,
    String? parkingSpaceId,
    DateTime? startTime,
    DateTime? endTime,
    Vehicle? vehicle,
    ParkingSpace? parkingSpace,
  }) {
    return Parking(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      vehicleId: vehicleId ?? this.vehicleId,
      parkingSpaceId: parkingSpaceId ?? this.parkingSpaceId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      vehicle: vehicle ?? this.vehicle,
      parkingSpace: parkingSpace ?? this.parkingSpace,
    );
  }
}
