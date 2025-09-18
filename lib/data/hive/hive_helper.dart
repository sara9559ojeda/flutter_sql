import 'package:hive_flutter/hive_flutter.dart';

class HiveHelper {
  static Box? _box;

  static Future<void> initHive() async {
    // Usar Hive de hive_flutter
    if (!Hive.isBoxOpen('remindersBox')) {
      _box = await Hive.openBox('remindersBox');
    } else {
      _box = Hive.box('remindersBox');
    }
  }

  static Box get box => _box!;

  static void addReminder(Map<String, dynamic> reminder) {
    _box?.add(reminder);
  }

  static List<Map<String, dynamic>> getReminders() {
    return _box!.values
        .cast<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  static void updateReminder(int index, Map<String, dynamic> reminder) {
    _box?.putAt(index, reminder);
  }

  static void deleteReminder(int index) {
    _box?.deleteAt(index);
  }
}
