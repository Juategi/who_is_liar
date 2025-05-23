import 'package:shared_preferences/shared_preferences.dart';

class NameModel {
  late SharedPreferences prefs;
  final String nameKey = 'NAME';

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  String getName() {
    String? value = prefs.getString(nameKey);
    if (value != null) {
      return value;
    } else {
      return '';
    }
  }

  Future<void> setName(String newValue) async {
    await prefs.setString(nameKey, newValue);
  }
}
