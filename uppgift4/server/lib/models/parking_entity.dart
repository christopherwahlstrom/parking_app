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
    if (json['id'] == null || json['vehicleId'] == null || json['parkingSpaceId'] == null || json['startTime'] == null) {
      throw Exception("Invalid parking JSON: saknar id, vehicleId, parkingSpaceId eller startTime");
    }

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

    final resolvedPersonId = personId ?? vehicle.ownerId;
    

    return Parking(
      id: id,
      personId: resolvedPersonId,
      vehicleId: vehicle.id,
      vehicle: vehicle.toModel(),
      parkingSpaceId: parkingSpace.id,
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
      vehicleId: vehicleId,
      parkingSpaceId: parkingSpaceId,
      startTime: startTime.toIso8601String(),
      endTime: endTime?.toIso8601String(),
    );
  }
}

extension ParkingEntityCopyWith on ParkingEntity {
  ParkingEntity copyWith({
    String? id,
    String? personId,
    String? vehicleId,
    String? parkingSpaceId,
    String? startTime,
    String? endTime,
  }) {
    return ParkingEntity(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      vehicleId: vehicleId ?? this.vehicleId,
      parkingSpaceId: parkingSpaceId ?? this.parkingSpaceId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
