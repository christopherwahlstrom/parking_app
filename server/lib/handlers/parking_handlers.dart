import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:server/repositories/parking_repository.dart';
import 'package:server/models/parking_entity.dart';
import 'package:shared/shared.dart';

final parkingRepository = ParkingRepository();

Future<Response> postParkingHandler(Request request) async {
  try {
    final data = await request.readAsString();
    final json = jsonDecode(data);
    var parking = Parking.fromJson(json);

    var parkingEntity = await parkingRepository.create(parking.toEntity());

    parking = await parkingEntity.toModel();

    return Response.ok(
      jsonEncode(parking.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(body: 'Error creating parking: $e');
  }
}

Future<Response> getParkingsHandler(Request request) async {
  try {
    final entities = await parkingRepository.getAll();

    final parkings = await Future.wait(entities.map((e) => e.toModel()));

    final payload = parkings.map((e) => e.toJson()).toList();

    return Response.ok(
      jsonEncode(payload),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(body: 'Error getting parkings: $e');
  }
}

Future<Response> getParkingByIdHandler(Request request, String id) async {
  try {
    final entity = await parkingRepository.getById(id);
    if (entity == null) {
      return Response.notFound('Parking not found');
    }

    final parking = await entity.toModel();

    return Response.ok(
      jsonEncode(parking.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(body: 'Error getting parking: $e');
  }
}

Future<Response> updateParkingHandler(Request request, String id) async {
  try {
    final data = await request.readAsString();
    final json = jsonDecode(data);
    var parking = Parking.fromJson(json);

    var entity = parking.toEntity();
    entity = await parkingRepository.update(id, entity);
    parking = await entity.toModel();

    return Response.ok(
      jsonEncode(parking.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(body: 'Error updating parking: $e');
  }
}

Future<Response> deleteParkingHandler(Request request, String id) async {
  try {
    final entity = await parkingRepository.delete(id);

    final parking = await entity.toModel();

    return Response.ok(
      jsonEncode(parking.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(body: 'Error deleting parking: $e');
  }
}