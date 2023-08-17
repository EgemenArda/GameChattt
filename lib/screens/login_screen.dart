import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/screens/register_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Consumer<AuthProvider>(
        builder: (context, provider, child) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    margin: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: provider.formKeyLogin,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // UserImagePicker(
                              //   onPickImage: (File pickedImage) {
                              //     provider.selectedImage = pickedImage;
                              //   },
                              // ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Email Address',
                                ),
                                keyboardType: TextInputType.emailAddress,
                                controller: emailController,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                  labelText: 'Password',
                                ),
                                controller: passController,
                                obscureText: true,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                ElevatedButton(
                                  onPressed: () {
                                    if (emailController.text.isEmpty || passController.text.isEmpty) {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Login error!'),
                                          content: const Text('Please dont leave fields empty!'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.of(ctx).pop(),
                                              child: Container(
                                                color: Colors.green,
                                                padding: const EdgeInsets.all(14),
                                                child: const Text('Okay'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      provider.login(context);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer),
                                  child: const Text("Sign in"),
                                ),
                              if (!provider.isAuthenticating)
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (ctx) => const AuthScreen()));
                                  },
                                  child: const Text(
                                    "Create an account.",
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
            ),
          );
        },
      ),
    );
  }
}
