import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:who_is_liar/model/game_room_model.dart';
import 'package:who_is_liar/model/name_model.dart';
import 'dart:async';

// Mocks
class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}

class MockDatabaseReference extends Mock implements DatabaseReference {}

class MockDatabaseEvent extends Mock implements DatabaseEvent {}

class MockDataSnapshot extends Mock implements DataSnapshot {}

class MockNameModel extends Mock implements NameModel {}

void main() {
  late GameRoomModel gameRoomModel;
  late MockFirebaseDatabase mockDatabase;
  late MockDatabaseReference mockRef;
  late MockNameModel mockNameModel;
  late GetIt getIt;

  setUp(() {
    mockDatabase = MockFirebaseDatabase();
    mockRef = MockDatabaseReference();
    mockNameModel = MockNameModel();
    getIt = GetIt.instance;
    getIt.reset();
    getIt.registerSingleton<NameModel>(mockNameModel);

    when(mockDatabase.ref(any)).thenReturn(mockRef);
    when(mockNameModel.getId()).thenReturn('testId');
    when(mockNameModel.getName()).thenReturn('testName');

    gameRoomModel = GameRoomModel();
    gameRoomModel.database = mockDatabase;
  });

  group('GameRoomModel', () {
    test('createRoom creates a room and adds host player', () async {
      when(mockRef.set(any)).thenAnswer((_) async => {});
      final code = await gameRoomModel.createRoom();
      expect(code, isA<String>());
      verify(mockRef.set(any)).called(2);
    });

    test('joinRoom throws if room is full', () async {
      final mockEvent = MockDatabaseEvent();
      final mockSnapshot = MockDataSnapshot();
      when(mockRef.once()).thenAnswer((_) async => mockEvent);
      when(mockEvent.snapshot).thenReturn(mockSnapshot);
      when(mockSnapshot.value).thenReturn({
        '1': {},
        '2': {},
        '3': {},
        '4': {},
        '5': {},
        '6': {},
        '7': {},
        '8': {}
      });
      expect(() => gameRoomModel.joinRoom('code'), throwsException);
    });

    test('joinRoom adds player if room is not full', () async {
      final mockEvent = MockDatabaseEvent();
      final mockSnapshot = MockDataSnapshot();
      when(mockRef.once()).thenAnswer((_) async => mockEvent);
      when(mockEvent.snapshot).thenReturn(mockSnapshot);
      when(mockSnapshot.value).thenReturn({'1': {}, '2': {}});
      when(mockRef.set(any)).thenAnswer((_) async => {});
      await gameRoomModel.joinRoom('code');
      verify(mockRef.set(any)).called(1);
    });

    test('listenRoom returns a stream', () {
      final streamController = StreamController<DatabaseEvent>();
      when(mockRef.onValue).thenAnswer((_) => streamController.stream);
      final stream = gameRoomModel.listenRoom('code');
      expect(stream, isA<Stream<DatabaseEvent>>());
      streamController.close();
    });

    test('sendAnswer updates player answer', () async {
      when(mockRef.update(any)).thenAnswer((_) async => {});
      await gameRoomModel.sendAnswer('code', 'answer');
      verify(mockRef.update({'answer': 'answer'})).called(1);
    });

    test('showAnswers updates show to true', () async {
      when(mockRef.update(any)).thenAnswer((_) async => {});
      await gameRoomModel.showAnswers('code');
      verify(mockRef.update({'show': true})).called(1);
    });

    test('leaveGame removes player and deletes room if last', () async {
      when(mockRef.remove()).thenAnswer((_) async => {});
      when(mockRef.once()).thenAnswer((_) async {
        final mockEvent = MockDatabaseEvent();
        final mockSnapshot = MockDataSnapshot();
        when(mockEvent.snapshot).thenReturn(mockSnapshot);
        when(mockSnapshot.value).thenReturn(null);
        return mockEvent;
      });
      await gameRoomModel.leaveGame('code');
      verify(mockRef.remove()).called(greaterThanOrEqualTo(1));
    });

    test('_isLastPlayer returns true if no players', () async {
      final mockEvent = MockDatabaseEvent();
      final mockSnapshot = MockDataSnapshot();
      when(mockRef.once()).thenAnswer((_) async => mockEvent);
      when(mockEvent.snapshot).thenReturn(mockSnapshot);
      when(mockSnapshot.value).thenReturn(null);
      final result = await gameRoomModel._isLastPlayer('code');
      expect(result, true);
    });

    test('_isLastPlayer returns false if players exist', () async {
      final mockEvent = MockDatabaseEvent();
      final mockSnapshot = MockDataSnapshot();
      when(mockRef.once()).thenAnswer((_) async => mockEvent);
      when(mockEvent.snapshot).thenReturn(mockSnapshot);
      when(mockSnapshot.value).thenReturn({'1': {}});
      final result = await gameRoomModel._isLastPlayer('code');
      expect(result, false);
    });
  });
}
