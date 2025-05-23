import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'dart:math' as math;
import 'package:who_is_liar/model/name_model.dart';

class GameRoomModel {
  final database = FirebaseDatabase.instance;
  final NameModel nameModel = GetIt.instance.get<NameModel>();

  Future<String> createRoom() async {
    final String code = _randomCode();
    final String name = nameModel.getName();
    await database.ref('nodes/$code').set({
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
    database.ref('nodes/$code/players/$name').set({
      'name': name,
      'isHost': true,
    });
    return code;
  }

  Future<void> joinRoom(String code) async {
    final String name = nameModel.getName();
    database.ref('nodes/$code/players/$name').set({
      'name': name,
      'isHost': false,
    });
  }

  Stream<DatabaseEvent> listenRoom(String code) {
    Stream<DatabaseEvent> stream = database.ref('nodes/$code').onValue;
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
