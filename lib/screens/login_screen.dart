import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/screens/register_screen.dart';
import 'package:game_chat_1/screens/widgets/custom_alert_dialog.dart';
import 'package:game_chat_1/services/connection_check.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../services/status_service.dart';

final _firebase = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ConnectionCheck(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Consumer<AuthProvider>(
          builder: (context, provider, child) {
            return Center(
              child: SingleChildScrollView(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                  Image.asset('assets/images/background.jpg',
                      fit: BoxFit.cover),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.0),
                          borderRadius: BorderRadius.circular(40),
                          // border: Border.all(color: Colors.purpleAccent),
                          ////Circuler Border with color
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Form(
                              key: provider.formKeyLogin,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      // icon: Icon(Icons.email_outlined),
                                      labelText: 'Email Address',
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    controller: emailController,
                                    autocorrect: false,
                                    textCapitalization: TextCapitalization.none,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                              .hasMatch(value)) {
                                        //allow upper and lower case alphabets and space
                                        return "Please enter a valid Email address";
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (value) {
                                      provider.enteredEmail = value!;
                                    },
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      // icon: Icon(Icons.lock_outline),
                                      labelText: 'Password',
                                    ),
                                    controller: passController,
                                    obscureText: true,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().length < 6 ||
                                          value.trim().length > 20) {
                                        return 'Password must be between 6-20 characters';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      provider.enteredPassword = value!;
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  if (provider.isAuthenticating)
                                    const CircularProgressIndicator(),
                                  if (!provider.isAuthenticating)
                                    ElevatedButton(
                                      onPressed: () {
                                        if (emailController.text.isEmpty ||
                                            passController.text.isEmpty) {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) =>
                                                const CustomAlertDialog(
                                                    title: 'Login error!',
                                                    content:
                                                        'Please dont leave files empty'),
                                          );
                                        } else {
                                          provider.login(context);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer),
                                      child: const Text("Login"),
                                    ),
                                  if (!provider.isAuthenticating)
                                    const SizedBox(
                                      height: 8,
                                    ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer),
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  const AuthScreen()));
                                    },
                                    child: const Text(
                                      "Create an account",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ]),
              ),
            );
          },
        ),
      ),
    );
  }
}
