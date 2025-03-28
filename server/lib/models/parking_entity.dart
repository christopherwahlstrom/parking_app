import 'package:server/repositories/vehicle_repository.dart';
import 'package:server/repositories/parking_space_repository.dart';
import 'package:shared/shared.dart';

class ParkingEntity {
  final String id;
  final String vehicleId;
  final String parkingSpaceId;
  final String starttid;
  final String? sluttid;

  ParkingEntity({
    required this.id,
    required this.vehicleId,
    required this.parkingSpaceId,
    required this.starttid,
    this.sluttid,
  });

  factory ParkingEntity.fromJson(Map<String, dynamic> json) {
    return ParkingEntity(
      id: json['id'],
      vehicleId: json['vehicleId'],
      parkingSpaceId: json['parkingSpaceId'],
      starttid: json['starttid'],
      sluttid: json['sluttid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'parkingSpaceId': parkingSpaceId,
      'starttid': starttid,
      'sluttid': sluttid,
    };
  }

  Future<Parking> toModel() async {
    final vehicle = await VehicleRepository().getById(vehicleId);
    final parkingSpaceEntity = await ParkingSpaceRepository().getById(parkingSpaceId);
    final parkingSpace = parkingSpaceEntity?.toModel();

    return Parking(
      id: id,
      fordon: vehicle!.toModel(),
      parkeringsplats: parkingSpace!,
      starttid: DateTime.parse(starttid),
      sluttid: sluttid != null ? DateTime.parse(sluttid!) : null,
    );
  }
}

extension EntityConversion on Parking {
  ParkingEntity toEntity() {
    return ParkingEntity(
      id: id,
      vehicleId: fordon.id,
      parkingSpaceId: parkeringsplats.id,
      starttid: starttid.toIso8601String(),
      sluttid: sluttid?.toIso8601String(),
    );
  }
}