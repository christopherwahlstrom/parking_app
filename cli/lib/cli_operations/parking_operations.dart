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
    print('Enter vehicle registreringsnummer: ');
    var registreringsnummer = stdin.readLineSync();

    print('Enter parking space address: ');
    var adress = stdin.readLineSync();

    if (Validator.isString(registreringsnummer) && Validator.isString(adress)) {
      List<Vehicle> allVehicles = await vehicleRepository.getAll();
      Vehicle? vehicle;
      try {
        vehicle = allVehicles.firstWhere((v) => v.registreringsnummer == registreringsnummer);
      } catch (e) {
        vehicle = null;
      }

      if (vehicle == null) {
        print('Vehicle not found. Please create the vehicle first.');
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
        fordon: vehicle,
        parkeringsplats: parkingSpace,
        starttid: DateTime.now(),
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
      print('${i + 1}. ${allParkings[i].fordon.registreringsnummer} - ${allParkings[i].parkeringsplats.adress} - Start: ${allParkings[i].starttid} - End: ${allParkings[i].sluttid ?? 'Ongoing'}');
    }
  }

  static Future update() async {
    print('Pick an index to update: ');
    List<Parking> allParkings = await repository.getAll();
    for (int i = 0; i < allParkings.length; i++) {
      print('${i + 1}. ${allParkings[i].fordon.registreringsnummer} - ${allParkings[i].parkeringsplats.adress} - Start: ${allParkings[i].starttid} - End: ${allParkings[i].sluttid ?? 'Ongoing'}');
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
      print('${i + 1}. ${allParkings[i].fordon.registreringsnummer} - ${allParkings[i].parkeringsplats.adress} - Start: ${allParkings[i].starttid} - End: ${allParkings[i].sluttid ?? 'Ongoing'}');
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