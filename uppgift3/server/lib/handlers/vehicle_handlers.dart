import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:server/repositories/vehicle_repository.dart';
import 'package:server/models/vehicle_entity.dart';
import 'package:shared/shared.dart';

final vehicleRepository = VehicleRepository();

Future<Response> postVehicleHandler(Request request) async {
  try {
    final data = await request.readAsString();
    final json = jsonDecode(data);
    var vehicle = Vehicle.fromJson(json);

    var vehicleEntity = await vehicleRepository.create(vehicle.toEntity());

    vehicle = vehicleEntity.toModel();

    return Response.ok(
      jsonEncode(vehicle.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(body: 'Error creating vehicle: $e');
  }
}

Future<Response> getVehiclesHandler(Request request) async {
  try {
    final entities = await vehicleRepository.getAll();

    final vehicles = entities.map((e) => e.toModel()).toList();

    final payload = vehicles.map((e) => e.toJson()).toList();

    return Response.ok(
      jsonEncode(payload),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(body: 'Error getting vehicles: $e');
  }
}

Future<Response> getVehicleByIdHandler(Request request, String id) async {
  try {
    final entity = await vehicleRepository.getById(id);
    if (entity == null) {
      return Response.notFound('Vehicle not found');
    }

    final vehicle = entity.toModel();

    return Response.ok(
      jsonEncode(vehicle.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(body: 'Error getting vehicle: $e');
  }
}

Future<Response> updateVehicleHandler(Request request, String id) async {
  try {
    final data = await request.readAsString();
    final json = jsonDecode(data);
    var vehicle = Vehicle.fromJson(json);

    var entity = vehicle.toEntity();
    entity = await vehicleRepository.update(id, entity);
    vehicle = entity.toModel();

    return Response.ok(
      jsonEncode(vehicle.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(body: 'Error updating vehicle: $e');
  }
}

Future<Response> deleteVehicleHandler(Request request, String id) async {
  try {
    final entity = await vehicleRepository.delete(id);

    final vehicle = entity.toModel();

    return Response.ok(
      jsonEncode(vehicle.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(body: 'Error deleting vehicle: $e');
  }
}