import 'package:server/models/person_entity.dart';
import 'package:server/repositories/file_repository.dart';

class PersonRepository extends FileRepository<PersonEntity> {
  PersonRepository() : super('persons.json');

  @override
  PersonEntity fromJson(Map<String, dynamic> json) {
    return PersonEntity.fromJson(json);
  }

  @override
  String idFromType(PersonEntity entity) {
    return entity.id;
  }

  @override
  Map<String, dynamic> toJson(PersonEntity entity) {
    return entity.toJson();
  }
}
