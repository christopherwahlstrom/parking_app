import 'package:uuid/uuid.dart';

import 'vehicle.dart';

class Person {
  String namn;
  String personnummer;
  List<Vehicle> vehicles;
  String id;

  Person({required this.namn, required this.personnummer, List<Vehicle>? vehicles, String? id})
      : vehicles = vehicles ?? [],
        id = id ?? Uuid().v4();


  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      namn: json['namn'],
      personnummer: json['personnummer'],
      vehicles: (json['vehicles'] as List).map((e) => Vehicle.fromJson(e)).toList(),
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "namn": namn,
      "personnummer": personnummer,
      "vehicles": vehicles.map((e) => e.toJson()).toList(),
      "id": id,
    };
  }
}
