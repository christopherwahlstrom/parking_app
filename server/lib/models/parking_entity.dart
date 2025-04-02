import 'package:server/repositories/vehicle_repository.dart';
import 'package:server/repositories/parking_space_repository.dart';
import 'package:shared/shared.dart';

class ParkingEntity {
  final String id;
  final String? personId;
  final String vehicleId;
  final String parkingSpaceId;
  final String startTime;
  final String? endTime;

  ParkingEntity({
    required this.id,
    required this.personId,
    required this.vehicleId,
    required this.parkingSpaceId,
    required this.startTime,
    this.endTime,
  });

  factory ParkingEntity.fromJson(Map<String, dynamic> json) {
    return ParkingEntity(
      id: json['id'],
      personId: json['personId'], 
      vehicleId: json['vehicleId'],
      parkingSpaceId: json['parkingSpaceId'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personId': personId,
      'vehicleId': vehicleId,
      'parkingSpaceId': parkingSpaceId,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  Future<Parking> toModel() async {
    final vehicle = await VehicleRepository().getById(vehicleId);
    if (vehicle == null) {
      throw Exception('Vehicle with ID $vehicleId not found');
    }

    final parkingSpaceEntity = await ParkingSpaceRepository().getById(parkingSpaceId);
    if (parkingSpaceEntity == null) {
      throw Exception('Parking space with ID $parkingSpaceId not found');
    }

    final parkingSpace = parkingSpaceEntity.toModel();

    // Hämta personId från vehicle om det saknas
    final resolvedPersonId = personId ?? vehicle.ownerId;

    if (resolvedPersonId == null) {
      throw Exception('Unable to resolve personId for parking with ID $id');
    }

    return Parking(
      id: id,
      personId: resolvedPersonId,
      vehicle: vehicle.toModel(),
      parkingSpace: parkingSpace,
      startTime: DateTime.parse(startTime),
      endTime: endTime != null ? DateTime.parse(endTime!) : null,
    );
  }
}

extension EntityConversion on Parking {
  ParkingEntity toEntity() {
    return ParkingEntity(
      id: id,
      personId: personId,
      vehicleId: vehicle.id,
      parkingSpaceId: parkingSpace.id,
      startTime: startTime.toIso8601String(),
      endTime: endTime?.toIso8601String(),
    );
  }
}
