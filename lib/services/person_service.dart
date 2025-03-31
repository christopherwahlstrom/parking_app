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
  Future<void> updatePerson(Person person) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${person.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(person.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Kunde inte uppdatera person');
    }
  }
}
