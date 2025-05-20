import 'package:uuid/uuid.dart';

class Person {
  String name;
  String personalNumber;
  String email;
  List<String> vehicleIds;
  String id;

  Person({
    required this.name,
    required this.personalNumber,
    this.email = '',
    List<String>? vehicleIds,
    String? id,
  })  : vehicleIds = vehicleIds ?? [],
        id = id ?? Uuid().v4();

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'],
      personalNumber: json['personalNumber'],
      email: json['email'] ?? '',
      vehicleIds: List<String>.from(json['vehicleIds'] ?? []),
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "personalNumber": personalNumber,
      "email": email,
      "vehicleIds": vehicleIds,
      "id": id,
    };
  }
}
