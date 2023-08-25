import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OnlineStatusService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateOnlineStatus(bool isOnline) async {
    print(isOnline);
    final user = _auth.currentUser;
      if (user != null) {
        final userRef = _firestore.collection('users').doc(user.uid);
        await userRef.update({'isOnline': '$isOnline'});
    }
  }

  Stream<String> onlineStatusStream() {
    final user = _auth.currentUser;
    if (user != null) {
      final userRef = _firestore.collection('users').doc(user.uid);
      return userRef.snapshots().map((snapshot) {
        return snapshot.data()?['isOnline'] ?? false;
      });
    } else {
      return Stream<String>.value('false');
    }
  }
}
