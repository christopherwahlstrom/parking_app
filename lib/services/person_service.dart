import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';

class PersonService {
    final String baseUrl = 'http://10.0.2.2:8080/persons';

  Future<bool> login(String name) async{
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.any((p) => p['namn'] == name);
      } else {
        throw Exception('Kunde inte hämta personer');
      }
    } catch (e) {
      log('Login Error: $e');
      return false;
    }
  }
}