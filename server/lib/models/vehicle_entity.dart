import 'package:shared/shared.dart';

class VehicleEntity {
  final String registreringsnummer;
  final String typ;
  final String ownerId;
  final String id;

  VehicleEntity({
    required this.registreringsnummer,
    required this.typ,
    required this.ownerId,
    required this.id,
  });

  factory VehicleEntity.fromJson(Map<String, dynamic> json) {
    return VehicleEntity(
      registreringsnummer: json['registreringsnummer'],
      typ: json['typ'],
      ownerId: json['ownerId'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'registreringsnummer': registreringsnummer,
      'typ': typ,
      'ownerId': ownerId,
      'id': id,
    };
  }

  Vehicle toModel() {
    return Vehicle(
      registreringsnummer: registreringsnummer,
      typ: typ,
      ownerId: ownerId,
      id: id,
    );
  }
}

extension EntityConversion on Vehicle {
  VehicleEntity toEntity() {
    return VehicleEntity(
      registreringsnummer: registreringsnummer,
      typ: typ,
      ownerId: ownerId,
      id: id,
    );
  }
}