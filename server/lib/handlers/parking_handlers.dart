
import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:server/repositories/parking_repository.dart';
import 'package:server/models/parking_entity.dart';
import 'package:shared/shared.dart';

final parkingRepository = ParkingRepository();

Future<Response> postParkingHandler(Request request) async {
  try {
    final data = await request.readAsString();
    
    print('Received raw POST body: $data');

    final json = jsonDecode(data);
    var parking = Parking.fromJson(json);

    var parkingEntity = await parkingRepository.create(parking.toEntity());
    parking = await parkingEntity.toModel();

    return Response.ok(
      jsonEncode(parking.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    } catch (e, stack) {
    print('Error in postParkingHandler: $e');
    print('Stacktrace: $stack');
    return Response.internalServerError(body: 'Error creating parking: $e');
  }
}

Future<Response> getParkingsHandler(Request request) async {
  try {
    final personId = request.url.queryParameters['personId'];
    final entities = await parkingRepository.getAll();

    print('Fick ${entities.length} parkeringar totalt.');
    print('personId från query: $personId');

    
    final parkings = await Future.wait(entities.map((e) async {
      try {
        final model = await e.toModel();
        print('Konverterad Parking: id=${model.id}, personId=${model.personId}');
        return model;
      } catch (err) {
        print('Fel vid konvertering av ParkingEntity ${e.id}: $err');
        return null;
      }
    }));

    
    final validParkings = parkings.whereType<Parking>().toList();

    final filtered = personId != null
        ? validParkings.where((p) => p.personId == personId).toList()
        : validParkings;

    final payload = filtered.map((e) => e.toJson()).toList();

    return Response.ok(
      jsonEncode(payload),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    print('Error in getParkingsHandler: $e');
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

    final existing = await parkingRepository.getById(id);
    if (existing == null) {
      return Response.notFound('Parking not found');
    }

    final endTimeStr = json['endTime'];
    if (endTimeStr == null) {
      return Response.badRequest(body: 'Missing endTime');
    }

    final updatedEntity = existing.copyWith(endTime: endTimeStr);
    final saved = await parkingRepository.update(id, updatedEntity);
    final parking = await saved.toModel();

    return Response.ok(
      jsonEncode(parking.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e, stack) {
    print('Error in updateParkingHandler: $e');
    print('Stacktrace: $stack');
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
