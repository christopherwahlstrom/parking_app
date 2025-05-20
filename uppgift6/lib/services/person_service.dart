import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/person.dart';
import 'dart:developer';

class PersonService {
  final String baseUrl = 'http://10.0.2.2:8080/persons';

  Future<Person?> getPersonByName(String name) async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final found = data.firstWhere(
          (p) => p['name'].toString().toLowerCase() == name.toLowerCase(),
          orElse: () => null,
        );
        if (found != null) {
          return Person.fromJson(found);
        }
      }
    } catch (e) {
      log('getPersonByName error: $e');
    }
    return null;
  }

  Future<bool> createPerson(Person person) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(person.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        log('createPerson failed: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      log('createPerson error: $e');
    }
    return false;
  }

  Future<bool> updatePerson(Person person) async {
    try {
      final url = Uri.parse('$baseUrl/${person.id}');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(person.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      log('updatePerson error: $e');
      return false;
    }
  }

  Future<void> removeVehicleFromPerson(String personId, String vehicleId) async {
  try {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final personJson = data.firstWhere((p) => p['id'] == personId, orElse: () => null);

      if (personJson != null) {
        final person = Person.fromJson(personJson);
        person.vehicleIds.remove(vehicleId); 
        await updatePerson(person); 
          }
        }
      } catch (e) {
        log('removeVehicleFromPerson error: $e');
      }
    }

  Future<void> addVehicleToPerson(String personId,  String vehicleId) async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final personJson = data.firstWhere((p) => p['id'] == personId, orElse: () => null);

        if (personJson != null) {
          final person = Person.fromJson(personJson);
          if (!person.vehicleIds.contains(vehicleId)) {
            person.vehicleIds.add(vehicleId); // Lägg till fordonets ID
            await updatePerson(person); // Uppdatera personen i persons.json
          }
        }
      }
    } catch (e) {
      log('addVehicleToPerson error: $e');
    }
  }

    Future<Person?> getPersonById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Person.fromJson(data);
      }
    } catch (e) {
      log('getPersonById error: $e');
    }
    return null;
  }

}
