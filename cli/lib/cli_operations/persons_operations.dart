import 'dart:io';

import 'package:cli/repositories/person_repository.dart';
import 'package:cli/repositories/vehicle_repository.dart';
import 'package:cli/utils/validator.dart';
import 'package:shared/shared.dart';

PersonRepository repository = PersonRepository();
VehicleRepository vehicleRepository = VehicleRepository();

class PersonsOperations {
  static Future create() async {
    print('Enter name: ');
    var name = stdin.readLineSync();

    print('Enter personnummer: ');
    var personnummer = stdin.readLineSync();

    if (Validator.isString(name) && Validator.isString(personnummer)) {
      Person person = Person(
        namn: name!,
        personnummer: personnummer!,
        vehicles: [],
      );
      await repository.create(person);
      print('Person created');
    } else {
      print('Invalid input');
    }
  }

  static Future list() async {
    List<Person> allPersons = await repository.getAll();
    for (int i = 0; i < allPersons.length; i++) {
      print(
          '${i + 1}. ${allPersons[i].namn} - ${allPersons[i].personnummer} - [${allPersons[i].vehicles.map((e) => e.registreringsnummer).join(', ')}]');
    }
  }

  static Future update() async {
    print('Pick an index to update: ');
    List<Person> allPersons = await repository.getAll();
    for (int i = 0; i < allPersons.length; i++) {
      print('${i + 1}. ${allPersons[i].namn} - ${allPersons[i].personnummer}');
    }

    String? input = stdin.readLineSync();

    if (Validator.isIndex(input, allPersons)) {
      int index = int.parse(input!) - 1;

      while (true) {
        print("\n------------------------------------\n");

        Person person = await repository.getById(allPersons[index].id);

        print(
            "What would you like to update in person: ${person.namn} - ${person.personnummer} - [${person.vehicles.map((e) => e.registreringsnummer).join(", ")}]?");
        print('1. Update Name');
        print('2. Add vehicle to person');
        print('3. Remove vehicle from person');

        var input = stdin.readLineSync();

        if (Validator.isNumber(input)) {
          int choice = int.parse(input!);

          switch (choice) {
            case 1:
              await _updateName(person);
              break;
            case 2:
              await _addVehicleToPerson(person);
              break;
            case 3:
              await _removeVehiclesFromPerson(person);
              break;
            default:
              print('Invalid choice');
          }
        } else {
          print('Invalid input');
        }
        print("Would you like to update anything else? (y/n)");
        input = stdin.readLineSync();
        if (input == 'n') {
          break;
        }
      }
    } else {
      print('Invalid input');
    }
  }

  static Future _updateName(Person person) async {
    print('Enter new name: ');
    var name = stdin.readLineSync();

    if (Validator.isString(name)) {
      person.namn = name!;
      await repository.update(person.id, person);
      print('Person updated');
    } else {
      print('Invalid input');
    }
  }

  static Future _addVehicleToPerson(Person person) async {

    var allVehicles = await vehicleRepository.getAll();
    print('Pick a vehicle to add: ');

    for (int i = 0; i < allVehicles.length; i++) {
      print('${i + 1}. ${allVehicles[i].registreringsnummer}');
    }

    var input = stdin.readLineSync();

    if (Validator.isIndex(input, allVehicles)) {
      int index = int.parse(input!) - 1;
      person.vehicles.add(allVehicles[index]);
      await repository.update(person.id, person);
      print('Vehicle added to person');
    } else {
      print('Invalid input');
    }
  }

  static Future _removeVehiclesFromPerson(Person person) async {
    print('Pick a vehicle to remove: ');
    for (int i = 0; i < person.vehicles.length; i++) {
      print('${i + 1}. ${person.vehicles[i].registreringsnummer}');
    }

    String? input = stdin.readLineSync();

    if (Validator.isIndex(input, person.vehicles)) {
      int index = int.parse(input!) - 1;
      person.vehicles.removeAt(index);
      await repository.update(person.id, person);
      print('Vehicle removed from person');
    } else {
      print('Invalid input');
    }
  }

  static Future delete() async {
    print('Pick an index to delete: ');
    List<Person> allPersons = await repository.getAll();
    for (int i = 0; i < allPersons.length; i++) {
      print('${i + 1}. ${allPersons[i].namn} - ${allPersons[i].personnummer}');
    }

    String? input = stdin.readLineSync();

    if (Validator.isIndex(input, allPersons)) {
      int index = int.parse(input!) - 1;
      await repository.delete(allPersons[index].id);
      print('Person deleted');
    } else {
      print('Invalid input');
    }
  }
}