// Uppdaterad persons_operations.dart med vehicleIds
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

    print('Enter personalNumber: ');
    var personalNumber = stdin.readLineSync();

    if (Validator.isString(name) && Validator.isString(personalNumber)) {
      Person person = Person(
        name: name!,
        personalNumber: personalNumber!,
        vehicleIds: [],
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
          '${i + 1}. ${allPersons[i].name} - ${allPersons[i].personalNumber} - [${allPersons[i].vehicleIds.join(', ')}]');
    }
  }

  static Future update() async {
    print('Pick an index to update: ');
    List<Person> allPersons = await repository.getAll();
    for (int i = 0; i < allPersons.length; i++) {
      print('${i + 1}. ${allPersons[i].name} - ${allPersons[i].personalNumber}');
    }

    String? input = stdin.readLineSync();

    if (Validator.isIndex(input, allPersons)) {
      int index = int.parse(input!) - 1;

      while (true) {
        print("\n------------------------------------\n");

        Person person = await repository.getById(allPersons[index].id);

        print(
            "Update: ${person.name} - ${person.personalNumber} - [${person.vehicleIds.join(', ')}]");
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
        print("Update more? (y/n)");
        input = stdin.readLineSync();
        if (input == 'n') break;
      }
    } else {
      print('Invalid input');
    }
  }

  static Future _updateName(Person person) async {
    print('Enter new name: ');
    var name = stdin.readLineSync();

    if (Validator.isString(name)) {
      person.name = name!;
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
      print('${i + 1}. ${allVehicles[i].registrationNumber}');
    }

    var input = stdin.readLineSync();

    if (Validator.isIndex(input, allVehicles)) {
      int index = int.parse(input!) - 1;
      person.vehicleIds.add(allVehicles[index].id);
      await repository.update(person.id, person);
      print('Vehicle added to person');
    } else {
      print('Invalid input');
    }
  }

  static Future _removeVehiclesFromPerson(Person person) async {
    print('Pick a vehicle to remove: ');
    for (int i = 0; i < person.vehicleIds.length; i++) {
      print('${i + 1}. ${person.vehicleIds[i]}');
    }

    String? input = stdin.readLineSync();

    if (Validator.isIndex(input, person.vehicleIds)) {
      int index = int.parse(input!) - 1;
      person.vehicleIds.removeAt(index);
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
      print('${i + 1}. ${allPersons[i].name} - ${allPersons[i].personalNumber}');
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
