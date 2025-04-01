import 'package:uuid/uuid.dart';
import 'vehicle.dart';
import 'parking_space.dart';

class Parking {
  final String id;
  final String vehicleId;
  final String parkingSpaceId;
  final DateTime starttid;
  final DateTime? sluttid;

  Parking({
    required this.id,
    required this.vehicleId,
    required this.parkingSpaceId,
    required this.starttid,
    this.sluttid,
  });

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json['id'],
      vehicleId: json['vehicleId'],
      parkingSpaceId: json['parkingSpaceId'],
      starttid: DateTime.parse(json['starttid']),
      sluttid:
          json['sluttid'] != null ? DateTime.tryParse(json['sluttid']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'vehicleId': vehicleId,
    'parkingSpaceId': parkingSpaceId,
    'starttid': starttid.toIso8601String(),
    'sluttid': sluttid?.toIso8601String(),
  };
}
