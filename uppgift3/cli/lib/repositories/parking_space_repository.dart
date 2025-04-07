import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared/shared.dart';

class ParkingSpaceRepository {
  final String baseUrl = 'http://localhost:8080/parkingspaces';

  Future<ParkingSpace> create(ParkingSpace parkingSpace) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(parkingSpace.toJson()),
    );

    if (response.statusCode == 200) {
      return ParkingSpace.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create parking space');
    }
  }

  Future<List<ParkingSpace>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => ParkingSpace.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get all parking spaces');
    }
  }

  Future<ParkingSpace?> getById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return ParkingSpace.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to get parking space');
    }
  }

  Future<ParkingSpace> update(String id, ParkingSpace parkingSpace) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(parkingSpace.toJson()),
    );

    if (response.statusCode == 200) {
      return ParkingSpace.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update parking space');
    }
  }

  Future<void> delete(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete parking space');
    }
  }
}