import 'package:shared_preferences/shared_preferences.dart';
import 'package:who_is_liar/utils/code_utils.dart';

class NameModel {
  late SharedPreferences prefs;
  final String nameKey = 'NAME';
  late final String id;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    id = CodeUtils.generateRandomId(10);
  }

  String getName() {
    String? value = prefs.getString(nameKey);
    if (value != null) {
      return value;
    } else {
      return '';
    }
  }

  String getId() {
    return id;
  }

  Future<void> setName(String newValue) async {
    await prefs.setString(nameKey, newValue);
  }
}
