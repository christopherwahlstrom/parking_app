import 'dart:convert';
import 'dart:io';
import '../models/parking_space.dart';

class ParkingSpaceService {
  final String filePath = 'server/parking_spaces.json';

  Future<List<ParkingSpace>> loadSpaces() async {
    final file = File(filePath);
    final contents = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(contents);
    return jsonList.map((z) => ParkingSpace.fromJson(z)).toList();
  }
}
