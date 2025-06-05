import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:who_is_liar/controller/game_room/game_room_controller.dart';
import 'package:who_is_liar/controller/game_room/game_room_state.dart';
import 'package:who_is_liar/model/game_room_model.dart';
import 'package:who_is_liar/model/name_model.dart';
import 'package:who_is_liar/controller/game_room/game_room.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

// Mocks
class MockGameRoomModel extends Mock implements GameRoomModel {}

class MockNameModel extends Mock implements NameModel {}

class MockDatabaseEvent extends Mock implements DatabaseEvent {}

class MockDataSnapshot extends Mock implements DataSnapshot {}

void main() {
  late MockGameRoomModel mockGameRoomModel;
  late MockNameModel mockNameModel;
  late GameRoomController controller;

  setUp(() {
    mockGameRoomModel = MockGameRoomModel();
    mockNameModel = MockNameModel();
    when(mockNameModel.getId()).thenReturn('player1');
    controller = GameRoomController(mockGameRoomModel, mockNameModel);
  });

  group('GameRoomController', () {
    test('createRoom calls createRoom and _listenRoom', () async {
      when(mockGameRoomModel.createRoom()).thenAnswer((_) async => '1234');
      when(mockGameRoomModel.listenRoom('1234'))
          .thenAnswer((_) => const Stream.empty());
      await controller.createRoom();
      verify(mockGameRoomModel.createRoom()).called(1);
      verify(mockGameRoomModel.listenRoom('1234')).called(1);
    });

    test('joinRoom success calls joinRoom and _listenRoom', () async {
      when(mockGameRoomModel.joinRoom('abcd')).thenAnswer((_) async {});
      when(mockGameRoomModel.listenRoom('abcd'))
          .thenAnswer((_) => const Stream.empty());
      await controller.joinRoom('abcd');
      verify(mockGameRoomModel.joinRoom('abcd')).called(1);
      verify(mockGameRoomModel.listenRoom('abcd')).called(1);
    });

    test('joinRoom failure emits GameRoomError', () async {
      when(mockGameRoomModel.joinRoom('fail')).thenThrow(Exception('error'));
      final states = <GameRoomState>[];
      controller.stream.listen(states.add);
      await controller.joinRoom('fail');
      expect(states.last, isA<GameRoomError>());
    });

    test('sendAnswer emits GameRoomError on failure', () async {
      when(mockGameRoomModel.sendAnswer(any, any)).thenThrow(Exception('fail'));
      final states = <GameRoomState>[];
      controller.stream.listen(states.add);
      await controller.sendAnswer('code', 'answer');
      expect(states.last, isA<GameRoomError>());
    });

    test('showAnswers emits GameRoomError on failure', () async {
      when(mockGameRoomModel.showAnswers(any)).thenThrow(Exception('fail'));
      final states = <GameRoomState>[];
      controller.stream.listen(states.add);
      await controller.showAnswers('code');
      expect(states.last, isA<GameRoomError>());
    });

    test('loadNextQuestion emits GameRoomError on failure', () async {
      when(mockGameRoomModel.loadNextQuestion(any))
          .thenThrow(Exception('fail'));
      final states = <GameRoomState>[];
      controller.stream.listen(states.add);
      await controller.loadNextQuestion('code');
      expect(states.last, isA<GameRoomError>());
    });

    test('dispose cancels subscription and calls leaveGame', () async {
      final mockSubscription = MockStreamSubscription();
      controller.emit(WaitingRoomLoaded(
          code: 'room',
          gameRoom: GameRoom(players: [], impostor: '', show: false)));
      controller._subscription = mockSubscription;
      controller.dispose();
      verify(mockSubscription.cancel()).called(1);
      verify(mockGameRoomModel.leaveGame('room')).called(1);
    });

    test('isHost returns false if not RoomLoaded', () {
      expect(controller.isHost(), false);
    });

    test('isImpostor returns false if not RoomLoaded', () {
      expect(controller.isImpostor(), false);
    });

    test('getCurrentPlayer returns null if gameRoom is null', () {
      expect(controller.getCurrentPlayer(null), null);
    });
  });
}

// Helper mock for StreamSubscription
class MockStreamSubscription extends Mock
    implements StreamSubscription<DatabaseEvent> {}
