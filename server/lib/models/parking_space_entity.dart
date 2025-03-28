import 'package:shared/shared.dart';

class ParkingSpaceEntity {
  final String id;
  final String adress;
  final double prisPerTimme;

  ParkingSpaceEntity({
    required this.id,
    required this.adress,
    required this.prisPerTimme,
  });

  factory ParkingSpaceEntity.fromJson(Map<String, dynamic> json) {
    return ParkingSpaceEntity(
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

  ParkingSpace toModel() {
    return ParkingSpace(
      id: id,
      adress: adress,
      prisPerTimme: prisPerTimme,
    );
  }
}

extension EntityConversion on ParkingSpace {
  ParkingSpaceEntity toEntity() {
    return ParkingSpaceEntity(
      id: id,
      adress: adress,
      prisPerTimme: prisPerTimme,
    );
  }
}