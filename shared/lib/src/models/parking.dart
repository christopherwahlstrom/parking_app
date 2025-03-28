import 'package:uuid/uuid.dart';
import 'vehicle.dart';
import 'parking_space.dart';

class Parking {
  String id;
  Vehicle fordon;
  ParkingSpace parkeringsplats;
  DateTime starttid;
  DateTime? sluttid;

  Parking({
    required this.fordon,
    required this.parkeringsplats,
    required this.starttid,
    this.sluttid,
    String? id,
  }) : id = id ?? Uuid().v4();

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json['id'],
      fordon: Vehicle.fromJson(json['fordon']),
      parkeringsplats: ParkingSpace.fromJson(json['parkeringsplats']),
      starttid: DateTime.parse(json['starttid']),
      sluttid: json['sluttid'] != null ? DateTime.parse(json['sluttid']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fordon': fordon.toJson(),
      'parkeringsplats': parkeringsplats.toJson(),
      'starttid': starttid.toIso8601String(),
      'sluttid': sluttid?.toIso8601String(),
    };
  }
}