import 'package:shared_preferences/shared_preferences.dart';

class NameModel {
  late SharedPreferences prefs;
  final String nameKey = 'NAME';

  Future<String> getName() async {
    prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(nameKey);
    if (value != null) {
      return value;
    } else {
      return '';
    }
  }

  Future<void> setName(String newValue) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString(nameKey, newValue);
  }
}
