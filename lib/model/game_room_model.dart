import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math' as math;
import 'package:who_is_liar/model/name_model.dart';

class GameRoomModel {
  final database = FirebaseDatabase.instance;
  final NameModel nameModel = NameModel();

  Future<String> createRoom() async {
    final String code = _randomCode();
    final String name = await nameModel.getName();
    database.ref('nodes/$code').set({
      'status': false,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
    database.ref('nodes/$code/$name').set({
      'name': name,
    });
    return code;
  }

  Stream<DatabaseEvent> listenRoom(String code) {
    Stream<DatabaseEvent> stream = database.ref('nodes/$code').onValue;
    /*
    stream.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      print("Datos actualizados: $data");
    });
    */
    return stream;
  }

  String _randomCode() {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = StringBuffer();
    for (int i = 0; i < 5; i++) {
      random.write(
          characters[(characters.length * math.Random().nextDouble()).floor()]);
    }
    return random.toString();
  }
}
