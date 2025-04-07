import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/parking_space.dart';

class ParkingSpaceService {
  Future<List<ParkingSpace>> loadSpaces() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/parking_spaces'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => ParkingSpace.fromJson(e)).toList();
    } else {
      throw Exception('Kunde inte ladda parkeringszoner');
    }
  }
}
