import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/parking.dart';

class ParkingService {
  final String baseUrl = 'http://10.0.2.2:8080/parkings';

  Future<List<Parking>> getParkingsByPerson(String personId) async {
    final response = await http.get(Uri.parse('$baseUrl?personId=$personId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((p) => Parking.fromJson(p)).toList();
    } else {
      throw Exception('Could not fetch parkings');
    }
  }

  Future<Parking> startParking(Parking parking) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(parking.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Parking.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Could not start parking');
    }
  }

  Future<Parking> stopParking(String parkingId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$parkingId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'endTime': DateTime.now().toIso8601String()}),
    );
    if (response.statusCode == 200) {
      return Parking.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Could not stop parking');
    }
  }

  
}
