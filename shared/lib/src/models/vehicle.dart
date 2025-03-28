import 'package:uuid/uuid.dart';

class Vehicle {
  String registreringsnummer;
  String typ;
  String ownerId;
  String id;

  Vehicle({
    required this.registreringsnummer,
    required this.typ,
    required this.ownerId,
    String? id,
  }) : id = id ?? Uuid().v4();

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
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
}