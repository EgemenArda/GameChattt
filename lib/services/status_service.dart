import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OnlineStatusService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kullanıcının durumunu Firestore'a güncelleyen fonksiyon
  Future<void> updateOnlineStatus(bool isOnline) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userRef = _firestore.collection('users').doc(user.uid);
        userRef.set({'isOnline': isOnline});
      }
    } catch (error) {
      print("Online status update error: $error");
    }
  }

  // Kullanıcının online durumunu dinleyen Stream
  Stream<bool> onlineStatusStream() {
    final user = _auth.currentUser;
    if (user != null) {
      final userRef = _firestore.collection('users').doc(user.uid);
      return userRef.snapshots().map((snapshot) {
        return snapshot.data()?['isOnline'] ?? false;
      });
    } else {
      return Stream<bool>.value(false);
    }
  }
}
