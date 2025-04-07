import 'package:cli/cli_operations/persons_operations.dart';
import 'package:cli/utils/console.dart';

class PersonsMenu {
  static Future prompt() async {
    Console.clear();
    while (true) {
      print('Person Menu');
      print('1. Create Person');
      print('2. List all Persons');
      print('3. Update Person');
      print('4. Delete Person');
      print('5. Back to Main Menu');

      var input = Console.choice();

      switch (input) {
        case 1:
          print('Creating Person');
          await PersonsOperations.create();
        case 2:
          print('Listing all Persons');
          await PersonsOperations.list();
        case 3:
          print('Updating Person');
          await PersonsOperations.update();
        case 4:
          print('Deleting Person');
          await PersonsOperations.delete();
        case 5:
          return;
        default:
          print('Invalid choice');
      }
      print("\n------------------------------------\n");
    }
  }


}
