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

  Future<void> updateVehicle(Vehicle vehicle) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${vehicle.id}'),
      body: jsonEncode(vehicle.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Kunde inte uppdatera fordon');
    }
  }

  Future<void> deleteVehicle(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Kunde inte ta bort fordon');
    }
  }
    Future<List<Vehicle>> getAllVehicles() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Vehicle.fromJson(json)).toList();
    } else {
      throw Exception('Kunde inte hämta fordon');
    }
  }
}



