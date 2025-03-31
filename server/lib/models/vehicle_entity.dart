import 'package:shared/shared.dart';

class VehicleEntity {
  final String registrationNumber;
  final String type;
  final String ownerId;
  final String id;

  VehicleEntity({
    required this.registrationNumber,
    required this.type,
    required this.ownerId,
    required this.id,
  });

  factory VehicleEntity.fromJson(Map<String, dynamic> json) {
    return VehicleEntity(
      registrationNumber: json['registrationNumber'],
      type: json['type'],
      ownerId: json['ownerId'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'registrationNumber': registrationNumber,
      'type': type,
      'ownerId': ownerId,
      'id': id,
    };
  }

  Vehicle toModel() {
    return Vehicle(
      registrationNumber: registrationNumber,
      type: type,
      ownerId: ownerId,
      id: id,
    );
  }
}

extension EntityConversion on Vehicle {
  VehicleEntity toEntity() {
    return VehicleEntity(
      registrationNumber: registrationNumber,
      type: type,
      ownerId: ownerId,
      id: id,
    );
  }
}