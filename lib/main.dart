import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/providers/auth_provider.dart';
import 'package:game_chat_1/providers/create_room_provider.dart';
import 'package:game_chat_1/providers/game_room_provider.dart';
import 'package:game_chat_1/providers/homepage_provider.dart';
import 'package:game_chat_1/providers/profile_proivder.dart';
import 'package:game_chat_1/screens/home_screen.dart';
import 'package:game_chat_1/screens/login_screen.dart';
import 'package:game_chat_1/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ListenableProvider<HomePageProvider>(create: (_) => HomePageProvider()),
      ListenableProvider<AuthProvider>(create: (_) => AuthProvider()),
      ListenableProvider<CreateRoomProvider>(create: (_) => CreateRoomProvider()),
      ListenableProvider<GameRoomProvider>(create: (_) => GameRoomProvider()),
      ListenableProvider<ProfileScreenProvider>(create: (_) => ProfileScreenProvider()),

    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Game Chat',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }

            if (snapshot.hasData) {
              return const HomeScreen();
            }
            return const LoginScreen();
          },
        ));
  }
}
