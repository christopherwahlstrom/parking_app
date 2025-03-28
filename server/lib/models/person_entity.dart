import 'package:server/repositories/vehicle_repository.dart';
import 'package:shared/shared.dart';

class PersonEntity {
  final String namn;
  final String personnummer;
  final List<String> vehiclesIds;
  final String id;

  PersonEntity({
    required this.namn,
    required this.personnummer,
    required this.vehiclesIds,
    required this.id,
  });

  factory PersonEntity.fromJson(Map<String, dynamic> json) {
    return PersonEntity(
      namn: json['namn'],
      personnummer: json['personnummer'],
      vehiclesIds:
          (json['vehiclesIds'] as List).map((e) => e as String).toList(),
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "namn": namn,
      "personnummer": personnummer,
      "vehiclesIds": vehiclesIds,
      "id": id,
    };
  }

  Future<Person> toModel() async {
    final vehicles = await Future.wait(
      vehiclesIds.map((id) => VehicleRepository().getById(id)),
    );
    return Person(
      namn: namn,
      personnummer: personnummer,
      vehicles: vehicles.whereType<Vehicle>().toList(),
      id: id,
    );
  }
}

extension EntityConversion on Person {
  PersonEntity toEntity() {
    return PersonEntity(
      namn: namn,
      personnummer: personnummer,
      vehiclesIds: vehicles.map((vehicle) => vehicle.id).toList(),
      id: id,
    );
  }
}
