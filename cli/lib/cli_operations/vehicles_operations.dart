import 'dart:io';

import 'package:cli/repositories/person_repository.dart';
import 'package:cli/repositories/vehicle_repository.dart';
import 'package:cli/utils/validator.dart';
import 'package:shared/shared.dart';

VehicleRepository vehicleRepository = VehicleRepository();
PersonRepository personRepository = PersonRepository();

class VehiclesOperations {
  static Future create() async {
    print('Enter registreringsnummer: ');
    var registreringsnummer = stdin.readLineSync();

    print('Enter typ (car, motorcycle, etc.): ');
    var typ = stdin.readLineSync();

    print('Enter owner personnummer: ');
    var ownerPersonnummer = stdin.readLineSync();

    if (Validator.isString(registreringsnummer) && Validator.isString(typ) && Validator.isString(ownerPersonnummer)) {
      List<Person> allPersons = await personRepository.getAll();
      Person? owner;
      try {
        owner = allPersons.firstWhere((person) => person.personnummer == ownerPersonnummer);
      } catch (e) {
        owner = null;
      }

      if (owner == null) {
        print('Owner not found. Please create the owner first.');
        return;
      }

      Vehicle vehicle = Vehicle(
        registreringsnummer: registreringsnummer!,
        typ: typ!,
        ownerId: owner.id,
      );

      await vehicleRepository.create(vehicle);
      owner.vehicles.add(vehicle);
      await personRepository.update(owner.id, owner);
      print('Vehicle created and linked to owner');
    } else {
      print('Invalid input');
    }
  }

  static Future list() async {
    List<Vehicle> allVehicles = await vehicleRepository.getAll();
    for (int i = 0; i < allVehicles.length; i++) {
      Person? owner;
      try {
        owner = await personRepository.getById(allVehicles[i].ownerId);
      } catch (e) {
        owner = null;
      }
      if (owner != null) {
        print('${i + 1}. ${allVehicles[i].registreringsnummer} - ${allVehicles[i].typ} - Owner: ${owner.namn}');
      } else {
        print('${i + 1}. ${allVehicles[i].registreringsnummer} - ${allVehicles[i].typ} - Owner: Not found');
      }
    }
  }

  static Future update() async {
    print('Pick an index to update: ');
    List<Vehicle> allVehicles = await vehicleRepository.getAll();
    for (int i = 0; i < allVehicles.length; i++) {
      Person? owner;
      try {
        owner = await personRepository.getById(allVehicles[i].ownerId);
      } catch (e) {
        owner = null;
      }
      if (owner != null) {
        print('${i + 1}. ${allVehicles[i].registreringsnummer} - ${allVehicles[i].typ} - Owner: ${owner.namn}');
      } else {
        print('${i + 1}. ${allVehicles[i].registreringsnummer} - ${allVehicles[i].typ} - Owner: Not found');
      }
    }

    String? input = stdin.readLineSync();

    if (Validator.isIndex(input, allVehicles)) {
      int index = int.parse(input!) - 1;
      Vehicle vehicle = allVehicles[index];

      print('Enter new registreringsnummer: ');
      var registreringsnummer = stdin.readLineSync();

      print('Enter new typ (car, motorcycle, etc.): ');
      var typ = stdin.readLineSync();

      print('Enter new owner personnummer: ');
      var ownerPersonnummer = stdin.readLineSync();

      if (Validator.isString(registreringsnummer) && Validator.isString(typ) && Validator.isString(ownerPersonnummer)) {
        List<Person> allPersons = await personRepository.getAll();
        Person? owner;
        try {
          owner = allPersons.firstWhere((person) => person.personnummer == ownerPersonnummer);
        } catch (e) {
          owner = null;
        }

        if (owner == null) {
          print('Owner not found. Please create the owner first.');
          return;
        }

        vehicle.registreringsnummer = registreringsnummer!;
        vehicle.typ = typ!;
        vehicle.ownerId = owner.id;

        await vehicleRepository.update(vehicle.id, vehicle);
        print('Vehicle updated');
      } else {
        print('Invalid input');
      }
    } else {
      print('Invalid input');
    }
  }

  static Future delete() async {
    print('Pick an index to delete: ');
    List<Vehicle> allVehicles = await vehicleRepository.getAll();
    for (int i = 0; i < allVehicles.length; i++) {
      Person? owner;
      try {
        owner = await personRepository.getById(allVehicles[i].ownerId);
      } catch (e) {
        owner = null;
      }
      if (owner != null) {
        print('${i + 1}. ${allVehicles[i].registreringsnummer} - ${allVehicles[i].typ} - Owner: ${owner.namn}');
      } else {
        print('${i + 1}. ${allVehicles[i].registreringsnummer} - ${allVehicles[i].typ} - Owner: Not found');
      }
    }

    String? input = stdin.readLineSync();

    if (Validator.isIndex(input, allVehicles)) {
      int index = int.parse(input!) - 1;
      await vehicleRepository.delete(allVehicles[index].id);
      print('Vehicle deleted');
    } else {
      print('Invalid input');
    }
  }
}