import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/providers/auth_provider.dart';
import 'package:game_chat_1/providers/create_room_provider.dart';
import 'package:game_chat_1/providers/game_room_provider.dart';
import 'package:game_chat_1/providers/homepage_provider.dart';
import 'package:game_chat_1/screens/home_screen.dart';
import 'package:game_chat_1/screens/login_screen.dart';
import 'package:game_chat_1/screens/splash_screen.dart';
import 'package:game_chat_1/screens/widgets/internet_connection_failed.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<HomePageProvider>(create: (_) => HomePageProvider()),
        ListenableProvider<AuthProvider>(create: (_) => AuthProvider()),
        ListenableProvider<CreateRoomProvider>(
          create: (_) => CreateRoomProvider(),
        ),
        ListenableProvider<GameRoomProvider>(create: (_) => GameRoomProvider()),
      ],
      child: StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, connectivitySnapshot) {
          var connectivityResult = connectivitySnapshot.data;
          var hasConnectivity = connectivityResult != ConnectivityResult.none;

          Widget content;

          if (!hasConnectivity) {
            content = const InternetConnectionFailed();
          } else {
            content = StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, authSnapshot) {
                if (connectivitySnapshot.connectionState ==
                        ConnectionState.waiting ||
                    authSnapshot.connectionState == ConnectionState.waiting) {
                  return const SplashScreen();
                }

                if (authSnapshot.hasData) {
                  content = const HomeScreen();
                } else {
                  content = const LoginScreen();
                }

                return content;
              },
            );
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Game Chat',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: content,
          );
        },
      ),
    );
  }
}
