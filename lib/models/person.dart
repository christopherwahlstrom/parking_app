import 'package:uuid/uuid.dart';

import 'vehicle.dart';

class Person {
  String name;
  String personalNumber;
  List<Vehicle> vehicles;
  String id;

  Person({required this.name, required this.personalNumber, List<Vehicle>? vehicles, String? id})
      : vehicles = vehicles ?? [],
        id = id ?? Uuid().v4();


  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'],
      personalNumber: json['personalNumber'],
      vehicles: (json['vehicles'] as List).map((e) => Vehicle.fromJson(e)).toList(),
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "personalNumber": personalNumber,
      "vehicles": vehicles.map((e) => e.toJson()).toList(),
      "id": id,
    };
  }
}
