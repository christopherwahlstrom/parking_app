import 'package:uuid/uuid.dart';

class Person {
  String name;
  String personalNumber;
  List<String> vehicleIds;
  String id;

  Person({
    required this.name,
    required this.personalNumber,
    List<String>? vehicleIds,
    String? id,
  })  : vehicleIds = vehicleIds ?? [],
        id = id ?? Uuid().v4();

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'],
      personalNumber: json['personalNumber'],
      vehicleIds: List<String>.from(json['vehicleIds'] ?? []),
      id: json['id'],
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
}
