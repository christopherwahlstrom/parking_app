import 'dart:io';

import 'package:cli/menus/persons_menu.dart';
import 'package:cli/menus/vehicles_menu.dart';
import 'package:cli/menus/parking_space_menu.dart';
import 'package:cli/menus/parking_menu.dart';
import 'package:cli/utils/console.dart';

class MainMenu {
  static Future prompt() async {
    Console.clear();
    while (true) {
      print('Main Menu');
      print('1. Person Menu');
      print('2. Vehicle Menu');
      print('3. Parking Space Menu');
      print('4. Parking Menu');
      print('5. Exit');

      var input = Console.choice();

      switch (input) {
        case 1:
          await PersonsMenu.prompt();
          break;
        case 2:
          await VehiclesMenu.prompt();
          break;
        case 3:
          await ParkingSpaceMenu.prompt();
          break;
        case 4:
          await ParkingMenu.prompt();
          break;
        case 5:
          exit(0);
        default:
          print('Invalid choice');
      }
      print("\n------------------------------------\n");
    }
  }
}