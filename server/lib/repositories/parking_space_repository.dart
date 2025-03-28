import 'dart:convert';
import 'dart:io';
import 'package:server/models/parking_space_entity.dart';
import 'package:server/repositories/file_repository.dart';

class ParkingSpaceRepository extends FileRepository<ParkingSpaceEntity> {
  ParkingSpaceRepository() : super('parking_spaces.json');

  @override
  ParkingSpaceEntity fromJson(Map<String, dynamic> json) {
    return ParkingSpaceEntity.fromJson(json);
  }

  @override
  String idFromType(ParkingSpaceEntity entity) {
    return entity.id;
  }

  @override
  Map<String, dynamic> toJson(ParkingSpaceEntity entity) {
    return entity.toJson();
  }

  @override
  Future<List<ParkingSpaceEntity>> getAll() async {
    final file = File(filePath); 
    if (!await file.exists()) {
      return [];
    }

    final contents = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(contents);
    return jsonList.map((json) => fromJson(json)).toList();
  }
}
