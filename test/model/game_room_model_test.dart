import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:who_is_liar/controller/game_room/game_room.dart';
import 'package:who_is_liar/model/game_room_model.dart';
import 'package:who_is_liar/model/name_model.dart';

import 'package:mockito/annotations.dart';

import 'game_room_model_test.mocks.dart';

// Generate mocks for the following classes
@GenerateMocks([
  FirebaseDatabase,
  DatabaseReference,
  DatabaseEvent,
  DataSnapshot,
  NameModel,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockFirebaseDatabase mockDatabase;
  late MockDatabaseReference mockRef;
  late MockDatabaseReference mockPlayersRef;
  late MockDatabaseEvent mockEvent;
  late MockDataSnapshot mockSnapshot;
  late MockNameModel mockNameModel;
  late GameRoomModel gameRoomModel;

  setUp(() {
    mockDatabase = MockFirebaseDatabase();
    mockRef = MockDatabaseReference();
    mockPlayersRef = MockDatabaseReference();
    mockEvent = MockDatabaseEvent();
    mockSnapshot = MockDataSnapshot();
    mockNameModel = MockNameModel();

    // Register NameModel in GetIt
    GetIt.I.reset();
    GetIt.I.registerSingleton<NameModel>(mockNameModel);

    when(mockDatabase.ref(any)).thenReturn(mockRef);
    when(mockRef.set(any)).thenAnswer((_) async {});
    when(mockRef.update(any)).thenAnswer((_) async {});
    when(mockRef.once()).thenAnswer((_) async => mockEvent);
    when(mockEvent.snapshot).thenReturn(mockSnapshot);

    gameRoomModel = GameRoomModel(mockDatabase);
    gameRoomModel.questions = [
      Question(id: 1, originalQuestion: 'Q1', impostorQuestion: 'IQ1'),
      Question(id: 2, originalQuestion: 'Q2', impostorQuestion: 'IQ2'),
    ];
    // Override the database instance
    gameRoomModel = GameRoomModel(mockDatabase);
    gameRoomModel.questions = [
      Question(id: 1, originalQuestion: 'Q1', impostorQuestion: 'IQ1'),
      Question(id: 2, originalQuestion: 'Q2', impostorQuestion: 'IQ2'),
    ];
  });

  test('createRoom creates a room and adds host player', () async {
    when(mockNameModel.getId()).thenReturn('hostId');
    when(mockNameModel.getName()).thenReturn('Host');
    final code = await gameRoomModel.createRoom();
    expect(code, isNotNull);
    verify(mockDatabase.ref('nodes/$code')).called(1);
    verify(mockDatabase.ref('nodes/$code/players/hostId')).called(1);
  });

  test('joinRoom returns false if room does not exist', () async {
    when(mockNameModel.getId()).thenReturn('playerId');
    when(mockRef.once()).thenAnswer((_) async {
      final event = MockDatabaseEvent();
      final snap = MockDataSnapshot();
      when(event.snapshot).thenReturn(snap);
      when(snap.value).thenReturn(null);
      return event;
    });
    final result = await gameRoomModel.joinRoom('ABCDE');
    expect(result, isFalse);
  });

  test('joinRoom throws if room is full', () async {
    when(mockNameModel.getId()).thenReturn('playerId');
    when(mockRef.once()).thenAnswer((_) async {
      final event = MockDatabaseEvent();
      final snap = MockDataSnapshot();
      when(event.snapshot).thenReturn(snap);
      when(snap.value).thenReturn({'createdAt': 123});
      return event;
    });
    when(mockDatabase.ref('nodes/ABCDE/players')).thenReturn(mockPlayersRef);
    when(mockPlayersRef.once()).thenAnswer((_) async {
      final event = MockDatabaseEvent();
      final snap = MockDataSnapshot();
      when(event.snapshot).thenReturn(snap);
      when(snap.value).thenReturn(Map.fromIterable(List.generate(8, (i) => i)));
      return event;
    });
    expect(() => gameRoomModel.joinRoom('ABCDE'), throwsException);
  });

  test('joinRoom adds player if room is not full', () async {
    when(mockNameModel.getId()).thenReturn('playerId');
    when(mockNameModel.getName()).thenReturn('Player');
    when(mockRef.once()).thenAnswer((_) async {
      final event = MockDatabaseEvent();
      final snap = MockDataSnapshot();
      when(event.snapshot).thenReturn(snap);
      when(snap.value).thenReturn({'createdAt': 123});
      return event;
    });
    when(mockDatabase.ref('nodes/ABCDE/players')).thenReturn(mockPlayersRef);
    when(mockPlayersRef.once()).thenAnswer((_) async {
      final event = MockDatabaseEvent();
      final snap = MockDataSnapshot();
      when(event.snapshot).thenReturn(snap);
      when(snap.value).thenReturn({});
      return event;
    });
    final result = await gameRoomModel.joinRoom('ABCDE');
    expect(result, isTrue);
    verify(mockDatabase.ref('nodes/ABCDE/players/playerId')).called(1);
  });

  test('sendAnswer updates player answer', () async {
    when(mockNameModel.getId()).thenReturn('playerId');
    await gameRoomModel.sendAnswer('ABCDE', 'My answer');
    verify(mockDatabase.ref('nodes/ABCDE/players/playerId')).called(1);
  });

  test('showAnswers updates show to true', () async {
    await gameRoomModel.showAnswers('ABCDE');
    verify(mockDatabase.ref('nodes/ABCDE')).called(1);
  });

  test('sendVote updates player vote', () async {
    when(mockNameModel.getId()).thenReturn('playerId');
    await gameRoomModel.sendVote('ABCDE', 'targetId');
    verify(mockDatabase.ref('nodes/ABCDE/players/playerId')).called(1);
  });

  test('leaveGame removes player and deletes room if last', () async {
    when(mockNameModel.getId()).thenReturn('playerId');
    when(mockDatabase.ref('nodes/ABCDE/players')).thenReturn(mockPlayersRef);
    when(mockPlayersRef.once()).thenAnswer((_) async {
      final event = MockDatabaseEvent();
      final snap = MockDataSnapshot();
      when(event.snapshot).thenReturn(snap);
      when(snap.value).thenReturn(null);
      return event;
    });
    await gameRoomModel.leaveGame('ABCDE');
    verify(mockDatabase.ref('nodes/ABCDE/players/playerId')).called(1);
    verify(mockDatabase.ref('nodes/ABCDE')).called(1);
  });

  test('leaveGame removes player and does not delete room if not last',
      () async {
    when(mockNameModel.getId()).thenReturn('playerId');
    when(mockDatabase.ref('nodes/ABCDE/players')).thenReturn(mockPlayersRef);
    when(mockPlayersRef.once()).thenAnswer((_) async {
      final event = MockDatabaseEvent();
      final snap = MockDataSnapshot();
      when(event.snapshot).thenReturn(snap);
      when(snap.value).thenReturn({'other': {}});
      return event;
    });
    await gameRoomModel.leaveGame('ABCDE');
    verify(mockDatabase.ref('nodes/ABCDE/players/playerId')).called(1);
    verifyNever(mockDatabase.ref('nodes/ABCDE'));
  });
}
