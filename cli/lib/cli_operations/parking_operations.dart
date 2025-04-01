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
  print('Enter vehicle registrationNumber: ');
  var registrationNumber = stdin.readLineSync();

  print('Enter parking space address: ');
  var adress = stdin.readLineSync();

  if (Validator.isString(registrationNumber) && Validator.isString(adress)) {
    // Hämta fordon
    List<Vehicle> allVehicles = await vehicleRepository.getAll();
    Vehicle? vehicle;
    try {
      vehicle = allVehicles.firstWhere((v) => v.registrationNumber == registrationNumber);
    } catch (e) {
      vehicle = null;
    }

    if (vehicle == null) {
      print('Vehicle not found. Please create the vehicle first.');
      return;
    }

    
    if (vehicle.ownerId == null || vehicle.ownerId!.isEmpty) {
      print('Vehicle does not have an owner. Please assign an owner first.');
      return;
    }

    List<ParkingSpace> allParkingSpaces = await parkingSpaceRepository.getAll();
    ParkingSpace? parkingSpace;
    try {
      parkingSpace = allParkingSpaces.firstWhere((p) => p.adress == adress);
    } catch (e) {
      parkingSpace = null;
    }

    if (parkingSpace == null) {
      print('Parking space not found. Please create the parking space first.');
      return;
    }

    
    Parking parking = Parking(
      id: '', 
      personId: vehicle.ownerId,
      vehicleId: vehicle.id,
      parkingSpaceId: parkingSpace.id,
      starttid: DateTime.now(),
      sluttid: null,
    );

    await repository.create(parking);
    print('Parking created');
  } else {
    print('Invalid input');
  }
}

  static Future list() async {
    List<Parking> allParkings = await repository.getAll();
    for (int i = 0; i < allParkings.length; i++) {
      print(
        '${i + 1}. Vehicle: ${allParkings[i].vehicleId} - Parking Space: ${allParkings[i].parkingSpaceId} - Start: ${allParkings[i].starttid} - End: ${allParkings[i].sluttid ?? 'Ongoing'}',
      );
    }
  }

  static Future update() async {
    print('Pick an index to update: ');
    List<Parking> allParkings = await repository.getAll();
    for (int i = 0; i < allParkings.length; i++) {
      print(
        '${i + 1}. Vehicle: ${allParkings[i].vehicleId} - Parking Space: ${allParkings[i].parkingSpaceId} - Start: ${allParkings[i].starttid} - End: ${allParkings[i].sluttid ?? 'Ongoing'}',
      );
    }

    String? input = stdin.readLineSync();

    if (Validator.isIndex(input, allParkings)) {
      int index = int.parse(input!) - 1;
      Parking parking = allParkings[index];

      print('Enter new end time (yyyy-MM-ddTHH:mm:ss): ');
      var endTime = stdin.readLineSync();

      if (Validator.isDateTime(endTime)) {
        parking.sluttid = DateTime.parse(endTime!);

        await repository.update(parking.id, parking);
        print('Parking updated');
      } else {
        print('Invalid input');
      }
    } else {
      print('Invalid input');
    }
  }

  static Future delete() async {
    print('Pick an index to delete: ');
    List<Parking> allParkings = await repository.getAll();
    for (int i = 0; i < allParkings.length; i++) {
      print(
        '${i + 1}. Vehicle: ${allParkings[i].vehicleId} - Parking Space: ${allParkings[i].parkingSpaceId} - Start: ${allParkings[i].starttid} - End: ${allParkings[i].sluttid ?? 'Ongoing'}',
      );
    }

    String? input = stdin.readLineSync();

    if (Validator.isIndex(input, allParkings)) {
      int index = int.parse(input!) - 1;
      await repository.delete(allParkings[index].id);
      print('Parking deleted');
    } else {
      print('Invalid input');
    }
  }
}