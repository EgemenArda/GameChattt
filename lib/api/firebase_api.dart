import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:game_chat_1/screens/notifications_page.dart';

import '../main.dart';

/// background notification parser
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title:${message.notification?.title}');
  print('Body:${message.notification?.body}');
  print('Payload:${message.data}');
}

void handleMessage(RemoteMessage? message) {
  if (message == null) return;
  navigatorKey.currentState?.pushNamed(
    NotificationsScreen.route,
    arguments: message,
  );
}

/// notifications setting
Future initPushNotifications() async {
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
}

/// firebase request permission and create token
class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final user = FirebaseAuth.instance.currentUser;
  final CollectionReference roomsCollection =
      FirebaseFirestore.instance.collection('rooms');

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    initPushNotifications();
    if (user != null) {
      FirebaseFirestore.instance.collection('users').doc(user?.uid).update(
        {'fcmToken': fcmToken},
      );
    }
    print(fcmToken);
  }
}
