import 'package:mocktail/mocktail.dart';
import 'package:parking_app_uppgift4/services/person_service.dart';
import 'package:parking_app_uppgift4/models/person.dart';

class MockPersonService extends Mock implements PersonService {}

class MockPerson extends Mock implements Person {}
