import 'dart:convert';
import 'dart:io';

import 'package:shared/shared.dart';

abstract class FileRepository<T> implements RepositoryInterface<T> {
  final String filePath;

  FileRepository(this.filePath);

  T fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson(T entity);  
  String idFromType(T entity);           

  Future<List<T>> readFile() async {
    final file = File(filePath);

    if (!await file.exists()) {
      await file.writeAsString('[]');
      return [];
    }

    final content = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(content);
    return jsonList.map((json) => fromJson(json)).toList();
  }

  Future<void> writeFile(List<T> entities) async {  // 🔥 "vehicles" -> "entities"
    final file = File(filePath);
    final jsonList = entities.map((entity) => toJson(entity)).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  @override
  Future<T> create(T entity) async {
    var entities = await readFile();
    entities.add(entity);
    await writeFile(entities);
    return entity;
  }

  @override
  Future<List<T>> getAll() async {
    return await readFile();
  }

  @override
  Future<T?> getById(String id) async {
    var entities = await readFile();
    for (var entity in entities) {
      if (idFromType(entity) == id) {
        return entity;
      }
    }
    return null;
  }

  @override
  Future<T> update(String id, T newEntity) async {
    var entities = await readFile();
    for (var i = 0; i < entities.length; i++) {
      if (idFromType(entities[i]) == id) {
        entities[i] = newEntity;
        await writeFile(entities);
        return newEntity;
      }
    }
    throw Exception('Entity not found');
  }

  @override
  Future<T> delete(String id) async {
    var entities = await readFile();
    var index = entities.indexWhere((entity) => idFromType(entity) == id);
    if (index == -1) {
      throw Exception('Entity not found');
    } else {
      var entity = entities.removeAt(index);
      await writeFile(entities);
      return entity;
    }
  }
}
