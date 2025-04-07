import 'dart:convert';
import 'dart:io';

import 'package:server/models/parking_entity.dart';
import 'package:server/repositories/file_repository.dart';

class ParkingRepository extends FileRepository<ParkingEntity> {
  final String fileName;

  ParkingRepository() : fileName = 'parkings.json', super('parkings.json');

  @override
  ParkingEntity fromJson(Map<String, dynamic> json) {
    return ParkingEntity.fromJson(json);
  }

  @override
  String idFromType(ParkingEntity entity) {
    return entity.id;
  }

  @override
  Map<String, dynamic> toJson(ParkingEntity entity) {
    return entity.toJson();
  }

  @override
  Future<List<ParkingEntity>> getAll() async {
    final file = File(fileName);
    if (!await file.exists()) {
      return [];
    }

    final contents = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(contents);
    return jsonList.map((json) => fromJson(json)).toList();
  }
}