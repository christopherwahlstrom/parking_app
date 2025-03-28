import 'dart:convert';

import 'package:server/models/person_entity.dart';
import 'package:server/repositories/person_repository.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

PersonRepository repo = PersonRepository();

Future<Response> postPersonHandler(Request request) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  var person = Person.fromJson(json);

  var personEntity = await repo.create(person.toEntity());

  person = await personEntity.toModel();

  return Response.ok(
    jsonEncode(person.toJson()),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> getPersonsHandler(Request request) async {
  final entities = await repo.getAll();

  final persons = await Future.wait(entities.map((e) => e.toModel()));

  final payload = persons.map((e) => e.toJson()).toList();

  return Response.ok(
    jsonEncode(payload),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> getPersonHandler(Request request) async {
  String? id = request.params["id"];

  if (id != null) {
    var entity = await repo.getById(id);

    var person = await entity?.toModel();

    return Response.ok(
      jsonEncode(person?.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  }

  return Response.badRequest();
}

Future<Response> updatePersonHandler(Request request) async {
  String? id = request.params["id"];

  if (id != null) {
    final data = await request.readAsString();
    final json = jsonDecode(data);
    Person? person = Person.fromJson(json);
    var entity = person.toEntity();
    entity = await repo.update(id, entity);
    person = await entity.toModel();

    return Response.ok(
      jsonEncode(person.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  }

  return Response.badRequest();
}

Future<Response> deletePersonHandler(Request request) async {
  String? id = request.params["id"];

  if (id != null) {
    var entity = await repo.delete(id);

    var person = await entity.toModel();

    return Response.ok(
      jsonEncode(person.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  }

  return Response.badRequest();
}
