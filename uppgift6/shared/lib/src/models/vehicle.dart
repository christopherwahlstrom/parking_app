import 'package:uuid/uuid.dart';

class Vehicle {
  String registrationNumber;
  String type;
  String ownerId;
  String id;

  Vehicle({
    required this.registrationNumber,
    required this.type,
    required this.ownerId,
    String? id,
  }) : id = id ?? Uuid().v4();

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
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
}