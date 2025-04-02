import 'dart:io';

import 'package:cli/repositories/parking_repository.dart';
import 'package:cli/repositories/vehicle_repository.dart';
import 'package:cli/repositories/parking_space_repository.dart';
import 'package:cli/utils/validator.dart';
import 'package:shared/shared.dart';

VehicleRepository vehicleRepository = VehicleRepository();
ParkingRepository repository = ParkingRepository();
ParkingSpaceRepository parkingSpaceRepository = ParkingSpaceRepository();

class ParkingOperations {
  static Future create() async {
    print('Enter vehicle registration number: ');
    var registrationNumber = stdin.readLineSync();

    print('Enter parking space address: ');
    var address = stdin.readLineSync();

    print('Enter personId: ');
    var personId = stdin.readLineSync();

    if (Validator.isString(registrationNumber) &&
        Validator.isString(address) &&
        Validator.isString(personId)) {
      final allVehicles = await vehicleRepository.getAll();
      final vehicle = allVehicles.firstWhere(
        (v) => v.registrationNumber == registrationNumber,
        orElse: () => throw Exception('Vehicle not found.'),
      );

      final allSpaces = await parkingSpaceRepository.getAll();
      final space = allSpaces.firstWhere(
        (p) => p.adress == address,
        orElse: () => throw Exception('Parking space not found.'),
      );

      final parking = Parking(
        id: '',
        personId: personId!,
        vehicle: vehicle,
        parkingSpace: space,
        startTime: DateTime.now(),
        endTime: null,
      );

      await repository.create(parking);
      print('✅ Parking created');
    } else {
      print('Invalid input');
    }
  }

  static Future list() async {
    final allParkings = await repository.getAll();
    for (int i = 0; i < allParkings.length; i++) {
      print(
        '${i + 1}. Vehicle: ${allParkings[i].vehicle.id} '
        '- Parking Space: ${allParkings[i].parkingSpace.adress} '
        '- Start: ${allParkings[i].startTime} '
        '- End: ${allParkings[i].endTime ?? 'Ongoing'}',
      );
    }
  }

  static Future update() async {
    final allParkings = await repository.getAll();
    for (int i = 0; i < allParkings.length; i++) {
      print(
        '${i + 1}. Vehicle: ${allParkings[i].vehicle.id} '
        '- Parking Space: ${allParkings[i].parkingSpace.adress} '
        '- Start: ${allParkings[i].startTime} '
        '- End: ${allParkings[i].endTime ?? 'Ongoing'}',
      );
    }

    print('Pick an index to update: ');
    final input = stdin.readLineSync();

    if (Validator.isIndex(input, allParkings)) {
      final index = int.parse(input!) - 1;
      final parking = allParkings[index];

      print('Enter new end time (yyyy-MM-ddTHH:mm:ss): ');
      final endTime = stdin.readLineSync();

      if (Validator.isDateTime(endTime)) {
        parking.endTime = DateTime.parse(endTime!);
        await repository.update(parking.id, parking);
        print('✅ Parking updated');
      } else {
        print('Invalid date format');
      }
    } else {
      print('Invalid index');
    }
  }

  static Future delete() async {
    final allParkings = await repository.getAll();
    for (int i = 0; i < allParkings.length; i++) {
      print(
        '${i + 1}. Vehicle: ${allParkings[i].vehicle.id} '
        '- Parking Space: ${allParkings[i].parkingSpace.adress} '
        '- Start: ${allParkings[i].startTime} '
        '- End: ${allParkings[i].endTime ?? 'Ongoing'}',
      );
    }

    print('Pick an index to delete: ');
    final input = stdin.readLineSync();

    if (Validator.isIndex(input, allParkings)) {
      final index = int.parse(input!) - 1;
      await repository.delete(allParkings[index].id);
      print('🗑️ Parking deleted');
    } else {
      print('Invalid index');
    }
  }
}
