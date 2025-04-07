import 'package:cli/cli_operations/parking_operations.dart';
import 'package:cli/utils/console.dart';

class ParkingMenu {
  static Future prompt() async {
    Console.clear();
    while (true) {
      print('Parking Menu');
      print('1. Create Parking');
      print('2. List all Parkings');
      print('3. Update Parking');
      print('4. Delete Parking');
      print('5. Back to Main Menu');

      var input = Console.choice();

      switch (input) {
        case 1:
          print('Creating Parking');
          await ParkingOperations.create();
          break;
        case 2:
          print('Listing all Parkings');
          await ParkingOperations.list();
          break;
        case 3:
          print('Updating Parking');
          await ParkingOperations.update();
          break;
        case 4:
          print('Deleting Parking');
          await ParkingOperations.delete();
          break;
        case 5:
          return;
        default:
          print('Invalid choice');
      }
      print("\n------------------------------------\n");
    }
  }
}