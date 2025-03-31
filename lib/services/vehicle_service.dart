import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vehicle.dart';

class VehicleService {
  final String baseUrl = 'http://10.0.2.2:8080/vehicles';

  Future<Vehicle?> getVehicleById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Vehicle.fromJson(json);
    }

    return null;
  }

  Future<Vehicle> createVehicle(Vehicle vehicle) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(vehicle.toJson()),
    );
    if (response.statusCode == 200) {
      return Vehicle.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Kunde inte skapa fordon');
    }
  }

  Future<void> deleteVehicle(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Kunde inte ta bort fordon');
    }
  }
}
