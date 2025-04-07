import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared/shared.dart';
import 'vehicle_repository.dart';
import 'parking_space_repository.dart';

class ParkingRepository {
  final String baseUrl = 'http://localhost:8080/parkings';
  final vehicleRepo = VehicleRepository();
  final parkingSpaceRepo = ParkingSpaceRepository();

  Future<List<Parking>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch parkings');
    }

    final List<dynamic> data = jsonDecode(response.body);
    final vehicles = await vehicleRepo.getAll();
    final spaces = await parkingSpaceRepo.getAll();

    return data.map((json) {
      final parking = Parking.fromJson(json);

      final vehicle = vehicles.firstWhere(
        (v) => v.id == parking.vehicleId,
        orElse: () => throw Exception('Vehicle not found: ${parking.vehicleId}'),
      );

      final space = spaces.firstWhere(
        (s) => s.id == parking.parkingSpaceId,
        orElse: () => throw Exception('ParkingSpace not found: ${parking.parkingSpaceId}'),
      );

      return parking.copyWith(
        vehicle: vehicle,
        parkingSpace: space,
      );
    }).toList();
  }

  Future<Parking> create(Parking parking) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(parking.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create parking');
    }

    final json = jsonDecode(response.body);
    final created = Parking.fromJson(json);

    final vehicle = await vehicleRepo.getById(created.vehicleId);
    final space = await parkingSpaceRepo.getById(created.parkingSpaceId);

    return created.copyWith(vehicle: vehicle, parkingSpace: space);
  }

  Future<Parking> update(String id, Parking parking) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(parking.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update parking');
    }

    final json = jsonDecode(response.body);
    final updated = Parking.fromJson(json);

    final vehicle = await vehicleRepo.getById(updated.vehicleId);
    final space = await parkingSpaceRepo.getById(updated.parkingSpaceId);

    return updated.copyWith(vehicle: vehicle, parkingSpace: space);
  }

  Future<void> delete(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete parking');
    }
  }
}
