import 'package:server/repositories/vehicle_repository.dart';
import 'package:server/repositories/parking_space_repository.dart';
import 'package:shared/shared.dart';

class ParkingEntity {
  final String id;
  final String personId;
  final String vehicleId;
  final String parkingSpaceId;
  final String starttid;
  final String? sluttid;

  ParkingEntity({
    required this.id,
    required this.personId,
    required this.vehicleId,
    required this.parkingSpaceId,
    required this.starttid,
    this.sluttid,
  });

  factory ParkingEntity.fromJson(Map<String, dynamic> json) {
    return ParkingEntity(
      id: json['id'],
      personId: json['personId'],
      vehicleId: json['vehicleId'],
      parkingSpaceId: json['parkingSpaceId'],
      starttid: json['starttid'],
      sluttid: json['sluttid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personId': personId,
      'vehicleId': vehicleId,
      'parkingSpaceId': parkingSpaceId,
      'starttid': starttid,
      'sluttid': sluttid,
    };
  }

    Future<Parking> toModel() async {
    final vehicle = await VehicleRepository().getById(vehicleId);
    if (vehicle == null) {
      throw Exception('Fordon med ID $vehicleId hittades inte.');
    }

    final parkingSpaceEntity = await ParkingSpaceRepository().getById(parkingSpaceId);
    if (parkingSpaceEntity == null) {
      throw Exception('Parkeringsplats med ID $parkingSpaceId hittades inte.');
    }

    final parkingSpace = parkingSpaceEntity.toModel();

    return Parking(
      id: id,
      personId: personId,
      vehicleId: vehicleId,
      parkingSpaceId: parkingSpaceId,
      starttid: DateTime.parse(starttid),
      sluttid: sluttid != null ? DateTime.parse(sluttid!) : null,
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
      starttid: starttid.toIso8601String(),
      sluttid: sluttid?.toIso8601String(),
    );
  }
}
