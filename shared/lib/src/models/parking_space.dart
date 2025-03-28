import 'package:uuid/uuid.dart';

class ParkingSpace {
  String id;
  String adress;
  double prisPerTimme;

  ParkingSpace({
    required this.adress,
    required this.prisPerTimme,
    String? id,
  }) : id = id ?? Uuid().v4();

  factory ParkingSpace.fromJson(Map<String, dynamic> json) {
    return ParkingSpace(
      id: json['id'],
      adress: json['adress'],
      prisPerTimme: json['prisPerTimme'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'adress': adress,
      'prisPerTimme': prisPerTimme,
    };
  }
}