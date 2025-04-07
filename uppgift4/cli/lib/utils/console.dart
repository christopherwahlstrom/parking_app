import 'dart:io';

class Console {
  static void clear() {
    stdout.write('\x1B[2J\x1B[0;0H');
  }

  static int? choice() {
    print('Enter choice: ');
    var choice = int.tryParse(stdin.readLineSync() ?? "foobar");
    return choice;
  }
}
