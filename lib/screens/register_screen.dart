import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/screens/widgets/custom_alert_dialog.dart';
import 'package:game_chat_1/screens/widgets/custom_elevated_buton.dart';
import 'package:game_chat_1/services/connection_check.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'login_screen.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    void registerControl() {
      if (Provider.of<AuthProvider>(context, listen: false)
          .formKeyRegister
          .currentState!
          .validate()) {
        Provider.of<AuthProvider>(context, listen: false).register(context);
      } else {
        showDialog(
          context: context,
          builder: (ctx) => const CustomAlertDialog(
            title: 'Registration error!',
            content: 'Please fill the fields according to the rules!',
          ),
        );
      }
    }

    return ConnectionCheck(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Consumer<AuthProvider>(
          builder: (context, provider, child) {
            return Stack(
              children: [
                Image.asset('assets/images/background.jpg', fit: BoxFit.cover),
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.0),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Form(
                                key: provider.formKeyRegister,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Email Address',
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      autocorrect: false,
                                      textCapitalization:
                                          TextCapitalization.none,
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
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().length < 3 ||
                                            value.trim().length > 16 ||
                                            !RegExp(r"^[A-Za-z][A-Za-z0-9_]{2,16}$")
                                                .hasMatch(value)) {
                                          return '3-16 Characters / Only special character is => _';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        labelText: "Username",
                                      ),
                                      enableSuggestions: false,
                                      onSaved: (value) {
                                        provider.enteredUsername = value!;
                                      },
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Password',
                                      ),
                                      obscureText: true,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().length <= 6 ||
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
                                      CustomElevatedButton(
                                        onPressed: () => registerControl(),
                                        title: ('Sing up'),
                                      ),
                                    if (!provider.isAuthenticating)
                                      SizedBox(
                                        height: 8,
                                      ),
                                    CustomElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (ctx) =>
                                                    const LoginScreen()));
                                      },
                                      title: "I already have an account.",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
