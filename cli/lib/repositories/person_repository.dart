import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared/shared.dart';

class PersonRepository implements RepositoryInterface<Person> {
  @override
  Future<Person> create(Person person) async {
    final uri = Uri.parse("http://localhost:8080/persons");

    Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(person.toJson()),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Person.fromJson(json);
    } else {
      print('Failed to create person: ${response.body}');
      throw Exception('Failed to create person');
    }
  }

  @override
  Future<Person> getById(String id) async {
    final uri = Uri.parse("http://localhost:8080/persons/${id}");

    Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Person.fromJson(json);
    } else {
      print('Failed to get person: ${response.body}');
      throw Exception('Failed to get person');
    }
  }

  @override
  Future<List<Person>> getAll() async {
    final uri = Uri.parse("http://localhost:8080/persons");
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return (json as List).map((person) => Person.fromJson(person)).toList();
    } else {
      print('Failed to get all persons: ${response.body}');
      throw Exception('Failed to get all persons');
    }
  }

  @override
  Future<Person> delete(String id) async {
    final uri = Uri.parse("http://localhost:8080/persons/${id}");

    Response response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Person.fromJson(json);
    } else {
      print('Failed to delete person: ${response.body}');
      throw Exception('Failed to delete person');
    }
  }

  @override
  Future<Person> update(String id, Person person) async {
    final uri = Uri.parse("http://localhost:8080/persons/${id}");

    Response response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(person.toJson()),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Person.fromJson(json);
    } else {
      print('Failed to update person: ${response.body}');
      throw Exception('Failed to update person');
    }
  }
}