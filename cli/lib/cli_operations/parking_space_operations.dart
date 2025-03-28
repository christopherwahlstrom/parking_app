import 'dart:io';

import 'package:cli/repositories/parking_space_repository.dart';
import 'package:cli/utils/validator.dart';
import 'package:shared/shared.dart';

ParkingSpaceRepository repository = ParkingSpaceRepository();

class ParkingSpaceOperations {
  static Future create() async {
    print('Enter address: ');
    var adress = stdin.readLineSync();

    print('Enter price per hour: ');
    var prisPerTimme = stdin.readLineSync();

    if (Validator.isString(adress) && Validator.isDouble(prisPerTimme)) {
      ParkingSpace parkingSpace = ParkingSpace(
        adress: adress!,
        prisPerTimme: double.parse(prisPerTimme!),
      );
      await repository.create(parkingSpace);
      print('Parking space created');
    } else {
      print('Invalid input');
    }
  }

  static Future list() async {
    List<ParkingSpace> allParkingSpaces = await repository.getAll();
    for (int i = 0; i < allParkingSpaces.length; i++) {
      print('${i + 1}. ${allParkingSpaces[i].adress} - ${allParkingSpaces[i].prisPerTimme} SEK/h');
    }
  }

  static Future update() async {
    print('Pick an index to update: ');
    List<ParkingSpace> allParkingSpaces = await repository.getAll();
    for (int i = 0; i < allParkingSpaces.length; i++) {
      print('${i + 1}. ${allParkingSpaces[i].adress} - ${allParkingSpaces[i].prisPerTimme} SEK/h');
    }

    String? input = stdin.readLineSync();

    if (Validator.isIndex(input, allParkingSpaces)) {
      int index = int.parse(input!) - 1;
      ParkingSpace parkingSpace = allParkingSpaces[index];

      print('Enter new address: ');
      var adress = stdin.readLineSync();

      print('Enter new price per hour: ');
      var prisPerTimme = stdin.readLineSync();

      if (Validator.isString(adress) && Validator.isDouble(prisPerTimme)) {
        parkingSpace.adress = adress!;
        parkingSpace.prisPerTimme = double.parse(prisPerTimme!);

        await repository.update(parkingSpace.id, parkingSpace);
        print('Parking space updated');
      } else {
        print('Invalid input');
      }
    } else {
      print('Invalid input');
    }
  }

  static Future delete() async {
    print('Pick an index to delete: ');
    List<ParkingSpace> allParkingSpaces = await repository.getAll();
    for (int i = 0; i < allParkingSpaces.length; i++) {
      print('${i + 1}. ${allParkingSpaces[i].adress} - ${allParkingSpaces[i].prisPerTimme} SEK/h');
    }

    String? input = stdin.readLineSync();

    if (Validator.isIndex(input, allParkingSpaces)) {
      int index = int.parse(input!) - 1;
      await repository.delete(allParkingSpaces[index].id);
      print('Parking space deleted');
    } else {
      print('Invalid input');
    }
  }
}