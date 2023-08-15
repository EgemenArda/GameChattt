import 'package:cloud_firestore/cloud_firestore.dart';

class Rooms {
  String gameName;
  String roomCreator;
  String roomDescription;
  String roomName;
  int roomSize;

  Rooms({
    required this.gameName,
    required this.roomCreator,
    required this.roomDescription,
    required this.roomName,
    required this.roomSize,
  });

  factory Rooms.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Rooms(
      gameName: data?['game_name'],
      roomCreator: data?['room_creator'],
      roomDescription: data?['room_description'],
      roomName: data?['room_name'],
      roomSize: data?['room_size'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "game_name": gameName,
      "room_creator": roomCreator,
      "room_description": roomDescription,
      "room_name": roomName,
      "room_size": roomSize,
    };
  }
}
