import 'package:shared/shared.dart';

class PersonEntity {
  final String name;
  final String personalNumber;
  final List<String> vehicleIds;
  final String id;

  PersonEntity({
    required this.name,
    required this.personalNumber,
    required this.vehicleIds,
    required this.id,
  });

  factory PersonEntity.fromJson(Map<String, dynamic> json) {
    return PersonEntity(
      name: json['name'] ?? 'Unknown',
      personalNumber: json['personalNumber'] ?? 'Unknown',
      id: json['id'] ?? 'Unknown',
      vehicleIds: List<String>.from(json['vehicleIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "personalNumber": personalNumber,
      "vehicleIds": vehicleIds,
      "id": id,
    };
  }

  Future<Person> toModel() async {
    return Person(
      name: name,
      personalNumber: personalNumber,
      vehicleIds: vehicleIds,
      id: id,
    );
  }
}

extension EntityConversion on Person {
  PersonEntity toEntity() {
    return PersonEntity(
      name: name,
      personalNumber: personalNumber,
      vehicleIds: vehicleIds,
      id: id,
    );
  }
}
