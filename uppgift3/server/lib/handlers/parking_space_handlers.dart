import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:server/repositories/parking_space_repository.dart';
import 'package:server/models/parking_space_entity.dart';
import 'package:shared/shared.dart';

final parkingSpaceRepository = ParkingSpaceRepository();

Future<Response> postParkingSpaceHandler(Request request) async {
  try {
    final data = await request.readAsString();
    final json = jsonDecode(data);
    var parkingSpace = ParkingSpace.fromJson(json);

    var parkingSpaceEntity = await parkingSpaceRepository.create(parkingSpace.toEntity());

    parkingSpace = parkingSpaceEntity.toModel();

    return Response.ok(
      jsonEncode(parkingSpace.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(body: 'Error creating parking space: $e');
  }
}

Future<Response> getParkingSpacesHandler(Request request) async {
  try {
    final entities = await parkingSpaceRepository.getAll();

    final parkingSpaces = entities.map((e) => e.toModel()).toList();

    final payload = parkingSpaces.map((e) => e.toJson()).toList();

    return Response.ok(
      jsonEncode(payload),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(body: 'Error getting parking spaces: $e');
  }
}

Future<Response> getParkingSpaceByIdHandler(Request request, String id) async {
  try {
    final entity = await parkingSpaceRepository.getById(id);
    if (entity == null) {
      return Response.notFound('Parking space not found');
    }

    final parkingSpace = entity.toModel();

    return Response.ok(
      jsonEncode(parkingSpace.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(body: 'Error getting parking space: $e');
  }
}

Future<Response> updateParkingSpaceHandler(Request request, String id) async {
  try {
    final data = await request.readAsString();
    final json = jsonDecode(data);
    var parkingSpace = ParkingSpace.fromJson(json);

    var entity = parkingSpace.toEntity();
    entity = await parkingSpaceRepository.update(id, entity);
    parkingSpace = entity.toModel();

    return Response.ok(
      jsonEncode(parkingSpace.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(body: 'Error updating parking space: $e');
  }
}

Future<Response> deleteParkingSpaceHandler(Request request, String id) async {
  try {
    final entity = await parkingSpaceRepository.delete(id);

    final parkingSpace = entity.toModel();

    return Response.ok(
      jsonEncode(parkingSpace.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(body: 'Error deleting parking space: $e');
  }
}