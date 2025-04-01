import 'package:uuid/uuid.dart';
import 'vehicle.dart';
import 'parking_space.dart';

class Parking {
  String id;
  String personId;
  String vehicleId;
  String parkingSpaceId;
  DateTime starttid;
  DateTime? sluttid;

  Parking({
    required this.personId,
    required this.vehicleId,
    required this.parkingSpaceId,
    required this.starttid,
    this.sluttid,
    String? id,
  }) : id = id ?? Uuid().v4();

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json['id'] ?? '',
      personId: json['personId'],
      vehicleId: json['vehicleId'],
      parkingSpaceId: json['parkingSpaceId'],
      starttid: DateTime.parse(json['starttid']),
      sluttid: json['sluttid'] != null ? DateTime.parse(json['sluttid']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personId': personId,
      'vehicleId': vehicleId,
      'parkingSpaceId': parkingSpaceId,
      'starttid': starttid.toIso8601String(),
      'sluttid': sluttid?.toIso8601String(),
    };
  }
}
