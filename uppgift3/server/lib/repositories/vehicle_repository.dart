import 'dart:convert';
import 'dart:io';
import 'package:server/models/vehicle_entity.dart';
import 'package:server/repositories/file_repository.dart';

class VehicleRepository extends FileRepository<VehicleEntity> {
  VehicleRepository() : super('vehicles.json');

  @override
  VehicleEntity fromJson(Map<String, dynamic> json) {
    return VehicleEntity.fromJson(json);
  }

  @override
  String idFromType(VehicleEntity entity) {
    return entity.id;
  }

  @override
  Map<String, dynamic> toJson(VehicleEntity entity) {
    return entity.toJson();
  }

  @override
  Future<List<VehicleEntity>> getAll() async {
    final file = File(filePath); 
    if (!await file.exists()) {
      return [];
    }

    final contents = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(contents);
    return jsonList.map((json) => fromJson(json)).toList();
  }
}
