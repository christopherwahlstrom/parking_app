import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared/shared.dart';

class VehicleRepository implements RepositoryInterface<Vehicle> {
  @override
  Future<Vehicle> create(Vehicle vehicle) async {
    final uri = Uri.parse("http://localhost:8080/vehicles");

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(vehicle.toJson()),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Vehicle.fromJson(json);
    } else {
      print('Failed to create vehicle: ${response.body}');
      throw Exception('Failed to create vehicle');
    }
  }

  @override
  Future<Vehicle?> getById(String id) async {
    final uri = Uri.parse("http://localhost:8080/vehicles/$id");

    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Vehicle.fromJson(json);
    } else {
      print('Failed to get vehicle: ${response.body}');
      throw Exception('Failed to get vehicle');
    }
  }

  @override
  Future<List<Vehicle>> getAll() async {
    final uri = Uri.parse("http://localhost:8080/vehicles");

    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return (json as List).map((vehicle) => Vehicle.fromJson(vehicle)).toList();
    } else {
      print('Failed to get all vehicles: ${response.body}');
      throw Exception('Failed to get all vehicles');
    }
  }

  @override
  Future<Vehicle> delete(String id) async {
    final uri = Uri.parse("http://localhost:8080/vehicles/$id");

    final response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Vehicle.fromJson(json);
    } else {
      print('Failed to delete vehicle: ${response.body}');
      throw Exception('Failed to delete vehicle');
    }
  }

  @override
  Future<Vehicle> update(String id, Vehicle vehicle) async {
    final uri = Uri.parse("http://localhost:8080/vehicles/$id");

    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(vehicle.toJson()),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Vehicle.fromJson(json);
    } else {
      print('Failed to update vehicle: ${response.body}');
      throw Exception('Failed to update vehicle');
    }
  }
}