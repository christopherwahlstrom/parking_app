import 'package:cli/cli_operations/parking_space_operations.dart';
import 'package:cli/utils/console.dart';

class ParkingSpaceMenu {
  static Future prompt() async {
    Console.clear();
    while (true) {
      print('Parking Space Menu');
      print('1. Create Parking Space');
      print('2. List all Parking Spaces');
      print('3. Update Parking Space');
      print('4. Delete Parking Space');
      print('5. Back to Main Menu');

      var input = Console.choice();

      switch (input) {
        case 1:
          print('Creating Parking Space');
          await ParkingSpaceOperations.create();
          break;
        case 2:
          print('Listing all Parking Spaces');
          await ParkingSpaceOperations.list();
          break;
        case 3:
          print('Updating Parking Space');
          await ParkingSpaceOperations.update();
          break;
        case 4:
          print('Deleting Parking Space');
          await ParkingSpaceOperations.delete();
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