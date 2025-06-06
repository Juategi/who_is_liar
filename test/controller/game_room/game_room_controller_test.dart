import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:who_is_liar/controller/game_room/game_room_controller.dart';
import 'package:who_is_liar/model/game_room_model.dart';
import 'package:who_is_liar/model/name_model.dart';
import 'package:who_is_liar/controller/game_room/game_room_state.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:mockito/annotations.dart';

import 'game_room_controller_test.mocks.dart';

@GenerateMocks([GameRoomModel, NameModel, DatabaseEvent, DataSnapshot])
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

  test('createRoom calls createRoom and _listenRoom', () async {
    when(mockGameRoomModel.createRoom()).thenAnswer((_) async => 'ROOM123');
    when(mockGameRoomModel.listenRoom('ROOM123'))
        .thenAnswer((_) => const Stream.empty());
    await controller.createRoom();
    verify(mockGameRoomModel.createRoom()).called(1);
  });

  test('joinRoom emits error if room does not exist', () async {
    when(mockGameRoomModel.joinRoom('CODE')).thenAnswer((_) async => false);
    expectLater(
      controller.stream,
      emits(isA<GameRoomError>()),
    );
    await controller.joinRoom('CODE');
  });

  test('joinRoom emits error on exception', () async {
    when(mockGameRoomModel.joinRoom('CODE')).thenThrow(Exception('fail'));
    expectLater(
      controller.stream,
      emits(isA<GameRoomError>()),
    );
    await controller.joinRoom('CODE');
  });

  test('isHost returns false if not RoomLoaded', () {
    expect(controller.isHost(), false);
  });

  test('isImpostor returns false if not RoomLoaded', () {
    expect(controller.isImpostor(), false);
  });

  test('getCurrentPlayer returns null if not RoomLoaded', () {
    expect(controller.getCurrentPlayer(null), null);
  });

  test('getImpostorName returns empty if not RoomLoaded', () {
    expect(controller.getImpostorName(null), '');
  });

  test('getTotalVotes returns 0 if not RoomLoaded', () {
    expect(controller.getTotalVotes(null, 'player1'), 0);
  });

  test('loadNextQuestion emits error on exception', () async {
    when(mockGameRoomModel.loadNextQuestion('CODE'))
        .thenThrow(Exception('fail'));
    expectLater(
      controller.stream,
      emits(isA<GameRoomError>()),
    );
    await controller.loadNextQuestion('CODE');
  });

  test('sendAnswer emits error on exception', () async {
    when(mockGameRoomModel.sendAnswer('CODE', 'answer'))
        .thenThrow(Exception('fail'));
    expectLater(
      controller.stream,
      emits(isA<GameRoomError>()),
    );
    await controller.sendAnswer('CODE', 'answer');
  });

  test('sendVote emits error on exception', () async {
    when(mockGameRoomModel.sendVote('CODE', 'player2'))
        .thenThrow(Exception('fail'));
    expectLater(
      controller.stream,
      emits(isA<GameRoomError>()),
    );
    await controller.sendVote('CODE', 'player2');
  });

  test('showAnswers emits error on exception', () async {
    when(mockGameRoomModel.showAnswers('CODE')).thenThrow(Exception('fail'));
    expectLater(
      controller.stream,
      emits(isA<GameRoomError>()),
    );
    await controller.showAnswers('CODE');
  });

  test('dispose cancels subscription and resets state', () async {
    await controller.dispose();
    expect(controller.playerVoted, null);
  });
}
