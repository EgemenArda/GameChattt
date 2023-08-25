import 'package:cloud_firestore/cloud_firestore.dart';

class Dms {
  String documentId;
  String roomIdentifier;
  Dms(
      {required this.documentId, required this.roomIdentifier});

  factory Dms.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();

    return Dms(
      documentId: snapshot.id,
      roomIdentifier: data?['roomIdentifier'],
    );
  }
}
